# Books Tracker - Flutter App

A cross-platform book tracking application with AI-powered bookshelf scanning, built with Flutter, Firebase, and Material Design 3.

## 🚀 Features

- 📚 **Digital Library Management** - Track your book collection
- 📷 **AI Bookshelf Scanner** - Photograph bookshelves for instant detection (powered by Gemini 2.0 Flash)
- 🔍 **Multi-Mode Search** - Search by title, ISBN, author, or barcode
- ✅ **Review Queue** - Human-in-the-loop corrections for AI detections
- 📊 **Reading Statistics** - Analytics and insights on reading habits
- 🌍 **Diversity Insights** - Cultural diversity analysis
- ☁️ **Cloud Sync** - Firebase-powered backup and multi-device sync
- 🎨 **Material Design 3** - Modern, polished UI with Blue 700 seed color

## 📋 Prerequisites

### Required Software

1. **Flutter SDK** (3.2.0 or higher)
   ```bash
   # Install Flutter: https://docs.flutter.dev/get-started/install
   flutter --version
   ```

2. **Firebase CLI**
   ```bash
   npm install -g firebase-tools
   firebase login
   ```

3. **FlutterFire CLI**
   ```bash
   dart pub global activate flutterfire_cli
   ```

4. **Platform-Specific Tools**
   - **iOS:** Xcode 15.0+, CocoaPods
   - **Android:** Android Studio, Android SDK 33+

## 🛠️ Setup Instructions

### Step 1: Clone & Install Dependencies

```bash
cd books-flutter
flutter pub get
```

### Step 2: Configure Firebase

