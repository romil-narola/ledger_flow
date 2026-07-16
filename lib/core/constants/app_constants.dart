/// Application-wide constants for LedgerFlow
class AppConstants {
  AppConstants._();

  // App Info
  static const String appName = 'LedgerFlow';
  static const String appVersion = '1.0.0';

  // Currency
  static const String currencySymbol = '₹';
  static const String currencyCode = 'INR';

  // Date Formats
  static const String displayDateFormat = 'dd/MM/yyyy';
  static const String displayDateTimeFormat = 'dd/MM/yyyy HH:mm';
  static const String dbDateFormat = 'yyyy-MM-dd';

  // Pagination
  static const int defaultPageSize = 25;

  // Transaction Reference Prefix
  static const String purchasePrefix = 'PUR';
  static const String salePrefix = 'SAL';
  static const String supplierPaymentPrefix = 'SPY';
  static const String customerPaymentPrefix = 'CPY';
  static const String walletAdjustmentPrefix = 'WAD';
  static const String expensePrefix = 'EXP';

  // Validation
  static const double minTransactionAmount = 0.01;
  static const int maxNotesLength = 500;
  static const int maxNameLength = 100;

  // Database
  static const String dbName = 'ledger_flow.db';
  static const int dbVersion = 1;

  // Animation Duration
  static const Duration shortAnimation = Duration(milliseconds: 200);
  static const Duration mediumAnimation = Duration(milliseconds: 400);
  static const Duration longAnimation = Duration(milliseconds: 600);
}
