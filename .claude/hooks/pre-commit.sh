#!/bin/bash
# Pre-commit hook for BooksTrack Flutter
# Runs before git commits to ensure code quality
#
# This hook integrates with Zen MCP for automated code review

set -e

echo "🔍 Pre-commit Hook: Running code quality checks..."

# 1. Flutter analyze
echo "📊 Running flutter analyze..."
if ! flutter analyze --no-fatal-infos; then
    echo "❌ Flutter analyze found issues. Please fix before committing."
    exit 1
fi

# 2. Format check
echo "✨ Checking code formatting..."
if ! dart format --set-exit-if-changed . > /dev/null 2>&1; then
    echo "⚠️  Code is not formatted. Running dart format..."
    dart format .
    echo "✅ Code formatted automatically. Please review and re-stage changes."
    exit 1
fi

# 3. Run tests (if available)
if [ -d "test" ] && [ "$(ls -A test)" ]; then
    echo "🧪 Running tests..."
    if ! flutter test; then
        echo "❌ Tests failed. Please fix before committing."
        exit 1
    fi
fi

# 4. Check for sensitive files
echo "🔐 Checking for sensitive files..."
if git diff --cached --name-only | grep -E "google-services\.json|GoogleService-Info\.plist|\.env$"; then
    echo "❌ ERROR: Attempting to commit sensitive files!"
    echo "Files found:"
    git diff --cached --name-only | grep -E "google-services\.json|GoogleService-Info\.plist|\.env$"
    echo ""
    echo "These files should be in .gitignore. Run:"
    echo "  git restore --staged <file>"
    exit 1
fi

# 5. Check for debug statements
echo "🐛 Checking for debug statements..."
if git diff --cached | grep -E "print\(|debugPrint\(|console\.log" > /dev/null; then
    echo "⚠️  Warning: Found debug print statements in staged changes."
    echo "Consider removing them or using proper logging."
    # Don't fail, just warn
fi

echo "✅ Pre-commit checks passed!"
echo ""
