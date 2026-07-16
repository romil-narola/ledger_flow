/// Domain entities for the General Expenses feature
library;

class ExpenseCategoryEntity {
  final int id;
  final String name;
  final int iconCodepoint;
  final String colorHex;
  final double? monthlyBudget;
  final bool isActive;

  const ExpenseCategoryEntity({
    required this.id,
    required this.name,
    required this.iconCodepoint,
    required this.colorHex,
    this.monthlyBudget,
    required this.isActive,
  });

  ExpenseCategoryEntity copyWith({
    int? id,
    String? name,
    int? iconCodepoint,
    String? colorHex,
    double? monthlyBudget,
    bool? isActive,
  }) {
    return ExpenseCategoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      iconCodepoint: iconCodepoint ?? this.iconCodepoint,
      colorHex: colorHex ?? this.colorHex,
      monthlyBudget: monthlyBudget ?? this.monthlyBudget,
      isActive: isActive ?? this.isActive,
    );
  }
}

class ExpenseEntity {
  final int id;
  final String referenceNumber;
  final int categoryId;
  final String categoryName;
  final int categoryIconCodepoint;
  final String categoryColorHex;
  final int? walletAccountId;
  final String? walletName;
  final double amount;
  final String description;
  final String? notes;
  final DateTime date;

  const ExpenseEntity({
    required this.id,
    required this.referenceNumber,
    required this.categoryId,
    required this.categoryName,
    required this.categoryIconCodepoint,
    required this.categoryColorHex,
    this.walletAccountId,
    this.walletName,
    required this.amount,
    required this.description,
    this.notes,
    required this.date,
  });
}

class ExpenseCategorySummary {
  final ExpenseCategoryEntity category;
  final double totalSpent;
  final int count;

  const ExpenseCategorySummary({
    required this.category,
    required this.totalSpent,
    required this.count,
  });
}
