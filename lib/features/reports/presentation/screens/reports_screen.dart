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

  final List<ReportType> _reportTypes = ReportType.values;

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
            );
          } else {
            file = await ExcelExportService.exportLedger(
              entries: entries,
              sheetName: l10n.ledger,
              l10n: l10n,
            );
          }
          break;

        case ReportType.supplierOutstanding:
          final suppliers = await supplierRepo.getSuppliersWithOutstanding();
          if (_selectedFormat == ExportFormat.pdf) {
            file = await PdfExportService.generateOutstandingReport(
              suppliers: suppliers,
              customers: [],
              l10n: l10n,
            );
          } else {
            file = await ExcelExportService.exportOutstanding(
              suppliers: suppliers,
              customers: [],
              l10n: l10n,
            );
          }
          break;

        case ReportType.supplierCredit:
          final suppliers = await supplierRepo.getSuppliersWithCredit();
          if (_selectedFormat == ExportFormat.pdf) {
            file = await PdfExportService.generateOutstandingReport(
              suppliers: suppliers,
              customers: [],
              l10n: l10n,
            );
          } else {
            file = await ExcelExportService.exportOutstanding(
              suppliers: suppliers,
              customers: [],
              l10n: l10n,
            );
          }
          break;

        case ReportType.customerOutstanding:
          final customers = await customerRepo.getCustomersWithOutstanding();
          if (_selectedFormat == ExportFormat.pdf) {
            file = await PdfExportService.generateOutstandingReport(
              suppliers: [],
              customers: customers,
              l10n: l10n,
            );
          } else {
            file = await ExcelExportService.exportOutstanding(
              suppliers: [],
              customers: customers,
              l10n: l10n,
            );
          }
          break;

        case ReportType.customerAdvance:
          final customers = await customerRepo.getCustomersWithAdvance();
          if (_selectedFormat == ExportFormat.pdf) {
            file = await PdfExportService.generateOutstandingReport(
              suppliers: [],
              customers: customers,
              l10n: l10n,
            );
          } else {
            file = await ExcelExportService.exportOutstanding(
              suppliers: [],
              customers: customers,
              l10n: l10n,
            );
          }
          break;

        case ReportType.walletReport:
          final wallets = await walletRepo.getWallets();
          if (_selectedFormat == ExportFormat.pdf) {
            file = await PdfExportService.generateWalletReport(
                wallets: wallets, l10n: l10n);
          } else {
            file = await ExcelExportService.exportWallets(
                wallets: wallets, l10n: l10n);
          }
          break;

        case ReportType.purchaseReport:
          final purchases =
              await supplierRepo.getAllPurchases(from: _fromDate, to: _toDate);
          final entries = purchases
              .map((p) => LedgerEntryEntity(
                    id: p.id,
                    referenceNumber: p.referenceNumber,
                    transactionType: TransactionType.purchase,
                    supplierName: p.supplierName,
                    debit: p.amount,
                    credit: 0.0,
                    walletBalance: 0.0,
                    description:
                        p.notes ?? '${l10n.purchase} (${p.supplierName})',
                    date: p.date,
                    createdAt: p.createdAt,
                  ))
              .toList();

          if (_selectedFormat == ExportFormat.pdf) {
            file = await PdfExportService.generateLedgerReport(
              entries: entries,
              title: l10n.purchaseReport,
              subtitle: dateSubtitle,
              l10n: l10n,
            );
          } else {
            file = await ExcelExportService.exportLedger(
              entries: entries,
              sheetName: l10n.purchaseReport,
              l10n: l10n,
            );
          }
          break;

        case ReportType.salesReport:
          final sales =
              await customerRepo.getAllSales(from: _fromDate, to: _toDate);
          final entries = sales
              .map((s) => LedgerEntryEntity(
                    id: s.id,
                    referenceNumber: s.referenceNumber,
                    transactionType: TransactionType.sale,
                    customerName: s.customerName,
                    debit: 0.0,
                    credit: s.amount,
                    walletBalance: 0.0,
                    description: s.notes ?? '${l10n.sale} (${s.customerName})',
                    date: s.date,
                    createdAt: s.createdAt,
                  ))
              .toList();

          if (_selectedFormat == ExportFormat.pdf) {
            file = await PdfExportService.generateLedgerReport(
              entries: entries,
              title: l10n.salesReport,
              subtitle: dateSubtitle,
              l10n: l10n,
            );
          } else {
            file = await ExcelExportService.exportLedger(
              entries: entries,
              sheetName: l10n.salesReport,
              l10n: l10n,
            );
          }
          break;

        case ReportType.paymentReport:
          final sPayments =
              await supplierRepo.getAllPayments(from: _fromDate, to: _toDate);
          final cPayments =
              await customerRepo.getAllPayments(from: _fromDate, to: _toDate);

          final List<LedgerEntryEntity> entries = [
            ...sPayments.map((p) => LedgerEntryEntity(
                  id: p.id,
                  referenceNumber: p.referenceNumber,
                  transactionType: TransactionType.supplierPayment,
                  supplierName: p.supplierName,
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
                  customerName: p.customerName,
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
            );
          } else {
            file = await ExcelExportService.exportLedger(
              entries: entries,
              sheetName: l10n.paymentsReport,
              l10n: l10n,
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
            );
          } else {
            file = await ExcelExportService.exportLedger(
              entries: entries,
              sheetName: l10n.monthlySummaryReport,
              l10n: l10n,
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
            );
          } else {
            file = await ExcelExportService.exportProfitLoss(
              totalSales: totalSales,
              totalPurchases: totalPurchases,
              from: _fromDate,
              to: _toDate,
              l10n: l10n,
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
                      setState(() => _selectedReportType = val);
                    }
                  },
                ),
                const SizedBox(height: 20),

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
