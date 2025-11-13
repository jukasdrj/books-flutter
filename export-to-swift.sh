#!/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
FLUTTER_PROJECT="$(pwd)"
SWIFT_PROJECT=""

echo -e "${BLUE}🚀 Export Optimal Setup to Swift Project${NC}"
echo ""

# Get Swift project path from user
read -p "Enter path to your Swift 'books' project: " SWIFT_PROJECT

if [ ! -d "$SWIFT_PROJECT" ]; then
    echo -e "${RED}❌ Directory not found: $SWIFT_PROJECT${NC}"
    exit 1
fi

echo ""
echo -e "${GREEN}Flutter Project:${NC} $FLUTTER_PROJECT"
echo -e "${GREEN}Swift Project:${NC} $SWIFT_PROJECT"
echo ""

read -p "Proceed with export? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    echo "Export cancelled."
    exit 0
fi

echo ""

# 1. Copy GitHub Labels
echo -e "${BLUE}📋 Copying GitHub labels...${NC}"
mkdir -p "$SWIFT_PROJECT/.github"
cp "$FLUTTER_PROJECT/.github/labels.yml" "$SWIFT_PROJECT/.github/"
cp "$FLUTTER_PROJECT/.github/create_labels.py" "$SWIFT_PROJECT/.github/"
echo -e "${GREEN}✅ Labels copied${NC}"

# 2. Copy Zen MCP
echo -e "${BLUE}🤖 Copying Zen MCP configuration...${NC}"
if [ -d "$SWIFT_PROJECT/.zen" ]; then
    echo -e "${YELLOW}⚠️  .zen directory exists. Backing up to .zen.backup${NC}"
    mv "$SWIFT_PROJECT/.zen" "$SWIFT_PROJECT/.zen.backup"
fi
cp -r "$FLUTTER_PROJECT/.zen" "$SWIFT_PROJECT/"
echo -e "${GREEN}✅ Zen MCP configuration copied${NC}"

# 3. Copy Claude Code
echo -e "${BLUE}🔧 Copying Claude Code configuration...${NC}"
if [ -d "$SWIFT_PROJECT/.claude" ]; then
    echo -e "${YELLOW}⚠️  .claude directory exists. Backing up to .claude.backup${NC}"
    mv "$SWIFT_PROJECT/.claude" "$SWIFT_PROJECT/.claude.backup"
fi
cp -r "$FLUTTER_PROJECT/.claude" "$SWIFT_PROJECT/"
echo -e "${GREEN}✅ Claude Code configuration copied${NC}"

# 4. Copy Issue Templates
echo -e "${BLUE}📝 Copying issue templates...${NC}"
mkdir -p "$SWIFT_PROJECT/.github/ISSUE_TEMPLATE"
cp -r "$FLUTTER_PROJECT/.github/ISSUE_TEMPLATE/"* "$SWIFT_PROJECT/.github/ISSUE_TEMPLATE/"
echo -e "${GREEN}✅ Issue templates copied${NC}"

# 5. Copy Workflows
echo -e "${BLUE}⚙️  Copying workflows...${NC}"
mkdir -p "$SWIFT_PROJECT/.github/workflows"
if [ -f "$FLUTTER_PROJECT/.github/workflows/copilot-review.yml" ]; then
    cp "$FLUTTER_PROJECT/.github/workflows/copilot-review.yml" "$SWIFT_PROJECT/.github/workflows/"
    echo -e "${GREEN}  ✓ copilot-review.yml${NC}"
fi
if [ -f "$FLUTTER_PROJECT/.github/workflows/deploy-cloudflare.yml" ]; then
    cp "$FLUTTER_PROJECT/.github/workflows/deploy-cloudflare.yml" "$SWIFT_PROJECT/.github/workflows/"
    echo -e "${GREEN}  ✓ deploy-cloudflare.yml${NC}"
fi
echo -e "${YELLOW}⚠️  Workflows need manual adaptation for Swift/Xcode${NC}"

