# Flutter Project Organization - Modern Best Practices

## Current State Analysis

Your project already follows many best practices:
- ✅ Feature-first architecture (`lib/features/`)
- ✅ Separate `core/` for shared business logic
- ✅ `shared/` for UI components
- ✅ Clear separation of concerns

## Ideal Modern Flutter Structure (2025)

```
lib/
├── main.dart                    # App entry point
├── app/                         # NEW: App-level configuration
│   ├── app.dart                # MaterialApp wrapper
│   ├── router.dart             # App routing (go_router)
│   └── theme.dart              # App theme configuration
│
├── core/                        # Business logic, data, infrastructure
│   ├── data/                   # NEW: Better organization
│   │   ├── database/           # Drift database
│   │   │   ├── database.dart
│   │   │   ├── tables/         # Table definitions
│   │   │   └── daos/           # Data Access Objects
│   │   ├── repositories/       # Repository pattern (data sources)
│   │   │   ├── work_repository.dart
│   │   │   ├── library_repository.dart
│   │   │   └── sync_repository.dart
│   │   └── models/             # Data models
│   │       ├── work.dart
│   │       ├── edition.dart
│   │       └── dtos/           # Data Transfer Objects
│   │           └── work_dto.dart
│   │
│   ├── domain/                 # NEW: Business logic layer
│   │   ├── entities/           # Business entities (domain models)
│   │   ├── usecases/           # Use cases (business logic)
│   │   │   ├── add_book_usecase.dart
│   │   │   └── sync_library_usecase.dart
│   │   └── failures/           # Error handling
│   │       └── app_failure.dart
│   │
│   ├── services/               # Shared services
│   │   ├── api/
│   │   │   ├── api_client.dart
│   │   │   └── endpoints.dart
│   │   ├── auth/
│   │   │   └── firebase_auth_service.dart
│   │   ├── storage/
│   │   │   └── image_cache_service.dart
│   │   └── sync/
│   │       └── firebase_sync_service.dart
│   │
│   ├── providers/              # Core Riverpod providers
│   │   ├── database_provider.dart
│   │   └── repository_providers.dart
│   │
│   └── utils/                  # Utilities
│       ├── constants.dart
│       ├── extensions/
│       │   ├── string_extensions.dart
│       │   └── datetime_extensions.dart
│       └── helpers/
│           └── isbn_validator.dart
│
├── features/                    # Feature modules (existing)
│   ├── library/
│   │   ├── data/               # Feature-specific data (optional)
│   │   ├── domain/             # Feature-specific business logic
│   │   │   ├── models/         # Feature models
│   │   │   └── providers/      # Feature providers
│   │   ├── presentation/       # UI layer
│   │   │   ├── screens/
│   │   │   │   └── library_screen.dart
│   │   │   ├── widgets/
│   │   │   │   ├── book_card.dart
│   │   │   │   └── book_grid_card.dart
│   │   │   └── controllers/    # Screen-specific state
│   │   │       └── library_controller.dart
│   │   └── library.dart        # Feature barrel export
│   │
│   ├── search/
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   └── providers/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   └── widgets/
│   │   └── search.dart
│   │
│   ├── scanner/
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   └── providers/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   └── widgets/
│   │   └── scanner.dart
│   │
│   ├── bookshelf_scanner/
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   ├── providers/
│   │   │   └── services/       # Feature-specific services
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   └── widgets/
│   │   └── bookshelf_scanner.dart
│   │
│   ├── review_queue/
│   │   ├── domain/
│   │   │   ├── models/
│   │   │   └── providers/
│   │   ├── presentation/
│   │   │   ├── screens/
│   │   │   └── widgets/
│   │   └── review_queue.dart
│   │
│   └── insights/
│       ├── domain/
│       ├── presentation/
│       └── insights.dart
│
└── shared/                      # Shared UI components & design system
    ├── theme/
    │   ├── app_colors.dart
    │   ├── app_text_styles.dart
    │   └── app_theme.dart
    │
    ├── widgets/                # Reusable widgets
    │   ├── buttons/
    │   │   ├── primary_button.dart
    │   │   └── icon_button.dart
    │   ├── cards/
    │   │   └── book_card.dart  # Generic book card
    │   ├── loading/
    │   │   ├── loading_overlay.dart
    │   │   └── shimmer_loading.dart
    │   ├── dialogs/
    │   │   └── confirm_dialog.dart
    │   └── layouts/
    │       └── main_scaffold.dart
    │
    ├── constants/              # UI constants
    │   ├── app_sizes.dart
    │   ├── app_strings.dart
    │   └── app_assets.dart
    │
    └── utils/                  # UI utilities
        ├── responsive.dart
        └── validators.dart
```

## Key Improvements to Make

### 1. Extract App Configuration (Priority: HIGH)

**Current:**
```dart
// lib/main.dart (150+ lines with theme, routing, providers)
```

**Better:**
```dart
// lib/main.dart (20 lines)
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const ProviderScope(child: BooksApp()));
}

// lib/app/app.dart (clean separation)
class BooksApp extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);
    return MaterialApp.router(
      title: 'BooksTrack',
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      routerConfig: router,
    );
  }
}
```

### 2. Repository Pattern (Priority: HIGH)

