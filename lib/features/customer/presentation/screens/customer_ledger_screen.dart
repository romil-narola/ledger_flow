import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../customer.dart';

class CustomerLedgerScreen extends StatelessWidget {
  final int customerId;
  const CustomerLedgerScreen({super.key, required this.customerId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CustomerBloc>()..add(LoadCustomerLedger(customerId)),
      child: _CustomerLedgerView(customerId: customerId),
    );
  }
}

class _CustomerLedgerView extends StatefulWidget {
  final int customerId;
  const _CustomerLedgerView({required this.customerId});

  @override
  State<_CustomerLedgerView> createState() => _CustomerLedgerViewState();
}

class _CustomerLedgerViewState extends State<_CustomerLedgerView>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CustomerBloc, CustomerState>(
      builder: (context, state) {
        String title = 'Customer Ledger';
        if (state is CustomerDetailLoaded) {
          title = state.customer.name;
        } else if (state is CustomerLedgerLoaded) {
          title = state.customer.name;
        }
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
              IconButton(
                onPressed: () => context.go('/customers/sale',
                    extra: {'customerId': widget.customerId}),
                icon: const Icon(Icons.sell_outlined),
                tooltip: context.l10n.addSale,
              ),
              IconButton(
                onPressed: () => context.go('/customers/payment',
                    extra: {'customerId': widget.customerId}),
                icon: const Icon(Icons.payments_outlined),
                tooltip: context.l10n.addPayment,
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: context.l10n.summary),
                Tab(text: context.l10n.transactions),
                Tab(text: context.l10n.ledger)
              ],
            ),
          ),
          body: state is CustomerLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSummaryTab(state),
                    _buildTransactionsTab(state),
                    _buildLedgerTab(context, state),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildSummaryTab(CustomerState state) {
    CustomerEntity? customer;
    if (state is CustomerDetailLoaded) {
      customer = state.customer;
    } else if (state is CustomerLedgerLoaded) {
      customer = state.customer;
    }
    if (customer == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.contactInfo,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const Divider(height: 16),
                if (customer.phone != null)
                  _row(context.l10n.phone, customer.phone!),
                if (customer.email != null)
                  _row(context.l10n.email, customer.email!),
                if (customer.address != null)
                  _row(context.l10n.address, customer.address!),
                if (customer.phone == null &&
                    customer.email == null &&
                    customer.address == null)
                  Text(context.l10n.noContactInfo),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(context.l10n.financialSummary,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const Divider(height: 16),
                _financialRow(context.l10n.totalSales, customer.totalSales,
                    AppColors.primary),
                _financialRow(context.l10n.totalPayments,
                    customer.totalPayments, AppColors.success),
                const Divider(),
                _financialRow(context.l10n.outstanding, customer.outstanding,
                    AppColors.error,
                    bold: true),
                if (customer.advanceBalance > 0)
                  _financialRow(context.l10n.advanceBalance,
                      customer.advanceBalance, AppColors.success,
                      bold: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionsTab(CustomerState state) {
    final List<SaleEntity> sales;
    final List<CustomerPaymentEntity> payments;

    if (state is CustomerDetailLoaded) {
      sales = state.sales;
      payments = state.payments;
    } else if (state is CustomerLedgerLoaded) {
      sales = state.sales;
      payments = state.payments;
    } else {
      return Center(child: Text(context.l10n.loading));
    }

    final txs = <Map<String, dynamic>>[
      ...sales.map((s) => {'type': 'sale', 'data': s}),
      ...payments.map((p) => {'type': 'payment', 'data': p}),
    ]..sort((a, b) {
        final dateA = a['type'] == 'sale'
            ? (a['data'] as SaleEntity).date
            : (a['data'] as CustomerPaymentEntity).date;
        final dateB = b['type'] == 'sale'
            ? (b['data'] as SaleEntity).date
            : (b['data'] as CustomerPaymentEntity).date;
        return dateB.compareTo(dateA);
      });

    if (txs.isEmpty) return Center(child: Text(context.l10n.noTransactionsYet));

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: txs.length,
      itemBuilder: (context, i) {
        final tx = txs[i];
        if (tx['type'] == 'sale') {
          final s = tx['data'] as SaleEntity;
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              leading: const CircleAvatar(
                backgroundColor: AppColors.infoBg,
                radius: 18,
                child:
                    Icon(Icons.sell_outlined, color: AppColors.info, size: 16),
              ),
              title: Text('${context.l10n.sale} · ${s.referenceNumber}',
                  style: const TextStyle(
                      fontSize: 13, fontWeight: FontWeight.w500)),
              subtitle: Text(DateFormatter.format(s.date),
                  style: Theme.of(context).textTheme.bodySmall),
              trailing: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(CurrencyFormatter.format(s.amount),
                      style: const TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 13)),
                  if (s.advanceApplied > 0)
                    Text(
                        '${context.l10n.adv}: ${CurrencyFormatter.formatCard(s.advanceApplied)}',
                        style: const TextStyle(
                            color: AppColors.success, fontSize: 11)),
                ],
              ),
            ),
          );
        }
        final p = tx['data'] as CustomerPaymentEntity;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: const CircleAvatar(
              backgroundColor: AppColors.successBg,
              radius: 18,
              child: Icon(Icons.payments_outlined,
                  color: AppColors.success, size: 16),
            ),
            title: Text(
                '${context.l10n.customerPayment} · ${p.referenceNumber}',
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
            subtitle: Text(DateFormatter.format(p.date),
                style: Theme.of(context).textTheme.bodySmall),
            trailing: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(CurrencyFormatter.format(p.amount),
                    style: const TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w600,
                        fontSize: 13)),
                if (p.advanceGenerated > 0)
                  Text(
                      '${context.l10n.adv}: ${CurrencyFormatter.formatCard(p.advanceGenerated)}',
                      style: const TextStyle(
                          color: AppColors.warning, fontSize: 11)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLedgerTab(BuildContext context, CustomerState state) {
    if (state is! CustomerLedgerLoaded) {
      return Center(child: Text(context.l10n.loading));
    }
    if (state.entries.isEmpty) {
      return Center(child: Text(context.l10n.noLedgerEntries));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.entries.length,
      itemBuilder: (ctx, i) {
        final e = state.entries[i];
        final isDebit = e.debit > 0;
        final color = isDebit ? AppColors.success : AppColors.error;
        final amount = isDebit ? e.debit : e.credit;
        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.12),
              radius: 18,
              child: Icon(isDebit ? Icons.arrow_downward : Icons.arrow_upward,
                  color: color, size: 16),
            ),
            title: Text(e.description,
                style: const TextStyle(fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            subtitle: Text(
                '${e.referenceNumber} · ${DateFormatter.format(e.date)}',
                style: Theme.of(context).textTheme.bodySmall),
            trailing: Text(
              '${isDebit ? '+' : '-'}${CurrencyFormatter.formatCard(amount)}',
              style: TextStyle(
                  color: color, fontWeight: FontWeight.w700, fontSize: 13),
            ),
          ),
        );
      },
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        children: [
          SizedBox(
              width: 80,
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondaryLight))),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _financialRow(String label, double value, Color color,
      {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: TextStyle(fontWeight: bold ? FontWeight.w600 : null)),
          Text(CurrencyFormatter.format(value),
              style: TextStyle(
                  color: color,
                  fontWeight: bold ? FontWeight.w700 : FontWeight.w500)),
        ],
      ),
    );
  }
}

