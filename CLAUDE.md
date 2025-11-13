# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **Flutter conversion project** for a book tracking application (BooksTrack). The project is currently in the PRD (Product Requirements Document) conversion phase, transitioning iOS-native PRDs to Flutter cross-platform architecture.

**Status:** Planning phase - converting iOS PRDs to Flutter specifications (6/16 completed as of Nov 12, 2025)

**Key Differentiator:** Platform-agnostic Cloudflare Workers backend means zero API changes during iOS → Flutter conversion.

## Technology Stack

### Frontend (Target)
- **Framework:** Flutter (iOS + Android)
- **State Management:** flutter_riverpod (^2.4.0) with riverpod_annotation
- **Database:** Drift (^2.14.0) - type-safe reactive ORM
- **Networking:** Dio (^5.4.0) with dio_cache_interceptor
- **Navigation:** go_router (^12.0.0)
- **Camera:** camera (^0.10.5) + mobile_scanner (^3.5.0)

### Backend (Unchanged)
- **Platform:** Cloudflare Workers
- **AI Integration:** Google Gemini 2.0 Flash (vision + text)
- **Data Sources:** Google Books API, Open Library API

### Design System
- **Material Design 3**
- **Seed Color:** #1976D2 (Blue 700)
- **Dynamic Color:** Disabled (brand consistency)
- **Typography:** Material 3 text styles

## Repository Structure

```
books-flutter/
├── product/                    # All PRD documentation
│   ├── PRD-Template.md        # Standard template (Flutter-ready)
│   ├── *-PRD-Flutter.md       # Converted Flutter PRDs (6 complete)
│   ├── *-PRD.md              # Original iOS PRDs (10 remaining to convert)
│   ├── FLUTTER_CONVERSION_GUIDE.md  # Comprehensive conversion guide
│   ├── CONVERSION_SUMMARY.md        # Progress tracking & insights
│   └── QUICK_REFERENCE.md           # One-page cheat sheet
└── README.md
```

**Note:** No Flutter code exists yet - this is the planning/specification phase.

## PRD Conversion Workflow

### Key Insight: 60% Reusable, 40% Needs Conversion

**Sections that STAY UNCHANGED:**
- Executive Summary (business logic)
- Problem Statement (user pain points)
- Target Users & Personas
- Success Metrics / KPIs
- API Contracts (backend is platform-agnostic!)
- Functional Requirements (high-level flows)
- Open Questions & Risks

**Sections that NEED CONVERSION:**
- Technical Architecture (SwiftUI → Flutter widgets)
- Data Models (SwiftData → Drift syntax)
- Dependencies (iOS frameworks → Flutter packages)
- Design & UX (iOS HIG → Material Design 3)
- Testing Strategy (XCTest → flutter_test)
- Performance NFRs (add Flutter-specific requirements)

### iOS → Flutter Architecture Mapping

| iOS Pattern | Flutter Equivalent | Package |
|-------------|-------------------|---------|
| SwiftUI Views | StatelessWidget / ConsumerWidget | flutter |
| @Observable | StateNotifier | riverpod |
| @State / @Binding | Provider / StateProvider | riverpod |
| SwiftData @Model | Drift Table | drift |
| AVFoundation camera | CameraController | camera |
| VisionKit barcode | MobileScanner | mobile_scanner |
| URLSession | Dio | dio |
| NavigationStack | GoRouter | go_router |
| UserDefaults | SharedPreferences | shared_preferences |
| @globalActor | Isolate.run() | dart:isolate |

### Standard Conversion Steps

1. **Copy** original iOS PRD to `[Feature]-PRD-Flutter.md`
2. **Update header** (Engineering Lead → Flutter Developer, add Target Platform)
3. **Leave unchanged** (~60% of content)
4. **Convert Technical Architecture** using mapping table
5. **Convert Data Models** (SwiftData syntax → Drift syntax)
6. **Update Dependencies** using standard template (see FLUTTER_CONVERSION_GUIDE.md)
7. **Replace Design section** with Material Design 3 compliance template
8. **Update Testing** strategy (flutter_test, widget tests, both platforms)
9. **Add Flutter-specific NFRs** (60 FPS, startup time, isolates)
10. **Review** for iOS-specific terminology

**Average Time:** 45 minutes per PRD (after initial learning curve)

## Converted PRD Examples

### Completed Conversions (Use as Reference)
1. **PRD-Template.md** - Updated base template with Flutter patterns
2. **Bookshelf-Scanner-PRD-Flutter.md** - Complex feature (AI, camera, WebSocket, image processing)
3. **Search-PRD-Flutter.md** - Medium complexity (multi-mode search, barcode integration)
4. **Mobile-Scanner-PRD-Flutter.md** - Medium complexity (barcode scanning, permissions)
5. **Review-Queue-PRD-Flutter.md** - Medium complexity (human-in-the-loop corrections, image cropping)

### Remaining iOS PRDs (10 Total)
- Settings-PRD.md
- VisionKit-Barcode-Scanner-PRD.md
- Library-Reset-PRD.md
- CloudKit-Sync-PRD.md (will need Firebase/Supabase alternative)
- Reading-Statistics-PRD.md
- Genre-Normalization-PRD.md
- DTOMapper-PRD.md
- Canonical-Data-Contracts-PRD.md
- Diversity-Insights-PRD.md
- Enrichment-Pipeline-PRD.md
- Review-Queue-PRD.md
- Gemini-CSV-Import-PRD.md

## Key Features (From PRDs)

