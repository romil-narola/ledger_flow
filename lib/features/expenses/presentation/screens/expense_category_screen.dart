import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../expenses.dart';

class ExpenseCategoryScreen extends StatelessWidget {
  const ExpenseCategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ExpenseBloc>()..add(const LoadCategories()),
      child: const _CategoryView(),
    );
  }
}

class _CategoryView extends StatelessWidget {
  const _CategoryView();

  // Available icons for categories
  static const List<Map<String, dynamic>> _availableIcons = [
    {'label': 'Food', 'codepoint': 0xe56c},
    {'label': 'Transport', 'codepoint': 0xe531},
    {'label': 'Home', 'codepoint': 0xe318},
    {'label': 'Utilities', 'codepoint': 0xe1a4},
    {'label': 'Entertainment', 'codepoint': 0xe40b},
    {'label': 'Medical', 'codepoint': 0xe548},
    {'label': 'Education', 'codepoint': 0xe80c},
    {'label': 'Other', 'codepoint': 0xe8b8},
    {'label': 'Shopping', 'codepoint': 0xe8cc},
    {'label': 'Travel', 'codepoint': 0xe7c4},
    {'label': 'Sports', 'codepoint': 0xe30d},
    {'label': 'Work', 'codepoint': 0xe8f9},
  ];

