import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:books_flutter/features/library/presentation/screens/library_screen.dart';
import 'package:books_flutter/features/search/presentation/screens/search_screen.dart';
import 'package:books_flutter/features/scanner/presentation/screens/scanner_screen.dart';
import 'package:books_flutter/features/insights/presentation/screens/insights_screen.dart';
import 'package:books_flutter/shared/widgets/layouts/main_scaffold.dart';

/// App-wide routing configuration using go_router
/// Uses StatefulShellRoute for persistent tab navigation state
final appRouter = GoRouter(
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
