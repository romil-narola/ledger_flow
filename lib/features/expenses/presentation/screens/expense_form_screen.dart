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
  bool _isPersonalNature = false;

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

                  // Expense Nature Selector (Business vs Personal)
                  Container(
                    margin: const EdgeInsets.only(bottom: 16),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color:
                          Theme.of(context).colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPersonalNature = false;
                                final personalKeywords = [
                                  'food',
                                  'dining',
                                  'entertainment',
                                  'medical',
                                  'doctor',
                                  'hospital',
                                  'medicine',
                                  'education',
                                  'school',
                                  'college',
                                  'tuition',
                                  'fee',
                                  'personal',
                                  'family',
                                  'shopping',
                                  'clothing',
                                  'grocery',
                                  'groceries',
                                  'home',
                                  'house',
                                  'movie',
                                  'gift',
                                  'recharge',
                                  'subscription',
                                  'life',
                                  'health',
                                  'self',
                                  'draw',
                                  'drawing',
                                  'household',
                                  'charity',
                                  'vacation',
                                  'trip'
                                ];
                                final biz = _categories.where((c) =>
                                    !personalKeywords.any((p) =>
                                        c.name.toLowerCase().contains(p)));
                                if (biz.isNotEmpty) {
                                  _selectedCategory = biz.first;
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: !_isPersonalNature
                                    ? const Color(0xFF0284C7)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.business_center_outlined,
                                    size: 16,
                                    color: !_isPersonalNature
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Business Expense',
                                    style: TextStyle(
                                      color: !_isPersonalNature
                                          ? Colors.white
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                      fontWeight: !_isPersonalNature
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _isPersonalNature = true;
                                final personalKeywords = [
                                  'food',
                                  'dining',
                                  'entertainment',
                                  'medical',
                                  'doctor',
                                  'hospital',
                                  'medicine',
                                  'education',
                                  'school',
                                  'college',
                                  'tuition',
                                  'fee',
                                  'personal',
                                  'family',
                                  'shopping',
                                  'clothing',
                                  'grocery',
                                  'groceries',
                                  'home',
                                  'house',
                                  'movie',
                                  'gift',
                                  'recharge',
                                  'subscription',
                                  'life',
                                  'health',
                                  'self',
                                  'draw',
                                  'drawing',
                                  'household',
                                  'charity',
                                  'vacation',
                                  'trip'
                                ];
                                final personal = _categories.where((c) =>
                                    personalKeywords.any((p) =>
                                        c.name.toLowerCase().contains(p)));
                                if (personal.isNotEmpty) {
                                  _selectedCategory = personal.first;
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _isPersonalNature
                                    ? const Color(0xFF8B5CF6)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    size: 16,
                                    color: _isPersonalNature
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    'Personal Expense',
                                    style: TextStyle(
                                      color: _isPersonalNature
                                          ? Colors.white
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                      fontWeight: _isPersonalNature
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                      fontSize: 13,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

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
    final personalKeywords = [
      'food',
      'dining',
      'entertainment',
      'medical',
      'doctor',
      'hospital',
      'medicine',
      'education',
      'school',
      'college',
      'tuition',
      'fee',
      'personal',
      'family',
      'shopping',
      'clothing',
      'grocery',
      'groceries',
      'home',
      'house',
      'movie',
      'gift',
      'recharge',
      'subscription',
      'life',
      'health',
      'self',
      'draw',
      'drawing',
      'household',
      'charity',
      'vacation',
      'trip'
    ];

    final filtered = _categories.where((cat) {
      final isPersonalCat =
          personalKeywords.any((p) => cat.name.toLowerCase().contains(p));
      return _isPersonalNature ? isPersonalCat : !isPersonalCat;
    }).toList();

    final displayCategories = filtered.isNotEmpty ? filtered : _categories;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Text('${context.l10n.category} *',
                    style: const TextStyle(
                        fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(width: 8),
                InkWell(
                  onTap: () => _showQuickAddCategoryDialog(context),
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.3)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.add, size: 14, color: AppColors.primary),
                        SizedBox(width: 2),
                        Text(
                          'Add New',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            Text(
              _isPersonalNature ? 'Personal Categories' : 'Business Categories',
              style: TextStyle(
                fontSize: 12,
                color: _isPersonalNature
                    ? const Color(0xFF8B5CF6)
                    : const Color(0xFF0284C7),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: displayCategories.map((cat) {
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

  void _showQuickAddCategoryDialog(BuildContext context) {
    final nameController = TextEditingController();
    showDialog(
      context: context,
      builder: (dContext) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: (_isPersonalNature
                              ? const Color(0xFF8B5CF6)
                              : const Color(0xFF0284C7))
                          .withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      _isPersonalNature
                          ? Icons.person_outline
                          : Icons.business_center_outlined,
                      color: _isPersonalNature
                          ? const Color(0xFF8B5CF6)
                          : const Color(0xFF0284C7),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    _isPersonalNature
                        ? 'New Personal Category'
                        : 'New Business Category',
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextField(
                controller: nameController,
                autofocus: true,
                decoration: InputDecoration(
                  labelText: 'Category Name',
                  hintText: 'e.g. Office Supplies, Marketing, Logistics',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(dContext),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        side: BorderSide(
                            color: Colors.grey.shade300, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        context.l10n.cancel,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        final name = nameController.text.trim();
                        if (name.isNotEmpty) {
                          try {
                            final newId = await sl<AddCategory>()(
                              name: name,
                              iconCodepoint:
                                  _isPersonalNature ? 0xe8cc : 0xe8f9,
                              colorHex:
                                  _isPersonalNature ? '#8B5CF6' : '#0284C7',
                            );
                            if (dContext.mounted) Navigator.pop(dContext);
                            await _loadData();
                            final created =
                                _categories.where((c) => c.id == newId);
                            if (created.isNotEmpty) {
                              setState(
                                  () => _selectedCategory = created.first);
                            }
                          } catch (_) {
                            if (dContext.mounted) Navigator.pop(dContext);
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        context.l10n.add,
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
