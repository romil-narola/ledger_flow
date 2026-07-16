import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'core/core.dart';
import 'l10n/app_localizations.dart';

void main() async {
  // Ensure Flutter engine is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection (GetIt, Drift Database, repositories, blocs)
  await initDependencies();

  runApp(const LedgerFlowApp());
}

class LedgerFlowApp extends StatelessWidget {
  const LedgerFlowApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => LocaleCubit(),
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            title: AppConstants.appName,
            debugShowCheckedModeBanner: false,
            locale: locale,
            supportedLocales: const [
              Locale('en'),
              Locale('gu'),
              Locale('hi'),
            ],
            localizationsDelegates: [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],

            // Theme settings
            themeMode: ThemeMode.system, // respect system preference
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,

            // GoRouter navigation config
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
