import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../supplier.dart';

class SupplierLedgerScreen extends StatelessWidget {
  final int supplierId;
  const SupplierLedgerScreen({super.key, required this.supplierId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SupplierBloc>()..add(LoadSupplierLedger(supplierId)),
      child: _SupplierLedgerView(supplierId: supplierId),
    );
  }
}

class _SupplierLedgerView extends StatefulWidget {
  final int supplierId;
  const _SupplierLedgerView({required this.supplierId});

  @override
  State<_SupplierLedgerView> createState() => _SupplierLedgerViewState();
}

class _SupplierLedgerViewState extends State<_SupplierLedgerView>
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
    return BlocBuilder<SupplierBloc, SupplierState>(
      builder: (context, state) {
        String title = 'Supplier Ledger';

        if (state is SupplierDetailLoaded) {
          title = state.supplier.name;
        } else if (state is SupplierLedgerLoaded) {
          title = state.supplier.name;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            actions: [
              IconButton(
                onPressed: () => context.go('/suppliers/purchase',
                    extra: {'supplierId': widget.supplierId}),
                icon: const Icon(Icons.shopping_cart_outlined),
                tooltip: context.l10n.addPurchase,
              ),
              IconButton(
                onPressed: () => context.go('/suppliers/payment',
                    extra: {'supplierId': widget.supplierId}),
                icon: const Icon(Icons.payment_outlined),
                tooltip: context.l10n.addPayment,
              ),
            ],
            bottom: TabBar(
              controller: _tabController,
              tabs: [
                Tab(text: context.l10n.summary),
                Tab(text: context.l10n.transactions),
                Tab(text: context.l10n.ledger),
              ],
            ),
          ),
          body: state is SupplierLoading
              ? const Center(child: CircularProgressIndicator())
              : TabBarView(
                  controller: _tabController,
                  children: [
                    _buildSummaryTab(context, state),
                    _buildTransactionsTab(context, state),
                    _buildLedgerTab(context, state),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildSummaryTab(BuildContext context, SupplierState state) {
    if (state is! SupplierDetailLoaded && state is! SupplierLedgerLoaded) {
      return const Center(child: CircularProgressIndicator());
    }
    final SupplierEntity supplier;
    if (state is SupplierDetailLoaded) {
      supplier = state.supplier;
    } else if (state is SupplierLedgerLoaded) {
      supplier = state.supplier;
    } else {
      return const SizedBox.shrink();
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Contact Info
        _SectionCard(
          title: context.l10n.contactInfo,
          children: [
            if (supplier.phone != null)
              _InfoRow(label: context.l10n.phone, value: supplier.phone!),
            if (supplier.email != null)
              _InfoRow(label: context.l10n.email, value: supplier.email!),
            if (supplier.address != null)
              _InfoRow(label: context.l10n.address, value: supplier.address!),
            if (supplier.phone == null &&
                supplier.email == null &&
                supplier.address == null)
              Text(context.l10n.noContactInfo),
          ],
        ),
        const SizedBox(height: 16),
        // Financial Summary
        _SectionCard(
          title: context.l10n.financialSummary,
          children: [
            _FinancialRow(
                label: context.l10n.totalPurchases,
                value: supplier.totalPurchases,
                color: AppColors.error),
            _FinancialRow(
                label: context.l10n.totalPayments,
                value: supplier.totalPayments,
                color: AppColors.success),
            const Divider(),
            _FinancialRow(
                label: context.l10n.outstanding,
                value: supplier.outstanding,
                color: AppColors.error,
                isBold: true),
            if (supplier.creditBalance > 0)
              _FinancialRow(
                  label: context.l10n.creditBalance,
                  value: supplier.creditBalance,
                  color: AppColors.success,
                  isBold: true),
          ],
        ),
      ],
    );
  }

  Widget _buildTransactionsTab(BuildContext context, SupplierState state) {
    final List<PurchaseEntity> purchases;
    final List<SupplierPaymentEntity> payments;

    if (state is SupplierDetailLoaded) {
      purchases = state.purchases;
      payments = state.payments;
    } else if (state is SupplierLedgerLoaded) {
      purchases = state.purchases;
      payments = state.payments;
    } else {
      return Center(child: Text(context.l10n.loading));
    }

    final allTxs = <Map<String, dynamic>>[
      ...purchases.map((p) => {'type': 'purchase', 'data': p}),
      ...payments.map((p) => {'type': 'payment', 'data': p}),
    ]..sort((a, b) {
        final dateA = a['type'] == 'purchase'
            ? (a['data'] as PurchaseEntity).date
            : (a['data'] as SupplierPaymentEntity).date;
        final dateB = b['type'] == 'purchase'
            ? (b['data'] as PurchaseEntity).date
            : (b['data'] as SupplierPaymentEntity).date;
        return dateB.compareTo(dateA);
      });

    if (allTxs.isEmpty) {
      return Center(child: Text(context.l10n.noTransactionsYet));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: allTxs.length,
      itemBuilder: (context, i) {
        final tx = allTxs[i];
        if (tx['type'] == 'purchase') {
          return _PurchaseTile(purchase: tx['data'] as PurchaseEntity);
        }
        return _PaymentTile(payment: tx['data'] as SupplierPaymentEntity);
      },
    );
  }

  Widget _buildLedgerTab(BuildContext context, SupplierState state) {
    if (state is! SupplierLedgerLoaded) {
      return Center(child: Text(context.l10n.loading));
    }
    if (state.entries.isEmpty) {
      return Center(child: Text(context.l10n.noLedgerEntries));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: state.entries.length,
      itemBuilder: (context, i) {
        final entry = state.entries[i];
        final isDebit = entry.debit > 0;
        final color = isDebit ? AppColors.error : AppColors.success;
        final amount = isDebit ? entry.debit : entry.credit;

        return Card(
          margin: const EdgeInsets.only(bottom: 8),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: color.withValues(alpha: 0.12),
              radius: 18,
              child: Icon(isDebit ? Icons.arrow_upward : Icons.arrow_downward,
                  color: color, size: 16),
            ),
            title: Text(entry.description,
                style: const TextStyle(fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis),
            subtitle: Text(
                '${entry.referenceNumber} · ${DateFormatter.format(entry.date)}',
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
}

class _SectionCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  const _SectionCard({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.w700)),
            const Divider(height: 16),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final String label;
  final String value;
  const _InfoRow({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
              width: 80,
              child: Text(label, style: Theme.of(context).textTheme.bodySmall)),
          Expanded(
              child:
                  Text(value, style: Theme.of(context).textTheme.bodyMedium)),
        ],
      ),
    );
  }
}

class _FinancialRow extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final bool isBold;
  const _FinancialRow(
      {required this.label,
      required this.value,
      required this.color,
      this.isBold = false});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontWeight: isBold ? FontWeight.w600 : null)),
          Text(
            CurrencyFormatter.format(value),
            style: TextStyle(
                color: color,
                fontWeight: isBold ? FontWeight.w700 : FontWeight.w500),
          ),
        ],
      ),
    );
  }
}

