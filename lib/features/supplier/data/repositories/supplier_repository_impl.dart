import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/core.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/supplier_dao.dart';
import '../../../../core/database/daos/wallet_dao.dart';
import '../../../../core/database/daos/ledger_dao.dart';
import '../../supplier.dart';

const _uuid = Uuid();

/// Supplier repository implementation with full business logic:
/// - Auto credit application on purchases
/// - Outstanding tracking
/// - Ledger entry creation
class SupplierRepositoryImpl implements SupplierRepository {
  final SupplierDao _supplierDao;
  final WalletDao _walletDao;
  final LedgerDao _ledgerDao;
  final AppDatabase _db;

  SupplierRepositoryImpl({
    required SupplierDao supplierDao,
    required WalletDao walletDao,
    required LedgerDao ledgerDao,
    required AppDatabase db,
  })  : _supplierDao = supplierDao,
        _walletDao = walletDao,
        _ledgerDao = ledgerDao,
        _db = db;

  // ─── Mappers ────────────────────────────────────────────────────

  SupplierEntity _mapSupplier(Supplier s) => SupplierEntity(
        id: s.id,
        name: s.name,
        phone: s.phone,
        email: s.email,
        address: s.address,
        totalPurchases: s.totalPurchases,
        totalPayments: s.totalPayments,
        outstanding: s.outstanding,
        creditBalance: s.creditBalance,
        isActive: s.isActive,
        notes: s.notes,
        createdAt: s.createdAt,
        updatedAt: s.updatedAt,
      );

  // ─── Supplier CRUD ───────────────────────────────────────────────

  @override
  Future<List<SupplierEntity>> getSuppliers() async {
    final models = await _supplierDao.getAllSuppliers();
    return models.map(_mapSupplier).toList();
  }

  @override
  Stream<List<SupplierEntity>> watchSuppliers() {
    return _supplierDao.watchAllSuppliers().map(
          (models) => models.map(_mapSupplier).toList(),
        );
  }

  @override
  Future<SupplierEntity?> getSupplierById(int id) async {
    final s = await _supplierDao.getSupplierById(id);
    return s != null ? _mapSupplier(s) : null;
  }

  @override
  Future<int> addSupplier({
    required String name,
    String? phone,
    String? email,
    String? address,
    String? notes,
  }) {
    return _supplierDao.insertSupplier(SuppliersCompanion.insert(
      name: name,
      phone: Value(phone),
      email: Value(email),
      address: Value(address),
      notes: Value(notes),
    ));
  }

