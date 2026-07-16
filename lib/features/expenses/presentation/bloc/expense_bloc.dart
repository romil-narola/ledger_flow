import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/expense_usecases.dart';
import 'expense_event_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  final GetCategories _getCategories;
  final AddCategory _addCategory;
  final UpdateCategory _updateCategory;
  final DeleteCategory _deleteCategory;
  final GetAllExpenses _getAllExpenses;
  final AddExpense _addExpense;
  final DeleteExpense _deleteExpense;
  final GetExpenseCategoryTotals _getCategoryTotals;

  ExpenseBloc({
    required GetCategories getCategories,
    required AddCategory addCategory,
    required UpdateCategory updateCategory,
    required DeleteCategory deleteCategory,
    required GetAllExpenses getAllExpenses,
    required AddExpense addExpense,
    required DeleteExpense deleteExpense,
    required GetExpenseCategoryTotals getCategoryTotals,
  })  : _getCategories = getCategories,
        _addCategory = addCategory,
        _updateCategory = updateCategory,
        _deleteCategory = deleteCategory,
        _getAllExpenses = getAllExpenses,
        _addExpense = addExpense,
        _deleteExpense = deleteExpense,
        _getCategoryTotals = getCategoryTotals,
        super(const ExpenseInitial()) {
    on<LoadExpenses>(_onLoadExpenses);
    on<LoadCategories>(_onLoadCategories);
    on<AddExpenseRequested>(_onAddExpense);
    on<DeleteExpenseRequested>(_onDeleteExpense);
    on<AddCategoryRequested>(_onAddCategory);
    on<UpdateCategoryRequested>(_onUpdateCategory);
    on<DeleteCategoryRequested>(_onDeleteCategory);
    on<LoadExpenseSummary>(_onLoadExpenseSummary);
  }

  Future<void> _onLoadExpenses(
      LoadExpenses event, Emitter<ExpenseState> emit) async {
    emit(const ExpenseLoading());
    try {
      final expenses = await _getAllExpenses(from: event.from, to: event.to);
      emit(ExpenseListLoaded(expenses));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onLoadCategories(
      LoadCategories event, Emitter<ExpenseState> emit) async {
    emit(const ExpenseLoading());
    try {
      final categories = await _getCategories();
      emit(ExpenseCategoriesLoaded(categories));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onAddExpense(
      AddExpenseRequested event, Emitter<ExpenseState> emit) async {
    try {
      await _addExpense(
        categoryId: event.categoryId,
        walletAccountId: event.walletAccountId,
        amount: event.amount,
        description: event.description,
        date: event.date,
        notes: event.notes,
      );
      emit(const ExpenseOperationSuccess('expenseRecordedSuccessfully'));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onDeleteExpense(
      DeleteExpenseRequested event, Emitter<ExpenseState> emit) async {
    try {
      await _deleteExpense(event.expenseId);
      emit(const ExpenseOperationSuccess('expenseDeleted'));
      add(const LoadExpenses());
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onAddCategory(
      AddCategoryRequested event, Emitter<ExpenseState> emit) async {
    try {
      await _addCategory(
        name: event.name,
        iconCodepoint: event.iconCodepoint,
        colorHex: event.colorHex,
        monthlyBudget: event.monthlyBudget,
      );
      emit(const ExpenseOperationSuccess('categoryAdded'));
      add(const LoadCategories());
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onUpdateCategory(
      UpdateCategoryRequested event, Emitter<ExpenseState> emit) async {
    try {
      await _updateCategory(event.category);
      emit(const ExpenseOperationSuccess('categoryUpdated'));
      add(const LoadCategories());
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onDeleteCategory(
      DeleteCategoryRequested event, Emitter<ExpenseState> emit) async {
    try {
      await _deleteCategory(event.categoryId);
      emit(const ExpenseOperationSuccess('categoryDeleted'));
      add(const LoadCategories());
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }

  Future<void> _onLoadExpenseSummary(
      LoadExpenseSummary event, Emitter<ExpenseState> emit) async {
    emit(const ExpenseLoading());
    try {
      final summaries =
          await _getCategoryTotals(from: event.from, to: event.to);
      final grand = summaries.fold<double>(0.0, (s, e) => s + e.totalSpent);
      emit(ExpenseSummaryLoaded(summaries: summaries, grandTotal: grand));
    } catch (e) {
      emit(ExpenseError(e.toString()));
    }
  }
}
