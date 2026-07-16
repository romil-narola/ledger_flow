import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/business_cubit.dart';
import 'package:drift/drift.dart' show Value;
import '../../../../core/core.dart';
import '../../../../core/database/app_database.dart';

class BusinessFormScreen extends StatefulWidget {
  final Business? business;

  const BusinessFormScreen({super.key, this.business});

  @override
  State<BusinessFormScreen> createState() => _BusinessFormScreenState();
}

class _BusinessFormScreenState extends State<BusinessFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.business?.name);
    _descController = TextEditingController(text: widget.business?.description);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    super.dispose();
  }

  void _save() {
    if (_formKey.currentState!.validate()) {
      if (widget.business != null) {
        context.read<BusinessCubit>().updateBusiness(
              widget.business!.copyWith(
                name: _nameController.text.trim(),
                description: Value(_descController.text.trim()),
              ),
            );
      } else {
        context.read<BusinessCubit>().createBusiness(
              name: _nameController.text.trim(),
              description: _descController.text.trim(),
            );
      }
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.business == null
            ? context.l10n.newBusiness
            : context.l10n
                .businessName), // or context.l10n.editBusiness if available
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: context.l10n.businessName,
                  border: const OutlineInputBorder(),
                ),
                validator: (val) => val == null || val.isEmpty
                    ? context.l10n.requiredField
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: context.l10n.descriptionOptional,
                  border: const OutlineInputBorder(),
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _save,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: Text(widget.business == null
                    ? context.l10n.createBusiness
                    : context.l10n.save),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
