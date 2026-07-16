import 'package:equatable/equatable.dart';
import '../../../ledger/ledger.dart';

/// Dashboard summary data
class DashboardSummary extends Equatable {
  final double totalWalletBalance;
  final double supplierOutstanding;
  final double supplierCredit;
  final double customerOutstanding;
  final double customerAdvance;
  final double monthlyPurchases;
  final double monthlySales;
  final int todayTransactionCount;
  final List<LedgerEntryEntity> recentTransactions;
  final List<MonthlyData> last6MonthsPurchases;
  final List<MonthlyData> last6MonthsSales;

  const DashboardSummary({
    required this.totalWalletBalance,
    required this.supplierOutstanding,
    required this.supplierCredit,
    required this.customerOutstanding,
    required this.customerAdvance,
    required this.monthlyPurchases,
    required this.monthlySales,
    required this.todayTransactionCount,
    required this.recentTransactions,
    required this.last6MonthsPurchases,
    required this.last6MonthsSales,
  });

  @override
  List<Object?> get props => [
        totalWalletBalance,
        supplierOutstanding,
        supplierCredit,
        customerOutstanding,
        customerAdvance,
        monthlyPurchases,
        monthlySales,
        todayTransactionCount,
      ];
}

class MonthlyData {
  final String label; // e.g., "Jun"
  final double amount;
  final DateTime month;

  const MonthlyData(
      {required this.label, required this.amount, required this.month});
}

// ═══════════════════════════════════════════════════════════════════
// EVENTS & STATES
// ═══════════════════════════════════════════════════════════════════

abstract class DashboardEvent extends Equatable {
  const DashboardEvent();
  @override
  List<Object?> get props => [];
}

class LoadDashboard extends DashboardEvent {
  const LoadDashboard();
}

class RefreshDashboard extends DashboardEvent {
  const RefreshDashboard();
}

abstract class DashboardState extends Equatable {
  const DashboardState();
  @override
  List<Object?> get props => [];
}

class DashboardInitial extends DashboardState {
  const DashboardInitial();
}

class DashboardLoading extends DashboardState {
  const DashboardLoading();
}

class DashboardRefreshing extends DashboardState {
  final DashboardSummary summary;
  const DashboardRefreshing(this.summary);
  @override
  List<Object?> get props => [summary];
}

class DashboardLoaded extends DashboardState {
  final DashboardSummary summary;
  const DashboardLoaded(this.summary);
  @override
  List<Object?> get props => [summary];
}

class DashboardError extends DashboardState {
  final String message;
  const DashboardError(this.message);
  @override
  List<Object?> get props => [message];
}
