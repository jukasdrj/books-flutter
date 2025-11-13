# API CLIENT AUDIT REPORT - Phase 1 Analysis
**Date:** November 13, 2025
**Scope:** API Client Configuration & v1.0.0 Integration
**Status:** AUDIT COMPLETE - Multiple Issues Requiring Fixes

---

## EXECUTIVE SUMMARY

The API client exists but is **incomplete and not production-ready**. Critical issues found:

1. **CRITICAL:** Base URL is placeholder (`https://api.example.com` with TODO)
2. **CRITICAL:** No API service layer - only generic Dio client exists
3. **HIGH:** No search endpoint implementations
4. **HIGH:** Error handling is generic, not using canonical error codes
5. **HIGH:** Cache configuration missing/incomplete
6. **MEDIUM:** No response envelope parsing

**Current State:** 30% ready for Phase 1 testing
**Effort to Fix:** 2-3 hours of implementation

---

## CURRENT ARCHITECTURE

```
┌─────────────────────────────────────────┐
│  Search Screen (Placeholder)            │
│  - "Coming soon" message                │
│  - No API integration yet                │
└──────────────────────────────────────────┘
                    ↓
                    ✗ (no service layer)

┌─────────────────────────────────────────┐
│  ApiClient (Generic Dio wrapper)        │
│  - Base URL: https://api.example.com    │  ← WRONG!
│  - 3 generic interceptors               │
│  - No cache config                      │
└──────────────────────────────────────────┘
                    ↓
                   Dio
                    ↓
        (No actual endpoints called)
```

---

## DETAILED FINDINGS

### 1. Base URL Configuration

**Current (WRONG):**
```dart
// lib/core/services/api/api_client.dart:9
baseUrl: 'https://api.example.com', // TODO: Replace with actual API URL
```

**Required (from API_README.md):**
```dart
baseUrl: 'https://api.oooefam.net'
```

**Issue:** Production backend is at different URL. Placeholder breaks all API calls.

**Fix Required:** ✅ Simple 1-line change
```dart
baseUrl: 'https://api.oooefam.net',  // Production backend
```

**Impact:** CRITICAL - Without this, app cannot reach backend at all.

---

### 2. API Service Layer Missing

**Current State:**
```
lib/core/services/
├── api/
│   └── api_client.dart          (Generic Dio client only)
├── auth/
│   └── firebase_auth_service.dart
└── sync/
    └── firebase_sync_service.dart

❌ Missing:
  - No SearchService class
  - No BookService class
  - No method to call /v1/search/title
  - No method to call /v1/search/isbn
  - No method to call /v1/search/advanced
```

**What Needs to Be Created:**

**Option A: Single SearchService (Recommended for Phase 1)**
```dart
// lib/core/services/api/search_service.dart

class SearchService {
  final Dio dio;

  SearchService(this.dio);

  /// Search books by title
  Future<ResponseEnvelope<SearchResponseData>> searchByTitle(String query) async {
    final response = await dio.get(
      '/v1/search/title',
      queryParameters: {'q': query},
    );
    return ResponseEnvelope.fromJson(
      response.data as Map<String, dynamic>,
      (json) => SearchResponseData.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Search books by ISBN
  Future<ResponseEnvelope<SearchResponseData>> searchByIsbn(String isbn) async {
    final response = await dio.get(
      '/v1/search/isbn',
      queryParameters: {'isbn': isbn},
    );
    return ResponseEnvelope.fromJson(
      response.data as Map<String, dynamic>,
      (json) => SearchResponseData.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Advanced search
  Future<ResponseEnvelope<SearchResponseData>> searchAdvanced({
    String? title,
    String? author,
  }) async {
    final response = await dio.get(
      '/v1/search/advanced',
      queryParameters: {
        if (title != null) 'title': title,
        if (author != null) 'author': author,
      },
    );
    return ResponseEnvelope.fromJson(
      response.data as Map<String, dynamic>,
      (json) => SearchResponseData.fromJson(json as Map<String, dynamic>),
    );
  }
}
```

**Option B: Full Service with Caching (Recommended for Phase 4)**
- Implement retry logic per canonical spec
- Add cache decorators (6h title, 7d ISBN)
- Handle rate limit responses (429)
- Parse error codes to ApiErrorCode enum

**Recommendation for Phase 1:** Option A (simple, direct endpoint calls)

**Impact:** HIGH - Required to actually call backend

---

### 3. Cache Configuration

