import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../customer.dart';

class CustomerListScreen extends StatefulWidget {
  const CustomerListScreen({super.key});

  @override
  State<CustomerListScreen> createState() => _CustomerListScreenState();
}

class _CustomerListScreenState extends State<CustomerListScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CustomerBloc>()..add(const WatchCustomersStarted()),
      child: Builder(builder: (context) {
        return Scaffold(
          appBar: AppBar(
            title: Text(context.l10n.customers),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(60),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: context.l10n.searchCustomers,
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear),
                            onPressed: () => setState(() => _searchQuery = ''),
                          )
                        : null,
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
                  if (v == 'outstanding') context.go('/customers/outstanding');
                  if (v == 'advance') context.go('/customers/advance');
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                      value: 'outstanding',
                      child: Text(context.l10n.outstandingSummary)),
                  PopupMenuItem(
                      value: 'advance',
                      child: Text(context.l10n.advanceSummary)),
                ],
              ),
            ],
          ),
          body: BlocConsumer<CustomerBloc, CustomerState>(
            listener: (context, state) {
              if (state is CustomerOperationSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          translateBlocMessage(state.message, context.l10n)),
                      backgroundColor: AppColors.success),
                );
              } else if (state is CustomerError) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(
                          translateBlocMessage(state.message, context.l10n)),
                      backgroundColor: AppColors.error),
                );
              }
            },
            builder: (context, state) {
              if (state is CustomerLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (state is CustomerEmpty) return _buildEmpty(context);
              if (state is CustomerListLoaded) {
                final filtered = _searchQuery.isEmpty
                    ? state.customers
                    : state.customers
                        .where(
                            (c) => c.name.toLowerCase().contains(_searchQuery))
                        .toList();
                return _buildList(context, filtered);
              }
              return const SizedBox.shrink();
            },
          ),
          floatingActionButton: AssistiveQuickMenu(
            heroTag: 'customer_quick_menu',
            items: [
              QuickMenuItem(
                label: context.l10n.addCustomer,
                icon: Icons.person_add_rounded,
                color: AppColors.primary,
                onTap: () => context.go('/customers/add'),
              ),
              QuickMenuItem(
                label: context.l10n.recordSale,
                icon: Icons.sell_rounded,
                color: AppColors.success,
                onTap: () => context.go('/customers/sale'),
              ),
              QuickMenuItem(
                label: context.l10n.recordPayment,
                icon: Icons.payments_rounded,
                color: AppColors.primaryLight,
                onTap: () => context.go('/customers/payment'),
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
          Icon(Icons.person_outline,
              size: 80, color: Theme.of(context).colorScheme.outline),
          const SizedBox(height: 16),
          Text(context.l10n.noCustomersYet,
              style: Theme.of(context).textTheme.titleMedium),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => context.go('/customers/add'),
            icon: const Icon(Icons.add),
            label: Text(context.l10n.addCustomer),
          ),
        ],
      ),
    );
  }

  Widget _buildList(BuildContext context, List<CustomerEntity> customers) {
    if (customers.isEmpty) {
      return Center(child: Text(context.l10n.noResultsFound));
    }
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: customers.length,
      itemBuilder: (context, i) => _CustomerCard(customer: customers[i]),
    );
  }
}

class _CustomerCard extends StatelessWidget {
  final CustomerEntity customer;
  const _CustomerCard({required this.customer});

  @override
  Widget build(BuildContext context) {
    final color = AppColors.avatarColorForName(customer.name);
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => context.go('/customers/${customer.id}/ledger'),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(
                backgroundColor: color.withValues(alpha: 0.15),
                radius: 24,
                child: Text(customer.name[0].toUpperCase(),
                    style: TextStyle(
                        color: color,
                        fontWeight: FontWeight.w700,
                        fontSize: 18)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(customer.name,
                        style: Theme.of(context)
                            .textTheme
                            .titleSmall
                            ?.copyWith(fontWeight: FontWeight.w600)),
                    if (customer.phone != null)
                      Text(customer.phone!,
                          style: Theme.of(context).textTheme.bodySmall),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        if (customer.outstanding > 0)
                          _Badge(
                              label:
                                  '${context.l10n.owes} ${CurrencyFormatter.formatCard(customer.outstanding)}',
                              color: AppColors.error),
                        if (customer.outstanding > 0 &&
                            customer.advanceBalance > 0)
                          const SizedBox(width: 6),
                        if (customer.advanceBalance > 0)
                          _Badge(
                              label:
                                  '${context.l10n.adv} ${CurrencyFormatter.formatCard(customer.advanceBalance)}',
                              color: AppColors.success),
                        if (customer.outstanding == 0 &&
                            customer.advanceBalance == 0)
                          _Badge(
                              label: context.l10n.settled,
                              color: AppColors.textSecondaryLight),
                      ],
                    ),
                  ],
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (v) {
                  if (v == 'sale') {
                    context.go('/customers/sale',
                        extra: {'customerId': customer.id});
                  }
                  if (v == 'payment') {
                    context.go('/customers/payment',
                        extra: {'customerId': customer.id});
                  }
                  if (v == 'edit') context.go('/customers/${customer.id}/edit');
                  if (v == 'delete') _confirmDelete(context);
                },
                itemBuilder: (_) => [
                  PopupMenuItem(
                      value: 'sale', child: Text(context.l10n.addSale)),
                  PopupMenuItem(
                      value: 'payment', child: Text(context.l10n.addPayment)),
                  PopupMenuItem(value: 'edit', child: Text(context.l10n.edit)),
                  PopupMenuItem(
                      value: 'delete',
                      child: Text(context.l10n.delete,
                          style: const TextStyle(color: AppColors.error))),
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
        title: Text(context.l10n.deleteCustomer),
        content: Text('${context.l10n.confirmDelete} ("${customer.name}")'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(context.l10n.cancel)),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              context
                  .read<CustomerBloc>()
                  .add(DeleteCustomerRequested(customer.id));
            },
            style: TextButton.styleFrom(foregroundColor: AppColors.error),
            child: Text(context.l10n.delete),
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
          color: color.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(6)),
      child: Text(label,
          style: TextStyle(
              color: color, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}
