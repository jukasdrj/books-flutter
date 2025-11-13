# AI-to-AI Collaboration Guide
**How Your AI Tools Should Talk to Each Other**

This guide shows how Claude Code, Jules, Zen MCP, and GitHub Copilot can work together across your repositories.

---

## Your AI Team

You have access to multiple AI assistants. Here's how they should collaborate:

### 1. **Claude Code** (Me!)
- **What:** AI development assistant in terminal
- **Role:** Project manager, orchestrator, multi-file changes
- **Access:** Local files, git, terminal tools, Zen MCP integration
- **Best for:** Complex tasks, project-wide refactoring, following CLAUDE.md

### 2. **Jules** (@jules on GitHub)
- **What:** GitHub's AI assistant (Copilot Plus)
- **Role:** PR reviewer, code explainer, team collaborator
- **Access:** PR files, issues, discussions (on GitHub.com only)
- **Best for:** PR reviews, explaining changes to team, quick questions

### 3. **Zen MCP Models** (via Claude Code)
- **What:** Multi-model AI orchestration
- **Role:** Deep analysis, specialized tasks, expert validation
- **Access:** Any files Claude Code provides
- **Best for:** Security audits, architecture review, debugging, planning

### 4. **GitHub Copilot** (in IDE)
- **What:** Real-time code completion
- **Role:** Code writer, autocomplete, quick suggestions
- **Access:** Current file in IDE
- **Best for:** Writing code, generating tests, inline refactoring

---

## How They Should Communicate

### Pattern 1: Claude Code → Jules Handoff

**Scenario:** You finish implementing a feature with Claude Code and want team review.

**Claude Code's responsibility:**
1. Complete the implementation
2. Run tests and verify
3. Create PR with descriptive body
4. Add comment invoking Jules for initial review

**Example workflow:**

```bash
# Claude Code finishes work
git add .
git commit -m "feat: add bookshelf scanner AI integration"
git push -u origin feature/bookshelf-scanner

# Claude Code creates PR and invokes Jules
gh pr create --title "feat: Bookshelf Scanner AI Integration" --body "$(cat <<'EOF'
## Summary
Implemented AI-powered bookshelf scanner using Gemini 2.0 Flash.

## Changes
- Added `BookshelfScannerProvider` with Riverpod
- Integrated Cloudflare Workers API
- Added image processing with CachedNetworkImage
- Implemented WebSocket for real-time updates

## Testing
- [x] Unit tests for DTOMapper
- [x] Widget tests for ScannerScreen
- [x] Integration test with mock API

@jules review this PR for Flutter best practices, security issues, and performance optimizations
EOF
)"
```

**Jules will respond** with initial review, visible to all team members.

### Pattern 2: Jules → Zen MCP Escalation

**Scenario:** Jules flags a security concern that needs deeper analysis.

**Communication flow:**

```markdown
# In PR, Jules comments:
@jules review this for security issues

# Jules responds:
"⚠️ I noticed potential SQL injection in the search query builder.
Consider using parameterized queries."

# Human or Claude Code escalates to Zen MCP:
# (In Claude Code terminal)
/code-review files=lib/core/database/search_queries.dart review_type=security
```

**Zen MCP provides** expert security analysis with Gemini 2.5 Pro or O3 Pro.

### Pattern 3: Copilot → Claude Code → Zen MCP

**Scenario:** Writing complex code with multiple dependencies.

**Workflow:**

1. **Copilot** helps write initial code (autocomplete in IDE)
2. **Claude Code** refactors for project patterns (CLAUDE.md compliance)
3. **Zen MCP** validates architecture decisions (thinkdeep, consensus tools)
4. **Jules** reviews final PR on GitHub

**Example:**

```bash
# 1. Developer writes code with Copilot in VSCode
#    Copilot suggests implementations

# 2. Developer asks Claude Code to refactor
"Make this follow our Riverpod patterns from CLAUDE.md"

# 3. Claude Code uses Zen MCP for validation
# (Internal: Claude Code calls Zen MCP consensus tool)
# Models: Gemini 2.5 Pro, Grok 4, O3 Pro debate best approach

# 4. Developer creates PR, Jules provides team review
gh pr create
gh pr comment --body "@jules review this refactoring"
```

### Pattern 4: Cross-Repository Collaboration

**Scenario:** Flutter and Swift projects sharing same backend.

