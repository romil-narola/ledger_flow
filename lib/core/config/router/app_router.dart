import 'package:go_router/go_router.dart';
import '../../../features/dashboard/presentation/screens/dashboard_screen.dart';
import '../../../features/wallet/presentation/screens/wallet_list_screen.dart';
import '../../../features/wallet/presentation/screens/wallet_form_screen.dart';
import '../../../features/wallet/presentation/screens/wallet_history_screen.dart';
import '../../../features/supplier/presentation/screens/supplier_list_screen.dart';
import '../../../features/supplier/presentation/screens/supplier_form_screen.dart';
import '../../../features/supplier/presentation/screens/purchase_form_screen.dart';
import '../../../features/supplier/presentation/screens/supplier_payment_form_screen.dart';
import '../../../features/supplier/presentation/screens/supplier_ledger_screen.dart';
import '../../../features/supplier/presentation/screens/outstanding_summary_screen.dart';
import '../../../features/customer/presentation/screens/customer_list_screen.dart';
import '../../../features/customer/presentation/screens/customer_form_screen.dart';
import '../../../features/customer/presentation/screens/sale_form_screen.dart';
import '../../../features/customer/presentation/screens/customer_payment_form_screen.dart';
import '../../../features/customer/presentation/screens/customer_ledger_screen.dart';
import '../../../features/ledger/presentation/screens/ledger_screen.dart';
import '../../../features/ledger/presentation/screens/ledger_entry_detail_screen.dart';
import '../../../features/reports/presentation/screens/reports_screen.dart';
import '../../../features/expenses/presentation/screens/expense_list_screen.dart';
import '../../../features/expenses/presentation/screens/expense_form_screen.dart';
import '../../../features/expenses/presentation/screens/expense_summary_screen.dart';
import '../../../features/expenses/presentation/screens/expense_category_screen.dart';
import '../../../features/business/presentation/screens/business_list_screen.dart';
import '../../../features/business/presentation/screens/business_form_screen.dart';
import '../../presentation/main_shell.dart';
import '../../database/app_database.dart';

