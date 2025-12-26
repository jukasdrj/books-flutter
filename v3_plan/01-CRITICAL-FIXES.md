# 01 - Critical Fixes

**Priority:** P0 - Blocking
**Estimated Effort:** 2-4 hours
**Prerequisite:** None

---

## Problem Summary

The Flutter app has structural issues that prevent it from building:

1. **Import Path Mismatch** - Router and barrel exports reference non-existent directories
2. **Widget Duplication** - BookCard/BookGridCard exist in two locations
3. **Barrel Export Errors** - Feature exports reference wrong paths

---

## Issue 1: Import Path Mismatch

### Current State (Broken)

**Router references:**
```dart
// lib/app/router.dart (CURRENT - BROKEN)
import '../features/library/presentation/screens/library_screen.dart';
import '../features/search/presentation/screens/search_screen.dart';
// ... etc
```

**Actual file locations:**
```
lib/features/library/screens/library_screen.dart  ✓ EXISTS
lib/features/search/screens/search_screen.dart    ✓ EXISTS
lib/features/scanner/screens/scanner_screen.dart  ✓ EXISTS
lib/features/insights/screens/insights_screen.dart ✓ EXISTS
```

### Fix Required

Update `lib/app/router.dart` to use correct paths:

```dart
// lib/app/router.dart (FIXED)
import '../features/library/screens/library_screen.dart';
import '../features/search/screens/search_screen.dart';
import '../features/scanner/screens/scanner_screen.dart';
import '../features/insights/screens/insights_screen.dart';
```

**Alternative:** Use barrel exports (cleaner):
```dart
import '../features/library/library.dart';
import '../features/search/search.dart';
import '../features/scanner/scanner.dart';
import '../features/insights/insights.dart';
```

---

## Issue 2: Barrel Export Paths

### Current State (Broken)

**lib/features/library/library.dart:**
```dart
// BROKEN - references non-existent paths
export 'presentation/screens/library_screen.dart';
export 'presentation/widgets/book_card.dart';
export 'presentation/widgets/book_grid_card.dart';
```

### Fix Required

```dart
// lib/features/library/library.dart (FIXED)
export 'screens/library_screen.dart';
export 'widgets/book_card.dart';
export 'widgets/book_grid_card.dart';
export 'providers/library_providers.dart';
export 'providers/book_actions_provider.dart';
```

### All Barrel Exports to Fix

| File | Current Issue | Fix |
|------|---------------|-----|
| `lib/features/library/library.dart` | `presentation/screens/` | `screens/` |
| `lib/features/search/search.dart` | `presentation/screens/` | `screens/` |
| `lib/features/scanner/scanner.dart` | `presentation/screens/` | `screens/` |
| `lib/features/insights/insights.dart` | `presentation/screens/` | `screens/` |
| `lib/features/bookshelf_scanner/bookshelf_scanner.dart` | References non-existent screen | Create placeholder or remove |
| `lib/features/review_queue/review_queue.dart` | References non-existent screen | Create placeholder or remove |

---

## Issue 3: Widget Duplication

### Current State

Widgets exist in two locations:
```
lib/shared/widgets/cards/book_card.dart
lib/features/library/widgets/book_card.dart  (DUPLICATE)

lib/shared/widgets/cards/book_grid_card.dart
lib/features/library/widgets/book_grid_card.dart  (DUPLICATE)
```

### Fix Required

1. **Keep** widgets in `lib/shared/widgets/cards/`
2. **Delete** duplicates in `lib/features/library/widgets/`
3. **Update** imports throughout codebase

**Canonical location:**
```
lib/shared/widgets/cards/
├── book_card.dart
└── book_grid_card.dart
```

**Delete:**
```
lib/features/library/widgets/book_card.dart
lib/features/library/widgets/book_grid_card.dart
```

---

## Issue 4: Missing Placeholder Screens

### Bookshelf Scanner

**Current:** Barrel export references non-existent file
**Fix:** Create placeholder or remove barrel export until implemented

