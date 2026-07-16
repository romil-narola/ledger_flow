import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/ledger_repository.dart';
import 'ledger_event_state.dart';

class LedgerBloc extends Bloc<LedgerEvent, LedgerState> {
  final LedgerRepository _repository;
  static const int _pageSize = 50;

  LedgerBloc(this._repository) : super(const LedgerInitial()) {
    on<LoadLedger>(_onLoadLedger);
    on<WatchRecentLedger>(_onWatchRecentLedger);
    on<SearchLedger>(_onSearchLedger);
    on<LoadLedgerEntry>(_onLoadEntry);
    on<LoadMoreLedger>(_onLoadMore);
    on<ClearLedgerFilter>(_onClearFilter);
  }

  Future<void> _onLoadLedger(
      LoadLedger event, Emitter<LedgerState> emit) async {
    emit(const LedgerLoading());
    try {
      final entries = await _repository.getEntries(
        from: event.from,
        to: event.to,
        transactionType: event.transactionType,
        walletId: event.walletId,
        limit: _pageSize,
        offset: 0,
      );
      if (entries.isEmpty) {
        emit(const LedgerEmpty());
      } else {
        emit(LedgerLoaded(
          entries: entries,
          hasMore: entries.length == _pageSize,
          fromFilter: event.from,
          toFilter: event.to,
          typeFilter: event.transactionType,
        ));
      }
    } catch (e) {
      emit(LedgerError(e.toString()));
    }
  }

  Future<void> _onWatchRecentLedger(
      WatchRecentLedger event, Emitter<LedgerState> emit) async {
    emit(const LedgerLoading());
    await emit.forEach(
      _repository.watchRecentEntries(limit: _pageSize),
      onData: (entries) => entries.isEmpty
          ? const LedgerEmpty()
          : LedgerLoaded(entries: entries),
      onError: (e, _) => LedgerError(e.toString()),
    );
  }

  Future<void> _onSearchLedger(
      SearchLedger event, Emitter<LedgerState> emit) async {
    if (event.query.trim().isEmpty) {
      add(const LoadLedger());
      return;
    }
    emit(const LedgerLoading());
    try {
      final entries = await _repository.searchEntries(event.query);
      if (entries.isEmpty) {
        emit(const LedgerEmpty());
      } else {
        emit(LedgerLoaded(entries: entries, searchQuery: event.query));
      }
    } catch (e) {
      emit(LedgerError(e.toString()));
    }
  }

  Future<void> _onLoadEntry(
      LoadLedgerEntry event, Emitter<LedgerState> emit) async {
    try {
      final entry = await _repository.getEntryById(event.entryId);
      if (entry != null) emit(LedgerEntryDetailLoaded(entry));
    } catch (e) {
      emit(LedgerError(e.toString()));
    }
  }

  Future<void> _onLoadMore(
      LoadMoreLedger event, Emitter<LedgerState> emit) async {
    final current = state;
    if (current is! LedgerLoaded) return;
    try {
      final more = await _repository.getEntries(
        from: current.fromFilter,
        to: current.toFilter,
        transactionType: current.typeFilter,
        limit: _pageSize,
        offset: event.offset,
      );
      emit(current.copyWith(
        entries: [...current.entries, ...more],
        hasMore: more.length == _pageSize,
      ));
    } catch (e) {
      emit(LedgerError(e.toString()));
    }
  }

  Future<void> _onClearFilter(
      ClearLedgerFilter event, Emitter<LedgerState> emit) async {
    add(const LoadLedger());
  }
}
