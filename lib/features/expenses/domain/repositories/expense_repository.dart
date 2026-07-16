import '../entities/expense_entities.dart';

abstract class ExpenseRepository {
  // ─── Categories ───────────────────────────────────────────────────
  Future<List<ExpenseCategoryEntity>> getCategories();
  Future<int> addCategory({
    required String name,
    required int iconCodepoint,
    required String colorHex,
    double? monthlyBudget,
  });
  Future<void> updateCategory(ExpenseCategoryEntity category);
  Future<void> deleteCategory(int categoryId);

  // ─── Expenses ─────────────────────────────────────────────────────
  Future<int> addExpense({
    required int categoryId,
    int? walletAccountId,
    required double amount,
    required String description,
    required DateTime date,
    String? notes,
  });
  Future<List<ExpenseEntity>> getAllExpenses({DateTime? from, DateTime? to});
  Future<List<ExpenseEntity>> getExpensesByCategory(int categoryId,
      {DateTime? from, DateTime? to});
  Future<void> deleteExpense(int expenseId);

  // ─── Summaries ────────────────────────────────────────────────────
  Future<double> getMonthlyTotal(DateTime month);
  Future<List<ExpenseCategorySummary>> getCategoryTotals(
      {DateTime? from, DateTime? to});
}
