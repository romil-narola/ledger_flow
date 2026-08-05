import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import '../../services/firebase_service.dart';
import '../app_database.dart';

/// Progress state during cloud restore.
class RestoreProgress {
  final String stage;
  final double progress;
  final bool isCompleted;
  final String? error;

  const RestoreProgress({
    required this.stage,
    required this.progress,
    this.isCompleted = false,
    this.error,
  });
}

/// Service to restore data from Cloud Firestore to local SQLite (Drift) upon app reinstallation or new device setup.
class FirebaseToLocalRestoreService {
  final AppDatabase _db;
  final FirebaseService _firebaseService;

  FirebaseToLocalRestoreService({
    required AppDatabase db,
    required FirebaseService firebaseService,
  })  : _db = db,
        _firebaseService = firebaseService;

  /// Restores all user documents from Cloud Firestore to the local SQLite database.
  Future<bool> restoreFromCloud({
    void Function(RestoreProgress)? onProgress,
  }) async {
    try {
      onProgress?.call(const RestoreProgress(
        stage: 'Checking Cloud Backup...',
        progress: 0.10,
      ));

      final user = await _firebaseService.ensureAuthenticated();
      final uid = user?.uid ?? _firebaseService.currentUserId;

      if (uid == null) {
        throw Exception('User authentication required to restore cloud backup.');
      }

      final firestore = _firebaseService.firestore;
      final userDoc = firestore.collection('users').doc(uid);

      // Phase 1: Restore Businesses
      onProgress?.call(const RestoreProgress(
        stage: 'Restoring Business Profiles...',
        progress: 0.25,
      ));
      final businessesSnap = await userDoc.collection('businesses').get();
      for (final doc in businessesSnap.docs) {
        final data = doc.data();
        await _db.into(_db.businesses).insertOnConflictUpdate(
              BusinessesCompanion.insert(
                id: Value(data['id'] as int),
                name: data['name'] as String,
                description: Value(data['description'] as String?),
                currencyCode: Value(data['currencyCode'] as String? ?? 'INR'),
                createdAt: Value(DateTime.parse(data['createdAt'] as String)),
                updatedAt: Value(DateTime.parse(data['updatedAt'] as String)),
              ),
            );
      }

      // Phase 2: Restore Wallets
      onProgress?.call(const RestoreProgress(
        stage: 'Restoring Wallet Accounts...',
        progress: 0.40,
      ));
      final walletsSnap = await userDoc.collection('wallet_accounts').get();
      for (final doc in walletsSnap.docs) {
        final data = doc.data();
        await _db.into(_db.walletAccounts).insertOnConflictUpdate(
              WalletAccountsCompanion.insert(
                id: Value(data['id'] as int),
                businessId: Value(data['businessId'] as int? ?? 1),
                name: data['name'] as String,
                openingBalance: Value((data['openingBalance'] as num).toDouble()),
                currentBalance: Value((data['currentBalance'] as num).toDouble()),
                notes: Value(data['notes'] as String?),
                isActive: Value(data['isActive'] as bool? ?? true),
                overdraftEnabled: Value(data['overdraftEnabled'] as bool? ?? false),
                createdAt: Value(DateTime.parse(data['createdAt'] as String)),
                updatedAt: Value(DateTime.parse(data['updatedAt'] as String)),
              ),
            );
      }

      // Phase 3: Restore Suppliers & Customers
      onProgress?.call(const RestoreProgress(
        stage: 'Restoring Suppliers & Customers...',
        progress: 0.60,
      ));
      final suppliersSnap = await userDoc.collection('suppliers').get();
      for (final doc in suppliersSnap.docs) {
        final data = doc.data();
        await _db.into(_db.suppliers).insertOnConflictUpdate(
              SuppliersCompanion.insert(
                id: Value(data['id'] as int),
                businessId: Value(data['businessId'] as int? ?? 1),
                name: data['name'] as String,
                phone: Value(data['phone'] as String?),
                email: Value(data['email'] as String?),
                address: Value(data['address'] as String?),
                totalPurchases: Value((data['totalPurchases'] as num).toDouble()),
                totalPayments: Value((data['totalPayments'] as num).toDouble()),
                outstanding: Value((data['outstanding'] as num).toDouble()),
                creditBalance: Value((data['creditBalance'] as num).toDouble()),
                isActive: Value(data['isActive'] as bool? ?? true),
                notes: Value(data['notes'] as String?),
                createdAt: Value(DateTime.parse(data['createdAt'] as String)),
                updatedAt: Value(DateTime.parse(data['updatedAt'] as String)),
              ),
            );
      }

      final customersSnap = await userDoc.collection('customers').get();
      for (final doc in customersSnap.docs) {
        final data = doc.data();
        await _db.into(_db.customers).insertOnConflictUpdate(
              CustomersCompanion.insert(
                id: Value(data['id'] as int),
                businessId: Value(data['businessId'] as int? ?? 1),
                name: data['name'] as String,
                phone: Value(data['phone'] as String?),
                email: Value(data['email'] as String?),
                address: Value(data['address'] as String?),
                totalSales: Value((data['totalSales'] as num).toDouble()),
                totalPayments: Value((data['totalPayments'] as num).toDouble()),
                outstanding: Value((data['outstanding'] as num).toDouble()),
                advanceBalance: Value((data['advanceBalance'] as num).toDouble()),
                isActive: Value(data['isActive'] as bool? ?? true),
                notes: Value(data['notes'] as String?),
                createdAt: Value(DateTime.parse(data['createdAt'] as String)),
                updatedAt: Value(DateTime.parse(data['updatedAt'] as String)),
              ),
            );
      }

      // Phase 4: Restore Expenses
      onProgress?.call(const RestoreProgress(
        stage: 'Restoring Expenses & Transactions...',
        progress: 0.80,
      ));
      final expenseCatSnap = await userDoc.collection('expense_categories').get();
      for (final doc in expenseCatSnap.docs) {
        final data = doc.data();
        await _db.into(_db.expenseCategories).insertOnConflictUpdate(
              ExpenseCategoriesCompanion.insert(
                id: Value(data['id'] as int),
                businessId: Value(data['businessId'] as int? ?? 1),
                name: data['name'] as String,
                iconCodepoint: Value(data['iconCodepoint'] as int? ?? 0xe0b0),
                colorHex: Value(data['colorHex'] as String? ?? '#6366F1'),
                monthlyBudget: Value(
                  data['monthlyBudget'] != null
                      ? (data['monthlyBudget'] as num).toDouble()
                      : null,
                ),
                isActive: Value(data['isActive'] as bool? ?? true),
                createdAt: Value(DateTime.parse(data['createdAt'] as String)),
              ),
            );
      }

      final expensesSnap = await userDoc.collection('expenses').get();
      for (final doc in expensesSnap.docs) {
        final data = doc.data();
        await _db.into(_db.expenses).insertOnConflictUpdate(
              ExpensesCompanion.insert(
                id: Value(data['id'] as int),
                businessId: Value(data['businessId'] as int? ?? 1),
                referenceNumber: data['referenceNumber'] as String,
                categoryId: data['categoryId'] as int,
                walletAccountId: Value(data['walletAccountId'] as int?),
                amount: (data['amount'] as num).toDouble(),
                description: data['description'] as String,
                notes: Value(data['notes'] as String?),
                date: DateTime.parse(data['date'] as String),
                createdAt: Value(DateTime.parse(data['createdAt'] as String)),
              ),
            );
      }

      onProgress?.call(const RestoreProgress(
        stage: 'Cloud Backup Restored Successfully!',
        progress: 1.0,
        isCompleted: true,
      ));

      debugPrint('[FirebaseToLocalRestoreService] Cloud restore completed cleanly.');
      return true;
    } catch (e) {
      debugPrint('[FirebaseToLocalRestoreService] Restore error: $e');
      onProgress?.call(RestoreProgress(
        stage: 'Failed to restore cloud backup.',
        progress: 0.0,
        isCompleted: false,
        error: e.toString(),
      ));
      return false;
    }
  }
}
