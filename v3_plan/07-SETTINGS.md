# 07 - Settings Implementation

**Priority:** P2 - Polish
**Estimated Effort:** 1 day
**Prerequisites:** 01-CRITICAL-FIXES.md
**PRD Reference:** `product/Settings-PRD.md`, `product/Library-Reset-PRD.md`

---

## Overview

Settings provides app customization including:
- Theme selection (5 built-in themes)
- Feature flags for experimental features
- Library reset with backend job cancellation
- Storage information

Accessed via gear icon in Library screen toolbar (not a tab).

---

## Current State

| Component | Status | Notes |
|-----------|--------|-------|
| Theme system | Exists | Material 3 with single theme |
| Settings screen | Missing | Not implemented |
| Library reset | Missing | Database schema supports it |
| Feature flags | Missing | Not implemented |

---

## Target Architecture

```
LibraryScreen AppBar
└── Settings gear icon → Opens SettingsScreen (modal)

SettingsScreen (Sheet/Page)
├── Appearance Section
│   └── Theme Picker (5 options)
├── Advanced Section
│   └── Feature Flags (toggles)
├── Library Management Section
│   ├── Storage info
│   └── Reset Library (destructive)
└── About Section
    ├── Version info
    └── Links
```

---

## Implementation Plan

### Step 1: Create Theme Provider

**File:** `lib/core/providers/theme_provider.dart`

```dart
import 'package:flutter/material.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'theme_provider.g.dart';

/// Available app themes.
enum AppTheme {
  liquidBlue('Liquid Blue', Color(0xFF1976D2)),
  cosmicPurple('Cosmic Purple', Color(0xFF7B1FA2)),
  forestGreen('Forest Green', Color(0xFF388E3C)),
  sunsetOrange('Sunset Orange', Color(0xFFE64A19)),
  moonlightSilver('Moonlight Silver', Color(0xFF607D8B));

  final String label;
  final Color seedColor;

  const AppTheme(this.label, this.seedColor);

  ThemeData toThemeData(Brightness brightness) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: seedColor,
        brightness: brightness,
      ),
    );
  }
}

/// Manages the current app theme.
@riverpod
class ThemeNotifier extends _$ThemeNotifier {
  static const _key = 'app_theme';

  @override
  AppTheme build() {
    _loadFromPrefs();
    return AppTheme.liquidBlue;
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString(_key);
    if (name != null) {
      try {
        state = AppTheme.values.byName(name);
      } catch (_) {
        // Invalid theme name, keep default
      }
    }
  }

  Future<void> setTheme(AppTheme theme) async {
    state = theme;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_key, theme.name);
  }
}

/// Provides light theme data.
@riverpod
ThemeData lightTheme(LightThemeRef ref) {
  final theme = ref.watch(themeNotifierProvider);
  return theme.toThemeData(Brightness.light);
}

/// Provides dark theme data.
@riverpod
ThemeData darkTheme(DarkThemeRef ref) {
  final theme = ref.watch(themeNotifierProvider);
  return theme.toThemeData(Brightness.dark);
}
```

---

### Step 2: Create Feature Flags Provider

**File:** `lib/core/providers/feature_flags_provider.dart`

```dart
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'feature_flags_provider.g.dart';

/// Feature flags for experimental features.
class FeatureFlags {
  final bool experimentalScanner;
  final int batchUploadLimit;

  const FeatureFlags({
    this.experimentalScanner = true,
    this.batchUploadLimit = 5,
  });

  FeatureFlags copyWith({
    bool? experimentalScanner,
    int? batchUploadLimit,
  }) {
    return FeatureFlags(
      experimentalScanner: experimentalScanner ?? this.experimentalScanner,
      batchUploadLimit: batchUploadLimit ?? this.batchUploadLimit,
    );
  }
}

@riverpod
class FeatureFlagsNotifier extends _$FeatureFlagsNotifier {
  @override
  FeatureFlags build() {
    _loadFromPrefs();
    return const FeatureFlags();
  }

  Future<void> _loadFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    state = FeatureFlags(
      experimentalScanner: prefs.getBool('ff_experimental_scanner') ?? true,
      batchUploadLimit: prefs.getInt('ff_batch_limit') ?? 5,
    );
  }

  Future<void> setExperimentalScanner(bool enabled) async {
    state = state.copyWith(experimentalScanner: enabled);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('ff_experimental_scanner', enabled);
  }

  Future<void> setBatchUploadLimit(int limit) async {
    state = state.copyWith(batchUploadLimit: limit);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('ff_batch_limit', limit);
  }

  Future<void> resetToDefaults() async {
    state = const FeatureFlags();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('ff_experimental_scanner');
    await prefs.remove('ff_batch_limit');
  }
}
```

