import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../bloc/dashboard_bloc.dart';
import '../bloc/dashboard_event_state.dart';
import '../../../ledger/ledger.dart';

import '../../../business/presentation/bloc/business_cubit.dart';
import '../../../business/presentation/bloc/business_state.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<DashboardBloc>()..add(const LoadDashboard()),
      child: Builder(
        builder: (context) {
          return BlocListener<BusinessCubit, BusinessState>(
            listenWhen: (previous, current) {
              final prevId = previous.maybeWhen(
                  loaded: (_, c) => c.id, orElse: () => null);
              final currId =
                  current.maybeWhen(loaded: (_, c) => c.id, orElse: () => null);
              return prevId != currId && prevId != null;
            },
            listener: (context, state) {
              context.read<DashboardBloc>().add(const RefreshDashboard());
            },
            child: const _DashboardView(),
          );
        },
      ),
    );
  }
}

class _DashboardView extends StatelessWidget {
  const _DashboardView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DashboardBloc, DashboardState>(
        builder: (context, state) {
          if (state is DashboardLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is DashboardError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 64, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(context.l10n.error, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => context
                        .read<DashboardBloc>()
                        .add(const LoadDashboard()),
                    child: Text(context.l10n.retry),
                  ),
                ],
              ),
            );
          }

          final summary = state is DashboardLoaded
              ? state.summary
              : state is DashboardRefreshing
                  ? state.summary
                  : null;

          if (summary == null) return const SizedBox.shrink();

          return RefreshIndicator(
            onRefresh: () async {
              context.read<DashboardBloc>().add(const RefreshDashboard());
            },
            child: CustomScrollView(
              slivers: [
                // ── App Bar ──────────────────────────────────────
                _buildSliverAppBar(context, summary.totalWalletBalance),

                SliverPadding(
                  padding: const EdgeInsets.all(16),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // ── Summary Cards ────────────────────────
                      _buildSectionTitle(
                          context, context.l10n.financialSummary),
                      const SizedBox(height: 12),
                      _buildSummaryGrid(context, summary),
                      const SizedBox(height: 24),

                      // ── Monthly Snapshot ─────────────────────
                      _buildSectionTitle(context, context.l10n.thisMonth),
                      const SizedBox(height: 12),
                      _buildMonthlyCards(context, summary.monthlyPurchases,
                          summary.monthlySales),
                      const SizedBox(height: 24),

                      // ── Chart ────────────────────────────────
                      _buildSectionTitle(context, context.l10n.last6Months),
                      const SizedBox(height: 12),
                      _buildChart(context, summary),
                      const SizedBox(height: 24),

                      // ── Recent Transactions ───────────────────
                      _buildSectionTitle(
                          context, context.l10n.recentTransactions,
                          action: TextButton(
                            onPressed: () => context.push('/ledger'),
                            child: Text(context.l10n.viewAll),
                          )),
                      const SizedBox(height: 8),
                      if (summary.recentTransactions.isEmpty)
                        _buildEmptyTransactions(context)
                      else
                        ...summary.recentTransactions.take(5).map(
                              (t) => _TransactionTile(entry: t),
                            ),
                      const SizedBox(height: 24),
                    ]),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context, double totalBalance) {
    return SliverAppBar(
      expandedHeight: 150,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        background: GestureDetector(
          onTap: () => context.push('/wallets'),
          behavior: HitTestBehavior.opaque,
          child: Container(
            decoration:
                const BoxDecoration(gradient: AppColors.primaryGradient),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      context.l10n.totalNetBalance,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white70,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      CurrencyFormatter.format(totalBalance),
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                letterSpacing: -1,
                              ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      backgroundColor: AppColors.primary,
      title: Text(
        context.l10n.appName,
      ),
      actions: [
        IconButton(
          onPressed: () => context.push('/businesses'),
          icon: const Icon(Icons.business, color: Colors.white),
          tooltip: context.l10n.businesses,
        ),
        IconButton(
          onPressed: () => showDialog(
            context: context,
            builder: (_) => const LanguageSelectorDialog(),
          ),
          icon: const Icon(Icons.language, color: Colors.white),
          tooltip: context.l10n.language,
        ),
        IconButton(
          onPressed: () => context.push('/wallets'),
          icon: const Icon(Icons.account_balance_wallet_outlined,
              color: Colors.white),
          tooltip: context.l10n.walletAccounts,
        ),
        const SizedBox(width: 4),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title,
      {Widget? action}) {
    return Row(
      children: [
        Text(title,
            style: Theme.of(context)
                .textTheme
                .titleMedium
                ?.copyWith(fontWeight: FontWeight.w700)),
        const Spacer(),
        if (action != null) action,
      ],
    );
  }

  Widget _buildSummaryGrid(BuildContext context, DashboardSummary summary) {
    return GridView.count(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _SummaryCard(
          title: context.l10n.totalPayable,
          amount: summary.supplierOutstanding,
          gradient: AppColors.errorGradient,
          icon: Icons.trending_up,
          onTap: () => context.push('/suppliers/outstanding'),
        ),
        _SummaryCard(
          title: context.l10n.creditSummary,
          amount: summary.supplierCredit,
          gradient: AppColors.successGradient,
          icon: Icons.account_balance_wallet,
          onTap: () => context.push('/suppliers/credit'),
        ),
        _SummaryCard(
          title: context.l10n.totalReceivable,
          amount: summary.customerOutstanding,
          gradient: AppColors.warningGradient,
          icon: Icons.receipt_long,
          onTap: () => context.push('/customers/outstanding'),
        ),
        _SummaryCard(
          title: context.l10n.customers,
          amount: summary.customerAdvance,
          gradient: AppColors.tealGradient,
          icon: Icons.savings,
          onTap: () => context.push('/customers/advance'),
        ),
      ],
    );
  }

  Widget _buildMonthlyCards(
      BuildContext context, double purchases, double sales) {
    return Row(
      children: [
        Expanded(
          child: _MonthlyCard(
            title: context.l10n.purchase,
            amount: purchases,
            color: AppColors.error,
            icon: Icons.shopping_cart_outlined,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _MonthlyCard(
            title: context.l10n.sale,
            amount: sales,
            color: AppColors.success,
            icon: Icons.trending_up_outlined,
          ),
        ),
      ],
    );
  }

  Widget _buildChart(BuildContext context, DashboardSummary summary) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _ChartLegend(
                    color: AppColors.error, label: context.l10n.purchase),
                const SizedBox(width: 16),
                _ChartLegend(
                    color: AppColors.success, label: context.l10n.sale),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: BarChart(
                BarChartData(
                  barTouchData: BarTouchData(
                    enabled: true,
                    touchTooltipData: BarTouchTooltipData(
                      getTooltipColor: (group) => isDark
                          ? AppColors.surfaceDark
                          : AppColors.surfaceLight,
                      tooltipMargin: 8,
                      tooltipRoundedRadius: 8,
                      tooltipPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      tooltipBorder: BorderSide(
                        color: isDark
                            ? AppColors.borderDark
                            : AppColors.borderLight,
                        width: 1,
                      ),
                      getTooltipItem: (group, groupIndex, rod, rodIndex) {
                        final isPurchase = rodIndex == 0;
                        final value = CurrencyFormatter.format(rod.toY);

                        return BarTooltipItem(
                          value,
                          TextStyle(
                            color: isPurchase
                                ? AppColors.error
                                : AppColors.success,
                            fontWeight: FontWeight.bold,
                            fontSize: 12,
                          ),
                        );
                      },
                    ),
                  ),
                  alignment: BarChartAlignment.spaceAround,
                  maxY: _getMaxY(summary),
                  barGroups: _buildBarGroups(summary),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _getMaxY(summary) / 4,
                    getDrawingHorizontalLine: (value) => FlLine(
                      color:
                          isDark ? AppColors.borderDark : AppColors.borderLight,
                      strokeWidth: 1,
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          final idx = value.toInt();
                          if (idx < 0 ||
                              idx >= summary.last6MonthsPurchases.length) {
                            return const SizedBox.shrink();
                          }
                          return Text(
                            summary.last6MonthsPurchases[idx].label,
                            style: TextStyle(fontSize: 11, color: textColor),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  double _getMaxY(DashboardSummary summary) {
    double max = 1000;
    for (final d in summary.last6MonthsPurchases) {
      if (d.amount > max) max = d.amount;
    }
    for (final d in summary.last6MonthsSales) {
      if (d.amount > max) max = d.amount;
    }
    return max * 1.2;
  }

  List<BarChartGroupData> _buildBarGroups(DashboardSummary summary) {
    return List.generate(summary.last6MonthsPurchases.length, (i) {
      return BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: summary.last6MonthsPurchases[i].amount,
            color: AppColors.error.withValues(alpha: 0.8),
            width: 10,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
          BarChartRodData(
            toY: summary.last6MonthsSales[i].amount,
            color: AppColors.success.withValues(alpha: 0.8),
            width: 10,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
          ),
        ],
      );
    });
  }

  Widget _buildEmptyTransactions(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Center(
          child: Column(
            children: [
              Icon(Icons.receipt_long_outlined,
                  size: 48, color: Theme.of(context).colorScheme.outline),
              const SizedBox(height: 12),
              Text(context.l10n.noRecentTransactions,
                  style: Theme.of(context).textTheme.bodyLarge),
            ],
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String title;
  final double amount;
  final LinearGradient gradient;
  final IconData icon;
  final VoidCallback? onTap;

  const _SummaryCard({
    required this.title,
    required this.amount,
    required this.gradient,
    required this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          gradient: gradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: gradient.colors.first.withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(icon, color: Colors.white70, size: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  CurrencyFormatter.formatCard(amount),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MonthlyCard extends StatelessWidget {
  final String title;
  final double amount;
  final Color color;
  final IconData icon;

  const _MonthlyCard({
    required this.title,
    required this.amount,
    required this.color,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(icon, color: color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodySmall),
                  const SizedBox(height: 2),
                  Text(
                    CurrencyFormatter.formatCard(amount),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: color,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionTile extends StatelessWidget {
  final LedgerEntryEntity entry;
  const _TransactionTile({required this.entry});

  @override
  Widget build(BuildContext context) {
    final isCredit = entry.credit > 0;
    final color = isCredit ? AppColors.success : AppColors.error;
    final amount = isCredit ? entry.credit : entry.debit;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(
            _getTransactionIcon(entry.transactionType),
            color: color,
            size: 20,
          ),
        ),
        title: Text(
          entry.description,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
          DateFormatter.getRelativeLabel(context, entry.date),
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: Text(
          '${isCredit ? '+' : '-'}${CurrencyFormatter.formatCard(amount)}',
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w700,
            fontSize: 14,
          ),
        ),
      ),
    );
  }

  IconData _getTransactionIcon(TransactionType type) {
    switch (type) {
      case TransactionType.purchase:
        return Icons.shopping_cart_outlined;
      case TransactionType.sale:
        return Icons.sell_outlined;
      case TransactionType.supplierPayment:
        return Icons.payment_outlined;
      case TransactionType.customerPayment:
        return Icons.payments_outlined;
      default:
        return Icons.swap_horiz;
    }
  }
}

class _ChartLegend extends StatelessWidget {
  final Color color;
  final String label;
  const _ChartLegend({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
                color: color, borderRadius: BorderRadius.circular(2))),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }
}
