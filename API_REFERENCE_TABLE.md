# API Contract Quick Reference - Flutter vs Canonical

## Endpoint Mapping Table

| Feature | Canonical Spec | Flutter PRD | File | Line | Status |
|---------|---|---|---|---|---|
| Title Search | `/v1/search/title?q={query}` | `/v1/search/title?q={query}` | Search-PRD-Flutter.md | 36 | ✅ MATCH |
| ISBN Search | `/v1/search/isbn?isbn={isbn}` | `/v1/search/isbn?isbn={isbn}` | Search-PRD-Flutter.md | 37 | ✅ MATCH |
| Advanced Search | `/v1/search/advanced?title={title}&author={author}` | `/v1/search/advanced?title={title}&author={author}` | Search-PRD-Flutter.md | 38 | ✅ MATCH |
| Barcode Scan | N/A | `/v1/search/isbn?isbn={isbn}` | Mobile-Scanner-PRD-Flutter.md | 222 | ✅ CORRECT |
| AI Scan | N/A | `POST /api/scan-bookshelf` | Bookshelf-Scanner-PRD-Flutter.md | 394 | ✅ NEW |
| Batch Scan | N/A | `POST /api/scan-bookshelf/batch` | Bookshelf-Scanner-PRD-Flutter.md | 395 | ✅ NEW |
| Progress WS | N/A | `WebSocket /ws/progress?jobId={uuid}` | Bookshelf-Scanner-PRD-Flutter.md | 396 | ✅ NEW |

## Response Envelope Field Mapping

| Field | Canonical Type | Flutter Usage | Status |
|---|---|---|---|
| `success` | `boolean` | ✅ Used in all responses | MATCH |
| `data` | Generic `<T>` | ✅ Contains works[], editions[], authors[] | MATCH |
| `data.works` | `WorkDTO[]` | ✅ Array of WorkDTO objects | MATCH |
| `data.editions` | `EditionDTO[]` | ✅ Array of EditionDTO objects | MATCH |
| `data.authors` | `AuthorDTO[]` | ✅ Array of AuthorDTO objects | MATCH |
| `error` | ErrorDetails | ✅ Used when success=false | MATCH |
| `error.code` | ApiErrorCode | ✅ INVALID_QUERY, INVALID_ISBN, PROVIDER_ERROR, INTERNAL_ERROR | MATCH |
| `error.message` | string | ✅ User-friendly error messages | MATCH |
| `meta.timestamp` | ISO8601 string | ✅ Example: "2025-10-31T12:00:00Z" | MATCH |
| `meta.processingTime` | milliseconds | ✅ Example: 450 | MATCH |
| `meta.provider` | string | ✅ Example: "google-books" | MATCH |
| `meta.cached` | boolean | ✅ Cache status indicator | MATCH |

## WorkDTO Field Mapping

| Field | Canonical Spec | Flutter Search | Flutter Bookshelf | Flutter Review | Status |
|---|---|---|---|---|---|
| `title` | Required: string | ✅ | ✅ | ✅ | MATCH |
| `subjectTags` | Required: string[] | ✅ | ✅ | ✅ | MATCH |
| `synthetic` | Optional: boolean | ✅ | ✅ | ✅ | MATCH |
| `primaryProvider` | Optional: string | ✅ | ✅ | ✅ | MATCH |
| `contributors` | Optional: string[] | ✅ | ✅ | (inherited) | MATCH |
| `reviewStatus` | N/A | N/A | ✅ | ✅ | NEW (Flutter) |
| `originalImagePath` | N/A | N/A | ✅ | ✅ | NEW (Flutter) |
| `boundingBox` | N/A | N/A | ✅ | ✅ | NEW (Flutter) |
| `aiConfidence` | N/A | N/A | ✅ | ✅ | NEW (Flutter) |

## EditionDTO Field Mapping

| Field | Canonical Spec | Flutter Usage | Status |
|---|---|---|---|
| `isbn` | Optional: string | ✅ Used in responses | MATCH |
| `isbns` | Required: string[] | ✅ Array of all ISBNs | MATCH |
| `title` | Optional: string | ✅ Used when present | MATCH |
| `publisher` | Optional: string | ✅ Used when present | MATCH |
| `coverImageURL` | Optional: string | ✅ Used for book covers | MATCH |
| `primaryProvider` | Optional: string | ✅ Tracks data origin | MATCH |
| `format` | Required: EditionFormat | ✅ Implied from response | MATCH |

## AuthorDTO Field Mapping

| Field | Canonical Spec | Flutter Usage | Status |
|---|---|---|---|
| `name` | Required: string | ✅ Author name | MATCH |
| `gender` | Required: enum | ✅ male/female/unknown | MATCH |
| `culturalRegion` | Optional: enum | ✅ When available | MATCH |

## Error Code Reference

| Code | Canonical Spec | Flutter Reference | Status |
|---|---|---|---|
| `INVALID_QUERY` | Empty/invalid search parameters | Search-PRD-Flutter.md:203 | ✅ |
| `INVALID_ISBN` | Malformed ISBN format | Search-PRD-Flutter.md:203 | ✅ |
| `PROVIDER_ERROR` | Upstream API failure | Search-PRD-Flutter.md:203 | ✅ |
| `INTERNAL_ERROR` | Unexpected server error | Canonical spec only | N/A |

