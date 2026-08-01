import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../expenses.dart';

class ExpenseListScreen extends StatelessWidget {
  const ExpenseListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExpenseBloc>()..add(const LoadExpenses()),
      child: const _ExpenseListView(),
    );
  }
}

class _ExpenseListView extends StatefulWidget {
  const _ExpenseListView();

  @override
  State<_ExpenseListView> createState() => _ExpenseListViewState();
}

class _ExpenseListViewState extends State<_ExpenseListView> {
  DateTime? _from;
  DateTime? _to;
  int _selectedNatureIndex = 0; // 0: All, 1: Business, 2: Personal

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.expenses),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const LanguageSelectorDialog(),
            ),
            icon: const Icon(Icons.language),
            tooltip: context.l10n.language,
          ),
          IconButton(
            icon: const Icon(Icons.pie_chart_outline),
            tooltip: context.l10n.reports,
            onPressed: () => context.push('/expenses/summary'),
          ),
          IconButton(
            icon: const Icon(Icons.category_outlined),
            tooltip: context.l10n.manageCategories,
            onPressed: () => context.push('/expenses/categories'),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'expense-fab',
        onPressed: () async {
          await context.push('/expenses/add');
          if (context.mounted) {
            context.read<ExpenseBloc>().add(LoadExpenses(from: _from, to: _to));
          }
        },
        icon: const Icon(Icons.add),
        label: Text(context.l10n.addExpense),
      ),
      body: BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text(translateBlocMessage(state.message, context.l10n))),
            );
          } else if (state is ExpenseError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content:
                    Text(translateBlocMessage(state.message, context.l10n)),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is ExpenseLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ExpenseError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 48, color: AppColors.error),
                  const SizedBox(height: 8),
                  Text(state.message, textAlign: TextAlign.center),
                ],
              ),
            );
          }
          if (state is ExpenseListLoaded) {
            final expenses = state.expenses;
            if (expenses.isEmpty) {
              return _buildEmptyState(context);
            }
            return _buildExpenseList(context, expenses, isDark);
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.receipt_long_outlined,
                size: 64, color: AppColors.primary),
          ),
          const SizedBox(height: 20),
          Text(context.l10n.noExpensesYet,
              style:
                  const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(context.l10n.tapToRecordExpense,
              style: const TextStyle(color: AppColors.textSecondaryLight)),
        ],
      ),
    );
  }

  Widget _buildExpenseList(
      BuildContext context, List<ExpenseEntity> rawExpenses, bool isDark) {
    final personalKeywords = [
      'food',
      'dining',
      'entertainment',
      'medical',
      'doctor',
      'hospital',
      'medicine',
      'education',
      'school',
      'college',
      'tuition',
      'fee',
      'personal',
      'family',
      'shopping',
      'clothing',
      'grocery',
      'groceries',
      'home',
      'house',
      'movie',
      'gift',
      'recharge',
      'subscription',
      'life',
      'health',
      'self',
      'draw',
      'drawing',
      'household',
      'charity',
      'vacation',
      'trip'
    ];

    // Filter expenses based on selected nature segment
    final expenses = rawExpenses.where((e) {
      final isPersonal =
          personalKeywords.any((p) => e.categoryName.toLowerCase().contains(p));
      if (_selectedNatureIndex == 1) {
        return !isPersonal; // Business Only
      } else if (_selectedNatureIndex == 2) {
        return isPersonal; // Personal Only
      }
      return true; // All
    }).toList();

    // Group expenses by date
    final Map<String, List<ExpenseEntity>> grouped = {};
    for (final e in expenses) {
      final key = DateFormatter.format(e.date);
      grouped.putIfAbsent(key, () => []).add(e);
    }

    // Total this month
    final now = DateTime.now();
    final thisMonth = expenses
        .where((e) => e.date.year == now.year && e.date.month == now.month)
        .toList();
    final monthTotal = thisMonth.fold<double>(0, (s, e) => s + e.amount);

    return Column(
      children: [
        // Monthly total banner
        Container(
          width: double.infinity,
          margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: _selectedNatureIndex == 1
                  ? [const Color(0xFF0284C7), const Color(0xFF0369A1)]
                  : _selectedNatureIndex == 2
                      ? [const Color(0xFF8B5CF6), const Color(0xFF6D28D9)]
                      : [const Color(0xFF6366F1), const Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            children: [
              Icon(
                _selectedNatureIndex == 1
                    ? Icons.business_center_outlined
                    : _selectedNatureIndex == 2
                        ? Icons.person_outline
                        : Icons.calendar_month,
                color: Colors.white,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _selectedNatureIndex == 1
                          ? 'Business Expenses'
                          : _selectedNatureIndex == 2
                              ? 'Personal Expenses'
                              : context.l10n.thisMonth,
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        CurrencyFormatter.format(monthTotal),
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '${thisMonth.length} items',
                style: const TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),

        // Filter Segment Control Bar
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Row(
            children: [
              Expanded(
                child: ChoiceChip(
                  showCheckmark: false,
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.grid_view,
                        size: 16,
                        color: _selectedNatureIndex == 0
                            ? Colors.white
                            : AppColors.primary,
                      ),
                      const SizedBox(width: 6),
                      Text('All (${rawExpenses.length})'),
                    ],
                  ),
                  selected: _selectedNatureIndex == 0,
                  selectedColor: AppColors.primary,
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  labelStyle: TextStyle(
                    color: _selectedNatureIndex == 0
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                    fontSize: 12,
                    fontWeight: _selectedNatureIndex == 0
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  onSelected: (_) => setState(() => _selectedNatureIndex = 0),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ChoiceChip(
                  showCheckmark: false,
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.business_center_outlined,
                        size: 16,
                        color: _selectedNatureIndex == 1
                            ? Colors.white
                            : const Color(0xFF0284C7),
                      ),
                      const SizedBox(width: 6),
                      const Text('Business'),
                    ],
                  ),
                  selected: _selectedNatureIndex == 1,
                  selectedColor: const Color(0xFF0284C7),
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  labelStyle: TextStyle(
                    color: _selectedNatureIndex == 1
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                    fontSize: 12,
                    fontWeight: _selectedNatureIndex == 1
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  onSelected: (_) => setState(() => _selectedNatureIndex = 1),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: ChoiceChip(
                  showCheckmark: false,
                  label: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.person_outline,
                        size: 16,
                        color: _selectedNatureIndex == 2
                            ? Colors.white
                            : const Color(0xFF8B5CF6),
                      ),
                      const SizedBox(width: 6),
                      const Text('Personal'),
                    ],
                  ),
                  selected: _selectedNatureIndex == 2,
                  selectedColor: const Color(0xFF8B5CF6),
                  backgroundColor:
                      Theme.of(context).colorScheme.surfaceContainerHighest,
                  labelStyle: TextStyle(
                    color: _selectedNatureIndex == 2
                        ? Colors.white
                        : Theme.of(context).colorScheme.onSurface,
                    fontSize: 12,
                    fontWeight: _selectedNatureIndex == 2
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                  onSelected: (_) => setState(() => _selectedNatureIndex = 2),
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: expenses.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _selectedNatureIndex == 1
                            ? Icons.business_center_outlined
                            : Icons.person_outline,
                        size: 48,
                        color: Colors.grey.shade400,
                      ),
                      const SizedBox(height: 12),
                      Text(
                        _selectedNatureIndex == 1
                            ? 'No business expenses found'
                            : 'No personal expenses found',
                        style:
                            const TextStyle(fontSize: 16, color: Colors.grey),
                      ),
                    ],
                  ),
                )
              : ListView(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 100),
                  children: [
                    for (final entry in grouped.entries) ...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          children: [
                            Text(entry.key,
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                  color:
                                      isDark ? Colors.white60 : Colors.black54,
                                )),
                            const SizedBox(width: 8),
                            Expanded(
                                child: Divider(
                                    color: isDark
                                        ? Colors.white12
                                        : Colors.black12)),
                            const SizedBox(width: 8),
                            Text(
                              CurrencyFormatter.format(entry.value
                                  .fold(0.0, (s, e) => s + e.amount)),
                              style: const TextStyle(
                                  fontSize: 12,
                                  color: AppColors.error,
                                  fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      ...entry.value.map((expense) => _ExpenseCard(
                          expense: expense,
                          onDelete: () {
                            context
                                .read<ExpenseBloc>()
                                .add(DeleteExpenseRequested(expense.id));
                          })),
                    ],
                  ],
                ),
        ),
      ],
    );
  }
}

