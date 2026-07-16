import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../wallet.dart';

class WalletListScreen extends StatelessWidget {
  const WalletListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<WalletBloc>()..add(const WatchWalletsStarted()),
      child: const _WalletListView(),
    );
  }
}

class _WalletListView extends StatelessWidget {
  const _WalletListView();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.walletAccounts),
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
            icon: const Icon(Icons.add),
            onPressed: () => context.go('/wallets/add'),
          ),
        ],
      ),
      body: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is WalletOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text(translateBlocMessage(state.message, context.l10n)),
                  backgroundColor: AppColors.success),
            );
          } else if (state is WalletError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text(translateBlocMessage(state.message, context.l10n)),
                  backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          if (state is WalletLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is WalletEmpty) {
            return _buildEmpty(context);
          }
          if (state is WalletLoaded) {
            return _buildList(context, state);
          }
          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.go('/wallets/add'),
        icon: const Icon(Icons.add),
        label: Text(context.l10n.addWallet),
      ),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.account_balance_wallet_outlined,
              size: 80, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 16),
          Text(context.l10n.noWalletAccountsYet,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(context.l10n.addWalletToStart,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.outline)),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/wallets/add'),
            icon: const Icon(Icons.add),
            label: Text(context.l10n.addWallet),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, WalletLoaded state) {
    return Column(
      children: [
        // Total balance banner
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
              Text(context.l10n.totalBalance,
                  style: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.copyWith(color: Colors.white70)),
              const SizedBox(height: 4),
              Text(
                CurrencyFormatter.format(state.totalBalance),
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
              ),
            ],
          ),
        ),
        // Wallet list
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: state.wallets.length,
            itemBuilder: (context, index) {
              return _WalletCard(wallet: state.wallets[index]);
            },
          ),
        ),
      ],
    );
  }
}

class _WalletCard extends StatelessWidget {
  final WalletAccountEntity wallet;
  const _WalletCard({required this.wallet});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.avatarColorForName(wallet.name);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.go('/wallets/${wallet.id}/history'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    backgroundColor: color.withValues(alpha: 0.15),
                    radius: 22,
                    child: Text(
                      wallet.name.substring(0, 1).toUpperCase(),
                      style: TextStyle(
                          color: color,
                          fontWeight: FontWeight.w700,
                          fontSize: 18),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(wallet.name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w600,
                                )),
                        if (wallet.notes != null && wallet.notes!.isNotEmpty)
                          Text(wallet.notes!,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .outline)),
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'edit') {
                        context.go('/wallets/${wallet.id}/edit');
                      } else if (value == 'delete') {
                        _confirmDelete(context);
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                          value: 'edit', child: Text(context.l10n.edit)),
                      PopupMenuItem(
                          value: 'delete',
                          child: Text(context.l10n.delete,
                              style: const TextStyle(color: AppColors.error))),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.currentBalance,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.outline)),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.format(wallet.currentBalance),
                          style:
                              Theme.of(context).textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: wallet.currentBalance >= 0
                                        ? AppColors.success
                                        : AppColors.error,
                                  ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(context.l10n.opening,
                            style: Theme.of(context)
                                .textTheme
                                .bodySmall
                                ?.copyWith(
                                    color:
                                        Theme.of(context).colorScheme.outline)),
                        const SizedBox(height: 2),
                        Text(
                          CurrencyFormatter.format(wallet.openingBalance),
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w500,
                                  ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (wallet.overdraftEnabled)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Chip(
                    label: Text(context.l10n.overdraftEnabled),
                    backgroundColor: AppColors.warningBg,
                    labelStyle:
                        const TextStyle(color: AppColors.warning, fontSize: 11),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context) async {
    final confirmed = await DeleteDialog.show(
      context,
      title: context.l10n.deleteWallet,
      content: '${context.l10n.confirmDelete} ("${wallet.name}")',
    );

    if (confirmed == true && context.mounted) {
      context.read<WalletBloc>().add(DeleteWalletRequested(wallet.id));
    }
  }
}
