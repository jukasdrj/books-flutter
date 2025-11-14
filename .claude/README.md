# Claude Code Agent Setup (Flutter)

**Synced from:** bookstrack-backend (automated setup)
**Tech Stack:** Flutter, Dart

## Available Agents

### ✅ Universal Agents (Synced from Backend)
- **project-manager** - Orchestration and delegation
- **zen-mcp-master** - Deep analysis (14 Zen MCP tools)

### 🚧 Flutter-Specific Agent (TODO)
- **flutter-agent** - Flutter build, test, and deployment

## Quick Start

```bash
# For complex workflows
/skill project-manager

# For analysis/review/debugging
/skill zen-mcp-master

# For Flutter build/test (after creating flutter-agent)
/skill flutter-agent
```

## Next Steps

### 1. Create flutter-agent (Required)

Create `.claude/skills/flutter-agent/skill.md` with Flutter-specific capabilities:

- Flutter build commands (`flutter build`)
- Dart testing (`flutter test`)
- Package management (`pub get`, `pub upgrade`)
- Platform builds (Android, iOS, Web)
- Performance profiling

### 2. Customize project-manager

Edit `.claude/skills/project-manager/skill.md`:
- Replace `cloudflare-agent` references with `flutter-agent`
- Update delegation patterns for Flutter workflows

### 3. Add Hooks (Optional)

**Pre-commit hook** (`.claude/hooks/pre-commit.sh`):
- Dart analyzer validation
- Flutter formatting checks
- pubspec.yaml validation

**Post-tool-use hook** (`.claude/hooks/post-tool-use.sh`):
- Suggest `flutter-agent` when flutter commands are used
- Suggest `zen-mcp-master` for Dart file changes

## Documentation

- `ROBIT_OPTIMIZATION.md` - Complete agent architecture
- `ROBIT_SHARING_FRAMEWORK.md` - How sharing works
- Backend repo: https://github.com/jukasdrj/bookstrack-backend/.claude/

## Future Updates

Run `../bookstrack-backend/scripts/sync-robit-to-repos.sh` to sync updates from backend.
