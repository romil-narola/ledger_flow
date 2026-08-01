import 'package:equatable/equatable.dart';
import '../../../../core/core.dart';

/// Domain entity for a ledger entry
class LedgerEntryEntity extends Equatable {
  final int id;
  final String referenceNumber;
  final TransactionType transactionType;
  final int? walletAccountId;
  final String? walletName;
  final int? supplierId;
  final String? supplierName;
  final String? supplierPhone;
  final int? customerId;
  final String? customerName;
  final String? customerPhone;
  final double debit;
  final double credit;
  final double walletBalance;
  final String description;
  final DateTime date;
  final DateTime createdAt;

  const LedgerEntryEntity({
    required this.id,
    required this.referenceNumber,
    required this.transactionType,
    this.walletAccountId,
    this.walletName,
    this.supplierId,
    this.supplierName,
    this.supplierPhone,
    this.customerId,
    this.customerName,
    this.customerPhone,
    required this.debit,
    required this.credit,
    required this.walletBalance,
    required this.description,
    required this.date,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, referenceNumber, date, transactionType];

  double get netAmount => credit - debit;
  bool get isCredit => credit > debit;
  String? get partyPhone => customerPhone ?? supplierPhone;
}
