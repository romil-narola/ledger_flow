import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../supplier.dart';

class OutstandingSummaryScreen extends StatelessWidget {
  const OutstandingSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SupplierBloc>()..add(const LoadOutstandingSummary()),
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.supplierOutstanding)),
        body: BlocBuilder<SupplierBloc, SupplierState>(
          builder: (context, state) {
            if (state is SupplierLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is OutstandingSummaryLoaded) {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppColors.errorGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.totalOutstanding,
                            style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.format(state.totalOutstanding),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800),
                        ),
                        Text(
                            '${state.suppliers.length} ${context.l10n.suppliers.toLowerCase()}',
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  if (state.suppliers.isEmpty)
                    Expanded(
                        child: Center(
                            child: Text(context.l10n.noOutstandingSuppliers)))
                  else
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.suppliers.length,
                        itemBuilder: (context, i) {
                          final s = state.suppliers[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    AppColors.avatarColorForName(s.name)
                                        .withValues(alpha: 0.15),
                                child: Text(s.name[0],
                                    style: TextStyle(
                                        color: AppColors.avatarColorForName(
                                            s.name),
                                        fontWeight: FontWeight.w700)),
                              ),
                              title: Text(s.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              subtitle: Text(
                                  '${context.l10n.totalPurchases}: ${CurrencyFormatter.formatCard(s.totalPurchases)}'),
                              trailing: Text(
                                CurrencyFormatter.format(s.outstanding),
                                style: const TextStyle(
                                    color: AppColors.error,
                                    fontWeight: FontWeight.w700),
                              ),
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

class CreditSummaryScreen extends StatelessWidget {
  const CreditSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SupplierBloc>()..add(const LoadCreditSummary()),
      child: Scaffold(
        appBar: AppBar(title: Text(context.l10n.supplierCredit)),
        body: BlocBuilder<SupplierBloc, SupplierState>(
          builder: (context, state) {
            if (state is SupplierLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is CreditSummaryLoaded) {
              return Column(
                children: [
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.all(16),
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      gradient: AppColors.successGradient,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(context.l10n.creditSummary,
                            style: const TextStyle(color: Colors.white70)),
                        const SizedBox(height: 4),
                        Text(
                          CurrencyFormatter.format(state.totalCredit),
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 28,
                              fontWeight: FontWeight.w800),
                        ),
                        Text(
                            '${state.suppliers.length} ${context.l10n.suppliers.toLowerCase()}',
                            style: const TextStyle(color: Colors.white70)),
                      ],
                    ),
                  ),
                  if (state.suppliers.isEmpty)
                    Expanded(
                        child:
                            Center(child: Text(context.l10n.noSupplierCredits)))
                  else
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        itemCount: state.suppliers.length,
                        itemBuilder: (context, i) {
                          final s = state.suppliers[i];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor:
                                    AppColors.avatarColorForName(s.name)
                                        .withValues(alpha: 0.15),
                                child: Text(s.name[0],
                                    style: TextStyle(
                                        color: AppColors.avatarColorForName(
                                            s.name),
                                        fontWeight: FontWeight.w700)),
                              ),
                              title: Text(s.name,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w600)),
                              subtitle:
                                  Text(context.l10n.autoAppliesToNextPurchase),
                              trailing: Text(
                                CurrencyFormatter.format(s.creditBalance),
                                style: const TextStyle(
                                    color: AppColors.success,
                                    fontWeight: FontWeight.w700),
                              ),
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
