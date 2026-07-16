import 'package:equatable/equatable.dart';
import '../../domain/entities/supplier_entities.dart';

// ═══════════════════════════════════════════════════════════════════
// EVENTS
// ═══════════════════════════════════════════════════════════════════

abstract class SupplierEvent extends Equatable {
  const SupplierEvent();
  @override
  List<Object?> get props => [];
}

class LoadSuppliers extends SupplierEvent {
  const LoadSuppliers();
}

class WatchSuppliersStarted extends SupplierEvent {
  const WatchSuppliersStarted();
}

class SuppliersUpdated extends SupplierEvent {
  final List<SupplierEntity> suppliers;
  const SuppliersUpdated(this.suppliers);
  @override
  List<Object?> get props => [suppliers];
}

class AddSupplierRequested extends SupplierEvent {
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  const AddSupplierRequested(
      {required this.name, this.phone, this.email, this.address, this.notes});
  @override
  List<Object?> get props => [name, phone, email];
}

class UpdateSupplierRequested extends SupplierEvent {
  final SupplierEntity supplier;
  const UpdateSupplierRequested(this.supplier);
  @override
  List<Object?> get props => [supplier];
}

class DeleteSupplierRequested extends SupplierEvent {
  final int supplierId;
  const DeleteSupplierRequested(this.supplierId);
  @override
  List<Object?> get props => [supplierId];
}

class AddPurchaseRequested extends SupplierEvent {
  final int supplierId;
  final int walletAccountId;
  final double amount;
  final DateTime date;
  final String? notes;
  final double? paidAmount;
  const AddPurchaseRequested({
    required this.supplierId,
    required this.walletAccountId,
    required this.amount,
    required this.date,
    this.notes,
    this.paidAmount,
  });
  @override
  List<Object?> get props =>
      [supplierId, walletAccountId, amount, date, paidAmount];
}

class AddSupplierPaymentRequested extends SupplierEvent {
  final int supplierId;
  final int walletAccountId;
  final double amount;
  final DateTime date;
  final String? notes;
  const AddSupplierPaymentRequested({
    required this.supplierId,
    required this.walletAccountId,
    required this.amount,
    required this.date,
    this.notes,
  });
  @override
  List<Object?> get props => [supplierId, walletAccountId, amount, date];
}

class LoadSupplierDetail extends SupplierEvent {
  final int supplierId;
  const LoadSupplierDetail(this.supplierId);
  @override
  List<Object?> get props => [supplierId];
}

class LoadSupplierLedger extends SupplierEvent {
  final int supplierId;
  const LoadSupplierLedger(this.supplierId);
  @override
  List<Object?> get props => [supplierId];
}

class LoadAllPurchases extends SupplierEvent {
  final DateTime? from;
  final DateTime? to;
  const LoadAllPurchases({this.from, this.to});
  @override
  List<Object?> get props => [from, to];
}

class LoadOutstandingSummary extends SupplierEvent {
  const LoadOutstandingSummary();
}

class LoadCreditSummary extends SupplierEvent {
  const LoadCreditSummary();
}

// ═══════════════════════════════════════════════════════════════════
// STATES
// ═══════════════════════════════════════════════════════════════════

abstract class SupplierState extends Equatable {
  const SupplierState();
  @override
  List<Object?> get props => [];
}

class SupplierInitial extends SupplierState {
  const SupplierInitial();
}

class SupplierLoading extends SupplierState {
  const SupplierLoading();
}

class SupplierEmpty extends SupplierState {
  const SupplierEmpty();
}

class SupplierListLoaded extends SupplierState {
  final List<SupplierEntity> suppliers;
  const SupplierListLoaded(this.suppliers);
  @override
  List<Object?> get props => [suppliers];
}

class SupplierDetailLoaded extends SupplierState {
  final SupplierEntity supplier;
  final List<PurchaseEntity> purchases;
  final List<SupplierPaymentEntity> payments;
  const SupplierDetailLoaded(
      {required this.supplier,
      required this.purchases,
      required this.payments});
  @override
  List<Object?> get props => [supplier, purchases, payments];
}

class SupplierLedgerLoaded extends SupplierState {
  final SupplierEntity supplier;
  final List<SupplierLedgerEntry> entries;
  final List<PurchaseEntity> purchases;
  final List<SupplierPaymentEntity> payments;
  const SupplierLedgerLoaded({
    required this.supplier,
    required this.entries,
    required this.purchases,
    required this.payments,
  });
  @override
  List<Object?> get props => [supplier, entries, purchases, payments];
}

class PurchasesLoaded extends SupplierState {
  final List<PurchaseEntity> purchases;
  const PurchasesLoaded(this.purchases);
  @override
  List<Object?> get props => [purchases];
}

class OutstandingSummaryLoaded extends SupplierState {
  final List<SupplierEntity> suppliers;
  final double totalOutstanding;
  const OutstandingSummaryLoaded(
      {required this.suppliers, required this.totalOutstanding});
  @override
  List<Object?> get props => [suppliers, totalOutstanding];
}

class CreditSummaryLoaded extends SupplierState {
  final List<SupplierEntity> suppliers;
  final double totalCredit;
  const CreditSummaryLoaded(
      {required this.suppliers, required this.totalCredit});
  @override
  List<Object?> get props => [suppliers, totalCredit];
}

class SupplierOperationSuccess extends SupplierState {
  final String message;
  final String? transactionRef;
  const SupplierOperationSuccess(this.message, {this.transactionRef});
  @override
  List<Object?> get props => [message, transactionRef];
}

class SupplierError extends SupplierState {
  final String message;
  const SupplierError(this.message);
  @override
  List<Object?> get props => [message];
}
