# BooksTrack Flutter - Production-Ready Development Plan

**Last Updated:** November 12, 2025
**Status:** Planning Phase - Expert Validated (Consensus: 8.5/10 confidence)
**Expert Review:** Validated by Gemini 2.5 Pro (9/10) + GPT-5 Pro (8/10)

---

## 🎯 Expert Consensus Summary

### ✅ Strong Points Validated
- **Excellent prioritization** - Performance fixes in Phase 1 addresses target user needs
- **Solid tech stack** - Mature, well-supported packages (go_router, riverpod, drift)
- **User-centric phasing** - Library → Search → AI Scanner matches user behavior
- **Realistic complexity management** - AI Scanner properly broken into 3-week phase
- **Clear technical guidance** - Package justifications prevent architectural debates

### ⚠️ Critical Improvements Required

**PRIORITY 1 - Must Fix Before Implementation:**

1. **Use StatefulShellRoute** (not ShellRoute)
   - Preserves tab state and navigation stacks
   - Standard for Material Design 3 bottom navigation
   - Change in Phase 1.4 routing setup

2. **Elevate DTOMapper Bug to P0**
   - Currently marked "LOW" - actually affects data correctness
   - Blocks Search and Scanner features
   - Must fix in Phase 1

3. **Add Web Support Strategy**
   - Drift: Add wasm setup for web compatibility
   - Scanner: Define fallback (file upload, hide tab on web)
   - Camera: Add camera_web or kIsWeb gating

4. **Normalize Review Queue Data Model**
   - Don't add review fields to Works table
   - Create: ScanSessions, DetectedItems tables
   - Benefits: multiple sessions, duplicates handling, cleaner separation

5. **Use Keyset Pagination** (not OFFSET)
   - OFFSET degrades with 500+ books
   - Use: `WHERE id < lastId ORDER BY id DESC LIMIT 50`
   - Add createdAt/id cursor and index

**PRIORITY 2 - Add to Phase 1:**

6. **CI/CD Pipeline** - Add early to catch issues
7. **Analytics/Crash Reporting** - firebase_analytics, Crashlytics/Sentry
8. **AsyncValueView Wrapper** - Riverpod loading/error/empty handler
9. **Skeleton Shimmer** - Perceived performance improvement
10. **Blurhash Placeholders** - Graceful image loading

---

## 📅 Revised 14-Week Development Plan

## Phase 1: Foundation (Week 1-3) - CRITICAL [+1 week buffer]

### 1.1 Critical Performance & Data Fixes
**Priority:** P0 - Blocks everything

- [ ] **Fix DTOMapper Bug** (4-6 hours) **[ELEVATED TO P0]**
  - Currently assumes author list order matches works
  - Require author IDs in API response DTOs
  - Update `dto_mapper.dart:30-34` logic
  - **Backend coordination required**
  - **Blocking:** Search, Scanner features

- [ ] **Batch Database Queries** (3-4 hours)
  - Refactor `database.dart:223` `watchAllWorks()`
  - Refactor `database.dart:322` `watchLibrary()`
  - Pattern: `select(authors)..where((t) => t.id.isIn(authorIds))`
  - **Reusable:** All list views

- [ ] **Implement Keyset Pagination** (6-8 hours) **[IMPROVED FROM OFFSET]**
  ```dart
  // Instead of: LIMIT 50 OFFSET 100
  // Use: WHERE id < lastId ORDER BY id DESC LIMIT 50
  Stream<List<WorkWithLibraryStatus>> watchLibrary({
    String? cursor,  // lastId from previous page
    int limit = 50,
  }) {
    final query = select(userLibraryEntries).join([...]);
    if (cursor != null) {
      query.where(userLibraryEntries.id.isSmallerThan(Value(cursor)));
    }
    query
      ..orderBy([OrderingTerm.desc(userLibraryEntries.id)])
      ..limit(limit);
    return query.watch().asyncMap(...);
  }
  ```
  - Add index on `id` and `createdAt`
  - Infinite scroll in UI using `ScrollController`
  - **Reusable:** Search results, Review Queue

- [ ] **Add Image Caching** (1-2 hours)
  ```dart
  // Replace in book_card.dart:99
  CachedNetworkImage(
    imageUrl: coverUrl,
    fit: BoxFit.cover,
    memCacheWidth: 200,  // Optimize decode size
    memCacheHeight: 300,
    placeholder: (context, url) => BlurhashPlaceholder(hash: book.blurhash),
    errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
  )
  ```
  - Apply to `book_grid_card.dart` too
  - **Reusable:** All book cover displays

