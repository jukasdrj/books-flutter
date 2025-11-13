# ✅ Setup Checklist

Use this checklist to get your Flutter app running.

## Prerequisites

- [ ] **Flutter SDK installed** (3.2.0+)
  ```bash
  flutter --version
  ```

- [ ] **Xcode installed** (iOS development)
  ```bash
  xcodebuild -version
  ```

- [ ] **Android Studio installed** (Android development)

- [ ] **Firebase CLI installed**
  ```bash
  npm install -g firebase-tools
  firebase --version
  ```

- [ ] **FlutterFire CLI installed**
  ```bash
  dart pub global activate flutterfire_cli
  flutterfire --version
  ```

---

## Initial Setup

- [ ] **Navigate to project**
  ```bash
  cd /Users/justingardner/Downloads/vscode/books-flutter
  ```

- [ ] **Install dependencies**
  ```bash
  flutter pub get
  ```

- [ ] **Run Flutter doctor**
  ```bash
  flutter doctor
  ```
  Fix any issues shown (Xcode license, Android licenses, etc.)

---

## Firebase Configuration (Choose One)

### Option A: Skip Firebase (Quick Start)
- [ ] **Keep Firebase init commented out** in `lib/main.dart`
- [ ] App will run without cloud sync
- [ ] Skip to "Code Generation" section

### Option B: Full Firebase Setup (Recommended)
- [ ] **Create Firebase project**
  - Go to https://console.firebase.google.com/
  - Create project: "Books Tracker"
  - Accept defaults

- [ ] **Run FlutterFire configure**
  ```bash
  flutterfire configure
  ```
  - Select your Firebase project
  - Choose platforms: iOS, Android
  - Verify `lib/firebase_options.dart` was created

- [ ] **Enable Firebase Authentication**
  - Firebase Console → Authentication
  - Click "Get Started"
  - Enable: "Anonymous" and "Email/Password"

- [ ] **Create Firestore Database**
  - Firebase Console → Firestore Database
  - Click "Create database"
  - Start in: "Test mode"
  - Choose location (closest to users)

- [ ] **Create Firebase Storage**
  - Firebase Console → Storage
  - Click "Get started"
  - Start in: "Test mode"

- [ ] **Set Firestore Security Rules**
  Firebase Console → Firestore → Rules:
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

- [ ] **Set Storage Security Rules**
  Firebase Console → Storage → Rules:
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

- [ ] **Uncomment Firebase init** in `lib/main.dart`:
  ```dart
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  ```

---

## Code Generation

- [ ] **Generate Drift, Freezed, Riverpod code**
  ```bash
  flutter pub run build_runner build --delete-conflicting-outputs
  ```

- [ ] **Verify generated files exist:**
  - `lib/core/database/database.g.dart` ✅
  - `lib/core/models/dtos/work_dto.freezed.dart` ✅
  - `lib/core/models/dtos/work_dto.g.dart` ✅
  - `lib/core/providers/database_provider.g.dart` ✅

---

## Backend API Configuration (Later)

When you're ready to connect to your Cloudflare Workers backend:

- [ ] **Deploy Cloudflare Workers backend**
  (If you haven't already)

- [ ] **Get Worker URL**
  Example: `https://books-api.your-subdomain.workers.dev`

- [ ] **Update Search Service**
  Edit `lib/core/services/search_service.dart`:
  ```dart
  baseUrl: 'https://YOUR-WORKER-URL.workers.dev',
  ```

---

## Run the App

- [ ] **Open iOS Simulator**
  ```bash
  open -a Simulator
  ```

- [ ] **OR Open Android Emulator**
  - Android Studio → AVD Manager → Play button

- [ ] **Run Flutter app**
  ```bash
  flutter run
  ```

- [ ] **Verify app launches** and shows "My Library" screen

- [ ] **Test "Add Book" button** - shows bottom sheet with options

---

## Verify Everything Works

- [ ] **Hot reload works** - Press `r` in terminal
- [ ] **Hot restart works** - Press `R` in terminal
- [ ] **Material 3 theme applied** - Blue color scheme visible
- [ ] **Empty state displays** - "Your library is empty" message
- [ ] **No errors in console**

---

## Next Actions

- [ ] **Read NEXT_STEPS.md** for implementation roadmap

- [ ] **Start Week 4: Search Feature**
  - Estimated time: 4-6 hours
  - See detailed guide in NEXT_STEPS.md

- [ ] **Set up continuous code generation** (optional but recommended):
  ```bash
  flutter pub run build_runner watch
  ```
  This runs in background and auto-generates code on file save

---

## Common Issues & Solutions

### "Command not found: flutter"
**Solution:** Install Flutter SDK
```bash
brew install --cask flutter
# Or: https://docs.flutter.dev/get-started/install
```

### "MissingPluginException"
**Solution:** Hot restart (press `R` in terminal)

### "Failed to generate build"
**Solution:**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### "CocoaPods not installed" (iOS)
**Solution:**
```bash
sudo gem install cocoapods
cd ios
pod install
cd ..
```

### "Android license not accepted"
**Solution:**
```bash
flutter doctor --android-licenses
# Accept all licenses
```

### "Cannot find firebase_options.dart"
**Solution:**
```bash
flutterfire configure
# Select your project and platforms
```

---

## Quick Reference Commands

```bash
# Install dependencies
flutter pub get

# Generate code
flutter pub run build_runner build --delete-conflicting-outputs

# Watch mode (auto-generate on save)
flutter pub run build_runner watch

# Run app
flutter run

# Hot reload
r (in terminal while app is running)

# Hot restart
R (in terminal while app is running)

# Run tests
flutter test

# Clean build
flutter clean && flutter pub get

# Check for issues
flutter doctor
flutter analyze

# Format code
dart format .
```

---

## Success Criteria

✅ You're ready to start development when:

- [ ] App runs without errors
- [ ] Library screen displays
- [ ] Material 3 theme visible
- [ ] No build warnings
- [ ] Firebase configured (or intentionally skipped)
- [ ] Code generation working
- [ ] You've read NEXT_STEPS.md

---

**Estimated Setup Time:** 15-30 minutes (depending on Firebase choice)

**Next:** Implement Search feature (Week 4) 🔍

**Need help?** Check:
- README_FLUTTER.md (troubleshooting section)
- QUICKSTART.md (faster guide)
- NEXT_STEPS.md (implementation roadmap)

---

*Last Updated: November 12, 2025*
