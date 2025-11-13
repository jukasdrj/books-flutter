# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

**BooksTrack Flutter** is a cross-platform book tracking application converted from iOS. The app features AI-powered bookshelf scanning using Gemini 2.0 Flash, multi-mode search, and reading analytics with diversity insights.

**Current Status:** Phase 1 (Foundation) - 95% Complete (as of Nov 12, 2025)

**Key Differentiator:** Platform-agnostic Cloudflare Workers backend means zero API changes during iOS → Flutter conversion.

## Technology Stack

### Frontend
- **Framework:** Flutter 3.x (iOS + Android + Web)
- **State Management:** flutter_riverpod (^2.4.0) with code generation (@riverpod)
- **Database:** Drift (^2.14.0) - type-safe reactive SQL ORM
- **Networking:** Dio (^5.4.0) with dio_cache_interceptor
- **Navigation:** go_router (^12.0.0) with StatefulShellRoute
- **Image Caching:** cached_network_image (^3.3.0)
- **Camera/Barcode:** camera (^0.11.0) + mobile_scanner (^4.0.0)
- **Firebase:** Auth, Firestore, Storage, Analytics, Crashlytics

### Backend
- **Platform:** Cloudflare Workers (TypeScript)
- **AI:** Google Gemini 2.0 Flash (vision + text)
- **APIs:** Google Books API, Open Library API

### Design System
- **Material Design 3** with seed color #1976D2 (Blue 700)
- **Dynamic Color:** Disabled for brand consistency
- **Themes:** Light + Dark (ThemeMode.system)

## Essential Commands

### Code Generation
```bash
# Generate all code (Riverpod providers + Drift database)
dart run build_runner build --delete-conflicting-outputs

# Watch mode for development
dart run build_runner watch --delete-conflicting-outputs
```

### Running the App
```bash
# List available devices
flutter devices

# Run on specific device
flutter run -d macos
flutter run -d <device-id>

# Hot reload: Press 'r' in terminal
# Hot restart: Press 'R' in terminal
```

### Testing
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/features/library/library_screen_test.dart

# Run with coverage
flutter test --coverage
```

### Build & Release
```bash
# iOS build
flutter build ios --release

# Android build
flutter build apk --release
flutter build appbundle --release

# macOS build (currently blocked by gRPC issue)
flutter build macos --release

# Web build
flutter build web --release
```

### Maintenance
```bash
# Update dependencies
flutter pub get

# Upgrade dependencies
flutter pub upgrade

# Check for issues
flutter doctor
flutter analyze
```

## Architecture Overview

### Feature-First Structure
```
lib/
├── core/                    # Shared infrastructure
│   ├── database/           # Drift schema & queries
│   ├── models/dtos/        # API data transfer objects (Freezed)
│   ├── providers/          # Global Riverpod providers
│   ├── router/             # GoRouter configuration
│   └── services/           # API client, Firebase, DTOMapper
├── features/               # Feature modules
│   ├── library/            # Book collection management
│   ├── search/             # Multi-mode search (placeholder)
│   ├── scanner/            # AI bookshelf scanner (placeholder)
│   └── insights/           # Reading analytics (placeholder)
├── shared/                 # Reusable components
│   ├── widgets/            # BookCard, BookGridCard, MainScaffold
│   ├── theme/              # Material 3 theme configuration
│   ├── providers/          # (future)
│   └── utils/              # (future)
└── main.dart               # App entry point
```

### Critical Patterns

#### 1. Database Layer (Drift)
- **Schema Version:** 4 (see database.dart:260)
- **Tables:** Works, Editions, Authors, WorkAuthors (junction), UserLibraryEntries, ScanSessions, DetectedItems
- **Key Principle:** All queries return reactive `Stream<T>` via `.watch()`
- **N+1 Prevention:** Use `_getBatchAuthorsForWorks()` for author fetching
- **Pagination:** Keyset-based with composite cursor `"timestamp|id"`

**Example:**
```dart
Stream<List<WorkWithLibraryStatus>> watchLibrary({
  ReadingStatus? filterStatus,
  String? cursor,  // "2024-01-15T10:30:00.000Z|abc123"
  int limit = 50,
}) {
  // Filters on (updatedAt, id) composite key
  // Orders by both fields (tie-breaker)
  // Uses idx_library_updated_id index
}
```

#### 2. State Management (Riverpod)
- **Code Generation:** All providers use `@riverpod` annotation
- **Pattern:** `ConsumerWidget` or `ConsumerStatefulWidget` for UI
- **Watching:** `ref.watch()` for rebuilds, `ref.read()` for one-time access
- **Providers:**
  - `databaseProvider` - Global AppDatabase instance
  - `watchLibraryWorksProvider` - Reactive library stream
  - `libraryFilterProvider` - Filter state (ReadingStatus?)
  - `librarySortOptionProvider` - Sort state (SortBy enum)
  - `bookActionsProvider` - CRUD operations

**Example:**
```dart
@riverpod
class LibraryFilter extends _$LibraryFilter {
  @override
  ReadingStatus? build() => null;

