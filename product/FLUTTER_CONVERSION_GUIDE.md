# iOS → Flutter PRD Conversion Guide

**Date:** November 12, 2025
**Purpose:** Guide for converting remaining iOS PRDs to Flutter architecture
**Status:** Active Template

---

## 📋 Conversion Summary

### Completed Conversions
✅ **PRD-Template.md** - Updated with Flutter patterns
✅ **Bookshelf-Scanner-PRD-Flutter.md** - Full conversion example
✅ **Search-PRD-Flutter.md** - Full conversion example

### Remaining PRDs to Convert (13 total)
- [ ] Settings-PRD.md
- [ ] VisionKit-Barcode-Scanner-PRD.md
- [ ] Library-Reset-PRD.md
- [ ] CloudKit-Sync-PRD.md
- [ ] Reading-Statistics-PRD.md
- [ ] Genre-Normalization-PRD.md
- [ ] DTOMapper-PRD.md
- [ ] Canonical-Data-Contracts-PRD.md
- [ ] Diversity-Insights-PRD.md
- [ ] Enrichment-Pipeline-PRD.md
- [ ] Review-Queue-PRD.md
- [ ] Gemini-CSV-Import-PRD.md

---

## 🎯 What Changes vs What Stays

### ✅ Sections That Need NO Changes (60%)
1. **Executive Summary** - Business description is platform-agnostic
2. **Problem Statement** - User pain points don't change
3. **Target Users** - Personas remain the same
4. **Success Metrics** - KPIs are platform-independent
5. **User Stories & Acceptance Criteria** - Mostly unchanged (just remove iOS version numbers)
6. **Functional Requirements** - High-level flows stay same
7. **API Contracts** - Backend is unchanged (Cloudflare Workers)
8. **Rollout Plan** - Process is similar (just add Android to phases)
9. **Open Questions & Risks** - Business risks unchanged

### 🔄 Sections That Need Conversion (40%)

#### 1. Header Section
**Before:**
```markdown
**Engineering Lead:** iOS Developer
**Target Release:** Build 46 (October 2025)
```

**After:**
```markdown
**Engineering Lead:** Flutter Developer
**Target Platform:** iOS and Android
**Target Release:** Version 1.0.0 (TBD)
```

#### 2. Technical Architecture
**Before:**
```markdown
| Component | Type | Responsibility | File Location |
| BookshelfCameraSessionManager | @BookshelfCameraActor | AVFoundation camera | BookshelfCameraSessionManager.swift |
```

**After:**
```markdown
| Component | Type | Responsibility | File Location |
| CameraManager | Service | Camera plugin wrapper | lib/services/camera_manager.dart |
```

**Key Changes:**
- SwiftUI Views → StatelessWidget / StatefulWidget / ConsumerWidget
- @Observable → StateNotifier (Riverpod)
- Actors → Services with Isolates
- `.swift` → `.dart`
- File paths: `FeatureName.swift` → `lib/features/feature_name/file_name.dart`

#### 3. Data Models
**Before (SwiftData):**
```swift
@Model
public class Work {
    public var id: UUID
    public var title: String
}
```

**After (Drift):**
```dart
class Works extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();

  @override
  Set<Column> get primaryKey => {id};
}
```

#### 4. Dependencies
**Before:**
```markdown
- **iOS:** SwiftData, AVFoundation, VisionKit
```

**After:**
```yaml
dependencies:
  flutter_riverpod: ^2.4.0  # State management
  drift: ^2.14.0            # Database
  camera: ^0.10.5           # Camera
  mobile_scanner: ^3.5.0    # Barcode scanning
```

#### 5. Design & UX
**Before:**
```markdown
### iOS 26 HIG Compliance
- [ ] Liquid Glass design system
- [ ] `.ultraThinMaterial` backgrounds
```

**After:**
```markdown
### Material Design 3 Compliance

**Color Scheme:**
- **Primary Seed Color:** `#1976D2` (Blue 700)
- **Dynamic Color:** Disabled (brand consistency)

