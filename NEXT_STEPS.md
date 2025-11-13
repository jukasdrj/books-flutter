# 🚀 Next Steps - Implementation Roadmap

Your Flutter project foundation is complete! Here's your step-by-step implementation plan.

## ✅ What You Have Now (Foundation Complete)

- [x] **Project Structure** - Clean architecture with feature modules
- [x] **Database Schema** - Drift tables (Works, Editions, Authors)
- [x] **API DTOs** - Canonical contracts matching backend
- [x] **Firebase Integration** - Auth, Firestore, Storage setup
- [x] **State Management** - Riverpod providers configured
- [x] **Material 3 Theme** - Blue 700 seed color, light/dark modes
- [x] **Library Screen** - Basic UI with empty state

## 🎯 Before You Start Coding

### 1. Install Flutter (if not already)

```bash
# macOS
brew install --cask flutter

# Or download from: https://docs.flutter.dev/get-started/install
```

Verify installation:
```bash
flutter doctor
```

Fix any issues shown (Xcode, Android Studio, etc.)

### 2. Run Code Generation

```bash
cd /Users/justingardner/Downloads/vscode/books-flutter
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### 3. Set Up Firebase

Follow `QUICKSTART.md` Step 2 (Option A to skip, Option B for full setup)

### 4. Test the App

```bash
# Open iOS Simulator or Android Emulator first, then:
flutter run
```

You should see the Library screen!

---

## 📅 Week-by-Week Implementation Plan

### **Week 4: Search Feature** (Start Here! 🎯)

**Goal:** Build search screen, integrate with your Cloudflare Workers API

**Files to Create:**
1. `lib/features/search/screens/search_screen.dart`
2. `lib/features/search/providers/search_provider.dart`
3. `lib/core/services/search_service.dart`

**Implementation Steps:**

1. **Create Search Service** (`lib/core/services/search_service.dart`):
   ```dart
   import 'package:dio/dio.dart';
   import '../models/dtos/work_dto.dart';

   class SearchService {
     final Dio _dio = Dio(BaseOptions(
       baseUrl: 'https://YOUR-WORKER.workers.dev',
     ));

     Future<ResponseEnvelope<SearchResponseData>> searchByTitle(String query) async {
       final response = await _dio.get('/v1/search/title',
         queryParameters: {'q': query},
       );
       return ResponseEnvelope.fromJson(
         response.data,
         (json) => SearchResponseData.fromJson(json as Map<String, dynamic>),
       );
     }

     Future<ResponseEnvelope<SearchResponseData>> searchByISBN(String isbn) async {
       final response = await _dio.get('/v1/search/isbn',
         queryParameters: {'isbn': isbn},
       );
       return ResponseEnvelope.fromJson(
         response.data,
         (json) => SearchResponseData.fromJson(json as Map<String, dynamic>),
       );
     }
   }
   ```

2. **Create Riverpod Provider** (`lib/features/search/providers/search_provider.dart`):
   ```dart
   import 'package:riverpod_annotation/riverpod_annotation.dart';
   import '../../../core/services/search_service.dart';
   import '../../../core/models/dtos/work_dto.dart';

   part 'search_provider.g.dart';

   @riverpod
   SearchService searchService(SearchServiceRef ref) {
     return SearchService();
   }

   @riverpod
   class SearchResults extends _$SearchResults {
     @override
     Future<SearchResponseData?> build() async => null;

     Future<void> searchByTitle(String query) async {
       state = const AsyncValue.loading();
       final service = ref.read(searchServiceProvider);
       state = await AsyncValue.guard(() async {
         final envelope = await service.searchByTitle(query);
         if (envelope.success && envelope.data != null) {
           return envelope.data!;
         }
         throw Exception(envelope.error?.message ?? 'Search failed');
       });
     }
   }
   ```

3. **Build Search Screen** - See `product/Search-PRD-Flutter.md` for full UI spec

4. **Test with Real API:**
   - Deploy your Cloudflare Workers backend
   - Update `baseUrl` in SearchService
   - Test title search: "Harry Potter"
   - Test ISBN search: "978-0-13-110362-7"

**Success Criteria:**
- ✅ Search by title returns results
- ✅ Results mapped to DTOs correctly
- ✅ DTOs converted to Drift models
- ✅ Books saved to local database
- ✅ Books appear in Library screen

---

### **Week 5: Testing Infrastructure**

**Goal:** Set up testing patterns for future features

**Files to Create:**
1. `test/core/services/dto_mapper_test.dart`
2. `test/features/library/library_screen_test.dart`
3. `test/core/database/database_test.dart`

**Example Unit Test:**
```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:books_tracker/core/services/dto_mapper.dart';

