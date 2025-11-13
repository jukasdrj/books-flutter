# BooksTrack Flutter - Development Roadmap

**Last Updated:** November 12, 2025
**Status:** Planning Phase (37.5% PRD conversion complete, ~10% implementation)
**Target:** Full feature parity with iOS version + cross-platform (Android/iOS/Web)

---

## 📊 Current State

### ✅ Completed (10%)
- **Database Schema v2** - UserLibraryEntries table with reading status tracking
- **Library Feature (60%)** - Filtering, sorting, book cards (list/grid views)
- **Riverpod State Management** - Library providers with code generation
- **Firebase Setup** - Multi-platform configuration (iOS, macOS, Android, Web)
- **Material Design 3** - Seed color #1976D2, proper theming foundation

### 🚧 In Progress
- **Tab Navigation** - go_router infrastructure (not started)

### ❌ Not Started (90%)
- Search (multi-mode: title, ISBN, author)
- Mobile Scanner (barcode scanning)
- Bookshelf AI Scanner (camera + Gemini 2.0 Flash)
- Review Queue (human-in-the-loop corrections)
- Reading Statistics (insights, charts)
- Diversity Insights (cultural/gender analytics)
- Settings (themes, preferences)

---

## 🎯 Strategic Priorities

### CRITICAL Performance Issues (Fix Immediately)
1. **N+1 Query Problem** - `database.dart:223, 322` fetches authors in loop (kills performance for 100+ books)
2. **No Image Caching** - `book_card.dart:99` uses `Image.network` (re-downloads every time)
3. **No Pagination** - `database.dart:310` loads ALL library entries at once (will crash with 500+ books)

### High-Impact Architecture Gaps
1. **Missing Shared Component Library** - `BookCard` is in `lib/features/library/` (will cause duplication)
2. **No Error/Empty/Loading States** - Every screen rebuilds these widgets
3. **Hardcoded API URL** - `api_client.dart:9` has placeholder URL (needs environment config)

---

## 📅 12-Week Development Plan

## Phase 1: Foundation (Week 1-2) - CRITICAL

### 1.1 Fix Performance Bottlenecks
**Priority:** P0 - Blocks scalability

- [ ] **Batch Database Queries** (2-3 hours)
  - Refactor `database.dart:223` `watchAllWorks()` - fetch all authors in single query
  - Refactor `database.dart:322` `watchLibrary()` - batch author fetches
  - Use `select(authors)..where((t) => t.id.isIn(authorIds))` pattern
  - **Reusable:** This pattern applies to all list views

- [ ] **Implement Pagination** (4-6 hours)
  - Add `limit` and `offset` parameters to `watchLibrary()`
  - Implement infinite scroll in `library_screen.dart` using `ScrollController`
  - Load 50 books per page
  - **Reusable:** Pagination pattern for Search results, Review Queue

- [ ] **Add Image Caching** (1 hour)
  - Add `cached_network_image: ^3.3.0` to `pubspec.yaml`
  - Replace `Image.network` in `book_card.dart:99` with `CachedNetworkImage`
  - Apply to `book_grid_card.dart` too
  - **Reusable:** All book cover displays app-wide

### 1.2 Add Missing Dependencies
**Priority:** P0 - Required for features

```yaml
# Add to pubspec.yaml dependencies:
fl_chart: ^0.68.0                    # Charts for statistics/diversity insights
cached_network_image: ^3.3.0         # Book cover performance
permission_handler: ^11.0.0          # Camera permissions UX
share_plus: ^7.2.0                   # Share library stats
url_launcher: ^6.2.0                 # External links (settings, about)
flutter_dotenv: ^5.1.0               # Environment config (.env files)
```

### 1.3 Create Shared Component Library
**Priority:** P0 - Prevents code duplication

