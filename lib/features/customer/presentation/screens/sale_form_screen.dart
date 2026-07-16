import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../wallet/wallet.dart';
import '../../customer.dart';

/// Sale entry form
class SaleFormScreen extends StatefulWidget {
  final int? preselectedCustomerId;
  const SaleFormScreen({super.key, this.preselectedCustomerId});

  @override
  State<SaleFormScreen> createState() => _SaleFormScreenState();
}

class _SaleFormScreenState extends State<SaleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  final _paidAmountController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  CustomerEntity? _selectedCustomer;
  WalletAccountEntity? _selectedWallet;
  List<CustomerEntity> _customers = [];
  List<WalletAccountEntity> _wallets = [];
  bool _receivePaymentImmediately = false;

  @override
  void initState() {
    super.initState();
    _amountController.addListener(_onAmountChanged);
    _loadData();
  }

  void _onAmountChanged() {
    if (_receivePaymentImmediately) {
      _paidAmountController.text = _amountController.text;
    }
  }

  Future<void> _loadData() async {
    final customers = await sl<GetCustomers>()();
    final wallets = await sl<GetWallets>()();
    if (mounted) {
      setState(() {
        _customers = customers;
        _wallets = wallets;
        if (widget.preselectedCustomerId != null) {
          _selectedCustomer = customers.firstWhere(
            (c) => c.id == widget.preselectedCustomerId,
            orElse: () => customers.first,
          );
        }
        if (wallets.isNotEmpty) {
          _selectedWallet = wallets.first;
        }
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
      create: (_) => sl<CustomerBloc>(),
      child: BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state is CustomerOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text(translateBlocMessage(state.message, context.l10n)),
                  backgroundColor: AppColors.success),
            );
            Navigator.pop(context);
          }
          if (state is CustomerError) {
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
            appBar: AppBar(title: Text(context.l10n.newSale)),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: AppColors.infoBg,
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.info, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.l10n.saleInfoBanner,
                            style: const TextStyle(
                                color: AppColors.info, fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

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
                          prefixIcon:
                              const Icon(Icons.calendar_today_outlined)),
                      child: Text(DateFormatter.format(_selectedDate)),
                    ),
                  ),
                  const SizedBox(height: 16),

                  DropdownButtonFormField<CustomerEntity>(
                    initialValue: _selectedCustomer,
                    decoration: InputDecoration(
                        labelText: '${context.l10n.customer} *',
                        prefixIcon: const Icon(Icons.person_outline)),
                    items: _customers
                        .map((c) => DropdownMenuItem(
                              value: c,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(c.name),
                                  if (c.advanceBalance > 0)
                                    Text(context.l10n.advanceAvailable,
                                        style: const TextStyle(
                                            fontSize: 11,
                                            color: AppColors.success)),
                                ],
                              ),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCustomer = v),
                    validator: (v) =>
                        v == null ? context.l10n.selectCustomer : null,
                  ),
                  const SizedBox(height: 8),

                  if (_selectedCustomer != null &&
                      _selectedCustomer!.advanceBalance > 0)
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
                                'Advance of ₹${_selectedCustomer!.advanceBalance.toStringAsFixed(2)} will be auto-applied',
                                style: const TextStyle(
                                    color: AppColors.success, fontSize: 13),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                        labelText: '${context.l10n.saleAmount} *',
                        prefixIcon: const Icon(Icons.currency_rupee)),
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

                  // Received Payment Immediately Switch
                  SwitchListTile(
                    title: Text(context.l10n.receivedPaymentImmediately),
                    subtitle: Text(context.l10n.recordPaymentAndDepositWallet),
                    value: _receivePaymentImmediately,
                    onChanged: (val) {
                      setState(() {
                        _receivePaymentImmediately = val;
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

                  // Conditional Wallet selection & Paid Amount
                  if (_receivePaymentImmediately) ...[
                    const SizedBox(height: 12),
                    DropdownButtonFormField<WalletAccountEntity>(
                      initialValue: _selectedWallet,
                      decoration: InputDecoration(
                        labelText: '${context.l10n.paymentWalletAccount} *',
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
                      validator: (v) => _receivePaymentImmediately && v == null
                          ? context.l10n.selectWallet
                          : null,
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _paidAmountController,
                      decoration: InputDecoration(
                        labelText: '${context.l10n.paidAmount} *',
                        prefixIcon: const Icon(Icons.payment),
                      ),
                      keyboardType:
                          const TextInputType.numberWithOptions(decimal: true),
                      validator: (v) {
                        if (!_receivePaymentImmediately) return null;
                        if (v == null || v.trim().isEmpty) {
                          return context.l10n.paidAmountRequired;
                        }
                        final paid = double.tryParse(v);
                        if (paid == null || paid <= 0) {
                          return context.l10n.invalidAmount;
                        }
                        final sale =
                            double.tryParse(_amountController.text) ?? 0.0;
                        if (paid > sale) {
                          return context.l10n.paidAmountCannotExceedSale;
                        }
                        return null;
                      },
                    ),
                  ],
                  const SizedBox(height: 16),

                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                        labelText: context.l10n.notesOptional,
                        prefixIcon: const Icon(Icons.notes_outlined)),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 32),

                  ElevatedButton.icon(
                    onPressed: state is CustomerLoading
                        ? null
                        : () => _submit(context),
                    icon: const Icon(Icons.sell_outlined),
                    label: Text(context.l10n.recordSale),
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
    if (_selectedCustomer == null) return;

    final walletId = _receivePaymentImmediately ? _selectedWallet?.id : null;
    final paid = _receivePaymentImmediately
        ? double.tryParse(_paidAmountController.text)
        : null;

    context.read<CustomerBloc>().add(AddSaleRequested(
          customerId: _selectedCustomer!.id,
          amount: double.parse(_amountController.text),
          date: _selectedDate,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
          walletAccountId: walletId,
          paidAmount: paid,
        ));
  }
}