# 6. Copy environment template
echo -e "${BLUE}🔐 Copying .env.example...${NC}"
cp "$FLUTTER_PROJECT/.env.example" "$SWIFT_PROJECT/"
echo -e "${GREEN}✅ .env.example copied${NC}"

# 7. Update .gitignore
echo -e "${BLUE}🔒 Updating .gitignore...${NC}"
if [ -f "$SWIFT_PROJECT/.gitignore" ]; then
    # Check if our entries already exist
    if ! grep -q "# Zen MCP" "$SWIFT_PROJECT/.gitignore"; then
        cat >> "$SWIFT_PROJECT/.gitignore" <<EOF

# Environment variables (API keys)
.env

# Zen MCP (AI provider keys)
.zen/cache/
.zen/logs/
.zen/.session

# Claude Code
.claude/.session
.claude/cache/

# Firebase configuration files (contain API keys)
**/GoogleService-Info.plist
**/google-services.json
EOF
        echo -e "${GREEN}✅ .gitignore updated${NC}"
    else
        echo -e "${YELLOW}⚠️  .gitignore already contains our entries${NC}"
    fi
else
    echo -e "${YELLOW}⚠️  No .gitignore found. Creating one...${NC}"
    cat > "$SWIFT_PROJECT/.gitignore" <<EOF
# Environment variables (API keys)
.env

# Zen MCP (AI provider keys)
.zen/cache/
.zen/logs/
.zen/.session

# Claude Code
.claude/.session
.claude/cache/

# Firebase configuration files
**/GoogleService-Info.plist
**/google-services.json
EOF
    echo -e "${GREEN}✅ .gitignore created${NC}"
fi

# 8. Copy documentation
echo -e "${BLUE}📚 Copying documentation...${NC}"
cp "$FLUTTER_PROJECT/GITHUB_ZEN_SETUP.md" "$SWIFT_PROJECT/"
cp "$FLUTTER_PROJECT/WORKFLOW_SUMMARY.md" "$SWIFT_PROJECT/"
cp "$FLUTTER_PROJECT/AI_SETUP_README.md" "$SWIFT_PROJECT/"
mkdir -p "$SWIFT_PROJECT/.github"
if [ -f "$FLUTTER_PROJECT/.github/CLOUDFLARE_SETUP.md" ]; then
    cp "$FLUTTER_PROJECT/.github/CLOUDFLARE_SETUP.md" "$SWIFT_PROJECT/.github/"
fi
if [ -f "$FLUTTER_PROJECT/.github/COPILOT_GUIDE.md" ]; then
    cp "$FLUTTER_PROJECT/.github/COPILOT_GUIDE.md" "$SWIFT_PROJECT/.github/"
fi
if [ -f "$FLUTTER_PROJECT/.github/JULES_GUIDE.md" ]; then
    cp "$FLUTTER_PROJECT/.github/JULES_GUIDE.md" "$SWIFT_PROJECT/.github/"
fi
if [ -f "$FLUTTER_PROJECT/.github/CLAUDE_MAX_BENEFITS.md" ]; then
    cp "$FLUTTER_PROJECT/.github/CLAUDE_MAX_BENEFITS.md" "$SWIFT_PROJECT/.github/"
fi
if [ -f "$FLUTTER_PROJECT/.github/AI_COLLABORATION.md" ]; then
    cp "$FLUTTER_PROJECT/.github/AI_COLLABORATION.md" "$SWIFT_PROJECT/.github/"
fi
if [ -f "$FLUTTER_PROJECT/.github/FIREBASE_PRICING.md" ]; then
    cp "$FLUTTER_PROJECT/.github/FIREBASE_PRICING.md" "$SWIFT_PROJECT/.github/"
fi
cp "$FLUTTER_PROJECT/EXPORT_TO_SWIFT.md" "$SWIFT_PROJECT/"
echo -e "${GREEN}✅ All documentation copied (including Claude Max benefits)${NC}"

