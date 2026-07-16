import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/core.dart';
import '../../wallet/wallet.dart';
import '../../supplier/supplier.dart';
import '../../customer/customer.dart';
import '../../ledger/ledger.dart';
import '../../../l10n/app_localizations.dart';

class ExcelExportService {
  static Future<File> exportLedger({
    required List<LedgerEntryEntity> entries,
    required String sheetName,
    required AppLocalizations l10n,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel[sheetName];
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    // Add Headers
    final headers = [
      l10n.date,
      l10n.referenceNo,
      l10n.transactionType,
      l10n.description,
      l10n.debit,
      l10n.credit,
      l10n.walletBalanceAfter
    ];
    for (var col = 0; col < headers.length; col++) {
      final cell =
          sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0));
      cell.value = TextCellValue(headers[col]);
    }

    // Add Row Data
    for (var row = 0; row < entries.length; row++) {
      final entry = entries[row];
      final values = [
        DateFormatter.format(entry.date),
        entry.referenceNumber,
        entry.transactionType.label,
        entry.description,
        entry.debit,
        entry.credit,
        entry.walletBalance,
      ];

      for (var col = 0; col < values.length; col++) {
        final cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 1));
        final val = values[col];
        if (val is double) {
          cell.value = DoubleCellValue(val);
        } else {
          cell.value = TextCellValue(val.toString());
        }
      }
    }

    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/Ledger_${sheetName}_${DateTime.now().millisecondsSinceEpoch}.xlsx');
    final bytes = excel.save();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file;
  }

  static Future<File> exportOutstanding({
    required List<SupplierEntity> suppliers,
    required List<CustomerEntity> customers,
    required AppLocalizations l10n,
  }) async {
    final excel = Excel.createExcel();
    final sSheet = excel[l10n.suppliers];
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }
    final sHeaders = [
      l10n.supplierName,
      l10n.phone,
      l10n.totalPurchased,
      l10n.totalPaid,
      l10n.outstanding,
      l10n.creditBalance
    ];
    for (var col = 0; col < sHeaders.length; col++) {
      sSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
          .value = TextCellValue(sHeaders[col]);
    }
    for (var row = 0; row < suppliers.length; row++) {
      final s = suppliers[row];
      final values = [
        s.name,
        s.phone ?? '',
        s.totalPurchases,
        s.totalPayments,
        s.outstanding,
        s.creditBalance
      ];
      for (var col = 0; col < values.length; col++) {
        final cell = sSheet.cell(
            CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 1));
        final val = values[col];
        if (val is double) {
          cell.value = DoubleCellValue(val);
        } else {
          cell.value = TextCellValue(val.toString());
        }
      }
    }

    // Customers sheet
    final cSheet = excel[l10n.customers];
    final cHeaders = [
      l10n.customerName,
      l10n.phone,
      l10n.totalSales,
      l10n.totalReceived,
      l10n.outstanding,
      l10n.advanceBalance
    ];
    for (var col = 0; col < cHeaders.length; col++) {
      cSheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
          .value = TextCellValue(cHeaders[col]);
    }
    for (var row = 0; row < customers.length; row++) {
      final c = customers[row];
      final values = [
        c.name,
        c.phone ?? '',
        c.totalSales,
        c.totalPayments,
        c.outstanding,
        c.advanceBalance
      ];
      for (var col = 0; col < values.length; col++) {
        final cell = cSheet.cell(
            CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 1));
        final val = values[col];
        if (val is double) {
          cell.value = DoubleCellValue(val);
        } else {
          cell.value = TextCellValue(val.toString());
        }
      }
    }

    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/Outstanding_Summary_${DateTime.now().millisecondsSinceEpoch}.xlsx');
    final bytes = excel.save();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file;
  }

  static Future<File> exportWallets({
    required List<WalletAccountEntity> wallets,
    required AppLocalizations l10n,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel[l10n.walletAccounts];
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    final headers = [
      l10n.walletName,
      l10n.initialBalance,
      l10n.currentBalance,
      l10n.enableOverdraft
    ];
    for (var col = 0; col < headers.length; col++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 0))
          .value = TextCellValue(headers[col]);
    }

    for (var row = 0; row < wallets.length; row++) {
      final w = wallets[row];
      final values = [
        w.name,
        w.openingBalance,
        w.currentBalance,
        w.overdraftEnabled ? l10n.enabled : l10n.disabled
      ];
      for (var col = 0; col < values.length; col++) {
        final cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 1));
        final val = values[col];
        if (val is double) {
          cell.value = DoubleCellValue(val);
        } else {
          cell.value = TextCellValue(val.toString());
        }
      }
    }

    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/Wallet_Summary_${DateTime.now().millisecondsSinceEpoch}.xlsx');
    final bytes = excel.save();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file;
  }

  static Future<File> exportProfitLoss({
    required double totalSales,
    required double totalPurchases,
    required AppLocalizations l10n,
    DateTime? from,
    DateTime? to,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel[l10n.financialReports];
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value =
        TextCellValue(l10n.financialReports);

    final rangeText = (from != null && to != null)
        ? '${from.day}/${from.month}/${from.year} to ${to.day}/${to.month}/${to.year}'
        : l10n.allTypes;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1)).value =
        TextCellValue('${l10n.dateRange}: $rangeText');

    final rows = [
      [l10n.income, ''],
      ['${l10n.totalSales} (${l10n.operatingIncome})', totalSales],
      ['', ''],
      ['${l10n.expense} (${l10n.costOfSales})', ''],
      ['${l10n.totalPurchases} (${l10n.expense})', totalPurchases],
      ['', ''],
      [l10n.summary, ''],
      ['${l10n.netProfit} / (${l10n.netLoss})', totalSales - totalPurchases],
    ];

    for (var r = 0; r < rows.length; r++) {
      final label = rows[r][0] as String;
      final val = rows[r][1];

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: r + 3))
          .value = TextCellValue(label);
      if (val is double) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: r + 3))
            .value = DoubleCellValue(val);
      } else if (val is String && val.isNotEmpty) {
        sheet
            .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: r + 3))
            .value = TextCellValue(val);
      }
    }

    final output = await getTemporaryDirectory();
    final file = File(
        '${output.path}/Profit_Loss_${DateTime.now().millisecondsSinceEpoch}.xlsx');
    final bytes = excel.save();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file;
  }
}
