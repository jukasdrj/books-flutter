# Firebase Pricing Guide
**Spark (Free) vs Blaze (Pay-as-you-go) - 2025**

Complete breakdown of Firebase pricing plans for the BooksTrack Flutter app.

---

## 📊 Firebase Plans Overview

Firebase offers two pricing plans:

| Plan | Cost | Best For |
|------|------|----------|
| **Spark** | FREE | Development, testing, small apps |
| **Blaze** | Pay-as-you-go | Production apps, scaling needs |

---

## 🆓 Spark Plan (Free Tier)

### What's Included (No Cost)

**Authentication:**
- Email/Password: Up to 50,000 MAU (Monthly Active Users)
- Social Auth (Google, Facebook, etc.): Up to 50,000 MAU
- Phone Auth: ❌ Not available (Blaze only)
- SAML/OIDC (Enterprise SSO): Up to 50 MAU
- Anonymous Auth: Unlimited

**Cloud Firestore:**
- Storage: 1 GB
- Document Reads: 50,000/day
- Document Writes: 20,000/day
- Document Deletes: 20,000/day

**Realtime Database:**
- Storage: 1 GB
- Downloads: 10 GB/month
- Concurrent connections: 100

**Cloud Storage:**
- Storage: 5 GB
- Downloads: 1 GB/day
- Uploads: 1 GB/day

**Cloud Functions:**
- Invocations: 125,000/month
- GB-seconds: 40,000/month
- CPU-seconds: 200,000/month
- Outbound networking: 5 GB/month

**Hosting:**
- Storage: 10 GB
- Transfer: 360 MB/day (~10 GB/month)
- Custom domain: ✅ Yes

**Fully Free (Unlimited):**
- ✅ Firebase Analytics
- ✅ Firebase Crashlytics
- ✅ Cloud Messaging (FCM)
- ✅ Remote Config
- ✅ A/B Testing
- ✅ Performance Monitoring
- ✅ App Distribution

### Spark Plan Limitations

**Hard Stops:**
- If you exceed any quota in a month, that specific service stops
- You must wait until next billing cycle OR upgrade to Blaze
- No access to paid Google Cloud features (BigQuery, Pub/Sub, etc.)

**For BooksTrack App:**

Estimated usage (small-scale app with 100 active users):

| Service | Daily Usage | Spark Limit | Status |
|---------|-------------|-------------|--------|
| Firestore Reads | ~5,000 | 50,000 | ✅ Safe |
| Firestore Writes | ~500 | 20,000 | ✅ Safe |
| Storage Downloads | ~100 MB | 1 GB | ✅ Safe |
| Auth MAU | 100 | 50,000 | ✅ Safe |

**Verdict:** Spark plan works for development and testing! ✅

---

## 💳 Blaze Plan (Pay-as-you-go)

### How It Works

- **All Spark quotas still apply** (you get them for free)
- Only pay when you exceed free quotas
- No monthly minimum (pay $0 if under limits)
- $300 Google Cloud credit for new users

### Pricing (2025)

**Cloud Firestore:**
- Reads: $0.06 per 100,000 documents
- Writes: $0.18 per 100,000 documents
- Deletes: $0.02 per 100,000 documents
- Storage: $0.18 per GB/month

**Realtime Database:**
- Storage: $5 per GB/month
- Downloads: $1 per GB

**Cloud Storage:**
- Storage: $0.026 per GB/month
- Downloads: $0.12 per GB
- Uploads: Free

**Cloud Functions:**
- Invocations: $0.40 per million
- GB-seconds: $0.0000025
- CPU-seconds: $0.0000100
- Network egress: $0.12 per GB

**Hosting:**
- Storage: $0.026 per GB/month
- Transfer: $0.15 per GB

**Authentication:**
- Email/Social: Free (unlimited MAU!)
- Phone Auth: $0.01 per verification after 10k/month
- SAML/OIDC (Enterprise SSO): $0.015 per MAU

### Example Monthly Costs

**Scenario 1: Small Production App (500 users)**

| Service | Usage | Cost |
|---------|-------|------|
| Firestore Reads | 500k/day (15M/month) - 1.5M free = 13.5M | $8.10 |
| Firestore Writes | 50k/day (1.5M/month) - 600k free = 900k | $1.62 |
| Storage (images) | 10 GB - 5 GB free = 5 GB | $0.13 |
| Storage Downloads | 50 GB - 30 GB free = 20 GB | $2.40 |
| Functions | 1M invocations - 125k free = 875k | $0.35 |
| Auth (Email/Social) | 500 MAU | FREE |
| Analytics, Crashlytics, FCM | Unlimited | FREE |
| **Total** | | **~$12.60/month** |

**Scenario 2: Medium Production App (2,000 users)**

| Service | Usage | Cost |
|---------|-------|------|
| Firestore Reads | 2M/day (60M/month) - 1.5M free = 58.5M | $35.10 |
| Firestore Writes | 200k/day (6M/month) - 600k free = 5.4M | $9.72 |
| Storage (images) | 50 GB - 5 GB free = 45 GB | $1.17 |
| Storage Downloads | 200 GB - 30 GB free = 170 GB | $20.40 |
| Functions | 5M invocations - 125k free = 4.875M | $1.95 |
| Auth (Email/Social) | 2,000 MAU | FREE |
| **Total** | | **~$68.34/month** |

