import 'package:equatable/equatable.dart';

/// Domain entity for a Wallet Account
class WalletAccountEntity extends Equatable {
  final int id;
  final String name;
  final double openingBalance;
  final double currentBalance;
  final String? notes;
  final bool isActive;
  final bool overdraftEnabled;
  final DateTime createdAt;
  final DateTime updatedAt;

  const WalletAccountEntity({
    required this.id,
    required this.name,
    required this.openingBalance,
    required this.currentBalance,
    this.notes,
    required this.isActive,
    required this.overdraftEnabled,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        openingBalance,
        currentBalance,
        notes,
        isActive,
        overdraftEnabled,
        createdAt,
        updatedAt,
      ];

  WalletAccountEntity copyWith({
    int? id,
    String? name,
    double? openingBalance,
    double? currentBalance,
    String? notes,
    bool? isActive,
    bool? overdraftEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return WalletAccountEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      openingBalance: openingBalance ?? this.openingBalance,
      currentBalance: currentBalance ?? this.currentBalance,
      notes: notes ?? this.notes,
      isActive: isActive ?? this.isActive,
      overdraftEnabled: overdraftEnabled ?? this.overdraftEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
