import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../../wallet/wallet.dart';
import '../../expenses.dart';

class ExpenseFormScreen extends StatefulWidget {
  const ExpenseFormScreen({super.key});

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _descController = TextEditingController();
  final _notesController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  ExpenseCategoryEntity? _selectedCategory;
  WalletAccountEntity? _selectedWallet;
  List<ExpenseCategoryEntity> _categories = [];
  List<WalletAccountEntity> _wallets = [];
  bool _useWallet = true;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final categories = await sl<GetCategories>()();
    final wallets = await sl<GetWallets>()();
    if (mounted) {
      setState(() {
        _categories = categories;
        _wallets = wallets;
        // Default to 'Other' category; fall back to first if not found
        if (categories.isNotEmpty) {
          final others =
              categories.where((c) => c.name.toLowerCase() == 'other');
          _selectedCategory =
              others.isNotEmpty ? others.first : categories.first;
        } else {
          _selectedCategory = null;
        }
        if (wallets.isNotEmpty) _selectedWallet = wallets.first;
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExpenseBloc>(),
      child: BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text(translateBlocMessage(state.message, context.l10n)),
                  backgroundColor: AppColors.success),
            );
            Navigator.pop(context);
          }
          if (state is ExpenseError) {
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
            appBar: AppBar(title: Text(context.l10n.newExpense)),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Info banner
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: Color(0xFF6366F1), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            context.l10n.recordExpenseBanner,
                            style: const TextStyle(
                                color: Color(0xFF6366F1), fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Date Picker
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

                  // Category Picker
                  if (_isLoading)
                    const Center(child: CircularProgressIndicator())
                  else if (_categories.isEmpty)
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Text(
                          'No categories found. Please create one.',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    )
                  else
                    _buildCategoryGrid(),
                  const SizedBox(height: 16),

                  // Description
                  TextFormField(
                    controller: _descController,
                    decoration: InputDecoration(
                      labelText: '${context.l10n.description} *',
                      prefixIcon: const Icon(Icons.edit_outlined),
                    ),
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? context.l10n.descriptionRequired
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Amount
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      labelText: '${context.l10n.amount} *',
                      prefixIcon: const Icon(Icons.currency_rupee),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return context.l10n.amountRequired;
                      }
                      final a = double.tryParse(v);
                      if (a == null || a <= 0) {
                        return context.l10n.invalidAmount;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Use Wallet toggle
                  SwitchListTile(
                    title: Text(context.l10n.deductFromWallet),
                    subtitle: Text(context.l10n.trackExpenseAgainstWallet),
                    value: _useWallet,
                    onChanged: (val) => setState(() => _useWallet = val),
                    activeThumbColor: AppColors.primary,
                    contentPadding: EdgeInsets.zero,
                  ),

                  // Wallet dropdown
                  if (_useWallet && _wallets.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    DropdownButtonFormField<WalletAccountEntity>(
                      initialValue: _selectedWallet,
                      decoration: InputDecoration(
                        labelText: '${context.l10n.walletName} *',
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
                      validator: (v) => _useWallet && v == null
                          ? context.l10n.selectWallet
                          : null,
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
                    onPressed:
                        state is ExpenseLoading ? null : () => _submit(context),
                    icon: const Icon(Icons.receipt_long),
                    label: Text(context.l10n.recordExpense),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('${context.l10n.category} *',
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: _categories.map((cat) {
            final catColor = _hexToColor(cat.colorHex);
            final isSelected = _selectedCategory?.id == cat.id;
            return GestureDetector(
              onTap: () => setState(() => _selectedCategory = cat),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color:
                      isSelected ? catColor : catColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                  border:
                      Border.all(color: catColor, width: isSelected ? 0 : 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      IconData(cat.iconCodepoint, fontFamily: 'MaterialIcons'),
                      color: isSelected ? Colors.white : catColor,
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      cat.name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : catColor,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
        if (_selectedCategory == null)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(context.l10n.selectCategory,
                style: const TextStyle(color: AppColors.error, fontSize: 12)),
          ),
      ],
    );
  }

  void _submit(BuildContext context) {
    if (_selectedCategory == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(context.l10n.selectCategory),
            backgroundColor: AppColors.error),
      );
      return;
    }
    if (!_formKey.currentState!.validate()) return;

    context.read<ExpenseBloc>().add(AddExpenseRequested(
          categoryId: _selectedCategory!.id,
          walletAccountId: _useWallet ? _selectedWallet?.id : null,
          amount: double.parse(_amountController.text),
          description: _descController.text.trim(),
          date: _selectedDate,
          notes: _notesController.text.trim().isEmpty
              ? null
              : _notesController.text.trim(),
        ));
  }

  Color _hexToColor(String hex) {
    try {
      final h = hex.replaceAll('#', '');
      return Color(int.parse('FF$h', radix: 16));
    } catch (_) {
      return const Color(0xFF6366F1);
    }
  }
}
