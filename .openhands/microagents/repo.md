---
name: Books Flutter Repository Guide
type: knowledge
version: 1.0.0
agent: CodeActAgent
---

# Books Flutter Repository Guide

This microagent provides comprehensive information about the jukasdrj/books-flutter repository structure, purpose, and development setup.

## Repository Purpose

**Books Tracker Flutter** is a cross-platform mobile application for tracking personal book collections with AI-powered features. The app provides:

- **Book Library Management**: Track personal book collections with detailed metadata
- **AI-Powered Bookshelf Scanning**: Use computer vision to scan physical bookshelves and automatically identify books
- **Search & Discovery**: Search for books by title, author, or ISBN with multiple data provider integration
- **Review Queue**: Manage and verify AI-detected books from bookshelf scans
- **Cross-Platform Support**: Native iOS and Android apps built with Flutter
- **Offline-First Architecture**: Local SQLite database with optional cloud sync via Firebase

## General Setup

### Technology Stack
- **Framework**: Flutter 3.24.0+ with Dart 3.2.0+
- **State Management**: Riverpod with code generation
- **Local Database**: Drift (SQLite) with type-safe queries
- **Cloud Services**: Firebase (Auth, Firestore, Storage, Analytics, Crashlytics)
- **API Integration**: RESTful APIs with Dio HTTP client
- **Camera/Scanning**: Mobile Scanner for barcode scanning, Camera plugin for bookshelf photos
- **UI Framework**: Material Design 3 with custom Blue 700 theme

### Key Dependencies
```yaml
# Core Framework
flutter_riverpod: ^2.4.0          # State management
drift: ^2.14.0                     # Local database
firebase_core: ^2.24.2             # Firebase SDK
dio: ^5.4.0                        # HTTP client
go_router: ^12.0.0                 # Navigation

# Camera & Scanning
camera: ^0.11.0                    # Camera access
mobile_scanner: ^4.0.0             # Barcode scanning
image: ^4.1.3                      # Image processing

# Code Generation
build_runner: ^2.4.0               # Build system
riverpod_generator: ^2.3.0         # Riverpod codegen
drift_dev: ^2.14.0                 # Drift codegen
freezed: ^2.4.5                    # Immutable models
```

### Development Setup
1. **Prerequisites**: Flutter 3.24.0+, Firebase CLI, FlutterFire CLI
2. **Installation**: `flutter pub get`
3. **Code Generation**: `dart run build_runner build --delete-conflicting-outputs`
4. **Firebase Setup**: `flutterfire configure` (optional for local development)
5. **Run App**: `flutter run`

## Repository Structure

```
books-flutter/
├── lib/
│   ├── app/                        # App-level configuration
│   │   ├── app.dart               # Main app widget
│   │   ├── router.dart            # Go Router configuration
│   │   └── theme.dart             # Material 3 theme
│   │
│   ├── core/                      # Core business logic
│   │   ├── data/                  # Data layer (repositories, data sources)
│   │   ├── models/                # DTOs and data models
│   │   ├── providers/             # Riverpod providers
│   │   └── services/              # Business services (Firebase, API, etc.)
│   │
│   ├── features/                  # Feature modules
│   │   ├── library/               # Book library management
│   │   ├── search/                # Book search functionality
│   │   ├── scanner/               # Barcode scanning
│   │   ├── bookshelf_scanner/     # AI bookshelf scanning
│   │   ├── review_queue/          # Review AI-detected books
│   │   └── insights/              # Statistics and insights
│   │
│   ├── shared/                    # Shared UI components
│   │   └── widgets/               # Reusable widgets
│   │
│   └── main.dart                  # App entry point
│
├── android/                       # Android-specific configuration
├── ios/                          # iOS-specific configuration
├── web/                          # Web platform support
├── test/                         # Unit and widget tests
│
├── product/                      # Product requirements documents
│   ├── PRD-Template.md
│   ├── Search-PRD-Flutter.md
│   ├── Mobile-Scanner-PRD-Flutter.md
│   ├── Bookshelf-Scanner-PRD-Flutter.md
│   ├── Review-Queue-PRD-Flutter.md
│   └── FLUTTER_CONVERSION_GUIDE.md
│
├── scripts/                      # Build and utility scripts
├── pubspec.yaml                  # Flutter dependencies
├── analysis_options.yaml         # Dart linting rules
└── build.yaml                    # Build configuration
```

### Database Schema (Drift/SQLite)

**Tables:**
- **Works** (15 columns): Primary book entities with metadata, review status, and external IDs
- **Editions** (13 columns): Specific book editions with ISBN, publisher, format details
- **Authors** (6 columns): Author information with demographics and external IDs  
- **WorkAuthors** (3 columns): Many-to-many junction table for work-author relationships

