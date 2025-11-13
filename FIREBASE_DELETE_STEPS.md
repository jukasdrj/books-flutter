# Firebase App Deletion Steps

**IMPORTANT:** Deleting the old apps will automatically rotate the compromised API keys! ✅

## Step-by-Step Instructions

### 1. Open Firebase Console
**URL:** https://console.firebase.google.com/project/flutter-books-857d3/settings/general

### 2. Scroll to "Your apps" Section

You should see 5 apps:
- 3x Android apps (duplicates)
- 1x iOS app
- 1x Web app

### 3. Delete Each App (One by One)

For **EACH** of the 5 apps:

1. Find the app card
2. Click the **settings icon** (⚙️) in the top-right corner of the app card
3. Select **"Delete app"** from the dropdown menu
4. **Confirm deletion** in the dialog

**Delete in this order:**
1. ✅ books_tracker (android) - App ID: `1:989217966501:android:174a9bb2ecfa163315c04c`
2. ✅ books_tracker (android) - App ID: `1:989217966501:android:6becaa7e51835fcb15c04c`
3. ✅ books_tracker (android) - App ID: `1:989217966501:android:a668e9e2b6213cdc15c04c`
4. ✅ books_tracker (ios) - App ID: `1:989217966501:ios:c4551f428c121e3015c04c`
5. ✅ books_tracker (web) - App ID: `1:989217966501:web:437fbc21f8f3877415c04c`

### 4. Verify All Apps Are Deleted

After deletion, the "Your apps" section should be **empty**.

### 5. Return to Terminal

Once all apps are deleted, return to the terminal and let Claude know:
```
"All Firebase apps deleted"
```

Then I'll use FlutterFire CLI to automatically re-register with the new package IDs!

---

**Why This Works:**
- Deleting old apps removes the compromised API keys
- New apps will get fresh, secure API keys
- FlutterFire CLI will auto-detect the new package IDs
- Everything gets re-registered cleanly

**Security Note:**
This is the **recommended approach** from Google for rotating exposed API keys when using Firebase.