- [ ] **Directory Structure** (30 min)
  ```
  lib/shared/
    widgets/
      error_state.dart
      empty_state.dart
      loading_overlay.dart
      book_card.dart (MOVE from lib/features/library/widgets/)
      book_grid_card.dart (MOVE from lib/features/library/widgets/)
    constants/
      app_constants.dart (durations, sizes, breakpoints)
    theme/
      theme_extensions.dart (custom colors, text styles)
  ```

- [ ] **Error State Widget** (1 hour)
  ```dart
  // lib/shared/widgets/error_state.dart
  class ErrorState extends StatelessWidget {
    final String message;
    final VoidCallback? onRetry;

    // Reusable error UI with Material 3 styling
    // Icon, message, retry button
  }
  ```
  **Used in:** Search, Scanner, Library, Insights (everywhere)

- [ ] **Empty State Widget** (1 hour)
  ```dart
  // lib/shared/widgets/empty_state.dart
  class EmptyState extends StatelessWidget {
    final String title;
    final String message;
    final IconData icon;
    final VoidCallback? onAction;

    // Reusable empty list UI
  }
  ```
  **Used in:** Library (no books), Search (no results), Review Queue (all cleared)

- [ ] **Loading Overlay** (30 min)
  ```dart
  // lib/shared/widgets/loading_overlay.dart
  class LoadingOverlay extends StatelessWidget {
    final String? message;

    // Consistent loading spinner with optional progress text
  }
  ```
  **Used in:** AI scanning, search, data sync

### 1.4 Tab Navigation with go_router
**Priority:** P0 - Blocks all features

- [ ] **Router Configuration** (4-6 hours)
  ```dart
  // lib/core/routing/app_router.dart
  final appRouter = GoRouter(
    initialLocation: '/library',
    routes: [
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(path: '/library', builder: (c, s) => LibraryScreen()),
          GoRoute(path: '/search', builder: (c, s) => SearchScreen()),
          GoRoute(path: '/scanner', builder: (c, s) => ScannerScreen()),
          GoRoute(path: '/insights', builder: (c, s) => InsightsScreen()),
        ],
      ),
      // Detail routes
      GoRoute(path: '/book/:id', builder: (c, s) => BookDetailScreen(...)),
      GoRoute(path: '/review-queue', builder: (c, s) => ReviewQueueScreen()),
    ],
  );
  ```

- [ ] **Bottom Navigation Bar** (2 hours)
  ```dart
  // lib/core/widgets/main_scaffold.dart
  class MainScaffold extends ConsumerWidget {
    // Material 3 NavigationBar with 4 tabs
    // Library, Search, Scanner, Insights
    // Active tab state persisted
  }
  ```

- [ ] **Deep Link Handling** (2 hours)
  - Configure iOS/Android deep links
  - Handle `/book/:id` for sharing
  - Handle `/scanner` for quick access

---

## Phase 2: Search & Discovery (Week 3-4) - HIGH

### 2.1 Search Feature
**Priority:** P1 - Most used after Library

- [ ] **Search Screen UI** (6-8 hours)
  ```dart
  // lib/features/search/screens/search_screen.dart
  class SearchScreen extends ConsumerStatefulWidget {
    // Material 3 SearchBar (SearchAnchor)
    // Search mode chips: Title, ISBN, Author, Advanced
    // Debounced search (300ms using Timer)
    // Results using SharedBookCard widget
  }
  ```

- [ ] **Search Provider** (4 hours)
  ```dart
  // lib/features/search/providers/search_provider.dart
  @riverpod
  class SearchNotifier extends _$SearchNotifier {
    // State: initial, searching, results, error, empty
    // Methods: searchByTitle, searchByISBN, searchByAuthor, searchAdvanced
    // Debouncing logic
  }
  ```

- [ ] **API Integration** (2 hours)
  ```dart
  // lib/core/services/book_search_api_service.dart
  class BookSearchAPIService {
    // GET /v1/search/title?q={query}
    // GET /v1/search/isbn?isbn={isbn}
    // GET /v1/search/advanced?title={title}&author={author}
    // Uses Dio with 6-hour cache (title/advanced), 7-day (ISBN)
  }
  ```

