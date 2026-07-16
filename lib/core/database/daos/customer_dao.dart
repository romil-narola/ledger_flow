import 'package:drift/drift.dart';
import '../app_database.dart';

import 'scoped_business_dao.dart';

part 'customer_dao.g.dart';

/// Data Access Object for Customers
@DriftAccessor(tables: [Customers, Sales, CustomerPayments, LedgerEntries])
class CustomerDao extends DatabaseAccessor<AppDatabase>
    with _$CustomerDaoMixin, ScopedBusinessDao {
  CustomerDao(super.db);

  // ─── Customer CRUD ────────────────────────────────────────────────

  Future<List<Customer>> getAllCustomers() {
    return (select(customers)
          ..where((c) =>
              c.businessId.equals(currentBusinessId) & c.isActive.equals(true))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .get();
  }

  Stream<List<Customer>> watchAllCustomers() {
    return (select(customers)
          ..where((c) =>
              c.businessId.equals(currentBusinessId) & c.isActive.equals(true))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .watch();
  }

  Future<Customer?> getCustomerById(int id) {
    return (select(customers)
          ..where(
              (c) => c.id.equals(id) & c.businessId.equals(currentBusinessId)))
        .getSingleOrNull();
  }

  Future<int> insertCustomer(CustomersCompanion customer) {
    return into(customers)
        .insert(customer.copyWith(businessId: Value(currentBusinessId)));
  }

  Future<bool> updateCustomer(CustomersCompanion customer) {
    return update(customers).replace(customer);
  }

  Future<void> softDeleteCustomer(int customerId) {
    return (update(customers)
          ..where((c) =>
              c.id.equals(customerId) & c.businessId.equals(currentBusinessId)))
        .write(CustomersCompanion(
      isActive: const Value(false),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Update customer financial totals after a transaction
  Future<void> updateCustomerTotals({
    required int customerId,
    required double totalSales,
    required double totalPayments,
    required double outstanding,
    required double advanceBalance,
  }) {
    return (update(customers)
          ..where((c) =>
              c.id.equals(customerId) & c.businessId.equals(currentBusinessId)))
        .write(CustomersCompanion(
      totalSales: Value(totalSales),
      totalPayments: Value(totalPayments),
      outstanding: Value(outstanding),
      advanceBalance: Value(advanceBalance),
      updatedAt: Value(DateTime.now()),
    ));
  }

  // ─── Sales Operations ─────────────────────────────────────────────

  Future<List<Sale>> getSalesByCustomer(int customerId) {
    return (select(sales)
          ..where((s) =>
              s.customerId.equals(customerId) &
              s.businessId.equals(currentBusinessId))
          ..orderBy([(s) => OrderingTerm.desc(s.date)]))
        .get();
  }

  Future<List<Sale>> getAllSales({DateTime? from, DateTime? to}) {
    final query = select(sales)..orderBy([(s) => OrderingTerm.desc(s.date)]);
    query.where((s) {
      Expression<bool> expr = s.businessId.equals(currentBusinessId);
      if (from != null) expr = expr & s.date.isBiggerOrEqualValue(from);
      if (to != null) expr = expr & s.date.isSmallerOrEqualValue(to);
      return expr;
    });
    return query.get();
  }

  Future<int> insertSale(SalesCompanion sale) {
    return into(sales)
        .insert(sale.copyWith(businessId: Value(currentBusinessId)));
  }

  Future<double> getMonthySales(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    final query = selectOnly(sales)
      ..addColumns([sales.amount.sum()])
      ..where(sales.date.isBiggerOrEqualValue(start) &
          sales.date.isSmallerOrEqualValue(end) &
          sales.businessId.equals(currentBusinessId));
    final result = await query.getSingle();
    return result.read(sales.amount.sum()) ?? 0.0;
  }

  // ─── Customer Payment Operations ──────────────────────────────────

  Future<List<CustomerPayment>> getPaymentsByCustomer(int customerId) {
    return (select(customerPayments)
          ..where((p) =>
              p.customerId.equals(customerId) &
              p.businessId.equals(currentBusinessId))
          ..orderBy([(p) => OrderingTerm.desc(p.date)]))
        .get();
  }

  Future<List<CustomerPayment>> getAllCustomerPayments(
      {DateTime? from, DateTime? to}) {
    final query = select(customerPayments)
      ..orderBy([(p) => OrderingTerm.desc(p.date)]);
    query.where((p) {
      Expression<bool> expr = p.businessId.equals(currentBusinessId);
      if (from != null) expr = expr & p.date.isBiggerOrEqualValue(from);
      if (to != null) expr = expr & p.date.isSmallerOrEqualValue(to);
      return expr;
    });
    return query.get();
  }

  Future<int> insertCustomerPayment(CustomerPaymentsCompanion payment) {
    return into(customerPayments)
        .insert(payment.copyWith(businessId: Value(currentBusinessId)));
  }

  // ─── Summary Queries ──────────────────────────────────────────────

  Future<double> getTotalOutstanding() async {
    final query = selectOnly(customers)
      ..addColumns([customers.outstanding.sum()])
      ..where(customers.isActive.equals(true) &
          customers.businessId.equals(currentBusinessId));
    final result = await query.getSingle();
    return result.read(customers.outstanding.sum()) ?? 0.0;
  }

  Future<double> getTotalAdvance() async {
    final query = selectOnly(customers)
      ..addColumns([customers.advanceBalance.sum()])
      ..where(customers.isActive.equals(true) &
          customers.businessId.equals(currentBusinessId));
    final result = await query.getSingle();
    return result.read(customers.advanceBalance.sum()) ?? 0.0;
  }

  Future<List<Customer>> getCustomersWithOutstanding() {
    return (select(customers)
          ..where((c) =>
              c.isActive.equals(true) &
              c.outstanding.isBiggerThanValue(0) &
              c.businessId.equals(currentBusinessId))
          ..orderBy([(c) => OrderingTerm.desc(c.outstanding)]))
        .get();
  }

  Future<List<Customer>> getCustomersWithAdvance() {
    return (select(customers)
          ..where((c) =>
              c.isActive.equals(true) &
              c.advanceBalance.isBiggerThanValue(0) &
              c.businessId.equals(currentBusinessId))
          ..orderBy([(c) => OrderingTerm.desc(c.advanceBalance)]))
        .get();
  }
}