void main() {
  group('DTOMapper', () {
    test('maps WorkDTO to WorksCompanion correctly', () {
      final dto = WorkDTO(
        title: 'Test Book',
        subjectTags: ['Fiction'],
        synthetic: true,
      );

      final companion = DTOMapper._mapWorkDTOToCompanion(dto, null);

      expect(companion.title.value, 'Test Book');
      expect(companion.subjectTags.value, ['Fiction']);
      expect(companion.synthetic.value, true);
    });
  });
}
```

**Run tests:**
```bash
flutter test
flutter test --coverage
```

---

### **Week 6: Barcode Scanner**

**Goal:** Implement ISBN barcode scanning with `mobile_scanner`

**Package to Add:**
```yaml
dependencies:
  mobile_scanner: ^3.5.0
  permission_handler: ^11.0.1
```

**Files to Create:**
1. `lib/features/mobile_scanner/screens/barcode_scanner_screen.dart`
2. `lib/features/mobile_scanner/widgets/scanner_overlay.dart`

**Key Implementation:**
```dart
import 'package:mobile_scanner/mobile_scanner.dart';

MobileScanner(
  controller: MobileScannerController(
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  ),
  onDetect: (capture) {
    final List<Barcode> barcodes = capture.barcodes;
    for (final barcode in barcodes) {
      if (barcode.rawValue != null) {
        final isbn = barcode.rawValue!;
        // Call search by ISBN
        ref.read(searchResultsProvider.notifier).searchByISBN(isbn);
        Navigator.pop(context);
      }
    }
  },
)
```

**Permissions:**
- iOS: Add to `ios/Runner/Info.plist`:
  ```xml
  <key>NSCameraUsageDescription</key>
  <string>Scan book barcodes to add to library</string>
  ```
- Android: Add to `android/app/src/main/AndroidManifest.xml`:
  ```xml
  <uses-permission android:name="android.permission.CAMERA"/>
  ```

**Success Criteria:**
- ✅ Camera opens on scanner screen
- ✅ Barcode detected and parsed
- ✅ ISBN search triggered automatically
- ✅ Book added to library

---

### **Week 7: Review Queue**

**Goal:** UI for reviewing low-confidence AI detections

**Files to Create:**
1. `lib/features/review_queue/screens/review_queue_screen.dart`
2. `lib/features/review_queue/widgets/review_card.dart`
3. `lib/features/review_queue/providers/review_queue_provider.dart`

**Key Features:**
- Display works where `reviewStatus == ReviewStatus.needsReview`
- Show cropped spine image (from `originalImagePath`)
- Allow manual title/author correction
- Mark as verified or delete

**Provider:**
```dart
@riverpod
Stream<List<Work>> reviewQueue(ReviewQueueRef ref) {
  final db = ref.watch(databaseProvider);
  return db.watchReviewQueue();
}
```

---

### **Week 8-9: Bookshelf AI Scanner** (Most Complex!)

**Goal:** Camera + AI + WebSocket integration

**Packages Needed:**
```yaml
dependencies:
  camera: ^0.10.5
  image: ^4.1.3
  web_socket_channel: ^2.4.0