  static const List<Map<String, dynamic>> _availableColors = [
    {'label': 'Red', 'hex': '#EF4444'},
    {'label': 'Orange', 'hex': '#F59E0B'},
    {'label': 'Purple', 'hex': '#8B5CF6'},
    {'label': 'Cyan', 'hex': '#06B6D4'},
    {'label': 'Pink', 'hex': '#EC4899'},
    {'label': 'Green', 'hex': '#10B981'},
    {'label': 'Blue', 'hex': '#3B82F6'},
    {'label': 'Gray', 'hex': '#6B7280'},
    {'label': 'Indigo', 'hex': '#6366F1'},
    {'label': 'Teal', 'hex': '#14B8A6'},
    {'label': 'Yellow', 'hex': '#EAB308'},
    {'label': 'Rose', 'hex': '#F43F5E'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.expenseCategories),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCategoryDialog(context),
          ),
        ],
      ),
      body: BlocConsumer<ExpenseBloc, ExpenseState>(
        listener: (context, state) {
          if (state is ExpenseOperationSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text(translateBlocMessage(state.message, context.l10n)),
                  backgroundColor: AppColors.success),
            );
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
          if (state is ExpenseLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is ExpenseCategoriesLoaded) {
            if (state.categories.isEmpty) {
              return Center(child: Text(context.l10n.noCategoriesFound));
            }
            return ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: state.categories.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final cat = state.categories[index];
                final catColor = _hexToColor(cat.colorHex);
                return Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? const Color(0xFF1E293B)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.05),
                          blurRadius: 6)
                    ],
                  ),
                  child: ListTile(
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: catColor.withValues(alpha: 0.15),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        IconData(cat.iconCodepoint,
                            fontFamily: 'MaterialIcons'),
                        color: catColor,
                        size: 22,
                      ),
                    ),
                    title: Row(
                      children: [
                        Text(cat.name,
                            style: const TextStyle(fontWeight: FontWeight.w600)),
                        const SizedBox(width: 8),
                        Builder(builder: (_) {
                          final personalKeywords = [
                            'food', 'dining', 'entertainment', 'medical', 'doctor',
                            'hospital', 'medicine', 'education', 'school', 'college',
                            'tuition', 'fee', 'personal', 'family', 'shopping',
                            'clothing', 'grocery', 'groceries', 'home', 'house',
                            'movie', 'gift', 'recharge', 'subscription', 'life',
                            'health', 'self', 'draw', 'drawing', 'household',
                            'charity', 'vacation', 'trip'
                          ];
                          final isPersonal = personalKeywords.any(
                              (p) => cat.name.toLowerCase().contains(p));
                          final badgeColor = isPersonal
                              ? const Color(0xFF8B5CF6)
                              : const Color(0xFF0284C7);
                          return Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: badgeColor.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              isPersonal ? 'Personal' : 'Business',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: badgeColor,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                    subtitle: cat.monthlyBudget != null
                        ? Text(
                            '${context.l10n.monthlyBudget}: ${CurrencyFormatter.format(cat.monthlyBudget!)}',
                            style: const TextStyle(fontSize: 12))
                        : null,
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 18),
                          onPressed: () => _showCategoryDialog(context, cat),
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_outline,
                              size: 18, color: AppColors.error),
                          onPressed: () => _confirmDelete(context, cat),
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Future<void> _confirmDelete(
      BuildContext context, ExpenseCategoryEntity cat) async {
    final confirmed = await DeleteDialog.show(
      context,
      title: context.l10n.deleteCategory,
      content: '${context.l10n.confirmDelete} ("${cat.name}")',
    );

    if (confirmed == true && context.mounted) {
      context.read<ExpenseBloc>().add(DeleteCategoryRequested(cat.id));
    }
  }

  void _showCategoryDialog(BuildContext context,
      [ExpenseCategoryEntity? existing]) {
    final nameController = TextEditingController(text: existing?.name ?? '');
    int selectedIcon =
        existing?.iconCodepoint ?? _availableIcons.first['codepoint'] as int;
    String selectedColor =
        existing?.colorHex ?? (_availableColors.first['hex'] as String);

    final personalKeywords = [
      'food', 'dining', 'entertainment', 'medical', 'doctor',
      'hospital', 'medicine', 'education', 'school', 'college',
      'tuition', 'fee', 'personal', 'family', 'shopping',
      'clothing', 'grocery', 'groceries', 'home', 'house',
      'movie', 'gift', 'recharge', 'subscription', 'life',
      'health', 'self', 'draw', 'drawing', 'household',
      'charity', 'vacation', 'trip'
    ];
    bool isPersonalType = existing != null &&
        personalKeywords.any((p) => existing.name.toLowerCase().contains(p));

    showDialog(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (_, setDialogState) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: _hexToColor(selectedColor).withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          IconData(selectedIcon, fontFamily: 'MaterialIcons'),
                          color: _hexToColor(selectedColor),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        existing != null ? 'Edit Category' : 'New Category',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // Category Type Toggle (Business vs Personal)
                  Text('Category Type *',
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context)
                          .colorScheme
                          .surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              setDialogState(() {
                                isPersonalType = false;
                                selectedColor = '#0284C7';
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: !isPersonalType
                                    ? const Color(0xFF0284C7)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.business_center_outlined,
                                    size: 14,
                                    color: !isPersonalType
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Business',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: !isPersonalType
                                          ? Colors.white
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                      fontWeight: !isPersonalType
                                          ? FontWeight.bold
                                          : FontWeight.normal,
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
                              setDialogState(() {
                                isPersonalType = true;
                                selectedColor = '#8B5CF6';
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: isPersonalType
                                    ? const Color(0xFF8B5CF6)
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.person_outline,
                                    size: 14,
                                    color: isPersonalType
                                        ? Colors.white
                                        : Theme.of(context)
                                            .colorScheme
                                            .onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    'Personal',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: isPersonalType
                                          ? Colors.white
                                          : Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant,
                                      fontWeight: isPersonalType
                                          ? FontWeight.bold
                                          : FontWeight.normal,
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
                  const SizedBox(height: 16),

                  TextField(
                    controller: nameController,
                    decoration: InputDecoration(
                      labelText: context.l10n.categoryName,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(context.l10n.icon,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableIcons.map((ic) {
                      final cp = ic['codepoint'] as int;
                      final isSelected = selectedIcon == cp;
                      return GestureDetector(
                        onTap: () => setDialogState(() => selectedIcon = cp),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _hexToColor(selectedColor)
                                : _hexToColor(selectedColor)
                                    .withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            IconData(cp, fontFamily: 'MaterialIcons'),
                            color: isSelected
                                ? Colors.white
                                : _hexToColor(selectedColor),
                            size: 20,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  Text(context.l10n.color,
                      style: const TextStyle(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _availableColors.map((col) {
                      final hex = col['hex'] as String;
                      final isSelected = selectedColor == hex;
                      return GestureDetector(
                        onTap: () => setDialogState(() => selectedColor = hex),
                        child: Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            color: _hexToColor(hex),
                            shape: BoxShape.circle,
                            border: isSelected
                                ? Border.all(color: Colors.black, width: 2.5)
                                : null,
                          ),
                          child: isSelected
                              ? const Icon(Icons.check,
                                  color: Colors.white, size: 16)
                              : null,
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(dialogContext),
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
                          onPressed: () {
                            if (nameController.text.trim().isEmpty) return;
                            Navigator.pop(dialogContext);
                            if (existing != null) {
                              context
                                  .read<ExpenseBloc>()
                                  .add(UpdateCategoryRequested(
                                    existing.copyWith(
                                      name: nameController.text.trim(),
                                      iconCodepoint: selectedIcon,
                                      colorHex: selectedColor,
                                    ),
                                  ));
                            } else {
                              context
                                  .read<ExpenseBloc>()
                                  .add(AddCategoryRequested(
                                    name: nameController.text.trim(),
                                    iconCodepoint: selectedIcon,
                                    colorHex: selectedColor,
                                  ));
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
                            existing != null
                                ? context.l10n.update
                                : context.l10n.add,
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
        ),
      ),
    );
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
