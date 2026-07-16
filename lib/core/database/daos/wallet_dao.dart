import 'package:drift/drift.dart';
import '../app_database.dart';

part 'wallet_dao.g.dart';

/// Data Access Object for Wallet Accounts
@DriftAccessor(tables: [WalletAccounts, LedgerEntries])
class WalletDao extends DatabaseAccessor<AppDatabase> with _$WalletDaoMixin {
  WalletDao(super.db);

  // ─── Read Operations ────────────────────────────────────────────

  /// Get all active wallet accounts
  Future<List<WalletAccount>> getAllWallets() {
    return (select(walletAccounts)
          ..where((w) => w.isActive.equals(true))
          ..orderBy([(w) => OrderingTerm.asc(w.name)]))
        .get();
  }

  /// Stream all active wallet accounts (reactive)
  Stream<List<WalletAccount>> watchAllWallets() {
    return (select(walletAccounts)
          ..where((w) => w.isActive.equals(true))
          ..orderBy([(w) => OrderingTerm.asc(w.name)]))
        .watch();
  }

  /// Get wallet by ID
  Future<WalletAccount?> getWalletById(int id) {
    return (select(walletAccounts)..where((w) => w.id.equals(id)))
        .getSingleOrNull();
  }

  /// Get total balance across all wallets
  Future<double> getTotalBalance() async {
    final query = selectOnly(walletAccounts)
      ..addColumns([walletAccounts.currentBalance.sum()])
      ..where(walletAccounts.isActive.equals(true));
    final result = await query.getSingle();
    return result.read(walletAccounts.currentBalance.sum()) ?? 0.0;
  }

  /// Get wallet ledger entries (transactions for a specific wallet)
  Future<List<LedgerEntry>> getWalletLedger({
    required int walletId,
    DateTime? from,
    DateTime? to,
  }) {
    final query = select(ledgerEntries)
      ..where((l) => l.walletAccountId.equals(walletId));
    if (from != null) query.where((l) => l.date.isBiggerOrEqualValue(from));
    if (to != null) query.where((l) => l.date.isSmallerOrEqualValue(to));
    query.orderBy([(l) => OrderingTerm.desc(l.date)]);
    return query.get();
  }

  // ─── Write Operations ────────────────────────────────────────────

  /// Insert a new wallet account
  Future<int> insertWallet(WalletAccountsCompanion wallet) {
    return into(walletAccounts).insert(wallet);
  }

  /// Update a wallet account
  Future<bool> updateWallet(WalletAccountsCompanion wallet) {
    return update(walletAccounts).replace(wallet);
  }

  /// Update wallet balance
  Future<void> updateBalance(int walletId, double newBalance) {
    return (update(walletAccounts)..where((w) => w.id.equals(walletId)))
        .write(WalletAccountsCompanion(
      currentBalance: Value(newBalance),
      updatedAt: Value(DateTime.now()),
    ));
  }

  /// Soft delete a wallet (mark as inactive)
  Future<void> softDeleteWallet(int walletId) {
    return (update(walletAccounts)..where((w) => w.id.equals(walletId)))
        .write(WalletAccountsCompanion(
      isActive: const Value(false),
      updatedAt: Value(DateTime.now()),
    ));
  }
}
