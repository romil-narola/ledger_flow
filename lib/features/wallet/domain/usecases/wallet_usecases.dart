import '../entities/wallet_account_entity.dart';
import '../repositories/wallet_repository.dart';

class GetWallets {
  final WalletRepository repository;
  GetWallets(this.repository);
  Future<List<WalletAccountEntity>> call() => repository.getWallets();
}

class WatchWallets {
  final WalletRepository repository;
  WatchWallets(this.repository);
  Stream<List<WalletAccountEntity>> call() => repository.watchWallets();
}

class GetWalletById {
  final WalletRepository repository;
  GetWalletById(this.repository);
  Future<WalletAccountEntity?> call(int id) => repository.getWalletById(id);
}

class GetTotalBalance {
  final WalletRepository repository;
  GetTotalBalance(this.repository);
  Future<double> call() => repository.getTotalBalance();
}

class AddWallet {
  final WalletRepository repository;
  AddWallet(this.repository);
  Future<int> call({
    required String name,
    required double openingBalance,
    String? notes,
    bool overdraftEnabled = false,
  }) =>
      repository.addWallet(
        name: name,
        openingBalance: openingBalance,
        notes: notes,
        overdraftEnabled: overdraftEnabled,
      );
}

class UpdateWallet {
  final WalletRepository repository;
  UpdateWallet(this.repository);
  Future<void> call(WalletAccountEntity wallet) =>
      repository.updateWallet(wallet);
}

class DeleteWallet {
  final WalletRepository repository;
  DeleteWallet(this.repository);
  Future<void> call(int walletId) => repository.deleteWallet(walletId);
}

class GetWalletHistory {
  final WalletRepository repository;
  GetWalletHistory(this.repository);
  Future<List<WalletTransactionItem>> call({
    required int walletId,
    DateTime? from,
    DateTime? to,
  }) =>
      repository.getWalletHistory(walletId: walletId, from: from, to: to);
}
