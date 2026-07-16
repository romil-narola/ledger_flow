import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../supplier.dart';

class SupplierFormScreen extends StatefulWidget {
  final int? supplierId;
  const SupplierFormScreen({super.key, this.supplierId});

  bool get isEditing => supplierId != null;

  @override
  State<SupplierFormScreen> createState() => _SupplierFormScreenState();
}

class _SupplierFormScreenState extends State<SupplierFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _prefill(SupplierEntity supplier) {
    _nameController.text = supplier.name;
    _phoneController.text = supplier.phone ?? '';
    _emailController.text = supplier.email ?? '';
    _addressController.text = supplier.address ?? '';
    _notesController.text = supplier.notes ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = sl<SupplierBloc>();
        if (widget.isEditing) {
          bloc.add(LoadSupplierDetail(widget.supplierId!));
        }
        return bloc;
      },
      child: BlocConsumer<SupplierBloc, SupplierState>(
        listener: (context, state) {
          if (state is SupplierDetailLoaded && widget.isEditing) {
            _prefill(state.supplier);
          }
          if (state is SupplierOperationSuccess) Navigator.pop(context);
          if (state is SupplierError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                  content:
                      Text(translateBlocMessage(state.message, context.l10n)),
                  backgroundColor: AppColors.error),
            );
          }
        },
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
                title: Text(widget.isEditing
                    ? context.l10n.editSupplier
                    : context.l10n.addSupplier)),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      labelText: '${context.l10n.supplierName} *',
                      prefixIcon: const Icon(Icons.business_outlined),
                    ),
                    textCapitalization: TextCapitalization.words,
                    validator: (v) => (v == null || v.trim().isEmpty)
                        ? context.l10n.nameRequired
                        : null,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _phoneController,
                    decoration: InputDecoration(
                      labelText: context.l10n.phone,
                      prefixIcon: const Icon(Icons.phone_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: context.l10n.email,
                      prefixIcon: const Icon(Icons.email_outlined),
                    ),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                      labelText: context.l10n.address,
                      prefixIcon: const Icon(Icons.location_on_outlined),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                      labelText: context.l10n.notes,
                      prefixIcon: const Icon(Icons.notes_outlined),
                    ),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: state is SupplierLoading
                        ? null
                        : () => _submit(context),
                    child: Text(widget.isEditing
                        ? context.l10n.updateSupplier
                        : context.l10n.addSupplier),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _submit(BuildContext context) {
    if (!_formKey.currentState!.validate()) return;
    final bloc = context.read<SupplierBloc>();
    final name = _nameController.text.trim();
    final phone = _phoneController.text.trim().isEmpty
        ? null
        : _phoneController.text.trim();
    final email = _emailController.text.trim().isEmpty
        ? null
        : _emailController.text.trim();
    final address = _addressController.text.trim().isEmpty
        ? null
        : _addressController.text.trim();
    final notes = _notesController.text.trim().isEmpty
        ? null
        : _notesController.text.trim();

    if (widget.isEditing) {
      // We need the existing supplier - handled via state
    } else {
      bloc.add(AddSupplierRequested(
        name: name,
        phone: phone,
        email: email,
        address: address,
        notes: notes,
      ));
    }
  }
}