# 9. Create Swift-specific pre-commit hook
echo -e "${BLUE}🔨 Creating Swift-specific pre-commit hook...${NC}"
cat > "$SWIFT_PROJECT/.claude/hooks/pre-commit.sh" <<'EOF'
#!/bin/bash
set -e

echo "🔍 Pre-commit Hook: Running code quality checks..."

# 1. SwiftLint (install: brew install swiftlint)
if command -v swiftlint &> /dev/null; then
    if ! swiftlint lint --strict; then
        echo "❌ SwiftLint found issues. Please fix before committing."
        exit 1
    fi
    echo "✅ SwiftLint passed"
else
    echo "⚠️  SwiftLint not installed. Run: brew install swiftlint"
fi

# 2. Swift Format (install: brew install swift-format)
if command -v swift-format &> /dev/null; then
    if ! swift-format lint --recursive Sources/ Tests/ 2>/dev/null; then
        echo "⚠️  Swift format check found issues"
        # Uncomment to fail on format issues:
        # exit 1
    else
        echo "✅ Swift format check passed"
    fi
else
    echo "⚠️  swift-format not installed. Run: brew install swift-format"
fi

# 3. Check for sensitive files
if git diff --cached --name-only | grep -E "google-services\.json|GoogleService-Info\.plist|\.env$|credentials\.json"; then
    echo "❌ ERROR: Attempting to commit sensitive files!"
    echo "Files detected:"
    git diff --cached --name-only | grep -E "google-services\.json|GoogleService-Info\.plist|\.env$|credentials\.json"
    exit 1
fi

# 4. Check for debug statements
if git diff --cached | grep -E "^\+.*print\(|^\+.*debugPrint\(|^\+.*NSLog\("; then
    echo "⚠️  WARNING: Found debug print statements in staged changes."
    echo "Consider removing before committing to main branch."
fi

echo "✅ Pre-commit checks passed!"
EOF
chmod +x "$SWIFT_PROJECT/.claude/hooks/pre-commit.sh"
echo -e "${GREEN}✅ Swift pre-commit hook created${NC}"

echo ""
echo -e "${GREEN}✅ Export complete!${NC}"
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}Next steps:${NC}"
echo ""
echo -e "1. ${BLUE}Update component labels${NC} in .github/labels.yml for Swift"
echo "   - Change 'Drift database' → 'SwiftData models'"
echo "   - Change 'Riverpod' → '@Observable'"
echo "   - Change 'go_router' → 'NavigationStack'"
echo ""
echo -e "2. ${BLUE}Create labels${NC} on GitHub:"
echo "   cd $SWIFT_PROJECT/.github"
echo "   python3 create_labels.py"
echo ""
echo -e "3. ${BLUE}Set up API keys:${NC}"
echo "   cd $SWIFT_PROJECT"
echo "   cp .env.example .env"
echo "   # Edit .env with your keys"
echo ""
echo -e "4. ${BLUE}Link pre-commit hook:${NC}"
echo "   cd $SWIFT_PROJECT"
echo "   ln -sf ../../.claude/hooks/pre-commit.sh .git/hooks/pre-commit"
echo "   chmod +x .git/hooks/pre-commit"
echo ""
echo -e "5. ${BLUE}Install Swift tools:${NC}"
echo "   brew install swiftlint swift-format"
echo ""
echo -e "6. ${BLUE}Create Swift CI workflow${NC} (see EXPORT_TO_SWIFT.md)"
echo ""
echo -e "7. ${BLUE}Test the setup:${NC}"
echo "   git checkout -b test-new-workflow"
echo "   # Make a small change"
echo "   git add ."
echo "   git commit -m 'test: workflow setup'"
echo ""
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
echo -e "📖 Full guide: ${GREEN}$SWIFT_PROJECT/EXPORT_TO_SWIFT.md${NC}"
