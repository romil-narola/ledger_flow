import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../l10n/app_localizations.dart';

/// Main shell widget providing persistent bottom navigation bar
class MainShell extends StatelessWidget {
  final Widget child;
  const MainShell({super.key, required this.child});

  static const _destinations = [
    (
      icon: Icons.dashboard_outlined,
      selectedIcon: Icons.dashboard,
      path: '/dashboard'
    ),
    (
      icon: Icons.people_outline,
      selectedIcon: Icons.people,
      path: '/suppliers'
    ),
    (
      icon: Icons.person_outline,
      selectedIcon: Icons.person,
      path: '/customers'
    ),
    (icon: Icons.book_outlined, selectedIcon: Icons.book, path: '/ledger'),
    (
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long,
      path: '/expenses'
    ),
    (
      icon: Icons.bar_chart_outlined,
      selectedIcon: Icons.bar_chart,
      path: '/reports'
    ),
  ];

  String _getLabel(BuildContext context, String path) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return path;
    switch (path) {
      case '/dashboard':
        return l10n.dashboard;
      case '/suppliers':
        return l10n.suppliers;
      case '/customers':
        return l10n.customers;
      case '/ledger':
        return l10n.ledger;
      case '/expenses':
        return l10n.expenses;
      case '/reports':
        return l10n.reports;
      default:
        return '';
    }
  }

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    for (int i = 0; i < _destinations.length; i++) {
      if (location.startsWith(_destinations[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          context.go(_destinations[index].path);
        },
        destinations: _destinations
            .map((d) => NavigationDestination(
                  icon: Icon(d.icon),
                  selectedIcon: Icon(d.selectedIcon),
                  label: _getLabel(context, d.path),
                ))
            .toList(),
      ),
    );
  }
}
