import 'package:drift/drift.dart';
import '../app_database.dart';

import 'scoped_business_dao.dart';

part 'sales_dao.g.dart';

/// Data Access Object for Sales
@DriftAccessor(tables: [Sales])
class SalesDao extends DatabaseAccessor<AppDatabase>
    with _$SalesDaoMixin, ScopedBusinessDao {
  SalesDao(super.db);

  Future<List<Sale>> getAllSales({DateTime? from, DateTime? to}) {
    final query = select(sales)..orderBy([(s) => OrderingTerm.desc(s.date)]);
    if (from != null) query.where((s) => s.businessId.equals(currentBusinessId) & s.date.isBiggerOrEqualValue(from));
    if (to != null) query.where((s) => s.businessId.equals(currentBusinessId) & s.date.isSmallerOrEqualValue(to));
    return query.get();
  }

  Future<Sale?> getSaleById(int id) {
    return (select(sales)..where((s) => s.id.equals(id) & s.businessId.equals(currentBusinessId))).getSingleOrNull();
  }

  Future<int> insertSale(SalesCompanion sale) {
    return into(sales).insert(sale.copyWith(businessId: Value(currentBusinessId)));
  }

  Future<void> deleteSale(int id) {
    return (delete(sales)..where((s) => s.id.equals(id) & s.businessId.equals(currentBusinessId))).go();
  }
}
