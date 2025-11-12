# Book Search - Product Requirements Document

**Feature:** Multi-Mode Book Search (Title, ISBN, Author, Advanced)
**Status:** 📝 Draft (Flutter Conversion)
**Last Updated:** November 12, 2025
**Owner:** Flutter Engineering Team
**Target Platform:** iOS and Android
**Related Docs:**
- Workflow: [Search Workflow](../workflows/search-workflow.md)
- Parent: [Canonical Data Contracts PRD](Canonical-Data-Contracts-PRD.md)
- Barcode Scanner: [Mobile Scanner Integration](mobile-scanner-integration.md)

---

## Problem Statement

**Core Pain Point:**
Users need to find books quickly to add to their library, but don't always know the exact title or have the book physically present. Different search modes (title, author, ISBN) serve different user contexts.

**User Contexts:**
1. **Browsing bookstore:** Scan ISBN barcode (fastest, 3s scan-to-results)
2. **Remembering book name:** Search by title (partial match, fuzzy search)
3. **Exploring author:** Search by author name (discover all works)
4. **Specific edition:** Search by title + author (filter results)

**Why Now:**
- Mobile barcode scanner integration launched (ISBN search critical)
- Canonical data contracts deployed (consistent search results)
- Multiple entry points (SearchScreen, enrichment, CSV import, bookshelf scanner)

---

## Solution Overview

**Multi-Mode Search:**
1. **Title Search:** `/v1/search/title?q={query}` - Fuzzy matching, partial titles
2. **ISBN Search:** `/v1/search/isbn?isbn={isbn}` - Exact match, barcode scanner integration
3. **Advanced Search:** `/v1/search/advanced?title={title}&author={author}` - Combined filters

**Key Features:**
- Canonical DTOs (WorkDTO, EditionDTO, AuthorDTO) from all endpoints
- DTOMapper converts to Drift models (zero provider-specific logic)
- 6-hour cache for title/advanced, 7-day cache for ISBN
- Genre normalization built-in (backend)

---

## User Stories

**US-1: Quick Title Search**
As a user, I want to search "Harry Potter" and see all matching books, so I can find the specific title I'm looking for.
- **AC:** Type "harry" (lowercase, partial) → Results include "Harry Potter and the Philosopher's Stone"
- **Implementation:** `/v1/search/title?q=harry`, fuzzy matching on backend

**US-2: ISBN Barcode Scan**
As a user in a bookstore, I want to scan a barcode and see the book details in <3s, so I can quickly add it to my wishlist.
- **AC:** Scan ISBN → Mobile scanner → `/v1/search/isbn` → Book details in 1-3s
- **Implementation:** `mobile_scanner` package integration, 7-day cache

**US-3: Author Discovery**
As a user, I want to search "George Orwell" and see all his books, so I can explore his other works.
- **AC:** Search "George Orwell" (author scope) → Results include "1984", "Animal Farm", etc.
- **Implementation:** `/v1/search/advanced?author=George+Orwell`

**US-4: Advanced Filtering**
As a user, I want to search "1984" (title) by "Orwell" (author) to avoid seeing other books titled "1984".
- **AC:** Advanced search: title="1984", author="Orwell" → Only Orwell's "1984"
- **Implementation:** `/v1/search/advanced?title=1984&author=Orwell`

**US-5: Error Recovery**
As a user with poor network, I want clear error messages when search fails, so I know whether to retry or switch to manual entry.
- **AC:** Network timeout → Show "Search failed. Please try again." with retry button
- **Implementation:** Dio interceptors with user-friendly error messages

---

## Technical Implementation

### Flutter Components

**Files:**
- `lib/features/search/screens/search_screen.dart` - Main search UI (StatefulWidget)
- `lib/features/search/providers/search_provider.dart` - Riverpod StateNotifier managing search state
- `lib/features/search/models/search_view_state.dart` - State model (initial, searching, results, error, empty)
- `lib/core/services/book_search_api_service.dart` - Dio-based API client for `/v1/*` endpoints
- `lib/core/mappers/dto_mapper.dart` - Converts DTOs to Drift models