## HTTP Method Summary

| Method | Count | Usage |
|--------|-------|-------|
| GET | 3 | /v1/search/* endpoints (title, isbn, advanced) |
| POST | 2 | /api/scan-bookshelf, /api/scan-bookshelf/batch |
| WebSocket | 1 | /ws/progress (real-time updates) |

## Query Parameter Validation

| Endpoint | Parameter | Type | Example | Validation |
|---|---|---|---|---|
| `/v1/search/title` | `q` | string | "Harry Potter" | Non-empty, max 256 chars |
| `/v1/search/isbn` | `isbn` | string | "978-0-12345-678-9" | ISBN-10 or ISBN-13 |
| `/v1/search/advanced` | `title` | string | "1984" | Optional if author present |
| `/v1/search/advanced` | `author` | string | "George Orwell" | Optional if title present |
| `/ws/progress` | `jobId` | UUID | "550e8400-e29b-..." | Required, valid UUID format |
| `/api/scan-bookshelf` | `jobId` | UUID | "550e8400-e29b-..." | Required, valid UUID format |

## Drift Database Schema (Flutter-Specific)

### Works Table
```sql
CREATE TABLE works (
  id TEXT PRIMARY KEY,
  title TEXT NOT NULL,
  author TEXT,
  
  -- From Canonical API
  subjectTags TEXT,              -- JSON array
  synthetic BOOLEAN,
  primaryProvider TEXT,
  
  -- Flutter Review Queue Extensions
  reviewStatus INTEGER,           -- enum: 0=verified, 1=needsReview, 2=userEdited
  originalImagePath TEXT,         -- temp file path for cropped image
  boundingBox TEXT,              -- JSON: {x, y, width, height}
  aiConfidence REAL              -- 0.0-1.0 confidence score
);
```

## Cache Strategy

| Endpoint | Cache TTL | Canonical | Flutter | Status |
|---|---|---|---|---|
| `/v1/search/title` | 6 hours | ✅ Specified | ✅ Implemented | MATCH |
| `/v1/search/isbn` | 7 days | ✅ Specified | ✅ Implemented | MATCH |
| `/v1/search/advanced` | 6 hours | ✅ Specified | ✅ Implemented | MATCH |
| `/api/scan-bookshelf` | None | N/A | ✅ No caching (POST) | CORRECT |
| `/ws/progress` | N/A | N/A | ✅ Real-time | CORRECT |

## Feature Completeness

| Feature | Canonical | Search-Flutter | Mobile-Scanner | Bookshelf-Scanner | Review-Queue | Overall |
|---|---|---|---|---|---|---|
| /v1/search/title | ✅ | ✅ | - | - | ✅ (inherited) | COMPLETE |
| /v1/search/isbn | ✅ | ✅ | ✅ | ✅ | ✅ (inherited) | COMPLETE |
| /v1/search/advanced | ✅ | ✅ | - | - | ✅ (inherited) | COMPLETE |
| ResponseEnvelope | ✅ | ✅ | ✅ | ✅ | ✅ | COMPLETE |
| WorkDTO | ✅ | ✅ | ✅ | ✅ | ✅+ | COMPLETE |
| EditionDTO | ✅ | ✅ | ✅ | ✅ | ✅ | COMPLETE |
| AuthorDTO | ✅ | ✅ | ✅ | ✅ | ✅ | COMPLETE |
| Error Codes | ✅ | ✅ | ✅ | ✅ | ✅ | COMPLETE |

(✅+ = includes new Review Queue fields)

## Implementation Checklist

### Search-PRD-Flutter
- [x] GET /v1/search/title implemented correctly
- [x] GET /v1/search/isbn implemented correctly  
- [x] GET /v1/search/advanced implemented correctly
- [x] ResponseEnvelope used for all responses
- [x] Error codes (INVALID_QUERY, INVALID_ISBN) handled
- [x] Caching strategy (6hr/7day) specified
- [x] DTOMapper consumes WorkDTO/EditionDTO/AuthorDTO

### Mobile-Scanner-PRD-Flutter
- [x] Uses /v1/search/isbn endpoint
- [x] ISBN validation before API call
- [x] Error handling for invalid ISBNs
- [x] Haptic feedback on successful scan
- [x] Permission handling documented

### Bookshelf-Scanner-PRD-Flutter
- [x] POST /api/scan-bookshelf endpoint defined
- [x] WebSocket /ws/progress implemented
- [x] DetectedBook response model defined
- [x] ProgressData message format specified
- [x] Review Queue integration specified
- [x] Image cleanup strategy documented

### Review-Queue-PRD-Flutter
- [x] reviewStatus enum defined (verified|needsReview|userEdited)
- [x] boundingBox field for cropping images
- [x] aiConfidence field for confidence display
- [x] Drift schema updates documented
- [x] Image cleanup on app startup specified

---

**Last Updated:** November 12, 2025
**Status:** All API contracts verified and consistent
**Next Review:** When adding new providers (OpenLibrary, ISBNDB)
