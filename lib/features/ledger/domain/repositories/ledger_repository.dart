import '../entities/ledger_entry_entity.dart';

abstract class LedgerRepository {
  Future<List<LedgerEntryEntity>> getEntries({
    DateTime? from,
    DateTime? to,
    String? transactionType,
    int? walletId,
    int? supplierId,
    int? customerId,
    int limit,
    int offset,
  });

  Future<List<LedgerEntryEntity>> getTodayEntries();
  Future<List<LedgerEntryEntity>> searchEntries(String query);
  Future<LedgerEntryEntity?> getEntryById(int id);
  Stream<List<LedgerEntryEntity>> watchRecentEntries({int limit});
}