**Enums:**
- `ReviewStatus`: verified, needsReview, userEdited
- `EditionFormat`: hardcover, paperback, ebook, audiobook, unknown
- `AuthorGender`: male, female, nonBinary, unknown
- `CulturalRegion`: northAmerica, latinAmerica, europe, africa, etc.

### Firebase Integration

**Services:**
- **FirebaseAuthService**: Anonymous sign-in, email/password auth, account linking
- **FirebaseSyncService**: Bidirectional sync between local Drift DB and Firestore

**Firestore Structure:**
```
users/{userId}/
  works/{workId}
    - title, author, subjectTags
    - synthetic, primaryProvider, contributors
    - reviewStatus, aiConfidence
    - createdAt, updatedAt
```

**Storage Buckets:**
```
users/{userId}/
  covers/     # Book cover images
  scans/      # Bookshelf scan photos  
  cropped/    # Review queue cropped spines
```

## CI/CD Workflows

The repository includes comprehensive GitHub Actions workflows:

### 1. CI Pipeline (`.github/workflows/ci.yml`)
**Status**: Currently disabled (manual trigger only) due to missing generated code
**Features:**
- **Flutter Analyze**: Code analysis with `flutter analyze`
- **Code Formatting**: Dart format checking with `dart format`
- **Unit & Widget Tests**: Test execution with coverage reporting
- **Multi-Platform Builds**: Android APK, iOS (no codesign), Web builds
- **Security Scanning**: Trivy vulnerability scanner
- **Dependency Review**: Automated dependency security checks
- **Artifacts**: Uploads APK and web builds with 7-day retention

**Build Matrix:**
- Android: Ubuntu + Java 17 + Gradle cache
- iOS: macOS + Flutter 3.24.0
- Web: Ubuntu + CanvasKit renderer

### 2. Copilot Code Review (`.github/workflows/copilot-review.yml`)
**Features:**
- **AI-Powered Review**: GitHub Super Linter validation
- **Auto-Labeling**: File-based PR labeling with `.github/labeler.yml`
- **PR Size Labels**: Effort estimation (XS < 2h, S 2-4h, M 4-8h, L 1-2d, XL 3-5d)
- **Link Checking**: Markdown link validation
- **Copilot Integration**: Automated comments with @jules AI assistant guidance

### 3. Cloudflare Deployment (`.github/workflows/deploy-cloudflare.yml`)
**Status**: Currently disabled (manual trigger only)
**Features:**
- **Flutter Web**: Deploy to Cloudflare Pages with CanvasKit renderer
- **API Workers**: Deploy Cloudflare Workers (expects `cloudflare-workers/` directory)
- **Environment Management**: Production vs preview deployments
- **Health Checks**: Automated deployment verification
- **PR Comments**: Preview URL notifications

### CI Configuration Files
- **Linting**: `analysis_options.yaml` with Flutter lints
- **Link Checking**: `.github/markdown-link-check-config.json`
- **Auto-Labeling**: `.github/labeler.yml` for file-based PR labels
- **Issue Templates**: `.github/ISSUE_TEMPLATE/bug.yml` and `feature.yml`

## Development Status

### Completed Foundation (Week 1-3)
- ✅ Project structure and dependencies
- ✅ Drift database schema with 4 tables and 4 enums
- ✅ API DTOs matching backend contracts
- ✅ Firebase services (Auth, Sync)
- ✅ Riverpod providers and state management
- ✅ Material 3 theme with Blue 700 seed color
- ✅ Library screen with basic UI
- ✅ Comprehensive documentation (9,000+ words)

### Pending Features (Week 4-10)
- 🚧 Search feature implementation
- 🚧 Testing infrastructure setup
- 🚧 Barcode scanner integration
- 🚧 Review queue for AI-detected books
- 🚧 AI bookshelf scanner with computer vision
- 🚧 Settings and statistics screens

## Key Documentation Files

- **README_FLUTTER.md**: Complete setup guide (3,500 words)
- **QUICKSTART.md**: 15-minute setup guide (1,000 words)
- **NEXT_STEPS.md**: Week-by-week implementation roadmap (2,500 words)
- **PROJECT_SUMMARY.md**: Current status and architecture overview
- **CLAUDE.md**: AI development context and patterns (1,800 words)

## Architecture Patterns

- **Clean Architecture**: Separation of data, domain, and presentation layers
- **Feature-Based Structure**: Modular organization by app features
- **Offline-First**: Local database primary, cloud sync secondary
- **Type-Safe**: Compile-time safety with Drift, Freezed, and Riverpod
- **Reactive State**: Stream-based state management with Riverpod
- **Code Generation**: Automated boilerplate with build_runner

This repository represents a production-ready Flutter foundation with modern architecture patterns, comprehensive CI/CD, and detailed documentation for building a sophisticated book tracking application.