import 'package:equatable/equatable.dart';
import '../../domain/entities/ledger_entry_entity.dart';

// ═══════════════════════════════════════════════════════════════════
// EVENTS
// ═══════════════════════════════════════════════════════════════════

abstract class LedgerEvent extends Equatable {
  const LedgerEvent();
  @override
  List<Object?> get props => [];
}

class LoadLedger extends LedgerEvent {
  final DateTime? from;
  final DateTime? to;
  final String? transactionType;
  final int? walletId;
  const LoadLedger({this.from, this.to, this.transactionType, this.walletId});
  @override
  List<Object?> get props => [from, to, transactionType, walletId];
}

class WatchRecentLedger extends LedgerEvent {
  const WatchRecentLedger();
}

class SearchLedger extends LedgerEvent {
  final String query;
  const SearchLedger(this.query);
  @override
  List<Object?> get props => [query];
}

class LoadLedgerEntry extends LedgerEvent {
  final int entryId;
  const LoadLedgerEntry(this.entryId);
  @override
  List<Object?> get props => [entryId];
}

class LoadMoreLedger extends LedgerEvent {
  final int offset;
  const LoadMoreLedger(this.offset);
  @override
  List<Object?> get props => [offset];
}

class ClearLedgerFilter extends LedgerEvent {
  const ClearLedgerFilter();
}

// ═══════════════════════════════════════════════════════════════════
// STATES
// ═══════════════════════════════════════════════════════════════════

abstract class LedgerState extends Equatable {
  const LedgerState();
  @override
  List<Object?> get props => [];
}

class LedgerInitial extends LedgerState {
  const LedgerInitial();
}

class LedgerLoading extends LedgerState {
  const LedgerLoading();
}

class LedgerEmpty extends LedgerState {
  const LedgerEmpty();
}

class LedgerLoaded extends LedgerState {
  final List<LedgerEntryEntity> entries;
  final bool hasMore;
  final DateTime? fromFilter;
  final DateTime? toFilter;
  final String? typeFilter;
  final String? searchQuery;

  const LedgerLoaded({
    required this.entries,
    this.hasMore = false,
    this.fromFilter,
    this.toFilter,
    this.typeFilter,
    this.searchQuery,
  });

  @override
  List<Object?> get props =>
      [entries, hasMore, fromFilter, toFilter, typeFilter, searchQuery];

  LedgerLoaded copyWith({
    List<LedgerEntryEntity>? entries,
    bool? hasMore,
    DateTime? fromFilter,
    DateTime? toFilter,
    String? typeFilter,
    String? searchQuery,
  }) {
    return LedgerLoaded(
      entries: entries ?? this.entries,
      hasMore: hasMore ?? this.hasMore,
      fromFilter: fromFilter ?? this.fromFilter,
      toFilter: toFilter ?? this.toFilter,
      typeFilter: typeFilter ?? this.typeFilter,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }
}

class LedgerEntryDetailLoaded extends LedgerState {
  final LedgerEntryEntity entry;
  const LedgerEntryDetailLoaded(this.entry);
  @override
  List<Object?> get props => [entry];
}

class LedgerError extends LedgerState {
  final String message;
  const LedgerError(this.message);
  @override
  List<Object?> get props => [message];
}
