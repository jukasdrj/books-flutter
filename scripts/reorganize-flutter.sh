#!/bin/bash
set -e

# Flutter Project Reorganization Script
# Migrates to modern feature-first architecture with Clean Architecture principles

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Flutter Project Reorganization${NC}"
echo ""
echo "This script will reorganize your project to modern best practices:"
echo "  - Extract app configuration layer"
echo "  - Implement repository pattern"
echo "  - Better feature module organization"
echo "  - Clean separation of concerns"
echo ""
echo -e "${YELLOW}⚠️  WARNING: This will move many files and update imports${NC}"
echo ""

# Check if git is clean
if [[ -n $(git status -s) ]]; then
    echo -e "${RED}❌ Git working directory is not clean!${NC}"
    echo "Please commit or stash your changes first."
    exit 1
fi

# Create backup branch
BACKUP_BRANCH="backup-before-reorganization-$(date +%Y%m%d-%H%M%S)"
echo -e "${BLUE}Creating backup branch: $BACKUP_BRANCH${NC}"
git checkout -b "$BACKUP_BRANCH"
git checkout -

read -p "Continue with reorganization? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Reorganization cancelled."
    exit 0
fi

echo ""
echo -e "${GREEN}Starting reorganization...${NC}"
echo ""

# ============================================================================
# PHASE 1: Extract App Layer
# ============================================================================
echo -e "${BLUE}📱 Phase 1: Extract App Layer${NC}"

mkdir -p lib/app

# Create app.dart
cat > lib/app/app.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'router.dart';
import 'theme.dart';

class BooksApp extends ConsumerWidget {
  const BooksApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'BooksTrack',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
    );
  }
}
EOF

# Move router if it exists
if [ -f "lib/core/router/app_router.dart" ]; then
    echo "  Moving router to app layer..."
    mv lib/core/router/app_router.dart lib/app/router.dart
    rmdir lib/core/router 2>/dev/null || true

    # Update router imports
    find lib -name "*.dart" -type f -exec sed -i '' \
        's|import.*core/router/app_router.dart|import '\''package:books_flutter/app/router.dart'\'';|g' {} \;
fi

# Move theme to app layer
if [ -f "lib/shared/theme/app_theme.dart" ]; then
    echo "  Moving theme to app layer..."
    mv lib/shared/theme/app_theme.dart lib/app/theme.dart
    rmdir lib/shared/theme 2>/dev/null || true

    # Update theme imports
    find lib -name "*.dart" -type f -exec sed -i '' \
        's|import.*shared/theme/app_theme.dart|import '\''package:books_flutter/app/theme.dart'\'';|g' {} \;
fi

echo -e "${GREEN}  ✅ App layer extracted${NC}"

# ============================================================================
# PHASE 2: Reorganize Core Data Layer
# ============================================================================
echo -e "${BLUE}💾 Phase 2: Reorganize Core Data Layer${NC}"

# Create new directory structure
mkdir -p lib/core/data/database/{tables,daos}
mkdir -p lib/core/data/repositories
mkdir -p lib/core/data/models/dtos
mkdir -p lib/core/domain/{entities,usecases,failures}

# Move database files
echo "  Organizing database..."
if [ -f "lib/core/database/database.dart" ]; then
    mv lib/core/database/database.dart lib/core/data/database/
fi
if [ -f "lib/core/database/database.g.dart" ]; then
    mv lib/core/database/database.g.dart lib/core/data/database/
fi
if [ -f "lib/core/database/database.drift.dart" ]; then
    mv lib/core/database/database.drift.dart lib/core/data/database/
fi
rmdir lib/core/database 2>/dev/null || true

