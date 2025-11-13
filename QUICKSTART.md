# 🚀 Quick Start Guide

Get the Books Tracker Flutter app running in **15 minutes**.

## ⚡ Prerequisites Check

```bash
# Check Flutter (should be 3.2.0+)
flutter --version

# Check Dart
dart --version

# Check Firebase CLI
firebase --version

# Check FlutterFire CLI
flutterfire --version
```

**Don't have these?** See [README_FLUTTER.md](README_FLUTTER.md#prerequisites) for installation instructions.

## 📦 Step 1: Install Dependencies (2 min)

```bash
cd books-flutter
flutter pub get
```

## 🔥 Step 2: Configure Firebase (5 min)

### Option A: Skip Firebase for now (fastest)

The app will run without Firebase, but cloud sync won't work.

```dart
// lib/main.dart is already configured to skip Firebase if not set up
// Just run the app!
```

### Option B: Set up Firebase (recommended)

1. **Create Firebase project:** https://console.firebase.google.com/
   - Project name: `Books Tracker`
   - Click "Continue" through the setup

2. **Run FlutterFire configuration:**
   ```bash
   flutterfire configure
   ```
   - Select your project
   - Choose: iOS, Android
   - This creates `lib/firebase_options.dart`

3. **Enable services in Firebase Console:**
   - **Authentication** → Get Started → Enable "Anonymous" and "Email/Password"
   - **Firestore** → Create Database → Start in test mode → Choose region
   - **Storage** → Get Started → Start in test mode

4. **Uncomment Firebase init in `lib/main.dart`:**
   ```dart
   // Change this:
   // await Firebase.initializeApp(
   //   options: DefaultFirebaseOptions.currentPlatform,
   // );

   // To this:
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   ```

## 🏗️ Step 3: Generate Code (3 min)

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

This generates:
- Database code (`database.g.dart`)
- Model code (`*.freezed.dart`, `*.g.dart`)
- Provider code (`*_provider.g.dart`)

**Note:** You'll see warnings about missing generated files - that's normal!

## ▶️ Step 4: Run the App! (2 min)

```bash
# iOS Simulator
flutter run -d iphone

# Android Emulator
flutter run -d android

# Or let Flutter pick
flutter run
```

You should see:
- ✅ Material 3 theme with blue color scheme
- ✅ "My Library" screen with empty state
- ✅ "Add Book" floating action button
- ✅ Bottom sheet with add options (placeholders)

## 🎉 Success!

Your app is running! Here's what works out of the box:

- ✅ **Database:** Drift SQLite is ready (empty)
- ✅ **UI:** Material Design 3 theme
- ✅ **State:** Riverpod providers set up
- ✅ **Navigation:** Basic screens ready

## 🔧 What's Next?

### Connect to Backend API

Edit `lib/core/services/search_service.dart`:

```dart
baseUrl: 'https://your-cloudflare-worker.workers.dev',
```

### Add Test Data

Create `lib/core/utils/sample_data.dart`:

```dart
import 'package:uuid/uuid.dart';
import '../database/database.dart';
import 'package:drift/drift.dart';

Future<void> insertSampleData(AppDatabase db) async {
  const uuid = Uuid();

  await db.insertWorkWithAuthors(
    WorksCompanion.insert(
      id: uuid.v4(),
      title: 'The Great Gatsby',
      author: Value('F. Scott Fitzgerald'),
      subjectTags: Value(['Fiction', 'Classic Literature']),
    ),
    [
      AuthorsCompanion.insert(
        id: uuid.v4(),
        name: 'F. Scott Fitzgerald',
      ),
    ],
  );
}
```

Then call it from `main.dart`:
```dart
// After database initialization
final db = ProviderContainer().read(databaseProvider);
await insertSampleData(db);
```

### Start Building Features

Follow the roadmap in `README_FLUTTER.md`:
1. Search screen (Week 4)
2. Barcode scanner (Week 6)
3. AI bookshelf scanner (Week 8-9)

## 🐛 Common Issues

### "Unhandled Exception: MissingPluginException"

**Solution:** Hot restart (press 'R' in terminal or restart app)

### "Failed to generate build"

**Solution:**
```bash
flutter clean
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

### "Firebase not found"

**Solution:** Either skip Firebase (Option A above) or complete Firebase setup (Option B)

### "Unable to find libsqlite3.so"

**Android only - add to `android/app/build.gradle`:
```gradle
android {
    defaultConfig {
        ndk {
            abiFilters 'armeabi-v7a', 'arm64-v8a', 'x86_64'
        }
    }
}
```

## 📚 Learning Resources

- **Riverpod:** https://riverpod.dev/docs/getting_started
- **Drift:** https://drift.simonbinder.eu/docs/getting-started/
- **Material 3:** https://m3.material.io/
- **Firebase:** https://firebase.flutter.dev/

## 💬 Need Help?

1. Check `README_FLUTTER.md` troubleshooting section
2. Review PRDs in `product/` folder
3. See architecture in `CLAUDE.md`

---

**Total Time:** 12-15 minutes ⚡

**Next:** Build the Search feature (Week 4) 🔍
