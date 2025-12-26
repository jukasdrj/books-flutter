import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../features/library/screens/library_screen.dart';
import '../features/search/screens/search_screen.dart';
import '../features/scanner/screens/scanner_screen.dart';
import '../features/insights/screens/insights_screen.dart';
import '../shared/widgets/layouts/main_scaffold.dart';

part 'router.g.dart';

/// App-wide routing configuration using go_router
/// Uses StatefulShellRoute for persistent tab navigation state
@riverpod
GoRouter router(RouterRef ref) {
  return GoRouter(
  initialLocation: '/library',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return MainScaffold(navigationShell: navigationShell);
      },
      branches: [
        // Library Tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/library',
              builder: (context, state) => const LibraryScreen(),
            ),
          ],
        ),
        // Search Tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/search',
              builder: (context, state) => const SearchScreen(),
            ),
          ],
        ),
        // Scanner Tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/scanner',
              builder: (context, state) => const ScannerScreen(),
            ),
          ],
        ),
        // Insights Tab
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/insights',
              builder: (context, state) => const InsightsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
  );
}