/// Application routing configuration using GoRouter with shell route for navigation
final GoRouter appRouter = GoRouter(
  initialLocation: '/dashboard',
  routes: [
    ShellRoute(
      builder: (context, state, child) => MainShell(child: child),
      routes: [
        GoRoute(
          path: '/dashboard',
          name: 'dashboard',
          builder: (context, state) => const DashboardScreen(),
        ),
        // ─── Business Routes ───────────────────────────────────────
        GoRoute(
          path: '/businesses',
          name: 'businesses',
          builder: (context, state) => const BusinessListScreen(),
          routes: [
            GoRoute(
              path: 'new',
              name: 'business-add',
              builder: (context, state) => const BusinessFormScreen(),
            ),
            GoRoute(
              path: 'edit',
              name: 'business-edit',
              builder: (context, state) {
                final business = state.extra as Business;
                return BusinessFormScreen(business: business);
              },
            ),
          ],
        ),
        // ─── Wallet Routes ─────────────────────────────────────────
        GoRoute(
          path: '/wallets',
          name: 'wallets',
          builder: (context, state) => const WalletListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              name: 'wallet-add',
              builder: (context, state) => const WalletFormScreen(),
            ),
            GoRoute(
              path: ':id/edit',
              name: 'wallet-edit',
              builder: (context, state) {
                final id = int.parse(state.pathParameters['id']!);
                return WalletFormScreen(walletId: id);
              },
            ),
            GoRoute(
              path: ':id/history',
              name: 'wallet-history',
              builder: (context, state) {
                final id = int.parse(state.pathParameters['id']!);
                return WalletHistoryScreen(walletId: id);
              },
            ),
          ],
        ),
        // ─── Supplier Routes ────────────────────────────────────────
        GoRoute(
          path: '/suppliers',
          name: 'suppliers',
          builder: (context, state) => const SupplierListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              name: 'supplier-add',
              builder: (context, state) => const SupplierFormScreen(),
            ),
            GoRoute(
              path: ':id/edit',
              name: 'supplier-edit',
              builder: (context, state) {
                final id = int.parse(state.pathParameters['id']!);
                return SupplierFormScreen(supplierId: id);
              },
            ),
            GoRoute(
              path: 'purchase',
              name: 'purchase-add',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return PurchaseFormScreen(
                    preselectedSupplierId: extra?['supplierId']);
              },
            ),
            GoRoute(
              path: 'payment',
              name: 'supplier-payment-add',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return SupplierPaymentFormScreen(
                    preselectedSupplierId: extra?['supplierId']);
              },
            ),
            GoRoute(
              path: ':id/ledger',
              name: 'supplier-ledger',
              builder: (context, state) {
                final id = int.parse(state.pathParameters['id']!);
                return SupplierLedgerScreen(supplierId: id);
              },
            ),
            GoRoute(
              path: 'outstanding',
              name: 'supplier-outstanding',
              builder: (context, state) => const OutstandingSummaryScreen(),
            ),
            GoRoute(
              path: 'credit',
              name: 'supplier-credit',
              builder: (context, state) => const CreditSummaryScreen(),
            ),
          ],
        ),
        // ─── Customer Routes ────────────────────────────────────────
        GoRoute(
          path: '/customers',
          name: 'customers',
          builder: (context, state) => const CustomerListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              name: 'customer-add',
              builder: (context, state) => const CustomerFormScreen(),
            ),
            GoRoute(
              path: ':id/edit',
              name: 'customer-edit',
              builder: (context, state) {
                final id = int.parse(state.pathParameters['id']!);
                return CustomerFormScreen(customerId: id);
              },
            ),
            GoRoute(
              path: 'sale',
              name: 'sale-add',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return SaleFormScreen(
                    preselectedCustomerId: extra?['customerId']);
              },
            ),
            GoRoute(
              path: 'payment',
              name: 'customer-payment-add',
              builder: (context, state) {
                final extra = state.extra as Map<String, dynamic>?;
                return CustomerPaymentFormScreen(
                    preselectedCustomerId: extra?['customerId']);
              },
            ),
            GoRoute(
              path: ':id/ledger',
              name: 'customer-ledger',
              builder: (context, state) {
                final id = int.parse(state.pathParameters['id']!);
                return CustomerLedgerScreen(customerId: id);
              },
            ),
            GoRoute(
              path: 'outstanding',
              name: 'customer-outstanding',
              builder: (context, state) => const CustomerOutstandingScreen(),
            ),
            GoRoute(
              path: 'advance',
              name: 'customer-advance',
              builder: (context, state) => const CustomerAdvanceScreen(),
            ),
          ],
        ),
        // ─── Ledger Routes ──────────────────────────────────────────
        GoRoute(
          path: '/ledger',
          name: 'ledger',
          builder: (context, state) => const LedgerScreen(),
          routes: [
            GoRoute(
              path: ':id',
              name: 'ledger-entry',
              builder: (context, state) {
                final id = int.parse(state.pathParameters['id']!);
                return LedgerEntryDetailScreen(entryId: id);
              },
            ),
          ],
        ),
        // ─── Reports Routes ─────────────────────────────────────────
        GoRoute(
          path: '/reports',
          name: 'reports',
          builder: (context, state) => const ReportsScreen(),
        ),
        // ─── Expenses Routes ────────────────────────────────────────
        GoRoute(
          path: '/expenses',
          name: 'expenses',
          builder: (context, state) => const ExpenseListScreen(),
          routes: [
            GoRoute(
              path: 'add',
              name: 'expense-add',
              builder: (context, state) => const ExpenseFormScreen(),
            ),
            GoRoute(
              path: 'summary',
              name: 'expense-summary',
              builder: (context, state) => const ExpenseSummaryScreen(),
            ),
            GoRoute(
              path: 'categories',
              name: 'expense-categories',
              builder: (context, state) => const ExpenseCategoryScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
