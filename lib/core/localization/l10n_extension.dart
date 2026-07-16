import 'package:flutter/material.dart';
import '../utils/enums.dart';
import '../../l10n/app_localizations.dart';

extension LocalizationExtension on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension TransactionTypeLocalization on TransactionType {
  String getLocalizedLabel(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case TransactionType.purchase:
        return l10n.purchase;
      case TransactionType.sale:
        return l10n.sale;
      case TransactionType.supplierPayment:
        return l10n.supplierPayment;
      case TransactionType.customerPayment:
        return l10n.customerPayment;
      case TransactionType.walletAdjustment:
        return l10n.walletTransfer;
      case TransactionType.openingBalance:
        return l10n.initialBalance;
      case TransactionType.expense:
        return l10n.expense;
    }
  }
}

extension ReportTypeLocalization on ReportType {
  String getLocalizedLabel(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case ReportType.supplierOutstanding:
        return l10n.supplierOutstanding;
      case ReportType.supplierCredit:
        return l10n.supplierCredit;
      case ReportType.customerOutstanding:
        return l10n.customerOutstanding;
      case ReportType.customerAdvance:
        return l10n.customerAdvance;
      case ReportType.walletReport:
        return '${l10n.wallets} ${l10n.reports}';
      case ReportType.purchaseReport:
        return l10n.purchaseReport;
      case ReportType.salesReport:
        return l10n.salesReport;
      case ReportType.paymentReport:
        return l10n.paymentsReport;
      case ReportType.ledgerReport:
        return l10n.generalLedgerReport;
      case ReportType.monthlyReport:
        return l10n.monthlySummaryReport;
      case ReportType.profitLossStatement:
        return l10n.profitLossStatement;
    }
  }
}

/// Maps a BLoC message key to a localized string.
/// BLocs emit l10n key names (e.g. 'categoryAdded') instead of raw English.
/// UI listeners call this to translate before showing to user.
String translateBlocMessage(String key, AppLocalizations l10n) {
  switch (key) {
    case 'expenseRecordedSuccessfully':
      return l10n.expenseRecordedSuccessfully;
    case 'expenseDeleted':
      return l10n.expenseDeleted;
    case 'categoryAdded':
      return l10n.categoryAdded;
    case 'categoryUpdated':
      return l10n.categoryUpdated;
    case 'categoryDeleted':
      return l10n.categoryDeleted;
    case 'supplierAddedSuccessfully':
      return l10n.supplierAddedSuccessfully;
    case 'supplierUpdatedSuccessfully':
      return l10n.supplierUpdatedSuccessfully;
    case 'supplierDeleted':
      return l10n.supplierDeleted;
    case 'purchaseRecordedSuccessfully':
      return l10n.purchaseRecordedSuccessfully;
    case 'paymentRecordedSuccessfully':
      return l10n.paymentRecordedSuccessfully;
    case 'supplierNotFound':
      return l10n.supplierNotFound;
    case 'walletAddedSuccessfully':
      return l10n.walletAddedSuccessfully;
    case 'walletUpdatedSuccessfully':
      return l10n.walletUpdatedSuccessfully;
    case 'walletDeleted':
      return l10n.walletDeleted;
    case 'walletNotFound':
      return l10n.walletNotFound;
    case 'customerAddedSuccessfully':
      return l10n.customerAddedSuccessfully;
    case 'customerUpdatedSuccessfully':
      return l10n.customerUpdatedSuccessfully;
    case 'customerDeleted':
      return l10n.customerDeleted;
    case 'saleRecordedSuccessfully':
      return l10n.saleRecordedSuccessfully;
    case 'customerNotFound':
      return l10n.customerNotFound;
    default:
      return key; // fallback: show the raw key (shouldn't happen)
  }
}
