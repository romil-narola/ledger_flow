import '../entities/customer_entities.dart';
import '../repositories/customer_repository.dart';

class GetCustomers {
  final CustomerRepository repository;
  GetCustomers(this.repository);
  Future<List<CustomerEntity>> call() => repository.getCustomers();
}

class WatchCustomers {
  final CustomerRepository repository;
  WatchCustomers(this.repository);
  Stream<List<CustomerEntity>> call() => repository.watchCustomers();
}

class GetCustomerById {
  final CustomerRepository repository;
  GetCustomerById(this.repository);
  Future<CustomerEntity?> call(int id) => repository.getCustomerById(id);
}

class AddCustomer {
  final CustomerRepository repository;
  AddCustomer(this.repository);
  Future<int> call(
          {required String name,
          String? phone,
          String? email,
          String? address,
          String? notes}) =>
      repository.addCustomer(
          name: name,
          phone: phone,
          email: email,
          address: address,
          notes: notes);
}

class UpdateCustomer {
  final CustomerRepository repository;
  UpdateCustomer(this.repository);
  Future<void> call(CustomerEntity customer) =>
      repository.updateCustomer(customer);
}

class DeleteCustomer {
  final CustomerRepository repository;
  DeleteCustomer(this.repository);
  Future<void> call(int customerId) => repository.deleteCustomer(customerId);
}

class AddSale {
  final CustomerRepository repository;
  AddSale(this.repository);
  Future<int> call({
    required int customerId,
    required double amount,
    required DateTime date,
    String? notes,
    int? walletAccountId,
    double? paidAmount,
  }) =>
      repository.addSale(
        customerId: customerId,
        amount: amount,
        date: date,
        notes: notes,
        walletAccountId: walletAccountId,
        paidAmount: paidAmount,
      );
}

class GetSalesByCustomer {
  final CustomerRepository repository;
  GetSalesByCustomer(this.repository);
  Future<List<SaleEntity>> call(int customerId) =>
      repository.getSalesByCustomer(customerId);
}

class GetAllSales {
  final CustomerRepository repository;
  GetAllSales(this.repository);
  Future<List<SaleEntity>> call({DateTime? from, DateTime? to}) =>
      repository.getAllSales(from: from, to: to);
}

class GetMonthlySales {
  final CustomerRepository repository;
  GetMonthlySales(this.repository);
  Future<double> call(DateTime month) => repository.getMonthlySales(month);
}

class AddCustomerPayment {
  final CustomerRepository repository;
  AddCustomerPayment(this.repository);
  Future<int> call(
          {required int customerId,
          required int walletAccountId,
          required double amount,
          required DateTime date,
          String? notes}) =>
      repository.addPayment(
          customerId: customerId,
          walletAccountId: walletAccountId,
          amount: amount,
          date: date,
          notes: notes);
}

class GetPaymentsByCustomer {
  final CustomerRepository repository;
  GetPaymentsByCustomer(this.repository);
  Future<List<CustomerPaymentEntity>> call(int customerId) =>
      repository.getPaymentsByCustomer(customerId);
}

class GetCustomerLedger {
  final CustomerRepository repository;
  GetCustomerLedger(this.repository);
  Future<List<CustomerLedgerEntry>> call(int customerId) =>
      repository.getCustomerLedger(customerId);
}

class GetCustomersWithOutstanding {
  final CustomerRepository repository;
  GetCustomersWithOutstanding(this.repository);
  Future<List<CustomerEntity>> call() =>
      repository.getCustomersWithOutstanding();
}

class GetCustomersWithAdvance {
  final CustomerRepository repository;
  GetCustomersWithAdvance(this.repository);
  Future<List<CustomerEntity>> call() => repository.getCustomersWithAdvance();
}
