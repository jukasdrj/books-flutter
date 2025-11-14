#!/bin/bash

# Flutter Pre-Commit Hook
# Based on backend template, customized for Flutter

set -e

echo "🤖 Running Flutter pre-commit checks..."

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

FAILED=0

# 1. Check for sensitive files
echo "🔐 Checking for sensitive files..."
SENSITIVE_FILES=(
  "*.jks"
  "*.keystore"
  "*key.properties"
  "*google-services.json"
  "*GoogleService-Info.plist"
  "*.p12"
)

for pattern in "${SENSITIVE_FILES[@]}"; do
  if git diff --cached --name-only | grep -q "$pattern"; then
    echo -e "${RED}✗ Blocked: Attempting to commit sensitive file: $pattern${NC}"
    FAILED=1
  fi
done

if [ $FAILED -eq 0 ]; then
  echo -e "${GREEN}✓ No sensitive files detected${NC}"
fi

# 2. Check for code generation needed
if command -v flutter &> /dev/null; then
  echo "⚙️  Checking code generation..."
  STAGED_PROVIDERS=$(git diff --cached --name-only --diff-filter=ACM | grep -E "(provider|database|drift).*\.dart$" || true)

  if [ -n "$STAGED_PROVIDERS" ]; then
    echo -e "${YELLOW}ℹ Info: Provider/Database files changed${NC}"
    echo "  Ensure you've run: dart run build_runner build --delete-conflicting-outputs"
  fi
fi

# 3. Dart analyzer (if Flutter available)
if command -v flutter &> /dev/null; then
  echo "🎯 Running Dart analyzer..."
  STAGED_DART=$(git diff --cached --name-only --diff-filter=ACM | grep -E '\.dart$' || true)

  if [ -n "$STAGED_DART" ]; then
    if ! flutter analyze --no-pub 2>&1 | grep -q "No issues found"; then
      echo -e "${YELLOW}⚠ Warning: Dart analyzer found issues${NC}"
      echo "  Run: flutter analyze"
    else
      echo -e "${GREEN}✓ Dart analyzer passed${NC}"
    fi
  fi
fi

# 4. Check for debug print statements
echo "🐛 Checking for debug statements..."
DEBUG_COUNT=$(git diff --cached | grep -c "print(" || true)

if [ $DEBUG_COUNT -gt 0 ]; then
  echo -e "${YELLOW}⚠ Warning: Found $DEBUG_COUNT print() statements${NC}"
  echo "  Consider using debugPrint() or proper logging"
fi

# 5. Check pubspec.yaml changes
if git diff --cached --name-only | grep -q "pubspec.yaml"; then
  echo "📦 Checking pubspec.yaml..."

  if git diff --cached pubspec.yaml | grep -q "<<<<<<"; then
    echo -e "${RED}✗ Merge conflicts in pubspec.yaml${NC}"
    FAILED=1
  else
    echo -e "${GREEN}✓ pubspec.yaml looks clean${NC}"
  fi
fi

# Final result
echo ""
if [ $FAILED -eq 1 ]; then
  echo -e "${RED}❌ Pre-commit checks failed. Commit blocked.${NC}"
  exit 1
else
  echo -e "${GREEN}✅ All pre-commit checks passed!${NC}"
  exit 0
fi
