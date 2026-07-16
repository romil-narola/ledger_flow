import 'package:equatable/equatable.dart';
import '../../domain/entities/expense_entities.dart';

// ═══════════════════════════════════════════════════════════════════
// EVENTS
// ═══════════════════════════════════════════════════════════════════

abstract class ExpenseEvent extends Equatable {
  const ExpenseEvent();
  @override
  List<Object?> get props => [];
}

class LoadExpenses extends ExpenseEvent {
  final DateTime? from;
  final DateTime? to;
  const LoadExpenses({this.from, this.to});
  @override
  List<Object?> get props => [from, to];
}

class LoadCategories extends ExpenseEvent {
  const LoadCategories();
}

class AddExpenseRequested extends ExpenseEvent {
  final int categoryId;
  final int? walletAccountId;
  final double amount;
  final String description;
  final DateTime date;
  final String? notes;
  const AddExpenseRequested({
    required this.categoryId,
    this.walletAccountId,
    required this.amount,
    required this.description,
    required this.date,
    this.notes,
  });
  @override
  List<Object?> get props => [categoryId, amount, description, date];
}

class DeleteExpenseRequested extends ExpenseEvent {
  final int expenseId;
  const DeleteExpenseRequested(this.expenseId);
  @override
  List<Object?> get props => [expenseId];
}

class AddCategoryRequested extends ExpenseEvent {
  final String name;
  final int iconCodepoint;
  final String colorHex;
  final double? monthlyBudget;
  const AddCategoryRequested({
    required this.name,
    required this.iconCodepoint,
    required this.colorHex,
    this.monthlyBudget,
  });
  @override
  List<Object?> get props => [name, iconCodepoint, colorHex];
}

class UpdateCategoryRequested extends ExpenseEvent {
  final ExpenseCategoryEntity category;
  const UpdateCategoryRequested(this.category);
  @override
  List<Object?> get props => [category];
}

class DeleteCategoryRequested extends ExpenseEvent {
  final int categoryId;
  const DeleteCategoryRequested(this.categoryId);
  @override
  List<Object?> get props => [categoryId];
}

class LoadExpenseSummary extends ExpenseEvent {
  final DateTime? from;
  final DateTime? to;
  const LoadExpenseSummary({this.from, this.to});
  @override
  List<Object?> get props => [from, to];
}

// ═══════════════════════════════════════════════════════════════════
// STATES
// ═══════════════════════════════════════════════════════════════════

abstract class ExpenseState extends Equatable {
  const ExpenseState();
  @override
  List<Object?> get props => [];
}

class ExpenseInitial extends ExpenseState {
  const ExpenseInitial();
}

class ExpenseLoading extends ExpenseState {
  const ExpenseLoading();
}

class ExpenseListLoaded extends ExpenseState {
  final List<ExpenseEntity> expenses;
  const ExpenseListLoaded(this.expenses);
  @override
  List<Object?> get props => [expenses];
}

class ExpenseCategoriesLoaded extends ExpenseState {
  final List<ExpenseCategoryEntity> categories;
  const ExpenseCategoriesLoaded(this.categories);
  @override
  List<Object?> get props => [categories];
}

class ExpenseSummaryLoaded extends ExpenseState {
  final List<ExpenseCategorySummary> summaries;
  final double grandTotal;
  const ExpenseSummaryLoaded(
      {required this.summaries, required this.grandTotal});
  @override
  List<Object?> get props => [summaries, grandTotal];
}

class ExpenseOperationSuccess extends ExpenseState {
  final String message;
  const ExpenseOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class ExpenseError extends ExpenseState {
  final String message;
  const ExpenseError(this.message);
  @override
  List<Object?> get props => [message];
}