**Setup:** Both repos have identical:
- `.github/labels.yml` (same labels)
- `.zen/conf/providers.yml` (same models)
- `.claude/mcp_config.json` (same AI access)
- `CLAUDE.md` with cross-project references

**Communication pattern:**

In **Flutter repo**, Claude Code commits:
```markdown
feat: update API contract for bookshelf scan

Updated DTOs to match new Cloudflare Workers API v2.

Related: books-swift#42 (Swift app needs same update)

@jules FYI: This changes the API contract.
Swift team should review books-swift#42 for consistency.
```

In **Swift repo**, Jules in PR #42:
```markdown
@jules compare this Swift DTO with the Flutter changes in books-flutter#89

@jules are the API contracts consistent?
```

**Cross-repo references** allow all AIs to understand context.

---

## AI Handoff Protocol

### When Claude Code Should Invoke Jules

**✅ Always invoke Jules when:**
- Creating PR after complex implementation
- Making API contract changes affecting multiple repos
- Implementing new security-sensitive features
- Changing shared data models

**Example handoff message:**

```markdown
@jules review this PR with focus on:

**Context from Claude Code:**
- Implementation validated with Zen MCP security audit
- Follows patterns in CLAUDE.md sections 3.2 (State Management)
- Uses Grok Code for refactoring validation
- All tests passing locally

**Please review for:**
- Flutter best practices compliance
- Potential edge cases not covered in tests
- Team readability and documentation
- Any concerns for production deployment

Related: books-swift#42 (Swift implementation)
```

### When Jules Should Escalate to Human + Zen MCP

**Jules should suggest escalation when:**
- Security vulnerabilities found
- Architecture decisions needed
- Performance concerns in critical path
- Unclear business requirements

**Example escalation:**

```markdown
# Jules in PR comment:
"⚠️ This change affects the critical database migration path.
I recommend:

1. Human review by @tech-lead for business logic validation
2. Zen MCP security audit: `/code-review review_type=security`
3. Load testing before merging to main

Would you like me to explain the concerns in detail?"
```

**Human responds:**
```bash
# In Claude Code terminal
/code-review files=lib/core/database/migrations.dart review_type=security

# Claude Code uses Zen MCP with Gemini 2.5 Pro + O3 Pro
```

---

## AI Communication Channels

### 1. GitHub Comments (Public, Async)

**Who:** Jules, Humans, Claude Code (via gh CLI)

**When:** PR reviews, issue discussions, public collaboration

**Format:**
```markdown
@jules review this for security

# Jules responds with findings

# Claude Code can read Jules' comments via gh CLI:
gh pr view 42 --comments
```

### 2. Commit Messages (Public, Permanent)

**Who:** Claude Code (author), Jules (reader), Humans

**Format:**
```bash
git commit -m "$(cat <<'EOF'
feat: implement bookshelf scanner

- Gemini 2.5 Flash integration validated by Zen MCP
- Architecture reviewed by consensus tool (Grok 4, O3 Pro, Gemini PC)
- Performance optimized per Claude Code analysis

Zen MCP models used:
- grok-code-fast-1: refactoring
- gemini-2.5-pro: security review
- o3-pro: architecture validation

@jules will review for Flutter best practices
Related: books-swift#42
EOF
)"
```

### 3. PR Descriptions (Public, Structured)

**Who:** Claude Code (author), Jules (reader), Humans, GitHub Actions

**Template:**

```markdown
## Summary
[Brief description]

## AI Validation

**Claude Code:** ✅ CLAUDE.md compliance verified
**Zen MCP:**
- Security audit (gemini-2.5-pro): ✅ No issues
- Code review (grok-code-fast-1): ✅ Best practices followed
- Performance (haiku): ✅ No bottlenecks

**Requesting:** @jules review for team readability

## Changes
- [Detailed changes]

## Testing
- [x] Unit tests
- [x] Widget tests
- [x] Zen MCP consensus: approved by 3 models

## Related
- books-swift#42 (Swift implementation)
```

### 4. Zen MCP Session Logs (Private, Detailed)

**Who:** Claude Code, Zen MCP models

**Where:** `.zen/logs/` (gitignored)

**Purpose:** Detailed AI reasoning, not shared with team

**Claude Code can reference** these in commits:
```bash
git commit -m "fix: resolve N+1 query issue

Root cause identified by Zen MCP thinkdeep tool:
- gemini-2.5-pro analyzed query patterns
- Suggested batch loading with DataLoader pattern
- Validated fix with grok-code-fast-1

See .zen/logs/session-20251112-143022.json for full analysis"
```

