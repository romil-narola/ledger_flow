import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/business_dao.dart';
import '../../domain/repositories/business_repository.dart';

class BusinessRepositoryImpl implements BusinessRepository {
  final BusinessDao _businessDao;

  BusinessRepositoryImpl(this._businessDao);

  @override
  Future<List<Business>> getAllBusinesses() {
    return _businessDao.getAllBusinesses();
  }

  @override
  Stream<List<Business>> watchAllBusinesses() {
    return _businessDao.watchAllBusinesses();
  }

  @override
  Future<Business?> getBusinessById(int id) {
    return _businessDao.getBusinessById(id);
  }

  @override
  Future<int> createBusiness({
    required String name,
    String? description,
    String? currencyCode,
  }) {
    return _businessDao.insertBusiness(
      BusinessesCompanion.insert(
        name: name,
        description: Value(description),
        currencyCode: currencyCode != null ? Value(currencyCode) : const Value.absent(),
      ),
    );
  }

  @override
  Future<bool> updateBusiness(Business business) {
    return _businessDao.updateBusiness(
      BusinessesCompanion(
        id: Value(business.id),
        name: Value(business.name),
        description: Value(business.description),
        currencyCode: Value(business.currencyCode),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  @override
  Future<int> deleteBusiness(int id) {
    return _businessDao.deleteBusiness(id);
  }
}
