import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../expenses.dart';

class ExpenseSummaryScreen extends StatefulWidget {
  const ExpenseSummaryScreen({super.key});

  @override
  State<ExpenseSummaryScreen> createState() => _ExpenseSummaryScreenState();
}

class _ExpenseSummaryScreenState extends State<ExpenseSummaryScreen> {
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExpenseBloc>()
        ..add(LoadExpenseSummary(
          from: DateTime(_selectedMonth.year, _selectedMonth.month, 1),
          to: DateTime(_selectedMonth.year, _selectedMonth.month + 1, 1),
        )),
      child: _SummaryView(
        selectedMonth: _selectedMonth,
        onMonthChanged: (m) {
          setState(() => _selectedMonth = m);
        },
      ),
    );
  }
}

class _SummaryView extends StatelessWidget {
  final DateTime selectedMonth;
  final ValueChanged<DateTime> onMonthChanged;

  const _SummaryView(
      {required this.selectedMonth, required this.onMonthChanged});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final monthLabel = _monthLabel(selectedMonth);

    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.expenseSummary)),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (context, state) {
          return Column(
            children: [
              // Month Navigator
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.chevron_left),
                      onPressed: () {
                        final prev = DateTime(
                            selectedMonth.year, selectedMonth.month - 1);
                        onMonthChanged(prev);
                        context.read<ExpenseBloc>().add(LoadExpenseSummary(
                              from: DateTime(prev.year, prev.month, 1),
                              to: DateTime(prev.year, prev.month + 1, 1),
                            ));
                      },
                    ),
                    Text(monthLabel,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      onPressed: selectedMonth.month == DateTime.now().month &&
                              selectedMonth.year == DateTime.now().year
                          ? null
                          : () {
                              final next = DateTime(
                                  selectedMonth.year, selectedMonth.month + 1);
                              onMonthChanged(next);
                              context
                                  .read<ExpenseBloc>()
                                  .add(LoadExpenseSummary(
                                    from: DateTime(next.year, next.month, 1),
                                    to: DateTime(next.year, next.month + 1, 1),
                                  ));
                            },
                    ),
                  ],
                ),
              ),
              const Divider(height: 1),

              if (state is ExpenseLoading)
                const Expanded(
                    child: Center(child: CircularProgressIndicator()))
              else if (state is ExpenseSummaryLoaded) ...[
                // Grand Total Card
                Container(
                  margin: const EdgeInsets.all(16),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.receipt_long,
                          color: Colors.white, size: 32),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(context.l10n.totalExpenses,
                              style: const TextStyle(
                                  color: Colors.white70, fontSize: 14)),
                          Text(
                            CurrencyFormatter.format(state.grandTotal),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 26,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Category breakdown
                Expanded(
                  child: state.summaries.isEmpty
                      ? Center(child: Text(context.l10n.noExpensesThisMonth))
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: state.summaries.length,
                          itemBuilder: (context, index) {
                            final summary = state.summaries[index];
                            return _CategorySummaryTile(
                              summary: summary,
                              grandTotal: state.grandTotal,
                              isDark: isDark,
                            );
                          },
                        ),
                ),
              ] else
                Expanded(child: Center(child: Text(context.l10n.noDataFound))),
            ],
          );
        },
      ),
    );
  }

  String _monthLabel(DateTime dt) {
    const months = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return '${months[dt.month - 1]} ${dt.year}';
  }
}

class _CategorySummaryTile extends StatelessWidget {
  final ExpenseCategorySummary summary;
  final double grandTotal;
  final bool isDark;

  const _CategorySummaryTile({
    required this.summary,
    required this.grandTotal,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final catColor = _hexToColor(summary.category.colorHex);
    final pct = grandTotal > 0 ? summary.totalSpent / grandTotal : 0.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: catColor.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  IconData(summary.category.iconCodepoint,
                      fontFamily: 'MaterialIcons'),
                  color: catColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(summary.category.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 14)),
                    Text(
                        '${summary.count} expense${summary.count != 1 ? 's' : ''}',
                        style: const TextStyle(
                            color: AppColors.textSecondaryLight, fontSize: 12)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(CurrencyFormatter.format(summary.totalSpent),
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: catColor,
                          fontSize: 15)),
                  Text('${(pct * 100).toStringAsFixed(1)}%',
                      style: const TextStyle(
                          color: AppColors.textSecondaryLight, fontSize: 11)),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: pct,
              backgroundColor: catColor.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(catColor),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
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