**Current State:**
```dart
connectTimeout: const Duration(seconds: 10),
receiveTimeout: const Duration(seconds: 10),
headers: {
  'Content-Type': 'application/json',
  'Accept': 'application/json',
},
```

**Missing (from FRONTEND_HANDOFF.md):**
- Title search cache: **6 hours**
- ISBN search cache: **7 days**
- No cache interceptor implemented

**Canonical Spec (API_README.md):**
```
GET /v1/search/title → Cache 6 hours
GET /v1/search/isbn → Cache 7 days (permanent once fetched)
GET /v1/search/advanced → Cache 6 hours
```

**Current Approach:** No caching at all

**Fix Required:** Add dio_cache_interceptor

```dart
import 'package:dio_cache_interceptor/dio_cache_interceptor.dart';

final cacheOptions = CacheOptions(
  store: MemCacheStore(),
  policy: CachePolicy.request,
  maxStale: const Duration(days: 7),
  priority: CachePriority.high,
);

dio.interceptors.add(
  DioCacheInterceptor(
    options: CacheOptions(
      store: MemCacheStore(),
      policy: CachePolicy.request,
      maxStale: const Duration(days: 7),
    ),
  ),
);
```

**Impact:** MEDIUM - API calls will work without cache, but will be slow on repeat searches and waste bandwidth

---

### 4. Error Handling

**Current State (lib/core/services/api/api_client.dart):**

```dart
class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    switch (err.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        err = DioException(
          requestOptions: err.requestOptions,
          error: 'Connection timeout. Please check your internet connection.',
          type: err.type,
        );
        break;
      case DioExceptionType.badResponse:
        final statusCode = err.response?.statusCode;
        String message;
        switch (statusCode) {
          case 400:
            message = 'Bad request. Please check your input.';
            break;
          case 401:
            message = 'Unauthorized. Please log in again.';
            break;
          case 403:
            message = 'Forbidden. You don\'t have permission.';
            break;
          case 404:
            message = 'Resource not found.';
            break;
          case 500:
            message = 'Server error. Please try again later.';
            break;
          default:
            message = 'An error occurred. Please try again.';
        }
        // ...
    }
  }
}
```

**Issues Found:**

| Issue | Severity | Details |
|-------|----------|---------|
| **No canonical error code parsing** | CRITICAL | Uses generic HTTP status codes, not `INVALID_QUERY`, `INVALID_ISBN`, etc. |
| **Doesn't parse response envelope** | CRITICAL | Doesn't check `ResponseEnvelope.error` for structured error codes |
| **No 429 rate limit handling** | HIGH | Rate limit requires special Retry-After header handling + countdown timer |
| **Catches DioException, not response data** | MEDIUM | Doesn't extract error code from `ResponseEnvelope.error.code` field |
| **No logging for backend team** | MEDIUM | Errors are swallowed without logging context |

**What's Needed:**

Before hitting DioException, must parse ResponseEnvelope and extract error:
```dart
// API Response with error
{
  "success": false,
  "error": {
    "code": "INVALID_QUERY",      // ← Need to extract this
    "message": "Empty search term",
    "details": {...}
  },
  "meta": {...}
}
```