1. **Bookshelf AI Scanner** - Photograph bookshelves, AI detects books via Gemini 2.0 Flash
2. **Multi-Mode Search** - Title/ISBN/author search with barcode scanning integration
3. **Mobile Scanner** - VisionKit → mobile_scanner conversion (barcode scanning)
4. **Review Queue** - Human-in-the-loop corrections for AI-detected books
5. **Reading Statistics** - Analytics and insights on reading habits
6. **Diversity Insights** - Cultural diversity analysis of reading library

## Working with PRD Conversions

### Quick Reference Files
- **FLUTTER_CONVERSION_GUIDE.md** - Comprehensive guide (400+ lines)
- **CONVERSION_SUMMARY.md** - Progress tracking & session insights
- **QUICK_REFERENCE.md** - One-page cheat sheet

### Common Conversion Patterns

#### Data Models (SwiftData → Drift)
**Before:**
```swift
@Model
public class Work {
    public var id: UUID
    public var title: String
}
```

**After:**
```dart
class Works extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();

  @override
  Set<Column> get primaryKey => {id};
}
```

#### State Management (@Observable → StateNotifier)
**Before:**
```swift
@Observable
class BookshelfViewModel {
    var isScanning: Bool = false
}
```

**After:**
```dart
@riverpod
class BookshelfState extends _$BookshelfState {
  @override
  bool build() => false;

  void toggleScanning() => state = !state;
}
```

### Material Design 3 Standard Template

Every PRD's "Design & UX" section should include:

```markdown
### Material Design 3 Compliance

**Color Scheme:**
- **Primary Seed Color:** `#1976D2` (Blue 700)
- **Dynamic Color Support:** Disabled (brand consistency)
- **Light/Dark Mode:** Both supported via `ThemeMode.system`

**Design Tokens:**
- [ ] ColorScheme.fromSeed
- [ ] Material 3 typography
- [ ] 12dp corner radius for cards
- [ ] Proper navigation patterns
```

### Flutter-Specific Performance NFRs

Add to every PRD's "Non-Functional Requirements":

```markdown
**Flutter-Specific Requirements:**
- **UI Performance:** 60 FPS on scrolling views (measured with DevTools)
- **App Startup:** Cold <2s, Warm <500ms
- **Background Processing:** Heavy operations on isolates
- **Shader Pre-compilation:** iOS builds use --bundle-sksl-path
```

## Common Mistakes to Avoid

1. ❌ **Don't change backend/API sections** - Cloudflare Workers is platform-agnostic
2. ❌ **Don't change user stories** - Business logic is platform-independent
3. ❌ **Don't change success metrics** - KPIs are the same
4. ❌ **Don't add unnecessary Flutter jargon** - Keep PRDs readable for Product/Design teams
5. ❌ **Don't forget platform-specific testing** - Both iOS and Android matter
6. ❌ **Don't use iOS-specific terminology** - Replace "Liquid Glass", "ultraThinMaterial", etc.
7. ❌ **Don't forget Android** - Add to rollout plans, testing strategies, accessibility (TalkBack)

## Expert Validation Notes

All architectural decisions were validated using Zen MCP tools:
- **thinkdeep** - Systematic analysis of iOS → Flutter conversion patterns
- **chat** (Gemini 2.5 Pro) - Expert validation of technology stack choices

**Validated Decisions:**
- ✅ Riverpod for state management (closest SwiftUI @Observable equivalent)
- ✅ Drift for database (type-safe, reactive, matches SwiftData feature set)
- ✅ Material Design 3 for UI (cross-platform consistency, rich component library)
- ✅ Dio for networking (enhanced HTTP with automatic caching)
- ✅ mobile_scanner for barcodes (works on both platforms, mature library)

## Git Workflow

**Current Branch:** main
**Status:** Clean working directory
**Recent Work:** Converting iOS PRDs to Flutter architecture (6/16 complete)

### Important Commits
- `c76b5e0` - Convert iOS PRDs to Flutter architecture (6/16 complete)
- `22e9056` - Add files via upload
- `57b1258` - Initial commit

## When Converting PRDs

1. **Always reference** FLUTTER_CONVERSION_GUIDE.md for detailed steps
2. **Use completed PRDs as examples** (Bookshelf Scanner is most comprehensive)
3. **Follow the 10-step checklist** systematically
4. **Use standard templates** for dependencies, Material Design 3, performance NFRs
5. **Validate with architecture mapping table** when converting technical sections
6. **Keep business sections unchanged** - focus conversion on technical implementation only
7. **Mark new PRDs as "Draft"** until implementation starts

## Next Steps (Project Roadmap)

### Immediate (This Week)
1. Complete remaining PRD conversions (10 PRDs, ~12-15 hours)
2. Team review of converted PRDs
3. Validate technology stack decisions with engineering team

### Short Term (Next 2 Weeks)
4. Set up Flutter project structure
5. Configure Riverpod + Drift + Dio
6. Implement proof-of-concept feature (recommend: Search - simplest, validates networking)

### Medium Term (Next Month)
7. Implement core features (Mobile Scanner → Bookshelf AI Scanner → Review Queue)
8. Set up testing infrastructure (unit tests, widget tests, integration tests)
9. Configure CI/CD for both iOS and Android

## Resources

**Official Documentation:**
- [Flutter Official Docs](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Drift Documentation](https://drift.simonbinder.eu/)
- [Material Design 3](https://m3.material.io/)

**Project-Specific:**
- See FLUTTER_CONVERSION_GUIDE.md for comprehensive conversion instructions
- See QUICK_REFERENCE.md for one-page cheat sheet
- See completed Flutter PRDs for real-world examples
- Architecture mapping table in conversion guide for iOS → Flutter patterns

---

**Last Updated:** November 12, 2025
**Maintained By:** Flutter Engineering Team
**Project Status:** Planning Phase - PRD Conversion (37.5% complete)
