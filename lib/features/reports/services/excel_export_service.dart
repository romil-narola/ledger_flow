import 'dart:io';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../core/core.dart';
import '../../wallet/wallet.dart';
import '../../supplier/supplier.dart';
import '../../customer/customer.dart';
import '../../expenses/expenses.dart';
import '../../ledger/ledger.dart';
import '../../../l10n/app_localizations.dart';

class ExcelExportService {
  static Future<File> exportLedger({
    required List<LedgerEntryEntity> entries,
    required String sheetName,
    required AppLocalizations l10n,
    double? openingBalance,
    double? totalAvailableBalance,
    double? totalSales,
    double? totalPurchases,
    double? customerPayouts,
    double? supplierPayouts,
    double? personalExpenses,
    double? businessExpenses,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel[sheetName];
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    int startRow = 0;
    if (openingBalance != null) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startRow))
          .value = TextCellValue(l10n.openingBalance);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: startRow))
          .value = DoubleCellValue(openingBalance);
      startRow++;
    }
    if (totalAvailableBalance != null) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startRow))
          .value = TextCellValue(l10n.totalAvailableBalance);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: startRow))
          .value = DoubleCellValue(totalAvailableBalance);
      startRow++;
    }
    if (totalSales != null && totalSales > 0) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startRow))
          .value = TextCellValue(l10n.totalSales);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: startRow))
          .value = DoubleCellValue(totalSales);
      startRow++;
    }
    if (totalPurchases != null && totalPurchases > 0) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startRow))
          .value = TextCellValue(l10n.totalPurchases);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: startRow))
          .value = DoubleCellValue(totalPurchases);
      startRow++;
    }
    if (customerPayouts != null && customerPayouts > 0) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startRow))
          .value = TextCellValue(l10n.customerPayouts);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: startRow))
          .value = DoubleCellValue(customerPayouts);
      startRow++;
    }
    if (supplierPayouts != null && supplierPayouts > 0) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startRow))
          .value = TextCellValue(l10n.supplierPayouts);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: startRow))
          .value = DoubleCellValue(supplierPayouts);
      startRow++;
    }
    if (personalExpenses != null && personalExpenses > 0) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startRow))
          .value = TextCellValue('Personal Expenses');
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: startRow))
          .value = DoubleCellValue(personalExpenses);
      startRow++;
    }
    if (businessExpenses != null && businessExpenses > 0) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startRow))
          .value = TextCellValue('Operating Expenses');
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: startRow))
          .value = DoubleCellValue(businessExpenses);
      startRow++;
    }
    startRow++; // Blank separator

    if (entries.isNotEmpty) {
      // Add Headers including Party Name, Mobile Number & Wallet Account
      final headers = [
        l10n.date,
        l10n.referenceNo,
        l10n.transactionType,
        l10n.partyName,
        l10n.phone,
        l10n.walletAccount,
        l10n.description,
        l10n.debit,
        l10n.credit,
        l10n.walletBalanceAfter
      ];
      for (var col = 0; col < headers.length; col++) {
        final cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: col, rowIndex: startRow));
        cell.value = TextCellValue(headers[col]);
      }
      startRow++;

      // Add Row Data
      for (var row = 0; row < entries.length; row++) {
        final entry = entries[row];
        final party = entry.customerName ?? entry.supplierName ?? '-';
        final phone = entry.partyPhone ?? '-';
        final wallet = entry.walletName ?? '-';

        final values = [
          DateFormatter.format(entry.date),
          entry.referenceNumber,
          entry.transactionType.label,
          party,
          phone,
          wallet,
          entry.description,
          entry.debit,
          entry.credit,
          entry.walletBalance,
        ];

        for (var col = 0; col < values.length; col++) {
          final cell = sheet.cell(CellIndex.indexByColumnRow(
              columnIndex: col, rowIndex: startRow));
          final val = values[col];
          if (val is double) {
            cell.value = DoubleCellValue(val);
          } else {
            cell.value = TextCellValue(val.toString());
          }
        }
        startRow++;
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
    double? openingBalance,
    double? totalAvailableBalance,
  }) async {
    final excel = Excel.createExcel();
    final sSheet = excel[l10n.suppliers];
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    int sStartRow = 0;
    if (openingBalance != null || totalAvailableBalance != null) {
      if (openingBalance != null) {
        sSheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: sStartRow))
            .value = TextCellValue(l10n.openingBalance);
        sSheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: sStartRow))
            .value = DoubleCellValue(openingBalance);
        sStartRow++;
      }
      if (totalAvailableBalance != null) {
        sSheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: sStartRow))
            .value = TextCellValue(l10n.totalAvailableBalance);
        sSheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: sStartRow))
            .value = DoubleCellValue(totalAvailableBalance);
        sStartRow++;
      }
      sStartRow++;
    }

    final sHeaders = [
      l10n.supplierName,
      l10n.phone,
      l10n.email,
      l10n.address,
      l10n.totalPurchased,
      l10n.supplierPayouts,
      l10n.outstanding,
      l10n.creditBalance
    ];
    for (var col = 0; col < sHeaders.length; col++) {
      sSheet
          .cell(
              CellIndex.indexByColumnRow(columnIndex: col, rowIndex: sStartRow))
          .value = TextCellValue(sHeaders[col]);
    }
    sStartRow++;

    for (var row = 0; row < suppliers.length; row++) {
      final s = suppliers[row];
      final values = [
        s.name,
        s.phone ?? '-',
        s.email ?? '-',
        s.address ?? '-',
        s.totalPurchases,
        s.totalPayments,
        s.outstanding,
        s.creditBalance
      ];
      for (var col = 0; col < values.length; col++) {
        final cell = sSheet.cell(CellIndex.indexByColumnRow(
            columnIndex: col, rowIndex: sStartRow + row));
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
    int cStartRow = 0;
    if (openingBalance != null || totalAvailableBalance != null) {
      if (openingBalance != null) {
        cSheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: cStartRow))
            .value = TextCellValue(l10n.openingBalance);
        cSheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: cStartRow))
            .value = DoubleCellValue(openingBalance);
        cStartRow++;
      }
      if (totalAvailableBalance != null) {
        cSheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: cStartRow))
            .value = TextCellValue(l10n.totalAvailableBalance);
        cSheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: cStartRow))
            .value = DoubleCellValue(totalAvailableBalance);
        cStartRow++;
      }
      cStartRow++;
    }

    final cHeaders = [
      l10n.customerName,
      l10n.phone,
      l10n.email,
      l10n.address,
      l10n.totalSales,
      l10n.customerPayouts,
      l10n.outstanding,
      l10n.advanceBalance
    ];
    for (var col = 0; col < cHeaders.length; col++) {
      cSheet
          .cell(
              CellIndex.indexByColumnRow(columnIndex: col, rowIndex: cStartRow))
          .value = TextCellValue(cHeaders[col]);
    }
    cStartRow++;

    for (var row = 0; row < customers.length; row++) {
      final c = customers[row];
      final values = [
        c.name,
        c.phone ?? '-',
        c.email ?? '-',
        c.address ?? '-',
        c.totalSales,
        c.totalPayments,
        c.outstanding,
        c.advanceBalance
      ];
      for (var col = 0; col < values.length; col++) {
        final cell = cSheet.cell(CellIndex.indexByColumnRow(
            columnIndex: col, rowIndex: cStartRow + row));
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
    double? openingBalance,
    double? totalAvailableBalance,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel[l10n.walletAccounts];
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    final calcOpening = openingBalance ??
        wallets.fold<double>(0.0, (sum, w) => sum + w.openingBalance);
    final calcAvailable = totalAvailableBalance ??
        wallets.fold<double>(0.0, (sum, w) => sum + w.currentBalance);

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value =
        TextCellValue(l10n.openingBalance);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 0)).value =
        DoubleCellValue(calcOpening);

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1)).value =
        TextCellValue(l10n.totalAvailableBalance);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 1)).value =
        DoubleCellValue(calcAvailable);

    final headers = [
      l10n.walletName,
      l10n.initialBalance,
      l10n.currentBalance,
      l10n.enableOverdraft
    ];
    for (var col = 0; col < headers.length; col++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 3))
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
            CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 4));
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
    double businessExpenses = 0.0,
    double personalExpenses = 0.0,
    DateTime? from,
    DateTime? to,
    double? openingBalance,
    double? totalAvailableBalance,
    double? customerPayouts,
    double? supplierPayouts,
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

    int rowIdx = 2;
    if (openingBalance != null) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIdx))
          .value = TextCellValue(l10n.openingBalance);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIdx))
          .value = DoubleCellValue(openingBalance);
      rowIdx++;
    }
    if (totalAvailableBalance != null) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIdx))
          .value = TextCellValue(l10n.totalAvailableBalance);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIdx))
          .value = DoubleCellValue(totalAvailableBalance);
      rowIdx++;
    }
    if (customerPayouts != null && customerPayouts > 0) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIdx))
          .value = TextCellValue(l10n.customerPayouts);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIdx))
          .value = DoubleCellValue(customerPayouts);
      rowIdx++;
    }
    if (supplierPayouts != null && supplierPayouts > 0) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: rowIdx))
          .value = TextCellValue(l10n.supplierPayouts);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: rowIdx))
          .value = DoubleCellValue(supplierPayouts);
      rowIdx++;
    }
    rowIdx++;

    final grossProfit = totalSales - totalPurchases;
    final netOperating = grossProfit - businessExpenses;
    final netRetained = netOperating - personalExpenses;

    final rows = [
      [l10n.income, ''],
      ['${l10n.totalSales} (${l10n.operatingIncome})', totalSales],
      ['', ''],
      ['${l10n.expense} (${l10n.costOfSales})', ''],
      ['${l10n.totalPurchases} (${l10n.expense})', totalPurchases],
      ['Gross Profit (Sales - Purchases)', grossProfit],
      ['', ''],
      ['OPERATING & PERSONAL EXPENSES', ''],
      ['Business Operating Expenses', businessExpenses],
      ['Net Operating Business Profit', netOperating],
      ['Personal Out-of-Pocket Expenses', personalExpenses],
      ['', ''],
      [l10n.summary, ''],
      ['Net Retained Profit / (Loss)', netRetained],
    ];

    for (var r = 0; r < rows.length; r++) {
      final label = rows[r][0] as String;
      final val = rows[r][1];
      final targetRow = rowIdx + r;

      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: targetRow))
          .value = TextCellValue(label);
      if (val is double) {
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: targetRow))
            .value = DoubleCellValue(val);
      } else if (val is String && val.isNotEmpty) {
        sheet
            .cell(
                CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: targetRow))
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

  static Future<File> exportCustomerLedger({
    required CustomerEntity customer,
    required List<CustomerLedgerEntry> entries,
    required AppLocalizations l10n,
    double? totalAvailableBalance,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Customer_${customer.name}'];
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    // Customer Profile Details
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value =
        TextCellValue('${l10n.customer}: ${customer.name}');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1)).value =
        TextCellValue(
            '${l10n.phone}: ${customer.phone ?? '-'} | ${l10n.email}: ${customer.email ?? '-'} | ${l10n.address}: ${customer.address ?? '-'}');
    if (customer.notes != null && customer.notes!.trim().isNotEmpty) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 2))
          .value = TextCellValue('${l10n.notes}: ${customer.notes}');
    }

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 3)).value =
        TextCellValue(l10n.openingBalance);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 3)).value =
        DoubleCellValue(
            customer.advanceBalance > 0 ? customer.advanceBalance : 0.0);

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 4)).value =
        TextCellValue(l10n.totalAvailableBalance);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 4)).value =
        DoubleCellValue(totalAvailableBalance ?? 0.0);

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 5)).value =
        TextCellValue(l10n.totalSales);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 5)).value =
        DoubleCellValue(customer.totalSales);

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 6)).value =
        TextCellValue(l10n.customerPayouts);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 6)).value =
        DoubleCellValue(customer.totalPayments);

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 7)).value =
        TextCellValue(l10n.outstanding);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 7)).value =
        DoubleCellValue(customer.outstanding);

    final headers = [
      l10n.date,
      l10n.referenceNo,
      l10n.transactionType,
      l10n.partyName,
      l10n.phone,
      l10n.description,
      l10n.debit,
      l10n.credit,
      l10n.balance
    ];
    for (var col = 0; col < headers.length; col++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 9))
          .value = TextCellValue(headers[col]);
    }

    for (var row = 0; row < entries.length; row++) {
      final e = entries[row];
      final values = [
        DateFormatter.format(e.date),
        e.referenceNumber,
        e.transactionType,
        customer.name,
        customer.phone ?? '-',
        e.description,
        e.debit,
        e.credit,
        e.balance
      ];
      for (var col = 0; col < values.length; col++) {
        final cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 10));
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
        '${output.path}/Customer_${customer.name}_${DateTime.now().millisecondsSinceEpoch}.xlsx');
    final bytes = excel.save();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file;
  }

  static Future<File> exportSupplierLedger({
    required SupplierEntity supplier,
    required List<SupplierLedgerEntry> entries,
    required AppLocalizations l10n,
    double? totalAvailableBalance,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel['Supplier_${supplier.name}'];
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    // Supplier Profile Details
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 0)).value =
        TextCellValue('${l10n.supplier}: ${supplier.name}');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 1)).value =
        TextCellValue(
            '${l10n.phone}: ${supplier.phone ?? '-'} | ${l10n.email}: ${supplier.email ?? '-'} | ${l10n.address}: ${supplier.address ?? '-'}');
    if (supplier.notes != null && supplier.notes!.trim().isNotEmpty) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 2))
          .value = TextCellValue('${l10n.notes}: ${supplier.notes}');
    }

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 3)).value =
        TextCellValue(l10n.openingBalance);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 3)).value =
        DoubleCellValue(
            supplier.creditBalance > 0 ? supplier.creditBalance : 0.0);

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 4)).value =
        TextCellValue(l10n.totalAvailableBalance);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 4)).value =
        DoubleCellValue(totalAvailableBalance ?? 0.0);

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 5)).value =
        TextCellValue(l10n.totalPurchases);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 5)).value =
        DoubleCellValue(supplier.totalPurchases);

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 6)).value =
        TextCellValue(l10n.supplierPayouts);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 6)).value =
        DoubleCellValue(supplier.totalPayments);

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: 7)).value =
        TextCellValue(l10n.outstanding);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: 7)).value =
        DoubleCellValue(supplier.outstanding);

    final sHeaders = [
      l10n.date,
      l10n.referenceNo,
      l10n.transactionType,
      l10n.partyName,
      l10n.phone,
      l10n.description,
      l10n.debit,
      l10n.credit,
      l10n.balance
    ];
    for (var col = 0; col < sHeaders.length; col++) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: 9))
          .value = TextCellValue(sHeaders[col]);
    }

    for (var row = 0; row < entries.length; row++) {
      final e = entries[row];
      final values = [
        DateFormatter.format(e.date),
        e.referenceNumber,
        e.transactionType,
        supplier.name,
        supplier.phone ?? '-',
        e.description,
        e.debit,
        e.credit,
        e.balance
      ];
      for (var col = 0; col < values.length; col++) {
        final cell = sheet.cell(
            CellIndex.indexByColumnRow(columnIndex: col, rowIndex: row + 10));
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
        '${output.path}/Supplier_${supplier.name}_${DateTime.now().millisecondsSinceEpoch}.xlsx');
    final bytes = excel.save();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file;
  }

  static Future<File> exportSalesReport({
    required List<SaleEntity> sales,
    required Map<int, String?> customerPhones,
    Map<int, String?>? customerNames,
    required AppLocalizations l10n,
    double? openingBalance,
    double? totalAvailableBalance,
    double? customerPayouts,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel[l10n.salesReport];
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    final totalSales = sales.fold(0.0, (sum, s) => sum + s.amount);

    int startRow = 0;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startRow))
        .value = TextCellValue(l10n.totalSales);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: startRow))
        .value = DoubleCellValue(totalSales);
    startRow++;

    if (customerPayouts != null && customerPayouts > 0) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startRow))
          .value = TextCellValue(l10n.customerPayouts);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: startRow))
          .value = DoubleCellValue(customerPayouts);
      startRow++;
    }
    startRow++;

    final headers = [
      l10n.date,
      l10n.referenceNo,
      l10n.customerName,
      l10n.phone,
      l10n.description,
      l10n.amount
    ];
    for (var col = 0; col < headers.length; col++) {
      sheet
          .cell(
              CellIndex.indexByColumnRow(columnIndex: col, rowIndex: startRow))
          .value = TextCellValue(headers[col]);
    }
    startRow++;

    for (var row = 0; row < sales.length; row++) {
      final s = sales[row];
      final name = s.customerName.trim().isNotEmpty
          ? s.customerName
          : (customerNames?[s.customerId] ?? '-');
      final phone = customerPhones[s.customerId] ?? '-';
      final values = [
        DateFormatter.format(s.date),
        s.referenceNumber,
        name,
        phone,
        s.notes ?? '-',
        s.amount
      ];
      for (var col = 0; col < values.length; col++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(
            columnIndex: col, rowIndex: startRow + row));
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
        '${output.path}/Sales_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx');
    final bytes = excel.save();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file;
  }

  static Future<File> exportPurchaseReport({
    required List<PurchaseEntity> purchases,
    required Map<int, String?> supplierPhones,
    Map<int, String?>? supplierNames,
    required AppLocalizations l10n,
    double? openingBalance,
    double? totalAvailableBalance,
    double? supplierPayouts,
  }) async {
    final excel = Excel.createExcel();
    final sheet = excel[l10n.purchaseReport];
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

    final totalPurchases = purchases.fold(0.0, (sum, p) => sum + p.amount);

    int startRow = 0;
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startRow))
        .value = TextCellValue(l10n.totalPurchases);
    sheet
        .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: startRow))
        .value = DoubleCellValue(totalPurchases);
    startRow++;

    if (supplierPayouts != null && supplierPayouts > 0) {
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startRow))
          .value = TextCellValue(l10n.supplierPayouts);
      sheet
          .cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: startRow))
          .value = DoubleCellValue(supplierPayouts);
      startRow++;
    }
    startRow++;

    final headers = [
      l10n.date,
      l10n.referenceNo,
      l10n.supplierName,
      l10n.phone,
      l10n.walletAccount,
      l10n.description,
      l10n.amount
    ];
    for (var col = 0; col < headers.length; col++) {
      sheet
          .cell(
              CellIndex.indexByColumnRow(columnIndex: col, rowIndex: startRow))
          .value = TextCellValue(headers[col]);
    }
    startRow++;

    for (var row = 0; row < purchases.length; row++) {
      final p = purchases[row];
      final name = p.supplierName.trim().isNotEmpty
          ? p.supplierName
          : (supplierNames?[p.supplierId] ?? '-');
      final phone = supplierPhones[p.supplierId] ?? '-';
      final values = [
        DateFormatter.format(p.date),
        p.referenceNumber,
        name,
        phone,
        p.walletName.isNotEmpty ? p.walletName : '-',
        p.notes ?? '-',
        p.amount
      ];
      for (var col = 0; col < values.length; col++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(
            columnIndex: col, rowIndex: startRow + row));
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
        '${output.path}/Purchase_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx');
    final bytes = excel.save();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file;
  }

  static Future<File> exportExpenseReport({
    required List<ExpenseEntity> expenses,
    required AppLocalizations l10n,
    double? openingBalance,
    double? totalAvailableBalance,
  }) async {
    final excel = Excel.createExcel();
    final sheetName = '${l10n.expenses}_${l10n.reports}';
    final sheet = excel[sheetName];
    if (excel.sheets.containsKey('Sheet1')) {
      excel.delete('Sheet1');
    }

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
    for (final e in expenses) {
      final isPersonal = personalCategories
          .any((p) => e.categoryName.toLowerCase().contains(p));
      if (isPersonal) {
        personalTotal += e.amount;
      } else {
        businessTotal += e.amount;
      }
    }

    final totalExpenses = expenses.fold(0.0, (sum, e) => sum + e.amount);

    int startRow = 0;
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startRow)).value =
        TextCellValue(l10n.totalExpenses);
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: startRow)).value =
        DoubleCellValue(totalExpenses);
    startRow++;

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startRow)).value =
        TextCellValue('Personal Expenses');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: startRow)).value =
        DoubleCellValue(personalTotal);
    startRow++;

    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startRow)).value =
        TextCellValue('Business Expenses');
    sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: startRow)).value =
        DoubleCellValue(businessTotal);
    startRow++;

    if (openingBalance != null) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startRow)).value =
          TextCellValue(l10n.openingBalance);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: startRow)).value =
          DoubleCellValue(openingBalance);
      startRow++;
    }
    if (totalAvailableBalance != null) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: startRow)).value =
          TextCellValue(l10n.totalAvailableBalance);
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: startRow)).value =
          DoubleCellValue(totalAvailableBalance);
      startRow++;
    }
    startRow++;

    final headers = [
      l10n.date,
      l10n.referenceNo,
      'Type',
      l10n.category,
      l10n.walletAccount,
      l10n.description,
      l10n.amount
    ];
    for (var col = 0; col < headers.length; col++) {
      sheet.cell(CellIndex.indexByColumnRow(columnIndex: col, rowIndex: startRow)).value =
          TextCellValue(headers[col]);
    }
    startRow++;

    for (var row = 0; row < expenses.length; row++) {
      final e = expenses[row];
      final isPersonal = personalCategories
          .any((p) => e.categoryName.toLowerCase().contains(p));
      final values = [
        DateFormatter.format(e.date),
        e.referenceNumber,
        isPersonal ? 'Personal' : 'Business',
        e.categoryName,
        e.walletName ?? '-',
        e.description,
        e.amount
      ];
      for (var col = 0; col < values.length; col++) {
        final cell = sheet.cell(CellIndex.indexByColumnRow(
            columnIndex: col, rowIndex: startRow + row));
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
        '${output.path}/Expense_Report_${DateTime.now().millisecondsSinceEpoch}.xlsx');
    final bytes = excel.save();
    if (bytes != null) {
      await file.writeAsBytes(bytes);
    }
    return file;
  }
}
