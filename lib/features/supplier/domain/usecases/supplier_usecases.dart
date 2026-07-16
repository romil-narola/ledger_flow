import '../entities/supplier_entities.dart';
import '../repositories/supplier_repository.dart';

// ─── Supplier CRUD ────────────────────────────────────────────────

class GetSuppliers {
  final SupplierRepository repository;
  GetSuppliers(this.repository);
  Future<List<SupplierEntity>> call() => repository.getSuppliers();
}

class WatchSuppliers {
  final SupplierRepository repository;
  WatchSuppliers(this.repository);
  Stream<List<SupplierEntity>> call() => repository.watchSuppliers();
}

class GetSupplierById {
  final SupplierRepository repository;
  GetSupplierById(this.repository);
  Future<SupplierEntity?> call(int id) => repository.getSupplierById(id);
}

class AddSupplier {
  final SupplierRepository repository;
  AddSupplier(this.repository);
  Future<int> call({
    required String name,
    String? phone,
    String? email,
    String? address,
    String? notes,
  }) =>
      repository.addSupplier(
          name: name,
          phone: phone,
          email: email,
          address: address,
          notes: notes);
}

class UpdateSupplier {
  final SupplierRepository repository;
  UpdateSupplier(this.repository);
  Future<void> call(SupplierEntity supplier) =>
      repository.updateSupplier(supplier);
}

class DeleteSupplier {
  final SupplierRepository repository;
  DeleteSupplier(this.repository);
  Future<void> call(int supplierId) => repository.deleteSupplier(supplierId);
}

// ─── Purchase Use Cases ───────────────────────────────────────────

class AddPurchase {
  final SupplierRepository repository;
  AddPurchase(this.repository);
  Future<int> call({
    required int supplierId,
    required int walletAccountId,
    required double amount,
    required DateTime date,
    String? notes,
    double? paidAmount,
  }) =>
      repository.addPurchase(
        supplierId: supplierId,
        walletAccountId: walletAccountId,
        amount: amount,
        date: date,
        notes: notes,
        paidAmount: paidAmount,
      );
}

class GetPurchasesBySupplier {
  final SupplierRepository repository;
  GetPurchasesBySupplier(this.repository);
  Future<List<PurchaseEntity>> call(int supplierId) =>
      repository.getPurchasesBySupplier(supplierId);
}

class GetAllPurchases {
  final SupplierRepository repository;
  GetAllPurchases(this.repository);
  Future<List<PurchaseEntity>> call({DateTime? from, DateTime? to}) =>
      repository.getAllPurchases(from: from, to: to);
}

class GetMonthlyPurchases {
  final SupplierRepository repository;
  GetMonthlyPurchases(this.repository);
  Future<double> call(DateTime month) => repository.getMonthlyPurchases(month);
}

// ─── Payment Use Cases ────────────────────────────────────────────

class AddSupplierPayment {
  final SupplierRepository repository;
  AddSupplierPayment(this.repository);
  Future<int> call({
    required int supplierId,
    required int walletAccountId,
    required double amount,
    required DateTime date,
    String? notes,
  }) =>
      repository.addPayment(
        supplierId: supplierId,
        walletAccountId: walletAccountId,
        amount: amount,
        date: date,
        notes: notes,
      );
}

class GetPaymentsBySupplier {
  final SupplierRepository repository;
  GetPaymentsBySupplier(this.repository);
  Future<List<SupplierPaymentEntity>> call(int supplierId) =>
      repository.getPaymentsBySupplier(supplierId);
}

// ─── Summary Use Cases ────────────────────────────────────────────

class GetSupplierLedger {
  final SupplierRepository repository;
  GetSupplierLedger(this.repository);
  Future<List<SupplierLedgerEntry>> call(int supplierId) =>
      repository.getSupplierLedger(supplierId);
}

class GetSuppliersWithOutstanding {
  final SupplierRepository repository;
  GetSuppliersWithOutstanding(this.repository);
  Future<List<SupplierEntity>> call() =>
      repository.getSuppliersWithOutstanding();
}

class GetSuppliersWithCredit {
  final SupplierRepository repository;
  GetSuppliersWithCredit(this.repository);
  Future<List<SupplierEntity>> call() => repository.getSuppliersWithCredit();
}
