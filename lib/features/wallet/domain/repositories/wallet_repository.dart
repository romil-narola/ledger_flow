import '../../domain/entities/wallet_account_entity.dart';

/// Repository interface for Wallet operations
abstract class WalletRepository {
  /// Get all active wallets
  Future<List<WalletAccountEntity>> getWallets();

  /// Stream all wallets (reactive updates)
  Stream<List<WalletAccountEntity>> watchWallets();

  /// Get wallet by ID
  Future<WalletAccountEntity?> getWalletById(int id);

  /// Get total balance across all wallets
  Future<double> getTotalBalance();

  /// Add a new wallet account
  Future<int> addWallet({
    required String name,
    required double openingBalance,
    String? notes,
    bool overdraftEnabled = false,
  });

  /// Update wallet account details
  Future<void> updateWallet(WalletAccountEntity wallet);

  /// Delete wallet (soft delete)
  Future<void> deleteWallet(int walletId);

  /// Get wallet transaction history from ledger
  Future<List<WalletTransactionItem>> getWalletHistory({
    required int walletId,
    DateTime? from,
    DateTime? to,
  });
}

/// Represents a wallet transaction history item
class WalletTransactionItem {
  final int id;
  final String referenceNumber;
  final String transactionType;
  final String description;
  final double debit;
  final double credit;
  final double balance;
  final DateTime date;

  const WalletTransactionItem({
    required this.id,
    required this.referenceNumber,
    required this.transactionType,
    required this.description,
    required this.debit,
    required this.credit,
    required this.balance,
    required this.date,
  });
}
