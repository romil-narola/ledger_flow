import 'package:drift/drift.dart';
import '../app_database.dart';

import 'scoped_business_dao.dart';

part 'ledger_dao.g.dart';

/// Data Access Object for Ledger Entries
@DriftAccessor(tables: [LedgerEntries])
class LedgerDao extends DatabaseAccessor<AppDatabase>
    with _$LedgerDaoMixin, ScopedBusinessDao {
  LedgerDao(super.db);

  // ─── Read Operations ────────────────────────────────────────────

  /// Get all ledger entries ordered by date descending
  Future<List<LedgerEntry>> getAllEntries({
    DateTime? from,
    DateTime? to,
    String? transactionType,
    int? walletId,
    int? supplierId,
    int? customerId,
    int limit = 100,
    int offset = 0,
  }) {
    final query = select(ledgerEntries)
      ..where((t) => t.businessId.equals(currentBusinessId))
      ..orderBy(
          [(l) => OrderingTerm.desc(l.date), (l) => OrderingTerm.desc(l.id)])
      ..limit(limit, offset: offset);

    if (from != null) query.where((l) => l.businessId.equals(currentBusinessId) & l.date.isBiggerOrEqualValue(from));
    if (to != null) query.where((l) => l.businessId.equals(currentBusinessId) & l.date.isSmallerOrEqualValue(to));
    if (transactionType != null) {
      query.where((l) => l.transactionType.equals(transactionType));
    }
    if (walletId != null) {
      query.where((l) => l.walletAccountId.equals(walletId) & l.businessId.equals(currentBusinessId));
    }
    if (supplierId != null) query.where((l) => l.supplierId.equals(supplierId) & l.businessId.equals(currentBusinessId));
    if (customerId != null) query.where((l) => l.customerId.equals(customerId) & l.businessId.equals(currentBusinessId));

    return query.get();
  }

  /// Stream all ledger entries (reactive)
  Stream<List<LedgerEntry>> watchAllEntries({int limit = 50}) {
    return (select(ledgerEntries)
      ..where((t) => t.businessId.equals(currentBusinessId))
      ..orderBy([
            (l) => OrderingTerm.desc(l.date),
            (l) => OrderingTerm.desc(l.id)
          ])
          ..limit(limit))
        .watch();
  }

  /// Get today's transactions
  Future<List<LedgerEntry>> getTodayEntries() {
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59, 999);
    return (select(ledgerEntries)
          ..where((l) =>
              l.date.isBiggerOrEqualValue(startOfDay) &
              l.date.isSmallerOrEqualValue(endOfDay) &
              l.businessId.equals(currentBusinessId))
          ..orderBy([(l) => OrderingTerm.desc(l.date)]))
        .get();
  }

  /// Get entries for a specific supplier
  Future<List<LedgerEntry>> getSupplierLedger(int supplierId) {
    return (select(ledgerEntries)
          ..where((l) => l.supplierId.equals(supplierId) & l.businessId.equals(currentBusinessId))
          ..orderBy([(l) => OrderingTerm.desc(l.date)]))
        .get();
  }

  /// Get entries for a specific customer
  Future<List<LedgerEntry>> getCustomerLedger(int customerId) {
    return (select(ledgerEntries)
          ..where((l) => l.customerId.equals(customerId) & l.businessId.equals(currentBusinessId))
          ..orderBy([(l) => OrderingTerm.desc(l.date)]))
        .get();
  }

  /// Get entry by ID
  Future<LedgerEntry?> getEntryById(int id) {
    return (select(ledgerEntries)..where((l) => l.id.equals(id) & l.businessId.equals(currentBusinessId)))
        .getSingleOrNull();
  }

  // ─── Write Operations ────────────────────────────────────────────

  /// Insert a ledger entry
  Future<int> insertEntry(LedgerEntriesCompanion entry) {
    return into(ledgerEntries).insert(entry.copyWith(businessId: Value(currentBusinessId)));
  }

  /// Get the last wallet balance from ledger for a given wallet
  Future<double> getLastWalletBalance(int walletId) async {
    final query = select(ledgerEntries)
      ..where((l) => l.walletAccountId.equals(walletId) & l.businessId.equals(currentBusinessId))
      ..orderBy(
          [(l) => OrderingTerm.desc(l.date), (l) => OrderingTerm.desc(l.id)])
      ..limit(1);
    final result = await query.getSingleOrNull();
    return result?.walletBalance ?? 0.0;
  }

  /// Search ledger entries by description or reference number
  Future<List<LedgerEntry>> searchEntries(String query) {
    return (select(ledgerEntries)
          ..where((l) =>
              (l.description.like('%$query%') |
              l.referenceNumber.like('%$query%')) & l.businessId.equals(currentBusinessId))
          ..orderBy([(l) => OrderingTerm.desc(l.date)])
          ..limit(50))
        .get();
  }

  /// Delete entries matching reference number
  Future<int> deleteByReference(String referenceNumber) {
    return (delete(ledgerEntries)
          ..where((l) => l.referenceNumber.equals(referenceNumber) & l.businessId.equals(currentBusinessId)))
        .go();
  }

  /// Get count of all entries
  Future<int> getEntryCount() async {
    final countExp = ledgerEntries.id.count();
    final query = selectOnly(ledgerEntries)..addColumns([countExp])..where(ledgerEntries.businessId.equals(currentBusinessId));
    final result = await query.getSingle();
    return result.read(countExp) ?? 0;
  }
}
