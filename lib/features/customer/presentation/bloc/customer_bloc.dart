import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/customer_usecases.dart';
import 'customer_event_state.dart';

class CustomerBloc extends Bloc<CustomerEvent, CustomerState> {
  final GetCustomers _getCustomers;
  final WatchCustomers _watchCustomers;
  final GetCustomerById _getCustomerById;
  final AddCustomer _addCustomer;
  final UpdateCustomer _updateCustomer;
  final DeleteCustomer _deleteCustomer;
  final AddSale _addSale;
  final AddCustomerPayment _addPayment;
  final GetSalesByCustomer _getSalesByCustomer;
  final GetPaymentsByCustomer _getPaymentsByCustomer;
  final GetCustomerLedger _getCustomerLedger;
  final GetAllSales _getAllSales;
  final GetCustomersWithOutstanding _getCustomersWithOutstanding;
  final GetCustomersWithAdvance _getCustomersWithAdvance;

  CustomerBloc({
    required GetCustomers getCustomers,
    required WatchCustomers watchCustomers,
    required GetCustomerById getCustomerById,
    required AddCustomer addCustomer,
    required UpdateCustomer updateCustomer,
    required DeleteCustomer deleteCustomer,
    required AddSale addSale,
    required AddCustomerPayment addPayment,
    required GetSalesByCustomer getSalesByCustomer,
    required GetPaymentsByCustomer getPaymentsByCustomer,
    required GetCustomerLedger getCustomerLedger,
    required GetAllSales getAllSales,
    required GetCustomersWithOutstanding getCustomersWithOutstanding,
    required GetCustomersWithAdvance getCustomersWithAdvance,
  })  : _getCustomers = getCustomers,
        _watchCustomers = watchCustomers,
        _getCustomerById = getCustomerById,
        _addCustomer = addCustomer,
        _updateCustomer = updateCustomer,
        _deleteCustomer = deleteCustomer,
        _addSale = addSale,
        _addPayment = addPayment,
        _getSalesByCustomer = getSalesByCustomer,
        _getPaymentsByCustomer = getPaymentsByCustomer,
        _getCustomerLedger = getCustomerLedger,
        _getAllSales = getAllSales,
        _getCustomersWithOutstanding = getCustomersWithOutstanding,
        _getCustomersWithAdvance = getCustomersWithAdvance,
        super(const CustomerInitial()) {
    on<LoadCustomers>(_onLoadCustomers);
    on<WatchCustomersStarted>(_onWatchCustomersStarted);
    on<CustomersUpdated>(_onCustomersUpdated);
    on<AddCustomerRequested>(_onAddCustomer);
    on<UpdateCustomerRequested>(_onUpdateCustomer);
    on<DeleteCustomerRequested>(_onDeleteCustomer);
    on<AddSaleRequested>(_onAddSale);
    on<AddCustomerPaymentRequested>(_onAddPayment);
    on<LoadCustomerDetail>(_onLoadCustomerDetail);
    on<LoadCustomerLedger>(_onLoadCustomerLedger);
    on<LoadAllSales>(_onLoadAllSales);
    on<LoadCustomerOutstandingSummary>(_onLoadOutstandingSummary);
    on<LoadCustomerAdvanceSummary>(_onLoadAdvanceSummary);
  }

