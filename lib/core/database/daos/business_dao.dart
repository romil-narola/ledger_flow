import 'package:drift/drift.dart';
import '../app_database.dart';

part 'business_dao.g.dart';

@DriftAccessor(tables: [Businesses])
class BusinessDao extends DatabaseAccessor<AppDatabase> with _$BusinessDaoMixin {
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
    return (select(businesses)..where((t) => t.id.equals(id))).getSingleOrNull();
  }

  /// Create a new business
  Future<int> insertBusiness(BusinessesCompanion business) {
    return into(businesses).insert(business);
  }

  /// Update an existing business
  Future<bool> updateBusiness(BusinessesCompanion business) {
    return update(businesses).replace(business);
  }

  /// Delete a business
  Future<int> deleteBusiness(int id) {
    return (delete(businesses)..where((t) => t.id.equals(id))).go();
  }
}
