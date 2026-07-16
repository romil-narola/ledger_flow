import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../../core/core.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/expense_dao.dart';
import '../../../../core/database/daos/wallet_dao.dart';
import '../../../../core/database/daos/ledger_dao.dart';
import '../../expenses.dart';

const _uuid = Uuid();

/// Expense repository implementing all expense business logic.
/// - Deducts wallet balance if wallet is provided (atomic transaction)
/// - Creates ledger entry for each expense
/// - Provides category summaries for analytics
class ExpenseRepositoryImpl implements ExpenseRepository {
  final ExpenseDao _expenseDao;
  final WalletDao _walletDao;
  final LedgerDao _ledgerDao;
  final AppDatabase _db;

  ExpenseRepositoryImpl({
    required ExpenseDao expenseDao,
    required WalletDao walletDao,
    required LedgerDao ledgerDao,
    required AppDatabase db,
  })  : _expenseDao = expenseDao,
        _walletDao = walletDao,
        _ledgerDao = ledgerDao,
        _db = db;

  // ─── Categories ───────────────────────────────────────────────────

  @override
  Future<List<ExpenseCategoryEntity>> getCategories() async {
    final rows = await _expenseDao.getAllCategories();
    return rows
        .map((r) => ExpenseCategoryEntity(
              id: r.id,
              name: r.name,
              iconCodepoint: r.iconCodepoint,
              colorHex: r.colorHex,
              monthlyBudget: r.monthlyBudget,
              isActive: r.isActive,
            ))
        .toList();
  }

  @override
  Future<int> addCategory({
    required String name,
    required int iconCodepoint,
    required String colorHex,
    double? monthlyBudget,
  }) =>
      _expenseDao.insertCategory(ExpenseCategoriesCompanion.insert(
        name: name,
        iconCodepoint: Value(iconCodepoint),
        colorHex: Value(colorHex),
        monthlyBudget: Value(monthlyBudget),
      ));

  @override
  Future<void> updateCategory(ExpenseCategoryEntity category) async {
    await _expenseDao.updateCategory(ExpenseCategoriesCompanion(
      id: Value(category.id),
      name: Value(category.name),
      iconCodepoint: Value(category.iconCodepoint),
      colorHex: Value(category.colorHex),
      monthlyBudget: Value(category.monthlyBudget),
      isActive: Value(category.isActive),
    ));
  }

  @override
  Future<void> deleteCategory(int categoryId) async {
    await _expenseDao.deleteCategory(categoryId);
  }

  // ─── Expenses ─────────────────────────────────────────────────────

  @override
  Future<int> addExpense({
    required int categoryId,
    int? walletAccountId,
    required double amount,
    required String description,
    required DateTime date,
    String? notes,
  }) async {
    return _db.transaction(() async {
      final category = await _expenseDao.getCategoryById(categoryId);
      if (category == null) throw Exception('Expense category not found');

      double walletBalance = 0.0;

      // Deduct from wallet if provided
      if (walletAccountId != null) {
        final wallet = await _walletDao.getWalletById(walletAccountId);
        if (wallet == null) throw Exception('Wallet not found');

        if (!wallet.overdraftEnabled && wallet.currentBalance < amount) {
          throw Exception(
            'Insufficient wallet balance. Available: ₹${wallet.currentBalance.toStringAsFixed(2)}, Required: ₹${amount.toStringAsFixed(2)}',
          );
        }

        final newBalance = wallet.currentBalance - amount;
        await _walletDao.updateBalance(walletAccountId, newBalance);
        walletBalance = newBalance;
      }

      final ref =
          '${AppConstants.expensePrefix}${_uuid.v4().substring(0, 8).toUpperCase()}';

      // Insert expense record
      final expenseId =
          await _expenseDao.insertExpense(ExpensesCompanion.insert(
        referenceNumber: ref,
        categoryId: categoryId,
        walletAccountId: Value(walletAccountId),
        amount: amount,
        description: description,
        notes: Value(notes),
        date: date,
      ));

      // Create ledger entry
      await _ledgerDao.insertEntry(LedgerEntriesCompanion.insert(
        referenceNumber: ref,
        transactionType: TransactionType.expense.name,
        walletAccountId: Value(walletAccountId),
        relatedTransactionId: Value(expenseId),
        debit: const Value(0.0),
        credit: Value(amount),
        walletBalance: Value(walletBalance),
        description: '${category.name}: $description',
        date: date,
      ));

      return expenseId;
    });
  }

