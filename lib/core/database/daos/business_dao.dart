import 'package:drift/drift.dart';
import '../app_database.dart';

part 'business_dao.g.dart';

@DriftAccessor(tables: [
  Businesses,
  WalletAccounts,
  Suppliers,
  Customers,
  Purchases,
  Sales,
  SupplierPayments,
  CustomerPayments,
  LedgerEntries,
  ExpenseCategories,
  Expenses,
])
class BusinessDao extends DatabaseAccessor<AppDatabase>
    with _$BusinessDaoMixin {
  BusinessDao(super.db);

  /// Get all businesses
  Future<List<Business>> getAllBusinesses() {
    return select(businesses).get();
  }

  /// Watch all businesses
  Stream<List<Business>> watchAllBusinesses() {
    return select(businesses).watch();
  }

  /// Get a business by ID
  Future<Business?> getBusinessById(int id) {
    return (select(businesses)..where((t) => t.id.equals(id)))
        .getSingleOrNull();
  }

  /// Create a new business
  Future<int> insertBusiness(BusinessesCompanion business) {
    return into(businesses).insert(business);
  }

  /// Update an existing business
  Future<bool> updateBusiness(BusinessesCompanion business) {
    return update(businesses).replace(business);
  }

  /// Delete a business and all its associated data
  Future<void> deleteBusinessWithData(int businessId) {
    return transaction(() async {
      await (delete(ledgerEntries)
            ..where((t) => t.businessId.equals(businessId)))
          .go();
      await (delete(expenses)..where((t) => t.businessId.equals(businessId)))
          .go();
      await (delete(expenseCategories)
            ..where((t) => t.businessId.equals(businessId)))
          .go();
      await (delete(purchases)..where((t) => t.businessId.equals(businessId)))
          .go();
      await (delete(sales)..where((t) => t.businessId.equals(businessId))).go();
      await (delete(supplierPayments)
            ..where((t) => t.businessId.equals(businessId)))
          .go();
      await (delete(customerPayments)
            ..where((t) => t.businessId.equals(businessId)))
          .go();
      await (delete(walletAccounts)
            ..where((t) => t.businessId.equals(businessId)))
          .go();
      await (delete(suppliers)..where((t) => t.businessId.equals(businessId)))
          .go();
      await (delete(customers)..where((t) => t.businessId.equals(businessId)))
          .go();

      // Finally delete the business
      await (delete(businesses)..where((t) => t.id.equals(businessId))).go();
    });
  }
}
