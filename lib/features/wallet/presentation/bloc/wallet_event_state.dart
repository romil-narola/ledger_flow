import 'package:equatable/equatable.dart';
import '../../domain/entities/wallet_account_entity.dart';
import '../../domain/repositories/wallet_repository.dart';

// ═══════════════════════════════════════════════════════════════════
// EVENTS
// ═══════════════════════════════════════════════════════════════════

abstract class WalletEvent extends Equatable {
  const WalletEvent();
  @override
  List<Object?> get props => [];
}

class LoadWallets extends WalletEvent {
  const LoadWallets();
}

class WatchWalletsStarted extends WalletEvent {
  const WatchWalletsStarted();
}

class WalletsUpdated extends WalletEvent {
  final List<WalletAccountEntity> wallets;
  const WalletsUpdated(this.wallets);
  @override
  List<Object?> get props => [wallets];
}

class AddWalletRequested extends WalletEvent {
  final String name;
  final double openingBalance;
  final String? notes;
  final bool overdraftEnabled;

  const AddWalletRequested({
    required this.name,
    required this.openingBalance,
    this.notes,
    this.overdraftEnabled = false,
  });

  @override
  List<Object?> get props => [name, openingBalance, notes, overdraftEnabled];
}

class UpdateWalletRequested extends WalletEvent {
  final WalletAccountEntity wallet;
  const UpdateWalletRequested(this.wallet);
  @override
  List<Object?> get props => [wallet];
}

class DeleteWalletRequested extends WalletEvent {
  final int walletId;
  const DeleteWalletRequested(this.walletId);
  @override
  List<Object?> get props => [walletId];
}

class LoadWalletHistory extends WalletEvent {
  final int walletId;
  final DateTime? from;
  final DateTime? to;

  const LoadWalletHistory({required this.walletId, this.from, this.to});
  @override
  List<Object?> get props => [walletId, from, to];
}

// ═══════════════════════════════════════════════════════════════════
// STATES
// ═══════════════════════════════════════════════════════════════════

abstract class WalletState extends Equatable {
  const WalletState();
  @override
  List<Object?> get props => [];
}

class WalletInitial extends WalletState {
  const WalletInitial();
}

class WalletLoading extends WalletState {
  const WalletLoading();
}

class WalletLoaded extends WalletState {
  final List<WalletAccountEntity> wallets;
  final double totalBalance;

  const WalletLoaded({required this.wallets, required this.totalBalance});

  @override
  List<Object?> get props => [wallets, totalBalance];
}

class WalletEmpty extends WalletState {
  const WalletEmpty();
}

class WalletOperationSuccess extends WalletState {
  final String message;
  const WalletOperationSuccess(this.message);
  @override
  List<Object?> get props => [message];
}

class WalletError extends WalletState {
  final String message;
  const WalletError(this.message);
  @override
  List<Object?> get props => [message];
}

class WalletHistoryLoading extends WalletState {
  const WalletHistoryLoading();
}

class WalletHistoryLoaded extends WalletState {
  final WalletAccountEntity wallet;
  final List<WalletTransactionItem> transactions;

  const WalletHistoryLoaded({required this.wallet, required this.transactions});
  @override
  List<Object?> get props => [wallet, transactions];
}