class _ExpenseCard extends StatelessWidget {
  final ExpenseEntity expense;
  final VoidCallback onDelete;

  const _ExpenseCard({required this.expense, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final catColor = _hexToColor(expense.categoryColorHex);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: catColor.withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            IconData(expense.categoryIconCodepoint,
                fontFamily: 'MaterialIcons'),
            color: catColor,
            size: 22,
          ),
        ),
        title: Text(
          expense.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: catColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(expense.categoryName,
                      style: TextStyle(
                          color: catColor,
                          fontSize: 11,
                          fontWeight: FontWeight.w500)),
                ),
                Builder(builder: (context) {
                  final personalKeywords = [
                    'food',
                    'dining',
                    'entertainment',
                    'medical',
                    'doctor',
                    'hospital',
                    'medicine',
                    'education',
                    'school',
                    'college',
                    'tuition',
                    'fee',
                    'personal',
                    'family',
                    'shopping',
                    'clothing',
                    'grocery',
                    'groceries',
                    'home',
                    'house',
                    'movie',
                    'gift',
                    'recharge',
                    'subscription',
                    'life',
                    'health',
                    'self',
                    'draw',
                    'drawing',
                    'household',
                    'charity',
                    'vacation',
                    'trip'
                  ];
                  final isPersonal = personalKeywords.any(
                      (p) => expense.categoryName.toLowerCase().contains(p));
                  final badgeColor = isPersonal
                      ? const Color(0xFF8B5CF6)
                      : const Color(0xFF0284C7);

                  return Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isPersonal
                              ? Icons.person_outline
                              : Icons.business_center_outlined,
                          size: 10,
                          color: badgeColor,
                        ),
                        const SizedBox(width: 3),
                        Text(
                          isPersonal ? 'Personal' : 'Business',
                          style: TextStyle(
                              color: badgeColor,
                              fontSize: 10,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  );
                }),
                if (expense.walletName != null) ...[
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.account_balance_wallet_outlined,
                          size: 12, color: AppColors.textSecondaryLight),
                      const SizedBox(width: 2),
                      Text(
                        expense.walletName!,
                        style: const TextStyle(
                            fontSize: 11, color: AppColors.textSecondaryLight),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ],
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                CurrencyFormatter.format(expense.amount),
                style: const TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.bold,
                    fontSize: 15),
              ),
            ),
            const SizedBox(width: 4),
            IconButton(
              icon: const Icon(Icons.delete_outline,
                  size: 18, color: AppColors.error),
              onPressed: () => _confirmDelete(context),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await DeleteDialog.show(
      context,
      title: context.l10n.deleteExpense,
      content: '${context.l10n.confirmDelete} ("${expense.description}")',
    );

    if (confirmed == true) {
      onDelete();
    }
  }

  Color _hexToColor(String hex) {
    try {
      final h = hex.replaceAll('#', '');
      return Color(int.parse('FF$h', radix: 16));
    } catch (_) {
      return const Color(0xFF6366F1);
    }
  }
}
