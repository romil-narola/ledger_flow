import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/core.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/customer_dao.dart';
import '../../../../core/database/daos/wallet_dao.dart';
import '../../../../core/database/daos/ledger_dao.dart';
import '../../customer.dart';

const _uuid = Uuid();

class CustomerRepositoryImpl implements CustomerRepository {
  final CustomerDao _customerDao;
  final WalletDao _walletDao;
  final LedgerDao _ledgerDao;
  final AppDatabase _db;

  CustomerRepositoryImpl({
    required CustomerDao customerDao,
    required WalletDao walletDao,
    required LedgerDao ledgerDao,
    required AppDatabase db,
  })  : _customerDao = customerDao,
        _walletDao = walletDao,
        _ledgerDao = ledgerDao,
        _db = db;

  CustomerEntity _mapCustomer(Customer c) => CustomerEntity(
        id: c.id,
        name: c.name,
        phone: c.phone,
        email: c.email,
        address: c.address,
        totalSales: c.totalSales,
        totalPayments: c.totalPayments,
        outstanding: c.outstanding,
        advanceBalance: c.advanceBalance,
        isActive: c.isActive,
        notes: c.notes,
        createdAt: c.createdAt,
        updatedAt: c.updatedAt,
      );

  // ─── Customer CRUD ───────────────────────────────────────────────

  @override
  Future<List<CustomerEntity>> getCustomers() async {
    final models = await _customerDao.getAllCustomers();
    return models.map(_mapCustomer).toList();
  }

  @override
  Stream<List<CustomerEntity>> watchCustomers() {
    return _customerDao.watchAllCustomers().map(
          (models) => models.map(_mapCustomer).toList(),
        );
  }

  @override
  Future<CustomerEntity?> getCustomerById(int id) async {
    final c = await _customerDao.getCustomerById(id);
    return c != null ? _mapCustomer(c) : null;
  }

  @override
  Future<int> addCustomer({
    required String name,
    String? phone,
    String? email,
    String? address,
    String? notes,
  }) {
    return _customerDao.insertCustomer(CustomersCompanion.insert(
      name: name,
      phone: Value(phone),
      email: Value(email),
      address: Value(address),
      notes: Value(notes),
    ));
  }

  @override
  Future<void> updateCustomer(CustomerEntity customer) {
    return _customerDao.updateCustomer(CustomersCompanion(
      id: Value(customer.id),
      name: Value(customer.name),
      phone: Value(customer.phone),
      email: Value(customer.email),
      address: Value(customer.address),
      notes: Value(customer.notes),
      updatedAt: Value(DateTime.now()),
    ));
  }

  @override
  Future<void> deleteCustomer(int customerId) =>
      _customerDao.softDeleteCustomer(customerId);