---

### Step 3: Create Settings Screen

**File:** `lib/features/settings/screens/settings_screen.dart`

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/providers/feature_flags_provider.dart';
import '../../../core/providers/database_provider.dart';

/// Settings screen for app configuration.
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentTheme = ref.watch(themeNotifierProvider);
    final featureFlags = ref.watch(featureFlagsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Done'),
          ),
        ],
      ),
      body: ListView(
        children: [
          // Appearance Section
          _SectionHeader(title: 'Appearance'),
          ListTile(
            leading: const Icon(Icons.palette),
            title: const Text('Theme'),
            subtitle: Text(currentTheme.label),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showThemePicker(context, ref, currentTheme),
          ),

          const Divider(),

          // Advanced Section
          _SectionHeader(title: 'Advanced'),
          SwitchListTile(
            secondary: const Icon(Icons.science),
            title: const Text('Experimental Scanner'),
            subtitle: const Text('Use new camera features'),
            value: featureFlags.experimentalScanner,
            onChanged: (value) {
              ref
                  .read(featureFlagsNotifierProvider.notifier)
                  .setExperimentalScanner(value);
            },
          ),
          ListTile(
            leading: const Icon(Icons.burst_mode),
            title: const Text('Batch Upload Limit'),
            subtitle: Text('${featureFlags.batchUploadLimit} photos'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showBatchLimitPicker(context, ref, featureFlags),
          ),

          const Divider(),

          // Library Management Section
          _SectionHeader(title: 'Library Management'),
          FutureBuilder<_StorageInfo>(
            future: _getStorageInfo(ref),
            builder: (context, snapshot) {
              final info = snapshot.data;
              return ListTile(
                leading: const Icon(Icons.storage),
                title: const Text('Storage'),
                subtitle: Text(
                  info != null
                      ? '${info.bookCount} books'
                      : 'Calculating...',
                ),
              );
            },
          ),
          ListTile(
            leading: Icon(
              Icons.delete_forever,
              color: Theme.of(context).colorScheme.error,
            ),
            title: Text(
              'Reset Library',
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            subtitle: const Text('Delete all books and reading progress'),
            onTap: () => _confirmResetLibrary(context, ref),
          ),

          const Divider(),

          // About Section
          _SectionHeader(title: 'About'),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('Version'),
            subtitle: Text('1.0.0'),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showThemePicker(
    BuildContext context,
    WidgetRef ref,
    AppTheme current,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Choose Theme',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...AppTheme.values.map((theme) {
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: theme.seedColor,
                ),
                title: Text(theme.label),
                trailing: theme == current
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  ref.read(themeNotifierProvider.notifier).setTheme(theme);
                  Navigator.of(context).pop();
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _showBatchLimitPicker(
    BuildContext context,
    WidgetRef ref,
    FeatureFlags flags,
  ) {
    showModalBottomSheet<void>(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                'Batch Upload Limit',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            ...[3, 5, 10].map((limit) {
              return ListTile(
                title: Text('$limit photos'),
                trailing: limit == flags.batchUploadLimit
                    ? const Icon(Icons.check)
                    : null,
                onTap: () {
                  ref
                      .read(featureFlagsNotifierProvider.notifier)
                      .setBatchUploadLimit(limit);
                  Navigator.of(context).pop();
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Future<void> _confirmResetLibrary(BuildContext context, WidgetRef ref) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Library?'),
        content: const Text(
          'This will delete all books, authors, editions, and reading progress. '
          'In-flight enrichment jobs will be canceled. '
          'This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );

    if (confirmed == true && context.mounted) {
      await _performLibraryReset(context, ref);
    }
  }

  Future<void> _performLibraryReset(BuildContext context, WidgetRef ref) async {
    // Show loading indicator
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Resetting library...'),
          ],
        ),
      ),
    );

    try {
      final database = ref.read(databaseProvider);

      // Delete all data
      await database.resetLibrary();

      // Reset feature flags
      await ref.read(featureFlagsNotifierProvider.notifier).resetToDefaults();

      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Library reset successfully')),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.of(context).pop(); // Close loading dialog
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Reset failed: $e'),
            backgroundColor: Theme.of(context).colorScheme.error,
          ),
        );
      }
    }
  }

  Future<_StorageInfo> _getStorageInfo(WidgetRef ref) async {
    final database = ref.read(databaseProvider);
    final count = await database.getBookCount();
    return _StorageInfo(bookCount: count);
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _StorageInfo {
  final int bookCount;

  const _StorageInfo({required this.bookCount});
}
```

---

### Step 4: Add Database Reset Method

Add to `lib/core/data/database/database.dart`:

```dart
/// Deletes all library data (works, authors, editions, entries).
Future<void> resetLibrary() async {
  await transaction(() async {
    // Delete in order respecting foreign keys
    await delete(userLibraryEntries).go();
    await delete(detectedItems).go();
    await delete(scanSessions).go();
    await delete(workAuthors).go();
    await delete(editions).go();
    await delete(authors).go();
    await delete(works).go();
  });
}

/// Gets the total book count.
Future<int> getBookCount() async {
  final result = await (selectOnly(works)..addColumns([works.id.count()])).getSingle();
  return result.read(works.id.count()) ?? 0;
}
```

---

### Step 5: Integrate Settings into Library Screen

Update `lib/features/library/screens/library_screen.dart`:

```dart
import '../../settings/screens/settings_screen.dart';

// In AppBar:
AppBar(
  title: const Text('Library'),
  actions: [
    IconButton(
      icon: const Icon(Icons.settings),
      tooltip: 'Settings',
      onPressed: () {
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          useSafeArea: true,
          builder: (context) => const SettingsScreen(),
        );
      },
    ),
  ],
),
```

---

### Step 6: Update App with Theme Provider

Update `lib/app/app.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/providers/theme_provider.dart';
import 'router.dart';

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final lightTheme = ref.watch(lightThemeProvider);
    final darkTheme = ref.watch(darkThemeProvider);

    return MaterialApp.router(
      title: 'BooksTrack',
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      routerConfig: router,
    );
  }
}
```

---

## Testing Strategy

### Unit Tests

- [ ] ThemeNotifier persists theme to SharedPreferences
- [ ] ThemeNotifier loads theme on init
- [ ] FeatureFlagsNotifier persists and loads flags
- [ ] resetLibrary deletes all tables

### Widget Tests

- [ ] SettingsScreen renders all sections
- [ ] Theme picker shows all 5 themes
- [ ] Reset confirmation dialog appears
- [ ] Storage info displays book count

### Integration Tests

- [ ] Change theme → App UI updates immediately
- [ ] Reset library → All data deleted, empty state shown

---

## Files to Create

| File | Type | Description |
|------|------|-------------|
| `lib/core/providers/theme_provider.dart` | Provider | Theme management |
| `lib/core/providers/feature_flags_provider.dart` | Provider | Feature flags |
| `lib/features/settings/screens/settings_screen.dart` | Screen | Settings UI |

---

## Files to Modify

| File | Change |
|------|--------|
| `lib/app/app.dart` | Use theme providers |
| `lib/core/data/database/database.dart` | Add resetLibrary, getBookCount |
| `lib/features/library/screens/library_screen.dart` | Add settings button |

---

## Next Steps

After implementing Settings:
1. **08-BOOK-DETAIL.md** - Book detail and editing screen
2. Polish theme transitions and animations

---

**Document Status:** Ready for Implementation
**Last Updated:** December 26, 2025