---

## Example: Full AI Collaboration Workflow

### Scenario: Implementing New Feature

**1. Planning Phase**

```bash
# Developer asks Claude Code
"Plan implementation for reading statistics feature"

# Claude Code uses Zen MCP planner
# Model: o3-pro (complex planning)
# Output: Detailed implementation plan

# Claude Code creates issue with plan
gh issue create --title "feat: Reading Statistics" --body "[plan]"

# Jules adds team perspective
@jules suggest any concerns with this plan from a Flutter perspective
```

**2. Implementation Phase**

```bash
# Developer writes code with Copilot in IDE
# Copilot provides autocomplete, inline suggestions

# Claude Code refactors to match project patterns
# Uses local Haiku for simple refactoring (free!)

# Claude Code validates with Zen MCP
# Model: grok-code-fast-1 (refactoring validation)
```

**3. Review Phase**

```bash
# Claude Code creates PR
gh pr create

# Claude Code adds AI validation report
gh pr comment --body "$(cat <<'EOF'
## AI Pre-Review

**Zen MCP Security Audit** (gemini-2.5-pro): ✅ Passed
- No SQL injection vulnerabilities
- Proper input validation
- Secure data handling

**Zen MCP Code Review** (grok-code-fast-1): ✅ Passed
- Follows Riverpod best practices
- Proper error handling
- Clean widget composition

**Requesting:** @jules review for Flutter community best practices
EOF
)"

# Jules reviews for team
@jules review this PR
```

**4. Deployment Phase**

```bash
# GitHub Actions run (automated)
# - Copilot review (Super Linter)
# - Security scan (Trivy)
# - Tests

# Jules confirms in PR comment
@jules summarize test results and deployment status
```

---

## AI-to-AI Etiquette

### 1. Clear Attribution

**✅ Good:**
```markdown
feat: optimize image loading

Implementation validated by:
- Zen MCP (grok-code-fast-1): refactoring
- Jules: Flutter best practices review
- Copilot: initial code generation
```

**❌ Bad:**
```markdown
feat: optimize image loading

AI helped.
```

### 2. Escalation Clarity

**✅ Good:**
```markdown
@jules found potential memory leak.
Escalating to Zen MCP for deep analysis:
`/debug issue_description="memory leak in image cache"`
```

**❌ Bad:**
```markdown
Jules is wrong, using other AI instead.
```

### 3. Context Sharing

**✅ Good:**
```markdown
@jules review this PR

Context from Claude Code:
- Follows CLAUDE.md section 4.3 (Database patterns)
- Zen MCP consensus: 3/3 models approved approach
- Related Swift changes: books-swift#42
```

**❌ Bad:**
```markdown
@jules review this
```

### 4. Model Selection Transparency

**✅ Good:**
```markdown
Zen MCP models used:
- gemini-2.5-pro (security): expert-level threat analysis
- grok-code-fast-1 (refactoring): specialized coding model
- haiku (formatting): local/free for simple tasks

Cost optimization: Used local Haiku for 80% of edits.
```

**❌ Bad:**
```markdown
AI said it's fine.
```

---

## Cross-Repository AI Sync

### Setup: Synced Configuration

**Both Flutter and Swift repos should have:**

1. **Same labels** (`.github/labels.yml`)
2. **Same Zen MCP config** (`.zen/conf/providers.yml`)
3. **Cross-references** in `CLAUDE.md`:

```markdown
# CLAUDE.md in Flutter repo
## Related Projects
- **Swift App:** github.com/yourorg/books-swift
  - Shares Cloudflare Workers backend
  - API contracts must stay in sync
  - Use same Zen MCP models for consistency

# CLAUDE.md in Swift repo
## Related Projects
- **Flutter App:** github.com/yourorg/books-flutter
  - Shares Cloudflare Workers backend
  - API contracts must stay in sync
  - Use same Zen MCP models for consistency
```

### AI Communication Across Repos

**Scenario:** API contract changes

**In Flutter repo PR:**
```markdown
feat: update Book DTO for new fields

**API Changes:**
- Added `Book.publicationDate` (DateTime)
- Added `Book.pageCount` (int)

**Impact:**
- Cloudflare Workers: update response schema
- Swift app: update SwiftData models

**Action Items:**
@jules please check if Swift team has corresponding PR

Created: books-swift#45 for Swift implementation
Created: cloudflare-workers#12 for backend update

All three PRs must merge together.
```