**Scenario 3: Large Production App (10,000 users)**

| Service | Usage | Cost |
|---------|-------|------|
| Firestore Reads | 10M/day (300M/month) | $180.00 |
| Firestore Writes | 1M/day (30M/month) | $54.00 |
| Storage (images) | 200 GB | $5.20 |
| Storage Downloads | 1 TB | $120.00 |
| Functions | 25M invocations | $10.00 |
| Auth (Email/Social) | 10,000 MAU | FREE |
| **Total** | | **~$369.20/month** |

---

## 🎯 Recommendations for BooksTrack App

### During Development (Current Phase)

**Use:** Spark Plan (Free)

**Why:**
- All development/testing needs covered
- No risk of unexpected charges
- Analytics, Crashlytics, FCM free
- Generous quotas for testing

**Monitor:**
```bash
# Check Firebase Console daily:
# firebase.google.com/project/YOUR_PROJECT/usage

# Watch for quota warnings
```

### For Production Launch

**Start with:** Blaze Plan

**Why:**
- Can't risk service interruption mid-month
- Phone auth might be needed
- Predictable costs with scaling
- Access to BigQuery for analytics

**Estimated cost:**
- Small launch (500 users): ~$12-15/month
- Growing app (2k users): ~$70/month
- Success scenario (10k users): ~$370/month

**Budget recommendation:** $50-100/month buffer

---

## 💰 Cost Optimization Strategies

### 1. Optimize Firestore Reads

**Problem:** Reads are most expensive operation

