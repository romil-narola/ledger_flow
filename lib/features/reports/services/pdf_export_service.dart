import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/core.dart';
import '../../wallet/wallet.dart';
import '../../supplier/supplier.dart';
import '../../customer/customer.dart';
import '../../ledger/ledger.dart';
import '../../../l10n/app_localizations.dart';

class PdfExportService {
  /// Load Noto Sans font which supports the ₹ Rupee glyph (U+20B9).
  /// Loads from local assets first to guarantee offline and release mode support.
  /// Falls back to PdfGoogleFonts if asset loading fails.
  static Future<pw.Font> _loadFont() async {
    try {
      final fontData =
          await rootBundle.load('assets/fonts/NotoSans-Regular.ttf');
      return pw.Font.ttf(fontData);
    } catch (_) {
      return PdfGoogleFonts.notoSansRegular();
    }
  }

  static Future<pw.Font> _loadFontBold() async {
    try {
      final fontData = await rootBundle.load('assets/fonts/NotoSans-Bold.ttf');
      return pw.Font.ttf(fontData);
    } catch (_) {
      return PdfGoogleFonts.notoSansBold();
    }
  }

  /// Build a [pw.ThemeData] that uses Noto Sans for all text,
  /// ensuring ₹ (and Gujarati/Hindi glyphs if needed) render correctly.
  static Future<pw.ThemeData> _theme() async {
    final base = await _loadFont();
    final bold = await _loadFontBold();
    return pw.ThemeData.withFont(
      base: base,
      bold: bold,
    );
  }

