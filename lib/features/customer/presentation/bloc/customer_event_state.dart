import 'package:equatable/equatable.dart';
import '../../domain/entities/customer_entities.dart';

// ═══════════════════════════════════════════════════════════════════
// EVENTS
// ═══════════════════════════════════════════════════════════════════

abstract class CustomerEvent extends Equatable {
  const CustomerEvent();
  @override
  List<Object?> get props => [];
}

class LoadCustomers extends CustomerEvent {
  const LoadCustomers();
}

class WatchCustomersStarted extends CustomerEvent {
  const WatchCustomersStarted();
}

class CustomersUpdated extends CustomerEvent {
  final List<CustomerEntity> customers;
  const CustomersUpdated(this.customers);
  @override
  List<Object?> get props => [customers];
}

class AddCustomerRequested extends CustomerEvent {
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  const AddCustomerRequested(
      {required this.name, this.phone, this.email, this.address, this.notes});
  @override
  List<Object?> get props => [name, phone, email];
}

class UpdateCustomerRequested extends CustomerEvent {
  final CustomerEntity customer;
  const UpdateCustomerRequested(this.customer);
  @override
  List<Object?> get props => [customer];
}

class DeleteCustomerRequested extends CustomerEvent {
  final int customerId;
  const DeleteCustomerRequested(this.customerId);
  @override
  List<Object?> get props => [customerId];
}

class AddSaleRequested extends CustomerEvent {
  final int customerId;
  final double amount;
  final DateTime date;
  final String? notes;
  final int? walletAccountId;
  final double? paidAmount;
  const AddSaleRequested({
    required this.customerId,
    required this.amount,
    required this.date,
    this.notes,
    this.walletAccountId,
    this.paidAmount,
  });
  @override
  List<Object?> get props =>
      [customerId, amount, date, walletAccountId, paidAmount];
}

class AddCustomerPaymentRequested extends CustomerEvent {
  final int customerId;
  final int walletAccountId;
  final double amount;
  final DateTime date;
  final String? notes;
  const AddCustomerPaymentRequested({
    required this.customerId,
    required this.walletAccountId,
    required this.amount,
    required this.date,
    this.notes,
  });
  @override
  List<Object?> get props => [customerId, walletAccountId, amount, date];
}

class LoadCustomerDetail extends CustomerEvent {
  final int customerId;
  const LoadCustomerDetail(this.customerId);
  @override
  List<Object?> get props => [customerId];
}

class LoadCustomerLedger extends CustomerEvent {
  final int customerId;
  const LoadCustomerLedger(this.customerId);
  @override
  List<Object?> get props => [customerId];
}

class LoadAllSales extends CustomerEvent {
  final DateTime? from;
  final DateTime? to;
  const LoadAllSales({this.from, this.to});
  @override
  List<Object?> get props => [from, to];
}

class LoadCustomerOutstandingSummary extends CustomerEvent {
  const LoadCustomerOutstandingSummary();
}

class LoadCustomerAdvanceSummary extends CustomerEvent {
  const LoadCustomerAdvanceSummary();
}

// ═══════════════════════════════════════════════════════════════════
// STATES
// ═══════════════════════════════════════════════════════════════════

abstract class CustomerState extends Equatable {
  const CustomerState();
  @override
  List<Object?> get props => [];
}

class CustomerInitial extends CustomerState {
  const CustomerInitial();
}

class CustomerLoading extends CustomerState {
  const CustomerLoading();
}

class CustomerEmpty extends CustomerState {
  const CustomerEmpty();
}

class CustomerListLoaded extends CustomerState {
  final List<CustomerEntity> customers;
  const CustomerListLoaded(this.customers);
  @override
  List<Object?> get props => [customers];
}

class CustomerDetailLoaded extends CustomerState {
  final CustomerEntity customer;
  final List<SaleEntity> sales;
  final List<CustomerPaymentEntity> payments;
  const CustomerDetailLoaded(
      {required this.customer, required this.sales, required this.payments});
  @override
  List<Object?> get props => [customer, sales, payments];
}

class CustomerLedgerLoaded extends CustomerState {
  final CustomerEntity customer;
  final List<CustomerLedgerEntry> entries;
  final List<SaleEntity> sales;
  final List<CustomerPaymentEntity> payments;
  const CustomerLedgerLoaded({
    required this.customer,
    required this.entries,
    required this.sales,
    required this.payments,
  });
  @override
  List<Object?> get props => [customer, entries, sales, payments];
}

class SalesLoaded extends CustomerState {
  final List<SaleEntity> sales;
  const SalesLoaded(this.sales);
  @override
  List<Object?> get props => [sales];
}

class CustomerOutstandingSummaryLoaded extends CustomerState {
  final List<CustomerEntity> customers;
  final double totalOutstanding;
  const CustomerOutstandingSummaryLoaded(
      {required this.customers, required this.totalOutstanding});
  @override
  List<Object?> get props => [customers, totalOutstanding];
}

class CustomerAdvanceSummaryLoaded extends CustomerState {
  final List<CustomerEntity> customers;
  final double totalAdvance;
  const CustomerAdvanceSummaryLoaded(
      {required this.customers, required this.totalAdvance});
  @override
  List<Object?> get props => [customers, totalAdvance];
}

class CustomerOperationSuccess extends CustomerState {
  final String message;
  const CustomerOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class CustomerError extends CustomerState {
  final String message;
  const CustomerError(this.message);
  @override
  List<Object?> get props => [message];
}