### 1.2 Add Missing Dependencies & Infrastructure

```yaml
# Add to pubspec.yaml dependencies:
fl_chart: ^0.68.0                    # Statistics/diversity charts
cached_network_image: ^3.3.0         # Book cover performance
flutter_cache_manager: ^3.3.0        # Configure disk cache limits
permission_handler: ^11.0.0          # Camera permissions UX
share_plus: ^7.2.0                   # Share library stats
url_launcher: ^6.2.0                 # External links
flutter_dotenv: ^5.1.0               # Environment config (mobile/desktop)
flutter_blurhash: ^0.8.0             # Image placeholders
shimmer: ^3.0.0                      # Skeleton loading
drift_dev: ^2.14.0                   # Keep for codegen
sqlite3_web: ^0.1.0                  # Web support for Drift (NEW)

# Add to dependencies for web:
drift: ^2.14.0
  # Configure with wasm for web builds
  # See: https://drift.simonbinder.eu/web/
```

**CI/CD Setup** (4-6 hours) **[NEW - MOVED TO PHASE 1]**
```yaml
# .github/workflows/flutter-ci.yml
name: Flutter CI
on: [push, pull_request]
jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - uses: subosito/flutter-action@v2
      - run: flutter pub get
      - run: dart run build_runner build --delete-conflicting-outputs
      - run: flutter analyze
      - run: flutter test --coverage
      - uses: codecov/codecov-action@v3
```

**Analytics & Crash Reporting** (2-3 hours) **[NEW - MOVED TO PHASE 1]**
```yaml
# Add to pubspec.yaml:
firebase_analytics: ^10.7.0
firebase_crashlytics: ^3.4.0
```
```dart
// Initialize in main.dart after Firebase.initializeApp()
await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;

// Track key events early:
FirebaseAnalytics.instance.logEvent(
  name: 'library_view',
  parameters: {'books_count': books.length},
);
```

### 1.3 Create Shared Component Library

- [ ] **Directory Structure** (30 min)
  ```
  lib/shared/
    widgets/
      book_card.dart (MOVE from lib/features/library/widgets/)
      book_grid_card.dart (MOVE from lib/features/library/widgets/)
      error_state.dart
      empty_state.dart
      loading_overlay.dart
      async_value_view.dart (NEW - Riverpod wrapper)
      skeleton_shimmer.dart (NEW)
      result_badge.dart (NEW - source/confidence badges)
    services/
      snackbar_service.dart (NEW - consistent messaging)
    constants/
      app_constants.dart
    theme/
      theme_extensions.dart
  ```

- [ ] **AsyncValueView Widget** (2 hours) **[NEW - FROM EXPERT FEEDBACK]**
  ```dart
  // lib/shared/widgets/async_value_view.dart
  class AsyncValueView<T> extends StatelessWidget {
    final AsyncValue<T> value;
    final Widget Function(T data) data;
    final Widget Function(Object error, StackTrace stackTrace)? error;
    final Widget? loading;

    // Standardized Riverpod async handling
    // Reuses ErrorState, EmptyState, LoadingOverlay
  }
  ```
  **Used in:** All screens with async data

- [ ] **Skeleton Shimmer** (1 hour) **[NEW]**
  ```dart
  // lib/shared/widgets/skeleton_shimmer.dart
  class SkeletonBookCard extends StatelessWidget {
    // Shimmer effect for loading book cards
    // Shows perceived performance improvement
  }
  ```

- [ ] **Result Badge Widget** (30 min) **[NEW]**
  ```dart
  // lib/shared/widgets/result_badge.dart
  class ResultBadge extends StatelessWidget {
    final String label; // "Google Books", "85% confidence"
    final Color color;

    // Small colored badge for sources/confidence
  }
  ```
  **Used in:** Search results, Scan results, Review Queue

- [ ] **Error State, Empty State, Loading Overlay** (3 hours)
  - Same as original TODO.md specs
  - Used everywhere

### 1.4 Tab Navigation with go_router (REVISED)

