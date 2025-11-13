# Security Incident Report - Firebase API Key Exposure

**Date:** November 12, 2025
**Severity:** CRITICAL
**Status:** REMEDIATION IN PROGRESS

## Incident Summary

Firebase API keys and configuration files were accidentally committed to the public GitHub repository and detected by Google Cloud Platform's automated security scanning.

## Exposed Credentials

### Compromised Files
- `android/app/google-services.json` (Android Firebase config)
- `ios/Runner/GoogleService-Info.plist` (iOS Firebase config)
- `macos/Runner/GoogleService-Info.plist` (macOS Firebase config)
- `firebase.json` (Firebase hosting config)

### Exposed API Key
- **Project:** flutter-books (ID: flutter-books-857d3)
- **API Key:** `AIzaSyAeZ2PzX9lJpl4VMn-Y0KJcFc8IImLl8UM`
- **Exposure URL:** https://github.com/jukasdrj/books-flutter/blob/84bcfd0178315a302762afe2250c11149e66ab1a/android/app/google-services.json

## Immediate Actions Taken

### 1. Updated .gitignore ✅
Added comprehensive Firebase file exclusions:
```gitignore
# Firebase configuration files (contain API keys)
**/android/app/google-services.json
**/ios/Runner/GoogleService-Info.plist
**/macos/Runner/GoogleService-Info.plist
**/ios/firebase_app_id_file.json
**/macos/firebase_app_id_file.json
firebase.json
.firebaserc
```

### 2. Removed Files from Git Index ✅
Executed:
```bash
git rm --cached android/app/google-services.json
git rm --cached ios/Runner/GoogleService-Info.plist
git rm --cached macos/Runner/GoogleService-Info.plist
git rm --cached firebase.json
```

## Required User Actions (URGENT)

### ⚠️ CRITICAL - Must Complete Immediately

1. **Regenerate API Keys in Firebase Console**
   - Go to: https://console.firebase.google.com/project/flutter-books-857d3/settings/general
   - Navigate to: Settings → General → Your apps
   - For each platform (Android/iOS/Web):
     - Delete current app registration
     - Re-register app with same package/bundle ID
     - Download NEW configuration files

2. **Review Billing and Usage**
   - Check: https://console.cloud.google.com/billing
   - Look for unauthorized API usage
   - Review Firebase Analytics, Firestore, Storage usage
   - Set up billing alerts if not already configured

3. **Add API Key Restrictions**
   - Go to: https://console.cloud.google.com/apis/credentials?project=flutter-books-857d3
   - For each API key:
     - Click "Edit"
     - Under "Application restrictions": Select "Android apps" or "iOS apps"
     - Under "API restrictions": Restrict to only required APIs
   - Recommended restrictions:
     - Firebase Authentication API
     - Cloud Firestore API
     - Firebase Storage API
     - Firebase Analytics API

4. **Download New Configuration Files**
   After regenerating:
   - Download `google-services.json` → place in `android/app/`
   - Download `GoogleService-Info.plist` → place in `ios/Runner/` and `macos/Runner/`
   - **DO NOT COMMIT** these files (now in .gitignore)

5. **Clean Git History (Optional but Recommended)**
   To remove exposed keys from git history entirely:
   ```bash
   # WARNING: This rewrites history, coordinate with all team members
   git filter-branch --force --index-filter \
     "git rm --cached --ignore-unmatch android/app/google-services.json ios/Runner/GoogleService-Info.plist macos/Runner/GoogleService-Info.plist firebase.json" \
     --prune-empty --tag-name-filter cat -- --all

   # Force push (DANGEROUS - coordinate with team)
   git push origin --force --all
   ```

## Prevention Measures

### Template Files
Consider creating template files for team members:
- `android/app/google-services.json.template`
- `ios/Runner/GoogleService-Info.plist.template`
- `firebase.json.template`

Replace actual values with placeholders like `YOUR_API_KEY_HERE`.

### Documentation
Add to README.md:
```markdown
## Firebase Setup

1. Download configuration files from Firebase Console
2. Place files in respective directories:
   - Android: `android/app/google-services.json`
   - iOS: `ios/Runner/GoogleService-Info.plist`
   - macOS: `macos/Runner/GoogleService-Info.plist`
3. **NEVER commit these files to git** (protected by .gitignore)
```

### Pre-commit Hook (Optional)
Create `.git/hooks/pre-commit`:
```bash
#!/bin/bash
if git diff --cached --name-only | grep -E "google-services\.json|GoogleService-Info\.plist"; then
    echo "ERROR: Attempting to commit Firebase config files!"
    echo "These files contain API keys and should not be committed."
    exit 1
fi
```

## Timeline

- **2025-11-12 (earlier)**: Firebase configured, files committed to repository
- **2025-11-12 (commit 84bcfd0)**: Exposed files pushed to GitHub
- **2025-11-12 (detected)**: Google Cloud Platform detected exposure
- **2025-11-12 (remediation)**: Updated .gitignore, removed files from index

## Impact Assessment

**Potential Risks:**
- ⚠️ Unauthorized Firebase usage (Firestore, Storage, Auth)
- ⚠️ Potential billing abuse
- ⚠️ Data access if Firestore rules are permissive
- ⚠️ Account takeover if Auth is misconfigured

**Mitigation:**
- API keys should have application restrictions (Android/iOS bundle ID)
- Firebase Security Rules should limit access
- Firestore rules should require authentication
- Monitor billing for unexpected charges

## Lessons Learned

1. **Always review .gitignore** before committing sensitive configuration
2. **Use template files** for configuration with placeholders
3. **Set up pre-commit hooks** to catch sensitive files
4. **Enable Firebase App Check** for additional API protection
5. **Regularly audit** exposed credentials using tools like GitGuardian

## References

- [Google Cloud: Handling Compromised Credentials](https://cloud.google.com/iam/docs/best-practices-for-using-and-managing-service-account-keys)
- [Firebase: Security Best Practices](https://firebase.google.com/docs/rules/basics)
- [GitHub: Removing Sensitive Data](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/removing-sensitive-data-from-a-repository)

---

**Next Review Date:** 2025-11-13 (verify no unauthorized usage)
**Responsible:** Project Owner
**Status:** Awaiting API key regeneration
