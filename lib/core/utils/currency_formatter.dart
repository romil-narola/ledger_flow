import 'package:intl/intl.dart';
import '../constants/app_constants.dart';

/// Utility class for formatting currency values in Indian Rupee format
class CurrencyFormatter {
  CurrencyFormatter._();

  /// Indian number format (e.g., 1,00,000)
  static final NumberFormat _indianFormat = NumberFormat.currency(
    locale: 'en_IN',
    symbol: AppConstants.currencySymbol,
    decimalDigits: 2,
  );

  static final NumberFormat _indianFormatNoDecimal = NumberFormat.currency(
    locale: 'en_IN',
    symbol: AppConstants.currencySymbol,
    decimalDigits: 0,
  );

  static final NumberFormat _compactFormat = NumberFormat.compact(
    locale: 'en_IN',
  );

  /// Format amount for PDF export using the ₹ Rupee symbol.
  /// Noto Sans font (used in PdfExportService) fully supports U+20B9.
  static String formatPdf(double amount) {
    return _indianFormat.format(amount);
  }

  /// Format amount with currency symbol (e.g., ₹1,00,000.00)
  static String format(double amount) {
    return _indianFormat.format(amount);
  }

  /// Format amount without decimal places (e.g., ₹1,00,000)
  static String formatNoDecimal(double amount) {
    return _indianFormatNoDecimal.format(amount);
  }

  /// Format amount in compact form (e.g., ₹1L, ₹50K)
  static String formatCompact(double amount) {
    return '${AppConstants.currencySymbol}${_compactFormat.format(amount)}';
  }

  /// Format amount with sign (e.g., +₹1,00,000 or -₹50,000)
  static String formatWithSign(double amount) {
    final sign = amount >= 0 ? '+' : '';
    return '$sign${format(amount)}';
  }

  /// Parse a formatted string back to double
  static double? parse(String value) {
    try {
      final cleaned = value
          .replaceAll(AppConstants.currencySymbol, '')
          .replaceAll(',', '')
          .trim();
      return double.tryParse(cleaned);
    } catch (_) {
      return null;
    }
  }

  /// Format for display in cards (abbreviated)
  static String formatCard(double amount) {
    if (amount >= 10000000) {
      return '${AppConstants.currencySymbol}${(amount / 10000000).toStringAsFixed(2)}Cr';
    } else if (amount >= 100000) {
      return '${AppConstants.currencySymbol}${(amount / 100000).toStringAsFixed(2)}L';
    } else if (amount >= 1000) {
      return '${AppConstants.currencySymbol}${(amount / 1000).toStringAsFixed(1)}K';
    }
    return formatNoDecimal(amount);
  }
}
