import '../entities/expense_entities.dart';
import '../repositories/expense_repository.dart';

// ─── Category Use Cases ───────────────────────────────────────────

class GetCategories {
  final ExpenseRepository repository;
  GetCategories(this.repository);
  Future<List<ExpenseCategoryEntity>> call() => repository.getCategories();
}

class AddCategory {
  final ExpenseRepository repository;
  AddCategory(this.repository);
  Future<int> call({
    required String name,
    required int iconCodepoint,
    required String colorHex,
    double? monthlyBudget,
  }) =>
      repository.addCategory(
        name: name,
        iconCodepoint: iconCodepoint,
        colorHex: colorHex,
        monthlyBudget: monthlyBudget,
      );
}

class UpdateCategory {
  final ExpenseRepository repository;
  UpdateCategory(this.repository);
  Future<void> call(ExpenseCategoryEntity category) =>
      repository.updateCategory(category);
}

class DeleteCategory {
  final ExpenseRepository repository;
  DeleteCategory(this.repository);
  Future<void> call(int categoryId) => repository.deleteCategory(categoryId);
}

// ─── Expense Use Cases ────────────────────────────────────────────

class AddExpense {
  final ExpenseRepository repository;
  AddExpense(this.repository);
  Future<int> call({
    required int categoryId,
    int? walletAccountId,
    required double amount,
    required String description,
    required DateTime date,
    String? notes,
  }) =>
      repository.addExpense(
        categoryId: categoryId,
        walletAccountId: walletAccountId,
        amount: amount,
        description: description,
        date: date,
        notes: notes,
      );
}

class GetAllExpenses {
  final ExpenseRepository repository;
  GetAllExpenses(this.repository);
  Future<List<ExpenseEntity>> call({DateTime? from, DateTime? to}) =>
      repository.getAllExpenses(from: from, to: to);
}

class GetExpensesByCategory {
  final ExpenseRepository repository;
  GetExpensesByCategory(this.repository);
  Future<List<ExpenseEntity>> call(int categoryId,
          {DateTime? from, DateTime? to}) =>
      repository.getExpensesByCategory(categoryId, from: from, to: to);
}

class DeleteExpense {
  final ExpenseRepository repository;
  DeleteExpense(this.repository);
  Future<void> call(int expenseId) => repository.deleteExpense(expenseId);
}

// ─── Summary Use Cases ────────────────────────────────────────────

class GetMonthlyExpenseTotal {
  final ExpenseRepository repository;
  GetMonthlyExpenseTotal(this.repository);
  Future<double> call(DateTime month) => repository.getMonthlyTotal(month);
}

class GetExpenseCategoryTotals {
  final ExpenseRepository repository;
  GetExpenseCategoryTotals(this.repository);
  Future<List<ExpenseCategorySummary>> call({DateTime? from, DateTime? to}) =>
      repository.getCategoryTotals(from: from, to: to);
}
