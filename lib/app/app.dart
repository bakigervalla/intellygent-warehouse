import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../presentation/auth/auth_controller.dart';
import '../presentation/auth/login_screen.dart';
import '../presentation/drafts/review_drafts_screen.dart';
import '../presentation/inventory/inventory_screen.dart';
import '../presentation/providers.dart';
import '../presentation/scan/scan_screen.dart';
import '../presentation/theme/app_theme.dart';

class IntellygentWarehouseApp extends StatelessWidget {
  const IntellygentWarehouseApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Intellygent Warehouse',
      theme: AppTheme.light(),
      debugShowCheckedModeBanner: false,
      home: const _AuthGate(),
    );
  }
}

/// Shows the password gate when APP_PASSWORD is configured and no valid
/// session exists; otherwise the app. When ungated, resolves to [HomeShell]
/// immediately.
class _AuthGate extends ConsumerWidget {
  const _AuthGate();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authControllerProvider);
    return auth.when(
      data: (unlocked) => unlocked ? const HomeShell() : const LoginScreen(),
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (_, _) => const LoginScreen(),
    );
  }
}

/// Bottom-nav shell: Scan / Drafts / Inventory. The Drafts tab carries a
/// live badge with the pending count.
class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pendingCount =
        ref.watch(pendingDraftsProvider).value?.length ?? 0;

    final screens = [
      ScanScreen(onDraftsCreated: () => setState(() => _index = 1)),
      const ReviewDraftsScreen(),
      InventoryScreen(onOpenDrafts: () => setState(() => _index = 1)),
    ];

    return Scaffold(
      body: IndexedStack(index: _index, children: screens),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          const NavigationDestination(
            icon: Icon(Icons.photo_camera_outlined),
            selectedIcon: Icon(Icons.photo_camera),
            label: 'Scan',
          ),
          NavigationDestination(
            icon: Badge(
              isLabelVisible: pendingCount > 0,
              label: Text('$pendingCount'),
              child: const Icon(Icons.fact_check_outlined),
            ),
            selectedIcon: Badge(
              isLabelVisible: pendingCount > 0,
              label: Text('$pendingCount'),
              child: const Icon(Icons.fact_check),
            ),
            label: 'Drafts',
          ),
          const NavigationDestination(
            icon: Icon(Icons.inventory_2_outlined),
            selectedIcon: Icon(Icons.inventory_2),
            label: 'Inventory',
          ),
        ],
      ),
    );
  }
}