**Current:**
```dart
// Services mixing data access and business logic
lib/core/services/api_client.dart
lib/core/services/firebase_sync_service.dart
```

**Better:**
```dart
// lib/core/data/repositories/work_repository.dart
abstract class WorkRepository {
  Future<List<Work>> getLibrary({int limit = 20, String? lastId});
  Future<Work> addWork(WorkDTO dto);
  Future<void> syncWithFirebase();
}

class WorkRepositoryImpl implements WorkRepository {
  final Database _db;
  final ApiClient _api;
  final FirebaseSyncService _sync;

  // Implementation
}

// lib/core/providers/repository_providers.dart
@riverpod
WorkRepository workRepository(WorkRepositoryRef ref) {
  return WorkRepositoryImpl(
    ref.watch(databaseProvider),
    ref.watch(apiClientProvider),
    ref.watch(firebaseSyncProvider),
  );
}
```

### 3. Feature Barrel Exports (Priority: MEDIUM)

**Current:**
```dart
// Imports scattered
import '../../features/library/screens/library_screen.dart';
import '../../features/library/widgets/book_card.dart';
```

**Better:**
```dart
// lib/features/library/library.dart
export 'presentation/screens/library_screen.dart';
export 'presentation/widgets/book_card.dart';
export 'domain/providers/library_providers.dart';

// Usage
import 'package:books_flutter/features/library/library.dart';
```

### 4. Separate Database Tables (Priority: MEDIUM)

**Current:**
```dart
// lib/core/database/database.dart (500+ lines with all tables)
```

**Better:**
```dart
// lib/core/data/database/tables/works_table.dart
@DataClassName('Work')
class Works extends Table {
  TextColumn get id => text()();
  TextColumn get title => text()();
  // ...
}

// lib/core/data/database/database.dart (imports tables)
@DriftDatabase(tables: [Works, Editions, Authors])
class AppDatabase extends _$AppDatabase {
  // ...
}
```

### 5. Feature-Specific Models (Priority: LOW)

Move feature-specific models out of `core/`:

```dart
// lib/features/bookshelf_scanner/domain/models/detected_book.dart
@freezed
class DetectedBook with _$DetectedBook {
  const factory DetectedBook({
    required String title,
    required String author,
    required double confidence,
    required Rect boundingBox,
  }) = _DetectedBook;
}
```

## Migration Steps

### Phase 1: Extract App Layer (1 hour)
```bash
mkdir -p lib/app
# Move routing, theme to app/
# Create app.dart
# Update main.dart
```

### Phase 2: Reorganize Core Data (2 hours)
```bash
mkdir -p lib/core/data/{database/{tables,daos},repositories,models/dtos}
mkdir -p lib/core/domain/{entities,usecases,failures}
# Move database tables
# Create repositories
# Refactor services
```

### Phase 3: Refactor Features (3 hours)
```bash
# For each feature:
mkdir -p lib/features/FEATURE/{domain/{models,providers},presentation/{screens,widgets}}
# Move files
# Create barrel exports
# Update imports
```

### Phase 4: Improve Shared (1 hour)
```bash
mkdir -p lib/shared/widgets/{buttons,cards,loading,dialogs,layouts}
mkdir -p lib/shared/constants
# Organize widgets by category
```

## Benefits of This Structure

1. **Scalability**: Easy to add new features without affecting existing code
2. **Testability**: Clear boundaries make unit testing simple
3. **Maintainability**: Developers know exactly where to find things
4. **Team Collaboration**: Multiple devs can work on different features without conflicts
5. **Code Reuse**: Shared components are obvious and accessible
6. **Onboarding**: New developers understand structure immediately

## Tools to Help

### 1. VSCode Snippets
Create `.vscode/flutter-feature.code-snippets`:
```json
{
  "New Feature Module": {
    "prefix": "feature",
    "body": [
      "lib/features/${1:feature_name}/",
      "├── domain/",
      "│   ├── models/",
      "│   └── providers/",
      "├── presentation/",
      "│   ├── screens/",
      "│   └── widgets/",
      "└── ${1:feature_name}.dart"
    ]
  }
}
```

### 2. Import Alias (pubspec.yaml)
```yaml
# Makes imports cleaner
flutter:
  uses-material-design: true

# Then use:
# import 'package:books_flutter/features/library/library.dart';
```

### 3. Melos for Monorepo (Optional)
If you later split into packages:
```yaml
# melos.yaml
packages:
  - lib/features/*/
  - lib/core/
```

## Migration Script

I can create an automated migration script that:
1. Creates new directory structure
2. Moves files to new locations
3. Updates all imports automatically
4. Preserves git history

Would you like me to:
- **A)** Create the full migration script and run it
- **B)** Do it step-by-step (Phase 1 first, then review)
- **C)** Create a detailed manual guide for you to execute

## Verification

After migration, verify with:
```bash
# All imports work
flutter analyze

# Code generates correctly
dart run build_runner build --delete-conflicting-outputs

# Tests still pass
flutter test

# App runs
flutter run
```

---

**Estimated Migration Time:** 4-6 hours for full reorganization
**Risk Level:** Medium (lots of import changes, but automated)
**Recommended Approach:** Phase-by-phase with testing after each phase

What would you like me to do?
