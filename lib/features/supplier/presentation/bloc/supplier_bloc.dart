import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/supplier_usecases.dart';
import 'supplier_event_state.dart';

/// BLoC for managing supplier state
class SupplierBloc extends Bloc<SupplierEvent, SupplierState> {
  final GetSuppliers _getSuppliers;
  final WatchSuppliers _watchSuppliers;
  final GetSupplierById _getSupplierById;
  final AddSupplier _addSupplier;
  final UpdateSupplier _updateSupplier;
  final DeleteSupplier _deleteSupplier;
  final AddPurchase _addPurchase;
  final AddSupplierPayment _addPayment;
  final GetPurchasesBySupplier _getPurchasesBySupplier;
  final GetPaymentsBySupplier _getPaymentsBySupplier;
  final GetSupplierLedger _getSupplierLedger;
  final GetAllPurchases _getAllPurchases;
  final GetSuppliersWithOutstanding _getSuppliersWithOutstanding;
  final GetSuppliersWithCredit _getSuppliersWithCredit;

  SupplierBloc({
    required GetSuppliers getSuppliers,
    required WatchSuppliers watchSuppliers,
    required GetSupplierById getSupplierById,
    required AddSupplier addSupplier,
    required UpdateSupplier updateSupplier,
    required DeleteSupplier deleteSupplier,
    required AddPurchase addPurchase,
    required AddSupplierPayment addPayment,
    required GetPurchasesBySupplier getPurchasesBySupplier,
    required GetPaymentsBySupplier getPaymentsBySupplier,
    required GetSupplierLedger getSupplierLedger,
    required GetAllPurchases getAllPurchases,
    required GetSuppliersWithOutstanding getSuppliersWithOutstanding,
    required GetSuppliersWithCredit getSuppliersWithCredit,
  })  : _getSuppliers = getSuppliers,
        _watchSuppliers = watchSuppliers,
        _getSupplierById = getSupplierById,
        _addSupplier = addSupplier,
        _updateSupplier = updateSupplier,
        _deleteSupplier = deleteSupplier,
        _addPurchase = addPurchase,
        _addPayment = addPayment,
        _getPurchasesBySupplier = getPurchasesBySupplier,
        _getPaymentsBySupplier = getPaymentsBySupplier,
        _getSupplierLedger = getSupplierLedger,
        _getAllPurchases = getAllPurchases,
        _getSuppliersWithOutstanding = getSuppliersWithOutstanding,
        _getSuppliersWithCredit = getSuppliersWithCredit,
        super(const SupplierInitial()) {
    on<LoadSuppliers>(_onLoadSuppliers);
    on<WatchSuppliersStarted>(_onWatchSuppliersStarted);
    on<SuppliersUpdated>(_onSuppliersUpdated);
    on<AddSupplierRequested>(_onAddSupplier);
    on<UpdateSupplierRequested>(_onUpdateSupplier);
    on<DeleteSupplierRequested>(_onDeleteSupplier);
    on<AddPurchaseRequested>(_onAddPurchase);
    on<AddSupplierPaymentRequested>(_onAddPayment);
    on<LoadSupplierDetail>(_onLoadSupplierDetail);
    on<LoadSupplierLedger>(_onLoadSupplierLedger);
    on<LoadAllPurchases>(_onLoadAllPurchases);
    on<LoadOutstandingSummary>(_onLoadOutstandingSummary);
    on<LoadCreditSummary>(_onLoadCreditSummary);
  }

