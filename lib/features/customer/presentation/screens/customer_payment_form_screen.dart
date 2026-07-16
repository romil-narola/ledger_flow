import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../wallet/wallet.dart';
import '../../customer.dart';

class CustomerPaymentFormScreen extends StatefulWidget {
  final int? preselectedCustomerId;
  const CustomerPaymentFormScreen({super.key, this.preselectedCustomerId});

  @override
  State<CustomerPaymentFormScreen> createState() =>
      _CustomerPaymentFormScreenState();
}

class _CustomerPaymentFormScreenState extends State<CustomerPaymentFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  CustomerEntity? _selectedCustomer;
  WalletAccountEntity? _selectedWallet;
  List<CustomerEntity> _customers = [];
  List<WalletAccountEntity> _wallets = [];

  @override
  void initState() {
    super.initState();
    _loadData();
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
          final outstanding = _selectedCustomer?.outstanding ?? 0;

          return Scaffold(
            appBar: AppBar(title: Text(context.l10n.customerPayment)),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        color: AppColors.successBg,
                        borderRadius: BorderRadius.circular(12)),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: AppColors.success, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.l10n.customerPaymentInfoBanner,
                            style: const TextStyle(
                                color: AppColors.success, fontSize: 13),
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
                        .map((c) =>
                            DropdownMenuItem(value: c, child: Text(c.name)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCustomer = v),
                    validator: (v) =>
                        v == null ? context.l10n.selectCustomer : null,
                  ),
                  const SizedBox(height: 8),
                  if (_selectedCustomer != null)
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
                  DropdownButtonFormField<WalletAccountEntity>(
                    initialValue: _selectedWallet,
                    decoration: InputDecoration(
                        labelText: '${context.l10n.receiveInWallet} *',
                        prefixIcon:
                            const Icon(Icons.account_balance_wallet_outlined)),
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
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: '${context.l10n.paymentAmount} *',
                      prefixIcon: const Icon(Icons.currency_rupee),
                      suffix: outstanding > 0
                          ? InkWell(
                              onTap: () => _amountController.text =
                                  outstanding.toStringAsFixed(2),
                              child: Text(context.l10n.fullAmount),
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
                      return null;
                    },
                  ),
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
                    icon: const Icon(Icons.payments_outlined),
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
    context.read<CustomerBloc>().add(AddCustomerPaymentRequested(
          customerId: _selectedCustomer!.id,
          walletAccountId: _selectedWallet!.id,
          amount: double.parse(_amountController.text),
          date: _selectedDate,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ));
  }
}
