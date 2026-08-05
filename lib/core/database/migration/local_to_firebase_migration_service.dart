import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../services/firebase_service.dart';
import '../app_database.dart';

/// Data summary preview before performing migration.
class MigrationPreview {
  final int businessCount;
  final int walletCount;
  final int supplierCount;
  final int customerCount;
  final int transactionCount;
  final int expenseCount;
  final double totalWalletBalance;
  final double totalSupplierOutstanding;
  final double totalCustomerOutstanding;

  const MigrationPreview({
    required this.businessCount,
    required this.walletCount,
    required this.supplierCount,
    required this.customerCount,
    required this.transactionCount,
    required this.expenseCount,
    required this.totalWalletBalance,
    required this.totalSupplierOutstanding,
    required this.totalCustomerOutstanding,
  });

  int get totalRecords =>
      businessCount +
      walletCount +
      supplierCount +
      customerCount +
      transactionCount +
      expenseCount;
}

/// Migration status callback model.
class MigrationProgress {
  final String stage;
  final double progress; // 0.0 to 1.0
  final bool isCompleted;
  final String? error;

  const MigrationProgress({
    required this.stage,
    required this.progress,
    this.isCompleted = false,
    this.error,
  });
}

/// Service to handle zero-data-loss migration from local SQLite (Drift) to Cloud Firestore.
class LocalToFirebaseMigrationService {
  static const String _prefMigrationCompletedKey = 'firebase_migration_completed';
  static const String _prefMigrationTimestampKey = 'firebase_migration_timestamp';

  final AppDatabase _db;
  final FirebaseService _firebaseService;
  final SharedPreferences _prefs;

  LocalToFirebaseMigrationService({
    required AppDatabase db,
    required FirebaseService firebaseService,
    required SharedPreferences prefs,
  })  : _db = db,
        _firebaseService = firebaseService,
        _prefs = prefs;

  /// Checks if migration has already been successfully executed.
  bool isMigrationCompleted() {
    return _prefs.getBool(_prefMigrationCompletedKey) ?? false;
  }

  /// Calculates a pre-migration preview summary for user confirmation.
  Future<MigrationPreview> getMigrationPreview() async {
    final businesses = await _db.select(_db.businesses).get();
    final wallets = await _db.select(_db.walletAccounts).get();
    final suppliers = await _db.select(_db.suppliers).get();
    final customers = await _db.select(_db.customers).get();
    final purchases = await _db.select(_db.purchases).get();
    final sales = await _db.select(_db.sales).get();
    final supplierPayments = await _db.select(_db.supplierPayments).get();
    final customerPayments = await _db.select(_db.customerPayments).get();
    final expenses = await _db.select(_db.expenses).get();

    final totalWalletBalance = wallets.fold<double>(
      0.0,
      (acc, w) => acc + w.currentBalance,
    );
    final totalSupplierOutstanding = suppliers.fold<double>(
      0.0,
      (acc, s) => acc + s.outstanding,
    );
    final totalCustomerOutstanding = customers.fold<double>(
      0.0,
      (acc, c) => acc + c.outstanding,
    );

    final totalTxCount =
        purchases.length + sales.length + supplierPayments.length + customerPayments.length;

    return MigrationPreview(
      businessCount: businesses.length,
      walletCount: wallets.length,
      supplierCount: suppliers.length,
      customerCount: customers.length,
      transactionCount: totalTxCount,
      expenseCount: expenses.length,
      totalWalletBalance: totalWalletBalance,
      totalSupplierOutstanding: totalSupplierOutstanding,
      totalCustomerOutstanding: totalCustomerOutstanding,
    );
  }