**Design Tokens:**
- [ ] ColorScheme.fromSeed
- [ ] Material 3 typography
- [ ] 12dp corner radius for cards
```

#### 6. Testing Strategy
**Before:**
```markdown
- [ ] XCTest for unit tests
- [ ] Real device testing (iPhone/iPad)
```

**After:**
```markdown
- [ ] flutter_test for unit tests
- [ ] Widget tests for UI components
- [ ] Real device testing (iOS: iPhone/iPad, Android: Phone/Tablet)
```

#### 7. Performance Requirements
**Add Flutter-Specific NFRs:**
```markdown
**Flutter-Specific Requirements:**
- **UI Performance:** 60 FPS on scrolling views (measured with DevTools)
- **App Startup:** Cold <2s, Warm <500ms
- **Background Processing:** Heavy operations on isolates
- **Shader Pre-compilation:** iOS builds use --bundle-sksl-path
```

---

## 🛠️ Architecture Mapping Reference

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

---

## 📦 Standard Flutter Dependencies

Include this in all PRDs under "Dependencies" section:

```yaml
dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0

  # Database (Local Persistence)
  drift: ^2.14.0
  drift_flutter: ^0.1.0
  sqlite3_flutter_libs: ^0.5.0

  # Networking
  dio: ^5.4.0
  dio_cache_interceptor: ^3.4.0  # For caching
  web_socket_channel: ^2.4.0     # For WebSocket features

  # [Add feature-specific packages below]

dev_dependencies:
  build_runner: ^2.4.0
  riverpod_generator: ^2.3.0
  drift_dev: ^2.14.0
  flutter_test:
    sdk: flutter
```

**Feature-Specific Additions:**
- **Camera features:** `camera: ^0.10.5`
- **Barcode scanning:** `mobile_scanner: ^3.5.0`
- **Image processing:** `image: ^4.1.3`, `image_picker: ^1.0.4`
- **File access:** `path_provider: ^2.1.1`
- **Navigation:** `go_router: ^12.0.0`

---

## 🎨 Material Design 3 Standard Section

Include this in all PRDs under "Design & User Experience":

```markdown
### Material Design 3 Compliance

**Color Scheme:**
- **Primary Seed Color:** `#1976D2` (Blue 700)
- **Dynamic Color Support:** Disabled (maintain consistent brand identity)
- **Light/Dark Mode:** Both supported via `ThemeMode.system`

