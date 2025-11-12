# Flutter Conversion - Quick Reference Card

**📱 One-page cheat sheet for converting iOS PRDs to Flutter**

---

## ⚡ Quick Substitution Guide

### Architecture Patterns
| iOS | Flutter |
|-----|---------|
| `SwiftUI View` | `StatelessWidget` or `ConsumerWidget` |
| `@Observable class` | `StateNotifier` (Riverpod) |
| `@State var` | `useState` or `StateProvider` |
| `@Binding var` | `ref.watch(provider)` |
| `@globalActor` | `Isolate.run()` |
| `NavigationStack` | `GoRouter` |
| `.sheet()` | `showModalBottomSheet()` |

### Data & Storage
| iOS | Flutter |
|-----|---------|
| `@Model class` | `class extends Table` (Drift) |
| `SwiftData` | `Drift` + `sqlite3_flutter_libs` |
| `UserDefaults` | `SharedPreferences` |
| `FileManager` | `path_provider` package |

### UI Components
| iOS | Flutter |
|-----|---------|
| `VStack` | `Column` |
| `HStack` | `Row` |
| `List` | `ListView` |
| `Text` | `Text` widget |
| `Button` | `ElevatedButton`, `TextButton`, etc. |
| `.padding()` | `Padding` widget |

### Camera & Vision
| iOS | Flutter |
|-----|---------|
| `AVFoundation` | `camera` package |
| `VisionKit` | `mobile_scanner` package |
| Barcode scanning | `mobile_scanner` (ML Kit + AVFoundation) |

### Networking
| iOS | Flutter |
|-----|---------|
| `URLSession` | `Dio` |
| HTTP caching | `dio_cache_interceptor` |
| WebSocket | `web_socket_channel` |

---

## 🎨 Material Design 3 Standard Template

```dart
// In every PRD "Design & UX" section:

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

---

## 📦 Standard Dependencies Block

```yaml
# Copy this into every PRD's "Dependencies" section:

dependencies:
  flutter:
    sdk: flutter

  # State Management
  flutter_riverpod: ^2.4.0
  riverpod_annotation: ^2.3.0

  # Database
  drift: ^2.14.0
  drift_flutter: ^0.1.0
  sqlite3_flutter_libs: ^0.5.0

  # Networking
  dio: ^5.4.0
  dio_cache_interceptor: ^3.4.0
  web_socket_channel: ^2.4.0

  # [Add feature-specific packages]

dev_dependencies:
  build_runner: ^2.4.0
  riverpod_generator: ^2.3.0
  drift_dev: ^2.14.0
```

---

## ⚙️ Standard Performance NFRs

```markdown
# Add to every PRD's "Non-Functional Requirements" section:

**Flutter-Specific Requirements:**
- **UI Performance:** 60 FPS on scrolling views (measured with DevTools)
- **App Startup:** Cold <2s, Warm <500ms
- **Background Processing:** Heavy operations on isolates
- **Memory Usage:** <250MB during typical usage
```

---

## ✅ 10-Step Conversion Checklist

- [ ] **1. Header:** Change "iOS" → "Flutter", add "Target Platform: iOS and Android"
- [ ] **2. Executive Summary:** No changes needed ✅
- [ ] **3. Problem Statement:** No changes needed ✅
- [ ] **4. User Stories:** Remove iOS version numbers only
- [ ] **5. Technical Architecture:** Use mapping table, update file paths
- [ ] **6. Data Models:** Convert SwiftData → Drift syntax
- [ ] **7. Dependencies:** Use standard template above
- [ ] **8. Design:** Replace iOS HIG → Material Design 3
- [ ] **9. Testing:** Change XCTest → flutter_test, add widget tests
- [ ] **10. Performance:** Add Flutter-specific NFRs

**Average time:** 45 minutes per PRD

---

## 🚫 What NOT to Change

✅ **Keep these sections as-is:**
- Executive Summary
- Problem Statement
- Target Users
- Success Metrics (KPIs)
- API Contracts (backend unchanged!)
- Business logic in functional requirements
- Open Questions & Risks
- User pain points

---

## 📁 File Naming Convention

`[Feature-Name]-PRD-Flutter.md`

**Examples:**
- `Bookshelf-Scanner-PRD-Flutter.md`
- `Search-PRD-Flutter.md`
- `Mobile-Scanner-PRD-Flutter.md`

---

## 🎯 Common Mistakes to Avoid

❌ **Don't change:**
- Backend/API endpoint documentation
- User stories (business logic)
- Success metrics / KPIs

❌ **Don't forget:**
- Platform permissions (Android + iOS)
- Widget tests in testing strategy
- Both app stores in rollout plan
- TalkBack + VoiceOver in accessibility

❌ **Don't use:**
- iOS-specific jargon ("Liquid Glass", "ultraThinMaterial")
- Swift code examples (use Dart)
- `.swift` file paths (use `lib/` structure)

---

## 📖 Reference Documents

**For converting:**
1. `PRD-Template.md` - Base template
2. `FLUTTER_CONVERSION_GUIDE.md` - Detailed guide
3. `Bookshelf-Scanner-PRD-Flutter.md` - Complex example
4. `Mobile-Scanner-PRD-Flutter.md` - Medium example

**For architecture:**
- Architecture mapping table (in conversion guide)
- Standard dependencies template (above)
- Material 3 section template (above)

---

## 💪 When You're Stuck

**Can't find Flutter equivalent?**
1. Check architecture mapping table
2. Search pub.dev for packages
3. Ask: "What's the Flutter equivalent of [iOS thing]?"

**Not sure if section needs changes?**
1. If it mentions business logic → Keep it
2. If it mentions iOS frameworks → Convert it
3. If it mentions backend → Keep it

**Example unclear?**
1. Look at completed PRDs
2. Focus on Bookshelf Scanner (most complete)
3. Check conversion guide for patterns

---

## 🎓 Learning Resources (2-Minute Links)

- **Riverpod:** https://riverpod.dev/docs/concepts/providers
- **Drift:** https://drift.simonbinder.eu/docs/getting-started/
- **Material 3:** https://m3.material.io/
- **mobile_scanner:** https://pub.dev/packages/mobile_scanner

---

## 📊 Progress Tracker

**Completed:** 6 / 16 PRDs (37.5%)

✅ PRD-Template.md
✅ Bookshelf-Scanner-PRD-Flutter.md
✅ Search-PRD-Flutter.md
✅ Mobile-Scanner-PRD-Flutter.md
✅ Review-Queue-PRD-Flutter.md
✅ FLUTTER_CONVERSION_GUIDE.md

**Remaining:** 10 PRDs (~12-15 hours)

---

**Print this page and keep it handy while converting! 🚀**
