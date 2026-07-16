import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../ledger.dart';

class LedgerEntryDetailScreen extends StatelessWidget {
  final int entryId;
  const LedgerEntryDetailScreen({super.key, required this.entryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LedgerBloc>()..add(LoadLedgerEntry(entryId)),
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.l10n.transactionDetails),
        ),
        body: BlocBuilder<LedgerBloc, LedgerState>(
          builder: (context, state) {
            if (state is LedgerLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is LedgerError) {
              return Center(child: Text(context.l10n.error));
            }
            if (state is LedgerEntryDetailLoaded) {
              final entry = state.entry;
              final isDebit = entry.debit > 0;
              final Color amountColor =
                  isDebit ? AppColors.debit : AppColors.creditEntry;
              final double amount = isDebit ? entry.debit : entry.credit;

              return ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Top card with type and amount
                  Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          Text(
                            entry.transactionType
                                .getLocalizedLabel(context)
                                .toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).colorScheme.outline,
                                  letterSpacing: 1.2,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            '${isDebit ? '-' : '+'}${CurrencyFormatter.format(amount)}',
                            style: Theme.of(context)
                                .textTheme
                                .headlineMedium
                                ?.copyWith(
                                  color: amountColor,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .colorScheme
                                  .surfaceContainerHighest,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.tag, size: 14),
                                const SizedBox(width: 4),
                                Text(
                                  entry.referenceNumber,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // General Details Card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            context.l10n.details,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const Divider(height: 24),
                          _buildDetailRow(
                            context,
                            icon: Icons.calendar_today,
                            label: context.l10n.dateTime,
                            value: DateFormatter.formatWithTime(entry.date),
                          ),
                          _buildDetailRow(
                            context,
                            icon: Icons.description_outlined,
                            label: context.l10n.description,
                            value: entry.description,
                          ),
                          _buildDetailRow(
                            context,
                            icon: Icons.account_balance_wallet_outlined,
                            label: context.l10n.walletAccount,
                            value: entry.walletName ?? 'N/A',
                          ),
                          _buildDetailRow(
                            context,
                            icon: Icons.wallet,
                            label: context.l10n.walletBalanceAfter,
                            value:
                                CurrencyFormatter.format(entry.walletBalance),
                            valueColor: entry.walletBalance >= 0
                                ? AppColors.success
                                : AppColors.error,
                          ),
                          if (entry.supplierName != null)
                            _buildDetailRow(
                              context,
                              icon: Icons.business,
                              label: context.l10n.supplier,
                              value: entry.supplierName!,
                              onTap: () => context
                                  .go('/suppliers/${entry.supplierId}/ledger'),
                            ),
                          if (entry.customerName != null)
                            _buildDetailRow(
                              context,
                              icon: Icons.person,
                              label: context.l10n.customer,
                              value: entry.customerName!,
                              onTap: () => context
                                  .go('/customers/${entry.customerId}/ledger'),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    Color? valueColor,
    VoidCallback? onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Theme.of(context).colorScheme.outline),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                ),
                const SizedBox(height: 4),
                GestureDetector(
                  onTap: onTap,
                  child: Text(
                    value,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: valueColor ??
                              (onTap != null ? AppColors.primaryLight : null),
                          fontWeight: onTap != null ? FontWeight.bold : null,
                          decoration:
                              onTap != null ? TextDecoration.underline : null,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