class _PurchaseTile extends StatelessWidget {
  final PurchaseEntity purchase;
  const _PurchaseTile({required this.purchase});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.errorBg,
          radius: 18,
          child: const Icon(Icons.shopping_cart_outlined,
              color: AppColors.error, size: 16),
        ),
        title: Text('${context.l10n.purchase} · ${purchase.referenceNumber}',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        subtitle: Text(DateFormatter.format(purchase.date),
            style: Theme.of(context).textTheme.bodySmall),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(CurrencyFormatter.format(purchase.amount),
                style: const TextStyle(
                    color: AppColors.error,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
            if (purchase.creditApplied > 0)
              Text(
                  '${context.l10n.credit}: ${CurrencyFormatter.formatCard(purchase.creditApplied)}',
                  style:
                      const TextStyle(color: AppColors.success, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final SupplierPaymentEntity payment;
  const _PaymentTile({required this.payment});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.successBg,
          radius: 18,
          child: const Icon(Icons.payment_outlined,
              color: AppColors.success, size: 16),
        ),
        title: Text(
            '${context.l10n.supplierPayment} · ${payment.referenceNumber}',
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500)),
        subtitle: Text(DateFormatter.format(payment.date),
            style: Theme.of(context).textTheme.bodySmall),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(CurrencyFormatter.format(payment.amount),
                style: const TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w600,
                    fontSize: 13)),
            if (payment.creditGenerated > 0)
              Text(
                  '${context.l10n.credit}: ${CurrencyFormatter.formatCard(payment.creditGenerated)}',
                  style:
                      const TextStyle(color: AppColors.warning, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}
