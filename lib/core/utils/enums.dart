/// Enumerations used throughout LedgerFlow
library;

/// Types of ledger transactions
enum TransactionType {
  purchase('Purchase'),
  sale('Sale'),
  supplierPayment('Supplier Payment'),
  customerPayment('Customer Payment'),
  walletAdjustment('Wallet Adjustment'),
  openingBalance('Opening Balance'),
  expense('Expense');

  const TransactionType(this.label);
  final String label;
}

/// Wallet event types for history display
enum WalletEventType {
  credit('Credit'),
  debit('Debit'),
  adjustment('Adjustment');

  const WalletEventType(this.label);
  final String label;
}

/// Status of a supplier/customer account
enum AccountStatus {
  active('Active'),
  inactive('Inactive');

  const AccountStatus(this.label);
  final String label;
}

/// Filter period for reports
enum ReportPeriod {
  today('Today'),
  thisWeek('This Week'),
  thisMonth('This Month'),
  lastMonth('Last Month'),
  thisYear('This Year'),
  custom('Custom Range');

  const ReportPeriod(this.label);
  final String label;
}

/// Report types available
enum ReportType {
  supplierOutstanding('Supplier Outstanding'),
  supplierCredit('Supplier Credit'),
  customerOutstanding('Customer Outstanding'),
  customerAdvance('Customer Advance'),
  walletReport('Wallet Report'),
  purchaseReport('Purchase Report'),
  salesReport('Sales Report'),
  paymentReport('Payment Report'),
  ledgerReport('Ledger Report'),
  monthlyReport('Monthly Report'),
  profitLossStatement('Profit & Loss Statement');

  const ReportType(this.label);
  final String label;
}

/// Export format
enum ExportFormat {
  pdf('PDF'),
  excel('Excel');

  const ExportFormat(this.label);
  final String label;
}

/// Sort order
enum SortOrder {
  ascending('Ascending'),
  descending('Descending');

  const SortOrder(this.label);
  final String label;
}

/// Payment direction relative to outstanding
enum PaymentResult {
  partialPayment, // paid less than outstanding
  exactPayment, // paid exactly outstanding
  overpayment, // paid more than outstanding (creates credit/advance)
}
