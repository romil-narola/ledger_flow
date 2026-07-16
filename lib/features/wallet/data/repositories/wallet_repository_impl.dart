import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/database/daos/wallet_dao.dart';
import '../../domain/entities/wallet_account_entity.dart';
import '../../domain/repositories/wallet_repository.dart';

/// Implementation of WalletRepository using Drift SQLite
class WalletRepositoryImpl implements WalletRepository {
  final WalletDao _walletDao;

  WalletRepositoryImpl(this._walletDao);

  // ─── Mappers ────────────────────────────────────────────────────

  WalletAccountEntity _mapToEntity(WalletAccount model) {
    return WalletAccountEntity(
      id: model.id,
      name: model.name,
      openingBalance: model.openingBalance,
      currentBalance: model.currentBalance,
      notes: model.notes,
      isActive: model.isActive,
      overdraftEnabled: model.overdraftEnabled,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  // ─── Read Operations ────────────────────────────────────────────

  @override
  Future<List<WalletAccountEntity>> getWallets() async {
    final models = await _walletDao.getAllWallets();
    return models.map(_mapToEntity).toList();
  }

  @override
  Stream<List<WalletAccountEntity>> watchWallets() {
    return _walletDao.watchAllWallets().map(
          (models) => models.map(_mapToEntity).toList(),
        );
  }

  @override
  Future<WalletAccountEntity?> getWalletById(int id) async {
    final model = await _walletDao.getWalletById(id);
    return model != null ? _mapToEntity(model) : null;
  }

  @override
  Future<double> getTotalBalance() => _walletDao.getTotalBalance();

  @override
  Future<List<WalletTransactionItem>> getWalletHistory({
    required int walletId,
    DateTime? from,
    DateTime? to,
  }) async {
    final entries = await _walletDao.getWalletLedger(
      walletId: walletId,
      from: from,
      to: to,
    );
    return entries
        .map((e) => WalletTransactionItem(
              id: e.id,
              referenceNumber: e.referenceNumber,
              transactionType: e.transactionType,
              description: e.description,
              debit: e.debit,
              credit: e.credit,
              balance: e.walletBalance,
              date: e.date,
            ))
        .toList();
  }

  // ─── Write Operations ────────────────────────────────────────────

  @override
  Future<int> addWallet({
    required String name,
    required double openingBalance,
    String? notes,
    bool overdraftEnabled = false,
  }) async {
    final companion = WalletAccountsCompanion.insert(
      name: name,
      openingBalance: Value(openingBalance),
      currentBalance: Value(openingBalance), // Current = Opening at creation
      notes: Value(notes),
      overdraftEnabled: Value(overdraftEnabled),
    );
    return _walletDao.insertWallet(companion);
  }

  @override
  Future<void> updateWallet(WalletAccountEntity wallet) async {
    final companion = WalletAccountsCompanion(
      id: Value(wallet.id),
      name: Value(wallet.name),
      openingBalance: Value(wallet.openingBalance),
      notes: Value(wallet.notes),
      overdraftEnabled: Value(wallet.overdraftEnabled),
      updatedAt: Value(DateTime.now()),
    );
    await _walletDao.updateWallet(companion);
  }

  @override
  Future<void> deleteWallet(int walletId) =>
      _walletDao.softDeleteWallet(walletId);
}