- [ ] **Router Configuration** (5-7 hours) **[UPDATED WITH StatefulShellRoute]**
  ```dart
  // lib/core/routing/app_router.dart
  final appRouter = GoRouter(
    initialLocation: '/library',
    routes: [
      StatefulShellRoute.indexedStack(  // CHANGED FROM ShellRoute
        builder: (context, state, navigationShell) {
          return MainScaffold(navigationShell: navigationShell);
        },
        branches: [
          StatefulShellBranch(
            routes: [GoRoute(path: '/library', builder: (c, s) => LibraryScreen())],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/search', builder: (c, s) => SearchScreen())],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: '/scanner',
                builder: (c, s) => kIsWeb
                  ? WebScannerFallback()  // File upload for web
                  : ScannerScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [GoRoute(path: '/insights', builder: (c, s) => InsightsScreen())],
          ),
        ],
      ),
      // Detail routes (outside shell)
      GoRoute(path: '/book/:id', builder: (c, s) => BookDetailScreen(...)),
      GoRoute(path: '/review-queue', builder: (c, s) => ReviewQueueScreen()),
    ],
  );
  ```
  **Key Change:** `StatefulShellRoute.indexedStack` preserves tab state and navigation stacks

- [ ] **Bottom Navigation Bar** (2 hours)
  ```dart
  // lib/core/widgets/main_scaffold.dart
  class MainScaffold extends StatelessWidget {
    final StatefulNavigationShell navigationShell;

    // Material 3 NavigationBar with 4 tabs
    // Conditionally hide Scanner tab on web
  }
  ```

