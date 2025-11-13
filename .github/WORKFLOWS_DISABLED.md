# GitHub Actions Workflows - Temporarily Disabled

The CI/CD and Cloudflare deployment workflows have been temporarily disabled because they're running against code with pre-existing compilation issues.

## Issues to Fix Before Enabling

### 1. Missing Firebase Configuration
**Error:** `Error when reading 'lib/firebase_options.dart': No such file or directory`

**Fix:**
```bash
# Generate Firebase configuration
flutterfire configure
```

This will create `lib/firebase_options.dart` with your Firebase project settings.

**Important:** After generating, add to `.gitignore`:
```
# Firebase configuration (contains API keys)
lib/firebase_options.dart
**/GoogleService-Info.plist
**/google-services.json
```

### 2. Database Compilation Errors
**Error:** Multiple Drift generated code errors in `lib/core/database/database.drift.dart`

**Issues:**
- `Index()` constructor syntax has changed in newer Drift versions
- Type mismatches in generated code

**Fix:**
```bash
# Clean and regenerate Drift code
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs
```

**If errors persist:**
- Check `lib/core/database/database.dart` for proper Drift syntax
- Verify `@override` on `customConstraints` getter
- Ensure Index definitions use correct syntax

### 3. Missing Cloudflare Workers Directory
**Error:** Cache path not found for `cloudflare-workers/package-lock.json`

**Fix (Option 1):** Remove Cloudflare deployment if not needed
```bash
rm .github/workflows/deploy-cloudflare.yml
```

**Fix (Option 2):** Add Cloudflare Workers backend
```bash
# Create workers directory
mkdir -p cloudflare-workers
cd cloudflare-workers
npm init -y
npm install wrangler --save-dev
```

## Enabling Workflows

Once all issues are fixed:

### 1. Edit `.github/workflows/ci.yml`
Uncomment the `on:` triggers:
```yaml
on:
  workflow_dispatch:
  push:
    branches: [main, develop]
  pull_request:
    branches: [main, develop]
```

Remove the comment block at the top.

### 2. Edit `.github/workflows/deploy-cloudflare.yml`
Same process - uncomment triggers.

### 3. Test Locally First
```bash
# Verify code compiles
flutter analyze
flutter test
flutter build apk --debug
flutter build web --release

# Verify Drift generation works
dart run build_runner build --delete-conflicting-outputs
```

## Current Workflow Status

| Workflow | Status | Reason |
|----------|--------|--------|
| **ci.yml** | ⏸️ Disabled | Firebase + Database errors |
| **deploy-cloudflare.yml** | ⏸️ Disabled | Missing workers directory + compilation errors |
| **copilot-review.yml** | ✅ Active | Runs on PRs, doesn't compile code |

## Quick Fix Commands

```bash
# 1. Generate Firebase config
flutterfire configure

# 2. Regenerate Drift code
flutter pub get
dart run build_runner clean
dart run build_runner build --delete-conflicting-outputs

# 3. Test compilation
flutter analyze

# 4. If all passes, re-enable workflows
# Edit .github/workflows/ci.yml and deploy-cloudflare.yml
# Uncomment the `on:` triggers

# 5. Test workflows locally (optional)
# Install act: brew install act
act push -W .github/workflows/ci.yml
```

## Need Help?

- **Firebase setup:** See `.github/FIREBASE_PRICING.md`
- **Drift issues:** Run `/code-review files=lib/core/database/ review_type=full` with Zen MCP
- **Cloudflare:** See `.github/CLOUDFLARE_SETUP.md`

---

**Last Updated:** November 13, 2025
**Reason for Disable:** Pre-existing code compilation errors
**ETA to Fix:** ~30 minutes with above steps