```

**Files to Create:**
1. `lib/features/bookshelf_scanner/screens/scanner_screen.dart`
2. `lib/features/bookshelf_scanner/services/camera_manager.dart`
3. `lib/features/bookshelf_scanner/services/websocket_progress_manager.dart`
4. `lib/core/services/bookshelf_ai_service.dart`

**Implementation Flow:**
1. User taps "Scan Bookshelf"
2. Camera preview opens
3. User captures photo
4. Upload to `/api/scan-bookshelf?jobId={uuid}`
5. Connect WebSocket to `/ws/progress?jobId={uuid}`
6. Show real-time progress (AI processing, enrichment)
7. Display results in Review Queue
8. User reviews/confirms detections
9. Books added to library

**See:** `product/Bookshelf-Scanner-PRD-Flutter.md` for complete spec

---

### **Week 10: Settings & Statistics**

**Goal:** User preferences and reading analytics

**Files to Create:**
1. `lib/features/settings/screens/settings_screen.dart`
2. `lib/features/statistics/screens/statistics_screen.dart`
3. `lib/core/services/preferences_service.dart`

**Settings to Include:**
- Theme mode (light/dark/system)
- Firebase sync on/off
- Clear cache
- About/version info

**Statistics to Show:**
- Total books
- Books by genre (pie chart)
- Reading diversity (cultural regions)
- Books added over time (line chart)

**Package for Charts:**
```yaml
dependencies:
  fl_chart: ^0.65.0
```

---

## 🔧 Development Commands Cheat Sheet

```bash
# Install dependencies
flutter pub get

# Generate code (run after changing DTOs, database, providers)
flutter pub run build_runner build --delete-conflicting-outputs

# Run app
flutter run

# Run tests
flutter test

# Format code
dart format .

# Analyze code
flutter analyze

# Clean build
flutter clean
flutter pub get

# Build for release (iOS)
flutter build ipa --release

# Build for release (Android)
flutter build appbundle --release
```

---

## 📚 Reference Documents

- **API Contracts:** `product/Canonical-Data-Contracts-PRD.md`
- **Search Spec:** `product/Search-PRD-Flutter.md`
- **Scanner Spec:** `product/Bookshelf-Scanner-PRD-Flutter.md`
- **Review Queue Spec:** `product/Review-Queue-PRD-Flutter.md`
- **Mobile Scanner Spec:** `product/Mobile-Scanner-PRD-Flutter.md`
- **Architecture Guide:** `CLAUDE.md`
- **Conversion Guide:** `product/FLUTTER_CONVERSION_GUIDE.md`

---

## 🎯 Recommended Order of Implementation

1. ✅ **Foundation** (Done!)
2. 🔍 **Search** (Week 4) ← **START HERE**
3. 🧪 **Testing** (Week 5)
4. 📷 **Barcode Scanner** (Week 6)
5. ✅ **Review Queue** (Week 7)
6. 📚 **AI Bookshelf Scanner** (Week 8-9)
7. ⚙️ **Settings & Stats** (Week 10)

---

## 💡 Pro Tips

1. **Always run code generation after changing models:**
   ```bash
   flutter pub run build_runner watch
   ```
   (Runs in background, auto-generates on file save)

2. **Use Flutter DevTools for debugging:**
   ```bash
   flutter run
   # Then open: http://localhost:9100
   ```

3. **Test on real devices early** - Emulators can't test camera/barcode features

4. **Keep backend URL in environment variable:**
   - Create `.env` file (add to .gitignore)
   - Use `flutter_dotenv` package
   - `API_URL=https://your-worker.workers.dev`

5. **Use hot reload (r) and hot restart (R)** - Saves tons of time!

---

## 🚨 Common Gotchas

1. **Forgot to generate code?** → `*.g.dart` files missing errors
2. **Firebase not initialized?** → Check `main.dart` Firebase init
3. **Camera permission denied?** → Check Info.plist / AndroidManifest.xml
4. **WebSocket connection fails?** → CORS issue, check backend config
5. **Drift queries not updating UI?** → Use `watch()` instead of `get()`

---

## 🎉 You're Ready!

Your foundation is rock-solid. Time to build features! 🚀

**First Task:** Implement Search (Week 4)
**Time Estimate:** 4-6 hours
**Difficulty:** Easy ⭐️

Good luck! 🍀
