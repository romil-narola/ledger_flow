import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../../wallet/domain/repositories/wallet_repository.dart';
import '../../../supplier/domain/repositories/supplier_repository.dart';
import '../../../customer/domain/repositories/customer_repository.dart';
import '../../../ledger/domain/repositories/ledger_repository.dart';
import 'dashboard_event_state.dart';

class DashboardBloc extends Bloc<DashboardEvent, DashboardState> {
  final WalletRepository _walletRepo;
  final SupplierRepository _supplierRepo;
  final CustomerRepository _customerRepo;
  final LedgerRepository _ledgerRepo;

  DashboardBloc({
    required WalletRepository walletRepository,
    required SupplierRepository supplierRepository,
    required CustomerRepository customerRepository,
    required LedgerRepository ledgerRepository,
  })  : _walletRepo = walletRepository,
        _supplierRepo = supplierRepository,
        _customerRepo = customerRepository,
        _ledgerRepo = ledgerRepository,
        super(const DashboardInitial()) {
    on<LoadDashboard>(_onLoadDashboard);
    on<RefreshDashboard>(_onRefreshDashboard);
  }

  Future<void> _onLoadDashboard(
      LoadDashboard event, Emitter<DashboardState> emit) async {
    emit(const DashboardLoading());
    try {
      final summary = await _fetchSummary();
      emit(DashboardLoaded(summary));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<void> _onRefreshDashboard(
      RefreshDashboard event, Emitter<DashboardState> emit) async {
    final current = state;
    if (current is DashboardLoaded) {
      emit(DashboardRefreshing(current.summary));
    }
    try {
      final summary = await _fetchSummary();
      emit(DashboardLoaded(summary));
    } catch (e) {
      emit(DashboardError(e.toString()));
    }
  }

  Future<DashboardSummary> _fetchSummary() async {
    final now = DateTime.now();
    final fmt = DateFormat('MMM');

    // Fetch all data in parallel
    final results = await Future.wait([
      _walletRepo.getTotalBalance(),
      _supplierRepo.getTotalOutstanding(),
      _supplierRepo.getTotalCredit(),
      _customerRepo.getTotalOutstanding(),
      _customerRepo.getTotalAdvance(),
      _supplierRepo.getMonthlyPurchases(now),
      _customerRepo.getMonthlySales(now),
      _ledgerRepo.getTodayEntries(),
      _ledgerRepo.getEntries(limit: 10, offset: 0),
    ]);

    // Build last 6 months purchase/sales data
    final monthlyPurchases = <MonthlyData>[];
    final monthlySales = <MonthlyData>[];

    for (int i = 5; i >= 0; i--) {
      final month = DateTime(now.year, now.month - i, 1);
      final purchaseAmount = await _supplierRepo.getMonthlyPurchases(month);
      final salesAmount = await _customerRepo.getMonthlySales(month);
      monthlyPurchases.add(MonthlyData(
        label: fmt.format(month),
        amount: purchaseAmount,
        month: month,
      ));
      monthlySales.add(MonthlyData(
        label: fmt.format(month),
        amount: salesAmount,
        month: month,
      ));
    }

    return DashboardSummary(
      totalWalletBalance: results[0] as double,
      supplierOutstanding: results[1] as double,
      supplierCredit: results[2] as double,
      customerOutstanding: results[3] as double,
      customerAdvance: results[4] as double,
      monthlyPurchases: results[5] as double,
      monthlySales: results[6] as double,
      todayTransactionCount: (results[7] as List).length,
      recentTransactions: (results[8] as List).cast(),
      last6MonthsPurchases: monthlyPurchases,
      last6MonthsSales: monthlySales,
    );
  }
}