**Fix Required:** Create proper error handling layer (see Issue #2 github task)

**Impact:** CRITICAL - Without this, users see generic error messages instead of canonical friendly messages

---

### 5. Response Envelope Parsing

**Current State:**
```
ApiClient → Dio → Response.data
            (no ResponseEnvelope<T> parsing)
            (caller must handle ResponseEnvelope)
```

**Issue:** Response parsing is caller's responsibility. Each endpoint implementation must:
1. Call dio.get()
2. Get response.data
3. Manually parse ResponseEnvelope<T>
4. Check success flag
5. Extract data or error

**Better Pattern:** Parse at service layer

```dart
// SearchService should handle this:
Future<ResponseEnvelope<SearchResponseData>> searchByTitle(String query) async {
  try {
    final response = await dio.get('/v1/search/title', queryParameters: {'q': query});

    // Parse ResponseEnvelope
    final envelope = ResponseEnvelope.fromJson(
      response.data as Map<String, dynamic>,
      (json) => SearchResponseData.fromJson(json as Map<String, dynamic>),
    );

    if (!envelope.success) {
      // Handle error
      throw ApiException(envelope.error!.code, envelope.error!.message);
    }

    return envelope;
  } on DioException catch (e) {
    // Handle network error
    throw NetworkException(e.message ?? 'Network error');
  }
}
```

**Impact:** MEDIUM - Code will be messy and error-prone without this abstraction

---

### 6. Timeout Configuration

**Current:**
```dart
connectTimeout: const Duration(seconds: 10),
receiveTimeout: const Duration(seconds: 10),
```

**Canonical Spec Requirement:**
- Connect timeout: 10s ✅ Correct
- Receive timeout: 30s ⚠️ Should be longer (AI processing takes 25-40s)

**Issue:** 10s receive timeout is too short for Phase 3 (AI scanning) and Phase 4 (batch enrichment)

**Better Config:**
```dart
connectTimeout: const Duration(seconds: 10),  // 10s for connection
receiveTimeout: const Duration(seconds: 60),  // 60s for response (covers AI processing)
```

**Impact:** LOW for Phase 1 (search is fast), HIGH for Phase 3+ (AI processing)

---

## AUDIT CHECKLIST

### Base URL ✗
- [x] Using placeholder URL
- [x] TODO comment present
- [x] Not using production backend

### Service Layer ✗
- [x] No SearchService implemented
- [x] No endpoint methods
- [x] No ResponseEnvelope parsing
- [x] No search screen integration

### Cache Configuration ✗
- [x] No cache interceptor
- [x] No TTL configuration
- [x] No 6h/7d cache strategy

### Error Handling ✗
- [x] No canonical error code enum
- [x] No error code parsing from response
- [x] No ApiException class
- [x] No 429 rate limit handling
- [x] No user-friendly messages

### Response Parsing ✗
- [x] No ResponseEnvelope parsing
- [x] No success flag checking
- [x] No structured error extraction

### Request Headers ✓
- [x] Content-Type set correctly
- [x] Accept set correctly

### Timeouts ⚠️
- [x] Connect timeout correct (10s)
- [x] Receive timeout too short (10s → should be 30-60s)

### Interceptors ⚠️
- [x] Logging interceptor present (good for debugging)
- [x] Error interceptor present (but incomplete)
- [x] Retry interceptor present (but doesn't handle 429)
- [x] Missing: Cache interceptor
- [x] Missing: Rate limit interceptor

---

## COMPARISON: Current vs Required

| Capability | Current | Required | Status |
|------------|---------|----------|--------|
| Base URL | api.example.com | api.oooefam.net | ❌ Wrong |
| SearchService | None | Implemented | ❌ Missing |
| /v1/search/title | Not callable | Callable | ❌ Missing |
| /v1/search/isbn | Not callable | Callable | ❌ Missing |
| /v1/search/advanced | Not callable | Callable | ❌ Missing |
| ResponseEnvelope parsing | No | Yes | ❌ Missing |
| ApiErrorCode enum | No | Yes | ❌ Missing |
| Error code parsing | No | Yes | ❌ Missing |
| 429 rate limit handling | No | Yes | ❌ Missing |
| Cache (6h title) | No | Yes | ❌ Missing |
| Cache (7d ISBN) | No | Yes | ❌ Missing |
| User-friendly messages | Generic | Canonical | ❌ Missing |
| Logging for debugging | Basic | Comprehensive | ⚠️ Partial |

---

## IMPLEMENTATION ROADMAP

### Phase 1: Critical Fixes (Must Do Before Testing)

**Task 1: Update Base URL (5 minutes)**
```dart
// lib/core/services/api/api_client.dart:9
baseUrl: 'https://api.oooefam.net',  // Production backend
```

**Task 2: Create SearchService (30 minutes)**
```
lib/core/services/api/search_service.dart
  - searchByTitle(String query)
  - searchByIsbn(String isbn)
  - searchAdvanced({String? title, String? author})
  - All return ResponseEnvelope<SearchResponseData>
```

**Task 3: Create ApiException class (10 minutes)**
```
lib/core/models/error/api_exception.dart
  - ApiException(code: String, message: String)
  - Parse from ResponseEnvelope.error
```

**Task 4: Update receive timeout (2 minutes)**
```dart
receiveTimeout: const Duration(seconds: 60),  // For AI processing
```

**Task 5: Create ApiClient provider (10 minutes)**
```
lib/core/providers/api_client_provider.dart
  - Provide Dio instance via Riverpod
  - Provide SearchService instance
```

**Estimated Total:** 1 hour

### Phase 2: Error Handling & UX (This Week - Issue #2)

**Task 1: ApiErrorCode enum**
**Task 2: Error parsing from ResponseEnvelope**
**Task 3: Canonical error messages**
**Task 4: Rate limit handling (429)**
**Task 5: Update Error Interceptor**

**Estimated Total:** 2 hours

### Phase 3: Caching (This Week - Issue #1 mentions but not critical for Phase 1)**

**Task 1: Add dio_cache_interceptor**
**Task 2: Configure TTLs (6h/7d)**
**Task 3: Test cache behavior**

**Estimated Total:** 1 hour

### Phase 4: Rate Limit UI (This Week - Issue #3)

**Task 1: CountdownTimer widget**
**Task 2: Integrate with error handling**
**Task 3: Disable button during countdown**

**Estimated Total:** 1.5 hours

---

## PHASE 1 TESTING BLOCKERS

### Blocker 1: Base URL Mismatch ⚠️ CRITICAL
**Status:** Preventing ALL API calls
**Fix:** 1 line change
**Estimated Fix Time:** 5 minutes

### Blocker 2: No Service Layer ⚠️ CRITICAL
**Status:** Search endpoints not implemented
**Fix:** Create SearchService class
**Estimated Fix Time:** 30 minutes

### Blocker 3: No Error Handling ⚠️ CRITICAL
**Status:** Can't distinguish INVALID_ISBN from PROVIDER_ERROR
**Fix:** Implement ApiErrorCode + error parsing (this is Task #2, not blocking Phase 1 testing)
**Estimated Fix Time:** 2 hours

---

## RECOMMENDATIONS

### PRIORITY 1 (Do Now - Before Testing)
1. ✅ Update base URL to https://api.oooefam.net
2. ✅ Create SearchService with 3 endpoint methods
3. ✅ Create ApiException class
4. ✅ Create ApiClient + SearchService providers

**Time:** 1 hour
**Payoff:** Can now make API calls to production

### PRIORITY 2 (Today - Before User Testing)
1. ✅ Implement ApiErrorCode enum (Issue #2)
2. ✅ Parse error codes from ResponseEnvelope
3. ✅ Add canonical error messages
4. ✅ Handle 429 rate limits
5. ✅ Update error messages in UI

**Time:** 2 hours
**Payoff:** Users see friendly error messages

### PRIORITY 3 (This Week)
1. ✅ Add caching interceptor
2. ✅ Configure TTLs (6h/7d)
3. ✅ Build countdown timer UI (Issue #3)

**Time:** 2.5 hours
**Payoff:** Better performance and UX

---

## TESTING READINESS

**Current Status:**
- ❌ Cannot make API calls (no service layer)
- ❌ Cannot test endpoints (base URL wrong)
- ❌ Cannot test error handling (not implemented)

**After Priority 1 Fixes:**
- ✅ Can make API calls to production
- ✅ Can test /v1/search/title endpoint
- ✅ Can test /v1/search/isbn endpoint
- ✅ Can test /v1/search/advanced endpoint
- ❌ Error messages will be generic (need Priority 2)

**After Priority 2 Fixes:**
- ✅ All Phase 1 testing checklist items ready
- ✅ Canonical error messages
- ✅ Rate limit handling

---

## FILES TO CREATE/MODIFY

### Create (New)
```
lib/core/services/api/search_service.dart
lib/core/models/error/api_exception.dart
lib/core/providers/api_client_provider.dart
lib/core/providers/search_provider.dart (for Phase 1 testing)
```

### Modify
```
lib/core/services/api/api_client.dart (base URL + receive timeout)
lib/core/services/api/api_client.dart (ErrorInterceptor - Phase 2)
```

### Update (Later)
```
lib/features/search/screens/search_screen.dart (integrate SearchService)
```

---

## CONCLUSION

**Audit Status:** ✅ COMPLETE

**Current Readiness:** 30% - API infrastructure exists but incomplete

**Critical Blockers:** 2
1. Base URL placeholder
2. No service layer

**Estimated Fix Time:** 1 hour for Phase 1 testing capability

**Effort Before Full Phase 1 Compliance:** 3-4 hours total

---

## NEXT STEPS

1. **Immediately:** Apply Priority 1 fixes (1 hour)
   - Update base URL
   - Create SearchService
   - Create ApiException + providers

2. **Today:** Apply Priority 2 fixes (2 hours) - This is Task #2
   - Implement ApiErrorCode
   - Error parsing & canonical messages

3. **Later This Week:** Priority 3 (2.5 hours)
   - Add caching
   - Build countdown timer UI

4. **Then:** Phase 1 Testing (This Week - Task #4)
   - Execute full testing checklist

---

**Audit Completed By:** Claude Code
**Confidence Level:** Very High (comprehensive code review)
**Report Generated:** November 13, 2025