  // ─── Sale Logic ───────────────────────────────────────────────────
  /// Business Rule:
  ///   1. If customer has advance balance, consume it first
  ///   2. Remaining adds to outstanding
  ///   3. Ledger entry created
  @override
  Future<int> addSale({
    required int customerId,
    required double amount,
    required DateTime date,
    String? notes,
    int? walletAccountId,
    double? paidAmount,
  }) async {
    return _db.transaction(() async {
      final customer = await _customerDao.getCustomerById(customerId);
      if (customer == null) throw Exception('Customer not found');

      // Apply advance if available
      double advanceApplied = 0.0;
      double netAmount = amount;
      double newAdvanceBalance = customer.advanceBalance;

      if (customer.advanceBalance > 0) {
        if (customer.advanceBalance >= amount) {
          advanceApplied = amount;
          newAdvanceBalance = customer.advanceBalance - amount;
          netAmount = 0;
        } else {
          advanceApplied = customer.advanceBalance;
          netAmount = amount - customer.advanceBalance;
          newAdvanceBalance = 0;
        }
      }

      final newOutstanding = customer.outstanding + netAmount;
      final newTotalSales = customer.totalSales + amount;

      final ref =
          '${AppConstants.salePrefix}${_uuid.v4().substring(0, 8).toUpperCase()}';

      // Insert sale
      final saleId = await _customerDao.insertSale(SalesCompanion.insert(
        referenceNumber: ref,
        customerId: customerId,
        amount: amount,
        advanceApplied: Value(advanceApplied),
        netAmount: netAmount,
        notes: Value(notes),
        date: date,
      ));

      // Initialize values for potential payment
      double currentOutstanding = newOutstanding;
      double currentAdvanceBalance = newAdvanceBalance;
      double totalPayments = customer.totalPayments;

      if (paidAmount != null && paidAmount > 0 && walletAccountId != null) {
        final wallet = await _walletDao.getWalletById(walletAccountId);
        if (wallet == null) throw Exception('Wallet not found');

        double outstandingSettled;
        double advanceGenerated;

        if (paidAmount <= currentOutstanding) {
          outstandingSettled = paidAmount;
          advanceGenerated = 0;
        } else {
          outstandingSettled = currentOutstanding;
          advanceGenerated = paidAmount - currentOutstanding;
        }

        currentOutstanding = currentOutstanding - outstandingSettled;
        currentAdvanceBalance = currentAdvanceBalance + advanceGenerated;
        totalPayments = totalPayments + paidAmount;
        final newWalletBalance = wallet.currentBalance + paidAmount;

        final payRef =
            '${AppConstants.customerPaymentPrefix}${_uuid.v4().substring(0, 8).toUpperCase()}';

        // Insert payment record
        final paymentId = await _customerDao.insertCustomerPayment(
          CustomerPaymentsCompanion.insert(
            referenceNumber: payRef,
            customerId: customerId,
            walletAccountId: walletAccountId,
            amount: paidAmount,
            outstandingSettled: Value(outstandingSettled),
            advanceGenerated: Value(advanceGenerated),
            notes: Value(notes != null
                ? 'Immediate payment for Sale $ref. $notes'
                : 'Immediate payment for Sale $ref'),
            date: date,
          ),
        );

        // Update wallet balance
        await _walletDao.updateBalance(walletAccountId, newWalletBalance);

        // Create ledger entry for Payment
        await _ledgerDao.insertEntry(LedgerEntriesCompanion.insert(
          referenceNumber: payRef,
          transactionType: TransactionType.customerPayment.name,
          walletAccountId: Value(walletAccountId),
          customerId: Value(customerId),
          relatedTransactionId: Value(paymentId),
          debit: Value(paidAmount),
          credit: const Value(0.0),
          walletBalance: Value(newWalletBalance),
          description: advanceGenerated > 0
              ? 'Payment from ${customer.name} (Advance generated: ₹${advanceGenerated.toStringAsFixed(2)})'
              : 'Payment from ${customer.name} (Immediate sales payment)',
          date: date,
        ));
      }

      // Update customer totals
      await _customerDao.updateCustomerTotals(
        customerId: customerId,
        totalSales: newTotalSales,
        totalPayments: totalPayments,
        outstanding: currentOutstanding,
        advanceBalance: currentAdvanceBalance,
      );

      // Ledger entry for Sale
      await _ledgerDao.insertEntry(LedgerEntriesCompanion.insert(
        referenceNumber: ref,
        transactionType: TransactionType.sale.name,
        customerId: Value(customerId),
        relatedTransactionId: Value(saleId),
        debit: const Value(0.0),
        credit: Value(amount),
        walletBalance: const Value(0.0), // No wallet involved directly in sale
        description: advanceApplied > 0
            ? 'Sale to ${customer.name} (Advance applied: ₹${advanceApplied.toStringAsFixed(2)})'
            : 'Sale to ${customer.name}',
        date: date,
      ));

      return saleId;
    });
  }

  // ─── Payment Logic ───────────────────────────────────────────────
  /// Business Rule:
  ///   1. Wallet balance increases by payment amount
  ///   2. Outstanding reduced (up to 0)
  ///   3. Excess creates customer advance
  ///   4. Ledger entry created
  @override
  Future<int> addPayment({
    required int customerId,
    required int walletAccountId,
    required double amount,
    required DateTime date,
    String? notes,
  }) async {
    return _db.transaction(() async {
      final customer = await _customerDao.getCustomerById(customerId);
      if (customer == null) throw Exception('Customer not found');

      final wallet = await _walletDao.getWalletById(walletAccountId);
      if (wallet == null) throw Exception('Wallet not found');

      double outstandingSettled;
      double advanceGenerated;

      if (amount <= customer.outstanding) {
        outstandingSettled = amount;
        advanceGenerated = 0;
      } else {
        outstandingSettled = customer.outstanding;
        advanceGenerated = amount - customer.outstanding;
      }

      final newOutstanding = customer.outstanding - outstandingSettled;
      final newAdvanceBalance = customer.advanceBalance + advanceGenerated;
      final newTotalPayments = customer.totalPayments + amount;
      final newWalletBalance =
          wallet.currentBalance + amount; // Wallet INCREASES

      final ref =
          '${AppConstants.customerPaymentPrefix}${_uuid.v4().substring(0, 8).toUpperCase()}';

      // Insert payment
      final paymentId = await _customerDao.insertCustomerPayment(
        CustomerPaymentsCompanion.insert(
          referenceNumber: ref,
          customerId: customerId,
          walletAccountId: walletAccountId,
          amount: amount,
          outstandingSettled: Value(outstandingSettled),
          advanceGenerated: Value(advanceGenerated),
          notes: Value(notes),
          date: date,
        ),
      );

      // Update customer totals
      await _customerDao.updateCustomerTotals(
        customerId: customerId,
        totalSales: customer.totalSales,
        totalPayments: newTotalPayments,
        outstanding: newOutstanding,
        advanceBalance: newAdvanceBalance,
      );

      // Update wallet balance
      await _walletDao.updateBalance(walletAccountId, newWalletBalance);

      // Ledger entry
      await _ledgerDao.insertEntry(LedgerEntriesCompanion.insert(
        referenceNumber: ref,
        transactionType: TransactionType.customerPayment.name,
        walletAccountId: Value(walletAccountId),
        customerId: Value(customerId),
        relatedTransactionId: Value(paymentId),
        debit: Value(amount),
        credit: const Value(0.0),
        walletBalance: Value(newWalletBalance),
        description: advanceGenerated > 0
            ? 'Payment from ${customer.name} (Advance created: ₹${advanceGenerated.toStringAsFixed(2)})'
            : 'Payment from ${customer.name}',
        date: date,
      ));

      return paymentId;
    });
  }

