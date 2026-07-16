import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_gu.dart';
import 'app_localizations_hi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
      : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('gu'),
    Locale('hi')
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'LedgerFlow'**
  String get appTitle;

  /// No description provided for @dashboard.
  ///
  /// In en, this message translates to:
  /// **'Dashboard'**
  String get dashboard;

  /// No description provided for @ledger.
  ///
  /// In en, this message translates to:
  /// **'Ledger'**
  String get ledger;

  /// No description provided for @expenses.
  ///
  /// In en, this message translates to:
  /// **'Expenses'**
  String get expenses;

  /// No description provided for @wallets.
  ///
  /// In en, this message translates to:
  /// **'Wallets'**
  String get wallets;

  /// No description provided for @suppliers.
  ///
  /// In en, this message translates to:
  /// **'Suppliers'**
  String get suppliers;

  /// No description provided for @customers.
  ///
  /// In en, this message translates to:
  /// **'Customers'**
  String get customers;

  /// No description provided for @reports.
  ///
  /// In en, this message translates to:
  /// **'Reports'**
  String get reports;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @gujarati.
  ///
  /// In en, this message translates to:
  /// **'ગુજરાતી (Gujarati)'**
  String get gujarati;

  /// No description provided for @hindi.
  ///
  /// In en, this message translates to:
  /// **'हिंदी (Hindi)'**
  String get hindi;

  /// No description provided for @add.
  ///
  /// In en, this message translates to:
  /// **'Add'**
  String get add;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @total.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get total;

  /// No description provided for @balance.
  ///
  /// In en, this message translates to:
  /// **'Balance'**
  String get balance;

  /// No description provided for @income.
  ///
  /// In en, this message translates to:
  /// **'Income'**
  String get income;

  /// No description provided for @expense.
  ///
  /// In en, this message translates to:
  /// **'Expense'**
  String get expense;

  /// No description provided for @amount.
  ///
  /// In en, this message translates to:
  /// **'Amount'**
  String get amount;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @categories.
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// No description provided for @noDataFound.
  ///
  /// In en, this message translates to:
  /// **'No data found'**
  String get noDataFound;

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this?'**
  String get confirmDelete;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @noResultsFound.
  ///
  /// In en, this message translates to:
  /// **'No results found'**
  String get noResultsFound;

  /// No description provided for @financialSummary.
  ///
  /// In en, this message translates to:
  /// **'Financial Summary'**
  String get financialSummary;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @last6Months.
  ///
  /// In en, this message translates to:
  /// **'Last 6 Months'**
  String get last6Months;

  /// No description provided for @totalNetBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Net Balance'**
  String get totalNetBalance;

  /// No description provided for @totalPayable.
  ///
  /// In en, this message translates to:
  /// **'Total Payable (Suppliers)'**
  String get totalPayable;

  /// No description provided for @totalReceivable.
  ///
  /// In en, this message translates to:
  /// **'Total Receivable (Customers)'**
  String get totalReceivable;

  /// No description provided for @totalExpenses.
  ///
  /// In en, this message translates to:
  /// **'Total Expenses'**
  String get totalExpenses;

  /// No description provided for @recentTransactions.
  ///
  /// In en, this message translates to:
  /// **'Recent Transactions'**
  String get recentTransactions;

  /// No description provided for @quickActions.
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// No description provided for @noRecentTransactions.
  ///
  /// In en, this message translates to:
  /// **'No recent transactions found'**
  String get noRecentTransactions;

  /// No description provided for @chronologicalLedger.
  ///
  /// In en, this message translates to:
  /// **'Chronological Ledger'**
  String get chronologicalLedger;

  /// No description provided for @transactionLedger.
  ///
  /// In en, this message translates to:
  /// **'Transaction Ledger'**
  String get transactionLedger;

  /// No description provided for @transactionType.
  ///
  /// In en, this message translates to:
  /// **'Transaction Type'**
  String get transactionType;

  /// No description provided for @allTypes.
  ///
  /// In en, this message translates to:
  /// **'All Types'**
  String get allTypes;

  /// No description provided for @sale.
  ///
  /// In en, this message translates to:
  /// **'Sale'**
  String get sale;

  /// No description provided for @purchase.
  ///
  /// In en, this message translates to:
  /// **'Purchase'**
  String get purchase;

  /// No description provided for @supplierPayment.
  ///
  /// In en, this message translates to:
  /// **'Supplier Payment'**
  String get supplierPayment;

  /// No description provided for @customerPayment.
  ///
  /// In en, this message translates to:
  /// **'Customer Payment'**
  String get customerPayment;

  /// No description provided for @walletTransfer.
  ///
  /// In en, this message translates to:
  /// **'Wallet Transfer'**
  String get walletTransfer;

  /// No description provided for @initialBalance.
  ///
  /// In en, this message translates to:
  /// **'Initial Balance'**
  String get initialBalance;

  /// No description provided for @referenceNo.
  ///
  /// In en, this message translates to:
  /// **'Reference No.'**
  String get referenceNo;

  /// No description provided for @fromDate.
  ///
  /// In en, this message translates to:
  /// **'From Date'**
  String get fromDate;

  /// No description provided for @toDate.
  ///
  /// In en, this message translates to:
  /// **'To Date'**
  String get toDate;

  /// No description provided for @filterByDate.
  ///
  /// In en, this message translates to:
  /// **'Filter by Date'**
  String get filterByDate;

  /// No description provided for @filterLedger.
  ///
  /// In en, this message translates to:
  /// **'Filter Ledger'**
  String get filterLedger;

  /// No description provided for @searchHintLedger.
  ///
  /// In en, this message translates to:
  /// **'Search description, ref no...'**
  String get searchHintLedger;

  /// No description provided for @grandTotal.
  ///
  /// In en, this message translates to:
  /// **'Grand Total'**
  String get grandTotal;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @noLedgerEntriesFound.
  ///
  /// In en, this message translates to:
  /// **'No ledger entries found'**
  String get noLedgerEntriesFound;

  /// No description provided for @tryChangingSearchFilters.
  ///
  /// In en, this message translates to:
  /// **'Try changing your search or filters'**
  String get tryChangingSearchFilters;

  /// No description provided for @clearFilters.
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// No description provided for @applyFilters.
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// No description provided for @allWallets.
  ///
  /// In en, this message translates to:
  /// **'All Wallets'**
  String get allWallets;

  /// No description provided for @transactionDetails.
  ///
  /// In en, this message translates to:
  /// **'Transaction Details'**
  String get transactionDetails;

  /// No description provided for @details.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get details;

  /// No description provided for @dateTime.
  ///
  /// In en, this message translates to:
  /// **'Date & Time'**
  String get dateTime;

  /// No description provided for @walletAccount.
  ///
  /// In en, this message translates to:
  /// **'Wallet Account'**
  String get walletAccount;

  /// No description provided for @walletBalanceAfter.
  ///
  /// In en, this message translates to:
  /// **'Wallet Balance After'**
  String get walletBalanceAfter;

  /// No description provided for @active.
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// No description provided for @walletBal.
  ///
  /// In en, this message translates to:
  /// **'Wallet Bal'**
  String get walletBal;

  /// No description provided for @summary.
  ///
  /// In en, this message translates to:
  /// **'Summary'**
  String get summary;

  /// No description provided for @transactions.
  ///
  /// In en, this message translates to:
  /// **'Transactions'**
  String get transactions;

  /// No description provided for @expenseCategories.
  ///
  /// In en, this message translates to:
  /// **'Expense Categories'**
  String get expenseCategories;

  /// No description provided for @addExpense.
  ///
  /// In en, this message translates to:
  /// **'Add Expense'**
  String get addExpense;

  /// No description provided for @newExpense.
  ///
  /// In en, this message translates to:
  /// **'New Expense'**
  String get newExpense;

  /// No description provided for @editExpense.
  ///
  /// In en, this message translates to:
  /// **'Edit Expense'**
  String get editExpense;

  /// No description provided for @deleteExpense.
  ///
  /// In en, this message translates to:
  /// **'Delete Expense'**
  String get deleteExpense;

  /// No description provided for @recordExpense.
  ///
  /// In en, this message translates to:
  /// **'Record Expense'**
  String get recordExpense;

  /// No description provided for @recordExpenseBanner.
  ///
  /// In en, this message translates to:
  /// **'Record a personal or general expense. Toggle wallet to deduct from balance.'**
  String get recordExpenseBanner;

  /// No description provided for @categoryName.
  ///
  /// In en, this message translates to:
  /// **'Category Name'**
  String get categoryName;

  /// No description provided for @icon.
  ///
  /// In en, this message translates to:
  /// **'Icon'**
  String get icon;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @monthlyBudget.
  ///
  /// In en, this message translates to:
  /// **'Monthly Budget'**
  String get monthlyBudget;

  /// No description provided for @totalSpent.
  ///
  /// In en, this message translates to:
  /// **'Total Spent'**
  String get totalSpent;

  /// No description provided for @addCategory.
  ///
  /// In en, this message translates to:
  /// **'Add Category'**
  String get addCategory;

  /// No description provided for @editCategory.
  ///
  /// In en, this message translates to:
  /// **'Edit Category'**
  String get editCategory;

  /// No description provided for @deleteCategory.
  ///
  /// In en, this message translates to:
  /// **'Delete Category'**
  String get deleteCategory;

  /// No description provided for @newCategory.
  ///
  /// In en, this message translates to:
  /// **'New Category'**
  String get newCategory;

  /// No description provided for @manageCategories.
  ///
  /// In en, this message translates to:
  /// **'Manage Categories'**
  String get manageCategories;

  /// No description provided for @description.
  ///
  /// In en, this message translates to:
  /// **'Description'**
  String get description;

  /// No description provided for @descriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Description is required'**
  String get descriptionRequired;

  /// No description provided for @amountRequired.
  ///
  /// In en, this message translates to:
  /// **'Amount is required'**
  String get amountRequired;

  /// No description provided for @deductFromWallet.
  ///
  /// In en, this message translates to:
  /// **'Deduct from Wallet'**
  String get deductFromWallet;

  /// No description provided for @trackExpenseAgainstWallet.
  ///
  /// In en, this message translates to:
  /// **'Track this expense against a wallet balance'**
  String get trackExpenseAgainstWallet;

  /// No description provided for @selectWallet.
  ///
  /// In en, this message translates to:
  /// **'Please select a wallet'**
  String get selectWallet;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Please select a category'**
  String get selectCategory;

  /// No description provided for @noCategoriesFound.
  ///
  /// In en, this message translates to:
  /// **'No categories found'**
  String get noCategoriesFound;

  /// No description provided for @noExpensesYet.
  ///
  /// In en, this message translates to:
  /// **'No Expenses Yet'**
  String get noExpensesYet;

  /// No description provided for @tapToRecordExpense.
  ///
  /// In en, this message translates to:
  /// **'Tap + to record your first expense'**
  String get tapToRecordExpense;

  /// No description provided for @noExpensesThisMonth.
  ///
  /// In en, this message translates to:
  /// **'No expenses this month'**
  String get noExpensesThisMonth;

  /// No description provided for @expenseSummary.
  ///
  /// In en, this message translates to:
  /// **'Expense Summary'**
  String get expenseSummary;

  /// No description provided for @walletAccounts.
  ///
  /// In en, this message translates to:
  /// **'Wallet Accounts'**
  String get walletAccounts;

  /// No description provided for @addWallet.
  ///
  /// In en, this message translates to:
  /// **'Add Wallet'**
  String get addWallet;

  /// No description provided for @editWallet.
  ///
  /// In en, this message translates to:
  /// **'Edit Wallet'**
  String get editWallet;

  /// No description provided for @deleteWallet.
  ///
  /// In en, this message translates to:
  /// **'Delete Wallet'**
  String get deleteWallet;

  /// No description provided for @updateWallet.
  ///
  /// In en, this message translates to:
  /// **'Update Wallet'**
  String get updateWallet;

  /// No description provided for @walletName.
  ///
  /// In en, this message translates to:
  /// **'Wallet Name'**
  String get walletName;

  /// No description provided for @accountType.
  ///
  /// In en, this message translates to:
  /// **'Account Type'**
  String get accountType;

  /// No description provided for @currentBalance.
  ///
  /// In en, this message translates to:
  /// **'Current Balance'**
  String get currentBalance;

  /// No description provided for @transferMoney.
  ///
  /// In en, this message translates to:
  /// **'Transfer Money'**
  String get transferMoney;

  /// No description provided for @fromWallet.
  ///
  /// In en, this message translates to:
  /// **'From Wallet'**
  String get fromWallet;

  /// No description provided for @toWallet.
  ///
  /// In en, this message translates to:
  /// **'To Wallet'**
  String get toWallet;

  /// No description provided for @noWalletAccountsYet.
  ///
  /// In en, this message translates to:
  /// **'No wallet accounts yet'**
  String get noWalletAccountsYet;

  /// No description provided for @addWalletToStart.
  ///
  /// In en, this message translates to:
  /// **'Add a wallet to start tracking balances'**
  String get addWalletToStart;

  /// No description provided for @accountNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Account name is required'**
  String get accountNameRequired;

  /// No description provided for @openingBalanceRequired.
  ///
  /// In en, this message translates to:
  /// **'Opening balance is required'**
  String get openingBalanceRequired;

  /// No description provided for @openingBalanceCannotBeChanged.
  ///
  /// In en, this message translates to:
  /// **'Opening balance cannot be changed after creation'**
  String get openingBalanceCannotBeChanged;

  /// No description provided for @notesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes (Optional)'**
  String get notesOptional;

  /// No description provided for @enableOverdraft.
  ///
  /// In en, this message translates to:
  /// **'Enable Overdraft'**
  String get enableOverdraft;

  /// No description provided for @allowNegativeBalance.
  ///
  /// In en, this message translates to:
  /// **'Allow balance to go below zero'**
  String get allowNegativeBalance;

  /// No description provided for @totalBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Balance'**
  String get totalBalance;

  /// No description provided for @opening.
  ///
  /// In en, this message translates to:
  /// **'Opening'**
  String get opening;

  /// No description provided for @overdraftEnabled.
  ///
  /// In en, this message translates to:
  /// **'Overdraft Enabled'**
  String get overdraftEnabled;

  /// No description provided for @walletHistory.
  ///
  /// In en, this message translates to:
  /// **'Wallet History'**
  String get walletHistory;

  /// No description provided for @overdraft.
  ///
  /// In en, this message translates to:
  /// **'Overdraft'**
  String get overdraft;

  /// No description provided for @enabled.
  ///
  /// In en, this message translates to:
  /// **'Enabled'**
  String get enabled;

  /// No description provided for @disabled.
  ///
  /// In en, this message translates to:
  /// **'Disabled'**
  String get disabled;

  /// No description provided for @bal.
  ///
  /// In en, this message translates to:
  /// **'Bal'**
  String get bal;

  /// No description provided for @supplierDirectory.
  ///
  /// In en, this message translates to:
  /// **'Supplier Directory'**
  String get supplierDirectory;

  /// No description provided for @addSupplier.
  ///
  /// In en, this message translates to:
  /// **'Add Supplier'**
  String get addSupplier;

  /// No description provided for @editSupplier.
  ///
  /// In en, this message translates to:
  /// **'Edit Supplier'**
  String get editSupplier;

  /// No description provided for @updateSupplier.
  ///
  /// In en, this message translates to:
  /// **'Update Supplier'**
  String get updateSupplier;

  /// No description provided for @deleteSupplier.
  ///
  /// In en, this message translates to:
  /// **'Delete Supplier'**
  String get deleteSupplier;

  /// No description provided for @supplierName.
  ///
  /// In en, this message translates to:
  /// **'Supplier Name'**
  String get supplierName;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phone;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get email;

  /// No description provided for @address.
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get address;

  /// No description provided for @gstNo.
  ///
  /// In en, this message translates to:
  /// **'GST No.'**
  String get gstNo;

  /// No description provided for @totalPurchased.
  ///
  /// In en, this message translates to:
  /// **'Total Purchased'**
  String get totalPurchased;

  /// No description provided for @totalPaid.
  ///
  /// In en, this message translates to:
  /// **'Total Paid'**
  String get totalPaid;

  /// No description provided for @recordPurchase.
  ///
  /// In en, this message translates to:
  /// **'Record Purchase'**
  String get recordPurchase;

  /// No description provided for @recordPayment.
  ///
  /// In en, this message translates to:
  /// **'Record Payment'**
  String get recordPayment;

  /// No description provided for @searchSuppliers.
  ///
  /// In en, this message translates to:
  /// **'Search suppliers...'**
  String get searchSuppliers;

  /// No description provided for @outstandingSummary.
  ///
  /// In en, this message translates to:
  /// **'Outstanding Summary'**
  String get outstandingSummary;

  /// No description provided for @creditSummary.
  ///
  /// In en, this message translates to:
  /// **'Credit Summary'**
  String get creditSummary;

  /// No description provided for @newPurchase.
  ///
  /// In en, this message translates to:
  /// **'New Purchase'**
  String get newPurchase;

  /// No description provided for @purchaseInfoBanner.
  ///
  /// In en, this message translates to:
  /// **'Purchasing goods increases Supplier Outstanding. Wallet balance remains unchanged.'**
  String get purchaseInfoBanner;

  /// No description provided for @supplier.
  ///
  /// In en, this message translates to:
  /// **'Supplier'**
  String get supplier;

  /// No description provided for @selectSupplier.
  ///
  /// In en, this message translates to:
  /// **'Please select a supplier'**
  String get selectSupplier;

  /// No description provided for @creditAvailable.
  ///
  /// In en, this message translates to:
  /// **'Credit available'**
  String get creditAvailable;

  /// No description provided for @paymentWalletAccount.
  ///
  /// In en, this message translates to:
  /// **'Payment Wallet Account'**
  String get paymentWalletAccount;

  /// No description provided for @associatedWalletAccount.
  ///
  /// In en, this message translates to:
  /// **'Associated Wallet Account'**
  String get associatedWalletAccount;

  /// No description provided for @purchaseAmount.
  ///
  /// In en, this message translates to:
  /// **'Purchase Amount'**
  String get purchaseAmount;

  /// No description provided for @paidImmediately.
  ///
  /// In en, this message translates to:
  /// **'Paid Immediately'**
  String get paidImmediately;

  /// No description provided for @recordPaymentAndDeductWallet.
  ///
  /// In en, this message translates to:
  /// **'Record payment and deduct balance from wallet'**
  String get recordPaymentAndDeductWallet;

  /// No description provided for @paidAmount.
  ///
  /// In en, this message translates to:
  /// **'Paid Amount'**
  String get paidAmount;

  /// No description provided for @paidAmountRequired.
  ///
  /// In en, this message translates to:
  /// **'Paid amount is required'**
  String get paidAmountRequired;

  /// No description provided for @paidAmountCannotExceed.
  ///
  /// In en, this message translates to:
  /// **'Paid amount cannot exceed purchase amount'**
  String get paidAmountCannotExceed;

  /// No description provided for @supplierPaymentInfoBanner.
  ///
  /// In en, this message translates to:
  /// **'Payment reduces wallet balance. Overpayment creates Supplier Credit.'**
  String get supplierPaymentInfoBanner;

  /// No description provided for @payFromWallet.
  ///
  /// In en, this message translates to:
  /// **'Pay From Wallet'**
  String get payFromWallet;

  /// No description provided for @payAll.
  ///
  /// In en, this message translates to:
  /// **'Pay All'**
  String get payAll;

  /// No description provided for @insufficientWalletBalance.
  ///
  /// In en, this message translates to:
  /// **'Insufficient wallet balance'**
  String get insufficientWalletBalance;

  /// No description provided for @noSuppliersYet.
  ///
  /// In en, this message translates to:
  /// **'No suppliers yet'**
  String get noSuppliersYet;

  /// No description provided for @noOutstandingSuppliers.
  ///
  /// In en, this message translates to:
  /// **'No outstanding suppliers'**
  String get noOutstandingSuppliers;

  /// No description provided for @noCreditBalances.
  ///
  /// In en, this message translates to:
  /// **'No credit balances'**
  String get noCreditBalances;

  /// No description provided for @addPurchase.
  ///
  /// In en, this message translates to:
  /// **'Add Purchase'**
  String get addPurchase;

  /// No description provided for @credit.
  ///
  /// In en, this message translates to:
  /// **'Credit'**
  String get credit;

  /// No description provided for @debit.
  ///
  /// In en, this message translates to:
  /// **'Debit'**
  String get debit;

  /// No description provided for @totalPurchases.
  ///
  /// In en, this message translates to:
  /// **'Total Purchases'**
  String get totalPurchases;

  /// No description provided for @creditBalance.
  ///
  /// In en, this message translates to:
  /// **'Credit Balance'**
  String get creditBalance;

  /// No description provided for @supplierOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Supplier Outstanding'**
  String get supplierOutstanding;

  /// No description provided for @supplierCredit.
  ///
  /// In en, this message translates to:
  /// **'Supplier Credit'**
  String get supplierCredit;

  /// No description provided for @noSupplierCredits.
  ///
  /// In en, this message translates to:
  /// **'No supplier credits'**
  String get noSupplierCredits;

  /// No description provided for @autoAppliesToNextPurchase.
  ///
  /// In en, this message translates to:
  /// **'Auto-applies to next purchase'**
  String get autoAppliesToNextPurchase;

  /// No description provided for @customerDirectory.
  ///
  /// In en, this message translates to:
  /// **'Customer Directory'**
  String get customerDirectory;

  /// No description provided for @addCustomer.
  ///
  /// In en, this message translates to:
  /// **'Add Customer'**
  String get addCustomer;

  /// No description provided for @editCustomer.
  ///
  /// In en, this message translates to:
  /// **'Edit Customer'**
  String get editCustomer;

  /// No description provided for @updateCustomer.
  ///
  /// In en, this message translates to:
  /// **'Update Customer'**
  String get updateCustomer;

  /// No description provided for @deleteCustomer.
  ///
  /// In en, this message translates to:
  /// **'Delete Customer'**
  String get deleteCustomer;

  /// No description provided for @customerName.
  ///
  /// In en, this message translates to:
  /// **'Customer Name'**
  String get customerName;

  /// No description provided for @totalSales.
  ///
  /// In en, this message translates to:
  /// **'Total Sales'**
  String get totalSales;

  /// No description provided for @totalReceived.
  ///
  /// In en, this message translates to:
  /// **'Total Received'**
  String get totalReceived;

  /// No description provided for @recordSale.
  ///
  /// In en, this message translates to:
  /// **'Record Credit Sale'**
  String get recordSale;

  /// No description provided for @searchCustomers.
  ///
  /// In en, this message translates to:
  /// **'Search customers...'**
  String get searchCustomers;

  /// No description provided for @newSale.
  ///
  /// In en, this message translates to:
  /// **'New Sale'**
  String get newSale;

  /// No description provided for @saleInfoBanner.
  ///
  /// In en, this message translates to:
  /// **'Sales increase Customer Outstanding. Customer Advance is auto-applied.'**
  String get saleInfoBanner;

  /// No description provided for @customer.
  ///
  /// In en, this message translates to:
  /// **'Customer'**
  String get customer;

  /// No description provided for @selectCustomer.
  ///
  /// In en, this message translates to:
  /// **'Please select a customer'**
  String get selectCustomer;

  /// No description provided for @advanceAvailable.
  ///
  /// In en, this message translates to:
  /// **'Advance available'**
  String get advanceAvailable;

  /// No description provided for @saleAmount.
  ///
  /// In en, this message translates to:
  /// **'Sale Amount'**
  String get saleAmount;

  /// No description provided for @receivedPaymentImmediately.
  ///
  /// In en, this message translates to:
  /// **'Received Payment Immediately'**
  String get receivedPaymentImmediately;

  /// No description provided for @recordPaymentAndDepositWallet.
  ///
  /// In en, this message translates to:
  /// **'Record payment and deposit balance to wallet'**
  String get recordPaymentAndDepositWallet;

  /// No description provided for @paidAmountCannotExceedSale.
  ///
  /// In en, this message translates to:
  /// **'Paid amount cannot exceed sale amount'**
  String get paidAmountCannotExceedSale;

  /// No description provided for @recordSaleAction.
  ///
  /// In en, this message translates to:
  /// **'Record Sale'**
  String get recordSaleAction;

  /// No description provided for @customerPaymentInfoBanner.
  ///
  /// In en, this message translates to:
  /// **'Payment increases wallet balance. Overpayment creates Customer Advance.'**
  String get customerPaymentInfoBanner;

  /// No description provided for @receiveInWallet.
  ///
  /// In en, this message translates to:
  /// **'Receive In Wallet'**
  String get receiveInWallet;

  /// No description provided for @paymentAmount.
  ///
  /// In en, this message translates to:
  /// **'Payment Amount'**
  String get paymentAmount;

  /// No description provided for @fullAmount.
  ///
  /// In en, this message translates to:
  /// **'Full Amount'**
  String get fullAmount;

  /// No description provided for @recordPaymentAction.
  ///
  /// In en, this message translates to:
  /// **'Record Payment'**
  String get recordPaymentAction;

  /// No description provided for @outstanding.
  ///
  /// In en, this message translates to:
  /// **'Outstanding'**
  String get outstanding;

  /// No description provided for @advanceSummary.
  ///
  /// In en, this message translates to:
  /// **'Advance Summary'**
  String get advanceSummary;

  /// No description provided for @noCustomersYet.
  ///
  /// In en, this message translates to:
  /// **'No customers yet'**
  String get noCustomersYet;

  /// No description provided for @owes.
  ///
  /// In en, this message translates to:
  /// **'Owes'**
  String get owes;

  /// No description provided for @adv.
  ///
  /// In en, this message translates to:
  /// **'Adv'**
  String get adv;

  /// No description provided for @settled.
  ///
  /// In en, this message translates to:
  /// **'Settled'**
  String get settled;

  /// No description provided for @addSale.
  ///
  /// In en, this message translates to:
  /// **'Add Sale'**
  String get addSale;

  /// No description provided for @addPayment.
  ///
  /// In en, this message translates to:
  /// **'Add Payment'**
  String get addPayment;

  /// No description provided for @contactInfo.
  ///
  /// In en, this message translates to:
  /// **'Contact Info'**
  String get contactInfo;

  /// No description provided for @noContactInfo.
  ///
  /// In en, this message translates to:
  /// **'No contact info'**
  String get noContactInfo;

  /// No description provided for @noTransactionsYet.
  ///
  /// In en, this message translates to:
  /// **'No transactions yet'**
  String get noTransactionsYet;

  /// No description provided for @noOutstandingCustomers.
  ///
  /// In en, this message translates to:
  /// **'No outstanding customers'**
  String get noOutstandingCustomers;

  /// No description provided for @noAdvanceBalances.
  ///
  /// In en, this message translates to:
  /// **'No advance balances'**
  String get noAdvanceBalances;

  /// No description provided for @autoAppliesToNextSale.
  ///
  /// In en, this message translates to:
  /// **'Auto-applies to next sale'**
  String get autoAppliesToNextSale;

  /// No description provided for @totalOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Total Outstanding'**
  String get totalOutstanding;

  /// No description provided for @totalAdvanceBalance.
  ///
  /// In en, this message translates to:
  /// **'Total Advance Balance'**
  String get totalAdvanceBalance;

  /// No description provided for @customerOutstanding.
  ///
  /// In en, this message translates to:
  /// **'Customer Outstanding'**
  String get customerOutstanding;

  /// No description provided for @customerAdvance.
  ///
  /// In en, this message translates to:
  /// **'Customer Advance'**
  String get customerAdvance;

  /// No description provided for @totalPayments.
  ///
  /// In en, this message translates to:
  /// **'Total Payments'**
  String get totalPayments;

  /// No description provided for @advanceBalance.
  ///
  /// In en, this message translates to:
  /// **'Advance Balance'**
  String get advanceBalance;

  /// No description provided for @noLedgerEntries.
  ///
  /// In en, this message translates to:
  /// **'No ledger entries'**
  String get noLedgerEntries;

  /// No description provided for @financialReports.
  ///
  /// In en, this message translates to:
  /// **'Financial Reports'**
  String get financialReports;

  /// No description provided for @exportReports.
  ///
  /// In en, this message translates to:
  /// **'Export Reports'**
  String get exportReports;

  /// No description provided for @exportPdf.
  ///
  /// In en, this message translates to:
  /// **'Export PDF'**
  String get exportPdf;

  /// No description provided for @exportExcel.
  ///
  /// In en, this message translates to:
  /// **'Export Excel'**
  String get exportExcel;

  /// No description provided for @generateReport.
  ///
  /// In en, this message translates to:
  /// **'Generate Report'**
  String get generateReport;

  /// No description provided for @dateRange.
  ///
  /// In en, this message translates to:
  /// **'Date Range'**
  String get dateRange;

  /// No description provided for @generatingReportWait.
  ///
  /// In en, this message translates to:
  /// **'Generating report, please wait...'**
  String get generatingReportWait;

  /// No description provided for @businessAnalyticsHeader.
  ///
  /// In en, this message translates to:
  /// **'Business Analytics & Reports'**
  String get businessAnalyticsHeader;

  /// No description provided for @businessAnalyticsDesc.
  ///
  /// In en, this message translates to:
  /// **'Select the target report and format below. You can save locally or share directly.'**
  String get businessAnalyticsDesc;

  /// No description provided for @selectReportType.
  ///
  /// In en, this message translates to:
  /// **'Select Report Type'**
  String get selectReportType;

  /// No description provided for @selectFormat.
  ///
  /// In en, this message translates to:
  /// **'Select Format'**
  String get selectFormat;

  /// No description provided for @pdfDocument.
  ///
  /// In en, this message translates to:
  /// **'PDF Document'**
  String get pdfDocument;

  /// No description provided for @excelSheet.
  ///
  /// In en, this message translates to:
  /// **'Excel Sheet'**
  String get excelSheet;

  /// No description provided for @dateRangeOptional.
  ///
  /// In en, this message translates to:
  /// **'Date Range (Optional)'**
  String get dateRangeOptional;

  /// No description provided for @resetDates.
  ///
  /// In en, this message translates to:
  /// **'Reset Dates'**
  String get resetDates;

  /// No description provided for @saveToLocalStorage.
  ///
  /// In en, this message translates to:
  /// **'Save to Local Storage'**
  String get saveToLocalStorage;

  /// No description provided for @shareSendReport.
  ///
  /// In en, this message translates to:
  /// **'Share / Send Report'**
  String get shareSendReport;

  /// No description provided for @generalLedgerReport.
  ///
  /// In en, this message translates to:
  /// **'General Ledger Report'**
  String get generalLedgerReport;

  /// No description provided for @purchaseReport.
  ///
  /// In en, this message translates to:
  /// **'Purchase Report'**
  String get purchaseReport;

  /// No description provided for @salesReport.
  ///
  /// In en, this message translates to:
  /// **'Sales Report'**
  String get salesReport;

  /// No description provided for @paymentsReport.
  ///
  /// In en, this message translates to:
  /// **'Payments Report'**
  String get paymentsReport;

  /// No description provided for @monthlySummaryReport.
  ///
  /// In en, this message translates to:
  /// **'Monthly Summary Report'**
  String get monthlySummaryReport;

  /// No description provided for @last30Days.
  ///
  /// In en, this message translates to:
  /// **'Last 30 Days'**
  String get last30Days;

  /// No description provided for @reportSavedTo.
  ///
  /// In en, this message translates to:
  /// **'Report saved to'**
  String get reportSavedTo;

  /// No description provided for @exportFailed.
  ///
  /// In en, this message translates to:
  /// **'Export failed'**
  String get exportFailed;

  /// No description provided for @exported.
  ///
  /// In en, this message translates to:
  /// **'Exported'**
  String get exported;

  /// No description provided for @operatingIncome.
  ///
  /// In en, this message translates to:
  /// **'Operating Income'**
  String get operatingIncome;

  /// No description provided for @costOfSales.
  ///
  /// In en, this message translates to:
  /// **'Cost of Sales'**
  String get costOfSales;

  /// No description provided for @netProfit.
  ///
  /// In en, this message translates to:
  /// **'Net Profit'**
  String get netProfit;

  /// No description provided for @netLoss.
  ///
  /// In en, this message translates to:
  /// **'Net Loss'**
  String get netLoss;

  /// No description provided for @fieldRequired.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// No description provided for @nameRequired.
  ///
  /// In en, this message translates to:
  /// **'Name is required'**
  String get nameRequired;

  /// No description provided for @invalidAmount.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid amount'**
  String get invalidAmount;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @profitLossStatement.
  ///
  /// In en, this message translates to:
  /// **'Profit & Loss Statement'**
  String get profitLossStatement;

  /// No description provided for @notFound.
  ///
  /// In en, this message translates to:
  /// **'Not found'**
  String get notFound;

  /// No description provided for @recordedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Recorded successfully'**
  String get recordedSuccessfully;

  /// No description provided for @addedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Added successfully'**
  String get addedSuccessfully;

  /// No description provided for @updatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully'**
  String get updatedSuccessfully;

  /// No description provided for @deleted.
  ///
  /// In en, this message translates to:
  /// **'Deleted'**
  String get deleted;

  /// No description provided for @expenseRecordedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Expense recorded successfully'**
  String get expenseRecordedSuccessfully;

  /// No description provided for @expenseDeleted.
  ///
  /// In en, this message translates to:
  /// **'Expense deleted'**
  String get expenseDeleted;

  /// No description provided for @categoryAdded.
  ///
  /// In en, this message translates to:
  /// **'Category added'**
  String get categoryAdded;

  /// No description provided for @categoryUpdated.
  ///
  /// In en, this message translates to:
  /// **'Category updated'**
  String get categoryUpdated;

  /// No description provided for @categoryDeleted.
  ///
  /// In en, this message translates to:
  /// **'Category deleted'**
  String get categoryDeleted;

  /// No description provided for @supplierAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Supplier added successfully'**
  String get supplierAddedSuccessfully;

  /// No description provided for @supplierUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Supplier updated successfully'**
  String get supplierUpdatedSuccessfully;

  /// No description provided for @supplierDeleted.
  ///
  /// In en, this message translates to:
  /// **'Supplier deleted'**
  String get supplierDeleted;

  /// No description provided for @purchaseRecordedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Purchase recorded successfully'**
  String get purchaseRecordedSuccessfully;

  /// No description provided for @paymentRecordedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Payment recorded successfully'**
  String get paymentRecordedSuccessfully;

  /// No description provided for @supplierNotFound.
  ///
  /// In en, this message translates to:
  /// **'Supplier not found'**
  String get supplierNotFound;

  /// No description provided for @walletAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Wallet account added successfully'**
  String get walletAddedSuccessfully;

  /// No description provided for @walletUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Wallet account updated successfully'**
  String get walletUpdatedSuccessfully;

  /// No description provided for @walletDeleted.
  ///
  /// In en, this message translates to:
  /// **'Wallet account deleted'**
  String get walletDeleted;

  /// No description provided for @walletNotFound.
  ///
  /// In en, this message translates to:
  /// **'Wallet not found'**
  String get walletNotFound;

  /// No description provided for @customerAddedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Customer added successfully'**
  String get customerAddedSuccessfully;

  /// No description provided for @customerUpdatedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Customer updated successfully'**
  String get customerUpdatedSuccessfully;

  /// No description provided for @customerDeleted.
  ///
  /// In en, this message translates to:
  /// **'Customer deleted'**
  String get customerDeleted;

  /// No description provided for @saleRecordedSuccessfully.
  ///
  /// In en, this message translates to:
  /// **'Sale recorded successfully'**
  String get saleRecordedSuccessfully;

  /// No description provided for @customerNotFound.
  ///
  /// In en, this message translates to:
  /// **'Customer not found'**
  String get customerNotFound;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'gu', 'hi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'gu':
      return AppLocalizationsGu();
    case 'hi':
      return AppLocalizationsHi();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
