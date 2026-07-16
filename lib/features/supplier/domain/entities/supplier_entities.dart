import 'package:equatable/equatable.dart';

/// Domain entity for a Supplier
class SupplierEntity extends Equatable {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final double totalPurchases;
  final double totalPayments;
  final double outstanding;
  final double creditBalance;
  final bool isActive;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const SupplierEntity({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.address,
    required this.totalPurchases,
    required this.totalPayments,
    required this.outstanding,
    required this.creditBalance,
    required this.isActive,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        phone,
        email,
        address,
        totalPurchases,
        totalPayments,
        outstanding,
        creditBalance,
        isActive,
        notes,
      ];

  SupplierEntity copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    double? totalPurchases,
    double? totalPayments,
    double? outstanding,
    double? creditBalance,
    bool? isActive,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupplierEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      totalPurchases: totalPurchases ?? this.totalPurchases,
      totalPayments: totalPayments ?? this.totalPayments,
      outstanding: outstanding ?? this.outstanding,
      creditBalance: creditBalance ?? this.creditBalance,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Domain entity for a Purchase
class PurchaseEntity extends Equatable {
  final int id;
  final String referenceNumber;
  final int supplierId;
  final String supplierName;
  final int walletAccountId;
  final String walletName;
  final double amount;
  final double creditApplied;
  final double netAmount;
  final String? notes;
  final DateTime date;
  final DateTime createdAt;

  const PurchaseEntity({
    required this.id,
    required this.referenceNumber,
    required this.supplierId,
    required this.supplierName,
    required this.walletAccountId,
    required this.walletName,
    required this.amount,
    required this.creditApplied,
    required this.netAmount,
    this.notes,
    required this.date,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, referenceNumber, supplierId, amount, date];
}

/// Domain entity for a Supplier Payment
class SupplierPaymentEntity extends Equatable {
  final int id;
  final String referenceNumber;
  final int supplierId;
  final String supplierName;
  final int walletAccountId;
  final String walletName;
  final double amount;
  final double outstandingSettled;
  final double creditGenerated;
  final String? notes;
  final DateTime date;
  final DateTime createdAt;

  const SupplierPaymentEntity({
    required this.id,
    required this.referenceNumber,
    required this.supplierId,
    required this.supplierName,
    required this.walletAccountId,
    required this.walletName,
    required this.amount,
    required this.outstandingSettled,
    required this.creditGenerated,
    this.notes,
    required this.date,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, referenceNumber, supplierId, amount, date];
}

/// Supplier ledger entry
class SupplierLedgerEntry extends Equatable {
  final int id;
  final String referenceNumber;
  final String transactionType;
  final double debit;
  final double credit;
  final double balance;
  final String description;
  final DateTime date;

  const SupplierLedgerEntry({
    required this.id,
    required this.referenceNumber,
    required this.transactionType,
    required this.debit,
    required this.credit,
    required this.balance,
    required this.description,
    required this.date,
  });

  @override
  List<Object?> get props => [id, referenceNumber, date];
}
