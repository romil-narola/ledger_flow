import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/wallet_usecases.dart';
import 'wallet_event_state.dart';

/// BLoC for managing wallet account state
class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final GetWallets _getWallets;
  final WatchWallets _watchWallets;
  final GetWalletById _getWalletById;
  final AddWallet _addWallet;
  final UpdateWallet _updateWallet;
  final DeleteWallet _deleteWallet;
  final GetWalletHistory _getWalletHistory;
  final GetTotalBalance _getTotalBalance;

  StreamSubscription<dynamic>? _walletsSubscription;

  WalletBloc({
    required GetWallets getWallets,
    required WatchWallets watchWallets,
    required GetWalletById getWalletById,
    required AddWallet addWallet,
    required UpdateWallet updateWallet,
    required DeleteWallet deleteWallet,
    required GetWalletHistory getWalletHistory,
    required GetTotalBalance getTotalBalance,
  })  : _getWallets = getWallets,
        _watchWallets = watchWallets,
        _getWalletById = getWalletById,
        _addWallet = addWallet,
        _updateWallet = updateWallet,
        _deleteWallet = deleteWallet,
        _getWalletHistory = getWalletHistory,
        _getTotalBalance = getTotalBalance,
        super(const WalletInitial()) {
    on<LoadWallets>(_onLoadWallets);
    on<WatchWalletsStarted>(_onWatchWalletsStarted);
    on<WalletsUpdated>(_onWalletsUpdated);
    on<AddWalletRequested>(_onAddWallet);
    on<UpdateWalletRequested>(_onUpdateWallet);
    on<DeleteWalletRequested>(_onDeleteWallet);
    on<LoadWalletHistory>(_onLoadWalletHistory);
  }

  Future<void> _onLoadWallets(
      LoadWallets event, Emitter<WalletState> emit) async {
    emit(const WalletLoading());
    try {
      final wallets = await _getWallets();
      final total = await _getTotalBalance();
      if (wallets.isEmpty) {
        emit(const WalletEmpty());
      } else {
        emit(WalletLoaded(wallets: wallets, totalBalance: total));
      }
    } catch (e) {
      emit(WalletError('Failed to load wallets: ${e.toString()}'));
    }
  }

  Future<void> _onWatchWalletsStarted(
    WatchWalletsStarted event,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletLoading());
    await emit.forEach(
      _watchWallets(),
      onData: (wallets) {
        if (wallets.isEmpty) return const WalletEmpty();
        final total =
            wallets.fold<double>(0, (sum, w) => sum + w.currentBalance);
        return WalletLoaded(wallets: wallets, totalBalance: total);
      },
      onError: (error, _) => WalletError(error.toString()),
    );
  }

  Future<void> _onWalletsUpdated(
    WalletsUpdated event,
    Emitter<WalletState> emit,
  ) async {
    final total =
        event.wallets.fold<double>(0, (sum, w) => sum + w.currentBalance);
    if (event.wallets.isEmpty) {
      emit(const WalletEmpty());
    } else {
      emit(WalletLoaded(wallets: event.wallets, totalBalance: total));
    }
  }

  Future<void> _onAddWallet(
      AddWalletRequested event, Emitter<WalletState> emit) async {
    try {
      await _addWallet(
        name: event.name,
        openingBalance: event.openingBalance,
        notes: event.notes,
        overdraftEnabled: event.overdraftEnabled,
      );
      emit(const WalletOperationSuccess('walletAddedSuccessfully'));
      add(const LoadWallets());
    } catch (e) {
      emit(WalletError('Failed to add wallet: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateWallet(
      UpdateWalletRequested event, Emitter<WalletState> emit) async {
    try {
      await _updateWallet(event.wallet);
      emit(const WalletOperationSuccess('walletUpdatedSuccessfully'));
      add(const LoadWallets());
    } catch (e) {
      emit(WalletError('Failed to update wallet: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteWallet(
      DeleteWalletRequested event, Emitter<WalletState> emit) async {
    try {
      await _deleteWallet(event.walletId);
      emit(const WalletOperationSuccess('walletDeleted'));
      add(const LoadWallets());
    } catch (e) {
      emit(WalletError('Failed to delete wallet: ${e.toString()}'));
    }
  }

  Future<void> _onLoadWalletHistory(
    LoadWalletHistory event,
    Emitter<WalletState> emit,
  ) async {
    emit(const WalletHistoryLoading());
    try {
      final wallet = await _getWalletById(event.walletId);
      if (wallet == null) {
        emit(const WalletError('walletNotFound'));
        return;
      }
      final history = await _getWalletHistory(
        walletId: event.walletId,
        from: event.from,
        to: event.to,
      );
      emit(WalletHistoryLoaded(wallet: wallet, transactions: history));
    } catch (e) {
      emit(WalletError('Failed to load wallet history: ${e.toString()}'));
    }
  }

  @override
  Future<void> close() {
    _walletsSubscription?.cancel();
    return super.close();
  }
}