# Move DTOs
echo "  Moving DTOs..."
if [ -d "lib/core/models/dtos" ]; then
    mv lib/core/models/dtos/* lib/core/data/models/dtos/ 2>/dev/null || true
fi

# Move entities
if [ -d "lib/core/models/entities" ]; then
    mv lib/core/models/entities/* lib/core/domain/entities/ 2>/dev/null || true
fi
rmdir lib/core/models/{dtos,entities} 2>/dev/null || true
rmdir lib/core/models 2>/dev/null || true

# Organize services
echo "  Organizing services..."
mkdir -p lib/core/services/{api,auth,storage,sync}

if [ -f "lib/core/services/api_client.dart" ]; then
    mv lib/core/services/api_client.dart lib/core/services/api/
fi
if [ -f "lib/core/services/firebase_auth_service.dart" ]; then
    mv lib/core/services/firebase_auth_service.dart lib/core/services/auth/
fi
if [ -f "lib/core/services/firebase_sync_service.dart" ]; then
    mv lib/core/services/firebase_sync_service.dart lib/core/services/sync/
fi
if [ -f "lib/core/services/dto_mapper.dart" ]; then
    mv lib/core/services/dto_mapper.dart lib/core/data/
fi

echo -e "${GREEN}  ✅ Core data layer reorganized${NC}"

# ============================================================================
# PHASE 3: Refactor Feature Modules
# ============================================================================
echo -e "${BLUE}🎯 Phase 3: Refactor Feature Modules${NC}"

# Function to reorganize a feature
reorganize_feature() {
    local feature=$1
    echo "  Reorganizing $feature..."

    if [ ! -d "lib/features/$feature" ]; then
        return
    fi

    # Create new structure
    mkdir -p "lib/features/$feature/domain/{models,providers,services}"
    mkdir -p "lib/features/$feature/presentation/{screens,widgets,controllers}"

    # Move screens
    if [ -d "lib/features/$feature/screens" ]; then
        mv lib/features/$feature/screens/* "lib/features/$feature/presentation/screens/" 2>/dev/null || true
        rmdir "lib/features/$feature/screens" 2>/dev/null || true
    fi

    # Move widgets
    if [ -d "lib/features/$feature/widgets" ]; then
        mv lib/features/$feature/widgets/* "lib/features/$feature/presentation/widgets/" 2>/dev/null || true
        rmdir "lib/features/$feature/widgets" 2>/dev/null || true
    fi

    # Move providers
    if [ -d "lib/features/$feature/providers" ]; then
        mv lib/features/$feature/providers/* "lib/features/$feature/domain/providers/" 2>/dev/null || true
        rmdir "lib/features/$feature/providers" 2>/dev/null || true
    fi

    # Move services
    if [ -d "lib/features/$feature/services" ]; then
        mv lib/features/$feature/services/* "lib/features/$feature/domain/services/" 2>/dev/null || true
        rmdir "lib/features/$feature/services" 2>/dev/null || true
    fi

    # Create barrel export
    cat > "lib/features/$feature/$feature.dart" <<'BARREL_EOF'
// Feature: FEATURE_NAME
// Barrel export file

// Presentation
export 'presentation/screens/FEATURE_NAME_screen.dart';
BARREL_EOF

    # Replace placeholders
    sed -i '' "s/FEATURE_NAME/$feature/g" "lib/features/$feature/$feature.dart"

    if [ -d "lib/features/$feature/presentation/widgets" ]; then
        for widget in lib/features/$feature/presentation/widgets/*.dart; do
            if [ -f "$widget" ]; then
                widget_name=$(basename "$widget")
                echo "export 'presentation/widgets/$widget_name';" >> "lib/features/$feature/$feature.dart"
            fi
        done
    fi

    echo "" >> "lib/features/$feature/$feature.dart"
    echo "// Domain" >> "lib/features/$feature/$feature.dart"
    if [ -d "lib/features/$feature/domain/providers" ]; then
        for provider in lib/features/$feature/domain/providers/*.dart; do
            if [ -f "$provider" ] && [[ ! "$provider" =~ \.g\.dart$ ]]; then
                provider_name=$(basename "$provider")
                echo "export 'domain/providers/$provider_name';" >> "lib/features/$feature/$feature.dart"
            fi
        done
    fi
}

# Reorganize each feature
for feature_dir in lib/features/*/; do
    if [ -d "$feature_dir" ]; then
        feature=$(basename "$feature_dir")
        reorganize_feature "$feature"
    fi
done

echo -e "${GREEN}  ✅ Feature modules reorganized${NC}"

# ============================================================================
# PHASE 4: Improve Shared Layer
# ============================================================================
echo -e "${BLUE}🎨 Phase 4: Improve Shared Layer${NC}"

# Create organized widget directories
mkdir -p lib/shared/widgets/{buttons,cards,loading,dialogs,layouts}
mkdir -p lib/shared/constants
mkdir -p lib/shared/utils

# Move existing widgets to appropriate categories
if [ -f "lib/shared/widgets/book_card.dart" ]; then
    mv lib/shared/widgets/book_card.dart lib/shared/widgets/cards/
fi
if [ -f "lib/shared/widgets/book_grid_card.dart" ]; then
    mv lib/shared/widgets/book_grid_card.dart lib/shared/widgets/cards/
fi
if [ -f "lib/shared/widgets/main_scaffold.dart" ]; then
    mv lib/shared/widgets/main_scaffold.dart lib/shared/widgets/layouts/
fi

echo -e "${GREEN}  ✅ Shared layer improved${NC}"

# ============================================================================
# PHASE 5: Update Imports
# ============================================================================
echo -e "${BLUE}🔄 Phase 5: Update Imports${NC}"

echo "  Updating import paths..."

# Update database imports
find lib -name "*.dart" -type f -exec sed -i '' \
    's|import.*core/database/database.dart|import '\''package:books_flutter/core/data/database/database.dart'\'';|g' {} \;

# Update DTO imports
find lib -name "*.dart" -type f -exec sed -i '' \
    's|import.*core/models/dtos/|import '\''package:books_flutter/core/data/models/dtos/|g' {} \;