**Search Flow:**
```dart
SearchScreen (UI)
  ↓ user types query
SearchNotifier.updateSearchQuery("Harry Potter")
  ↓ debounced 300ms (using dart:async Timer)
BookSearchAPIService.searchByTitle("Harry Potter")
  ↓ GET /v1/search/title?q=Harry+Potter (via Dio)
ResponseEnvelope<WorkDTO[], EditionDTO[], AuthorDTO[]>
  ↓ parse JSON (json_serializable)
DTOMapper.mapToWorks(data, database)
  ↓ convert to Drift models
List<Work>
  ↓ update state
SearchViewState.results(query, scope, items, provider, cached)
  ↓ render
SearchScreen displays results (ListView.builder)
```

### Backend Endpoints

**Backend remains unchanged (platform-agnostic):**

**1. Title Search:**
```
GET /v1/search/title?q={query}
```
- Fuzzy matching (partial titles, case-insensitive)
- Cache: 6 hours (KV)
- Returns: Canonical WorkDTO[], EditionDTO[], AuthorDTO[]

**2. ISBN Search:**
```
GET /v1/search/isbn?isbn={isbn}
```
- Exact match (ISBN-10 or ISBN-13)
- Validation: Checksum, format
- Cache: 7 days (KV)
- Returns: Canonical DTOs

**3. Advanced Search:**
```
GET /v1/search/advanced?title={title}&author={author}
```
- Combined filters (both optional, but at least one required)
- Cache: 6 hours (KV)
- Returns: Canonical DTOs

**Response Format (All Endpoints):**
```json
{
  "success": true,
  "data": {
    "works": [
      {
        "title": "Harry Potter and the Philosopher's Stone",
        "subjectTags": ["Fiction", "Fantasy", "Young Adult"],
        "synthetic": true,
        "primaryProvider": "google-books"
      }
    ],
    "editions": [...],
    "authors": [...]
  },
  "meta": {
    "timestamp": "2025-10-31T12:00:00Z",
    "processingTime": 450,
    "provider": "google-books",
    "cached": false
  }
}
```

### Integration Points

**Mobile Scanner Integration:**
```dart
// Using mobile_scanner package (replaces VisionKit)
import 'package:mobile_scanner/mobile_scanner.dart';

// In SearchScreen
FloatingActionButton(
  onPressed: () {
    showModalBottomSheet(
      context: context,
      builder: (context) => ISBNScannerSheet(
        onScanned: (isbn) {
          Navigator.pop(context);
          ref.read(searchScopeProvider.notifier).state = SearchScope.isbn;
          ref.read(searchNotifierProvider.notifier).searchByISBN(isbn);
        },
      ),
    );
  },
  child: Icon(Icons.qr_code_scanner),
)
```

**Search Scopes:**
- `SearchScope.title` - Default scope, searches `/v1/search/title`
- `SearchScope.isbn` - Triggered by barcode scanner, searches `/v1/search/isbn`
- `SearchScope.author` - User-selected scope, searches `/v1/search/advanced?author={query}`

---

## Success Metrics

**Performance:**
- ✅ **Title search <2s** (avg 800ms uncached, <50ms cached)
- ✅ **ISBN search <3s** (scan + API, avg 1.3s total)
- ✅ **95% cache hit rate** (dio_cache_interceptor)

**Reliability:**
- ✅ **Zero crashes from malformed ISBNs** (backend validation)
- ✅ **100% error handling** (Dio interceptors catch all errors)
- ✅ **Structured error codes** (INVALID_QUERY, INVALID_ISBN, PROVIDER_ERROR)

**User Experience:**
- ✅ **Debounced search** (300ms delay via Timer, prevents API spam)
- ✅ **Trending books on empty state** (engaging landing page)
- ✅ **Recent searches** (via shared_preferences)
- ✅ **Genre normalization** (consistent tags: "Fiction" not "fiction")

---

## Design & User Experience

### Material Design 3 Implementation

**Search Screen Layout:**
- AppBar with `SearchBar` widget (Material 3)
- Chip filters for search scope (title, author, ISBN)
- ListView.builder for results
- FloatingActionButton for barcode scanner

**Color Scheme:**
- **Primary Seed:** `#1976D2` (Blue 700)
- **Dynamic Color:** Disabled
- **Dark Mode:** Supported via ThemeMode.system

**Typography:**
- Search results: `textTheme.bodyLarge` for titles
- Author names: `textTheme.bodyMedium` with secondary color
- Metadata: `textTheme.bodySmall`

---

## Technical Architecture

### System Components