  Future<void> _onLoadSuppliers(
      LoadSuppliers event, Emitter<SupplierState> emit) async {
    emit(const SupplierLoading());
    try {
      final suppliers = await _getSuppliers();
      if (suppliers.isEmpty) {
        emit(const SupplierEmpty());
      } else {
        emit(SupplierListLoaded(suppliers));
      }
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onWatchSuppliersStarted(
      WatchSuppliersStarted event, Emitter<SupplierState> emit) async {
    emit(const SupplierLoading());
    await emit.forEach(
      _watchSuppliers(),
      onData: (suppliers) => suppliers.isEmpty
          ? const SupplierEmpty()
          : SupplierListLoaded(suppliers),
      onError: (e, _) => SupplierError(e.toString()),
    );
  }

  Future<void> _onSuppliersUpdated(
      SuppliersUpdated event, Emitter<SupplierState> emit) async {
    if (event.suppliers.isEmpty) {
      emit(const SupplierEmpty());
    } else {
      emit(SupplierListLoaded(event.suppliers));
    }
  }

  Future<void> _onAddSupplier(
      AddSupplierRequested event, Emitter<SupplierState> emit) async {
    try {
      await _addSupplier(
        name: event.name,
        phone: event.phone,
        email: event.email,
        address: event.address,
        notes: event.notes,
      );
      emit(const SupplierOperationSuccess('supplierAddedSuccessfully'));
      add(const LoadSuppliers());
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onUpdateSupplier(
      UpdateSupplierRequested event, Emitter<SupplierState> emit) async {
    try {
      await _updateSupplier(event.supplier);
      emit(const SupplierOperationSuccess('supplierUpdatedSuccessfully'));
      add(const LoadSuppliers());
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onDeleteSupplier(
      DeleteSupplierRequested event, Emitter<SupplierState> emit) async {
    try {
      await _deleteSupplier(event.supplierId);
      emit(const SupplierOperationSuccess('supplierDeleted'));
      add(const LoadSuppliers());
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onAddPurchase(
      AddPurchaseRequested event, Emitter<SupplierState> emit) async {
    try {
      await _addPurchase(
        supplierId: event.supplierId,
        walletAccountId: event.walletAccountId,
        amount: event.amount,
        date: event.date,
        notes: event.notes,
        paidAmount: event.paidAmount,
      );
      emit(const SupplierOperationSuccess('purchaseRecordedSuccessfully'));
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onAddPayment(
      AddSupplierPaymentRequested event, Emitter<SupplierState> emit) async {
    try {
      await _addPayment(
        supplierId: event.supplierId,
        walletAccountId: event.walletAccountId,
        amount: event.amount,
        date: event.date,
        notes: event.notes,
      );
      emit(const SupplierOperationSuccess('paymentRecordedSuccessfully'));
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onLoadSupplierDetail(
      LoadSupplierDetail event, Emitter<SupplierState> emit) async {
    emit(const SupplierLoading());
    try {
      final supplier = await _getSupplierById(event.supplierId);
      if (supplier == null) {
        emit(const SupplierError('supplierNotFound'));
        return;
      }
      final purchases = await _getPurchasesBySupplier(event.supplierId);
      final payments = await _getPaymentsBySupplier(event.supplierId);
      emit(SupplierDetailLoaded(
        supplier: supplier,
        purchases: purchases,
        payments: payments,
      ));
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onLoadSupplierLedger(
      LoadSupplierLedger event, Emitter<SupplierState> emit) async {
    emit(const SupplierLoading());
    try {
      final supplier = await _getSupplierById(event.supplierId);
      if (supplier == null) {
        emit(const SupplierError('supplierNotFound'));
        return;
      }
      final entries = await _getSupplierLedger(event.supplierId);
      final purchases = await _getPurchasesBySupplier(event.supplierId);
      final payments = await _getPaymentsBySupplier(event.supplierId);
      emit(SupplierLedgerLoaded(
        supplier: supplier,
        entries: entries,
        purchases: purchases,
        payments: payments,
      ));
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onLoadAllPurchases(
      LoadAllPurchases event, Emitter<SupplierState> emit) async {
    emit(const SupplierLoading());
    try {
      final purchases = await _getAllPurchases(from: event.from, to: event.to);
      emit(PurchasesLoaded(purchases));
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onLoadOutstandingSummary(
      LoadOutstandingSummary event, Emitter<SupplierState> emit) async {
    emit(const SupplierLoading());
    try {
      final suppliers = await _getSuppliersWithOutstanding();
      final total = suppliers.fold<double>(0, (s, sup) => s + sup.outstanding);
      emit(OutstandingSummaryLoaded(
          suppliers: suppliers, totalOutstanding: total));
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }

  Future<void> _onLoadCreditSummary(
      LoadCreditSummary event, Emitter<SupplierState> emit) async {
    emit(const SupplierLoading());
    try {
      final suppliers = await _getSuppliersWithCredit();
      final total =
          suppliers.fold<double>(0, (s, sup) => s + sup.creditBalance);
      emit(CreditSummaryLoaded(suppliers: suppliers, totalCredit: total));
    } catch (e) {
      emit(SupplierError(e.toString()));
    }
  }
}
