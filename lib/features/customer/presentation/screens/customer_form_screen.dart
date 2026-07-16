import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../customer.dart';

class CustomerFormScreen extends StatefulWidget {
  final int? customerId;
  const CustomerFormScreen({super.key, this.customerId});
  bool get isEditing => customerId != null;

  @override
  State<CustomerFormScreen> createState() => _CustomerFormScreenState();
}

class _CustomerFormScreenState extends State<CustomerFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  CustomerEntity? _existingCustomer;

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  void _prefill(CustomerEntity c) {
    _existingCustomer = c;
    _nameController.text = c.name;
    _phoneController.text = c.phone ?? '';
    _emailController.text = c.email ?? '';
    _addressController.text = c.address ?? '';
    _notesController.text = c.notes ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = sl<CustomerBloc>();
        if (widget.isEditing) bloc.add(LoadCustomerDetail(widget.customerId!));
        return bloc;
      },
      child: BlocConsumer<CustomerBloc, CustomerState>(
        listener: (context, state) {
          if (state is CustomerDetailLoaded && widget.isEditing) {
            _prefill(state.customer);
          }
          if (state is CustomerOperationSuccess) Navigator.pop(context);
          if (state is CustomerError) {
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
                    ? context.l10n.editCustomer
                    : context.l10n.addCustomer)),
            body: Form(
              key: _formKey,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                        labelText: '${context.l10n.customerName} *',
                        prefixIcon: const Icon(Icons.person_outline)),
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
                        prefixIcon: const Icon(Icons.phone_outlined)),
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                        labelText: context.l10n.email,
                        prefixIcon: const Icon(Icons.email_outlined)),
                    keyboardType: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _addressController,
                    decoration: InputDecoration(
                        labelText: context.l10n.address,
                        prefixIcon: const Icon(Icons.location_on_outlined)),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _notesController,
                    decoration: InputDecoration(
                        labelText: context.l10n.notes,
                        prefixIcon: const Icon(Icons.notes_outlined)),
                    maxLines: 2,
                  ),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: state is CustomerLoading
                        ? null
                        : () => _submit(context),
                    child: Text(widget.isEditing
                        ? context.l10n.updateCustomer
                        : context.l10n.addCustomer),
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
    final bloc = context.read<CustomerBloc>();
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

    if (widget.isEditing && _existingCustomer != null) {
      bloc.add(UpdateCustomerRequested(_existingCustomer!.copyWith(
        name: name,
        phone: phone,
        email: email,
        address: address,
        notes: notes,
      )));
    } else {
      bloc.add(AddCustomerRequested(
          name: name,
          phone: phone,
          email: email,
          address: address,
          notes: notes));
    }
  }
}
