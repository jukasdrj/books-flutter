# Firebase App Cleanup & Standardization Plan

**Date:** November 12, 2025
**Project:** flutter-books (ID: flutter-books-857d3)

## Current State

### Registered Apps
| Display Name | App ID | Platform | Package/Bundle ID | Status |
|--------------|--------|----------|-------------------|--------|
| books_tracker (android) | 1:989217966501:android:174a9bb2ecfa163315c04c | ANDROID | Unknown (Duplicate 1) | ❌ DELETE |
| books_tracker (android) | 1:989217966501:android:6becaa7e51835fcb15c04c | ANDROID | Unknown (Duplicate 2) | ❌ DELETE |
| books_tracker (android) | 1:989217966501:android:a668e9e2b6213cdc15c04c | ANDROID | oooefam.com | ⚠️ KEEP (needs update) |
| books_tracker (ios) | 1:989217966501:ios:c4551f428c121e3015c04c | IOS | com.example.booksTracker | ⚠️ KEEP (needs update) |
| books_tracker (web) | 1:989217966501:web:437fbc21f8f3877415c04c | WEB | books-tracker-web | ⚠️ KEEP (needs update) |

### Current Package/Bundle IDs
```
Android:  oooefam.com              (non-standard, should be reverse domain)
iOS:      com.example.booksTracker (uses "example", should use your domain)
macOS:    Not registered yet
Web:      books-tracker-web
```

## Recommended Target State

### Standardized Naming Convention

**App Display Names:**
```
Android:  BooksTrack (Android)
iOS:      BooksTrack (iOS)
macOS:    BooksTrack (macOS)
Web:      BooksTrack (Web)
```

**Package/Bundle IDs (RECOMMENDED):**
```
Android:  com.oooefam.bookstrack
iOS:      com.oooefam.bookstrack
macOS:    com.oooefam.bookstrack
Web:      bookstrack-web (or com.oooefam.bookstrack)
```

### Why This Structure?
- ✅ **Professional:** Uses your domain (oooefam.com)
- ✅ **Consistent:** Same identifier across all platforms
- ✅ **Standard:** Follows reverse domain notation (com.domain.appname)
- ✅ **Clean:** Lowercase, no special characters, no "example"
- ✅ **Brandable:** "BooksTrack" is clear and memorable

## Step-by-Step Cleanup Process

### Phase 1: Delete Duplicate Android Apps (Firebase Console)

**URL:** https://console.firebase.google.com/project/flutter-books-857d3/settings/general

1. **Delete First Duplicate:**
   - Scroll to "Your apps" → Android section
   - Find app: `1:989217966501:android:174a9bb2ecfa163315c04c`
   - Click settings icon (⚙️) → Delete app
   - Confirm deletion

2. **Delete Second Duplicate:**
   - Find app: `1:989217966501:android:6becaa7e51835fcb15c04c`
   - Click settings icon (⚙️) → Delete app
   - Confirm deletion

3. **Keep Third Android App (for now):**
   - App ID: `1:989217966501:android:a668e9e2b6213cdc15c04c`
   - Package: `oooefam.com`
   - This is your current working app

### Phase 2: Update Package/Bundle IDs (Code Changes)

#### Option A: Keep Current IDs (Quick Fix - Less Ideal)
Just standardize Firebase display names to match existing IDs.

**Pros:** No code changes, works immediately
**Cons:** Android package "oooefam.com" is non-standard, iOS uses "example"

#### Option B: Migrate to New IDs (Recommended - More Work)
Update all package/bundle IDs to `com.oooefam.bookstrack`

**Pros:** Professional, consistent, follows best practices
**Cons:** Requires code changes and re-registration

---

### If Choosing Option B (Recommended):

#### Step 1: Update Android Package ID

**File:** `android/app/build.gradle.kts`
```kotlin
// Current
applicationId = "oooefam.com"

// Change to
applicationId = "com.oooefam.bookstrack"
```

**File:** `android/app/src/main/AndroidManifest.xml`
```xml
<!-- Verify package attribute matches -->
<manifest xmlns:android="http://schemas.android.com/apk/res/android"
    package="com.oooefam.bookstrack">
```

#### Step 2: Update iOS Bundle ID

**Using Xcode:**
1. Open `ios/Runner.xcodeproj` in Xcode
2. Select "Runner" target
3. General tab → Identity
4. Change "Bundle Identifier" to: `com.oooefam.bookstrack`

**Or manually edit:** `ios/Runner.xcodeproj/project.pbxproj`
```
// Find and replace all instances of:
PRODUCT_BUNDLE_IDENTIFIER = com.example.booksTracker;

// With:
PRODUCT_BUNDLE_IDENTIFIER = com.oooefam.bookstrack;
```

#### Step 3: Update macOS Bundle ID (if applicable)

Same process as iOS but in `macos/Runner.xcodeproj/project.pbxproj`:
```
PRODUCT_BUNDLE_IDENTIFIER = com.oooefam.bookstrack;
```

#### Step 4: Delete Existing Firebase Apps

**All platforms** (Android, iOS, macOS, Web):
1. Go to Firebase Console → Settings → General
2. Delete ALL existing apps (they have old IDs)
3. This also rotates the compromised API keys! ✅