  @override
  Future<List<ExpenseEntity>> getAllExpenses(
      {DateTime? from, DateTime? to}) async {
    final rows = await _expenseDao.getAllExpenses(from: from, to: to);
    return _mapExpenses(rows);
  }

  @override
  Future<List<ExpenseEntity>> getExpensesByCategory(int categoryId,
      {DateTime? from, DateTime? to}) async {
    final rows =
        await _expenseDao.getExpensesByCategory(categoryId, from: from, to: to);
    return _mapExpenses(rows);
  }

  @override
  Future<void> deleteExpense(int expenseId) async {
    await _db.transaction(() async {
      final expense = await _expenseDao.getExpenseById(expenseId);
      if (expense == null) return;

      // Restore wallet balance if this expense had a wallet
      if (expense.walletAccountId != null) {
        final wallet = await _walletDao.getWalletById(expense.walletAccountId!);
        if (wallet != null) {
          await _walletDao.updateBalance(
              expense.walletAccountId!, wallet.currentBalance + expense.amount);
        }
      }

      // Delete associated ledger entry
      await _ledgerDao.deleteByReference(expense.referenceNumber);

      await _expenseDao.deleteExpense(expenseId);
    });
  }

  // ─── Summaries ────────────────────────────────────────────────────

  @override
  Future<double> getMonthlyTotal(DateTime month) =>
      _expenseDao.getMonthlyExpenseTotal(month);

  @override
  Future<List<ExpenseCategorySummary>> getCategoryTotals(
      {DateTime? from, DateTime? to}) async {
    final categories = await _expenseDao.getAllCategories();
    final totalsMap = await _expenseDao.getCategoryTotals(from: from, to: to);
    final allExpenses = await _expenseDao.getAllExpenses(from: from, to: to);

    return categories
        .map((cat) {
          final total = totalsMap[cat.id] ?? 0.0;
          final count = allExpenses.where((e) => e.categoryId == cat.id).length;
          return ExpenseCategorySummary(
            category: ExpenseCategoryEntity(
              id: cat.id,
              name: cat.name,
              iconCodepoint: cat.iconCodepoint,
              colorHex: cat.colorHex,
              monthlyBudget: cat.monthlyBudget,
              isActive: cat.isActive,
            ),
            totalSpent: total,
            count: count,
          );
        })
        .where((s) => s.totalSpent > 0)
        .toList()
      ..sort((a, b) => b.totalSpent.compareTo(a.totalSpent));
  }

  // ─── Private Helpers ──────────────────────────────────────────────

  Future<List<ExpenseEntity>> _mapExpenses(List<Expense> rows) async {
    final categories = await _expenseDao.getAllCategories();
    final catMap = {for (final c in categories) c.id: c};

    final List<ExpenseEntity> result = [];
    for (final row in rows) {
      final cat = catMap[row.categoryId];
      String? walletName;
      if (row.walletAccountId != null) {
        final wallet = await _walletDao.getWalletById(row.walletAccountId!);
        walletName = wallet?.name;
      }
      result.add(ExpenseEntity(
        id: row.id,
        referenceNumber: row.referenceNumber,
        categoryId: row.categoryId,
        categoryName: cat?.name ?? 'Unknown',
        categoryIconCodepoint: cat?.iconCodepoint ?? 0xe8b8,
        categoryColorHex: cat?.colorHex ?? '#6B7280',
        walletAccountId: row.walletAccountId,
        walletName: walletName,
        amount: row.amount,
        description: row.description,
        notes: row.notes,
        date: row.date,
      ));
    }
    return result;
  }
}
