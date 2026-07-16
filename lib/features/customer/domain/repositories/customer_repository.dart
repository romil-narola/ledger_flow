import '../entities/customer_entities.dart';

abstract class CustomerRepository {
  Future<List<CustomerEntity>> getCustomers();
  Stream<List<CustomerEntity>> watchCustomers();
  Future<CustomerEntity?> getCustomerById(int id);
  Future<int> addCustomer(
      {required String name,
      String? phone,
      String? email,
      String? address,
      String? notes});
  Future<void> updateCustomer(CustomerEntity customer);
  Future<void> deleteCustomer(int customerId);

  Future<int> addSale({
    required int customerId,
    required double amount,
    required DateTime date,
    String? notes,
    int? walletAccountId,
    double? paidAmount,
  });
  Future<List<SaleEntity>> getSalesByCustomer(int customerId);
  Future<List<SaleEntity>> getAllSales({DateTime? from, DateTime? to});
  Future<double> getMonthlySales(DateTime month);

  Future<int> addPayment(
      {required int customerId,
      required int walletAccountId,
      required double amount,
      required DateTime date,
      String? notes});
  Future<List<CustomerPaymentEntity>> getPaymentsByCustomer(int customerId);
  Future<List<CustomerPaymentEntity>> getAllPayments(
      {DateTime? from, DateTime? to});

  Future<List<CustomerLedgerEntry>> getCustomerLedger(int customerId);

  Future<double> getTotalOutstanding();
  Future<double> getTotalAdvance();
  Future<List<CustomerEntity>> getCustomersWithOutstanding();
  Future<List<CustomerEntity>> getCustomersWithAdvance();
}
