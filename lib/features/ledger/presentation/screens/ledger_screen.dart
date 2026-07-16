import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../../wallet/wallet.dart';
import '../../ledger.dart';

class LedgerScreen extends StatelessWidget {
  const LedgerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<LedgerBloc>()..add(const LoadLedger()),
      child: const _LedgerView(),
    );
  }
}

class _LedgerView extends StatefulWidget {
  const _LedgerView();

  @override
  State<_LedgerView> createState() => _LedgerViewState();
}

class _LedgerViewState extends State<_LedgerView> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();

  DateTime? _fromDate;
  DateTime? _toDate;
  TransactionType? _selectedType;
  WalletAccountEntity? _selectedWallet;
  List<WalletAccountEntity> _wallets = [];

  @override
  void initState() {
    super.initState();
    _loadWallets();
    _scrollController.addListener(_onScroll);
  }

  Future<void> _loadWallets() async {
    final wallets = await sl<GetWallets>()();
    setState(() {
      _wallets = wallets;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final state = context.read<LedgerBloc>().state;
      if (state is LedgerLoaded && state.hasMore) {
        context.read<LedgerBloc>().add(LoadMoreLedger(state.entries.length));
      }
    }
  }

  void _applyFilters(BuildContext context) {
    context.read<LedgerBloc>().add(LoadLedger(
          from: _fromDate,
          to: _toDate,
          transactionType: _selectedType?.name,
          walletId: _selectedWallet?.id,
        ));
  }

  void _clearFilters(BuildContext context) {
    setState(() {
      _fromDate = null;
      _toDate = null;
      _selectedType = null;
      _selectedWallet = null;
      _searchController.clear();
    });
    context.read<LedgerBloc>().add(const ClearLedgerFilter());
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.chronologicalLedger),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const LanguageSelectorDialog(),
            ),
            icon: const Icon(Icons.language),
            tooltip: l10n.language,
          ),
          IconButton(
            icon: const Icon(Icons.filter_list),
            onPressed: () => _showFilterSheet(context),
            tooltip: l10n.filterLedger,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _applyFilters(context),
            tooltip: l10n.refresh,
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(60),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: l10n.searchHintLedger,
                prefixIcon: const Icon(Icons.search),
                isDense: true,
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          context
                              .read<LedgerBloc>()
                              .add(const SearchLedger(''));
                        },
                      )
                    : null,
              ),
              onChanged: (query) {
                context.read<LedgerBloc>().add(SearchLedger(query));
              },
            ),
          ),
        ),
      ),
      body: BlocBuilder<LedgerBloc, LedgerState>(
        builder: (context, state) {
          if (state is LedgerLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is LedgerError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline,
                      size: 60, color: AppColors.error),
                  const SizedBox(height: 16),
                  Text(context.l10n.error, textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => _applyFilters(context),
                    child: Text(context.l10n.retry),
                  ),
                ],
              ),
            );
          }
          if (state is LedgerEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.receipt_long_outlined,
                      size: 80, color: Theme.of(context).colorScheme.outline),
                  const SizedBox(height: 16),
                  Text(context.l10n.noLedgerEntriesFound,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 8),
                  Text(context.l10n.tryChangingSearchFilters,
                      style: Theme.of(context).textTheme.bodyMedium),
                  if (_fromDate != null ||
                      _toDate != null ||
                      _selectedType != null ||
                      _selectedWallet != null) ...[
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () => _clearFilters(context),
                      child: Text(context.l10n.clearFilters),
                    ),
                  ]
                ],
              ),
            );
          }
          if (state is LedgerLoaded) {
            return RefreshIndicator(
              onRefresh: () async => _applyFilters(context),
              child: Column(
                children: [
                  if (_fromDate != null ||
                      _toDate != null ||
                      _selectedType != null ||
                      _selectedWallet != null)
                    _buildActiveFiltersRow(context),
                  Expanded(
                    child: ListView.builder(
                      controller: _scrollController,
                      padding: const EdgeInsets.all(16),
                      itemCount: state.entries.length + (state.hasMore ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == state.entries.length) {
                          return const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        return _LedgerEntryCard(entry: state.entries[index]);
                      },
                    ),
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildActiveFiltersRow(BuildContext context) {
    return Container(
      color: Theme.of(context)
          .colorScheme
          .surfaceContainerHighest
          .withValues(alpha: 0.4),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Text('${context.l10n.active}: ',
                      style: const TextStyle(
                          fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 4),
                  if (_fromDate != null || _toDate != null)
                    _buildFilterChip(
                      label:
                          '${_fromDate != null ? DateFormatter.format(_fromDate!) : ''} - ${_toDate != null ? DateFormatter.format(_toDate!) : ''}',
                      onDeleted: () {
                        setState(() {
                          _fromDate = null;
                          _toDate = null;
                        });
                        _applyFilters(context);
                      },
                    ),
                  if (_selectedType != null)
                    _buildFilterChip(
                      label: _selectedType!.getLocalizedLabel(context),
                      onDeleted: () {
                        setState(() => _selectedType = null);
                        _applyFilters(context);
                      },
                    ),
                  if (_selectedWallet != null)
                    _buildFilterChip(
                      label: _selectedWallet!.name,
                      onDeleted: () {
                        setState(() => _selectedWallet = null);
                        _applyFilters(context);
                      },
                    ),
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () => _clearFilters(context),
            style: TextButton.styleFrom(visualDensity: VisualDensity.compact),
            child: Text(context.l10n.clearFilters),
          )
        ],
      ),
    );
  }

  Widget _buildFilterChip(
      {required String label, required VoidCallback onDeleted}) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Flexible(
            child: Text(
              label,
              style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.primary,
                  fontWeight: FontWeight.w500),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onDeleted,
            child: const Icon(Icons.close, size: 12, color: AppColors.primary),
          )
        ],
      ),
    );
  }

  void _showFilterSheet(BuildContext context) {
    final ledgerBloc = context.read<LedgerBloc>();
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return BlocProvider.value(
          value: ledgerBloc,
          child: StatefulBuilder(
            builder: (stContext, setSheetState) {
              return Padding(
                padding: EdgeInsets.fromLTRB(16, 16, 16,
                    MediaQuery.of(stContext).viewInsets.bottom + 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(stContext.l10n.filterLedger,
                            style: Theme.of(stContext)
                                .textTheme
                                .titleLarge
                                ?.copyWith(fontWeight: FontWeight.bold)),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.pop(sheetContext),
                        )
                      ],
                    ),
                    const Divider(),
                    const SizedBox(height: 12),
                    // Date Range Pickers
                    Text(stContext.l10n.dateRange,
                        style: Theme.of(stContext).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: stContext,
                                initialDate: _fromDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setSheetState(() => _fromDate = date);
                              }
                            },
                            icon: const Icon(Icons.calendar_today, size: 16),
                            label: Text(_fromDate == null
                                ? stContext.l10n.fromDate
                                : DateFormatter.format(_fromDate!)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () async {
                              final date = await showDatePicker(
                                context: stContext,
                                initialDate: _toDate ?? DateTime.now(),
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                              );
                              if (date != null) {
                                setSheetState(() => _toDate = date);
                              }
                            },
                            icon: const Icon(Icons.calendar_today, size: 16),
                            label: Text(_toDate == null
                                ? stContext.l10n.toDate
                                : DateFormatter.format(_toDate!)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Transaction Type
                    Text(stContext.l10n.transactionType,
                        style: Theme.of(stContext).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<TransactionType>(
                      initialValue: _selectedType,
                      hint: Text(stContext.l10n.allTypes),
                      items: TransactionType.values.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type.getLocalizedLabel(stContext)),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setSheetState(() => _selectedType = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    // Wallet account
                    Text(stContext.l10n.wallets,
                        style: Theme.of(stContext).textTheme.titleSmall),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<WalletAccountEntity>(
                      initialValue: _selectedWallet,
                      hint: Text(stContext.l10n.allWallets),
                      items: _wallets.map((wallet) {
                        return DropdownMenuItem(
                          value: wallet,
                          child: Text(wallet.name),
                        );
                      }).toList(),
                      onChanged: (val) {
                        setSheetState(() => _selectedWallet = val);
                      },
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton(
                            onPressed: () {
                              _clearFilters(context);
                              Navigator.pop(sheetContext);
                            },
                            child: Text(stContext.l10n.clearFilters),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () {
                              _applyFilters(context);
                              Navigator.pop(sheetContext);
                            },
                            child: Text(stContext.l10n.applyFilters),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _LedgerEntryCard extends StatelessWidget {
  final LedgerEntryEntity entry;
  const _LedgerEntryCard({required this.entry});

  @override
  Widget build(BuildContext context) {
    final isDebit = entry.debit > 0;
    final double amount = isDebit ? entry.debit : entry.credit;
    final Color badgeColor = isDebit ? AppColors.debit : AppColors.creditEntry;
    final IconData icon = _getTransactionIcon(entry.transactionType);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () => context.push('/ledger/${entry.id}'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(icon, color: badgeColor, size: 24),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          entry.description,
                          style: const TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 15),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .outlineVariant
                                    .withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                entry.transactionType
                                    .getLocalizedLabel(context),
                                style: const TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                entry.referenceNumber,
                                style: Theme.of(context).textTheme.bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 110),
                        child: FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerRight,
                          child: Text(
                            '${isDebit ? '-' : '+'}${CurrencyFormatter.format(amount)}',
                            style: TextStyle(
                              color: badgeColor,
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        DateFormatter.getRelativeLabel(context, entry.date),
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  )
                ],
              ),
              const Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_wallet,
                            size: 14, color: AppColors.textSecondaryLight),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            entry.walletName ?? 'No Wallet',
                            style: Theme.of(context).textTheme.bodySmall,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('${context.l10n.walletBal}: ',
                          style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondaryLight)),
                      Text(
                        CurrencyFormatter.format(entry.walletBalance),
                        style: Theme.of(context)
                            .textTheme
                            .bodySmall
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                    ],
                  )
                ],
              )
            ],
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
      case TransactionType.walletAdjustment:
        return Icons.tune_outlined;
      case TransactionType.openingBalance:
        return Icons.home_outlined;
      case TransactionType.expense:
        return Icons.receipt_long_outlined;
    }
  }
}
