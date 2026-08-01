import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/core.dart';
import '../../../customer/customer.dart';
import '../../../supplier/supplier.dart';
import '../../../wallet/wallet.dart';
import '../../../ledger/ledger.dart';
import '../../services/pdf_export_service.dart';
import '../../services/excel_export_service.dart';

class ReportsScreen extends StatefulWidget {
  const ReportsScreen({super.key});

  @override
  State<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends State<ReportsScreen> {
  ReportType _selectedReportType = ReportType.ledgerReport;
  ExportFormat _selectedFormat = ExportFormat.pdf;
  DateTime? _fromDate;
  DateTime? _toDate;
  bool _isExporting = false;

  CustomerEntity? _selectedCustomer;
  SupplierEntity? _selectedSupplier;
  WalletAccountEntity? _selectedWallet;

  List<CustomerEntity> _customers = [];
  List<SupplierEntity> _suppliers = [];
  List<WalletAccountEntity> _wallets = [];

  final List<ReportType> _reportTypes = ReportType.values;

  @override
  void initState() {
    super.initState();
    _loadEntities();
  }

  Future<void> _loadEntities() async {
    try {
      final customerRepo = sl<CustomerRepository>();
      final supplierRepo = sl<SupplierRepository>();
      final walletRepo = sl<WalletRepository>();

      final customers = await customerRepo.getCustomers();
      final suppliers = await supplierRepo.getSuppliers();
      final wallets = await walletRepo.getWallets();

      setState(() {
        _customers = customers;
        _suppliers = suppliers;
        _wallets = wallets;
      });
    } catch (_) {}
  }

  Future<void> _exportReport({required bool saveLocally}) async {
    final l10n = context.l10n;
    final dateSubtitle = _getDateSubtitle(context);
    final reportTitle = _selectedReportType.getLocalizedLabel(context);
    final shareText = '${l10n.exported} $reportTitle';
    setState(() => _isExporting = true);

    try {
      final walletRepo = sl<WalletRepository>();
      final supplierRepo = sl<SupplierRepository>();
      final customerRepo = sl<CustomerRepository>();
      final ledgerRepo = sl<LedgerRepository>();

      final allWallets = await walletRepo.getWallets();
      final totalAvailableBalance = await walletRepo.getTotalBalance();
      final openingBalance =
          allWallets.fold(0.0, (sum, w) => sum + w.openingBalance);

      final salesList =
          await customerRepo.getAllSales(from: _fromDate, to: _toDate);
      final purchasesList =
          await supplierRepo.getAllPurchases(from: _fromDate, to: _toDate);
      final cPaymentsList =
          await customerRepo.getAllPayments(from: _fromDate, to: _toDate);
      final sPaymentsList =
          await supplierRepo.getAllPayments(from: _fromDate, to: _toDate);

      final totalSalesVal = salesList.fold(0.0, (sum, s) => sum + s.amount);
      final totalPurchasesVal =
          purchasesList.fold(0.0, (sum, p) => sum + p.amount);
      final customerPayoutsVal =
          cPaymentsList.fold(0.0, (sum, p) => sum + p.amount);
      final supplierPayoutsVal =
          sPaymentsList.fold(0.0, (sum, p) => sum + p.amount);

      dynamic file;

      switch (_selectedReportType) {
        case ReportType.ledgerReport:
          final entries = await ledgerRepo.getEntries(
              from: _fromDate, to: _toDate, limit: 1000);
          if (_selectedFormat == ExportFormat.pdf) {
            file = await PdfExportService.generateLedgerReport(
              entries: entries,
              title: l10n.generalLedgerReport,
              subtitle: dateSubtitle,
              l10n: l10n,
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
              totalSales: totalSalesVal,
              totalPurchases: totalPurchasesVal,
              customerPayouts: customerPayoutsVal,
              supplierPayouts: supplierPayoutsVal,
            );
          } else {
            file = await ExcelExportService.exportLedger(
              entries: entries,
              sheetName: l10n.ledger,
              l10n: l10n,
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
              totalSales: totalSalesVal,
              totalPurchases: totalPurchasesVal,
              customerPayouts: customerPayoutsVal,
              supplierPayouts: supplierPayoutsVal,
            );
          }
          break;

        case ReportType.supplierOutstanding:
          if (_selectedSupplier != null) {
            // Detailed Supplier Report
            final entries =
                await supplierRepo.getSupplierLedger(_selectedSupplier!.id);
            if (_selectedFormat == ExportFormat.pdf) {
              file = await PdfExportService.generateSupplierLedgerReport(
                supplier: _selectedSupplier!,
                entries: entries,
                l10n: l10n,
                totalAvailableBalance: totalAvailableBalance,
              );
            } else {
              file = await ExcelExportService.exportSupplierLedger(
                supplier: _selectedSupplier!,
                entries: entries,
                l10n: l10n,
                totalAvailableBalance: totalAvailableBalance,
              );
            }
          } else {
            final suppliers = await supplierRepo.getSuppliersWithOutstanding();
            if (_selectedFormat == ExportFormat.pdf) {
              file = await PdfExportService.generateOutstandingReport(
                suppliers: suppliers,
                customers: [],
                l10n: l10n,
                openingBalance: openingBalance,
                totalAvailableBalance: totalAvailableBalance,
              );
            } else {
              file = await ExcelExportService.exportOutstanding(
                suppliers: suppliers,
                customers: [],
                l10n: l10n,
                openingBalance: openingBalance,
                totalAvailableBalance: totalAvailableBalance,
              );
            }
          }
          break;

        case ReportType.supplierCredit:
          final suppliers = await supplierRepo.getSuppliersWithCredit();
          if (_selectedFormat == ExportFormat.pdf) {
            file = await PdfExportService.generateOutstandingReport(
              suppliers: suppliers,
              customers: [],
              l10n: l10n,
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
            );
          } else {
            file = await ExcelExportService.exportOutstanding(
              suppliers: suppliers,
              customers: [],
              l10n: l10n,
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
            );
          }
          break;

        case ReportType.customerOutstanding:
          if (_selectedCustomer != null) {
            // Detailed Customer Report
            final entries =
                await customerRepo.getCustomerLedger(_selectedCustomer!.id);
            if (_selectedFormat == ExportFormat.pdf) {
              file = await PdfExportService.generateCustomerLedgerReport(
                customer: _selectedCustomer!,
                entries: entries,
                l10n: l10n,
                totalAvailableBalance: totalAvailableBalance,
              );
            } else {
              file = await ExcelExportService.exportCustomerLedger(
                customer: _selectedCustomer!,
                entries: entries,
                l10n: l10n,
                totalAvailableBalance: totalAvailableBalance,
              );
            }
          } else {
            final customers = await customerRepo.getCustomersWithOutstanding();
            if (_selectedFormat == ExportFormat.pdf) {
              file = await PdfExportService.generateOutstandingReport(
                suppliers: [],
                customers: customers,
                l10n: l10n,
                openingBalance: openingBalance,
                totalAvailableBalance: totalAvailableBalance,
              );
            } else {
              file = await ExcelExportService.exportOutstanding(
                suppliers: [],
                customers: customers,
                l10n: l10n,
                openingBalance: openingBalance,
                totalAvailableBalance: totalAvailableBalance,
              );
            }
          }
          break;

        case ReportType.customerAdvance:
          final customers = await customerRepo.getCustomersWithAdvance();
          if (_selectedFormat == ExportFormat.pdf) {
            file = await PdfExportService.generateOutstandingReport(
              suppliers: [],
              customers: customers,
              l10n: l10n,
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
            );
          } else {
            file = await ExcelExportService.exportOutstanding(
              suppliers: [],
              customers: customers,
              l10n: l10n,
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
            );
          }
          break;

        case ReportType.walletReport:
          if (_selectedWallet != null) {
            // Detailed Wallet Report
            final history = await walletRepo.getWalletHistory(
                walletId: _selectedWallet!.id);
            if (_selectedFormat == ExportFormat.pdf) {
              file = await PdfExportService.generateSingleWalletReport(
                wallet: _selectedWallet!,
                transactions: history,
                l10n: l10n,
                totalAvailableBalance: totalAvailableBalance,
              );
            } else {
              final entries = history
                  .map((h) => LedgerEntryEntity(
                        id: h.id,
                        referenceNumber: h.referenceNumber,
                        transactionType: TransactionType.walletAdjustment,
                        debit: h.debit,
                        credit: h.credit,
                        walletBalance: h.balance,
                        description: h.description,
                        date: h.date,
                        createdAt: h.date,
                      ))
                  .toList();
              file = await ExcelExportService.exportLedger(
                entries: entries,
                sheetName: _selectedWallet!.name,
                l10n: l10n,
                openingBalance: _selectedWallet!.openingBalance,
                totalAvailableBalance: _selectedWallet!.currentBalance,
              );
            }
          } else {
            if (_selectedFormat == ExportFormat.pdf) {
              file = await PdfExportService.generateWalletReport(
                wallets: allWallets,
                l10n: l10n,
                openingBalance: openingBalance,
                totalAvailableBalance: totalAvailableBalance,
              );
            } else {
              file = await ExcelExportService.exportWallets(
                wallets: allWallets,
                l10n: l10n,
                openingBalance: openingBalance,
                totalAvailableBalance: totalAvailableBalance,
              );
            }
          }
          break;

        case ReportType.purchaseReport:
          final purchases =
              await supplierRepo.getAllPurchases(from: _fromDate, to: _toDate);
          final supplierPhoneMap = {for (var s in _suppliers) s.id: s.phone};
          final supplierNameMap = {for (var s in _suppliers) s.id: s.name};

          if (_selectedFormat == ExportFormat.pdf) {
            file = await PdfExportService.generatePurchaseReport(
              purchases: purchases,
              supplierPhones: supplierPhoneMap,
              supplierNames: supplierNameMap,
              subtitle: dateSubtitle,
              l10n: l10n,
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
              supplierPayouts: supplierPayoutsVal,
            );
          } else {
            file = await ExcelExportService.exportPurchaseReport(
              purchases: purchases,
              supplierPhones: supplierPhoneMap,
              supplierNames: supplierNameMap,
              l10n: l10n,
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
              supplierPayouts: supplierPayoutsVal,
            );
          }
          break;

        case ReportType.salesReport:
          final sales =
              await customerRepo.getAllSales(from: _fromDate, to: _toDate);
          final customerPhoneMap = {for (var c in _customers) c.id: c.phone};
          final customerNameMap = {for (var c in _customers) c.id: c.name};

          if (_selectedFormat == ExportFormat.pdf) {
            file = await PdfExportService.generateSalesReport(
              sales: sales,
              customerPhones: customerPhoneMap,
              customerNames: customerNameMap,
              subtitle: dateSubtitle,
              l10n: l10n,
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
              customerPayouts: customerPayoutsVal,
            );
          } else {
            file = await ExcelExportService.exportSalesReport(
              sales: sales,
              customerPhones: customerPhoneMap,
              customerNames: customerNameMap,
              l10n: l10n,
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
              customerPayouts: customerPayoutsVal,
            );
          }
          break;

        case ReportType.paymentReport:
          final sPayments =
              await supplierRepo.getAllPayments(from: _fromDate, to: _toDate);
          final cPayments =
              await customerRepo.getAllPayments(from: _fromDate, to: _toDate);
          final sPhoneMap = {for (var s in _suppliers) s.id: s.phone};
          final cPhoneMap = {for (var c in _customers) c.id: c.phone};

          final List<LedgerEntryEntity> entries = [
            ...sPayments.map((p) => LedgerEntryEntity(
                  id: p.id,
                  referenceNumber: p.referenceNumber,
                  transactionType: TransactionType.supplierPayment,
                  supplierId: p.supplierId,
                  supplierName: p.supplierName,
                  supplierPhone: sPhoneMap[p.supplierId],
                  debit: p.amount,
                  credit: 0.0,
                  walletBalance: 0.0,
                  description: '${l10n.supplierPayment} (${p.supplierName})',
                  date: p.date,
                  createdAt: p.createdAt,
                )),
            ...cPayments.map((p) => LedgerEntryEntity(
                  id: p.id,
                  referenceNumber: p.referenceNumber,
                  transactionType: TransactionType.customerPayment,
                  customerId: p.customerId,
                  customerName: p.customerName,
                  customerPhone: cPhoneMap[p.customerId],
                  debit: 0.0,
                  credit: p.amount,
                  walletBalance: 0.0,
                  description: '${l10n.customerPayment} (${p.customerName})',
                  date: p.date,
                  createdAt: p.createdAt,
                )),
          ]..sort((a, b) => b.date.compareTo(a.date));

          if (_selectedFormat == ExportFormat.pdf) {
            file = await PdfExportService.generateLedgerReport(
              entries: entries,
              title: l10n.paymentsReport,
              subtitle: dateSubtitle,
              l10n: l10n,
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
              customerPayouts: customerPayoutsVal,
              supplierPayouts: supplierPayoutsVal,
            );
          } else {
            file = await ExcelExportService.exportLedger(
              entries: entries,
              sheetName: l10n.paymentsReport,
              l10n: l10n,
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
              customerPayouts: customerPayoutsVal,
              supplierPayouts: supplierPayoutsVal,
            );
          }
          break;

        case ReportType.monthlyReport:
          final entries = await ledgerRepo.getEntries(
            from: DateTime.now().subtract(const Duration(days: 30)),
            to: DateTime.now(),
            limit: 1000,
          );
          if (_selectedFormat == ExportFormat.pdf) {
            file = await PdfExportService.generateLedgerReport(
              entries: entries,
              title: l10n.monthlySummaryReport,
              subtitle: l10n.last30Days,
              l10n: l10n,
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
              totalSales: totalSalesVal,
              totalPurchases: totalPurchasesVal,
              customerPayouts: customerPayoutsVal,
              supplierPayouts: supplierPayoutsVal,
            );
          } else {
            file = await ExcelExportService.exportLedger(
              entries: entries,
              sheetName: l10n.monthlySummaryReport,
              l10n: l10n,
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
              totalSales: totalSalesVal,
              totalPurchases: totalPurchasesVal,
              customerPayouts: customerPayoutsVal,
              supplierPayouts: supplierPayoutsVal,
            );
          }
          break;

        case ReportType.profitLossStatement:
          final purchases =
              await supplierRepo.getAllPurchases(from: _fromDate, to: _toDate);
          final sales =
              await customerRepo.getAllSales(from: _fromDate, to: _toDate);

          final double totalPurchases =
              purchases.fold(0.0, (sum, p) => sum + p.amount);
          final double totalSales = sales.fold(0.0, (sum, s) => sum + s.amount);

          if (_selectedFormat == ExportFormat.pdf) {
            file = await PdfExportService.generateProfitLossReport(
              totalSales: totalSales,
              totalPurchases: totalPurchases,
              from: _fromDate,
              to: _toDate,
              l10n: l10n,
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
              customerPayouts: customerPayoutsVal,
              supplierPayouts: supplierPayoutsVal,
            );
          } else {
            file = await ExcelExportService.exportProfitLoss(
              totalSales: totalSales,
              totalPurchases: totalPurchases,
              from: _fromDate,
              to: _toDate,
              l10n: l10n,
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
              customerPayouts: customerPayoutsVal,
              supplierPayouts: supplierPayoutsVal,
            );
          }
          break;
      }

      if (file != null) {
        if (saveLocally) {
          final ext = _selectedFormat == ExportFormat.pdf ? 'pdf' : 'xlsx';
          final name =
              '${_selectedReportType.name}_report_${DateTime.now().millisecondsSinceEpoch}.$ext';

          Directory? targetDir;
          if (Platform.isAndroid) {
            targetDir = Directory('/storage/emulated/0/Download');
            if (!await targetDir.exists()) {
              targetDir = await getDownloadsDirectory();
            }
          } else {
            targetDir = await getApplicationDocumentsDirectory();
          }

          if (targetDir != null) {
            final targetPath = '${targetDir.path}/$name';
            final localFile = File(targetPath);
            await file.copy(localFile.path);

            if (mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${l10n.reportSavedTo}: ${localFile.path}'),
                  backgroundColor: AppColors.success,
                  duration: const Duration(seconds: 5),
                ),
              );
            }
          } else {
            throw Exception('Could not locate local storage directory');
          }
        } else {
          final xFile = XFile(file.path);
          await Share.shareXFiles([xFile], text: shareText);
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text('${l10n.exportFailed}: ${e.toString()}'),
              backgroundColor: AppColors.error),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isExporting = false);
      }
    }
  }

  String _getDateSubtitle(BuildContext context) {
    if (_fromDate != null && _toDate != null) {
      return '${context.l10n.dateRange}: ${DateFormatter.format(_fromDate!)} - ${DateFormatter.format(_toDate!)}';
    } else if (_fromDate != null) {
      return '${context.l10n.fromDate}: ${DateFormatter.format(_fromDate!)}';
    } else if (_toDate != null) {
      return '${context.l10n.toDate}: ${DateFormatter.format(_toDate!)}';
    }
    return context.l10n.allTypes;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.exportReports),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const LanguageSelectorDialog(),
            ),
            icon: const Icon(Icons.language),
            tooltip: context.l10n.language,
          ),
        ],
      ),
      body: _isExporting
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 16),
                  Text(context.l10n.generatingReportWait,
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            )
          : ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Info Banner
                Card(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        const Icon(Icons.analytics_outlined,
                            color: AppColors.primary, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                context.l10n.businessAnalyticsHeader,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall
                                    ?.copyWith(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                context.l10n.businessAnalyticsDesc,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Report Type Selector
                Text(context.l10n.selectReportType,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                DropdownButtonFormField<ReportType>(
                  initialValue: _selectedReportType,
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.description_outlined),
                  ),
                  items: _reportTypes.map((type) {
                    return DropdownMenuItem(
                      value: type,
                      child: Text(type.getLocalizedLabel(context)),
                    );
                  }).toList(),
                  onChanged: (val) {
                    if (val != null) {
                      setState(() {
                        _selectedReportType = val;
                        _selectedCustomer = null;
                        _selectedSupplier = null;
                        _selectedWallet = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),

                // Optional Customer Selector
                if (_selectedReportType == ReportType.customerOutstanding &&
                    _customers.isNotEmpty) ...[
                  Text(context.l10n.customer,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<CustomerEntity?>(
                    initialValue: _selectedCustomer,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.person_outlined),
                      hintText: context.l10n.allTypes,
                    ),
                    items: [
                      DropdownMenuItem<CustomerEntity?>(
                        value: null,
                        child: Text(
                            '${context.l10n.allTypes} (${context.l10n.customers})'),
                      ),
                      ..._customers.map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c.name),
                          )),
                    ],
                    onChanged: (val) => setState(() => _selectedCustomer = val),
                  ),
                  const SizedBox(height: 16),
                ],

                // Optional Supplier Selector
                if (_selectedReportType == ReportType.supplierOutstanding &&
                    _suppliers.isNotEmpty) ...[
                  Text(context.l10n.supplier,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<SupplierEntity?>(
                    initialValue: _selectedSupplier,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.storefront_outlined),
                      hintText: context.l10n.allTypes,
                    ),
                    items: [
                      DropdownMenuItem<SupplierEntity?>(
                        value: null,
                        child: Text(
                            '${context.l10n.allTypes} (${context.l10n.suppliers})'),
                      ),
                      ..._suppliers.map((s) => DropdownMenuItem(
                            value: s,
                            child: Text(s.name),
                          )),
                    ],
                    onChanged: (val) => setState(() => _selectedSupplier = val),
                  ),
                  const SizedBox(height: 16),
                ],

                // Optional Wallet Selector
                if (_selectedReportType == ReportType.walletReport &&
                    _wallets.isNotEmpty) ...[
                  Text(context.l10n.wallets,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<WalletAccountEntity?>(
                    initialValue: _selectedWallet,
                    decoration: InputDecoration(
                      prefixIcon:
                          const Icon(Icons.account_balance_wallet_outlined),
                      hintText: context.l10n.allTypes,
                    ),
                    items: [
                      DropdownMenuItem<WalletAccountEntity?>(
                        value: null,
                        child: Text(
                            '${context.l10n.allTypes} (${context.l10n.wallets})'),
                      ),
                      ..._wallets.map((w) => DropdownMenuItem(
                            value: w,
                            child: Text(w.name),
                          )),
                    ],
                    onChanged: (val) => setState(() => _selectedWallet = val),
                  ),
                  const SizedBox(height: 16),
                ],

                // Format Selector
                Text(context.l10n.selectFormat,
                    style: Theme.of(context)
                        .textTheme
                        .titleSmall
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ChoiceChip(
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.picture_as_pdf,
                              size: 16,
                              color: _selectedFormat == ExportFormat.pdf
                                  ? Colors.white
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              context.l10n.pdfDocument,
                              style: TextStyle(
                                color: _selectedFormat == ExportFormat.pdf
                                    ? Colors.white
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                fontWeight: _selectedFormat == ExportFormat.pdf
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        selected: _selectedFormat == ExportFormat.pdf,
                        selectedColor: AppColors.primary,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedFormat = ExportFormat.pdf);
                          }
                        },
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ChoiceChip(
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.grid_on,
                              size: 16,
                              color: _selectedFormat == ExportFormat.excel
                                  ? Colors.white
                                  : Theme.of(context)
                                      .colorScheme
                                      .onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              context.l10n.excelSheet,
                              style: TextStyle(
                                color: _selectedFormat == ExportFormat.excel
                                    ? Colors.white
                                    : Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                fontWeight:
                                    _selectedFormat == ExportFormat.excel
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                              ),
                            ),
                          ],
                        ),
                        selected: _selectedFormat == ExportFormat.excel,
                        selectedColor: AppColors.primary,
                        backgroundColor: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        onSelected: (selected) {
                          if (selected) {
                            setState(
                                () => _selectedFormat = ExportFormat.excel);
                          }
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),

                // Date Filters (If applicable)
                if (_requiresDateFilters()) ...[
                  Text(context.l10n.dateRangeOptional,
                      style: Theme.of(context)
                          .textTheme
                          .titleSmall
                          ?.copyWith(fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _fromDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) setState(() => _fromDate = date);
                          },
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: Text(_fromDate == null
                              ? context.l10n.fromDate
                              : DateFormatter.format(_fromDate!)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: _toDate ?? DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime.now(),
                            );
                            if (date != null) setState(() => _toDate = date);
                          },
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: Text(_toDate == null
                              ? context.l10n.toDate
                              : DateFormatter.format(_toDate!)),
                        ),
                      ),
                    ],
                  ),
                  if (_fromDate != null || _toDate != null)
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _fromDate = null;
                            _toDate = null;
                          });
                        },
                        child: Text(context.l10n.resetDates),
                      ),
                    ),
                  const SizedBox(height: 24),
                ],

                // Export Buttons
                ElevatedButton.icon(
                  onPressed: () => _exportReport(saveLocally: true),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    backgroundColor: AppColors.success,
                  ),
                  icon: const Icon(Icons.download, color: Colors.white),
                  label: Text(context.l10n.saveToLocalStorage,
                      style:
                          const TextStyle(color: Colors.white, fontSize: 16)),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => _exportReport(saveLocally: false),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    side: const BorderSide(color: AppColors.primary),
                  ),
                  icon: const Icon(Icons.share, color: AppColors.primary),
                  label: Text(context.l10n.shareSendReport,
                      style: const TextStyle(
                          color: AppColors.primary, fontSize: 16)),
                ),
              ],
            ),
    );
  }

  bool _requiresDateFilters() {
    return _selectedReportType == ReportType.ledgerReport ||
        _selectedReportType == ReportType.purchaseReport ||
        _selectedReportType == ReportType.salesReport ||
        _selectedReportType == ReportType.paymentReport ||
        _selectedReportType == ReportType.profitLossStatement;
  }
}