- [ ] **Web Platform Adaptations** (3-4 hours) **[NEW]**
  - Drift wasm setup for web database
  - Hide/adapt Scanner tab on web (use `kIsWeb`)
  - File upload fallback for web bookshelf scanning
  - Environment config via `--dart-define` (flutter_dotenv doesn't work on web)

### 1.5 Review Queue Data Model **[NEW - CRITICAL ARCHITECTURE]**

- [ ] **Normalize Review Queue Tables** (4-6 hours) **[EXPERT RECOMMENDATION]**
  ```dart
  // lib/core/database/database.dart

  // NEW TABLE: Track scan sessions
  class ScanSessions extends Table {
    TextColumn get id => text()();
    DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
    IntColumn get totalDetected => integer()();
    IntColumn get reviewedCount => integer().withDefault(const Constant(0))();
    @override
    Set<Column> get primaryKey => {id};
  }

  // NEW TABLE: Individual detected items (replaces review fields in Works)
  class DetectedItems extends Table {
    TextColumn get id => text()();
    TextColumn get sessionId => text().references(ScanSessions, #id, onDelete: KeyAction.cascade)();
    TextColumn get workId => text().references(Works, #id, onDelete: KeyAction.setNull).nullable()();

    // AI detection data
    TextColumn get titleGuess => text()();
    TextColumn get authorGuess => text()();
    RealColumn get confidence => real()();

    // Image data
    TextColumn get imagePath => text().nullable()();
    TextColumn get boundingBox => text().nullable()(); // JSON

    // Review status
    IntColumn get reviewStatus => intEnum<ReviewStatus>().withDefault(const Constant(1))(); // needsReview

    DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
    DateTimeColumn get reviewedAt => dateTime().nullable()();

    @override
    Set<Column> get primaryKey => {id};
  }

  // REMOVE from Works table:
  // - reviewStatus
  // - originalImagePath
  // - boundingBox
  // These belong to DetectedItems, not canonical Works
  ```

  **Benefits:**
  - Multiple scan sessions tracked separately
  - Handles duplicates across sessions
  - User-specific review state (doesn't pollute Works)
  - Cleaner data model separation

---

## Phase 2: Search & Discovery (Week 4-6) - HIGH [+0.5 week buffer]

### 2.1 Search Feature
(Same as original TODO.md - no changes needed)

### 2.2 Mobile Scanner
**Time Adjustment:** 2.5 weeks total (was 2 weeks)
- Barcode permission edge cases need buffer
- Cross-device testing takes longer than estimated

---

## Phase 3: Bookshelf AI Scanner (Week 7-11) - HIGH [+1-2 week buffer]

**Time Adjustment:** 4-5 weeks total (was 3 weeks)
- Batch mode complexity underestimated
- WebSocket robustness + error handling need more time
- Review Queue with new data model adds complexity

### 3.1 Camera & Capture
(Same as original TODO.md)

### 3.2 WebSocket Processing
(Same as original TODO.md)

### 3.3 Review Queue (UPDATED WITH NEW DATA MODEL)

- [ ] **Review Queue Screen** (4 hours)
  ```dart
  // lib/features/review_queue/screens/review_queue_screen.dart
  class ReviewQueueScreen extends ConsumerWidget {
    // Query DetectedItems where reviewStatus == needsReview
    // Group by sessionId for batch review
    // Material Badge in AppBar showing count
  }
  ```

- [ ] **Correction Screen** (10-12 hours) **[UPDATED]**
  ```dart
  // lib/features/review_queue/screens/correction_screen.dart
  class CorrectionScreen extends ConsumerStatefulWidget {
    final String sessionId;

    // PageView for swipe navigation
    // Query DetectedItems for this session
    // Show: cropped image, titleGuess/authorGuess in TextFormFields
    // On save: Update reviewStatus, link to Work, create UserLibraryEntry
    // On "Mark Verified": Keep guesses, just update status
  }
  ```

- [ ] **Session Management** (3-4 hours) **[NEW]**
  ```dart
  // lib/features/review_queue/providers/session_provider.dart
  @riverpod
  class SessionNotifier extends _$SessionNotifier {
    // Track active scan session
    // Manage detected items
    // Handle batch import after review
  }
  ```

---

## Phase 4: Insights & Analytics (Week 12-13) - MEDIUM

(Same as original TODO.md - no changes needed)

---

## Phase 5: Settings & Themes (Week 14) - LOW

(Same as original TODO.md - no changes needed)

---

## Phase 6: Optimization & Polish (Ongoing)

### Additional Testing Requirements

- [ ] **Critical Path E2E Tests** (Prioritize over coverage targets)
  - Scan → Review → Add to Library
  - Search → Add to Library
  - Barcode → Add to Library
  - Coverage targets are ambitious - focus on critical flows first

---

## 🔧 Revised Reusable Components

| Component | Location | Used In | Priority | Status |
|-----------|----------|---------|----------|--------|
| **BookCard** | `lib/shared/widgets/` | Library, Search, Review Queue, Insights | P0 | ✅ Built (needs move) |
| **AsyncValueView** | `lib/shared/widgets/` | All async screens | P0 | ❌ New requirement |
| **SkeletonShimmer** | `lib/shared/widgets/` | All list views | P1 | ❌ New requirement |
| **ResultBadge** | `lib/shared/widgets/` | Search, Scan, Review | P1 | ❌ New requirement |
| **ErrorState** | `lib/shared/widgets/` | All screens | P0 | ❌ Not built |
| **EmptyState** | `lib/shared/widgets/` | All list views | P0 | ❌ Not built |
| **LoadingOverlay** | `lib/shared/widgets/` | Async operations | P0 | ❌ Not built |
| **SnackbarService** | `lib/shared/services/` | Consistent messaging | P1 | ❌ New requirement |

---

## 📦 Updated Technology Stack

### Package Version Verification Required

```yaml
# Verify these are latest stable versions:
go_router: ^13.0.0  # Check if newer than ^12.0.0 (pubspec currently has ^12.0.0)
  # Ensure StatefulShellRoute.indexedStack support

riverpod: ^2.5.0  # Verify latest
riverpod_generator: ^2.4.0

drift: ^2.16.0  # Verify latest with web/wasm support
drift_flutter: ^0.2.0
sqlite3_web: ^0.1.0  # NEW for web

mobile_scanner: ^5.0.0  # Verify latest ^4.x or ^5.x
  # Check web compatibility or fallback strategy

fl_chart: ^0.68.0  # Verify latest

camera: ^0.11.0  # Current
camera_web: ^0.3.0  # NEW for web compatibility

dio: ^5.4.0  # Current
```

---

## ⚠️ Revised Known Issues & Priorities

### CRITICAL (P0) - Fix in Phase 1

1. **DTOMapper Bug** ~~(was LOW)~~ **→ P0**
   - **Impact:** Data correctness across Search/Scanner
   - **Fix:** Require author IDs in API response, update mapper logic
   - **Blocking:** Search, Scanner

2. **StatefulShellRoute Migration**
   - **Impact:** Tab state loss, poor UX
   - **Fix:** Replace ShellRoute in routing config
   - **Effort:** 1 day

3. **Web Compatibility**
   - **Impact:** Can't deploy to web (target platform)
   - **Fix:** Drift wasm, Scanner fallback, kIsWeb gating
   - **Effort:** 3-4 days

4. **Review Queue Data Model**
   - **Impact:** Data pollution, can't handle multiple sessions
   - **Fix:** Create ScanSessions/DetectedItems tables
   - **Effort:** 1-2 days

### HIGH (P1) - Fix in Phase 1

5. **Keyset Pagination** (upgraded from medium)
6. **Image Caching** (already P0)
7. **N+1 Queries** (already P0)
8. **CI/CD** (moved to Phase 1)
9. **Analytics** (moved to Phase 1)

---

## 📈 Success Metrics (Unchanged)

(Same as original TODO.md)

---

## 🚀 Immediate Actions (Updated)

### Week 1 - Foundation Setup

**Day 1-2: Critical Fixes**
```bash
# 1. Add all missing dependencies
flutter pub add cached_network_image flutter_cache_manager \
  permission_handler share_plus url_launcher flutter_dotenv \
  flutter_blurhash shimmer sqlite3_web firebase_analytics \
  firebase_crashlytics fl_chart

# 2. Fix DTOMapper bug (coordinate with backend team)
# 3. Replace Image.network with CachedNetworkImage
# 4. Batch database queries refactor
```

**Day 3-4: Data Model Updates**
```bash
# 5. Create ScanSessions and DetectedItems tables
# 6. Remove review fields from Works table
# 7. Implement keyset pagination
dart run build_runner build --delete-conflicting-outputs
```

**Day 5-7: Infrastructure**
```bash
# 8. Create shared widget library
mkdir -p lib/shared/{widgets,services,constants,theme}
git mv lib/features/library/widgets/book_card.dart lib/shared/widgets/
git mv lib/features/library/widgets/book_grid_card.dart lib/shared/widgets/

# 9. Set up CI/CD (.github/workflows/flutter-ci.yml)
# 10. Initialize analytics and crash reporting
# 11. Create .env files (.gitignore them)
echo "API_BASE_URL=https://api-dev.example.com" > .env
echo ".env" >> .gitignore
```

**Week 2: Tab Navigation & Web Support**
```bash
# 12. Implement StatefulShellRoute (not ShellRoute)
# 13. Add web adaptations (kIsWeb gating)
# 14. Configure Drift for web (wasm setup)
# 15. Test on all platforms
flutter run -d chrome  # Web
flutter run -d macos   # Desktop (when gRPC issue resolved)
```

---

## 📊 Expert Consensus Scores

| Aspect | Gemini 2.5 Pro (FOR) | GPT-5 Pro (AGAINST) | Average |
|--------|---------------------|---------------------|---------|
| **Technical Feasibility** | 9/10 | 8/10 | **8.5/10** |
| **Phase Prioritization** | 9/10 | 8/10 | **8.5/10** |
| **Package Choices** | 9/10 | 8/10 | **8.5/10** |
| **Time Estimates** | 9/10 | 7/10 | **8.0/10** |
| **Architecture** | 9/10 | 7/10 | **8.0/10** |
| **Overall Confidence** | 9/10 | 8/10 | **8.5/10** |

**Consensus:** Strong, production-ready plan with specific improvements implemented.

---

## 🎯 Key Changes from Original TODO

1. ✅ **StatefulShellRoute** replaces ShellRoute
2. ✅ **DTOMapper bug** elevated to P0 (was LOW)
3. ✅ **Keyset pagination** replaces OFFSET pagination
4. ✅ **Review Queue normalized** into ScanSessions/DetectedItems tables
5. ✅ **Web support** added (Drift wasm, Scanner fallback, kIsWeb)
6. ✅ **CI/CD** moved to Phase 1 (was Phase 6)
7. ✅ **Analytics/Crashlytics** moved to Phase 1 (was Phase 6)
8. ✅ **AsyncValueView** added (Riverpod wrapper)
9. ✅ **Skeleton shimmer** added (perceived performance)
10. ✅ **Result badges** added (reusable component)
11. ✅ **Blurhash placeholders** added (image loading)
12. ✅ **Time buffers** added to phases 2-3
13. ✅ **Package versions** flagged for verification

---

**This plan is now validated by expert consensus and ready for production implementation.**

**Last Updated:** November 12, 2025
**Validated By:** Gemini 2.5 Pro + GPT-5 Pro (Multi-Model Consensus)
**Confidence:** 8.5/10 (High)
**Status:** ✅ Production-Ready