  /// Executes data transfer from local Drift SQLite to Firebase Cloud Firestore.
  /// Emits progress via [onProgress].
  Future<bool> executeMigration({
    void Function(MigrationProgress)? onProgress,
  }) async {
    try {
      onProgress?.call(const MigrationProgress(
        stage: 'Initializing Firebase Authentication...',
        progress: 0.05,
      ));

      final user = await _firebaseService.ensureAuthenticated();
      final uid = user?.uid ?? _firebaseService.currentUserId;

      if (uid == null) {
        throw Exception('User authentication failed. Cannot proceed with cloud migration.');
      }

      final firestore = _firebaseService.firestore;
      final userDoc = firestore.collection('users').doc(uid);

      // Phase 1: Fetch all local entities
      onProgress?.call(const MigrationProgress(
        stage: 'Reading local database records...',
        progress: 0.15,
      ));

      final businesses = await _db.select(_db.businesses).get();
      final wallets = await _db.select(_db.walletAccounts).get();
      final suppliers = await _db.select(_db.suppliers).get();
      final customers = await _db.select(_db.customers).get();
      final purchases = await _db.select(_db.purchases).get();
      final sales = await _db.select(_db.sales).get();
      final supplierPayments = await _db.select(_db.supplierPayments).get();
      final customerPayments = await _db.select(_db.customerPayments).get();
      final expenseCategories = await _db.select(_db.expenseCategories).get();
      final expenses = await _db.select(_db.expenses).get();
      final ledgerEntries = await _db.select(_db.ledgerEntries).get();

      WriteBatch batch = firestore.batch();
      int batchCount = 0;

      Future<void> commitBatchIfNeeded() async {
        if (batchCount >= 450) {
          await batch.commit();
          batch = firestore.batch();
          batchCount = 0;
        }
      }

      // Phase 2: Migrate Businesses
      onProgress?.call(const MigrationProgress(
        stage: 'Migrating Business Profiles...',
        progress: 0.25,
      ));
      for (final b in businesses) {
        final docRef = userDoc.collection('businesses').doc(b.id.toString());
        batch.set(docRef, {
          'id': b.id,
          'name': b.name,
          'description': b.description,
          'currencyCode': b.currencyCode,
          'createdAt': b.createdAt.toIso8601String(),
          'updatedAt': b.updatedAt.toIso8601String(),
        });
        batchCount++;
        await commitBatchIfNeeded();
      }

      // Phase 3: Migrate Wallets
      onProgress?.call(const MigrationProgress(
        stage: 'Migrating Wallet Accounts...',
        progress: 0.35,
      ));
      for (final w in wallets) {
        final docRef = userDoc.collection('wallet_accounts').doc(w.id.toString());
        batch.set(docRef, {
          'id': w.id,
          'businessId': w.businessId,
          'name': w.name,
          'openingBalance': w.openingBalance,
          'currentBalance': w.currentBalance,
          'notes': w.notes,
          'isActive': w.isActive,
          'overdraftEnabled': w.overdraftEnabled,
          'createdAt': w.createdAt.toIso8601String(),
          'updatedAt': w.updatedAt.toIso8601String(),
        });
        batchCount++;
        await commitBatchIfNeeded();
      }

      // Phase 4: Migrate Suppliers & Customers
      onProgress?.call(const MigrationProgress(
        stage: 'Migrating Suppliers & Customers...',
        progress: 0.50,
      ));
      for (final s in suppliers) {
        final docRef = userDoc.collection('suppliers').doc(s.id.toString());
        batch.set(docRef, {
          'id': s.id,
          'businessId': s.businessId,
          'name': s.name,
          'phone': s.phone,
          'email': s.email,
          'address': s.address,
          'totalPurchases': s.totalPurchases,
          'totalPayments': s.totalPayments,
          'outstanding': s.outstanding,
          'creditBalance': s.creditBalance,
          'isActive': s.isActive,
          'notes': s.notes,
          'createdAt': s.createdAt.toIso8601String(),
          'updatedAt': s.updatedAt.toIso8601String(),
        });
        batchCount++;
        await commitBatchIfNeeded();
      }

      for (final c in customers) {
        final docRef = userDoc.collection('customers').doc(c.id.toString());
        batch.set(docRef, {
          'id': c.id,
          'businessId': c.businessId,
          'name': c.name,
          'phone': c.phone,
          'email': c.email,
          'address': c.address,
          'totalSales': c.totalSales,
          'totalPayments': c.totalPayments,
          'outstanding': c.outstanding,
          'advanceBalance': c.advanceBalance,
          'isActive': c.isActive,
          'notes': c.notes,
          'createdAt': c.createdAt.toIso8601String(),
          'updatedAt': c.updatedAt.toIso8601String(),
        });
        batchCount++;
        await commitBatchIfNeeded();
      }

      // Phase 5: Migrate Purchases, Sales, Payments
      onProgress?.call(const MigrationProgress(
        stage: 'Migrating Transactions & Ledger History...',
        progress: 0.70,
      ));
      for (final p in purchases) {
        final docRef = userDoc.collection('purchases').doc(p.id.toString());
        batch.set(docRef, {
          'id': p.id,
          'businessId': p.businessId,
          'referenceNumber': p.referenceNumber,
          'supplierId': p.supplierId,
          'walletAccountId': p.walletAccountId,
          'amount': p.amount,
          'creditApplied': p.creditApplied,
          'netAmount': p.netAmount,
          'notes': p.notes,
          'date': p.date.toIso8601String(),
          'createdAt': p.createdAt.toIso8601String(),
        });
        batchCount++;
        await commitBatchIfNeeded();
      }

      for (final s in sales) {
        final docRef = userDoc.collection('sales').doc(s.id.toString());
        batch.set(docRef, {
          'id': s.id,
          'businessId': s.businessId,
          'referenceNumber': s.referenceNumber,
          'customerId': s.customerId,
          'amount': s.amount,
          'advanceApplied': s.advanceApplied,
          'netAmount': s.netAmount,
          'notes': s.notes,
          'date': s.date.toIso8601String(),
          'createdAt': s.createdAt.toIso8601String(),
        });
        batchCount++;
        await commitBatchIfNeeded();
      }

      for (final sp in supplierPayments) {
        final docRef = userDoc.collection('supplier_payments').doc(sp.id.toString());
        batch.set(docRef, {
          'id': sp.id,
          'businessId': sp.businessId,
          'referenceNumber': sp.referenceNumber,
          'supplierId': sp.supplierId,
          'walletAccountId': sp.walletAccountId,
          'amount': sp.amount,
          'outstandingSettled': sp.outstandingSettled,
          'creditGenerated': sp.creditGenerated,
          'notes': sp.notes,
          'date': sp.date.toIso8601String(),
          'createdAt': sp.createdAt.toIso8601String(),
        });
        batchCount++;
        await commitBatchIfNeeded();
      }

      for (final cp in customerPayments) {
        final docRef = userDoc.collection('customer_payments').doc(cp.id.toString());
        batch.set(docRef, {
          'id': cp.id,
          'businessId': cp.businessId,
          'referenceNumber': cp.referenceNumber,
          'customerId': cp.customerId,
          'walletAccountId': cp.walletAccountId,
          'amount': cp.amount,
          'outstandingSettled': cp.outstandingSettled,
          'advanceGenerated': cp.advanceGenerated,
          'notes': cp.notes,
          'date': cp.date.toIso8601String(),
          'createdAt': cp.createdAt.toIso8601String(),
        });
        batchCount++;
        await commitBatchIfNeeded();
      }

      // Phase 6: Expenses & Ledger Entries
      onProgress?.call(const MigrationProgress(
        stage: 'Migrating Expenses & Ledger Entries...',
        progress: 0.85,
      ));
      for (final ec in expenseCategories) {
        final docRef = userDoc.collection('expense_categories').doc(ec.id.toString());
        batch.set(docRef, {
          'id': ec.id,
          'businessId': ec.businessId,
          'name': ec.name,
          'iconCodepoint': ec.iconCodepoint,
          'colorHex': ec.colorHex,
          'monthlyBudget': ec.monthlyBudget,
          'isActive': ec.isActive,
          'createdAt': ec.createdAt.toIso8601String(),
        });
        batchCount++;
        await commitBatchIfNeeded();
      }

      for (final e in expenses) {
        final docRef = userDoc.collection('expenses').doc(e.id.toString());
        batch.set(docRef, {
          'id': e.id,
          'businessId': e.businessId,
          'referenceNumber': e.referenceNumber,
          'categoryId': e.categoryId,
          'walletAccountId': e.walletAccountId,
          'amount': e.amount,
          'description': e.description,
          'notes': e.notes,
          'date': e.date.toIso8601String(),
          'createdAt': e.createdAt.toIso8601String(),
        });
        batchCount++;
        await commitBatchIfNeeded();
      }

      for (final l in ledgerEntries) {
        final docRef = userDoc.collection('ledger_entries').doc(l.id.toString());
        batch.set(docRef, {
          'id': l.id,
          'businessId': l.businessId,
          'referenceNumber': l.referenceNumber,
          'transactionType': l.transactionType,
          'walletAccountId': l.walletAccountId,
          'supplierId': l.supplierId,
          'customerId': l.customerId,
          'relatedTransactionId': l.relatedTransactionId,
          'debit': l.debit,
          'credit': l.credit,
          'walletBalance': l.walletBalance,
          'description': l.description,
          'date': l.date.toIso8601String(),
          'createdAt': l.createdAt.toIso8601String(),
        });
        batchCount++;
        await commitBatchIfNeeded();
      }

      // Final commit for remaining items
      if (batchCount > 0) {
        await batch.commit();
      }

      // Record migration success state
      await _prefs.setBool(_prefMigrationCompletedKey, true);
      await _prefs.setString(_prefMigrationTimestampKey, DateTime.now().toIso8601String());

      onProgress?.call(const MigrationProgress(
        stage: 'Migration completed successfully!',
        progress: 1.0,
        isCompleted: true,
      ));

      debugPrint('[LocalToFirebaseMigrationService] Migration finished cleanly.');
      return true;
    } catch (e) {
      debugPrint('[LocalToFirebaseMigrationService] Migration error: $e');
      onProgress?.call(MigrationProgress(
        stage: 'Migration encountered an error.',
        progress: 0.0,
        isCompleted: false,
        error: e.toString(),
      ));
      return false;
    }
  }
}