  @override
  Future<List<SaleEntity>> getSalesByCustomer(int customerId) async {
    final salesList = await _customerDao.getSalesByCustomer(customerId);
    final customer = await _customerDao.getCustomerById(customerId);
    return salesList
        .map((s) => SaleEntity(
              id: s.id,
              referenceNumber: s.referenceNumber,
              customerId: s.customerId,
              customerName: customer?.name ?? '',
              amount: s.amount,
              advanceApplied: s.advanceApplied,
              netAmount: s.netAmount,
              notes: s.notes,
              date: s.date,
              createdAt: s.createdAt,
            ))
        .toList();
  }

  @override
  Future<List<SaleEntity>> getAllSales({DateTime? from, DateTime? to}) async {
    final allSales = await _customerDao.getAllSales(from: from, to: to);
    return allSales
        .map((s) => SaleEntity(
              id: s.id,
              referenceNumber: s.referenceNumber,
              customerId: s.customerId,
              customerName: '',
              amount: s.amount,
              advanceApplied: s.advanceApplied,
              netAmount: s.netAmount,
              notes: s.notes,
              date: s.date,
              createdAt: s.createdAt,
            ))
        .toList();
  }

  @override
  Future<double> getMonthlySales(DateTime month) =>
      _customerDao.getMonthySales(month);

  @override
  Future<List<CustomerPaymentEntity>> getPaymentsByCustomer(
      int customerId) async {
    final payments = await _customerDao.getPaymentsByCustomer(customerId);
    final customer = await _customerDao.getCustomerById(customerId);
    return payments
        .map((p) => CustomerPaymentEntity(
              id: p.id,
              referenceNumber: p.referenceNumber,
              customerId: p.customerId,
              customerName: customer?.name ?? '',
              walletAccountId: p.walletAccountId,
              walletName: '',
              amount: p.amount,
              outstandingSettled: p.outstandingSettled,
              advanceGenerated: p.advanceGenerated,
              notes: p.notes,
              date: p.date,
              createdAt: p.createdAt,
            ))
        .toList();
  }

  @override
  Future<List<CustomerPaymentEntity>> getAllPayments(
      {DateTime? from, DateTime? to}) async {
    final payments =
        await _customerDao.getAllCustomerPayments(from: from, to: to);
    return payments
        .map((p) => CustomerPaymentEntity(
              id: p.id,
              referenceNumber: p.referenceNumber,
              customerId: p.customerId,
              customerName: '',
              walletAccountId: p.walletAccountId,
              walletName: '',
              amount: p.amount,
              outstandingSettled: p.outstandingSettled,
              advanceGenerated: p.advanceGenerated,
              notes: p.notes,
              date: p.date,
              createdAt: p.createdAt,
            ))
        .toList();
  }

  @override
  Future<List<CustomerLedgerEntry>> getCustomerLedger(int customerId) async {
    final entries = await _ledgerDao.getCustomerLedger(customerId);
    return entries
        .map((e) => CustomerLedgerEntry(
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
  Future<double> getTotalOutstanding() => _customerDao.getTotalOutstanding();

  @override
  Future<double> getTotalAdvance() => _customerDao.getTotalAdvance();

  @override
  Future<List<CustomerEntity>> getCustomersWithOutstanding() async {
    final models = await _customerDao.getCustomersWithOutstanding();
    return models.map(_mapCustomer).toList();
  }

  @override
  Future<List<CustomerEntity>> getCustomersWithAdvance() async {
    final models = await _customerDao.getCustomersWithAdvance();
    return models.map(_mapCustomer).toList();
  }
}
