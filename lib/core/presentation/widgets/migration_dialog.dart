import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core.dart';
import '../../database/migration/local_to_firebase_migration_service.dart';

/// Modal dialog prompting the user for explicit permission to migrate local SQLite data to Cloud Firestore.
class MigrationDialog extends StatefulWidget {
  final LocalToFirebaseMigrationService migrationService;
  final VoidCallback onMigrationComplete;

  const MigrationDialog({
    super.key,
    required this.migrationService,
    required this.onMigrationComplete,
  });

  static Future<void> showIfNeeded(
    BuildContext context, {
    required LocalToFirebaseMigrationService migrationService,
    required VoidCallback onMigrationComplete,
  }) async {
    if (migrationService.isMigrationCompleted()) return;
    if (!context.mounted) return;

    await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => MigrationDialog(
        migrationService: migrationService,
        onMigrationComplete: onMigrationComplete,
      ),
    );
  }

  @override
  State<MigrationDialog> createState() => _MigrationDialogState();
}

class _MigrationDialogState extends State<MigrationDialog> {
  MigrationPreview? _preview;
  bool _isLoadingPreview = true;
  bool _isMigrating = false;
  MigrationProgress _progress = const MigrationProgress(
    stage: 'Ready to migrate',
    progress: 0.0,
  );

  @override
  void initState() {
    super.initState();
    _loadPreview();
  }

  Future<void> _loadPreview() async {
    final preview = await widget.migrationService.getMigrationPreview();
    if (mounted) {
      setState(() {
        _preview = preview;
        _isLoadingPreview = false;
      });
    }
  }

  Future<void> _startMigration() async {
    final firebaseService = sl<FirebaseService>();
    final user = firebaseService.currentUser;

    if (user == null || user.isAnonymous) {
      if (mounted) {
        final router = GoRouter.of(context);
        final messenger = ScaffoldMessenger.of(context);

        // Pop/close dialog immediately
        Navigator.of(context).pop();

        messenger.showSnackBar(
          SnackBar(
            content: const Text(
              'Authentication required. Please sign in with Google before migrating data.',
            ),
            backgroundColor: Colors.amber.shade900,
            duration: const Duration(seconds: 2),
          ),
        );

        // Open Google Sign-In screen
        router.push('/login');
      }
      return;
    }

    setState(() {
      _isMigrating = true;
    });

    final success = await widget.migrationService.executeMigration(
      onProgress: (p) {
        if (mounted) {
          setState(() {
            _progress = p;
          });
        }
      },
    );

    if (mounted && success) {
      await Future.delayed(const Duration(milliseconds: 800));
      widget.onMigrationComplete();
      if (mounted) Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final maxHeight = MediaQuery.of(context).size.height * 0.85;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      backgroundColor:
          theme.dialogTheme.backgroundColor ?? theme.colorScheme.surface,
      elevation: 0,
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header Icon
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.cloud_upload_outlined,
                  color: theme.colorScheme.primary,
                  size: 32,
                ),
              ),
              const SizedBox(height: 16),

              // Title
              Text(
                'Migrate Local Data to Cloud',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),

              // Description
              Text(
                'We are adding Firebase Cloud backend to keep your accounting records backed up and synced. Your local SQLite data will be safely uploaded.',
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontSize: 13,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Scrollable Content Body to Prevent Any Overflow
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (_isLoadingPreview) ...[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.0),
                          child: CircularProgressIndicator(),
                        ),
                      ] else if (_preview != null) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.colorScheme.surfaceContainerHighest
                                .withValues(alpha: 0.4),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: theme.colorScheme.outlineVariant
                                  .withValues(alpha: 0.6),
                            ),
                          ),
                          child: Column(
                            children: [
                              _buildSummaryRow(
                                context,
                                'Total Records:',
                                '${_preview!.totalRecords} items',
                                Icons.storage_rounded,
                              ),
                              const Divider(height: 16),
                              _buildSummaryRow(
                                context,
                                'Businesses & Accounts:',
                                '${_preview!.businessCount} Biz, ${_preview!.walletCount} Wallets',
                                Icons.account_balance_wallet_rounded,
                              ),
                              const SizedBox(height: 8),
                              _buildSummaryRow(
                                context,
                                'Suppliers & Customers:',
                                '${_preview!.supplierCount} Sup, ${_preview!.customerCount} Cust',
                                Icons.people_alt_rounded,
                              ),
                              const SizedBox(height: 8),
                              _buildSummaryRow(
                                context,
                                'Transactions & Expenses:',
                                '${_preview!.transactionCount} Txns, ${_preview!.expenseCount} Exp',
                                Icons.receipt_long_rounded,
                              ),
                            ],
                          ),
                        ),
                      ],
                      if (_isMigrating) ...[
                        const SizedBox(height: 20),
                        LinearProgressIndicator(
                          value: _progress.progress > 0
                              ? _progress.progress
                              : null,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            if (_progress.error != null)
                              const Icon(Icons.error_outline,
                                  color: Colors.red, size: 20)
                            else if (_progress.isCompleted)
                              const Icon(Icons.check_circle,
                                  color: Colors.green, size: 20)
                            else
                              const SizedBox(
                                width: 16,
                                height: 16,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Text(
                                _progress.error ?? _progress.stage,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: _progress.error != null
                                      ? Colors.red
                                      : theme.colorScheme.onSurface,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Action Buttons Matching DeleteDialog & App Theme
              Row(
                children: [
                  if (!_isMigrating) ...[
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(
                              color: theme.colorScheme.outlineVariant,
                              width: 1.5),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Later',
                          style: TextStyle(
                            color: theme.colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                  ],
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _isMigrating ? null : _startMigration,
                      icon: _progress.isCompleted
                          ? const Icon(Icons.check, size: 20)
                          : const Icon(Icons.cloud_upload_outlined, size: 20),
                      label: Text(
                        _progress.isCompleted
                            ? 'Done'
                            : (_isMigrating ? 'Migrating...' : 'Migration'),
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.colorScheme.primary,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryRow(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.primary),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              fontSize: 13,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Text(
          value,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: theme.colorScheme.primary,
          ),
        ),
      ],
    );
  }
}
