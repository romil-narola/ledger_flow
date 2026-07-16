import 'package:drift/drift.dart';
import '../app_database.dart';

import 'scoped_business_dao.dart';

part 'purchase_dao.g.dart';

/// Data Access Object for Purchases (also used in supplier repository)
@DriftAccessor(tables: [Purchases])
class PurchaseDao extends DatabaseAccessor<AppDatabase>
    with _$PurchaseDaoMixin, ScopedBusinessDao {
  PurchaseDao(super.db);

  Future<List<Purchase>> getAllPurchases({DateTime? from, DateTime? to}) {
    final query = select(purchases)
      ..where((t) => t.businessId.equals(currentBusinessId))
      ..orderBy([(p) => OrderingTerm.desc(p.date)]);
    if (from != null) query.where((p) => p.businessId.equals(currentBusinessId) & p.date.isBiggerOrEqualValue(from));
    if (to != null) query.where((p) => p.businessId.equals(currentBusinessId) & p.date.isSmallerOrEqualValue(to));
    return query.get();
  }

  Future<Purchase?> getPurchaseById(int id) {
    return (select(purchases)..where((p) => p.id.equals(id) & p.businessId.equals(currentBusinessId))).getSingleOrNull();
  }

  Future<int> insertPurchase(PurchasesCompanion purchase) {
    return into(purchases).insert(purchase.copyWith(businessId: Value(currentBusinessId)));
  }

  Future<void> deletePurchase(int id) {
    return (delete(purchases)..where((p) => p.id.equals(id) & p.businessId.equals(currentBusinessId))).go();
  }
}