  static Future<File> generateLedgerReport({
    required List<LedgerEntryEntity> entries,
    required String title,
    required AppLocalizations l10n,
    String? subtitle,
  }) async {
    final pdf = pw.Document();
    final theme = await _theme();

    final dateHeader = l10n.date;
    final refHeader = l10n.referenceNo;
    final typeHeader = l10n.transactionType;
    final descHeader = l10n.description;

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          theme: theme,
        ),
        build: (pw.Context context) {
          return [
            // Header
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('${l10n.appTitle} ${l10n.reports}',
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      if (subtitle != null)
                        pw.Text(subtitle,
                            style: const pw.TextStyle(fontSize: 10)),
                    ],
                  ),
                  pw.Text(DateFormatter.format(DateTime.now()),
                      style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(title,
                style:
                    pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 10),

            // Table of Entries
            pw.TableHelper.fromTextArray(
              headers: [
                dateHeader,
                refHeader,
                typeHeader,
                descHeader,
                l10n.debit,
                l10n.credit
              ],
              data: entries.map((e) {
                return [
                  DateFormatter.format(e.date),
                  e.referenceNumber,
                  e.transactionType.label,
                  e.description,
                  e.debit > 0 ? CurrencyFormatter.formatPdf(e.debit) : '-',
                  e.credit > 0 ? CurrencyFormatter.formatPdf(e.credit) : '-',
                ];
              }).toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
              cellHeight: 25,
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerLeft,
                4: pw.Alignment.centerRight,
                5: pw.Alignment.centerRight,
              },
            ),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/Ledger_Report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<File> generateOutstandingReport({
    required List<SupplierEntity> suppliers,
    required List<CustomerEntity> customers,
    required AppLocalizations l10n,
  }) async {
    final pdf = pw.Document();
    final theme = await _theme();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          theme: theme,
        ),
        build: (pw.Context context) {
          return [
            // Header
            pw.Header(
              level: 0,
              child: pw.Text('${l10n.appTitle} ${l10n.outstandingSummary}',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 20),

            if (suppliers.isNotEmpty) ...[
              pw.Text(l10n.supplierOutstanding,
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.TableHelper.fromTextArray(
                headers: [
                  l10n.supplierName,
                  l10n.totalPurchased,
                  l10n.totalPaid,
                  l10n.outstanding
                ],
                data: suppliers
                    .map((s) => [
                          s.name,
                          CurrencyFormatter.formatPdf(s.totalPurchases),
                          CurrencyFormatter.formatPdf(s.totalPayments),
                          CurrencyFormatter.formatPdf(s.outstanding),
                        ])
                    .toList(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.grey300),
              ),
              pw.SizedBox(height: 24),
            ],

            if (customers.isNotEmpty) ...[
              pw.Text(l10n.customerOutstanding,
                  style: pw.TextStyle(
                      fontSize: 12, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.TableHelper.fromTextArray(
                headers: [
                  l10n.customerName,
                  l10n.totalSales,
                  l10n.totalReceived,
                  l10n.outstanding
                ],
                data: customers
                    .map((c) => [
                          c.name,
                          CurrencyFormatter.formatPdf(c.totalSales),
                          CurrencyFormatter.formatPdf(c.totalPayments),
                          CurrencyFormatter.formatPdf(c.outstanding),
                        ])
                    .toList(),
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.grey300),
              ),
            ],
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/Outstanding_Report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<File> generateWalletReport({
    required List<WalletAccountEntity> wallets,
    required AppLocalizations l10n,
  }) async {
    final pdf = pw.Document();
    final theme = await _theme();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          theme: theme,
        ),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Text('${l10n.appTitle} ${l10n.walletAccounts}',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: [
                l10n.walletName,
                l10n.initialBalance,
                l10n.currentBalance,
                l10n.enableOverdraft
              ],
              data: wallets
                  .map((w) => [
                        w.name,
                        CurrencyFormatter.formatPdf(w.openingBalance),
                        CurrencyFormatter.formatPdf(w.currentBalance),
                        w.overdraftEnabled ? l10n.enabled : l10n.disabled,
                      ])
                  .toList(),
              headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey300),
            ),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/Wallet_Balances_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  static Future<File> generateProfitLossReport({
    required double totalSales,
    required double totalPurchases,
    required AppLocalizations l10n,
    DateTime? from,
    DateTime? to,
  }) async {
    final pdf = pw.Document();
    final theme = await _theme();

    final double netProfit = totalSales - totalPurchases;
    final isProfit = netProfit >= 0;
    final String dateRange = (from != null && to != null)
        ? '${l10n.dateRange}: ${DateFormatter.format(from)} - ${DateFormatter.format(to)}'
        : l10n.allTypes;

    pdf.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(32),
          theme: theme,
        ),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('${l10n.appTitle} ${l10n.reports}',
                          style: pw.TextStyle(
                              fontSize: 18, fontWeight: pw.FontWeight.bold)),
                      pw.Text(l10n.financialReports,
                          style: const pw.TextStyle(fontSize: 12)),
                      pw.Text(dateRange,
                          style: const pw.TextStyle(fontSize: 10)),
                    ],
                  ),
                  pw.Text(DateFormatter.format(DateTime.now()),
                      style: const pw.TextStyle(fontSize: 10)),
                ],
              ),
              pw.Divider(height: 24),
              pw.SizedBox(height: 20),

              // Revenue Section
              pw.Text(l10n.income.toUpperCase(),
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('${l10n.totalSales} (${l10n.operatingIncome})'),
                  pw.Text(CurrencyFormatter.formatPdf(totalSales),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Divider(thickness: 0.5),

              // Expense Section
              pw.SizedBox(height: 12),
              pw.Text(l10n.expense.toUpperCase(),
                  style: pw.TextStyle(
                      fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 8),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('${l10n.totalPurchases} (${l10n.costOfSales})'),
                  pw.Text(CurrencyFormatter.formatPdf(totalPurchases),
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 12),
              pw.Divider(thickness: 0.5),

              // Net profit
              pw.SizedBox(height: 20),
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey100,
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                        '${l10n.total} ${isProfit ? l10n.netProfit.toUpperCase() : l10n.netLoss.toUpperCase()}',
                        style: pw.TextStyle(
                            fontSize: 14, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                      CurrencyFormatter.formatPdf(netProfit.abs()),
                      style: pw.TextStyle(
                        fontSize: 14,
                        fontWeight: pw.FontWeight.bold,
                        color: isProfit ? PdfColors.green700 : PdfColors.red700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/Profit_Loss_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
