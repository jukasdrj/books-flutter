# BooksTrack Flutter v3 - Implementation Plan Overview

**Created:** December 26, 2025
**Purpose:** Functional parity with iOS app against bendv3 API
**Focus:** Best-in-class Flutter design and functionality

---

## Executive Summary

This plan outlines the path to achieve functional parity between the Flutter app and the iOS BooksTrack app. The Flutter app has strong foundations (database, API client, providers) but is missing most user-facing functionality.

**Current State:** ~20% complete (foundation only)
**Target State:** 100% functional parity with iOS

---

## Gap Analysis

### What's Done (Foundation - Phase 1)

| Component | Status | Notes |
|-----------|--------|-------|
| **Database Schema** | Complete | 7 tables, Drift 2.14, schema v4 |
| **API Client** | Complete | Dio with caching, retry, error handling |
| **SearchService** | Complete | 3 endpoints ready (`/v1/search/*`) |
| **Core Providers** | Complete | Database, API, auth providers |
| **Library Screen** | ~50% | Filtering, sorting UI - missing book detail |
| **Navigation** | Complete | GoRouter with 4-tab shell |
| **Theme** | Complete | Material 3 with light/dark support |
| **DTOMapper** | Complete | 100% compliant with TypeScript contracts |

### What's Missing (Critical Gaps)

| Feature | iOS PRD | Flutter Status | Priority |
|---------|---------|----------------|----------|
| **Import Path Fixes** | N/A | Broken imports block build | P0 - Blocking |
| **Search UI** | Search-PRD-Flutter.md | Placeholder only | P0 |
| **ISBN Scanner** | Mobile-Scanner-PRD-Flutter.md | Placeholder only | P0 |
| **Bookshelf Scanner** | Bookshelf-Scanner-PRD-Flutter.md | Stub only | P1 |
| **Review Queue** | Review-Queue-PRD-Flutter.md | Stub only | P1 |
| **Insights Dashboard** | Diversity-Insights-PRD.md | Placeholder only | P1 |
| **Reading Statistics** | Reading-Statistics-PRD.md | Database ready, no UI | P1 |
| **Settings Screen** | Settings-PRD.md | Not started | P2 |
| **Book Detail Screen** | N/A (implied) | Not started | P0 |
| **Library Reset** | Library-Reset-PRD.md | Not started | P2 |

---

## Implementation Phases

### Phase 1: Critical Fixes (Day 1)
**Goal:** App builds and runs

1. Fix import path mismatches (router.dart, barrel exports)
2. Verify code generation works (`build_runner`)
3. Consolidate duplicate widgets

**Deliverable:** App launches with working Library screen

---

### Phase 2: Core Features (Week 1-2)
**Goal:** Basic book management functional

1. **Search Feature** - Full implementation
   - Search UI with TextField, scope chips
   - Debounced search (300ms)
   - Results list with add-to-library
   - API integration with SearchService

2. **Book Detail Screen** - View and edit books
   - Book metadata display
   - Reading status management
   - Progress tracking (current page)
   - Rating and notes

3. **ISBN Scanner** - Barcode scanning
   - mobile_scanner integration
   - Permission handling
   - ISBN validation
   - Quick add workflow

**Deliverable:** Users can search, scan, add, and manage books

---

### Phase 3: AI Features (Week 3-4)
**Goal:** AI-powered bookshelf scanning

1. **Bookshelf Scanner** - Photo capture and AI detection
   - Camera integration
   - Image upload to `/api/scan-bookshelf`
   - WebSocket progress tracking
   - Results display

2. **Review Queue** - Human-in-the-loop verification
   - Queue badge in app bar
   - Review list screen
   - Correction screen with spine image
   - Status updates (verified/userEdited)

**Deliverable:** Users can photograph bookshelves and review detections

---

### Phase 4: Analytics & Insights (Week 5)
**Goal:** Reading analytics and diversity insights

1. **Reading Statistics** - Basic stats
   - Books read this year
   - Currently reading list
   - Status distribution chart
   - Recent completions

2. **Diversity Insights** - Cultural analytics
   - Hero stats card (regions, gender %, languages)
   - Cultural regions bar chart
   - Gender donut chart
   - Language tag cloud
   - Diversity score calculation

**Deliverable:** Insights tab fully functional

---

### Phase 5: Settings & Polish (Week 6)
**Goal:** App customization and quality

1. **Settings Screen** - App configuration
   - Theme selection (5 themes)
   - Feature flags
   - Library reset
   - Storage info

2. **Testing & Polish**
   - Unit tests for business logic
   - Widget tests for screens
   - Performance optimization
   - Accessibility audit

**Deliverable:** Production-ready app

---

## API Integration Summary

### Endpoints Required

| Endpoint | Method | Feature | Status |
|----------|--------|---------|--------|
| `/v1/search/title` | GET | Search | Service ready |
| `/v1/search/isbn` | GET | Scanner | Service ready |
| `/v1/search/advanced` | GET | Search | Service ready |
| `/api/scan-bookshelf` | POST | Bookshelf Scanner | Not started |
| `/ws/progress` | WebSocket | Scanner progress | Not started |
| `/api/enrichment/cancel` | POST | Library Reset | Not started |

### Backend Notes

- Backend is **platform-agnostic** (Cloudflare Workers)
- **Zero API changes** required for Flutter
- All endpoints return canonical DTOs (WorkDTO, EditionDTO, AuthorDTO)
- DTOMapper already handles conversion to Drift models