```dart
// lib/features/bookshelf_scanner/screens/bookshelf_scanner_screen.dart
import 'package:flutter/material.dart';

class BookshelfScannerScreen extends StatelessWidget {
  const BookshelfScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Bookshelf Scanner')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.camera_alt, size: 64),
            SizedBox(height: 16),
            Text('AI Bookshelf Scanner'),
            SizedBox(height: 8),
            Text('Coming soon - photograph your bookshelf'),
          ],
        ),
      ),
    );
  }
}
```

### Review Queue

Same pattern - create placeholder:

```dart
// lib/features/review_queue/screens/review_queue_screen.dart
import 'package:flutter/material.dart';

class ReviewQueueScreen extends StatelessWidget {
  const ReviewQueueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Review Queue')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.rate_review, size: 64),
            SizedBox(height: 16),
            Text('Review Queue'),
            SizedBox(height: 8),
            Text('Books needing verification will appear here'),
          ],
        ),
      ),
    );
  }
}
```

---

## Implementation Checklist

### Step 1: Fix Router Imports
- [ ] Update `lib/app/router.dart` with correct paths
- [ ] Verify all 4 screen imports resolve

### Step 2: Fix Barrel Exports
- [ ] Update `lib/features/library/library.dart`
- [ ] Update `lib/features/search/search.dart`
- [ ] Update `lib/features/scanner/scanner.dart`
- [ ] Update `lib/features/insights/insights.dart`

### Step 3: Remove Widget Duplicates
- [ ] Delete `lib/features/library/widgets/book_card.dart`
- [ ] Delete `lib/features/library/widgets/book_grid_card.dart`
- [ ] Update imports in `library_screen.dart` to use `shared/widgets/cards/`

### Step 4: Create Missing Placeholders
- [ ] Create `lib/features/bookshelf_scanner/screens/` directory
- [ ] Create `bookshelf_scanner_screen.dart` placeholder
- [ ] Create `lib/features/review_queue/screens/` directory
- [ ] Create `review_queue_screen.dart` placeholder
- [ ] Update barrel exports

### Step 5: Verify Build
- [ ] Run `flutter pub get`
- [ ] Run `dart run build_runner build --delete-conflicting-outputs`
- [ ] Run `flutter analyze`
- [ ] Run `flutter run -d <device>` to verify app launches

---

## Verification Commands

```bash
# Clean and get dependencies
flutter clean
flutter pub get

# Generate code (Riverpod, Drift)
dart run build_runner build --delete-conflicting-outputs

# Check for issues
flutter analyze

# Run the app
flutter run -d macos  # or -d chrome, -d <device-id>
```

---

## Expected Outcome

After fixes:
- App builds without errors
- App launches to Library screen
- All 4 tabs are navigable
- No runtime import errors

---

## Files Modified

| File | Change |
|------|--------|
| `lib/app/router.dart` | Fix import paths |
| `lib/features/library/library.dart` | Fix barrel exports |
| `lib/features/search/search.dart` | Fix barrel exports |
| `lib/features/scanner/scanner.dart` | Fix barrel exports |
| `lib/features/insights/insights.dart` | Fix barrel exports |
| `lib/features/bookshelf_scanner/bookshelf_scanner.dart` | Fix barrel exports |
| `lib/features/review_queue/review_queue.dart` | Fix barrel exports |
| `lib/features/library/widgets/` | DELETE duplicates |
| `lib/features/bookshelf_scanner/screens/bookshelf_scanner_screen.dart` | CREATE placeholder |
| `lib/features/review_queue/screens/review_queue_screen.dart` | CREATE placeholder |

---

## Next Steps

After completing critical fixes:
1. Proceed to `02-SEARCH-FEATURE.md` for search implementation
2. Proceed to `08-BOOK-DETAIL.md` for book detail screen

---

**Document Status:** Ready for Implementation
**Last Updated:** December 26, 2025