  Future<void> _onLoadCustomers(
      LoadCustomers event, Emitter<CustomerState> emit) async {
    emit(const CustomerLoading());
    try {
      final customers = await _getCustomers();
      if (customers.isEmpty) {
        emit(const CustomerEmpty());
      } else {
        emit(CustomerListLoaded(customers));
      }
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> _onWatchCustomersStarted(
      WatchCustomersStarted event, Emitter<CustomerState> emit) async {
    emit(const CustomerLoading());
    await emit.forEach(
      _watchCustomers(),
      onData: (customers) => customers.isEmpty
          ? const CustomerEmpty()
          : CustomerListLoaded(customers),
      onError: (e, _) => CustomerError(e.toString()),
    );
  }

  Future<void> _onCustomersUpdated(
      CustomersUpdated event, Emitter<CustomerState> emit) async {
    if (event.customers.isEmpty) {
      emit(const CustomerEmpty());
    } else {
      emit(CustomerListLoaded(event.customers));
    }
  }

  Future<void> _onAddCustomer(
      AddCustomerRequested event, Emitter<CustomerState> emit) async {
    try {
      await _addCustomer(
          name: event.name,
          phone: event.phone,
          email: event.email,
          address: event.address,
          notes: event.notes);
      emit(const CustomerOperationSuccess('customerAddedSuccessfully'));
      add(const LoadCustomers());
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> _onUpdateCustomer(
      UpdateCustomerRequested event, Emitter<CustomerState> emit) async {
    try {
      await _updateCustomer(event.customer);
      emit(const CustomerOperationSuccess('customerUpdatedSuccessfully'));
      add(const LoadCustomers());
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> _onDeleteCustomer(
      DeleteCustomerRequested event, Emitter<CustomerState> emit) async {
    try {
      await _deleteCustomer(event.customerId);
      emit(const CustomerOperationSuccess('customerDeleted'));
      add(const LoadCustomers());
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> _onAddSale(
      AddSaleRequested event, Emitter<CustomerState> emit) async {
    try {
      await _addSale(
        customerId: event.customerId,
        amount: event.amount,
        date: event.date,
        notes: event.notes,
        walletAccountId: event.walletAccountId,
        paidAmount: event.paidAmount,
      );
      emit(const CustomerOperationSuccess('saleRecordedSuccessfully'));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> _onAddPayment(
      AddCustomerPaymentRequested event, Emitter<CustomerState> emit) async {
    try {
      await _addPayment(
          customerId: event.customerId,
          walletAccountId: event.walletAccountId,
          amount: event.amount,
          date: event.date,
          notes: event.notes);
      emit(const CustomerOperationSuccess('paymentRecordedSuccessfully'));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> _onLoadCustomerDetail(
      LoadCustomerDetail event, Emitter<CustomerState> emit) async {
    emit(const CustomerLoading());
    try {
      final customer = await _getCustomerById(event.customerId);
      if (customer == null) {
        emit(const CustomerError('customerNotFound'));
        return;
      }
      final sales = await _getSalesByCustomer(event.customerId);
      final payments = await _getPaymentsByCustomer(event.customerId);
      emit(CustomerDetailLoaded(
          customer: customer, sales: sales, payments: payments));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> _onLoadCustomerLedger(
      LoadCustomerLedger event, Emitter<CustomerState> emit) async {
    emit(const CustomerLoading());
    try {
      final customer = await _getCustomerById(event.customerId);
      if (customer == null) {
        emit(const CustomerError('customerNotFound'));
        return;
      }
      final entries = await _getCustomerLedger(event.customerId);
      final sales = await _getSalesByCustomer(event.customerId);
      final payments = await _getPaymentsByCustomer(event.customerId);
      emit(CustomerLedgerLoaded(
        customer: customer,
        entries: entries,
        sales: sales,
        payments: payments,
      ));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> _onLoadAllSales(
      LoadAllSales event, Emitter<CustomerState> emit) async {
    emit(const CustomerLoading());
    try {
      final sales = await _getAllSales(from: event.from, to: event.to);
      emit(SalesLoaded(sales));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> _onLoadOutstandingSummary(
      LoadCustomerOutstandingSummary event, Emitter<CustomerState> emit) async {
    emit(const CustomerLoading());
    try {
      final customers = await _getCustomersWithOutstanding();
      final total = customers.fold<double>(0, (s, c) => s + c.outstanding);
      emit(CustomerOutstandingSummaryLoaded(
          customers: customers, totalOutstanding: total));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }

  Future<void> _onLoadAdvanceSummary(
      LoadCustomerAdvanceSummary event, Emitter<CustomerState> emit) async {
    emit(const CustomerLoading());
    try {
      final customers = await _getCustomersWithAdvance();
      final total = customers.fold<double>(0, (s, c) => s + c.advanceBalance);
      emit(CustomerAdvanceSummaryLoaded(
          customers: customers, totalAdvance: total));
    } catch (e) {
      emit(CustomerError(e.toString()));
    }
  }
}
