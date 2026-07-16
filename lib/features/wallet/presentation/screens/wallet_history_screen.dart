import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../wallet.dart';

class WalletHistoryScreen extends StatelessWidget {
  final int walletId;
  const WalletHistoryScreen({super.key, required this.walletId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<WalletBloc>()..add(LoadWalletHistory(walletId: walletId)),
      child: const _WalletHistoryView(),
    );
  }
}

class _WalletHistoryView extends StatelessWidget {
  const _WalletHistoryView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(context.l10n.walletHistory)),
      body: BlocBuilder<WalletBloc, WalletState>(
        builder: (context, state) {
          if (state is WalletHistoryLoading || state is WalletLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WalletError) {
            return Center(
                child: Text(translateBlocMessage(state.message, context.l10n)));
          }
          if (state is WalletHistoryLoaded) {
            return _buildContent(context, state);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, WalletHistoryLoaded state) {
    final wallet = state.wallet;
    final transactions = state.transactions;

    return Column(
      children: [
        // Wallet Balance Header
        Container(
          width: double.infinity,
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(wallet.name,
                  style: const TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatter.format(wallet.currentBalance),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _BalanceChip(
                    label: context.l10n.opening,
                    value: CurrencyFormatter.format(wallet.openingBalance),
                  ),
                  const SizedBox(width: 8),
                  _BalanceChip(
                    label: context.l10n.overdraft,
                    value: wallet.overdraftEnabled
                        ? context.l10n.enabled
                        : context.l10n.disabled,
                  ),
                ],
              ),
            ],
          ),
        ),

        // Transaction History
        if (transactions.isEmpty)
          Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.history,
                      size: 64, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(context.l10n.noTransactionsYet),
                ],
              ),
            ),
          )
        else
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                return _TransactionItem(tx: transactions[index]);
              },
            ),
          ),
      ],
    );
  }
}

class _BalanceChip extends StatelessWidget {
  final String label;
  final String value;
  const _BalanceChip({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        '$label: $value',
        style: const TextStyle(color: Colors.white, fontSize: 12),
      ),
    );
  }
}

class _TransactionItem extends StatelessWidget {
  final WalletTransactionItem tx;
  const _TransactionItem({required this.tx});

  @override
  Widget build(BuildContext context) {
    final isCredit = tx.credit > 0;
    final amount = isCredit ? tx.credit : tx.debit;
    final color = isCredit ? AppColors.success : AppColors.error;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(
            isCredit ? Icons.arrow_downward : Icons.arrow_upward,
            color: color,
            size: 18,
          ),
        ),
        title: Text(
          tx.description,
          style: Theme.of(context)
              .textTheme
              .bodyMedium
              ?.copyWith(fontWeight: FontWeight.w500),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: Text(
            '${tx.referenceNumber} · ${DateFormatter.format(tx.date)}',
            style: Theme.of(context).textTheme.bodySmall),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${isCredit ? '+' : '-'}${CurrencyFormatter.format(amount)}',
              style: TextStyle(color: color, fontWeight: FontWeight.w700),
            ),
            Text(
              '${context.l10n.bal}: ${CurrencyFormatter.formatCard(tx.balance)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
