import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ledger_flow/core/database/daos/expense_dao.dart';
import '../database/app_database.dart';
import '../database/daos/wallet_dao.dart';
import '../database/daos/supplier_dao.dart';
import '../database/daos/customer_dao.dart';
import '../database/daos/purchase_dao.dart';
import '../database/daos/sales_dao.dart';
import '../database/daos/ledger_dao.dart';
import '../database/daos/business_dao.dart';

// Services
import '../../features/business/data/services/current_business_service.dart';

// Repositories
import '../../features/business/data/repositories/business_repository_impl.dart';
import '../../features/business/domain/repositories/business_repository.dart';
import '../../features/wallet/data/repositories/wallet_repository_impl.dart';
import '../../features/wallet/domain/repositories/wallet_repository.dart';
import '../../features/supplier/data/repositories/supplier_repository_impl.dart';
import '../../features/supplier/domain/repositories/supplier_repository.dart';
import '../../features/customer/data/repositories/customer_repository_impl.dart';
import '../../features/customer/domain/repositories/customer_repository.dart';
import '../../features/ledger/data/repositories/ledger_repository_impl.dart';
import '../../features/ledger/domain/repositories/ledger_repository.dart';
import '../../features/expenses/data/repositories/expense_repository_impl.dart';
import '../../features/expenses/domain/repositories/expense_repository.dart';

// Use Cases - Wallet
import '../../features/wallet/domain/usecases/wallet_usecases.dart';
// Use Cases - Supplier
import '../../features/supplier/domain/usecases/supplier_usecases.dart';
// Use Cases - Customer
import '../../features/customer/domain/usecases/customer_usecases.dart';
// Use Cases - Expenses
import '../../features/expenses/domain/usecases/expense_usecases.dart';

// BLoCs
import '../../features/business/presentation/bloc/business_cubit.dart';
import '../../features/wallet/presentation/bloc/wallet_bloc.dart';
import '../../features/supplier/presentation/bloc/supplier_bloc.dart';
import '../../features/customer/presentation/bloc/customer_bloc.dart';
import '../../features/ledger/presentation/bloc/ledger_bloc.dart';
import '../../features/dashboard/presentation/bloc/dashboard_bloc.dart';
import '../../features/expenses/presentation/bloc/expense_bloc.dart';

final sl = GetIt.instance;