**Design Tokens:**
- [ ] Material 3 color system (`ColorScheme.fromSeed`)
- [ ] Typography scale (Material 3 text styles)
- [ ] Elevation and shadows (proper Card elevation)
- [ ] Corner radius (12dp for cards, 8dp for buttons)
- [ ] Proper navigation patterns (push vs bottom sheet vs dialog)
```

---

## ✅ Conversion Checklist (Per PRD)

Use this checklist for each PRD conversion:

### Header Section
- [ ] Change "iOS Developer" → "Flutter Developer"
- [ ] Add "Target Platform: iOS and Android"
- [ ] Change "Build X" → "Version X.X.X"

### User Stories
- [ ] Remove iOS version numbers (e.g., "iOS 26.0+")
- [ ] Change platform-specific terms ("iPhone" → "device")
- [ ] Keep acceptance criteria (mostly unchanged)

### Technical Architecture
- [ ] Update component table (View → Widget, @Observable → StateNotifier)
- [ ] Change file paths (`.swift` → `.dart`, proper lib/ structure)
- [ ] Update type column (Widget / Provider / Service)

### Data Models
- [ ] Convert SwiftData syntax to Drift syntax
- [ ] Change `@Model` → `extends Table`
- [ ] Update property syntax (`public var` → `Column get`)

### Dependencies
- [ ] Replace iOS frameworks with Flutter packages
- [ ] Use standard dependency template (above)
- [ ] Add feature-specific packages

### Design & UX
- [ ] Replace "iOS HIG" section with "Material Design 3"
- [ ] Use Material Design 3 standard section (above)
- [ ] Remove iOS-specific terms (Liquid Glass, ultraThinMaterial)

### Testing
- [ ] Change XCTest → flutter_test
- [ ] Add widget tests section
- [ ] Update device list (iOS + Android)
- [ ] Add platform-specific test cases

### Performance
- [ ] Add Flutter-specific NFRs (60 FPS, startup time, isolates)
- [ ] Keep existing performance targets
- [ ] Add DevTools measurement note

### Rollout
- [ ] Add "Android" to beta testing (Internal Testing track)
- [ ] Add "Play Store" to GA phase
- [ ] Update rollback plan for both platforms

### Launch Checklist
- [ ] Add "Widget tests" to pre-launch
- [ ] Change "iOS HIG" → "Material Design 3"
- [ ] Add "TalkBack" alongside "VoiceOver"
- [ ] Add "both platforms" where relevant

---

## 🚫 Common Mistakes to Avoid

1. **Don't change backend/API sections** - Cloudflare Workers is platform-agnostic
2. **Don't change user stories** - Business logic is platform-independent
3. **Don't change success metrics** - KPIs are the same
4. **Don't add unnecessary Flutter jargon** - Keep it readable for Product/Design
5. **Don't forget platform-specific testing** - Both iOS and Android matter

---

## 🎓 Learning Resources

**For developers new to Flutter:**
- [Flutter Official Docs](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Drift Documentation](https://drift.simonbinder.eu/)
- [Material Design 3](https://m3.material.io/)

**For understanding the conversion:**
- See `Bookshelf-Scanner-PRD-Flutter.md` for complete example
- See `Search-PRD-Flutter.md` for second example
- See `PRD-Template.md` for standard template

---

## 📝 Conversion Workflow

### Step-by-Step Process
1. **Copy original iOS PRD** to `[FeatureName]-PRD-Flutter.md`
2. **Update header** (Engineering Lead, Target Platform, Status)
3. **Leave unchanged:** Executive Summary, Problem Statement, Target Users, Success Metrics, User Stories (mostly), API Contracts
4. **Convert Technical Architecture** using mapping reference
5. **Convert Data Models** (SwiftData → Drift syntax)
6. **Update Dependencies** using standard template
7. **Replace Design section** with Material Design 3
8. **Update Testing** strategy for both platforms
9. **Add Flutter-specific** performance requirements
10. **Update Rollout Plan** for both app stores
11. **Review** for iOS-specific terminology
12. **Mark as Draft** until implementation starts

---

## 🤝 Expert Validation Summary

Based on deep analysis and expert consultation (Gemini 2.5 Pro):

### Validated Decisions
✅ **Riverpod** for state management (best SwiftUI equivalent)
✅ **Drift** for database (type-safe, reactive, scalable)
✅ **Material Design 3** for design system (cross-platform consistency)
✅ **Dio** for networking (enhanced HTTP with caching)
✅ **mobile_scanner** for barcodes (VisionKit equivalent)

### Key Insights
- **60% of PRD content** is reusable as-is
- **40% requires conversion** (technical sections only)
- **Backend is unchanged** - huge advantage!
- **All iOS features** have mature Flutter equivalents
- **Material 3 + Riverpod** = closest to SwiftUI experience

---

## 📊 Conversion Progress

**Completed:** 6 / 16 PRDs (37.5%)
- ✅ PRD-Template.md (Updated template)
- ✅ Bookshelf-Scanner-PRD-Flutter.md (Full AI scanner feature)
- ✅ Search-PRD-Flutter.md (Multi-mode search)
- ✅ Mobile-Scanner-PRD-Flutter.md (Barcode scanning with mobile_scanner)
- ✅ Review-Queue-PRD-Flutter.md (Human-in-the-loop corrections)
- ✅ FLUTTER_CONVERSION_GUIDE.md (This guide)

**Remaining:** 10 PRDs

**Estimated Time:**
- Simple PRD (Settings, Review Queue): 30-45 minutes
- Medium PRD (Reading Stats, Diversity Insights): 1-1.5 hours
- Complex PRD (CloudKit Sync, Enrichment Pipeline): 2-3 hours

**Total Estimated Time:** 15-20 hours for all remaining PRDs

---

## 🎯 Next Steps

1. **Choose next PRD to convert** (recommend: VisionKit-Barcode-Scanner as it's similar to mobile_scanner)
2. **Follow conversion checklist** systematically
3. **Use examples as reference** (Bookshelf Scanner, Search)
4. **Review with team** before marking as approved
5. **Update this guide** if you discover new patterns

---

**Questions or Issues?**
- Refer to converted examples (Bookshelf Scanner, Search)
- Check architecture mapping reference
- Consult Flutter/Riverpod/Drift documentation
- Ask for clarification on ambiguous sections

---

*Last Updated: November 12, 2025*
*Maintained by: Flutter Engineering Team*