- [ ] **Search Result Card** (Reuse SharedBookCard)
  - Same BookCard from library
  - Add "Add to Library" button
  - Show source badge (Google Books, Open Library)

### 2.2 Mobile Scanner (Barcode Scanning)
**Priority:** P1 - Quick book addition

- [ ] **Barcode Scanner Screen** (4-6 hours)
  ```dart
  // lib/features/search/screens/barcode_scanner_screen.dart
  class BarcodeScannerScreen extends StatefulWidget {
    // MobileScanner widget with overlay
    // Auto-detect ISBN (EAN-13, EAN-8, UPC-E)
    // Vibration feedback on scan
    // Instant search on detect
  }
  ```

- [ ] **Permission Handling** (2 hours)
  ```dart
  // lib/core/services/permission_service.dart
  class PermissionService {
    // Check camera permission
    // Request with permission_handler
    // Handle denial → show settings link
    // Reusable for gallery access too
  }
  ```

- [ ] **ISBN Validation** (1 hour)
  ```dart
  // lib/core/utils/isbn_validator.dart
  class ISBNValidator {
    static bool isValid(String barcode) {
      // Validate ISBN-10/ISBN-13 checksum
      // Prevent false positives from non-book barcodes
    }
  }
  ```

**Target:** <3s scan-to-results (per Mobile-Scanner-PRD-Flutter.md)

---

## Phase 3: Bookshelf AI Scanner (Week 5-7) - HIGH

### 3.1 Camera & Capture
**Priority:** P1 - Core differentiator

- [ ] **Scanner Screen** (8-10 hours)
  ```dart
  // lib/features/bookshelf_scanner/screens/scanner_screen.dart
  class ScannerScreen extends StatefulWidget {
    // CameraController from camera package
    // Live preview with grid overlay (guides for shelf alignment)
    // Capture button (Material FilledButton)
    // Batch mode: capture up to 5 photos
    // Image compression before upload
  }
  ```

- [ ] **Image Upload to R2** (4 hours)
  ```dart
  // lib/features/bookshelf_scanner/services/image_upload_service.dart
  class ImageUploadService {
    // Upload to Cloudflare R2
    // Parallel uploads for batch mode
    // Progress tracking
    // Retry logic
  }
  ```

### 3.2 WebSocket Processing
**Priority:** P1 - Real-time UX

- [ ] **Processing Screen** (6-8 hours)
  ```dart
  // lib/features/bookshelf_scanner/screens/processing_screen.dart
  class ProcessingScreen extends ConsumerWidget {
    // WebSocket connection for real-time updates
    // Progress: "Processing with AI... 45%"
    // "15/20 books enriched (75%)"
    // Animated LinearProgressIndicator
    // Keep-alive pings (30s+ scans)
  }
  ```

- [ ] **WebSocket Service** (6 hours)
  ```dart
  // lib/features/bookshelf_scanner/services/websocket_service.dart
  class WebSocketService {
    // Connect to wss://api.example.com/ws/scan/{sessionId}
    // Parse JSON progress messages
    // Auto-fallback to HTTP polling on failure
    // 2s polling interval
  }
  ```

- [ ] **Scanner Provider** (4 hours)
  ```dart
  // lib/features/bookshelf_scanner/providers/scanner_provider.dart
  @riverpod
  class ScannerNotifier extends _$ScannerNotifier {
    // State: idle, uploading, processing, complete, error
    // Progress tracking
    // Batch management
  }
  ```

### 3.3 Review Queue
**Priority:** P1 - Data quality

- [ ] **Review Queue Screen** (4 hours)
  ```dart
  // lib/features/review_queue/screens/review_queue_screen.dart
  class ReviewQueueScreen extends ConsumerWidget {
    // ListView of books with reviewStatus == needsReview
    // Material Badge in AppBar showing count
    // Tap to open CorrectionScreen
  }
  ```