  void setFilter(ReadingStatus? status) => state = status;
}
```

#### 3. Navigation (GoRouter)
- **Configuration:** `lib/core/router/app_router.dart`
- **Pattern:** `StatefulShellRoute.indexedStack` for persistent tab state
- **Routes:** 4 main tabs (Library, Search, Scanner, Insights)
- **Deep Linking:** Supported via path parameters

**Example:**
```dart
StatefulShellRoute.indexedStack(
  builder: (context, state, navigationShell) {
    return MainScaffold(navigationShell: navigationShell);
  },
  branches: [
    StatefulShellBranch(routes: [GoRoute(path: '/library', ...)]),
    // ... 3 more branches
  ],
)
```

#### 4. DTOMapper Pattern
- **Purpose:** Convert API DTOs to Drift database models
- **Critical:** Use `workDTO.authorIds` for author relationships (NOT list order)
- **Transactions:** Wrap inserts in `database.transaction()` for atomicity
- **File:** `lib/core/services/dto_mapper.dart`

**Anti-Pattern (DO NOT USE):**
```dart
// ❌ WRONG: Assumes authors in same order as works
final editionDTO = i < data.editions.length ? data.editions[i] : null;
```

**Correct Pattern:**
```dart
// ✅ CORRECT: Use authorIds for relationship mapping
final authorDTOs = data.authors
    .where((a) => workDTO.authorIds.contains(a.id))
    .toList();
```

## Performance Critical Code

### 1. Image Loading
**Always use CachedNetworkImage with memory optimization:**
```dart
CachedNetworkImage(
  imageUrl: coverUrl,
  fit: BoxFit.cover,
  memCacheWidth: 240,  // 80 * 3 for Retina displays
  memCacheHeight: 360, // 120 * 3
  placeholder: (context, url) => CircularProgressIndicator(),
  errorWidget: (context, url, error) => Icon(Icons.book),
)
```

### 2. Database Queries
**Batch Fetching Pattern:**
```dart
// ✅ GOOD: Single query for all authors
Future<Map<String, List<Author>>> _getBatchAuthorsForWorks(List<String> workIds) async {
  final query = select(authors).join([...])
    ..where(workAuthors.workId.isIn(workIds));
  // ... group by workId
}

