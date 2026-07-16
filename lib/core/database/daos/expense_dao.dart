import 'package:drift/drift.dart';
import '../app_database.dart';

import 'scoped_business_dao.dart';

part 'expense_dao.g.dart';

@DriftAccessor(tables: [ExpenseCategories, Expenses])
class ExpenseDao extends DatabaseAccessor<AppDatabase>
    with _$ExpenseDaoMixin, ScopedBusinessDao {
  ExpenseDao(super.db);

  // ─── Categories ───────────────────────────────────────────────────

  Future<List<ExpenseCategory>> getAllCategories() => (select(expenseCategories)
        ..where((c) => c.businessId.equals(currentBusinessId) & c.isActive.equals(true))
        ..orderBy([(c) => OrderingTerm.asc(c.name)]))
      .get();

  Future<int> insertCategory(ExpenseCategoriesCompanion companion) =>
      into(expenseCategories).insert(companion.copyWith(businessId: Value(currentBusinessId)));

  Future<bool> updateCategory(ExpenseCategoriesCompanion companion) =>
      update(expenseCategories).replace(companion);

  Future<int> deleteCategory(int id) =>
      (update(expenseCategories)..where((c) => c.id.equals(id) & c.businessId.equals(currentBusinessId)))
          .write(const ExpenseCategoriesCompanion(isActive: Value(false)));

  Future<ExpenseCategory?> getCategoryById(int id) =>
      (select(expenseCategories)..where((c) => c.id.equals(id) & c.businessId.equals(currentBusinessId)))
          .getSingleOrNull();

  // ─── Expenses ─────────────────────────────────────────────────────

  Future<int> insertExpense(ExpensesCompanion companion) =>
      into(expenses).insert(companion.copyWith(businessId: Value(currentBusinessId)));

  Future<int> deleteExpense(int id) =>
      (delete(expenses)..where((e) => e.id.equals(id) & e.businessId.equals(currentBusinessId))).go();

  Future<List<Expense>> getAllExpenses({DateTime? from, DateTime? to}) {
    final query = select(expenses)..orderBy([(e) => OrderingTerm.desc(e.date)]);
    if (from != null) {
      query.where((e) => e.businessId.equals(currentBusinessId) & e.date.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      query.where((e) => e.businessId.equals(currentBusinessId) & e.date.isSmallerOrEqualValue(to));
    }
    return query.get();
  }

  Future<List<Expense>> getExpensesByCategory(int categoryId,
      {DateTime? from, DateTime? to}) {
    final query = select(expenses)
      ..where((e) => e.categoryId.equals(categoryId) & e.businessId.equals(currentBusinessId))
      ..orderBy([(e) => OrderingTerm.desc(e.date)]);
    if (from != null) {
      query.where((e) => e.businessId.equals(currentBusinessId) & e.date.isBiggerOrEqualValue(from));
    }
    if (to != null) {
      query.where((e) => e.businessId.equals(currentBusinessId) & e.date.isSmallerOrEqualValue(to));
    }
    return query.get();
  }

  Future<Expense?> getExpenseById(int id) =>
      (select(expenses)..where((e) => e.id.equals(id) & e.businessId.equals(currentBusinessId))).getSingleOrNull();

  Future<double> getMonthlyExpenseTotal(DateTime month) async {
    final start = DateTime(month.year, month.month, 1);
    final end = DateTime(month.year, month.month + 1, 1);
    final rows = await (select(expenses)
          ..where((e) => e.businessId.equals(currentBusinessId) & e.date.isBiggerOrEqualValue(start))
          ..where((e) => e.businessId.equals(currentBusinessId) & e.date.isSmallerOrEqualValue(end)))
        .get();
    return rows.fold<double>(0.0, (sum, e) => sum + e.amount);
  }

  /// Returns a map of categoryId -> total spent for the given period
  Future<Map<int, double>> getCategoryTotals(
      {DateTime? from, DateTime? to}) async {
    final rows = await getAllExpenses(from: from, to: to);
    final Map<int, double> totals = {};
    for (final e in rows) {
      totals[e.categoryId] = (totals[e.categoryId] ?? 0.0) + e.amount;
    }
    return totals;
  }
}
