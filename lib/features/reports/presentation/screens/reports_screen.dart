import 'dart:io';
import 'package:calendar_date_picker2/calendar_date_picker2.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../core/core.dart';
import '../../../customer/customer.dart';
import '../../../supplier/supplier.dart';
import '../../../wallet/wallet.dart';
import '../../../expenses/expenses.dart';
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

  DateTime get _effectiveFromDate {
    if (_fromDate != null) {
      return DateTime(
          _fromDate!.year, _fromDate!.month, _fromDate!.day, 0, 0, 0, 0);
    }
    final now = DateTime.now();
    return DateTime(now.year, now.month, 1, 0, 0, 0, 0);
  }

  DateTime get _effectiveToDate {
    if (_toDate != null) {
      return DateTime(
          _toDate!.year, _toDate!.month, _toDate!.day, 23, 59, 59, 999);
    }
    final now = DateTime.now();
    return DateTime(now.year, now.month + 1, 0, 23, 59, 59, 999);
  }

  CustomerEntity? _selectedCustomer;
  SupplierEntity? _selectedSupplier;
  WalletAccountEntity? _selectedWallet;

  List<CustomerEntity> _customers = [];
  List<SupplierEntity> _suppliers = [];
  List<WalletAccountEntity> _wallets = [];

  double _totalSales = 0.0;
  double _totalPurchases = 0.0;
  double _businessExpenses = 0.0;
  double _personalExpenses = 0.0;
  double _customerPayouts = 0.0;
  double _supplierPayouts = 0.0;
  double _totalAvailableBalance = 0.0;
  bool _isLoadingMetrics = false;

  final List<ReportType> _reportTypes = ReportType.values;

  @override
  void initState() {
    super.initState();
    _loadEntities();
    _loadMetrics();
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

  Future<void> _loadMetrics() async {
    setState(() => _isLoadingMetrics = true);
    try {
      final walletRepo = sl<WalletRepository>();
      final supplierRepo = sl<SupplierRepository>();
      final customerRepo = sl<CustomerRepository>();
      final expenseRepo = sl<ExpenseRepository>();

      final from = _effectiveFromDate;
      final to = _effectiveToDate;

      final totalAvailable = await walletRepo.getTotalBalance();
      final sales = await customerRepo.getAllSales(from: from, to: to);
      final purchases = await supplierRepo.getAllPurchases(from: from, to: to);
      final cPayments = await customerRepo.getAllPayments(from: from, to: to);
      final sPayments = await supplierRepo.getAllPayments(from: from, to: to);
      final expenses = await expenseRepo.getAllExpenses(from: from, to: to);

      final salesVal = sales.fold(0.0, (sum, s) => sum + s.amount);
      final purchasesVal = purchases.fold(0.0, (sum, p) => sum + p.amount);
      final cPayVal = cPayments.fold(0.0, (sum, p) => sum + p.amount);
      final sPayVal = sPayments.fold(0.0, (sum, p) => sum + p.amount);

      final personalCategories = [
        'food & dining',
        'entertainment',
        'medical',
        'education',
        'personal',
        'family',
        'shopping'
      ];
      double personalVal = 0.0;
      double businessVal = 0.0;
      for (final e in expenses) {
        final isPersonal = personalCategories
            .any((p) => e.categoryName.toLowerCase().contains(p));
        if (isPersonal) {
          personalVal += e.amount;
        } else {
          businessVal += e.amount;
        }
      }

      setState(() {
        _totalSales = salesVal;
        _totalPurchases = purchasesVal;
        _customerPayouts = cPayVal;
        _supplierPayouts = sPayVal;
        _businessExpenses = businessVal;
        _personalExpenses = personalVal;
        _totalAvailableBalance = totalAvailable;
        _isLoadingMetrics = false;
      });
    } catch (_) {
      setState(() => _isLoadingMetrics = false);
    }
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

      final from = _effectiveFromDate;
      final to = _effectiveToDate;

      final salesList = await customerRepo.getAllSales(from: from, to: to);
      final purchasesList =
          await supplierRepo.getAllPurchases(from: from, to: to);
      final cPaymentsList =
          await customerRepo.getAllPayments(from: from, to: to);
      final sPaymentsList =
          await supplierRepo.getAllPayments(from: from, to: to);

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
          final entries =
              await ledgerRepo.getEntries(from: from, to: to, limit: 100000);
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
            var entries =
                await supplierRepo.getSupplierLedger(_selectedSupplier!.id);
            entries = entries
                .where((e) => !e.date.isBefore(from) && !e.date.isAfter(to))
                .toList();
            if (_selectedFormat == ExportFormat.pdf) {
              file = await PdfExportService.generateSupplierLedgerReport(
                supplier: _selectedSupplier!,
                entries: entries,
                l10n: l10n,
                totalAvailableBalance: totalAvailableBalance,
                subtitle: dateSubtitle,
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
                subtitle: dateSubtitle,
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
              subtitle: dateSubtitle,
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
            var entries =
                await customerRepo.getCustomerLedger(_selectedCustomer!.id);
            entries = entries
                .where((e) => !e.date.isBefore(from) && !e.date.isAfter(to))
                .toList();
            if (_selectedFormat == ExportFormat.pdf) {
              file = await PdfExportService.generateCustomerLedgerReport(
                customer: _selectedCustomer!,
                entries: entries,
                l10n: l10n,
                totalAvailableBalance: totalAvailableBalance,
                subtitle: dateSubtitle,
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
                subtitle: dateSubtitle,
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
              subtitle: dateSubtitle,
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
            var history = await walletRepo.getWalletHistory(
                walletId: _selectedWallet!.id);
            history = history
                .where((h) => !h.date.isBefore(from) && !h.date.isAfter(to))
                .toList();
            if (_selectedFormat == ExportFormat.pdf) {
              file = await PdfExportService.generateSingleWalletReport(
                wallet: _selectedWallet!,
                transactions: history,
                l10n: l10n,
                totalAvailableBalance: totalAvailableBalance,
                subtitle: dateSubtitle,
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
                subtitle: dateSubtitle,
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
              await supplierRepo.getAllPurchases(from: from, to: to);
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
          final sales = await customerRepo.getAllSales(from: from, to: to);
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

        case ReportType.expenseReport:
          final expenseRepo = sl<ExpenseRepository>();
          final expenses = await expenseRepo.getAllExpenses(from: from, to: to);

          if (_selectedFormat == ExportFormat.pdf) {
            file = await PdfExportService.generateExpenseReport(
              expenses: expenses,
              subtitle: dateSubtitle,
              l10n: l10n,
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
            );
          } else {
            file = await ExcelExportService.exportExpenseReport(
              expenses: expenses,
              l10n: l10n,
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
            );
          }
          break;

        case ReportType.paymentReport:
          final sPayments =
              await supplierRepo.getAllPayments(from: from, to: to);
          final cPayments =
              await customerRepo.getAllPayments(from: from, to: to);
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
          final effectiveFrom = from;
          final effectiveTo = to;
          final entries = await ledgerRepo.getEntries(
            from: effectiveFrom,
            to: effectiveTo,
            limit: 100000,
          );
          final expenseRepo = sl<ExpenseRepository>();
          final monthlyExp = await expenseRepo.getAllExpenses(
            from: effectiveFrom,
            to: effectiveTo,
          );
          final personalCategories = [
            'food',
            'dining',
            'entertainment',
            'medical',
            'doctor',
            'hospital',
            'medicine',
            'education',
            'school',
            'college',
            'tuition',
            'fee',
            'personal',
            'family',
            'shopping',
            'clothing',
            'grocery',
            'groceries',
            'home',
            'house',
            'movie',
            'gift',
            'recharge',
            'subscription',
            'life',
            'health',
            'self',
            'draw',
            'drawing',
            'household',
            'charity',
            'vacation',
            'trip'
          ];
          double personalExpVal = 0.0;
          double businessExpVal = 0.0;
          for (final e in monthlyExp) {
            final isPersonal = personalCategories
                .any((p) => e.categoryName.toLowerCase().contains(p));
            if (isPersonal) {
              personalExpVal += e.amount;
            } else {
              businessExpVal += e.amount;
            }
          }

          if (_selectedFormat == ExportFormat.pdf) {
            file = await PdfExportService.generateLedgerReport(
              entries: entries,
              title: l10n.monthlySummaryReport,
              subtitle: dateSubtitle,
              l10n: l10n,
              openingBalance: openingBalance,
              totalAvailableBalance: totalAvailableBalance,
              totalSales: totalSalesVal,
              totalPurchases: totalPurchasesVal,
              customerPayouts: customerPayoutsVal,
              supplierPayouts: supplierPayoutsVal,
              personalExpenses: personalExpVal,
              businessExpenses: businessExpVal,
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
              personalExpenses: personalExpVal,
              businessExpenses: businessExpVal,
            );
          }
          break;

        case ReportType.profitLossStatement:
          final purchases =
              await supplierRepo.getAllPurchases(from: from, to: to);
          final sales = await customerRepo.getAllSales(from: from, to: to);
          final expenseRepo = sl<ExpenseRepository>();
          final expenses = await expenseRepo.getAllExpenses(from: from, to: to);

          final double totalPurchases =
              purchases.fold(0.0, (sum, p) => sum + p.amount);
          final double totalSales = sales.fold(0.0, (sum, s) => sum + s.amount);

          final personalCategories = [
            'food',
            'dining',
            'entertainment',
            'medical',
            'doctor',
            'hospital',
            'medicine',
            'education',
            'school',
            'college',
            'tuition',
            'fee',
            'personal',
            'family',
            'shopping',
            'clothing',
            'grocery',
            'groceries',
            'home',
            'house',
            'movie',
            'gift',
            'recharge',
            'subscription',
            'life',
            'health',
            'self',
            'draw',
            'drawing',
            'household',
            'charity',
            'vacation',
            'trip'
          ];
          double personalExp = 0.0;
          double businessExp = 0.0;
          for (final e in expenses) {
            final isPersonal = personalCategories
                .any((p) => e.categoryName.toLowerCase().contains(p));
            if (isPersonal) {
              personalExp += e.amount;
            } else {
              businessExp += e.amount;
            }
          }

          if (_selectedFormat == ExportFormat.pdf) {
            file = await PdfExportService.generateProfitLossReport(
              totalSales: totalSales,
              totalPurchases: totalPurchases,
              businessExpenses: businessExp,
              personalExpenses: personalExp,
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
              businessExpenses: businessExp,
              personalExpenses: personalExp,
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
    return '${context.l10n.dateRange}: ${DateFormatter.format(_effectiveFromDate)} - ${DateFormatter.format(_effectiveToDate)}';
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
                        showCheckmark: false,
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_selectedFormat == ExportFormat.pdf) ...[
                              const Icon(Icons.check_circle,
                                  size: 16, color: Colors.white),
                              const SizedBox(width: 6),
                            ],
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
                        showCheckmark: false,
                        label: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            if (_selectedFormat == ExportFormat.excel) ...[
                              const Icon(Icons.check_circle,
                                  size: 16, color: Colors.white),
                              const SizedBox(width: 6),
                            ],
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
                  Builder(
                    builder: (context) {
                      final isDark =
                          Theme.of(context).brightness == Brightness.dark;
                      final primaryColor = isDark
                          ? Colors.white70
                          : Theme.of(context).primaryColor;
                      return SizedBox(
                        width: double.infinity,
                        child: OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                vertical: 14, horizontal: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            foregroundColor:
                                isDark ? Colors.white : primaryColor,
                            side: BorderSide(
                              color: isDark
                                  ? Colors.white38
                                  : primaryColor.withValues(alpha: 0.5),
                            ),
                          ),
                          onPressed: () async {
                            final results = await showCalendarDatePicker2Dialog(
                              context: context,
                              config:
                                  CalendarDatePicker2WithActionButtonsConfig(
                                calendarType: CalendarDatePicker2Type.range,
                                firstDate: DateTime(2000),
                                lastDate: DateTime.now(),
                                selectedDayHighlightColor:
                                    isDark ? Colors.white : primaryColor,
                                selectedRangeHighlightColor: isDark
                                    ? Colors.white.withValues(alpha: 0.25)
                                    : primaryColor.withValues(alpha: 0.25),
                                daySplashColor: Colors.transparent,
                                buttonPadding: const EdgeInsets.all(10),
                                dayTextStyle: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                                selectedDayTextStyle: TextStyle(
                                  color: isDark ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                selectedRangeDayTextStyle: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                                weekdayLabelTextStyle: TextStyle(
                                  color:
                                      isDark ? Colors.white70 : Colors.black54,
                                  fontWeight: FontWeight.bold,
                                ),
                                controlsTextStyle: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                                disabledDayTextStyle: TextStyle(
                                  color:
                                      isDark ? Colors.white38 : Colors.black38,
                                ),
                                yearTextStyle: TextStyle(
                                  color: isDark ? Colors.white : Colors.black87,
                                ),
                                selectedYearTextStyle: TextStyle(
                                  color: isDark ? Colors.black : Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                cancelButtonTextStyle: TextStyle(
                                  color:
                                      isDark ? Colors.white70 : Colors.black54,
                                ),
                                okButton: Container(
                                  margin: const EdgeInsets.only(right: 12),
                                  child: Text(
                                    'APPLY',
                                    style: TextStyle(
                                      color:
                                          isDark ? Colors.white : primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              dialogSize: const Size(345, 420),
                              dialogBackgroundColor: isDark
                                  ? const Color(0xFF1E1E1E)
                                  : Colors.white,
                              builder: (context, child) {
                                return Theme(
                                  data: Theme.of(context).copyWith(
                                    splashColor: Colors.transparent,
                                    highlightColor: Colors.transparent,
                                    hoverColor: Colors.transparent,
                                    focusColor: Colors.transparent,
                                    textButtonTheme: TextButtonThemeData(
                                      style: ButtonStyle(
                                        overlayColor: WidgetStateProperty.all(
                                            Colors.transparent),
                                        shadowColor: WidgetStateProperty.all(
                                            Colors.transparent),
                                        elevation: WidgetStateProperty.all(0),
                                      ),
                                    ),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: child!,
                                  ),
                                );
                              },
                              value: [
                                if (_fromDate != null) _fromDate!,
                                if (_toDate != null) _toDate!,
                              ],
                              borderRadius: BorderRadius.circular(16),
                            );
                            if (results != null && results.isNotEmpty) {
                              final start = results.first;
                              final end = results.length > 1
                                  ? results.last
                                  : results.first;
                              if (start != null) {
                                setState(() {
                                  _fromDate = start;
                                  _toDate = end ?? start;
                                });
                              }
                            }
                          },
                          icon: const Icon(Icons.calendar_today, size: 16),
                          label: Text(
                            (_fromDate != null && _toDate != null)
                                ? '${DateFormatter.format(_fromDate!)} - ${DateFormatter.format(_toDate!)}'
                                : context.l10n.dateRange,
                          ),
                        ),
                      );
                    },
                  ),
                  if (_fromDate != null || _toDate != null) ...[
                    const SizedBox(height: 6),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          setState(() {
                            _fromDate = null;
                            _toDate = null;
                          });
                          _loadMetrics();
                        },
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: Text(context.l10n.resetDates),
                      ),
                    ),
                  ] else ...[
                    const SizedBox(height: 16),
                  ],
                ],

                // Live Summary Cards for Profit Loss, Monthly Summary & Expense Report
                if (_selectedReportType == ReportType.profitLossStatement) ...[
                  _buildProfitLossCards(context),
                  const SizedBox(height: 16),
                ] else if (_selectedReportType == ReportType.monthlyReport) ...[
                  _buildMonthlyReportCards(context),
                  const SizedBox(height: 16),
                ] else if (_selectedReportType == ReportType.expenseReport) ...[
                  _buildExpenseReportCards(context),
                  const SizedBox(height: 16),
                ],

                SizedBox(
                  height: 6,
                ),

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
    return true;
  }

  Widget _buildProfitLossCards(BuildContext context) {
    if (_isLoadingMetrics) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ));
    }

    final grossProfit = _totalSales - _totalPurchases;
    final netOperating = grossProfit - _businessExpenses;
    final netRetained = netOperating - _personalExpenses;
    final isProfit = netRetained >= 0;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .outlineVariant
                .withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.analytics_outlined,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Profit & Loss Financial Summary',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _buildMetricCard(
                context,
                title: context.l10n.totalSales,
                value: CurrencyFormatter.format(_totalSales),
                color: AppColors.creditEntry,
                icon: Icons.sell_outlined,
              ),
              _buildMetricCard(
                context,
                title: context.l10n.totalPurchases,
                value: CurrencyFormatter.format(_totalPurchases),
                color: AppColors.debit,
                icon: Icons.shopping_cart_outlined,
              ),
              _buildMetricCard(
                context,
                title: 'Business Expenses',
                value: CurrencyFormatter.format(_businessExpenses),
                color: const Color(0xFF0284C7),
                icon: Icons.business_center_outlined,
              ),
              _buildMetricCard(
                context,
                title: 'Personal Expenses',
                value: CurrencyFormatter.format(_personalExpenses),
                color: const Color(0xFF8B5CF6),
                icon: Icons.person_outline,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isProfit
                    ? [const Color(0xFF059669), const Color(0xFF10B981)]
                    : [const Color(0xFFDC2626), const Color(0xFFEF4444)],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Net Retained ${isProfit ? "Profit" : "Loss"}',
                      style:
                          const TextStyle(color: Colors.white70, fontSize: 12),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      CurrencyFormatter.format(netRetained.abs()),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isProfit ? Icons.trending_up : Icons.trending_down,
                    color: Colors.white,
                    size: 24,
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildMonthlyReportCards(BuildContext context) {
    if (_isLoadingMetrics) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ));
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .outlineVariant
                .withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.calendar_month_outlined,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Monthly Summary Breakdown',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _buildMetricCard(
                context,
                title: context.l10n.totalSales,
                value: CurrencyFormatter.format(_totalSales),
                color: AppColors.creditEntry,
                icon: Icons.sell_outlined,
              ),
              _buildMetricCard(
                context,
                title: context.l10n.totalPurchases,
                value: CurrencyFormatter.format(_totalPurchases),
                color: AppColors.debit,
                icon: Icons.shopping_cart_outlined,
              ),
              _buildMetricCard(
                context,
                title: context.l10n.customerPayouts,
                value: CurrencyFormatter.format(_customerPayouts),
                color: const Color(0xFF10B981),
                icon: Icons.payments_outlined,
              ),
              _buildMetricCard(
                context,
                title: context.l10n.supplierPayouts,
                value: CurrencyFormatter.format(_supplierPayouts),
                color: const Color(0xFFF59E0B),
                icon: Icons.payment_outlined,
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _buildMetricCard(
                  context,
                  title: 'Operating Expenses',
                  value: CurrencyFormatter.format(_businessExpenses),
                  color: const Color(0xFF0284C7),
                  icon: Icons.business_center_outlined,
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildMetricCard(
                  context,
                  title: 'Personal Expenses',
                  value: CurrencyFormatter.format(_personalExpenses),
                  color: const Color(0xFF8B5CF6),
                  icon: Icons.person_outline,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildMetricCard(
            context,
            title: context.l10n.totalAvailableBalance,
            value: CurrencyFormatter.format(_totalAvailableBalance),
            color: const Color(0xFF10B981),
            icon: Icons.account_balance_wallet_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseReportCards(BuildContext context) {
    if (_isLoadingMetrics) {
      return const Center(
          child: Padding(
        padding: EdgeInsets.all(16.0),
        child: CircularProgressIndicator(),
      ));
    }

    final totalExp = _businessExpenses + _personalExpenses;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .surfaceContainerHighest
            .withValues(alpha: 0.4),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: Theme.of(context)
                .colorScheme
                .outlineVariant
                .withValues(alpha: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.receipt_long_outlined,
                  color: AppColors.primary, size: 20),
              const SizedBox(width: 8),
              Text(
                'Expense Summary & Bifurcation',
                style: Theme.of(context)
                    .textTheme
                    .titleSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            childAspectRatio: 2.2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            children: [
              _buildMetricCard(
                context,
                title: 'Personal Expenses',
                value: CurrencyFormatter.format(_personalExpenses),
                color: const Color(0xFF8B5CF6),
                icon: Icons.person_outline,
              ),
              _buildMetricCard(
                context,
                title: 'Operating Expenses',
                value: CurrencyFormatter.format(_businessExpenses),
                color: const Color(0xFF0284C7),
                icon: Icons.business_center_outlined,
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildMetricCard(
            context,
            title: 'Total Expenses (Operating + Personal)',
            value: CurrencyFormatter.format(totalExp),
            color: const Color(0xFF4F46E5),
            icon: Icons.analytics_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildMetricCard(
    BuildContext context, {
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 18),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondaryLight),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