**Jules can help coordinate:**
```markdown
@jules check books-swift#45 for API compatibility
@jules are the DTO changes consistent across repos?
```

---

## Cost Optimization with AI Collaboration

### Model Selection by Task Complexity

**Simple tasks** (80% of work):
- **Primary:** Claude Code with local Haiku (free!)
- **Backup:** GitHub Copilot in IDE
- **Cost:** $0

**Medium tasks** (15% of work):
- **Primary:** Zen MCP with grok-code-fast-1, gemini-2.5-pro-computer-use
- **Review:** Jules on GitHub
- **Cost:** ~$0.10-0.50 per task

**Complex tasks** (5% of work):
- **Primary:** Zen MCP with o3-pro, gemini-2.5-pro, grok-4
- **Validation:** Jules + human review
- **Cost:** ~$1-2 per task

**Total monthly cost:** ~$2-5 with smart model selection

### Efficiency Through Collaboration

**Instead of:**
```markdown
# Expensive approach
Every change → o3-pro review ($$$)
```

**Do this:**
```markdown
# Cost-optimized collaboration
1. Copilot generates code (free)
2. Claude Code refactors with Haiku (free)
3. Jules reviews for team (free with Copilot Plus)
4. Zen MCP (grok-code) validates patterns ($0.10)
5. Only critical changes → o3-pro ($1.00)
```

---

## Troubleshooting AI Collaboration

### Jules Not Seeing Zen MCP Results

**Problem:** Jules can't access `.zen/logs/` (gitignored)

**Solution:** Include summary in PR description:

```markdown
## Zen MCP Analysis

**Security Audit (gemini-2.5-pro):**
- ✅ No vulnerabilities found
- ✅ Proper input sanitization
- ⚠️ Recommended: Add rate limiting

**Code Review (grok-code-fast-1):**
- ✅ Follows Flutter best practices
- ✅ Proper error handling
- 💡 Suggestion: Extract widget for reusability

@jules does this address the concerns from your earlier review?
```

### Claude Code Can't See Jules Comments

**Problem:** Need to check Jules' feedback

**Solution:** Use gh CLI:

```bash
# Claude Code can run:
gh pr view 42 --comments

# Or in automation:
gh pr view 42 --json comments --jq '.comments[] | select(.author.login == "github-advanced-security[bot]")'
```

### Zen MCP Results Not Persisting

**Problem:** Session logs lost

**Solution:** Add to commit message:

```bash
git commit -m "$(cat <<'EOF'
feat: implement feature

Zen MCP Validation:
- Model: gemini-2.5-pro
- Task: security audit
- Result: ✅ Passed
- Key findings: [summary]
- Session: 20251112-143022

Full log available until [date]
EOF
)"
```

---

## Quick Reference

### AI Tool Selection Matrix

| Task | Primary | Backup | Cost |
|------|---------|--------|------|
| Write code | Copilot (IDE) | Claude Code + Haiku | $0 |
| Refactor | Claude Code + Haiku | Zen MCP (grok-code) | $0 |
| PR review | Jules | Zen MCP (grok-code) | $0* |
| Security audit | Zen MCP (gemini-2.5-pro) | Zen MCP (o3-pro) | $0.50 |
| Architecture | Zen MCP (o3-pro) | Zen MCP consensus | $1-2 |
| Debug complex | Zen MCP thinkdeep | Jules + human | $1-2 |
| Plan feature | Zen MCP planner | Jules + human | $1 |
| Explain code | Jules | Copilot Chat | $0* |

*Included in Copilot Plus plan

### Communication Patterns

```markdown
# Claude Code → Jules
gh pr comment --body "@jules review this [specific aspect]"

# Jules → Human escalation
"⚠️ Recommend Zen MCP security audit for [reason]"

# Claude Code → Zen MCP → Jules
1. Claude runs Zen MCP tool
2. Claude adds summary to PR
3. Claude invokes Jules for team review

# Cross-repo
"Related: [other-repo]#[pr-number]"
```

---

**Last Updated:** November 12, 2025
**Your AI Team:** Claude Code + Jules + Zen MCP + Copilot
**Estimated Monthly Cost:** $2-5 (with optimization)