  @override
  Future<void> updateSupplier(SupplierEntity supplier) {
    return _supplierDao.updateSupplier(SuppliersCompanion(
      id: Value(supplier.id),
      name: Value(supplier.name),
      phone: Value(supplier.phone),
      email: Value(supplier.email),
      address: Value(supplier.address),
      notes: Value(supplier.notes),
      updatedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<void> deleteSupplier(int supplierId) =>
      _supplierDao.softDeleteSupplier(supplierId);

  // ─── Purchase Logic ──────────────────────────────────────────────
  /// Business Rule:
  ///   1. If supplier has credit, consume it first
  ///   2. Remaining amount adds to outstanding
  ///   3. Wallet balance UNCHANGED for purchases
  ///   4. Ledger entry created
  @override
  Future<int> addPurchase({
    required int supplierId,
    required int walletAccountId,
    required double amount,
    required DateTime date,
    String? notes,
    double? paidAmount,
  }) async {
    return _db.transaction(() async {
      // Get current supplier state
      final supplier = await _supplierDao.getSupplierById(supplierId);
      if (supplier == null) throw Exception('Supplier not found');

      final wallet = await _walletDao.getWalletById(walletAccountId);
      if (wallet == null) throw Exception('Wallet not found');

      // Apply supplier credit if available
      double creditApplied = 0.0;
      double netAmount = amount;
      double newCreditBalance = supplier.creditBalance;

      if (supplier.creditBalance > 0) {
        if (supplier.creditBalance >= amount) {
          // Full purchase covered by credit
          creditApplied = amount;
          newCreditBalance = supplier.creditBalance - amount;
          netAmount = 0;
        } else {
          // Partial credit applied
          creditApplied = supplier.creditBalance;
          netAmount = amount - supplier.creditBalance;
          newCreditBalance = 0;
        }
      }

      // New outstanding = previous outstanding + net amount after credit
      final newOutstanding = supplier.outstanding + netAmount;
      final newTotalPurchases = supplier.totalPurchases + amount;

      // Generate reference number
      final ref =
          '${AppConstants.purchasePrefix}${_uuid.v4().substring(0, 8).toUpperCase()}';

      // Insert purchase record
      final purchaseId =
          await _supplierDao.insertPurchase(PurchasesCompanion.insert(
        referenceNumber: ref,
        supplierId: supplierId,
        walletAccountId: walletAccountId,
        amount: amount,
        creditApplied: Value(creditApplied),
        netAmount: netAmount,
        notes: Value(notes),
        date: date,
      ));

      // Initialize values for potential payment
      double currentOutstanding = newOutstanding;
      double currentCreditBalance = newCreditBalance;
      double currentWalletBalance = wallet.currentBalance;
      double totalPayments = supplier.totalPayments;

      if (paidAmount != null && paidAmount > 0) {
        // Validate wallet balance (overdraft protection)
        if (!wallet.overdraftEnabled && wallet.currentBalance < paidAmount) {
          throw Exception(
            'Insufficient wallet balance for immediate payment. Available: ₹${wallet.currentBalance.toStringAsFixed(2)}, Required: ₹${paidAmount.toStringAsFixed(2)}',
          );
        }

        // Calculate outstanding settled and credit generated
        double outstandingSettled;
        double creditGenerated;

        if (paidAmount <= currentOutstanding) {
          outstandingSettled = paidAmount;
          creditGenerated = 0;
        } else {
          outstandingSettled = currentOutstanding;
          creditGenerated = paidAmount - currentOutstanding;
        }

        currentOutstanding = currentOutstanding - outstandingSettled;
        currentCreditBalance = currentCreditBalance + creditGenerated;
        totalPayments = totalPayments + paidAmount;
        currentWalletBalance = wallet.currentBalance - paidAmount;

        final payRef =
            '${AppConstants.supplierPaymentPrefix}${_uuid.v4().substring(0, 8).toUpperCase()}';

        // Insert payment record
        final paymentId = await _supplierDao.insertSupplierPayment(
          SupplierPaymentsCompanion.insert(
            referenceNumber: payRef,
            supplierId: supplierId,
            walletAccountId: walletAccountId,
            amount: paidAmount,
            outstandingSettled: Value(outstandingSettled),
            creditGenerated: Value(creditGenerated),
            notes: Value(notes != null
                ? 'Immediate payment for Purchase $ref. $notes'
                : 'Immediate payment for Purchase $ref'),
            date: date,
          ),
        );

        // Update wallet balance
        await _walletDao.updateBalance(walletAccountId, currentWalletBalance);

        // Create ledger entry for Payment
        await _ledgerDao.insertEntry(LedgerEntriesCompanion.insert(
          referenceNumber: payRef,
          transactionType: TransactionType.supplierPayment.name,
          walletAccountId: Value(walletAccountId),
          supplierId: Value(supplierId),
          relatedTransactionId: Value(paymentId),
          debit: const Value(0.0),
          credit: Value(paidAmount),
          walletBalance: Value(currentWalletBalance),
          description: creditGenerated > 0
              ? 'Payment to ${supplier.name} (Credit generated: ₹${creditGenerated.toStringAsFixed(2)})'
              : 'Payment to ${supplier.name} (Immediate purchase payment)',
          date: date,
        ));
      }

      // Update supplier totals (works for both unpaid and paid purchases)
      await _supplierDao.updateSupplierTotals(
        supplierId: supplierId,
        totalPurchases: newTotalPurchases,
        totalPayments: totalPayments,
        outstanding: currentOutstanding,
        creditBalance: currentCreditBalance,
      );

      // Create ledger entry for Purchase
      await _ledgerDao.insertEntry(LedgerEntriesCompanion.insert(
        referenceNumber: ref,
        transactionType: TransactionType.purchase.name,
        walletAccountId: Value(walletAccountId),
        supplierId: Value(supplierId),
        relatedTransactionId: Value(purchaseId),
        debit: Value(amount),
        credit: const Value(0.0),
        walletBalance:
            Value(wallet.currentBalance), // Original balance at purchase time
        description: creditApplied > 0
            ? 'Purchase from ${supplier.name} (Credit applied: ₹${creditApplied.toStringAsFixed(2)})'
            : 'Purchase from ${supplier.name}',
        date: date,
      ));

      return purchaseId;
    });
  }

  // ─── Payment Logic ───────────────────────────────────────────────
  /// Business Rule:
  ///   1. Wallet balance decreases by payment amount
  ///   2. Outstanding is reduced (up to 0)
  ///   3. If payment > outstanding → create supplier credit
  ///   4. Ledger entry created
  @override
  Future<int> addPayment({
    required int supplierId,
    required int walletAccountId,
    required double amount,
    required DateTime date,
    String? notes,
  }) async {
    return _db.transaction(() async {
      final supplier = await _supplierDao.getSupplierById(supplierId);
      if (supplier == null) throw Exception('Supplier not found');

      final wallet = await _walletDao.getWalletById(walletAccountId);
      if (wallet == null) throw Exception('Wallet not found');

      // Check wallet balance (overdraft protection)
      if (!wallet.overdraftEnabled && wallet.currentBalance < amount) {
        throw Exception(
          'Insufficient wallet balance. Available: ₹${wallet.currentBalance.toStringAsFixed(2)}, Required: ₹${amount.toStringAsFixed(2)}',
        );
      }

      // Calculate outstanding settled and credit generated
      double outstandingSettled;
      double creditGenerated;

      if (amount <= supplier.outstanding) {
        outstandingSettled = amount;
        creditGenerated = 0;
      } else {
        outstandingSettled = supplier.outstanding;
        creditGenerated = amount - supplier.outstanding;
      }

      final newOutstanding = supplier.outstanding - outstandingSettled;
      final newCreditBalance = supplier.creditBalance + creditGenerated;
      final newTotalPayments = supplier.totalPayments + amount;
      final newWalletBalance = wallet.currentBalance - amount;

      final ref =
          '${AppConstants.supplierPaymentPrefix}${_uuid.v4().substring(0, 8).toUpperCase()}';

      // Insert payment record
      final paymentId = await _supplierDao.insertSupplierPayment(
        SupplierPaymentsCompanion.insert(
          referenceNumber: ref,
          supplierId: supplierId,
          walletAccountId: walletAccountId,
          amount: amount,
          outstandingSettled: Value(outstandingSettled),
          creditGenerated: Value(creditGenerated),
          notes: Value(notes),
          date: date,
        ),
      );

      // Update supplier totals
      await _supplierDao.updateSupplierTotals(
        supplierId: supplierId,
        totalPurchases: supplier.totalPurchases,
        totalPayments: newTotalPayments,
        outstanding: newOutstanding,
        creditBalance: newCreditBalance,
      );

      // Update wallet balance
      await _walletDao.updateBalance(walletAccountId, newWalletBalance);

      // Create ledger entry (Credit - payment reduces wallet)
      await _ledgerDao.insertEntry(LedgerEntriesCompanion.insert(
        referenceNumber: ref,
        transactionType: TransactionType.supplierPayment.name,
        walletAccountId: Value(walletAccountId),
        supplierId: Value(supplierId),
        relatedTransactionId: Value(paymentId),
        debit: const Value(0.0),
        credit: Value(amount),
        walletBalance: Value(newWalletBalance),
        description: creditGenerated > 0
            ? 'Payment to ${supplier.name} (Credit generated: ₹${creditGenerated.toStringAsFixed(2)})'
            : 'Payment to ${supplier.name}',
        date: date,
      ));

      return paymentId;
    });
  }

  @override
  Future<List<PurchaseEntity>> getPurchasesBySupplier(int supplierId) async {
    final purchases = await _supplierDao.getPurchasesBySupplier(supplierId);
    final supplier = await _supplierDao.getSupplierById(supplierId);
    return purchases
        .map((p) => PurchaseEntity(
              id: p.id,
              referenceNumber: p.referenceNumber,
              supplierId: p.supplierId,
              supplierName: supplier?.name ?? '',
              walletAccountId: p.walletAccountId,
              walletName: '',
              amount: p.amount,
              creditApplied: p.creditApplied,
              netAmount: p.netAmount,
              notes: p.notes,
              date: p.date,
              createdAt: p.createdAt,
            ))
        .toList();
  }

  @override
  Future<List<PurchaseEntity>> getAllPurchases(
      {DateTime? from, DateTime? to}) async {
    final allPurchases = await _supplierDao.getAllPurchases(from: from, to: to);
    return allPurchases
        .map((p) => PurchaseEntity(
              id: p.id,
              referenceNumber: p.referenceNumber,
              supplierId: p.supplierId,
              supplierName: '',
              walletAccountId: p.walletAccountId,
              walletName: '',
              amount: p.amount,
              creditApplied: p.creditApplied,
              netAmount: p.netAmount,
              notes: p.notes,
              date: p.date,
              createdAt: p.createdAt,
            ))
        .toList();
  }

  @override
  Future<double> getMonthlyPurchases(DateTime month) =>
      _supplierDao.getMonthlyPurchases(month);

  @override
  Future<List<SupplierPaymentEntity>> getPaymentsBySupplier(
      int supplierId) async {
    final payments = await _supplierDao.getPaymentsBySupplier(supplierId);
    final supplier = await _supplierDao.getSupplierById(supplierId);
    return payments
        .map((p) => SupplierPaymentEntity(
              id: p.id,
              referenceNumber: p.referenceNumber,
              supplierId: p.supplierId,
              supplierName: supplier?.name ?? '',
              walletAccountId: p.walletAccountId,
              walletName: '',
              amount: p.amount,
              outstandingSettled: p.outstandingSettled,
              creditGenerated: p.creditGenerated,
              notes: p.notes,
              date: p.date,
              createdAt: p.createdAt,
            ))
        .toList();
  }

  @override
  Future<List<SupplierPaymentEntity>> getAllPayments(
      {DateTime? from, DateTime? to}) async {
    final payments =
        await _supplierDao.getAllSupplierPayments(from: from, to: to);
    return payments
        .map((p) => SupplierPaymentEntity(
              id: p.id,
              referenceNumber: p.referenceNumber,
              supplierId: p.supplierId,
              supplierName: '',
              walletAccountId: p.walletAccountId,
              walletName: '',
              amount: p.amount,
              outstandingSettled: p.outstandingSettled,
              creditGenerated: p.creditGenerated,
              notes: p.notes,
              date: p.date,
              createdAt: p.createdAt,
            ))
        .toList();
  }

  @override
  Future<List<SupplierLedgerEntry>> getSupplierLedger(int supplierId) async {
    final entries = await _ledgerDao.getSupplierLedger(supplierId);
    return entries
        .map((e) => SupplierLedgerEntry(
              id: e.id,
              referenceNumber: e.referenceNumber,
              transactionType: e.transactionType,
              debit: e.debit,
              credit: e.credit,
              balance: e.walletBalance,
              description: e.description,
              date: e.date,
            ))
        .toList();
  }

  @override
  Future<double> getTotalOutstanding() => _supplierDao.getTotalOutstanding();

  @override
  Future<double> getTotalCredit() => _supplierDao.getTotalCredit();

  @override
  Future<List<SupplierEntity>> getSuppliersWithOutstanding() async {
    final models = await _supplierDao.getSuppliersWithOutstanding();
    return models.map(_mapSupplier).toList();
  }

  @override
  Future<List<SupplierEntity>> getSuppliersWithCredit() async {
    final models = await _supplierDao.getSuppliersWithCredit();
    return models.map(_mapSupplier).toList();
  }
}