// ❌ BAD: N+1 query anti-pattern
for (final work in works) {
  final authors = await _getAuthorsForWork(work.id);  // N queries!
}
```

### 3. Keyset Pagination
**Composite Cursor Pattern:**
```dart
// Cursor format: "timestamp_iso8601|id"
if (cursor != null && cursor.contains('|')) {
  final parts = cursor.split('|');
  final lastTimestamp = DateTime.parse(parts[0]);
  final lastId = parts[1];

  query.where(
    updatedAt.isSmallerThanValue(lastTimestamp) |
    (updatedAt.equals(lastTimestamp) & id.isSmallerThan(lastId)),
  );
}
```

## Data Models

### Core Entities

**Works** - Book metadata
- Primary key: `id` (UUID)
- Fields: `title`, `author` (denormalized), `subjectTags`, `synthetic`, `reviewStatus`
- Relationships: Many-to-many with Authors via WorkAuthors

**Editions** - Physical/digital book editions
- Foreign key: `workId` → Works
- Fields: `isbn`, `publisher`, `publishedYear`, `coverImageURL`, `format`, `pageCount`

**Authors** - Author information
- Fields: `name`, `gender`, `culturalRegion`, external IDs
- Relationships: Many-to-many with Works

**UserLibraryEntries** - User's reading list
- Foreign keys: `workId` → Works, `editionId` → Editions
- Fields: `status` (wishlist/toRead/reading/read), `currentPage`, `personalRating`, `notes`
- **Indexes:** `(updatedAt, id)`, `(status, updatedAt)` for pagination

**ScanSessions** - AI scan metadata
- Fields: `totalDetected`, `reviewedCount`, `acceptedCount`, `rejectedCount`, `status`
- Cascade delete: Removes all DetectedItems when session deleted

**DetectedItems** - Individual AI detections
- Foreign keys: `sessionId` → ScanSessions, `workId` → Works (nullable)
- Fields: `titleGuess`, `authorGuess`, `confidence`, `imagePath`, `boundingBox`, `reviewStatus`
- **Indexes:** `(sessionId, reviewStatus)`, `confidence`

### DTO Contracts

All API responses follow the pattern:
```dart
@freezed
class ResponseEnvelope<T> with _$ResponseEnvelope<T> {
  const factory ResponseEnvelope({
    required bool success,
    T? data,
    ErrorDetails? error,
    required MetaData meta,
  }) = _ResponseEnvelope<T>;
}
```

## Known Issues & Workarounds

### macOS Build Failure
**Issue:** gRPC incompatibility with macOS 26.1 Sequoia
```
clang: error: unsupported option '-G' for target 'arm64-apple-macos10.12'
```
**Workaround:** Test on iOS/Android/Web instead. Tracked in Firebase issue.

### iOS Device Testing
**Issue:** Requires iOS 26.1 SDK installation in Xcode
**Fix:** Xcode > Settings > Components > Download iOS 26.1

## Material Design 3 Guidelines

### Component Usage
- **Navigation:** `NavigationBar` (not BottomNavigationBar)
- **Buttons:** `FilledButton`, `OutlinedButton`, `TextButton`
- **Filters:** `FilterChip` with `selectedColor: colorScheme.primaryContainer`
- **Cards:** 12dp corner radius, `clipBehavior: Clip.antiAlias`
- **Icons:** Outlined when inactive, filled when active

### Theme Configuration
```dart
// lib/shared/theme/app_theme.dart
static final lightTheme = ThemeData(
  useMaterial3: true,
  colorScheme: ColorScheme.fromSeed(
    seedColor: const Color(0xFF1976D2),  // Blue 700
    brightness: Brightness.light,
  ),
);
```

## Development Workflow

### Adding a New Feature
1. Create feature directory: `lib/features/<feature>/`
2. Add subdirectories: `screens/`, `providers/`, `widgets/`
3. Define Riverpod providers with `@riverpod` annotation
4. Create Drift queries if needed
5. Run code generation: `dart run build_runner build`
6. Implement UI with `ConsumerWidget`
7. Add route to `lib/core/router/app_router.dart`

### Database Schema Changes
1. Update table classes in `lib/core/database/database.dart`
2. Increment `schemaVersion` (currently 4)
3. Add migration logic if needed
4. Run: `dart run build_runner build --delete-conflicting-outputs`
5. Test with fresh database install

### Adding API Integration
1. Define DTOs in `lib/core/models/dtos/` using Freezed
2. Update `DTOMapper` in `lib/core/services/dto_mapper.dart`
3. Add API client methods in `lib/core/services/api_client.dart`
4. Create provider in relevant feature module
5. Run code generation

## Testing Strategy

### Unit Tests
- Database queries (Drift)
- DTOMapper transformations
- Provider logic (Riverpod)

### Widget Tests
- Screen rendering
- User interactions
- State changes

### Integration Tests
- Full user flows
- Database + UI integration
- Navigation flows

## Documentation

**Key Files:**
- `TODO_REFINED.md` - Production roadmap (12-week plan)
- `IMPLEMENTATION_LOG.md` - Development progress log
- `product/*.md` - Product requirement documents (PRDs)

**PRD Structure:**
- Converted Flutter PRDs: `*-PRD-Flutter.md`
- Original iOS PRDs: `*-PRD.md`
- Template: `PRD-Template.md`

## iOS → Flutter Architecture Mapping

| iOS Pattern | Flutter Equivalent | Package |
|-------------|-------------------|---------|
| SwiftUI Views | StatelessWidget / ConsumerWidget | flutter |
| @Observable | StateNotifier with @riverpod | riverpod |
| @State / @Binding | Provider / StateProvider | riverpod |
| SwiftData @Model | Drift Table | drift |
| AVFoundation | CameraController | camera |
| VisionKit barcode | MobileScanner | mobile_scanner |
| URLSession | Dio | dio |
| NavigationStack | GoRouter + StatefulShellRoute | go_router |
| UserDefaults | SharedPreferences | shared_preferences |
| @globalActor | Isolate.run() | dart:isolate |

## Platform-Specific Considerations

### Web Support
- Use `kIsWeb` for conditional logic
- Scanner: File upload fallback (no camera access)
- Database: Drift with `sqlite3_web` (WASM)
- Navigation: URL-based routing works automatically

### iOS
- App Tracking Transparency (ATT) required for analytics
- Universal Links: Configure in Info.plist
- Push Notifications: APNs certificates

### Android
- Deep Links: Configure in AndroidManifest.xml
- Permissions: Camera, storage in AndroidManifest.xml
- Notification channels required for Android 8+

---

**Last Updated:** November 12, 2025
**Project Status:** Phase 1 Foundation - 95% Complete
**Next Milestone:** Phase 2 Search Feature (Weeks 4-5)