| Component | Type | Responsibility | File Location |
|-----------|------|---------------|---------------|
| **SearchScreen** | StatefulWidget | Main search UI | `lib/features/search/screens/search_screen.dart` |
| **SearchNotifier** | StateNotifier (Riverpod) | Manages search state | `lib/features/search/providers/search_provider.dart` |
| **BookSearchAPIService** | Service | Dio-based API client | `lib/core/services/book_search_api_service.dart` |
| **DTOMapper** | Service | DTO → Drift conversion | `lib/core/mappers/dto_mapper.dart` |
| **ISBNScannerSheet** | StatefulWidget | Mobile scanner bottom sheet | `lib/features/search/widgets/isbn_scanner_sheet.dart` |

---

### Data Models

**Drift Tables (from Canonical DTOs):**
```dart
import 'package:drift/drift.dart';

class Works extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  TextColumn get author => text().nullable()();
  TextColumn get subjectTags => text()();  // JSON array
  BoolColumn get synthetic => boolean()();
  TextColumn get primaryProvider => text()();

  @override
  Set<Column> get primaryKey => {id};
}
```

---

### Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.4.0

  # Database
  drift: ^2.14.0
  drift_flutter: ^0.1.0

  # Networking
  dio: ^5.4.0
  dio_cache_interceptor: ^3.4.0  # For 6hr/7day caching

  # Barcode Scanning
  mobile_scanner: ^3.5.0

  # JSON Serialization
  json_annotation: ^4.8.0

dev_dependencies:
  json_serializable: ^6.7.0
  build_runner: ^2.4.0
```

---

## Testing Strategy

### Unit Tests

**Search Logic:**
- [ ] Debounce timing - Verify 300ms delay
- [ ] Query sanitization - Trim whitespace, handle special chars
- [ ] Cache hit/miss - Verify cache interceptor behavior
- [ ] ISBN validation - Accept ISBN-10 and ISBN-13

### Widget Tests

**Search UI:**
- [ ] SearchBar renders correctly
- [ ] Chip filters toggle scope
- [ ] Results list populates
- [ ] Empty state shows trending books
- [ ] Error state shows retry button

### Integration Tests

**End-to-End:**
- [ ] Type query → API call → Results display
- [ ] Scan barcode → ISBN search → Book detail
- [ ] Network error → Error message → Retry succeeds

---

## Non-Functional Requirements

### Performance

| Requirement | Target | Rationale |
|-------------|--------|-----------|
| **Search Latency** | <2s | Users expect instant results |
| **Barcode Scan Speed** | <3s total | Competitive with dedicated apps |
| **UI Responsiveness** | 60 FPS | Smooth scrolling in results |
| **Memory Usage** | <150MB | Support mid-range devices |

**Flutter-Specific:**
- Dio connection pool reused (reduce overhead)
- Results list uses ListView.builder (lazy loading)
- Images cached via cached_network_image

---

## Platform-Specific Considerations

**Android:**
- Permission: `<uses-permission android:name="android.permission.CAMERA" />`
- Barcode formats: All standard formats via ML Kit

**iOS:**
- Permission: `NSCameraUsageDescription` in Info.plist
- Barcode formats: All standard formats via ML Kit

---

## Launch Checklist

**Pre-Launch:**
- [ ] All P0 acceptance criteria met
- [ ] Unit tests passing (90%+ coverage)
- [ ] Widget tests for search UI
- [ ] Manual QA on iOS and Android
- [ ] Performance validated (60 FPS scrolling)
- [ ] Material Design 3 compliance
- [ ] Barcode scanner tested on physical devices

**Post-Launch:**
- [ ] Monitor search query analytics
- [ ] Track cache hit rates
- [ ] Measure search latency (P50, P95, P99)
- [ ] Collect user feedback on accuracy

---

## Related Features

**Upstream Dependencies:**
- Canonical Data Contracts (WorkDTO, EditionDTO, AuthorDTO)
- Genre Normalization (backend service)
- Mobile Scanner package (ISBN search)

**Downstream Dependents:**
- Enrichment Pipeline (uses `/v1/search/isbn`)
- Bookshelf Scanner (uses `/v1/search/isbn` after AI detection)
- CSV Import (uses `/v1/search/title` for metadata lookup)

---

**PRD Status:** 📝 Draft (Flutter Conversion)
**Implementation:** Not Started
**Last Review:** November 12, 2025