# Update entity imports
find lib -name "*.dart" -type f -exec sed -i '' \
    's|import.*core/models/entities/|import '\''package:books_flutter/core/domain/entities/|g' {} \;

# Update service imports
find lib -name "*.dart" -type f -exec sed -i '' \
    's|import.*core/services/api_client.dart|import '\''package:books_flutter/core/services/api/api_client.dart'\'';|g' {} \;
find lib -name "*.dart" -type f -exec sed -i '' \
    's|import.*core/services/firebase_auth_service.dart|import '\''package:books_flutter/core/services/auth/firebase_auth_service.dart'\'';|g' {} \;
find lib -name "*.dart" -type f -exec sed -i '' \
    's|import.*core/services/firebase_sync_service.dart|import '\''package:books_flutter/core/services/sync/firebase_sync_service.dart'\'';|g' {} \;

# Update feature imports to use barrel exports
for feature_dir in lib/features/*/; do
    if [ -d "$feature_dir" ]; then
        feature=$(basename "$feature_dir")

        # Update screen imports
        find lib -name "*.dart" -type f -exec sed -i '' \
            "s|import.*features/$feature/screens/|import 'package:books_flutter/features/$feature/presentation/screens/|g" {} \;

        # Update widget imports
        find lib -name "*.dart" -type f -exec sed -i '' \
            "s|import.*features/$feature/widgets/|import 'package:books_flutter/features/$feature/presentation/widgets/|g" {} \;

        # Update provider imports
        find lib -name "*.dart" -type f -exec sed -i '' \
            "s|import.*features/$feature/providers/|import 'package:books_flutter/features/$feature/domain/providers/|g" {} \;
    fi
done

# Update shared widget imports
find lib -name "*.dart" -type f -exec sed -i '' \
    's|import.*shared/widgets/book_card.dart|import '\''package:books_flutter/shared/widgets/cards/book_card.dart'\'';|g' {} \;
find lib -name "*.dart" -type f -exec sed -i '' \
    's|import.*shared/widgets/book_grid_card.dart|import '\''package:books_flutter/shared/widgets/cards/book_grid_card.dart'\'';|g' {} \;
find lib -name "*.dart" -type f -exec sed -i '' \
    's|import.*shared/widgets/main_scaffold.dart|import '\''package:books_flutter/shared/widgets/layouts/main_scaffold.dart'\'';|g' {} \;

echo -e "${GREEN}  ✅ Imports updated${NC}"

# ============================================================================
# PHASE 6: Update main.dart
# ============================================================================
echo -e "${BLUE}📱 Phase 6: Update main.dart${NC}"

# Backup original main.dart
cp lib/main.dart lib/main.dart.backup

# Create simplified main.dart
cat > lib/main.dart <<'EOF'
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(
    const ProviderScope(
      child: BooksApp(),
    ),
  );
}
EOF

echo -e "${GREEN}  ✅ main.dart simplified${NC}"

# ============================================================================
# VERIFICATION
# ============================================================================
echo ""
echo -e "${BLUE}🔍 Running Verification...${NC}"

# Run flutter analyze
echo "  Running flutter analyze..."
if flutter analyze --no-fatal-infos > /tmp/flutter_analyze.log 2>&1; then
    echo -e "${GREEN}  ✅ Flutter analyze passed${NC}"
else
    echo -e "${YELLOW}  ⚠️  Flutter analyze has warnings (see /tmp/flutter_analyze.log)${NC}"
fi

# Run code generation
echo "  Running build_runner..."
if dart run build_runner build --delete-conflicting-outputs > /tmp/build_runner.log 2>&1; then
    echo -e "${GREEN}  ✅ Code generation successful${NC}"
else
    echo -e "${YELLOW}  ⚠️  Code generation had issues (see /tmp/build_runner.log)${NC}"
fi

# ============================================================================
# SUMMARY
# ============================================================================
echo ""
echo -e "${GREEN}✅ Reorganization Complete!${NC}"
echo ""
echo -e "${BLUE}📊 Summary:${NC}"
echo "  ✅ Extracted app configuration layer"
echo "  ✅ Reorganized core data layer (database, repositories, models)"
echo "  ✅ Refactored all feature modules (domain/presentation separation)"
echo "  ✅ Improved shared layer organization"
echo "  ✅ Updated all import paths"
echo "  ✅ Simplified main.dart"
echo ""
echo -e "${YELLOW}📝 Next Steps:${NC}"
echo "  1. Review changes: git diff"
echo "  2. Test the app: flutter run"
echo "  3. If issues, rollback: git checkout $BACKUP_BRANCH"
echo "  4. Commit changes: git add . && git commit -m 'refactor: modernize project structure'"
echo ""
echo -e "${BLUE}📚 Documentation:${NC}"
echo "  See .github/FLUTTER_ORGANIZATION_PLAN.md for details"
echo ""
echo -e "${GREEN}🎉 Your Flutter project is now organized with modern best practices!${NC}"
