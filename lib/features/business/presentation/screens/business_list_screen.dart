import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../bloc/business_cubit.dart';
import '../bloc/business_state.dart';
import '../../../../core/core.dart';

class BusinessListScreen extends StatelessWidget {
  const BusinessListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.l10n.businesses),
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (_) => const LanguageSelectorDialog(),
            ),
            icon: const Icon(Icons.language),
            tooltip: context.l10n.language,
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => context.push('/businesses/new'),
            tooltip: context.l10n.newBusiness,
          ),
        ],
      ),
      body: BlocBuilder<BusinessCubit, BusinessState>(
        builder: (context, state) {
          return state.when(
            initial: () => const Center(child: CircularProgressIndicator()),
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (msg) => Center(child: Text(msg)),
            loaded: (businesses, current) {
              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: businesses.length,
                itemBuilder: (context, index) {
                  final business = businesses[index];
                  final isCurrent = business.id == current.id;

                  return Card(
                    elevation: isCurrent ? 2 : 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: isCurrent
                            ? AppColors.primary
                            : Colors.grey.shade300,
                        width: isCurrent ? 2 : 1,
                      ),
                    ),
                    child: ListTile(
                      title: Text(business.name,
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(
                          business.description ?? context.l10n.noDescription),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined,
                                color: Colors.green),
                            onPressed: () => context.push('/businesses/edit',
                                extra: business),
                          ),
                          if (businesses.length > 1)
                            IconButton(
                              icon: const Icon(Icons.delete_outline,
                                  color: Colors.red),
                              onPressed: () =>
                                  _confirmDelete(context, business),
                            ),
                        ],
                      ),
                      onTap: () {
                        if (!isCurrent) {
                          context
                              .read<BusinessCubit>()
                              .switchBusiness(business.id);
                        }
                      },
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, dynamic business) async {
    final confirmed = await DeleteDialog.show(
      context,
      title: 'Delete ${business.name}?',
      content:
          'Are you sure you want to delete this business? All wallets, suppliers, customers, and transactions associated with it will be permanently deleted. This action cannot be undone.',
    );

    if (confirmed == true && context.mounted) {
      context.read<BusinessCubit>().deleteBusiness(business.id);
    }
  }
}