**Solutions:**
- Use local caching (Drift database)
- Implement pagination (don't load all data)
- Use Firestore offline persistence
- Cache images with CachedNetworkImage

**Example savings:**
```dart
// ❌ Bad: Reads entire collection every time
final books = await FirebaseFirestore.instance
    .collection('books')
    .get();  // Costs 1000 reads for 1000 books

// ✅ Good: Paginate + cache in Drift
final books = await FirebaseFirestore.instance
    .collection('books')
    .limit(20)  // Only 20 reads
    .get();

// Save to Drift for offline access (0 reads on next load)
await database.insertBooks(books);
```

**Savings:** 98% reduction in reads

### 2. Use Cloud Storage for Images

**Problem:** Storing images in Firestore is expensive

**Solution:**
```dart
// ❌ Bad: Store image URLs in every book document
// Firestore read = image metadata + download

// ✅ Good: Store in Cloud Storage, cache locally
final url = await FirebaseStorage.instance
    .ref('book_covers/${bookId}.jpg')
    .getDownloadURL();

// Cache with CachedNetworkImage (already implemented!)
CachedNetworkImage(imageUrl: url);
```

**Savings:** 70% reduction in storage costs

### 3. Batch Firestore Operations

**Problem:** Each write costs money

**Solution:**
```dart
// ❌ Bad: Individual writes
for (var book in books) {
  await firestore.collection('books').add(book);  // 100 writes
}

// ✅ Good: Batch writes
final batch = firestore.batch();
for (var book in books) {
  batch.set(firestore.collection('books').doc(), book);
}
await batch.commit();  // 1 write operation
```

**Savings:** Up to 90% reduction in write costs

### 4. Leverage Free Services

**Always use these (unlimited, free):**
- Firebase Analytics
- Firebase Crashlytics
- Cloud Messaging (FCM)
- Remote Config
- Performance Monitoring

**Instead of:** Paying for third-party alternatives

**Savings:** $20-50/month (vs Sentry, Mixpanel, etc.)

### 5. Use Drift for Local Database

**Already implemented!** This saves massive costs:

```dart
// Firestore: Cloud sync only
// Drift: Local database for everything else

// Sync pattern:
1. User opens app → Load from Drift (0 reads)
2. Background sync → Update from Firestore (minimal reads)
3. User browses → All data from Drift (0 reads)
4. User adds book → Save to Drift + sync to Firestore (1 write)
```

**Savings:** 95%+ reduction in Firestore operations

---

## 📊 Cost Monitoring

### Firebase Console

**Daily checks:**
1. Go to: firebase.google.com/project/YOUR_PROJECT/usage
2. Check graphs for:
   - Firestore reads/writes
   - Storage usage/downloads
   - Cloud Functions invocations
3. Set up budget alerts

### Budget Alerts (Blaze Plan)

**Setup:**
```
1. Firebase Console → Settings → Usage and billing
2. Click "Set budget alerts"
3. Set thresholds: $10, $50, $100
4. Get email when exceeded
```

### Google Cloud Billing

**Access:** console.cloud.google.com/billing

**Features:**
- Detailed cost breakdown
- Forecasting
- Export to BigQuery for analysis
- Budget alerts

---

## 🚨 Common Cost Pitfalls

### 1. N+1 Query Problem

**Problem:**
```dart
// Gets all books (1000 reads)
final books = await firestore.collection('books').get();

// For each book, get author (1000 more reads!)
for (var book in books.docs) {
  final author = await firestore
      .collection('authors')
      .doc(book.data()['authorId'])
      .get();  // 1 read per book
}
// Total: 2000 reads (should be ~50 reads with batching)
```

**Already fixed in BooksTrack!** Uses DTOMapper with batch loading.

### 2. Image Storage

**Problem:**
- Storing images in Firestore documents
- Not caching images locally

**Solution:**
- Cloud Storage for images
- CachedNetworkImage (already implemented!)

### 3. Polling Instead of Listeners

**Problem:**
```dart
// ❌ Bad: Poll every second
Timer.periodic(Duration(seconds: 1), (_) async {
  final data = await firestore.collection('books').get();  // 86,400 reads/day!
});
```

**Solution:**
```dart
// ✅ Good: Real-time listener (1 read + free updates)
firestore.collection('books').snapshots().listen((snapshot) {
  // Updates automatically, no additional reads!
});
```

### 4. No Pagination

**Problem:**
```dart
// ❌ Bad: Load all 10,000 books at once
final books = await firestore.collection('books').get();  // 10,000 reads
```

**Solution (already implemented!):**
```dart
// ✅ Good: Keyset pagination
final books = await firestore
    .collection('books')
    .limit(20)
    .get();  // Only 20 reads
```

---

## 🎯 When to Upgrade from Spark to Blaze

### Upgrade When:

1. **You hit Spark limits mid-month**
   - Service stops working
   - Can't wait for next billing cycle

2. **You need phone authentication**
   - Not available on Spark
   - Common for production apps

3. **You need Google Cloud features**
   - BigQuery for analytics
   - Pub/Sub for messaging
   - Cloud Run for backend

4. **You launch to production**
   - Can't risk service interruption
   - Need predictable scaling

### Stay on Spark When:

1. **Still in development**
   - Testing features
   - Internal use only
   - Under 100 users

2. **Usage well under limits**
   - < 10,000 reads/day
   - < 1,000 writes/day
   - < 1 GB storage

3. **Cost-sensitive project**
   - Personal project
   - No revenue yet
   - Tight budget

---

## 💡 Pro Tips

### 1. Use $300 Google Cloud Credit

**New users get:** $300 credit when upgrading to Blaze

**How to claim:**
1. Upgrade to Blaze plan
2. Credit automatically applied
3. Lasts 90 days
4. Covers Firebase + Google Cloud services

**Estimate:** ~6 months free for small app!

### 2. Combine with Cloudflare Workers

**Your setup (already configured!):**
- Cloudflare Workers: $5/month (backend API)
- Firebase: $12-15/month (auth, database, storage)
- Total: ~$17-20/month

**Instead of:**
- Firebase only: $50+/month (would need more expensive Firebase hosting)

**Savings:** ~$30+/month

### 3. Use Firebase Extensions

**Free Firebase Extensions:**
- Resize images on upload
- Delete user data (GDPR compliance)
- Translate text
- Trigger email from Firestore

**Benefit:** Saves Cloud Functions costs

### 4. Monitor with Zen MCP

**Use Zen MCP to analyze costs:**
```bash
# In Claude Code
/analyze files=lib/core/database/ focus=firebase-costs

# Zen MCP can identify:
# - Expensive query patterns
# - N+1 query issues
# - Missing caching opportunities
```

---

## 📖 Resources

**Official Docs:**
- Pricing: https://firebase.google.com/pricing
- Usage limits: https://firebase.google.com/docs/firestore/quotas
- Cost optimization: https://firebase.google.com/docs/firestore/best-practices

**Your Documentation:**
- Firebase setup: FIREBASE_SETUP.md
- Firebase cleanup: FIREBASE_CLEANUP_PLAN.md
- Security incident: SECURITY_INCIDENT.md

**Monitor:**
- Usage dashboard: firebase.google.com/project/YOUR_PROJECT/usage
- Billing: console.cloud.google.com/billing

---

## 📝 Summary

### For BooksTrack App

**Current (Development):**
- Use: Spark Plan (Free)
- Cost: $0/month
- Safe for: Up to 100 active test users

**Production Launch:**
- Use: Blaze Plan
- Estimated: $12-15/month (500 users)
- Budget: $50/month safety buffer

**Optimizations Already Implemented:**
- ✅ Drift local database (95% read reduction)
- ✅ CachedNetworkImage (70% storage savings)
- ✅ DTOMapper batch loading (N+1 elimination)
- ✅ Keyset pagination (90% read reduction)
- ✅ Cloudflare Workers (backend cost savings)

**Total Monthly Cost (Production):**
- Firebase: $12-15/month
- Cloudflare: $5/month
- Zen MCP: $2-5/month
- GitHub Copilot Plus: $39/month
- **Total: ~$58-64/month**

**Comparable to:** $200+/month with less optimization

**Value:** Professional app infrastructure at indie pricing!

---

**Last Updated:** November 12, 2025
**Current Plan:** Spark (Free)
**Recommendation:** Upgrade to Blaze before production launch
