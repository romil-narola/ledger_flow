import '../entities/supplier_entities.dart';

/// Repository interface for Supplier operations
abstract class SupplierRepository {
  // ─── Suppliers ────────────────────────────────────────────────────
  Future<List<SupplierEntity>> getSuppliers();
  Stream<List<SupplierEntity>> watchSuppliers();
  Future<SupplierEntity?> getSupplierById(int id);
  Future<int> addSupplier({
    required String name,
    String? phone,
    String? email,
    String? address,
    String? notes,
  });
  Future<void> updateSupplier(SupplierEntity supplier);
  Future<void> deleteSupplier(int supplierId);

  // ─── Purchases ───────────────────────────────────────────────────
  Future<int> addPurchase({
    required int supplierId,
    required int walletAccountId,
    required double amount,
    required DateTime date,
    String? notes,
    double? paidAmount,
  });
  Future<List<PurchaseEntity>> getPurchasesBySupplier(int supplierId);
  Future<List<PurchaseEntity>> getAllPurchases({DateTime? from, DateTime? to});
  Future<double> getMonthlyPurchases(DateTime month);

  // ─── Supplier Payments ───────────────────────────────────────────
  Future<int> addPayment({
    required int supplierId,
    required int walletAccountId,
    required double amount,
    required DateTime date,
    String? notes,
  });
  Future<List<SupplierPaymentEntity>> getPaymentsBySupplier(int supplierId);
  Future<List<SupplierPaymentEntity>> getAllPayments(
      {DateTime? from, DateTime? to});

  // ─── Ledger ───────────────────────────────────────────────────────
  Future<List<SupplierLedgerEntry>> getSupplierLedger(int supplierId);

  // ─── Summaries ────────────────────────────────────────────────────
  Future<double> getTotalOutstanding();
  Future<double> getTotalCredit();
  Future<List<SupplierEntity>> getSuppliersWithOutstanding();
  Future<List<SupplierEntity>> getSuppliersWithCredit();
}
