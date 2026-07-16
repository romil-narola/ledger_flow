import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../locale_cubit.dart';
import '../l10n_extension.dart';

class LanguageSelectorDialog extends StatelessWidget {
  const LanguageSelectorDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final currentCode = context.watch<LocaleCubit>().state.languageCode;

    final languages = [
      {'code': 'en', 'name': context.l10n.english},
      {'code': 'gu', 'name': context.l10n.gujarati},
      {'code': 'hi', 'name': context.l10n.hindi},
    ];

    return AlertDialog(
      title: Text(context.l10n.selectLanguage),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: languages.map((lang) {
          final isSelected = currentCode == lang['code'];
          return ListTile(
            title: Text(lang['name']!),
            leading: Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Theme.of(context).primaryColor : null,
            ),
            onTap: () {
              context.read<LocaleCubit>().setLanguageCode(lang['code']!);
              Navigator.pop(context);
            },
          );
        }).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.l10n.cancel),
        ),
      ],
    );
  }
}
