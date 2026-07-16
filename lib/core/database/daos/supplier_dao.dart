import 'package:drift/drift.dart';
import '../app_database.dart';

import 'scoped_business_dao.dart';

part 'supplier_dao.g.dart';

/// Data Access Object for Suppliers
@DriftAccessor(tables: [Suppliers, Purchases, SupplierPayments, LedgerEntries])
class SupplierDao extends DatabaseAccessor<AppDatabase>
    with _$SupplierDaoMixin, ScopedBusinessDao {
  SupplierDao(super.db);

  // ─── Supplier CRUD ───────────────────────────────────────────────

  Future<List<Supplier>> getAllSuppliers() {
    return (select(suppliers)
          ..where((s) =>
              s.businessId.equals(currentBusinessId) & s.isActive.equals(true))
          ..orderBy([(s) => OrderingTerm.asc(s.name)]))
        .get();
  }

  Stream<List<Supplier>> watchAllSuppliers() {
    return (select(suppliers)
          ..where((s) =>
              s.businessId.equals(currentBusinessId) & s.isActive.equals(true))
          ..orderBy([(s) => OrderingTerm.asc(s.name)]))
        .watch();
  }

  Future<Supplier?> getSupplierById(int id) {
    return (select(suppliers)
          ..where(
              (s) => s.id.equals(id) & s.businessId.equals(currentBusinessId)))
        .getSingleOrNull();
  }

  Future<int> insertSupplier(SuppliersCompanion supplier) {
    return into(suppliers)
        .insert(supplier.copyWith(businessId: Value(currentBusinessId)));
  }

  Future<bool> updateSupplier(SuppliersCompanion supplier) {
    return update(suppliers).replace(supplier);
  }

  Future<void> softDeleteSupplier(int supplierId) {
    return (update(suppliers)
          ..where((s) =>
              s.id.equals(supplierId) & s.businessId.equals(currentBusinessId)))
        .write(SuppliersCompanion(
      isActive: const Value(false),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Update supplier financial totals after a transaction
  Future<void> updateSupplierTotals({
    required int supplierId,
    required double totalPurchases,
    required double totalPayments,
    required double outstanding,
    required double creditBalance,
  }) {
    return (update(suppliers)
          ..where((s) =>
              s.id.equals(supplierId) & s.businessId.equals(currentBusinessId)))
        .write(SuppliersCompanion(
      totalPurchases: Value(totalPurchases),
      totalPayments: Value(totalPayments),
      outstanding: Value(outstanding),
      creditBalance: Value(creditBalance),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // ─── Purchase Operations ─────────────────────────────────────────

  Future<List<Purchase>> getPurchasesBySupplier(int supplierId) {
    return (select(purchases)
          ..where((p) =>
              p.supplierId.equals(supplierId) &
              p.businessId.equals(currentBusinessId))
          ..orderBy([(p) => OrderingTerm.desc(p.date)]))
        .get();
  }

  Future<List<Purchase>> getAllPurchases({DateTime? from, DateTime? to}) {
    final query = select(purchases)
      ..orderBy([(p) => OrderingTerm.desc(p.date)]);
    query.where((p) {
      Expression<bool> expr = p.businessId.equals(currentBusinessId);
      if (from != null) expr = expr & p.date.isBiggerOrEqualValue(from);
      if (to != null) expr = expr & p.date.isSmallerOrEqualValue(to);
      return expr;
    });
    return query.get();
  }

  Future<int> insertPurchase(PurchasesCompanion purchase) {
    return into(purchases)
        .insert(purchase.copyWith(businessId: Value(currentBusinessId)));
  }

  Future<double> getTotalPurchasesForSupplier(int supplierId) async {
    final query = selectOnly(purchases)
      ..addColumns([purchases.amount.sum()])
      ..where(purchases.supplierId.equals(supplierId) &
          purchases.businessId.equals(currentBusinessId));
    final result = await query.getSingle();
    return result.read(purchases.amount.sum()) ?? 0.0;
  }

  Future<double> getMonthlyPurchases(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    final query = selectOnly(purchases)
      ..addColumns([purchases.amount.sum()])
      ..where(purchases.date.isBiggerOrEqualValue(start) &
          purchases.date.isSmallerOrEqualValue(end) &
          purchases.businessId.equals(currentBusinessId));
    final result = await query.getSingle();
    return result.read(purchases.amount.sum()) ?? 0.0;
  }

  // ─── Supplier Payment Operations ─────────────────────────────────

  Future<List<SupplierPayment>> getPaymentsBySupplier(int supplierId) {
    return (select(supplierPayments)
          ..where((p) =>
              p.supplierId.equals(supplierId) &
              p.businessId.equals(currentBusinessId))
          ..orderBy([(p) => OrderingTerm.desc(p.date)]))
        .get();
  }

  Future<List<SupplierPayment>> getAllSupplierPayments(
      {DateTime? from, DateTime? to}) {
    final query = select(supplierPayments)
      ..orderBy([(p) => OrderingTerm.desc(p.date)]);
    query.where((p) {
      Expression<bool> expr = p.businessId.equals(currentBusinessId);
      if (from != null) expr = expr & p.date.isBiggerOrEqualValue(from);
      if (to != null) expr = expr & p.date.isSmallerOrEqualValue(to);
      return expr;
    });
    return query.get();
  }

  Future<int> insertSupplierPayment(SupplierPaymentsCompanion payment) {
    return into(supplierPayments)
        .insert(payment.copyWith(businessId: Value(currentBusinessId)));
  }

  Future<double> getTotalPaymentsForSupplier(int supplierId) async {
    final query = selectOnly(supplierPayments)
      ..addColumns([supplierPayments.amount.sum()])
      ..where(supplierPayments.supplierId.equals(supplierId) &
          supplierPayments.businessId.equals(currentBusinessId));
    final result = await query.getSingle();
    return result.read(supplierPayments.amount.sum()) ?? 0.0;
  }

  // ─── Summary Queries ──────────────────────────────────────────────

  Future<double> getTotalOutstanding() async {
    final query = selectOnly(suppliers)
      ..addColumns([suppliers.outstanding.sum()])
      ..where(suppliers.isActive.equals(true) &
          suppliers.businessId.equals(currentBusinessId));
    final result = await query.getSingle();
    return result.read(suppliers.outstanding.sum()) ?? 0.0;
  }

  Future<double> getTotalCredit() async {
    final query = selectOnly(suppliers)
      ..addColumns([suppliers.creditBalance.sum()])
      ..where(suppliers.isActive.equals(true) &
          suppliers.businessId.equals(currentBusinessId));
    final result = await query.getSingle();
    return result.read(suppliers.creditBalance.sum()) ?? 0.0;
  }

  Future<List<Supplier>> getSuppliersWithOutstanding() {
    return (select(suppliers)
          ..where((s) =>
              s.isActive.equals(true) &
              s.outstanding.isBiggerThanValue(0) &
              s.businessId.equals(currentBusinessId))
          ..orderBy([(s) => OrderingTerm.desc(s.outstanding)]))
        .get();
  }

  Future<List<Supplier>> getSuppliersWithCredit() {
    return (select(suppliers)
          ..where((s) =>
              s.isActive.equals(true) &
              s.creditBalance.isBiggerThanValue(0) &
              s.businessId.equals(currentBusinessId))
          ..orderBy([(s) => OrderingTerm.desc(s.creditBalance)]))
        .get();
  }
}
