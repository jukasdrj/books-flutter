# GitHub Issue Labels Reference

**Project:** BooksTrack Flutter
**Last Updated:** 2025-11-14
**Total Labels:** 48

This document serves as the single source of truth for all GitHub issue labels used in the BooksTrack Flutter project.

## Label Categories

### Priority Labels
Labels indicating urgency and importance of work items.

| Label | Color | Description |
|-------|-------|-------------|
| `P0: Critical` | ![#d73a4a](https://via.placeholder.com/15/d73a4a/000000?text=+) `#d73a4a` | Blocks progress, must fix immediately |
| `P1: High` | ![#ff6b6b](https://via.placeholder.com/15/ff6b6b/000000?text=+) `#ff6b6b` | Important, should fix soon |
| `P2: Medium` | ![#ffa500](https://via.placeholder.com/15/ffa500/000000?text=+) `#ffa500` | Standard priority |
| `P3: Low` | ![#ffeb3b](https://via.placeholder.com/15/ffeb3b/000000?text=+) `#ffeb3b` | Nice to have, low urgency |

### Type Labels
Labels categorizing the nature of the work.

| Label | Color | Description |
|-------|-------|-------------|
| `type: bug` | ![#d73a4a](https://via.placeholder.com/15/d73a4a/000000?text=+) `#d73a4a` | Something isn't working |
| `type: enhancement` | ![#a2eeef](https://via.placeholder.com/15/a2eeef/000000?text=+) `#a2eeef` | Improvement to existing feature |
| `type: feature` | ![#0366d6](https://via.placeholder.com/15/0366d6/000000?text=+) `#0366d6` | New functionality |
| `type: docs` | ![#0075ca](https://via.placeholder.com/15/0075ca/000000?text=+) `#0075ca` | Documentation updates |
| `type: perf` | ![#ff9800](https://via.placeholder.com/15/ff9800/000000?text=+) `#ff9800` | Performance optimization |
| `type: refactor` | ![#d4c5f9](https://via.placeholder.com/15/d4c5f9/000000?text=+) `#d4c5f9` | Code improvement, no feature change |
| `type: security` | ![#d93f0b](https://via.placeholder.com/15/d93f0b/000000?text=+) `#d93f0b` | Security fix or improvement |
| `type: test` | ![#c5def5](https://via.placeholder.com/15/c5def5/000000?text=+) `#c5def5` | Testing related |

### Phase Labels
Labels tracking project phases (12-week roadmap).

| Label | Color | Description | Timeline |
|-------|-------|-------------|----------|
| `phase: 1-foundation` | ![#bfd4f2](https://via.placeholder.com/15/bfd4f2/000000?text=+) `#bfd4f2` | Phase 1: Critical foundation | Weeks 1-3 |
| `phase: 2-search` | ![#b3e5fc](https://via.placeholder.com/15/b3e5fc/000000?text=+) `#b3e5fc` | Phase 2: Search feature | Weeks 4-5 |
| `phase: 3-scanner` | ![#c8e6c9](https://via.placeholder.com/15/c8e6c9/000000?text=+) `#c8e6c9` | Phase 3: AI Scanner | Weeks 6-8 |
| `phase: 4-insights` | ![#ffe0b2](https://via.placeholder.com/15/ffe0b2/000000?text=+) `#ffe0b2` | Phase 4: Insights & Analytics | Weeks 9-10 |
| `phase: 5-polish` | ![#f8bbd0](https://via.placeholder.com/15/f8bbd0/000000?text=+) `#f8bbd0` | Phase 5: Polish & Testing | Weeks 11-12 |
| `phase: 6-launch` | ![#e1bee7](https://via.placeholder.com/15/e1bee7/000000?text=+) `#e1bee7` | Phase 6: Production Launch | Weeks 13-14 |

### Platform Labels
Labels for platform-specific issues.

| Label | Color | Description |
|-------|-------|-------------|
| `platform: android` | ![#3ddc84](https://via.placeholder.com/15/3ddc84/000000?text=+) `#3ddc84` | Android-specific |
| `platform: ios` | ![#147efb](https://via.placeholder.com/15/147efb/000000?text=+) `#147efb` | iOS-specific |
| `platform: macos` | ![#555555](https://via.placeholder.com/15/555555/000000?text=+) `#555555` | macOS-specific |
| `platform: web` | ![#ff6f00](https://via.placeholder.com/15/ff6f00/000000?text=+) `#ff6f00` | Web-specific |
| `platform: all` | ![#000000](https://via.placeholder.com/15/000000/000000?text=+) `#000000` | Cross-platform |

### Component Labels
Labels for codebase components/modules.

| Label | Color | Description | Path |
|-------|-------|-------------|------|
| `component: database` | ![#5319e7](https://via.placeholder.com/15/5319e7/000000?text=+) `#5319e7` | Drift database layer | `lib/core/database/` |
| `component: ui` | ![#1d76db](https://via.placeholder.com/15/1d76db/000000?text=+) `#1d76db` | UI/widgets | `lib/shared/widgets/`, `lib/features/*/screens/` |
| `component: api` | ![#0e8a16](https://via.placeholder.com/15/0e8a16/000000?text=+) `#0e8a16` | API integration | `lib/core/services/api_client.dart` |
| `component: auth` | ![#fbca04](https://via.placeholder.com/15/fbca04/000000?text=+) `#fbca04` | Authentication | `lib/core/services/auth_service.dart` |
| `component: scanner` | ![#ff6347](https://via.placeholder.com/15/ff6347/000000?text=+) `#ff6347` | AI Scanner / Vision | `lib/features/scanner/` |
| `component: firebase` | ![#ffa500](https://via.placeholder.com/15/ffa500/000000?text=+) `#ffa500` | Firebase services | `firebase.json`, `*.rules` |
| `component: routing` | ![#d876e3](https://via.placeholder.com/15/d876e3/000000?text=+) `#d876e3` | Navigation / go_router | `lib/core/router/` |
| `component: state` | ![#006b75](https://via.placeholder.com/15/006b75/000000?text=+) `#006b75` | State management / Riverpod | `lib/**/providers/` |

### Status Labels
Labels tracking issue workflow state.

| Label | Color | Description |
|-------|-------|-------------|
| `status: blocked` | ![#b60205](https://via.placeholder.com/15/b60205/000000?text=+) `#b60205` | Blocked by dependencies |
| `status: in-progress` | ![#0e8a16](https://via.placeholder.com/15/0e8a16/000000?text=+) `#0e8a16` | Currently being worked on |
| `status: needs-review` | ![#fbca04](https://via.placeholder.com/15/fbca04/000000?text=+) `#fbca04` | Needs code review |
| `status: needs-testing` | ![#ff9800](https://via.placeholder.com/15/ff9800/000000?text=+) `#ff9800` | Needs testing |
| `status: ready` | ![#0075ca](https://via.placeholder.com/15/0075ca/000000?text=+) `#0075ca` | Ready to be worked on |

### Effort Labels
Labels estimating time/complexity (auto-applied by GitHub Actions).

| Label | Color | Description | File Count |
|-------|-------|-------------|------------|
| `effort: XS (< 2h)` | ![#c2e0c6](https://via.placeholder.com/15/c2e0c6/000000?text=+) `#c2e0c6` | Extra small effort | 1-3 files |
| `effort: S (2-4h)` | ![#bfdadc](https://via.placeholder.com/15/bfdadc/000000?text=+) `#bfdadc` | Small effort | 4-10 files |
| `effort: M (4-8h)` | ![#fef2c0](https://via.placeholder.com/15/fef2c0/000000?text=+) `#fef2c0` | Medium effort | 11-25 files |
| `effort: L (1-2d)` | ![#fbca04](https://via.placeholder.com/15/fbca04/000000?text=+) `#fbca04` | Large effort | 26-50 files |
| `effort: XL (3-5d)` | ![#d93f0b](https://via.placeholder.com/15/d93f0b/000000?text=+) `#d93f0b` | Extra large effort | 51+ files |

### Standard GitHub Labels
Default labels from GitHub.

| Label | Color | Description |
|-------|-------|-------------|
| `bug` | ![#d73a4a](https://via.placeholder.com/15/d73a4a/000000?text=+) `#d73a4a` | Something isn't working |
| `documentation` | ![#0075ca](https://via.placeholder.com/15/0075ca/000000?text=+) `#0075ca` | Improvements or additions to documentation |
| `duplicate` | ![#cfd3d7](https://via.placeholder.com/15/cfd3d7/000000?text=+) `#cfd3d7` | This issue or pull request already exists |
| `enhancement` | ![#a2eeef](https://via.placeholder.com/15/a2eeef/000000?text=+) `#a2eeef` | New feature or request |
| `good first issue` | ![#7057ff](https://via.placeholder.com/15/7057ff/000000?text=+) `#7057ff` | Good for newcomers |
| `help wanted` | ![#008672](https://via.placeholder.com/15/008672/000000?text=+) `#008672` | Extra attention needed |
| `invalid` | ![#e4e669](https://via.placeholder.com/15/e4e669/000000?text=+) `#e4e669` | This doesn't seem right |
| `question` | ![#d876e3](https://via.placeholder.com/15/d876e3/000000?text=+) `#d876e3` | Further information requested |
| `wontfix` | ![#ffffff](https://via.placeholder.com/15/ffffff/000000?text=+) `#ffffff` | This will not be worked on |

## Label Usage Guidelines

### Priority Assignment Rules
- **P0: Critical** - App crashes, data loss, security vulnerabilities, production blockers
- **P1: High** - Major features, important bugs affecting user experience
- **P2: Medium** - Standard improvements, non-critical bugs
- **P3: Low** - Nice-to-have features, minor improvements

### Combining Labels
Issues should typically have:
1. **One Priority label** (P0-P3)
2. **One Type label** (bug, feature, etc.)
3. **One Phase label** (matching current/target phase)
4. **One or more Platform labels** (if platform-specific)
5. **One or more Component labels** (affected modules)
6. **One Status label** (workflow state)
7. **One Effort label** (auto-applied by GitHub Actions)

### Example Label Combinations

**Critical Bug in Library Screen (iOS):**
```
P0: Critical
type: bug
phase: 1-foundation
platform: ios
component: ui
component: database
status: in-progress
effort: M (4-8h)
```

**New AI Scanner Feature:**
```
P1: High
type: feature
phase: 3-scanner
platform: all
component: scanner
component: api
status: ready
effort: XL (3-5d)
```

**Performance Optimization:**
```
P2: Medium
type: perf
phase: 5-polish
platform: all
component: database
component: ui
status: needs-review
effort: L (1-2d)
```

## Automation

### Auto-Labeling
The `.github/labeler.yml` configuration automatically applies labels to PRs based on:
- Changed file paths
- Number of files changed (effort estimation)
- File types (platform detection)

### Copilot Review Workflow
The `.github/workflows/copilot-review.yml` workflow:
- Runs Super Linter validation
- Auto-comments on PRs with GitHub Copilot tips
- Applies PR size labels (effort: XS/S/M/L/XL)
- Checks documentation links

## Creating New Labels

Use GitHub CLI to create labels programmatically:

```bash
# Create a new label
gh label create "component: new-feature" \
  --description "New feature component" \
  --color "ff6347"

# Update an existing label
gh label edit "component: new-feature" \
  --description "Updated description" \
  --color "00ff00"

# List all labels
gh label list
```

## Managing Labels

### Bulk Import
To recreate all labels from this documentation:

```bash
# Export current labels to JSON
gh label list --json name,description,color --limit 100 > labels.json

# Import labels to another repository
cat labels.json | jq -r '.[] |
  "gh label create \"\(.name)\" --description \"\(.description)\" --color \(.color)"' |
  bash
```

### Label Cleanup
Remove unused or deprecated labels:

```bash
# Delete a label
gh label delete "old-label"

# List labels with zero usage
gh api repos/:owner/:repo/labels --jq '.[] |
  select(.open_issues_count == 0) | .name'
```

## Integration with GitHub Projects

Labels automatically populate in GitHub Projects:
- **BooksTracker Development** (Project #2) - Active development tracking
- **@jukasdrj's books** (Project #1) - Personal project board

Project views can filter by:
- Priority (P0-P3)
- Phase (1-6)
- Platform (Android, iOS, Web, macOS)
- Component (database, ui, api, etc.)
- Status (blocked, in-progress, needs-review, etc.)

## Best Practices

1. **Always add priority** - Every issue needs P0-P3
2. **Use type labels** - Categorize the nature of work
3. **Track phases** - Align with 12-week roadmap
4. **Platform tags** - Mark platform-specific issues
5. **Component tags** - Help with code ownership
6. **Status updates** - Keep workflow state current
7. **Let automation handle effort** - Don't manually set effort labels

## References

- [GitHub Labels Documentation](https://docs.github.com/en/issues/using-labels-and-milestones-to-track-work/managing-labels)
- [Project Roadmap](../TODO_REFINED.md)
- [Labeler Configuration](labeler.yml)
- [Copilot Review Workflow](workflows/copilot-review.yml)

---

**Maintained by:** Project Orchestrator Agent
**Update Frequency:** As needed when labels change
**Label Count:** 48 total labels