class CustomerOutstandingScreen extends StatelessWidget {
  const CustomerOutstandingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<CustomerBloc>()..add(const LoadCustomerOutstandingSummary()),
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.customerOutstanding)),
        body: BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            if (state is CustomerLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CustomerOutstandingSummaryLoaded) {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        gradient: AppColors.warningGradient,
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.totalOutstanding,
                            style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 4),
                        Text(CurrencyFormatter.format(state.totalOutstanding),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w800)),
                        Text(
                            '${state.customers.length} ${context.l10n.customers.toLowerCase()}',
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  if (state.customers.isEmpty)
                    Expanded(
                        child: Center(
                            child: Text(context.l10n.noOutstandingCustomers)))
                  else
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.customers.length,
                        itemBuilder: (ctx, i) {
                          final c = state.customers[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    AppColors.avatarColorForName(c.name)
                                        .withValues(alpha: 0.15),
                                child: Text(c.name[0],
                                    style: TextStyle(
                                        color: AppColors.avatarColorForName(
                                            c.name),
                                        fontWeight: FontWeight.w700)),
                              ),
                              title: Text(c.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                  '${context.l10n.totalSales}: ${CurrencyFormatter.formatCard(c.totalSales)}'),
                              trailing: Text(
                                  CurrencyFormatter.format(c.outstanding),
                                  style: const TextStyle(
                                      color: AppColors.warning,
                                      fontWeight: FontWeight.w700)),
                            ),
                          );
                        },
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
}

class CustomerAdvanceScreen extends StatelessWidget {
  const CustomerAdvanceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) =>
          sl<CustomerBloc>()..add(const LoadCustomerAdvanceSummary()),
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.customerAdvance)),
        body: BlocBuilder<CustomerBloc, CustomerState>(
          builder: (context, state) {
            if (state is CustomerLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CustomerAdvanceSummaryLoaded) {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                        gradient: AppColors.tealGradient,
                        borderRadius: BorderRadius.circular(16)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.totalAdvanceBalance,
                            style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 4),
                        Text(CurrencyFormatter.format(state.totalAdvance),
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 28,
                                fontWeight: FontWeight.w800)),
                        Text(
                            '${state.customers.length} ${context.l10n.customers.toLowerCase()}',
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  if (state.customers.isEmpty)
                    Expanded(
                        child:
                            Center(child: Text(context.l10n.noAdvanceBalances)))
                  else
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.customers.length,
                        itemBuilder: (ctx, i) {
                          final c = state.customers[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    AppColors.avatarColorForName(c.name)
                                        .withValues(alpha: 0.15),
                                child: Text(c.name[0],
                                    style: TextStyle(
                                        color: AppColors.avatarColorForName(
                                            c.name),
                                        fontWeight: FontWeight.w700)),
                              ),
                              title: Text(c.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              subtitle:
                                  Text(context.l10n.autoAppliesToNextSale),
                              trailing: Text(
                                  CurrencyFormatter.format(c.advanceBalance),
                                  style: const TextStyle(
                                      color: AppColors.success,
                                      fontWeight: FontWeight.w700)),
                            ),
                          );
                        },
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
}