---

## Architecture Decisions

### State Management
- **Riverpod** with code generation (`@riverpod`)
- StateNotifier for complex state
- StreamProvider for reactive database queries

### Navigation
- **GoRouter** with StatefulShellRoute
- 4 main tabs (Library, Search, Scanner, Insights)
- Deep linking supported

### Database
- **Drift** for type-safe SQLite
- Keyset pagination with composite cursors
- Batch author fetching to prevent N+1

### Networking
- **Dio** with interceptors (logging, retry, error)
- **dio_cache_interceptor** (6hr title, 7d ISBN)
- **web_socket_channel** for progress updates

---

## File Structure Target

```
lib/
├── app/
│   ├── app.dart
│   ├── router.dart
│   └── theme.dart
├── core/
│   ├── data/
│   │   ├── database/
│   │   ├── models/dtos/
│   │   └── dto_mapper.dart
│   ├── services/
│   │   ├── api/
│   │   │   ├── api_client.dart
│   │   │   ├── search_service.dart
│   │   │   └── bookshelf_ai_service.dart  (NEW)
│   │   ├── auth/
│   │   ├── sync/
│   │   └── websocket/                      (NEW)
│   │       └── progress_manager.dart
│   ├── utils/
│   │   └── isbn_validator.dart             (NEW)
│   └── providers/
├── features/
│   ├── library/
│   │   ├── screens/
│   │   │   ├── library_screen.dart
│   │   │   └── book_detail_screen.dart     (NEW)
│   │   ├── providers/
│   │   └── widgets/
│   ├── search/
│   │   ├── screens/
│   │   │   ├── search_screen.dart          (IMPLEMENT)
│   │   │   └── isbn_scanner_screen.dart    (NEW)
│   │   ├── providers/
│   │   │   └── search_provider.dart        (NEW)
│   │   └── widgets/
│   │       └── scanner_overlay.dart        (NEW)
│   ├── scanner/                            (RENAME: bookshelf_scanner)
│   │   ├── screens/
│   │   │   ├── bookshelf_scanner_screen.dart
│   │   │   └── scan_results_screen.dart    (NEW)
│   │   ├── providers/
│   │   │   └── scan_state_provider.dart    (NEW)
│   │   └── services/
│   │       └── camera_manager.dart         (NEW)
│   ├── review_queue/
│   │   ├── screens/
│   │   │   ├── review_queue_screen.dart    (NEW)
│   │   │   └── correction_screen.dart      (NEW)
│   │   ├── providers/
│   │   │   └── review_queue_provider.dart  (NEW)
│   │   └── widgets/
│   │       └── review_queue_badge.dart     (NEW)
│   ├── insights/
│   │   ├── screens/
│   │   │   └── insights_screen.dart        (IMPLEMENT)
│   │   ├── providers/
│   │   │   ├── diversity_stats_provider.dart (NEW)
│   │   │   └── reading_stats_provider.dart   (NEW)
│   │   └── widgets/
│   │       ├── hero_stats_card.dart        (NEW)
│   │       ├── cultural_regions_chart.dart (NEW)
│   │       ├── gender_donut_chart.dart     (NEW)
│   │       └── language_tag_cloud.dart     (NEW)
│   └── settings/                           (NEW)
│       ├── screens/
│       │   └── settings_screen.dart
│       ├── providers/
│       │   └── settings_provider.dart
│       └── widgets/
└── shared/
    └── widgets/
        ├── cards/
        ├── layouts/
        └── charts/                         (NEW)
```

---

## Success Metrics

### Functional Parity
- [ ] All 4 tabs functional (Library, Search, Scanner, Insights)
- [ ] Search by title, author, ISBN working
- [ ] Barcode scanning functional on iOS and Android
- [ ] Bookshelf AI scanning with review queue
- [ ] Reading statistics and diversity insights
- [ ] Settings with theme selection and library reset

### Performance
- [ ] Cold start < 2s
- [ ] Search results < 2s
- [ ] Barcode scan < 3s (scan to result)
- [ ] 60 FPS scrolling
- [ ] < 250MB memory usage

### Quality
- [ ] 0 critical bugs
- [ ] Unit test coverage > 80%
- [ ] Widget tests for all screens
- [ ] Material 3 compliant
- [ ] Accessibility (TalkBack, VoiceOver)

---

## Plan Files

| File | Description |
|------|-------------|
| `01-CRITICAL-FIXES.md` | Import paths, build fixes |
| `02-SEARCH-FEATURE.md` | Full search implementation |
| `03-SCANNER-FEATURE.md` | ISBN barcode scanning |
| `04-BOOKSHELF-SCANNER.md` | AI bookshelf detection |
| `05-REVIEW-QUEUE.md` | Low-confidence review |
| `06-INSIGHTS.md` | Stats and diversity analytics |
| `07-SETTINGS.md` | App settings and reset |
| `08-BOOK-DETAIL.md` | Book detail and editing |

---

## Next Steps

1. **Immediate:** Fix critical import paths (01-CRITICAL-FIXES.md)
2. **This Week:** Implement Search and Book Detail (02, 08)
3. **Next Week:** Scanner features (03, 04, 05)
4. **Following:** Insights and Settings (06, 07)

---

**Document Status:** Active
**Last Updated:** December 26, 2025