- [ ] **Correction Screen** (8-10 hours)
  ```dart
  // lib/features/review_queue/screens/correction_screen.dart
  class CorrectionScreen extends ConsumerStatefulWidget {
    // PageView for swipe navigation (batch review)
    // Cropped spine image (using boundingBox from AI)
    // TextFormFields for title/author (pre-filled)
    // "Mark as Verified" vs "Save Edits" buttons
    // Update reviewStatus: verified or userEdited
  }
  ```

- [ ] **Image Cropping** (3 hours)
  ```dart
  // lib/features/review_queue/widgets/cropped_image_viewer.dart
  class CroppedImageViewer extends StatelessWidget {
    // Display temp image file with bounding box crop
    // Fallback to full image if box invalid
    // Cached with cached_network_image
  }
  ```

- [ ] **Image Cleanup Service** (2 hours)
  ```dart
  // lib/core/services/image_cleanup_service.dart
  class ImageCleanupService {
    // Delete temp images when all books from scan reviewed
    // Run on app start to clean orphaned files
    // Scheduled cleanup (weekly)
  }
  ```

**Target:** <60s total (AI + enrichment per Bookshelf-Scanner-PRD-Flutter.md)

---

## Phase 4: Insights & Analytics (Week 8-9) - MEDIUM

### 4.1 Reading Statistics
**Priority:** P2 - Engagement driver

- [ ] **Insights Screen** (6-8 hours)
  ```dart
  // lib/features/insights/screens/insights_screen.dart
  class InsightsScreen extends ConsumerWidget {
    // Vertical scrollable layout
    // Stat cards: Books Read This Year, Total Books, Currently Reading
    // Reading progress chart (LineChart)
    // Status distribution chart (PieChart)
  }
  ```

- [ ] **Stat Card Widget** (2 hours)
  ```dart
  // lib/shared/widgets/stat_card.dart
  class StatCard extends StatelessWidget {
    final String label;
    final String value;
    final IconData icon;
    final Color? color;

    // Material 3 Card with icon, label, value
    // Reusable for all statistics
  }
  ```

- [ ] **Reading Chart** (4 hours)
  ```dart
  // lib/features/insights/widgets/reading_chart.dart
  class ReadingChart extends StatelessWidget {
    // fl_chart LineChart
    // Books completed per month (last 12 months)
    // Material 3 colors
    // Touch interactions (show exact count)
  }
  ```

- [ ] **Status Distribution Chart** (3 hours)
  ```dart
  // lib/features/insights/widgets/status_chart.dart
  class StatusChart extends StatelessWidget {
    // fl_chart PieChart
    // Wishlist, To Read, Reading, Read percentages
    // Color-coded (matches status chips)
    // Tap to filter library (future)
  }
  ```

### 4.2 Diversity Insights
**Priority:** P2 - Unique feature

- [ ] **Diversity Chart** (6 hours)
  ```dart
  // lib/features/insights/widgets/diversity_chart.dart
  class DiversityChart extends StatelessWidget {
    // fl_chart DonutChart
    // Cultural regions (North America, Latin America, Europe, Africa, etc.)
    // Percentages with labels
    // Highlight gaps (e.g., "0% from Africa")
  }
  ```

- [ ] **Gender Chart** (4 hours)
  ```dart
  // lib/features/insights/widgets/gender_chart.dart
  class GenderChart extends StatelessWidget {
    // fl_chart PieChart
    // Male, Female, Non-Binary, Unknown
    // Percentages
  }
  ```

- [ ] **Language Chart** (4 hours)
  ```dart
  // lib/features/insights/widgets/language_chart.dart
  class LanguageChart extends StatelessWidget {
    // fl_chart BarChart
    // Languages with book counts
    // Top 10 languages
  }
  ```

- [ ] **Share Stats Feature** (2 hours)
  ```dart
  // Using share_plus package
  // "Share your reading stats" button
  // Generate image or text summary
  // Share to social media
  ```

