import 'package:equatable/equatable.dart';

/// Domain entity for a Customer
class CustomerEntity extends Equatable {
  final int id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final double totalSales;
  final double totalPayments;
  final double outstanding;
  final double advanceBalance;
  final bool isActive;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const CustomerEntity({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.address,
    required this.totalSales,
    required this.totalPayments,
    required this.outstanding,
    required this.advanceBalance,
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
        totalSales,
        totalPayments,
        outstanding,
        advanceBalance,
        isActive,
        notes,
      ];

  CustomerEntity copyWith({
    int? id,
    String? name,
    String? phone,
    String? email,
    String? address,
    double? totalSales,
    double? totalPayments,
    double? outstanding,
    double? advanceBalance,
    bool? isActive,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return CustomerEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      totalSales: totalSales ?? this.totalSales,
      totalPayments: totalPayments ?? this.totalPayments,
      outstanding: outstanding ?? this.outstanding,
      advanceBalance: advanceBalance ?? this.advanceBalance,
      isActive: isActive ?? this.isActive,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Domain entity for a Sale
class SaleEntity extends Equatable {
  final int id;
  final String referenceNumber;
  final int customerId;
  final String customerName;
  final double amount;
  final double advanceApplied;
  final double netAmount;
  final String? notes;
  final DateTime date;
  final DateTime createdAt;

  const SaleEntity({
    required this.id,
    required this.referenceNumber,
    required this.customerId,
    required this.customerName,
    required this.amount,
    required this.advanceApplied,
    required this.netAmount,
    this.notes,
    required this.date,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, referenceNumber, customerId, amount, date];
}

/// Domain entity for a Customer Payment
class CustomerPaymentEntity extends Equatable {
  final int id;
  final String referenceNumber;
  final int customerId;
  final String customerName;
  final int walletAccountId;
  final String walletName;
  final double amount;
  final double outstandingSettled;
  final double advanceGenerated;
  final String? notes;
  final DateTime date;
  final DateTime createdAt;

  const CustomerPaymentEntity({
    required this.id,
    required this.referenceNumber,
    required this.customerId,
    required this.customerName,
    required this.walletAccountId,
    required this.walletName,
    required this.amount,
    required this.outstandingSettled,
    required this.advanceGenerated,
    this.notes,
    required this.date,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, referenceNumber, customerId, amount, date];
}

/// Customer ledger entry
class CustomerLedgerEntry extends Equatable {
  final int id;
  final String referenceNumber;
  final String transactionType;
  final double debit;
  final double credit;
  final double balance;
  final String description;
  final DateTime date;

  const CustomerLedgerEntry({
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