#### Step 5: Re-register Apps with New IDs

**Android:**
```bash
# After changing applicationId in build.gradle.kts
firebase apps:create android com.oooefam.bookstrack \
  --project flutter-books-857d3 \
  --display-name "BooksTrack (Android)"
```

**iOS:**
```bash
# After changing bundle ID in Xcode
firebase apps:create ios com.oooefam.bookstrack \
  --project flutter-books-857d3 \
  --display-name "BooksTrack (iOS)"
```

**macOS:**
```bash
firebase apps:create macos com.oooefam.bookstrack \
  --project flutter-books-857d3 \
  --display-name "BooksTrack (macOS)"
```

**Web:**
```bash
firebase apps:create web \
  --project flutter-books-857d3 \
  --display-name "BooksTrack (Web)"
```

#### Step 6: Download New Configuration Files

**Android:**
```bash
firebase apps:sdkconfig ANDROID \
  --project flutter-books-857d3 \
  -o android/app/google-services.json
```

**iOS:**
```bash
firebase apps:sdkconfig IOS \
  --project flutter-books-857d3 \
  -o ios/Runner/GoogleService-Info.plist

# Also copy for macOS
cp ios/Runner/GoogleService-Info.plist macos/Runner/
```

**Or use FlutterFire CLI (easier):**
```bash
flutterfire configure --project=flutter-books-857d3
```

This will:
- Auto-detect your package/bundle IDs
- Register missing apps
- Download all config files
- Generate `lib/firebase_options.dart`

---

### Phase 3: Verify Setup

#### Test Each Platform

**Android:**
```bash
flutter run -d android
# Check Firebase initialization in logs
```

**iOS:**
```bash
flutter run -d ios
# Check Firebase initialization in logs
```

**macOS:**
```bash
flutter run -d macos
# Check Firebase initialization in logs
```

**Web:**
```bash
flutter run -d chrome
# Check Firebase initialization in console
```

#### Verify in Firebase Console

1. **Analytics:** Check events are coming through (24-48 hour delay)
2. **Crashlytics:** Force a test crash to verify reporting
3. **Authentication:** Test sign-in flow
4. **Firestore:** Test read/write operations

---

## Security Benefits of Option B

By **deleting and re-registering all apps**, you automatically:

✅ **Rotate compromised API keys** (new apps = new keys)
✅ **Remove duplicate apps** (clean project)
✅ **Standardize naming** (professional consistency)
✅ **Update package IDs** (follows best practices)

This solves **both** the cleanup and security issues at once!

---

## Quick Decision Matrix

| Aspect | Option A (Keep Current) | Option B (Standardize) |
|--------|-------------------------|------------------------|
| **Time Required** | 15 minutes | 1-2 hours |
| **Code Changes** | None | Android + iOS + macOS |
| **API Key Security** | Still need manual rotation | ✅ Automatic (new apps) |
| **Professional** | ⚠️ Uses "example" and "oooefam.com" | ✅ Uses "com.oooefam.bookstrack" |
| **Best Practice** | ❌ Non-standard | ✅ Standard |
| **Recommendation** | Only if urgent | **RECOMMENDED** |

---

## Recommended Action Plan

**My Recommendation: Option B (Full Standardization)**

This is the best time to do it because:
1. You're already fixing the API key exposure
2. Code changes are minimal (just package/bundle IDs)
3. Project is early-stage (minimal impact)
4. Results in professional, consistent setup

**Estimated Time:**
- Code changes: 30 minutes
- Firebase cleanup: 30 minutes
- Testing: 30 minutes
- **Total: ~1.5 hours**

---

## Next Steps

**Choose your path:**

### Path A (Quick Fix):
1. Delete 2 duplicate Android apps in Firebase Console
2. Manually rotate API key in Google Cloud Console
3. Download new configs with Firebase CLI
4. Done (keeps current non-standard IDs)

### Path B (Recommended):
1. Update package IDs in code (Android + iOS + macOS)
2. Delete ALL apps in Firebase Console
3. Re-register with new IDs using Firebase CLI
4. Download new configs
5. Test all platforms
6. Enjoy clean, professional, secure setup ✅

---

## Support Commands

**Check current package IDs:**
```bash
# Android
grep applicationId android/app/build.gradle.kts

# iOS
grep PRODUCT_BUNDLE_IDENTIFIER ios/Runner.xcodeproj/project.pbxproj | head -1

# macOS
grep PRODUCT_BUNDLE_IDENTIFIER macos/Runner.xcodeproj/project.pbxproj | head -1
```

**Firebase CLI helpful commands:**
```bash
# List all projects
firebase projects:list

# List all apps in project
firebase apps:list --project flutter-books-857d3

# Create new app
firebase apps:create [android|ios|macos|web] <package-id> --project <project-id>

# Download config
firebase apps:sdkconfig [ANDROID|IOS] --project <project-id> -o <output-file>
```

**FlutterFire CLI:**
```bash
# Interactive configuration
flutterfire configure

# Specific project
flutterfire configure --project=flutter-books-857d3

# Force reconfigure
flutterfire configure --force
```

---

**Last Updated:** November 12, 2025
**Status:** Awaiting user decision on Option A vs Option B