**Reference:** Reading-Statistics-PRD.md, Diversity-Insights-PRD.md

---

## Phase 5: Settings & Themes (Week 10) - LOW

### 5.1 Settings Screen
**Priority:** P3 - Polish

- [ ] **Settings UI** (4-6 hours)
  ```dart
  // lib/features/settings/screens/settings_screen.dart
  class SettingsScreen extends ConsumerWidget {
    // Modal bottom sheet (not a tab)
    // Sections: Appearance, Data, About
    // Material 3 ListTile with switches/dropdowns
  }
  ```

- [ ] **Theme Selection** (4 hours)
  ```dart
  // lib/features/settings/providers/theme_provider.dart
  @riverpod
  class ThemeNotifier extends _$ThemeNotifier {
    // 5 themes with different seed colors:
    // - Liquid Blue (#1976D2) - default
    // - Cosmic Purple (#7B1FA2)
    // - Forest Green (#388E3C)
    // - Sunset Orange (#F57C00)
    // - Moonlight Silver (#607D8B)

    // State persisted with SharedPreferences
  }
  ```

- [ ] **Library Reset** (2 hours)
  - Confirmation dialog (AlertDialog)
  - Delete all UserLibraryEntries
  - Keep Works/Editions (for re-import)
  - Clear temp images

