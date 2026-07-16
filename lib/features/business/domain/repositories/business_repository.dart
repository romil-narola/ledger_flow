import '../../../../core/database/app_database.dart';

abstract class BusinessRepository {
  Future<List<Business>> getAllBusinesses();
  Stream<List<Business>> watchAllBusinesses();
  Future<Business?> getBusinessById(int id);
  Future<int> createBusiness({
    required String name,
    String? description,
    String? currencyCode,
  });
  Future<bool> updateBusiness(Business business);
  Future<void> deleteBusiness(int id);
}
