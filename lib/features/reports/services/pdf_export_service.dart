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
import '../../expenses/expenses.dart';
import '../../ledger/ledger.dart';
import '../../../l10n/app_localizations.dart';

class PdfExportService {
  /// Load Noto Sans font which supports the ₹ Rupee glyph (U+20B9).
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

  static Future<pw.ThemeData> _theme() async {
    final base = await _loadFont();
    final bold = await _loadFontBold();
    return pw.ThemeData.withFont(
      base: base,
      bold: bold,
    );
  }

  /// Safely extracts Party Name from entity or description fallback
  static String _getPartyName(LedgerEntryEntity e) {
    if (e.customerName != null && e.customerName!.trim().isNotEmpty) {
      return e.customerName!;
    }
    if (e.supplierName != null && e.supplierName!.trim().isNotEmpty) {
      return e.supplierName!;
    }
    final match = RegExp(r'\(([^)]+)\)').firstMatch(e.description);
    if (match != null &&
        match.group(1) != null &&
        match.group(1)!.trim().isNotEmpty) {
      return match.group(1)!.trim();
    }
    return '-';
  }

  /// Safely extracts Party Mobile Number from entity
  static String _getPartyPhone(LedgerEntryEntity e) {
    if (e.customerPhone != null && e.customerPhone!.trim().isNotEmpty) {
      return e.customerPhone!;
    }
    if (e.supplierPhone != null && e.supplierPhone!.trim().isNotEmpty) {
      return e.supplierPhone!;
    }
    return '-';
  }

