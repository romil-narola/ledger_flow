import '../../../../core/core.dart';
import '../../../../core/database/daos/ledger_dao.dart';
import '../../../../core/database/daos/wallet_dao.dart';
import '../../../../core/database/daos/supplier_dao.dart';
import '../../../../core/database/daos/customer_dao.dart';
import '../../../../core/database/app_database.dart';
import '../../ledger.dart';

class LedgerRepositoryImpl implements LedgerRepository {
  final LedgerDao _ledgerDao;
  final WalletDao _walletDao;
  final SupplierDao _supplierDao;
  final CustomerDao _customerDao;

  LedgerRepositoryImpl({
    required LedgerDao ledgerDao,
    required WalletDao walletDao,
    required SupplierDao supplierDao,
    required CustomerDao customerDao,
  })  : _ledgerDao = ledgerDao,
        _walletDao = walletDao,
        _supplierDao = supplierDao,
        _customerDao = customerDao;

  Future<LedgerEntryEntity> _mapEntry(LedgerEntry e) async {
    String? walletName;
    String? supplierName;
    String? customerName;

    if (e.walletAccountId != null) {
      final wallet = await _walletDao.getWalletById(e.walletAccountId!);
      walletName = wallet?.name;
    }
    if (e.supplierId != null) {
      final supplier = await _supplierDao.getSupplierById(e.supplierId!);
      supplierName = supplier?.name;
    }
    if (e.customerId != null) {
      final customer = await _customerDao.getCustomerById(e.customerId!);
      customerName = customer?.name;
    }

    return LedgerEntryEntity(
      id: e.id,
      referenceNumber: e.referenceNumber,
      transactionType: TransactionType.values.firstWhere(
        (t) => t.name == e.transactionType,
        orElse: () => TransactionType.walletAdjustment,
      ),
      walletAccountId: e.walletAccountId,
      walletName: walletName,
      supplierId: e.supplierId,
      supplierName: supplierName,
      customerId: e.customerId,
      customerName: customerName,
      debit: e.debit,
      credit: e.credit,
      walletBalance: e.walletBalance,
      description: e.description,
      date: e.date,
      createdAt: e.createdAt,
    );
  }

  @override
  Future<List<LedgerEntryEntity>> getEntries({
    DateTime? from,
    DateTime? to,
    String? transactionType,
    int? walletId,
    int? supplierId,
    int? customerId,
    int limit = 100,
    int offset = 0,
  }) async {
    final entries = await _ledgerDao.getAllEntries(
      from: from,
      to: to,
      transactionType: transactionType,
      walletId: walletId,
      supplierId: supplierId,
      customerId: customerId,
      limit: limit,
      offset: offset,
    );
    return Future.wait(entries.map(_mapEntry));
  }

  @override
  Future<List<LedgerEntryEntity>> getTodayEntries() async {
    final entries = await _ledgerDao.getTodayEntries();
    return Future.wait(entries.map(_mapEntry));
  }

  @override
  Future<List<LedgerEntryEntity>> searchEntries(String query) async {
    final entries = await _ledgerDao.searchEntries(query);
    return Future.wait(entries.map(_mapEntry));
  }

  @override
  Future<LedgerEntryEntity?> getEntryById(int id) async {
    final entry = await _ledgerDao.getEntryById(id);
    if (entry == null) return null;
    return _mapEntry(entry);
  }

  @override
  Stream<List<LedgerEntryEntity>> watchRecentEntries({int limit = 50}) {
    return _ledgerDao.watchAllEntries(limit: limit).asyncMap(
          (entries) => Future.wait(entries.map(_mapEntry)),
        );
  }
}