Future<void> initDependencies() async {
  // ─── External Services ───────────────────────────────────────────
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerSingleton<SharedPreferences>(sharedPreferences);

  // ─── Database ────────────────────────────────────────────────────
  final db = AppDatabase();
  sl.registerSingleton<AppDatabase>(db);

  // ─── Services ────────────────────────────────────────────────────
  sl.registerSingleton<CurrentBusinessService>(
    CurrentBusinessService(sl<SharedPreferences>()),
  );

  // ─── DAOs ────────────────────────────────────────────────────────
  sl.registerSingleton<BusinessDao>(db.businessDao);
  sl.registerSingleton<WalletDao>(
      db.walletDao..businessService = sl<CurrentBusinessService>());
  sl.registerSingleton<SupplierDao>(
      db.supplierDao..businessService = sl<CurrentBusinessService>());
  sl.registerSingleton<CustomerDao>(
      db.customerDao..businessService = sl<CurrentBusinessService>());
  sl.registerSingleton<PurchaseDao>(
      db.purchaseDao..businessService = sl<CurrentBusinessService>());
  sl.registerSingleton<SalesDao>(
      db.salesDao..businessService = sl<CurrentBusinessService>());
  sl.registerSingleton<LedgerDao>(
      db.ledgerDao..businessService = sl<CurrentBusinessService>());
  sl.registerSingleton<ExpenseDao>(
      db.expenseDao..businessService = sl<CurrentBusinessService>());

  // ─── Repositories ────────────────────────────────────────────────
  sl.registerSingleton<BusinessRepository>(
    BusinessRepositoryImpl(sl<BusinessDao>()),
  );

  sl.registerSingleton<WalletRepository>(
    WalletRepositoryImpl(sl<WalletDao>()),
  );

  sl.registerSingleton<SupplierRepository>(
    SupplierRepositoryImpl(
      supplierDao: sl<SupplierDao>(),
      walletDao: sl<WalletDao>(),
      ledgerDao: sl<LedgerDao>(),
      db: sl<AppDatabase>(),
    ),
  );

  sl.registerSingleton<CustomerRepository>(
    CustomerRepositoryImpl(
      customerDao: sl<CustomerDao>(),
      walletDao: sl<WalletDao>(),
      ledgerDao: sl<LedgerDao>(),
      db: sl<AppDatabase>(),
    ),
  );

  sl.registerSingleton<LedgerRepository>(
    LedgerRepositoryImpl(
      ledgerDao: sl<LedgerDao>(),
      walletDao: sl<WalletDao>(),
      supplierDao: sl<SupplierDao>(),
      customerDao: sl<CustomerDao>(),
    ),
  );

  sl.registerSingleton<ExpenseRepository>(
    ExpenseRepositoryImpl(
      expenseDao: sl<ExpenseDao>(),
      walletDao: sl<WalletDao>(),
      ledgerDao: sl<LedgerDao>(),
      db: sl<AppDatabase>(),
    ),
  );

  // ─── Wallet Use Cases ────────────────────────────────────────────
  sl.registerFactory(() => GetWallets(sl<WalletRepository>()));
  sl.registerFactory(() => WatchWallets(sl<WalletRepository>()));
  sl.registerFactory(() => GetWalletById(sl<WalletRepository>()));
  sl.registerFactory(() => GetTotalBalance(sl<WalletRepository>()));
  sl.registerFactory(() => AddWallet(sl<WalletRepository>()));
  sl.registerFactory(() => UpdateWallet(sl<WalletRepository>()));
  sl.registerFactory(() => DeleteWallet(sl<WalletRepository>()));
  sl.registerFactory(() => GetWalletHistory(sl<WalletRepository>()));

  // ─── Supplier Use Cases ──────────────────────────────────────────
  sl.registerFactory(() => GetSuppliers(sl<SupplierRepository>()));
  sl.registerFactory(() => WatchSuppliers(sl<SupplierRepository>()));
  sl.registerFactory(() => GetSupplierById(sl<SupplierRepository>()));
  sl.registerFactory(() => AddSupplier(sl<SupplierRepository>()));
  sl.registerFactory(() => UpdateSupplier(sl<SupplierRepository>()));
  sl.registerFactory(() => DeleteSupplier(sl<SupplierRepository>()));
  sl.registerFactory(() => AddPurchase(sl<SupplierRepository>()));
  sl.registerFactory(() => GetPurchasesBySupplier(sl<SupplierRepository>()));
  sl.registerFactory(() => GetAllPurchases(sl<SupplierRepository>()));
  sl.registerFactory(() => GetMonthlyPurchases(sl<SupplierRepository>()));
  sl.registerFactory(() => AddSupplierPayment(sl<SupplierRepository>()));
  sl.registerFactory(() => GetPaymentsBySupplier(sl<SupplierRepository>()));
  sl.registerFactory(() => GetSupplierLedger(sl<SupplierRepository>()));
  sl.registerFactory(
      () => GetSuppliersWithOutstanding(sl<SupplierRepository>()));
  sl.registerFactory(() => GetSuppliersWithCredit(sl<SupplierRepository>()));

  // ─── Customer Use Cases ──────────────────────────────────────────
  sl.registerFactory(() => GetCustomers(sl<CustomerRepository>()));
  sl.registerFactory(() => WatchCustomers(sl<CustomerRepository>()));
  sl.registerFactory(() => GetCustomerById(sl<CustomerRepository>()));
  sl.registerFactory(() => AddCustomer(sl<CustomerRepository>()));
  sl.registerFactory(() => UpdateCustomer(sl<CustomerRepository>()));
  sl.registerFactory(() => DeleteCustomer(sl<CustomerRepository>()));
  sl.registerFactory(() => AddSale(sl<CustomerRepository>()));
  sl.registerFactory(() => GetSalesByCustomer(sl<CustomerRepository>()));
  sl.registerFactory(() => GetAllSales(sl<CustomerRepository>()));
  sl.registerFactory(() => GetMonthlySales(sl<CustomerRepository>()));
  sl.registerFactory(() => AddCustomerPayment(sl<CustomerRepository>()));
  sl.registerFactory(() => GetPaymentsByCustomer(sl<CustomerRepository>()));
  sl.registerFactory(() => GetCustomerLedger(sl<CustomerRepository>()));
  sl.registerFactory(
      () => GetCustomersWithOutstanding(sl<CustomerRepository>()));
  sl.registerFactory(() => GetCustomersWithAdvance(sl<CustomerRepository>()));

  // ─── BLoCs ───────────────────────────────────────────────────────
  sl.registerFactory(() => WalletBloc(
        getWallets: sl(),
        watchWallets: sl(),
        getWalletById: sl(),
        addWallet: sl(),
        updateWallet: sl(),
        deleteWallet: sl(),
        getWalletHistory: sl(),
        getTotalBalance: sl(),
      ));

  sl.registerFactory(() => SupplierBloc(
        getSuppliers: sl(),
        watchSuppliers: sl(),
        getSupplierById: sl(),
        addSupplier: sl(),
        updateSupplier: sl(),
        deleteSupplier: sl(),
        addPurchase: sl(),
        addPayment: sl(),
        getPurchasesBySupplier: sl(),
        getPaymentsBySupplier: sl(),
        getSupplierLedger: sl(),
        getAllPurchases: sl(),
        getSuppliersWithOutstanding: sl(),
        getSuppliersWithCredit: sl(),
      ));

  sl.registerFactory(() => CustomerBloc(
        getCustomers: sl(),
        watchCustomers: sl(),
        getCustomerById: sl(),
        addCustomer: sl(),
        updateCustomer: sl(),
        deleteCustomer: sl(),
        addSale: sl(),
        addPayment: sl(),
        getSalesByCustomer: sl(),
        getPaymentsByCustomer: sl(),
        getCustomerLedger: sl(),
        getAllSales: sl(),
        getCustomersWithOutstanding: sl(),
        getCustomersWithAdvance: sl(),
      ));

  sl.registerFactory(() => LedgerBloc(sl<LedgerRepository>()));

  sl.registerFactory(() => DashboardBloc(
        walletRepository: sl(),
        supplierRepository: sl(),
        customerRepository: sl(),
        ledgerRepository: sl(),
      ));

  // ─── Expense Use Cases ───────────────────────────────────────
  sl.registerFactory(() => GetCategories(sl<ExpenseRepository>()));
  sl.registerFactory(() => AddCategory(sl<ExpenseRepository>()));
  sl.registerFactory(() => UpdateCategory(sl<ExpenseRepository>()));
  sl.registerFactory(() => DeleteCategory(sl<ExpenseRepository>()));
  sl.registerFactory(() => GetAllExpenses(sl<ExpenseRepository>()));
  sl.registerFactory(() => AddExpense(sl<ExpenseRepository>()));
  sl.registerFactory(() => DeleteExpense(sl<ExpenseRepository>()));
  sl.registerFactory(() => GetMonthlyExpenseTotal(sl<ExpenseRepository>()));
  sl.registerFactory(() => GetExpenseCategoryTotals(sl<ExpenseRepository>()));

  // ─── Expense BLoC ─────────────────────────────────────────
  sl.registerFactory(() => ExpenseBloc(
        getCategories: sl(),
        addCategory: sl(),
        updateCategory: sl(),
        deleteCategory: sl(),
        getAllExpenses: sl(),
        addExpense: sl(),
        deleteExpense: sl(),
        getCategoryTotals: sl(),
      ));

  // ─── Business BLoC ─────────────────────────────────────────
  sl.registerFactory(() => BusinessCubit(
        repository: sl(),
        currentBusinessService: sl(),
      ));
}
