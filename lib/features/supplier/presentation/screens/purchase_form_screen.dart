import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../wallet/wallet.dart';
import '../../supplier.dart';

/// Purchase entry form - records a purchase from a supplier
class PurchaseFormScreen extends StatefulWidget {
  final int? preselectedSupplierId;
  const PurchaseFormScreen({super.key, this.preselectedSupplierId});

  @override
  State<PurchaseFormScreen> createState() => _PurchaseFormScreenState();
}

class _PurchaseFormScreenState extends State<PurchaseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _paidAmountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  SupplierEntity? _selectedSupplier;
  WalletAccountEntity? _selectedWallet;
  List<SupplierEntity> _suppliers = [];
  List<WalletAccountEntity> _wallets = [];
  bool _payImmediately = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onAmountChanged);
    _loadData();
  }

  void _onAmountChanged() {
    if (_payImmediately) {
      _paidAmountController.text = _amountController.text;
    }
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
    _amountController.removeListener(_onAmountChanged);
    _amountController.dispose();
    _notesController.dispose();
    _paidAmountController.dispose();
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
          return Scaffold(
            appBar: AppBar(title: Text(context.l10n.newPurchase)),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Business rule info card
                  _InfoCard(
                    text: context.l10n.purchaseInfoBanner,
                    color: AppColors.infoBg,
                    iconColor: AppColors.info,
                  ),
                  const SizedBox(height: 16),

                  // Date picker
                  _DatePickerField(
                    date: _selectedDate,
                    onDateSelected: (d) => setState(() => _selectedDate = d),
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(s.name),
                                  if (s.creditBalance > 0)
                                    Text(context.l10n.creditAvailable,
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.success)),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedSupplier = v),
                    validator: (v) =>
                        v == null ? context.l10n.selectSupplier : null,
                  ),
                  const SizedBox(height: 16),

                  // Show credit info if supplier has credit
                  if (_selectedSupplier != null &&
                      _selectedSupplier!.creditBalance > 0)
                    Card(
                      color: AppColors.successBg,
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            const Icon(Icons.savings, color: AppColors.success),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Credit of ₹${_selectedSupplier!.creditBalance.toStringAsFixed(2)} will be auto-applied',
                                style: const TextStyle(
                                    color: AppColors.success, fontSize: 13),
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
                      labelText: _payImmediately
                          ? '${context.l10n.paymentWalletAccount} *'
                          : '${context.l10n.associatedWalletAccount} *',
                      prefixIcon:
                          const Icon(Icons.account_balance_wallet_outlined),
                    ),
                    items: _wallets
                        .map((w) => DropdownMenuItem(
                              value: w,
                              child: Text(
                                  '${w.name} (₹${w.currentBalance.toStringAsFixed(0)})'),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedWallet = v),
                    validator: (v) =>
                        v == null ? context.l10n.selectWallet : null,
                  ),
                  const SizedBox(height: 16),

                  // Amount
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: '${context.l10n.purchaseAmount} *',
                      prefixIcon: const Icon(Icons.currency_rupee),
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
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Paid Immediately Switch
                  SwitchListTile(
                    title: Text(context.l10n.paidImmediately),
                    subtitle: Text(context.l10n.recordPaymentAndDeductWallet),
                    value: _payImmediately,
                    onChanged: (val) {
                      setState(() {
                        _payImmediately = val;
                        if (val) {
                          _paidAmountController.text = _amountController.text;
                        } else {
                          _paidAmountController.clear();
                        }
                      });
                    },
                    activeThumbColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                  ),

                  // Paid Amount Field (if Paid Immediately is enabled)
                  if (_payImmediately) ...[
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: _paidAmountController,
                      decoration: InputDecoration(
                        labelText: '${context.l10n.paidAmount} *',
                        prefixIcon: const Icon(Icons.payment),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (!_payImmediately) return null;
                        if (v == null || v.trim().isEmpty) {
                          return context.l10n.paidAmountRequired;
                        }
                        final paid = double.tryParse(v);
                        if (paid == null || paid <= 0) {
                          return context.l10n.invalidAmount;
                        }
                        final purchase =
                            double.tryParse(_amountController.text) ?? 0.0;
                        if (paid > purchase) {
                          return context.l10n.paidAmountCannotExceed;
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 16),

                  // Notes
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
                    icon: const Icon(Icons.shopping_cart_checkout),
                    label: Text(context.l10n.recordPurchase),
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
    if (_selectedSupplier == null || _selectedWallet == null) return;

    final paid =
        _payImmediately ? double.tryParse(_paidAmountController.text) : null;

    context.read<SupplierBloc>().add(AddPurchaseRequested(
          supplierId: _selectedSupplier!.id,
          walletAccountId: _selectedWallet!.id,
          amount: double.parse(_amountController.text),
          date: _selectedDate,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          paidAmount: paid,
        ));
  }
}

class _InfoCard extends StatelessWidget {
  final String text;
  final Color color;
  final Color iconColor;

  const _InfoCard(
      {required this.text, required this.color, required this.iconColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: iconColor, size: 20),
          const SizedBox(width: 8),
          Expanded(
              child:
                  Text(text, style: TextStyle(color: iconColor, fontSize: 13))),
        ],
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  final DateTime date;
  final ValueChanged<DateTime> onDateSelected;

  const _DatePickerField({required this.date, required this.onDateSelected});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: date,
          firstDate: DateTime(2000),
          lastDate: DateTime.now(),
        );
        if (picked != null) onDateSelected(picked);
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: '${context.l10n.date} *',
          prefixIcon: const Icon(Icons.calendar_today_outlined),
        ),
        child: Text(DateFormatter.format(date)),
      ),
    );
  }
}
