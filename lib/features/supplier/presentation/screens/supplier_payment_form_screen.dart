import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../wallet/wallet.dart';
import '../../supplier.dart';

/// Supplier payment form - records a payment to a supplier
class SupplierPaymentFormScreen extends StatefulWidget {
  final int? preselectedSupplierId;
  const SupplierPaymentFormScreen({super.key, this.preselectedSupplierId});

  @override
  State<SupplierPaymentFormScreen> createState() =>
      _SupplierPaymentFormScreenState();
}

class _SupplierPaymentFormScreenState extends State<SupplierPaymentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  SupplierEntity? _selectedSupplier;
  WalletAccountEntity? _selectedWallet;
  List<SupplierEntity> _suppliers = [];
  List<WalletAccountEntity> _wallets = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final suppliers = await sl<GetSuppliers>()();
    final wallets = await sl<GetWallets>()();
    if (mounted) {
      setState(() {
        _suppliers = suppliers;
        _wallets = wallets;
        if (widget.preselectedSupplierId != null) {
          _selectedSupplier = suppliers.firstWhere(
            (s) => s.id == widget.preselectedSupplierId,
            orElse: () => suppliers.first,
          );
        }
        if (wallets.isNotEmpty) _selectedWallet = wallets.first;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<SupplierBloc>(),
      child: BlocConsumer<SupplierBloc, SupplierState>(
        listener: (context, state) {
          if (state is SupplierOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text(translateBlocMessage(state.message, context.l10n)),
                  backgroundColor: AppColors.success),
            );
            Navigator.pop(context);
          }
          if (state is SupplierError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text(translateBlocMessage(state.message, context.l10n)),
                  backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          final outstanding = _selectedSupplier?.outstanding ?? 0;

          return Scaffold(
            appBar: AppBar(title: Text(context.l10n.supplierPayment)),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Info card
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.warningBg,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.warning, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.l10n.supplierPaymentInfoBanner,
                            style: const TextStyle(
                                color: AppColors.warning, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date
                  InkWell(
                    onTap: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: _selectedDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime.now(),
                      );
                      if (picked != null) {
                        setState(() => _selectedDate = picked);
                      }
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: '${context.l10n.date} *',
                        prefixIcon: const Icon(Icons.calendar_today_outlined),
                      ),
                      child: Text(DateFormatter.format(_selectedDate)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Supplier dropdown
                  DropdownButtonFormField<SupplierEntity>(
                    initialValue: _selectedSupplier,
                    decoration: InputDecoration(
                      labelText: '${context.l10n.supplier} *',
                      prefixIcon: const Icon(Icons.business_outlined),
                    ),
                    items: _suppliers
                        .map((s) => DropdownMenuItem(
                              value: s,
                              child: Text(s.name),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedSupplier = v),
                    validator: (v) =>
                        v == null ? context.l10n.selectSupplier : null,
                  ),
                  const SizedBox(height: 8),

                  // Outstanding info
                  if (_selectedSupplier != null)
                    Card(
                      color: outstanding > 0
                          ? AppColors.errorBg
                          : AppColors.successBg,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(context.l10n.outstanding,
                                style: TextStyle(
                                    color: outstanding > 0
                                        ? AppColors.error
                                        : AppColors.success)),
                            Text(
                              CurrencyFormatter.format(outstanding),
                              style: TextStyle(
                                color: outstanding > 0
                                    ? AppColors.error
                                    : AppColors.success,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Wallet dropdown
                  DropdownButtonFormField<WalletAccountEntity>(
                    initialValue: _selectedWallet,
                    decoration: InputDecoration(
                      labelText: '${context.l10n.payFromWallet} *',
                      prefixIcon:
                          const Icon(Icons.account_balance_wallet_outlined),
                    ),
                    items: _wallets
                        .map((w) => DropdownMenuItem(
                              value: w,
                              child: Text(
                                  '${w.name} (${CurrencyFormatter.formatCard(w.currentBalance)})'),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedWallet = v),
                    validator: (v) =>
                        v == null ? context.l10n.selectWallet : null,
                  ),
                  const SizedBox(height: 16),

                  // Amount field with quick-fill button
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: '${context.l10n.paymentAmount} *',
                      prefixIcon: const Icon(Icons.currency_rupee),
                      suffix: outstanding > 0
                          ? InkWell(
                              onTap: () => _amountController.text =
                                  outstanding.toStringAsFixed(2),
                              child: Text(context.l10n.payAll),
                            )
                          : null,
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return context.l10n.amountRequired;
                      }
                      final amount = double.tryParse(v);
                      if (amount == null || amount <= 0) {
                        return context.l10n.invalidAmount;
                      }
                      if (_selectedWallet != null &&
                          !_selectedWallet!.overdraftEnabled &&
                          amount > _selectedWallet!.currentBalance) {
                        return '${context.l10n.insufficientWalletBalance} (${CurrencyFormatter.format(_selectedWallet!.currentBalance)})';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: context.l10n.notesOptional,
                      prefixIcon: const Icon(Icons.notes_outlined),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton.icon(
                    onPressed: state is SupplierLoading
                        ? null
                        : () => _submit(context),
                    icon: const Icon(Icons.payment),
                    label: Text(context.l10n.recordPaymentAction),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    context.read<SupplierBloc>().add(AddSupplierPaymentRequested(
          supplierId: _selectedSupplier!.id,
          walletAccountId: _selectedWallet!.id,
          amount: double.parse(_amountController.text),
          date: _selectedDate,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ));
  }
}