- [ ] **About Screen** (1 hour)
  - App version
  - Credits
  - Links: Privacy Policy, Terms, GitHub (url_launcher)
  - Licenses (show Flutter's LicensePage)

**Reference:** Settings-PRD.md

---

## Phase 6: Optimization & Polish (Week 11-12) - ONGOING

### 6.1 Performance Optimizations

- [ ] **Image Optimization**
  - `cached_network_image` everywhere (already in Phase 1)
  - Thumbnail sizes for list views (request smaller images from API)
  - Progressive loading (blur hash placeholders)

- [ ] **List Performance**
  - Pagination for Library (already in Phase 1)
  - Pagination for Search results (50 per page)
  - Pagination for Review Queue (50 per page)
  - Virtual scrolling for large lists

- [ ] **Database Optimization**
  - Batch queries (already in Phase 1)
  - Indexes on frequently queried columns (workId, status, createdAt)
  - Analyze query plans with Drift's explain

- [ ] **Build Size Optimization**
  - Tree-shaking unused code
  - Compress images/assets
  - Split APKs by ABI (Android)

### 6.2 Accessibility & Localization

- [ ] **Accessibility Audit**
  - Semantic labels for all widgets
  - TalkBack/VoiceOver testing
  - Keyboard navigation
  - High contrast mode
  - Font scaling support (respect system settings)

- [ ] **Internationalization**
  - `flutter_localizations` setup
  - ARB files for strings
  - Date/time formatting with `intl`
  - RTL language support

- [ ] **Error Recovery**
  - Offline mode (show cached data)
  - Retry mechanisms for API failures
  - Clear error messages (not tech jargon)
  - Sentry/Firebase Crashlytics integration

### 6.3 Testing

- [ ] **Unit Tests**
  - Providers (Riverpod testing)
  - Database queries (Drift testing)
  - Validators (ISBN, etc.)
  - DTOMapper conversions

- [ ] **Widget Tests**
  - BookCard rendering
  - Error/Empty/Loading states
  - Search functionality
  - Navigation flows

- [ ] **Integration Tests**
  - Full user flows (scan → review → library)
  - Search → add to library
  - Cross-tab navigation

---

## 🔧 Reusable Components Strategy

### Components to Build Once, Use Everywhere

| Component | Location | Used In | Status |
|-----------|----------|---------|--------|
| **BookCard** | `lib/shared/widgets/` | Library, Search, Review Queue, Insights | ✅ Built (needs move) |
| **BookGridCard** | `lib/shared/widgets/` | Library grid view, Search grid | ✅ Built (needs move) |
| **ErrorState** | `lib/shared/widgets/` | All screens | ❌ Not built |
| **EmptyState** | `lib/shared/widgets/` | Library, Search, Review Queue | ❌ Not built |
| **LoadingOverlay** | `lib/shared/widgets/` | AI scanning, Search, Sync | ❌ Not built |
| **StatCard** | `lib/shared/widgets/` | Insights, Library summary | ❌ Not built |
| **DTOMapper** | `lib/core/services/` | All API integrations | ✅ Exists |
| **APIClient** | `lib/core/services/` | All network calls | ✅ Exists |
| **PermissionService** | `lib/core/services/` | Camera, Gallery, Location | ❌ Not built |
| **ImageCleanupService** | `lib/core/services/` | Scanner, Review Queue | ❌ Not built |

---

## 📦 Technology Stack Decisions

### Why These Packages?

| Package | Why Chosen | Alternatives Considered |
|---------|------------|------------------------|
| **go_router** | Official Flutter team recommendation, declarative routing, deep links | auto_route (too complex), GetX (deprecated patterns) |
| **riverpod** | Type-safe, compile-time errors, best async support | Provider (outdated), Bloc (verbose) |
| **drift** | Type-safe SQL, reactive queries, better than raw SQLite | sqflite (no type safety), Isar (immature) |
| **dio** | Best HTTP client, interceptors, caching built-in | http (basic), Retrofit (too verbose) |
| **mobile_scanner** | Cross-platform, uses native APIs (ML Kit, AVFoundation) | qr_code_scanner (outdated), barcode_scan2 (unmaintained) |
| **fl_chart** | Most popular, Material 3 compatible, rich features | charts_flutter (abandoned), syncfusion (paid) |
| **cached_network_image** | Industry standard, automatic cache management | Custom solution (reinventing wheel) |
| **permission_handler** | Official, cross-platform, handles all permission types | platform-specific code (maintenance burden) |

### Modern Flutter Patterns to Follow

1. **Material Design 3**
   - `NavigationBar` (not `BottomNavigationBar`)
   - `FilledButton` (not `ElevatedButton`)
   - `FilterChip` (not `ChoiceChip` for filters)
   - `SearchAnchor` (not `TextField` with custom logic)

2. **Riverpod**
   - Code generation (`@riverpod`)
   - `ConsumerWidget` / `ConsumerStatefulWidget`
   - Avoid `ref.watch()` in build methods for mutations

3. **Drift**
   - Reactive queries (`.watch()`)
   - Transactions for multi-step operations
   - Batch inserts (`batch.insertAll()`)

4. **go_router**
   - `ShellRoute` for persistent UI (bottom nav)
   - Nested routes for detail screens
   - `GoRouterHelper` for type-safe navigation

---

## ⚠️ Known Issues & Technical Debt

### CRITICAL - Fix Before Adding Features

1. **N+1 Query Problem** (`database.dart:223, 322`)
   - **Impact:** 100+ books = 100+ queries = app freeze
   - **Fix:** Batch author queries (see Phase 1.1)
   - **Effort:** 2-3 hours
   - **Blocking:** All list views (Library, Search, Review Queue)

2. **No Image Caching** (`book_card.dart:99`)
   - **Impact:** Network traffic, slow scrolling, data usage
   - **Fix:** Replace `Image.network` with `CachedNetworkImage`
   - **Effort:** 1 hour
   - **Blocking:** All book displays

3. **No Pagination** (`database.dart:310`)
   - **Impact:** 500+ books = OOM crash, slow initial load
   - **Fix:** Add limit/offset, infinite scroll
   - **Effort:** 4-6 hours
   - **Blocking:** Large libraries (target users!)

### MEDIUM - Address in Phase 1

4. **BookCard in Wrong Directory**
   - **Impact:** Will duplicate code in Search, Review Queue
   - **Fix:** Move to `lib/shared/widgets/`
   - **Effort:** 15 min
   - **Blocking:** Feature development

5. **Hardcoded API URL** (`api_client.dart:9`)
   - **Impact:** Can't switch dev/staging/prod environments
   - **Fix:** Use `flutter_dotenv` with `.env` files
   - **Effort:** 1 hour
   - **Blocking:** Backend integration

6. **Missing Permission Handling**
   - **Impact:** Poor camera UX, App Store rejection risk
   - **Fix:** Integrate `permission_handler`
   - **Effort:** 2 hours
   - **Blocking:** Scanner feature

### LOW - Technical Debt

7. **DTOMapper Logic Bug** (`dto_mapper.dart:30-34`)
   - **Impact:** Incorrect author associations (assumes list order)
   - **Fix:** Require author IDs in API response
   - **Effort:** Backend + frontend change
   - **Blocking:** Search, Scanner enrichment

8. **No Error Handling Strategy**
   - **Impact:** Inconsistent error UX
   - **Fix:** Shared ErrorState widget + error types
   - **Effort:** 2-3 hours
   - **Blocking:** Production readiness

---

## 📈 Success Metrics (Per PRDs)

### Adoption Metrics
- **30%** of users scan bookshelf within first 7 days
- **60%** of book additions via barcode (vs manual search)
- **40%** of users visit Insights tab weekly

### Performance Metrics
- **<3s** scan-to-results (barcode scanner)
- **<60s** total AI processing time (shelf scan + enrichment)
- **80%+** AI detection accuracy (clear images)
- **60 FPS** scrolling on library views

### Quality Metrics
- **70%+** Review Queue completion rate
- **90%+** of queued books would have been errors
- **<5%** users report needing post-import cleanup

---

## 🚀 Getting Started (Next Steps)

### Immediate Actions (This Week)

1. **Fix Performance Killers**
   ```bash
   # Add cached_network_image
   flutter pub add cached_network_image

   # Replace Image.network in book_card.dart
   # Refactor database.dart N+1 queries
   # Add pagination to watchLibrary()
   ```

2. **Create Shared Directory**
   ```bash
   mkdir -p lib/shared/widgets
   mkdir -p lib/shared/constants
   mkdir -p lib/shared/theme

   # Move BookCard
   git mv lib/features/library/widgets/book_card.dart lib/shared/widgets/
   git mv lib/features/library/widgets/book_grid_card.dart lib/shared/widgets/
   ```

3. **Set Up Environment Config**
   ```bash
   flutter pub add flutter_dotenv

   # Create .env file
   echo "API_BASE_URL=https://api-dev.example.com" > .env
   echo ".env" >> .gitignore
   ```

4. **Implement Tab Navigation**
   - Create `lib/core/routing/app_router.dart`
   - Set up 4-tab `NavigationBar`
   - Test deep links

---

## 📚 Reference Documentation

- **PRD Files:** `product/` directory
- **Conversion Guide:** `product/FLUTTER_CONVERSION_GUIDE.md`
- **Architecture Decisions:** `CLAUDE.md`
- **Design System:** Material Design 3 (https://m3.material.io/)
- **Packages:**
  - go_router: https://pub.dev/packages/go_router
  - riverpod: https://riverpod.dev/
  - drift: https://drift.simonbinder.eu/
  - fl_chart: https://pub.dev/packages/fl_chart
  - mobile_scanner: https://pub.dev/packages/mobile_scanner

---

## 🎨 Design Principles

1. **Material Design 3 First** - Don't try to replicate iOS HIG
2. **Performance Matters** - Target users have 100-500 books
3. **Accessibility Required** - Support TalkBack, VoiceOver, keyboard nav
4. **Offline Capable** - Show cached data when network fails
5. **Consistent UX** - Reuse components, don't reinvent patterns

---

**Last Updated:** November 12, 2025
**Maintained By:** Flutter Engineering Team
**Questions?** See PRD files or CLAUDE.md for detailed requirements
