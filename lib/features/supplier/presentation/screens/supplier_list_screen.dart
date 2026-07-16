import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../supplier.dart';

class SupplierListScreen extends StatefulWidget {
  const SupplierListScreen({super.key});

  @override
  State<SupplierListScreen> createState() => _SupplierListScreenState();
}

class _SupplierListScreenState extends State<SupplierListScreen> {
  final _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SupplierBloc>()..add(const WatchSuppliersStarted()),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.suppliers),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: context.l10n.searchSuppliers,
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () {
                              _searchController.clear();
                              setState(() => _searchQuery = '');
                            },
                          )
                        : null,
                    isDense: true,
                  ),
                  onChanged: (v) =>
                      setState(() => _searchQuery = v.toLowerCase()),
                ),
              ),
            ),
            actions: [
              IconButton(
                onPressed: () => showDialog(
                  context: context,
                  builder: (_) => const LanguageSelectorDialog(),
                ),
                icon: const Icon(Icons.language),
                tooltip: context.l10n.language,
              ),
              PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'outstanding') context.go('/suppliers/outstanding');
                  if (v == 'credit') context.go('/suppliers/credit');
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                      value: 'outstanding',
                      child: Text(context.l10n.outstandingSummary)),
                  PopupMenuItem(
                      value: 'credit', child: Text(context.l10n.creditSummary)),
                ],
              ),
            ],
          ),
          body: BlocConsumer<SupplierBloc, SupplierState>(
            listener: (context, state) {
              if (state is SupplierOperationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          translateBlocMessage(state.message, context.l10n)),
                      backgroundColor: AppColors.success),
                );
              } else if (state is SupplierError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          translateBlocMessage(state.message, context.l10n)),
                      backgroundColor: AppColors.error),
                );
              }
            },
            builder: (context, state) {
              if (state is SupplierLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is SupplierEmpty) {
                return _buildEmpty(context);
              }
              if (state is SupplierListLoaded) {
                final filtered = _searchQuery.isEmpty
                    ? state.suppliers
                    : state.suppliers
                        .where(
                            (s) => s.name.toLowerCase().contains(_searchQuery))
                        .toList();
                return _buildList(context, filtered);
              }
              return const SizedBox.shrink();
            },
          ),
          floatingActionButton: AssistiveQuickMenu(
            heroTag: 'supplier_quick_menu',
            items: [
              QuickMenuItem(
                label: context.l10n.addSupplier,
                icon: Icons.person_add_rounded,
                color: AppColors.primary,
                onTap: () => context.go('/suppliers/add'),
              ),
              QuickMenuItem(
                label: context.l10n.recordPurchase,
                icon: Icons.shopping_cart_rounded,
                color: AppColors.warning,
                onTap: () => context.go('/suppliers/purchase'),
              ),
              QuickMenuItem(
                label: context.l10n.recordPayment,
                icon: Icons.payment_rounded,
                color: AppColors.primaryLight,
                onTap: () => context.go('/suppliers/payment'),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people_outline,
              size: 80, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 16),
          Text(context.l10n.noSuppliersYet,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/suppliers/add'),
            icon: const Icon(Icons.add),
            label: Text(context.l10n.addSupplier),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<SupplierEntity> suppliers) {
    if (suppliers.isEmpty) {
      return Center(child: Text(context.l10n.noResultsFound));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: suppliers.length,
      itemBuilder: (context, i) => _SupplierCard(supplier: suppliers[i]),
    );
  }
}

class _SupplierCard extends StatelessWidget {
  final SupplierEntity supplier;
  const _SupplierCard({required this.supplier});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.avatarColorForName(supplier.name);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.go('/suppliers/${supplier.id}/ledger'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.15),
                radius: 24,
                child: Text(
                  supplier.name.substring(0, 1).toUpperCase(),
                  style: TextStyle(
                      color: color, fontWeight: FontWeight.w700, fontSize: 18),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(supplier.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    if (supplier.phone != null)
                      Text(supplier.phone!,
                          style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (supplier.outstanding > 0)
                          _StatusBadge(
                            label:
                                '${context.l10n.owes} ${CurrencyFormatter.formatCard(supplier.outstanding)}',
                            color: AppColors.error,
                          ),
                        if (supplier.outstanding > 0 &&
                            supplier.creditBalance > 0)
                          const SizedBox(width: 6),
                        if (supplier.creditBalance > 0)
                          _StatusBadge(
                            label:
                                '${context.l10n.credit} ${CurrencyFormatter.formatCard(supplier.creditBalance)}',
                            color: AppColors.success,
                          ),
                        if (supplier.outstanding == 0 &&
                            supplier.creditBalance == 0)
                          _StatusBadge(
                              label: context.l10n.settled,
                              color: AppColors.textSecondaryLight),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'purchase') {
                    context.go('/suppliers/purchase',
                        extra: {'supplierId': supplier.id});
                  }
                  if (v == 'payment') {
                    context.go('/suppliers/payment',
                        extra: {'supplierId': supplier.id});
                  }
                  if (v == 'edit') context.go('/suppliers/${supplier.id}/edit');
                  if (v == 'delete') _confirmDelete(context);
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                      value: 'purchase', child: Text(context.l10n.addPurchase)),
                  PopupMenuItem(
                      value: 'payment', child: Text(context.l10n.addPayment)),
                  PopupMenuItem(value: 'edit', child: Text(context.l10n.edit)),
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(context.l10n.delete,
                        style: const TextStyle(color: AppColors.error)),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(context.l10n.deleteSupplier),
        content: Text('${context.l10n.confirmDelete} ("${supplier.name}")'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(context.l10n.cancel)),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<SupplierBloc>()
                  .add(DeleteSupplierRequested(supplier.id));
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String label;
  final Color color;
  const _StatusBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
