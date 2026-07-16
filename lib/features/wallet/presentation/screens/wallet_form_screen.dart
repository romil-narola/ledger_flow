import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../wallet.dart';

/// Add / Edit wallet form screen
class WalletFormScreen extends StatefulWidget {
  final int? walletId;
  const WalletFormScreen({super.key, this.walletId});

  bool get isEditing => walletId != null;

  @override
  State<WalletFormScreen> createState() => _WalletFormScreenState();
}

class _WalletFormScreenState extends State<WalletFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _balanceController = TextEditingController();
  final _notesController = TextEditingController();
  bool _overdraftEnabled = false;
  WalletAccountEntity? _existingWallet;

  @override
  void dispose() {
    _nameController.dispose();
    _balanceController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _prefillForm(WalletAccountEntity wallet) {
    _existingWallet = wallet;
    _nameController.text = wallet.name;
    _balanceController.text = wallet.openingBalance.toStringAsFixed(2);
    _notesController.text = wallet.notes ?? '';
    _overdraftEnabled = wallet.overdraftEnabled;
    setState(() {});
  }

  void _submit(WalletBloc bloc) {
    if (!_formKey.currentState!.validate()) return;

    final name = _nameController.text.trim();
    final balance = double.tryParse(_balanceController.text) ?? 0.0;
    final notes = _notesController.text.trim().isEmpty
        ? null
        : _notesController.text.trim();

    if (widget.isEditing && _existingWallet != null) {
      bloc.add(UpdateWalletRequested(_existingWallet!.copyWith(
        name: name,
        openingBalance: balance,
        notes: notes,
        overdraftEnabled: _overdraftEnabled,
      )));
    } else {
      bloc.add(AddWalletRequested(
        name: name,
        openingBalance: balance,
        notes: notes,
        overdraftEnabled: _overdraftEnabled,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = sl<WalletBloc>();
        if (widget.isEditing) {
          bloc.add(LoadWalletHistory(walletId: widget.walletId!));
        }
        return bloc;
      },
      child: BlocConsumer<WalletBloc, WalletState>(
        listener: (context, state) {
          if (state is WalletHistoryLoaded && widget.isEditing) {
            _prefillForm(state.wallet);
          }
          if (state is WalletOperationSuccess) {
            context.pop();
          }
          if (state is WalletError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text(translateBlocMessage(state.message, context.l10n)),
                  backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          final bloc = context.read<WalletBloc>();
          final isLoading = state is WalletLoading;

          return Scaffold(
            appBar: AppBar(
              title: Text(widget.isEditing
                  ? context.l10n.editWallet
                  : context.l10n.addWallet),
            ),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Name
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '${context.l10n.walletName} *',
                      prefixIcon:
                          const Icon(Icons.account_balance_wallet_outlined),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? context.l10n.accountNameRequired
                        : null,
                  ),
                  const SizedBox(height: 16),

                  // Opening Balance
                  TextFormField(
                    controller: _balanceController,
                    decoration: InputDecoration(
                      labelText: '${context.l10n.initialBalance} *',
                      hintText: '0.00',
                      prefixIcon: const Icon(Icons.currency_rupee),
                    ),
                    keyboardType:
                        const TextInputType.numberWithOptions(decimal: true),
                    enabled: !widget.isEditing,
                    validator: (v) {
                      if (v == null || v.trim().isEmpty) {
                        return context.l10n.openingBalanceRequired;
                      }
                      if (double.tryParse(v) == null) {
                        return context.l10n.invalidAmount;
                      }
                      return null;
                    },
                  ),
                  if (widget.isEditing)
                    Padding(
                      padding: const EdgeInsets.only(top: 4, left: 4),
                      child: Text(
                        context.l10n.openingBalanceCannotBeChanged,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.outline,
                            ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Notes
                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: context.l10n.notesOptional,
                      prefixIcon: const Icon(Icons.notes_outlined),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),

                  // Overdraft Toggle
                  Card(
                    child: SwitchListTile(
                      title: Text(context.l10n.enableOverdraft),
                      subtitle: Text(context.l10n.allowNegativeBalance),
                      value: _overdraftEnabled,
                      onChanged: (v) => setState(() => _overdraftEnabled = v),
                      activeThumbColor: AppColors.primaryLight,
                      secondary: Icon(
                        Icons.warning_amber_rounded,
                        color: _overdraftEnabled ? AppColors.warning : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  ElevatedButton(
                    onPressed: isLoading ? null : () => _submit(bloc),
                    child: isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white),
                          )
                        : Text(widget.isEditing
                            ? context.l10n.updateWallet
                            : context.l10n.addWallet),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
