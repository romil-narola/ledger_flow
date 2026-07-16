import 'package:drift/drift.dart';
import '../app_database.dart';

part 'customer_dao.g.dart';

/// Data Access Object for Customers
@DriftAccessor(tables: [Customers, Sales, CustomerPayments, LedgerEntries])
class CustomerDao extends DatabaseAccessor<AppDatabase>
    with _$CustomerDaoMixin {
  CustomerDao(super.db);

  // ─── Customer CRUD ────────────────────────────────────────────────

  Future<List<Customer>> getAllCustomers() {
    return (select(customers)
          ..where((c) => c.isActive.equals(true))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .get();
  }

  Stream<List<Customer>> watchAllCustomers() {
    return (select(customers)
          ..where((c) => c.isActive.equals(true))
          ..orderBy([(c) => OrderingTerm.asc(c.name)]))
        .watch();
  }

  Future<Customer?> getCustomerById(int id) {
    return (select(customers)..where((c) => c.id.equals(id))).getSingleOrNull();
  }

  Future<int> insertCustomer(CustomersCompanion customer) {
    return into(customers).insert(customer);
  }

  Future<bool> updateCustomer(CustomersCompanion customer) {
    return update(customers).replace(customer);
  }

  Future<void> softDeleteCustomer(int customerId) {
    return (update(customers)..where((c) => c.id.equals(customerId)))
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
    return (update(customers)..where((c) => c.id.equals(customerId)))
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
          ..where((s) => s.customerId.equals(customerId))
          ..orderBy([(s) => OrderingTerm.desc(s.date)]))
        .get();
  }

  Future<List<Sale>> getAllSales({DateTime? from, DateTime? to}) {
    final query = select(sales)..orderBy([(s) => OrderingTerm.desc(s.date)]);
    if (from != null) query.where((s) => s.date.isBiggerOrEqualValue(from));
    if (to != null) query.where((s) => s.date.isSmallerOrEqualValue(to));
    return query.get();
  }

  Future<int> insertSale(SalesCompanion sale) {
    return into(sales).insert(sale);
  }

  Future<double> getMonthySales(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 0, 23, 59, 59);
    final query = selectOnly(sales)
      ..addColumns([sales.amount.sum()])
      ..where(sales.date.isBiggerOrEqualValue(start) &
          sales.date.isSmallerOrEqualValue(end));
    final result = await query.getSingle();
    return result.read(sales.amount.sum()) ?? 0.0;
  }

  // ─── Customer Payment Operations ──────────────────────────────────

  Future<List<CustomerPayment>> getPaymentsByCustomer(int customerId) {
    return (select(customerPayments)
          ..where((p) => p.customerId.equals(customerId))
          ..orderBy([(p) => OrderingTerm.desc(p.date)]))
        .get();
  }

  Future<List<CustomerPayment>> getAllCustomerPayments(
      {DateTime? from, DateTime? to}) {
    final query = select(customerPayments)
      ..orderBy([(p) => OrderingTerm.desc(p.date)]);
    if (from != null) query.where((p) => p.date.isBiggerOrEqualValue(from));
    if (to != null) query.where((p) => p.date.isSmallerOrEqualValue(to));
    return query.get();
  }

  Future<int> insertCustomerPayment(CustomerPaymentsCompanion payment) {
    return into(customerPayments).insert(payment);
  }

  // ─── Summary Queries ──────────────────────────────────────────────

  Future<double> getTotalOutstanding() async {
    final query = selectOnly(customers)
      ..addColumns([customers.outstanding.sum()])
      ..where(customers.isActive.equals(true));
    final result = await query.getSingle();
    return result.read(customers.outstanding.sum()) ?? 0.0;
  }

  Future<double> getTotalAdvance() async {
    final query = selectOnly(customers)
      ..addColumns([customers.advanceBalance.sum()])
      ..where(customers.isActive.equals(true));
    final result = await query.getSingle();
    return result.read(customers.advanceBalance.sum()) ?? 0.0;
  }

  Future<List<Customer>> getCustomersWithOutstanding() {
    return (select(customers)
          ..where((c) =>
              c.isActive.equals(true) & c.outstanding.isBiggerThanValue(0))
          ..orderBy([(c) => OrderingTerm.desc(c.outstanding)]))
        .get();
  }

  Future<List<Customer>> getCustomersWithAdvance() {
    return (select(customers)
          ..where((c) =>
              c.isActive.equals(true) & c.advanceBalance.isBiggerThanValue(0))
          ..orderBy([(c) => OrderingTerm.desc(c.advanceBalance)]))
        .get();
  }
}