1. **Create Firebase Project**
   - Go to [Firebase Console](https://console.firebase.google.com/)
   - Create new project: "Books Tracker"
   - Enable Google Analytics (optional)

2. **Run FlutterFire Configuration**
   ```bash
   flutterfire configure
   ```
   - Select your Firebase project
   - Choose platforms: iOS, Android
   - This generates `lib/firebase_options.dart`

3. **Enable Firebase Services** (in Firebase Console):
   - **Authentication** → Enable Anonymous auth + Email/Password
   - **Firestore Database** → Create database (start in test mode)
   - **Storage** → Create bucket (for cover images, scan photos)

4. **Firestore Security Rules** (set in Console):
   ```javascript
   rules_version = '2';
   service cloud.firestore {
     match /databases/{database}/documents {
       match /users/{userId}/{document=**} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```

5. **Storage Security Rules**:
   ```javascript
   rules_version = '2';
   service firebase.storage {
     match /b/{bucket}/o {
       match /users/{userId}/{allPaths=**} {
         allow read, write: if request.auth != null && request.auth.uid == userId;
       }
     }
   }
   ```

### Step 3: Uncomment Firebase Initialization

Edit `lib/main.dart` and uncomment the Firebase init code:

```dart
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

### Step 4: Generate Code

```bash
# Generate Drift database, Freezed models, Riverpod providers
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates:
- `database.g.dart` - Drift database code
- `*.freezed.dart` - Freezed immutable models
- `*.g.dart` - JSON serialization code
- `*_provider.g.dart` - Riverpod provider code

### Step 5: Configure Backend API

Edit `lib/core/services/search_service.dart` and set your Cloudflare Workers URL:

```dart
final Dio _dio = Dio(BaseOptions(
  baseUrl: 'https://your-worker.workers.dev', // YOUR URL HERE
));
```

### Step 6: Run the App

```bash
# iOS
flutter run -d iphone

# Android
flutter run -d android

# Or select device interactively
flutter run
```

## 📁 Project Structure

```
lib/
├── core/                       # Core business logic
│   ├── database/
│   │   ├── database.dart       # Drift database schema
│   │   └── database.g.dart     # Generated database code
│   ├── models/
│   │   └── dtos/               # API Data Transfer Objects
│   │       └── work_dto.dart   # WorkDTO, EditionDTO, ResponseEnvelope
│   ├── providers/              # Riverpod providers
│   │   └── database_provider.dart
│   └── services/
│       ├── dto_mapper.dart     # API DTO → Drift model conversion
│       ├── firebase_auth_service.dart
│       └── firebase_sync_service.dart
│
├── features/                   # Feature modules
│   ├── library/
│   │   └── screens/
│   │       └── library_screen.dart
│   ├── search/
│   ├── bookshelf_scanner/
│   └── review_queue/
│
├── shared/                     # Shared UI components
│   ├── theme/
│   │   └── app_theme.dart      # Material 3 theme
│   └── widgets/
│
└── main.dart                   # App entry point
```

## 🎨 Material Design 3 Theme

The app uses Material Design 3 with a custom seed color:

- **Seed Color:** `#1976D2` (Blue 700)
- **Dynamic Color:** Disabled (brand consistency)
- **Light/Dark Mode:** Both supported via `ThemeMode.system`
- **Corner Radius:** 12dp for cards, 8dp for buttons
- **Typography:** Material 3 text styles

## 🗄️ Database Schema (Drift/SQLite)

### Tables

1. **Works** - Abstract creative work
   - id, title, author, subjectTags
   - reviewStatus, synthetic, primaryProvider
   - AI confidence, bounding box, original image path
   - Timestamps

2. **Editions** - Physical/digital manifestation
   - id, workId (FK), isbn, isbns
   - publisher, coverImageURL, format
   - External IDs (Google Books, OpenLibrary)

3. **Authors** - Creator
   - id, name, gender, culturalRegion
   - External IDs

4. **WorkAuthors** - Many-to-many junction table

### Key Enums

- `ReviewStatus`: verified, needsReview, userEdited
- `EditionFormat`: hardcover, paperback, ebook, audiobook, unknown
- `AuthorGender`: male, female, nonBinary, unknown
- `CulturalRegion`: northAmerica, europe, africa, etc.

## 🔥 Firebase Structure

### Firestore Collections

```
users/
  {userId}/
    works/
      {workId}:
        - title: string
        - author: string
        - subjectTags: string[]
        - synthetic: boolean
        - primaryProvider: string
        - createdAt: timestamp
        - updatedAt: timestamp
```

### Firebase Storage

```
users/{userId}/
  covers/          # Book cover images
  scans/           # Bookshelf scan photos
  cropped/         # Review queue cropped spines
```

## 🧪 Testing

```bash
# Run all tests
flutter test

# Run with coverage
flutter test --coverage

# Widget tests
flutter test test/features/

# Unit tests
flutter test test/core/
```

## 📦 Building for Release

### iOS

```bash
# Update version in pubspec.yaml
# version: 1.0.0+1

# Build IPA
flutter build ipa --release

# Open Xcode for signing/upload
open ios/Runner.xcworkspace
```

### Android

```bash
# Build APK
flutter build apk --release

# Build App Bundle (for Play Store)
flutter build appbundle --release
```

## 🚧 Current Implementation Status

### ✅ Completed (Week 1-3)
- [x] Project structure
- [x] Drift database schema
- [x] API DTOs (matching canonical contracts)
- [x] Firebase integration (Auth, Firestore, Storage)
- [x] Riverpod providers
- [x] Material 3 theme
- [x] Library screen (basic UI)

### 🚀 Next Steps (Week 4-10)

1. **Week 4:** Search feature + API integration
2. **Week 5:** Unit & widget tests
3. **Week 6:** Mobile scanner (barcode)
4. **Week 7:** Review queue (image cropping)
5. **Week 8-9:** Bookshelf AI scanner (camera, WebSocket)
6. **Week 10:** Settings & statistics

See `product/FLUTTER_CONVERSION_GUIDE.md` for detailed conversion roadmap.

## 🔑 API Endpoints

All endpoints use canonical contracts from `Canonical-Data-Contracts-PRD.md`:

- `GET /v1/search/title?q={query}` - Title search
- `GET /v1/search/isbn?isbn={isbn}` - ISBN lookup
- `GET /v1/search/advanced?title={title}&author={author}` - Advanced search
- `POST /api/scan-bookshelf` - Upload bookshelf photo for AI processing
- `WebSocket /ws/progress?jobId={uuid}` - Real-time scan progress

### Response Format

```json
{
  "success": true,
  "data": {
    "works": [...],
    "editions": [...],
    "authors": [...]
  },
  "meta": {
    "timestamp": "2025-11-12T12:00:00Z",
    "processingTime": 450,
    "provider": "google-books",
    "cached": false
  }
}
```

## 🐛 Troubleshooting

### Build Runner Issues

```bash
# Clean generated files
flutter clean
flutter pub get
flutter pub run build_runner clean

# Rebuild
flutter pub run build_runner build --delete-conflicting-outputs
```

### Firebase Issues

```bash
# Re-configure Firebase
flutterfire configure

# Check Firebase project
firebase projects:list
```

### iOS Build Issues

```bash
cd ios
pod install
pod update
cd ..
flutter clean
flutter run
```

### Android Build Issues

```bash
# Update dependencies
flutter pub get

# Clean build
flutter clean

# Rebuild
flutter run
```

## 📚 Resources

- [Flutter Documentation](https://docs.flutter.dev/)
- [Riverpod Documentation](https://riverpod.dev/)
- [Drift Documentation](https://drift.simonbinder.eu/)
- [Material Design 3](https://m3.material.io/)
- [Firebase for Flutter](https://firebase.flutter.dev/)

## 🤝 Contributing

1. Follow Flutter style guide
2. Run `flutter analyze` before commit
3. Write tests for new features
4. Use conventional commits

## 📄 License

See LICENSE file

---

**Built with ❤️ using Flutter, Firebase, and Material Design 3**

*Last Updated: November 12, 2025*