  /// Builds a prominent Summary Box at the top of reports showing
  /// Opening Balance, Total Available Balance, Sales, Purchases, Customer Payouts, and Supplier Payouts.
  static pw.Widget _buildSummaryBox({
    double? openingBalance,
    double? totalAvailableBalance,
    double? totalSales,
    double? totalPurchases,
    double? customerPayouts,
    double? supplierPayouts,
    double? personalExpenses,
    double? businessExpenses,
    double? totalDebit,
    double? totalCredit,
    required AppLocalizations l10n,
  }) {
    final chips = <pw.Widget>[];

    pw.Widget buildChip({
      required String label,
      required double amount,
      required PdfColor bgColor,
      required PdfColor borderColor,
      required PdfColor textColor,
    }) {
      return pw.Container(
        padding: const pw.EdgeInsets.symmetric(horizontal: 8, vertical: 5),
        decoration: pw.BoxDecoration(
          color: bgColor,
          borderRadius: pw.BorderRadius.circular(6),
          border: pw.Border.all(color: borderColor, width: 0.5),
        ),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              label,
              style:
                  const pw.TextStyle(fontSize: 7.0, color: PdfColors.grey700),
            ),
            pw.SizedBox(height: 2),
            pw.Text(
              CurrencyFormatter.formatPdf(amount),
              style: pw.TextStyle(
                  fontSize: 8.5,
                  fontWeight: pw.FontWeight.bold,
                  color: textColor),
            ),
          ],
        ),
      );
    }

    if (openingBalance != null) {
      chips.add(buildChip(
        label: l10n.openingBalance,
        amount: openingBalance,
        bgColor: PdfColors.blue50,
        borderColor: PdfColors.blue200,
        textColor: PdfColors.blue900,
      ));
    }

    if (totalAvailableBalance != null) {
      if (chips.isNotEmpty) chips.add(pw.SizedBox(width: 6));
      chips.add(buildChip(
        label: l10n.totalAvailableBalance,
        amount: totalAvailableBalance,
        bgColor: PdfColors.green50,
        borderColor: PdfColors.green200,
        textColor: PdfColors.green900,
      ));
    }

    if (totalSales != null && totalSales > 0) {
      if (chips.isNotEmpty) chips.add(pw.SizedBox(width: 6));
      chips.add(buildChip(
        label: l10n.totalSales,
        amount: totalSales,
        bgColor: PdfColors.teal50,
        borderColor: PdfColors.teal200,
        textColor: PdfColors.teal900,
      ));
    }

    if (totalPurchases != null && totalPurchases > 0) {
      if (chips.isNotEmpty) chips.add(pw.SizedBox(width: 6));
      chips.add(buildChip(
        label: l10n.totalPurchases,
        amount: totalPurchases,
        bgColor: PdfColors.deepOrange50,
        borderColor: PdfColors.deepOrange200,
        textColor: PdfColors.deepOrange900,
      ));
    }

    if (customerPayouts != null && customerPayouts > 0) {
      if (chips.isNotEmpty) chips.add(pw.SizedBox(width: 6));
      chips.add(buildChip(
        label: l10n.customerPayouts,
        amount: customerPayouts,
        bgColor: PdfColors.lightGreen50,
        borderColor: PdfColors.lightGreen200,
        textColor: PdfColors.lightGreen900,
      ));
    }

    if (supplierPayouts != null && supplierPayouts > 0) {
      if (chips.isNotEmpty) chips.add(pw.SizedBox(width: 6));
      chips.add(buildChip(
        label: l10n.supplierPayouts,
        amount: supplierPayouts,
        bgColor: PdfColors.purple50,
        borderColor: PdfColors.purple200,
        textColor: PdfColors.purple900,
      ));
    }

    if (personalExpenses != null && personalExpenses > 0) {
      if (chips.isNotEmpty) chips.add(pw.SizedBox(width: 6));
      chips.add(buildChip(
        label: 'Personal Exp.',
        amount: personalExpenses,
        bgColor: PdfColors.purple50,
        borderColor: PdfColors.purple200,
        textColor: PdfColors.purple900,
      ));
    }

    if (businessExpenses != null && businessExpenses > 0) {
      if (chips.isNotEmpty) chips.add(pw.SizedBox(width: 6));
      chips.add(buildChip(
        label: 'Operating Exp.',
        amount: businessExpenses,
        bgColor: PdfColors.indigo50,
        borderColor: PdfColors.indigo200,
        textColor: PdfColors.indigo900,
      ));
    }

    if (totalDebit != null && totalDebit > 0 && customerPayouts == null) {
      if (chips.isNotEmpty) chips.add(pw.SizedBox(width: 6));
      chips.add(buildChip(
        label: l10n.debit,
        amount: totalDebit,
        bgColor: PdfColors.orange50,
        borderColor: PdfColors.orange200,
        textColor: PdfColors.orange900,
      ));
    }

    if (totalCredit != null && totalCredit > 0 && supplierPayouts == null) {
      if (chips.isNotEmpty) chips.add(pw.SizedBox(width: 6));
      chips.add(buildChip(
        label: l10n.credit,
        amount: totalCredit,
        bgColor: PdfColors.purple50,
        borderColor: PdfColors.purple200,
        textColor: PdfColors.purple900,
      ));
    }

    if (chips.isEmpty) return pw.SizedBox.shrink();

    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 10),
      child: pw.Wrap(spacing: 6, runSpacing: 6, children: chips),
    );
  }

  /// Builds a rich Customer Profile/Details Header Box
  static pw.Widget _buildCustomerDetailHeader(
      CustomerEntity customer, AppLocalizations l10n) {
    final details = <String>[];
    if (customer.phone != null && customer.phone!.trim().isNotEmpty) {
      details.add('${l10n.phone}: ${customer.phone}');
    }
    if (customer.email != null && customer.email!.trim().isNotEmpty) {
      details.add('${l10n.email}: ${customer.email}');
    }
    if (customer.address != null && customer.address!.trim().isNotEmpty) {
      details.add('${l10n.address}: ${customer.address}');
    }

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(8),
      margin: const pw.EdgeInsets.only(bottom: 8),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${l10n.customer}: ${customer.name}',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                '${l10n.outstanding}: ${CurrencyFormatter.formatPdf(customer.outstanding)}',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.red800,
                ),
              ),
            ],
          ),
          if (details.isNotEmpty) ...[
            pw.SizedBox(height: 3),
            pw.Text(
              details.join('  |  '),
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey800),
            ),
          ],
          if (customer.notes != null && customer.notes!.trim().isNotEmpty) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              '${l10n.notes}: ${customer.notes}',
              style:
                  const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700),
            ),
          ],
        ],
      ),
    );
  }

  /// Builds a rich Supplier Profile/Details Header Box
  static pw.Widget _buildSupplierDetailHeader(
      SupplierEntity supplier, AppLocalizations l10n) {
    final details = <String>[];
    if (supplier.phone != null && supplier.phone!.trim().isNotEmpty) {
      details.add('${l10n.phone}: ${supplier.phone}');
    }
    if (supplier.email != null && supplier.email!.trim().isNotEmpty) {
      details.add('${l10n.email}: ${supplier.email}');
    }
    if (supplier.address != null && supplier.address!.trim().isNotEmpty) {
      details.add('${l10n.address}: ${supplier.address}');
    }

    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(8),
      margin: const pw.EdgeInsets.only(bottom: 8),
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: PdfColors.grey300, width: 0.5),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                '${l10n.supplier}: ${supplier.name}',
                style:
                    pw.TextStyle(fontSize: 10, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                '${l10n.outstanding}: ${CurrencyFormatter.formatPdf(supplier.outstanding)}',
                style: pw.TextStyle(
                  fontSize: 9,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.orange800,
                ),
              ),
            ],
          ),
          if (details.isNotEmpty) ...[
            pw.SizedBox(height: 3),
            pw.Text(
              details.join('  |  '),
              style: const pw.TextStyle(fontSize: 8, color: PdfColors.grey800),
            ),
          ],
          if (supplier.notes != null && supplier.notes!.trim().isNotEmpty) ...[
            pw.SizedBox(height: 2),
            pw.Text(
              '${l10n.notes}: ${supplier.notes}',
              style:
                  const pw.TextStyle(fontSize: 7.5, color: PdfColors.grey700),
            ),
          ],
        ],
      ),
    );
  }

  static Future<File> generateLedgerReport({
    required List<LedgerEntryEntity> entries,
    required String title,
    required AppLocalizations l10n,
    String? subtitle,
    double? openingBalance,
    double? totalAvailableBalance,
    double? totalSales,
    double? totalPurchases,
    double? customerPayouts,
    double? supplierPayouts,
    double? personalExpenses,
    double? businessExpenses,
  }) async {
    final pdf = pw.Document();
    final theme = await _theme();

    final dateHeader = l10n.date;
    final refHeader = l10n.referenceNo;
    final typeHeader = l10n.transactionType;
    final partyHeader = l10n.partyName;
    final walletHeader = l10n.walletAccount;
    final descHeader = l10n.description;

    final double totalDebit = entries.fold(0.0, (sum, e) => sum + e.debit);
    final double totalCredit = entries.fold(0.0, (sum, e) => sum + e.credit);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
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
                              fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      if (subtitle != null)
                        pw.Text(subtitle,
                            style: const pw.TextStyle(fontSize: 8.5)),
                    ],
                  ),
                  pw.Text(DateFormatter.format(DateTime.now()),
                      style: const pw.TextStyle(fontSize: 8.5)),
                ],
              ),
            ),
            pw.SizedBox(height: 8),
            pw.Text(title,
                style:
                    pw.TextStyle(fontSize: 11, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 6),

            // Summary Box
            _buildSummaryBox(
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
              totalSales: totalSales,
              totalPurchases: totalPurchases,
              customerPayouts: customerPayouts,
              supplierPayouts: supplierPayouts,
              personalExpenses: personalExpenses,
              businessExpenses: businessExpenses,
              totalDebit: totalDebit,
              totalCredit: totalCredit,
              l10n: l10n,
            ),

            // Detailed Table including Party Name (Customer/Supplier), Mobile Number & Wallet Account
            pw.TableHelper.fromTextArray(
              headers: [
                dateHeader,
                refHeader,
                typeHeader,
                partyHeader,
                l10n.phone,
                walletHeader,
                descHeader,
                l10n.debit,
                l10n.credit
              ],
              data: entries.map((e) {
                final party = _getPartyName(e);
                final phone = _getPartyPhone(e);
                final wallet = e.walletName ?? '-';
                return [
                  DateFormatter.format(e.date),
                  e.referenceNumber,
                  e.transactionType.label,
                  party,
                  phone,
                  wallet,
                  e.description,
                  e.debit > 0 ? CurrencyFormatter.formatPdf(e.debit) : '-',
                  e.credit > 0 ? CurrencyFormatter.formatPdf(e.credit) : '-',
                ];
              }).toList(),
              headerStyle:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7.5),
              cellStyle: const pw.TextStyle(fontSize: 7.0),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey200),
              cellPadding:
                  const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerLeft,
                4: pw.Alignment.centerLeft,
                5: pw.Alignment.centerLeft,
                6: pw.Alignment.centerLeft,
                7: pw.Alignment.centerRight,
                8: pw.Alignment.centerRight,
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
    double? openingBalance,
    double? totalAvailableBalance,
  }) async {
    final pdf = pw.Document();
    final theme = await _theme();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          theme: theme,
        ),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('${l10n.appTitle} ${l10n.outstandingSummary}',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Text(DateFormatter.format(DateTime.now()),
                      style: const pw.TextStyle(fontSize: 8.5)),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            _buildSummaryBox(
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
              l10n: l10n,
            ),
            if (suppliers.isNotEmpty) ...[
              pw.Text(l10n.supplierOutstanding,
                  style: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              pw.TableHelper.fromTextArray(
                headers: [
                  l10n.supplierName,
                  l10n.phone,
                  l10n.email,
                  l10n.totalPurchased,
                  l10n.supplierPayouts,
                  l10n.outstanding
                ],
                data: suppliers
                    .map((s) => [
                          s.name,
                          s.phone ?? '-',
                          s.email ?? '-',
                          CurrencyFormatter.formatPdf(s.totalPurchases),
                          CurrencyFormatter.formatPdf(s.totalPayments),
                          CurrencyFormatter.formatPdf(s.outstanding),
                        ])
                    .toList(),
                headerStyle:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8.0),
                cellStyle: const pw.TextStyle(fontSize: 7.5),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.grey200),
                cellPadding:
                    const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              ),
              pw.SizedBox(height: 14),
            ],
            if (customers.isNotEmpty) ...[
              pw.Text(l10n.customerOutstanding,
                  style: pw.TextStyle(
                      fontSize: 10, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              pw.TableHelper.fromTextArray(
                headers: [
                  l10n.customerName,
                  l10n.phone,
                  l10n.email,
                  l10n.totalSales,
                  l10n.customerPayouts,
                  l10n.outstanding
                ],
                data: customers
                    .map((c) => [
                          c.name,
                          c.phone ?? '-',
                          c.email ?? '-',
                          CurrencyFormatter.formatPdf(c.totalSales),
                          CurrencyFormatter.formatPdf(c.totalPayments),
                          CurrencyFormatter.formatPdf(c.outstanding),
                        ])
                    .toList(),
                headerStyle:
                    pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8.0),
                cellStyle: const pw.TextStyle(fontSize: 7.5),
                headerDecoration:
                    const pw.BoxDecoration(color: PdfColors.grey200),
                cellPadding:
                    const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
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
    double? openingBalance,
    double? totalAvailableBalance,
  }) async {
    final pdf = pw.Document();
    final theme = await _theme();

    final calcOpening = openingBalance ??
        wallets.fold<double>(0.0, (sum, w) => sum + w.openingBalance);
    final calcAvailable = totalAvailableBalance ??
        wallets.fold<double>(0.0, (sum, w) => sum + w.currentBalance);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
          theme: theme,
        ),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('${l10n.appTitle} ${l10n.walletAccounts}',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Text(DateFormatter.format(DateTime.now()),
                      style: const pw.TextStyle(fontSize: 8.5)),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            _buildSummaryBox(
              openingBalance: calcOpening,
              totalAvailableBalance: calcAvailable,
              l10n: l10n,
            ),
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
              headerStyle:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8.5),
              cellStyle: const pw.TextStyle(fontSize: 8.0),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey200),
              cellPadding:
                  const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 4),
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
    double businessExpenses = 0.0,
    double personalExpenses = 0.0,
    DateTime? from,
    DateTime? to,
    double? openingBalance,
    double? totalAvailableBalance,
    double? customerPayouts,
    double? supplierPayouts,
  }) async {
    final pdf = pw.Document();
    final theme = await _theme();

    final double grossProfit = totalSales - totalPurchases;
    final double netOperatingProfit = grossProfit - businessExpenses;
    final double netFinalBalance = netOperatingProfit - personalExpenses;
    final isProfit = netFinalBalance >= 0;
    final String dateRange = (from != null && to != null)
        ? '${l10n.dateRange}: ${DateFormatter.format(from)} - ${DateFormatter.format(to)}'
        : l10n.allTypes;

    pdf.addPage(
      pw.Page(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(24),
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
                              fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      pw.Text(l10n.financialReports,
                          style: const pw.TextStyle(fontSize: 9)),
                      pw.Text(dateRange,
                          style: const pw.TextStyle(fontSize: 8.5)),
                    ],
                  ),
                  pw.Text(DateFormatter.format(DateTime.now()),
                      style: const pw.TextStyle(fontSize: 8.5)),
                ],
              ),
              pw.Divider(height: 16),
              pw.SizedBox(height: 8),

              _buildSummaryBox(
                openingBalance: openingBalance,
                totalAvailableBalance: totalAvailableBalance,
                totalSales: totalSales,
                totalPurchases: totalPurchases,
                customerPayouts: customerPayouts,
                supplierPayouts: supplierPayouts,
                l10n: l10n,
              ),

              // Revenue Section
              pw.Text(l10n.income.toUpperCase(),
                  style: pw.TextStyle(
                      fontSize: 10.5, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('${l10n.totalSales} (${l10n.operatingIncome})',
                      style: const pw.TextStyle(fontSize: 8.5)),
                  pw.Text(CurrencyFormatter.formatPdf(totalSales),
                      style: pw.TextStyle(
                          fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Divider(thickness: 0.5),

              // Expense & Purchase Section
              pw.SizedBox(height: 8),
              pw.Text(l10n.expense.toUpperCase(),
                  style: pw.TextStyle(
                      fontSize: 10.5, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('${l10n.totalPurchases} (${l10n.costOfSales})',
                      style: const pw.TextStyle(fontSize: 8.5)),
                  pw.Text(CurrencyFormatter.formatPdf(totalPurchases),
                      style: pw.TextStyle(
                          fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Gross Profit (Sales - Purchases)',
                      style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey700)),
                  pw.Text(CurrencyFormatter.formatPdf(grossProfit),
                      style: pw.TextStyle(
                          fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Divider(thickness: 0.5),

              // Operating & Personal Expenses Section
              pw.SizedBox(height: 8),
              pw.Text('OPERATING & PERSONAL EXPENSES',
                  style: pw.TextStyle(
                      fontSize: 10.5, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 6),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Business Operating Expenses',
                      style: const pw.TextStyle(fontSize: 8.5)),
                  pw.Text(CurrencyFormatter.formatPdf(businessExpenses),
                      style: pw.TextStyle(
                          fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Net Operating Business Profit',
                      style: const pw.TextStyle(fontSize: 8.5, color: PdfColors.grey700)),
                  pw.Text(CurrencyFormatter.formatPdf(netOperatingProfit),
                      style: pw.TextStyle(
                          fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 4),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('Personal Out-of-Pocket Expenses',
                      style: const pw.TextStyle(fontSize: 8.5)),
                  pw.Text(CurrencyFormatter.formatPdf(personalExpenses),
                      style: pw.TextStyle(
                          fontSize: 8.5, fontWeight: pw.FontWeight.bold)),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Divider(thickness: 0.5),

              // Net profit
              pw.SizedBox(height: 14),
              pw.Container(
                padding: const pw.EdgeInsets.all(10),
                decoration: const pw.BoxDecoration(
                  color: PdfColors.grey100,
                ),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Text(
                        'NET RETAINED ${isProfit ? l10n.netProfit.toUpperCase() : l10n.netLoss.toUpperCase()}',
                        style: pw.TextStyle(
                            fontSize: 10.5, fontWeight: pw.FontWeight.bold)),
                    pw.Text(
                      CurrencyFormatter.formatPdf(netFinalBalance.abs()),
                      style: pw.TextStyle(
                        fontSize: 10.5,
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

  /// Generate detailed report for a specific Customer with full profile details & Party columns
  static Future<File> generateCustomerLedgerReport({
    required CustomerEntity customer,
    required List<CustomerLedgerEntry> entries,
    required AppLocalizations l10n,
    double? totalAvailableBalance,
  }) async {
    final pdf = pw.Document();
    final theme = await _theme();

    final totalDebit = entries.fold(0.0, (sum, e) => sum + e.debit);
    final totalCredit = entries.fold(0.0, (sum, e) => sum + e.credit);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          theme: theme,
        ),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('${l10n.customer} ${l10n.ledger}',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Text(DateFormatter.format(DateTime.now()),
                      style: const pw.TextStyle(fontSize: 8.5)),
                ],
              ),
            ),
            pw.SizedBox(height: 8),

            // Detailed Customer Profile Header Box
            _buildCustomerDetailHeader(customer, l10n),

            _buildSummaryBox(
              openingBalance:
                  customer.advanceBalance > 0 ? customer.advanceBalance : 0.0,
              totalAvailableBalance: totalAvailableBalance,
              totalSales: customer.totalSales,
              customerPayouts: customer.totalPayments,
              totalDebit: totalDebit,
              totalCredit: totalCredit,
              l10n: l10n,
            ),

            pw.TableHelper.fromTextArray(
              headers: [
                l10n.date,
                l10n.referenceNo,
                l10n.transactionType,
                l10n.partyName,
                l10n.phone,
                l10n.description,
                l10n.debit,
                l10n.credit,
                l10n.balance
              ],
              data: entries.map((e) {
                return [
                  DateFormatter.format(e.date),
                  e.referenceNumber,
                  e.transactionType,
                  customer.name,
                  customer.phone ?? '-',
                  e.description,
                  e.debit > 0 ? CurrencyFormatter.formatPdf(e.debit) : '-',
                  e.credit > 0 ? CurrencyFormatter.formatPdf(e.credit) : '-',
                  CurrencyFormatter.formatPdf(e.balance),
                ];
              }).toList(),
              headerStyle:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7.5),
              cellStyle: const pw.TextStyle(fontSize: 7.0),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey200),
              cellPadding:
                  const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerLeft,
                4: pw.Alignment.centerLeft,
                5: pw.Alignment.centerLeft,
                6: pw.Alignment.centerRight,
                7: pw.Alignment.centerRight,
                8: pw.Alignment.centerRight,
              },
            ),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/Customer_Ledger_${customer.name}_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Generate detailed report for a specific Supplier with full profile details & Party columns
  static Future<File> generateSupplierLedgerReport({
    required SupplierEntity supplier,
    required List<SupplierLedgerEntry> entries,
    required AppLocalizations l10n,
    double? totalAvailableBalance,
  }) async {
    final pdf = pw.Document();
    final theme = await _theme();

    final totalDebit = entries.fold(0.0, (sum, e) => sum + e.debit);
    final totalCredit = entries.fold(0.0, (sum, e) => sum + e.credit);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          theme: theme,
        ),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('${l10n.supplier} ${l10n.ledger}',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Text(DateFormatter.format(DateTime.now()),
                      style: const pw.TextStyle(fontSize: 8.5)),
                ],
              ),
            ),
            pw.SizedBox(height: 8),

            // Detailed Supplier Profile Header Box
            _buildSupplierDetailHeader(supplier, l10n),

            _buildSummaryBox(
              openingBalance:
                  supplier.creditBalance > 0 ? supplier.creditBalance : 0.0,
              totalAvailableBalance: totalAvailableBalance,
              totalPurchases: supplier.totalPurchases,
              supplierPayouts: supplier.totalPayments,
              totalDebit: totalDebit,
              totalCredit: totalCredit,
              l10n: l10n,
            ),

            pw.TableHelper.fromTextArray(
              headers: [
                l10n.date,
                l10n.referenceNo,
                l10n.transactionType,
                l10n.partyName,
                l10n.phone,
                l10n.description,
                l10n.debit,
                l10n.credit,
                l10n.balance
              ],
              data: entries.map((e) {
                return [
                  DateFormatter.format(e.date),
                  e.referenceNumber,
                  e.transactionType,
                  supplier.name,
                  supplier.phone ?? '-',
                  e.description,
                  e.debit > 0 ? CurrencyFormatter.formatPdf(e.debit) : '-',
                  e.credit > 0 ? CurrencyFormatter.formatPdf(e.credit) : '-',
                  CurrencyFormatter.formatPdf(e.balance),
                ];
              }).toList(),
              headerStyle:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7.5),
              cellStyle: const pw.TextStyle(fontSize: 7.0),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey200),
              cellPadding:
                  const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerLeft,
                4: pw.Alignment.centerLeft,
                5: pw.Alignment.centerLeft,
                6: pw.Alignment.centerRight,
                7: pw.Alignment.centerRight,
                8: pw.Alignment.centerRight,
              },
            ),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/Supplier_Ledger_${supplier.name}_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Generate detailed report for a single Wallet Account with Party Name & Phone columns
  static Future<File> generateSingleWalletReport({
    required WalletAccountEntity wallet,
    required List<WalletTransactionItem> transactions,
    required AppLocalizations l10n,
    double? totalAvailableBalance,
  }) async {
    final pdf = pw.Document();
    final theme = await _theme();

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          theme: theme,
        ),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text('${l10n.walletHistory}: ${wallet.name}',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Text(DateFormatter.format(DateTime.now()),
                      style: const pw.TextStyle(fontSize: 8.5)),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            _buildSummaryBox(
              openingBalance: wallet.openingBalance,
              totalAvailableBalance:
                  totalAvailableBalance ?? wallet.currentBalance,
              l10n: l10n,
            ),
            pw.TableHelper.fromTextArray(
              headers: [
                l10n.date,
                l10n.referenceNo,
                l10n.transactionType,
                l10n.partyName,
                l10n.phone,
                l10n.description,
                l10n.debit,
                l10n.credit,
                l10n.balance
              ],
              data: transactions.map((e) {
                final party = e.partyName ?? '-';
                final phone = e.partyPhone ?? '-';
                return [
                  DateFormatter.format(e.date),
                  e.referenceNumber,
                  e.transactionType,
                  party,
                  phone,
                  e.description,
                  e.debit > 0 ? CurrencyFormatter.formatPdf(e.debit) : '-',
                  e.credit > 0 ? CurrencyFormatter.formatPdf(e.credit) : '-',
                  CurrencyFormatter.formatPdf(e.balance),
                ];
              }).toList(),
              headerStyle:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 7.5),
              cellStyle: const pw.TextStyle(fontSize: 7.0),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey200),
              cellPadding:
                  const pw.EdgeInsets.symmetric(horizontal: 3, vertical: 3),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerLeft,
                4: pw.Alignment.centerLeft,
                5: pw.Alignment.centerLeft,
                6: pw.Alignment.centerRight,
                7: pw.Alignment.centerRight,
                8: pw.Alignment.centerRight,
              },
            ),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/Wallet_${wallet.name}_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Dedicated Sales Report Generator with Customer Name & Customer Mobile Number
  static Future<File> generateSalesReport({
    required List<SaleEntity> sales,
    required Map<int, String?> customerPhones,
    Map<int, String?>? customerNames,
    required AppLocalizations l10n,
    String? subtitle,
    double? openingBalance,
    double? totalAvailableBalance,
    double? customerPayouts,
  }) async {
    final pdf = pw.Document();
    final theme = await _theme();
    final double totalSales = sales.fold(0.0, (sum, s) => sum + s.amount);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          theme: theme,
        ),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('${l10n.appTitle} ${l10n.salesReport}',
                          style: pw.TextStyle(
                              fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      if (subtitle != null)
                        pw.Text(subtitle,
                            style: const pw.TextStyle(fontSize: 8.5)),
                    ],
                  ),
                  pw.Text(DateFormatter.format(DateTime.now()),
                      style: const pw.TextStyle(fontSize: 8.5)),
                ],
              ),
            ),
            pw.SizedBox(height: 8),
            _buildSummaryBox(
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
              totalSales: totalSales,
              customerPayouts: customerPayouts,
              l10n: l10n,
            ),
            pw.TableHelper.fromTextArray(
              headers: [
                l10n.date,
                l10n.referenceNo,
                l10n.customerName,
                l10n.phone,
                l10n.description,
                l10n.amount
              ],
              data: sales.map((s) {
                final name = s.customerName.trim().isNotEmpty
                    ? s.customerName
                    : (customerNames?[s.customerId] ?? '-');
                final phone = customerPhones[s.customerId] ?? '-';
                return [
                  DateFormatter.format(s.date),
                  s.referenceNumber,
                  name,
                  phone,
                  s.notes ?? '-',
                  CurrencyFormatter.formatPdf(s.amount),
                ];
              }).toList(),
              headerStyle:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8.0),
              cellStyle: const pw.TextStyle(fontSize: 7.5),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey200),
              cellPadding:
                  const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerLeft,
                4: pw.Alignment.centerLeft,
                5: pw.Alignment.centerRight,
              },
            ),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/Sales_Report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Dedicated Purchase Report Generator with Supplier Name & Supplier Mobile Number
  static Future<File> generatePurchaseReport({
    required List<PurchaseEntity> purchases,
    required Map<int, String?> supplierPhones,
    Map<int, String?>? supplierNames,
    required AppLocalizations l10n,
    String? subtitle,
    double? openingBalance,
    double? totalAvailableBalance,
    double? supplierPayouts,
  }) async {
    final pdf = pw.Document();
    final theme = await _theme();
    final double totalPurchases =
        purchases.fold(0.0, (sum, p) => sum + p.amount);

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          theme: theme,
        ),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text('${l10n.appTitle} ${l10n.purchaseReport}',
                          style: pw.TextStyle(
                              fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      if (subtitle != null)
                        pw.Text(subtitle,
                            style: const pw.TextStyle(fontSize: 8.5)),
                    ],
                  ),
                  pw.Text(DateFormatter.format(DateTime.now()),
                      style: const pw.TextStyle(fontSize: 8.5)),
                ],
              ),
            ),
            pw.SizedBox(height: 8),
            _buildSummaryBox(
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
              totalPurchases: totalPurchases,
              supplierPayouts: supplierPayouts,
              l10n: l10n,
            ),
            pw.TableHelper.fromTextArray(
              headers: [
                l10n.date,
                l10n.referenceNo,
                l10n.supplierName,
                l10n.phone,
                l10n.walletAccount,
                l10n.description,
                l10n.amount
              ],
              data: purchases.map((p) {
                final name = p.supplierName.trim().isNotEmpty
                    ? p.supplierName
                    : (supplierNames?[p.supplierId] ?? '-');
                final phone = supplierPhones[p.supplierId] ?? '-';
                return [
                  DateFormatter.format(p.date),
                  p.referenceNumber,
                  name,
                  phone,
                  p.walletName.isNotEmpty ? p.walletName : '-',
                  p.notes ?? '-',
                  CurrencyFormatter.formatPdf(p.amount),
                ];
              }).toList(),
              headerStyle:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8.0),
              cellStyle: const pw.TextStyle(fontSize: 7.5),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey200),
              cellPadding:
                  const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerLeft,
                4: pw.Alignment.centerLeft,
                5: pw.Alignment.centerLeft,
                6: pw.Alignment.centerRight,
              },
            ),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/Purchase_Report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  /// Dedicated Expense Report Generator
  static Future<File> generateExpenseReport({
    required List<ExpenseEntity> expenses,
    required AppLocalizations l10n,
    String? subtitle,
    double? openingBalance,
    double? totalAvailableBalance,
  }) async {
    final pdf = pw.Document();
    final theme = await _theme();
    final personalCategories = [
      'food', 'dining', 'entertainment', 'medical', 'doctor',
      'hospital', 'medicine', 'education', 'school', 'college',
      'tuition', 'fee', 'personal', 'family', 'shopping',
      'clothing', 'grocery', 'groceries', 'home', 'house',
      'movie', 'gift', 'recharge', 'subscription', 'life',
      'health', 'self', 'draw', 'drawing', 'household',
      'charity', 'vacation', 'trip'
    ];
    double personalTotal = 0.0;
    double businessTotal = 0.0;
    final double totalExpenses = expenses.fold(0.0, (sum, e) => sum + e.amount);
    for (final e in expenses) {
      final isPersonal = personalCategories
          .any((p) => e.categoryName.toLowerCase().contains(p));
      if (isPersonal) {
        personalTotal += e.amount;
      } else {
        businessTotal += e.amount;
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageTheme: pw.PageTheme(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          theme: theme,
        ),
        build: (pw.Context context) {
          return [
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                          '${l10n.appTitle} ${l10n.expenses} ${l10n.reports}',
                          style: pw.TextStyle(
                              fontSize: 14, fontWeight: pw.FontWeight.bold)),
                      if (subtitle != null)
                        pw.Text(subtitle,
                            style: const pw.TextStyle(fontSize: 8.5)),
                    ],
                  ),
                  pw.Text(DateFormatter.format(DateTime.now()),
                      style: const pw.TextStyle(fontSize: 8.5)),
                ],
              ),
            ),
            pw.SizedBox(height: 8),

            _buildSummaryBox(
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
              totalDebit: totalExpenses,
              l10n: l10n,
            ),
            pw.SizedBox(height: 6),

            // Bifurcation Box
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(
                color: PdfColors.indigo50,
                borderRadius: pw.BorderRadius.circular(6),
                border: pw.Border.all(color: PdfColors.indigo200),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceAround,
                children: [
                  pw.Text(
                    'Personal Expenses: ${CurrencyFormatter.formatPdf(personalTotal)}',
                    style: pw.TextStyle(
                        fontSize: 8.5,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.purple900),
                  ),
                  pw.Text(
                    'Business Expenses: ${CurrencyFormatter.formatPdf(businessTotal)}',
                    style: pw.TextStyle(
                        fontSize: 8.5,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue900),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 8),

            pw.TableHelper.fromTextArray(
              headers: [
                l10n.date,
                l10n.referenceNo,
                'Type',
                l10n.category,
                l10n.walletAccount,
                l10n.description,
                l10n.amount
              ],
              data: expenses.map((e) {
                final isPersonal = personalCategories
                    .any((p) => e.categoryName.toLowerCase().contains(p));
                final wallet = e.walletName ?? '-';
                return [
                  DateFormatter.format(e.date),
                  e.referenceNumber,
                  isPersonal ? 'Personal' : 'Business',
                  e.categoryName,
                  wallet,
                  e.description,
                  CurrencyFormatter.formatPdf(e.amount),
                ];
              }).toList(),
              headerStyle:
                  pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 8.0),
              cellStyle: const pw.TextStyle(fontSize: 7.5),
              headerDecoration:
                  const pw.BoxDecoration(color: PdfColors.grey200),
              cellPadding:
                  const pw.EdgeInsets.symmetric(horizontal: 4, vertical: 3),
              cellAlignments: {
                0: pw.Alignment.centerLeft,
                1: pw.Alignment.centerLeft,
                2: pw.Alignment.centerLeft,
                3: pw.Alignment.centerLeft,
                4: pw.Alignment.centerLeft,
                5: pw.Alignment.centerLeft,
                6: pw.Alignment.centerRight,
              },
            ),
          ];
        },
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/Expense_Report_${DateTime.now().millisecondsSinceEpoch}.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }
}
