# Google Jules Guide
**Your Autonomous AI Coding Agent**

**Great news!** You have access to Google Jules through your Google Gemini Pro plan.

---

## What is Google Jules?

**Google Jules** is an autonomous AI coding agent that:
- Works asynchronously on your GitHub repositories
- Clones your repo to secure Google Cloud VMs
- Implements features while you work on other things
- Creates pull requests with complete implementations
- Generates audio summaries of changes
- Integrates with your existing GitHub workflow

**Access:** jules.google.com

**Included with:** Google Gemini Pro (you have this!)

**Quota:**
- Free beta: 5 tasks/day
- Gemini Pro: 60 tasks/day, up to 5 concurrent

---

## 🆚 Google Jules vs GitHub Copilot

You have BOTH! Here's when to use each:

| Feature | Google Jules | GitHub Copilot Plus |
|---------|--------------|---------------------|
| **Where it works** | jules.google.com (browser) | GitHub + your IDE |
| **Autonomous** | ✅ Yes (works in background) | Partial (agent mode) |
| **GitHub integration** | ✅ Direct PR creation | ✅ Direct PR creation |
| **Works while offline** | ✅ Yes (on Google Cloud VMs) | ❌ No (requires IDE open) |
| **Audio summaries** | ✅ Yes | ❌ No |
| **Code completions** | ❌ No | ✅ Yes (real-time) |
| **Chat in IDE** | ❌ No | ✅ Yes |
| **Multi-file edits** | ✅ Yes | ✅ Yes |
| **Task limit** | 60/day (Gemini Pro) | 1,500 requests/month |
| **Cost** | Included with Gemini Pro | $39/month |

**Recommendation:** Use BOTH!
- **Jules:** For asynchronous work (implement features overnight)
- **Copilot:** For real-time coding (autocomplete, chat, inline suggestions)

---

## 🚀 How to Set Up Google Jules

### Step 1: Sign In

1. Go to **jules.google.com**
2. Sign in with your Google account (same one as Gemini Pro)
3. Accept the privacy notice (one-time)

### Step 2: Connect GitHub

1. Click "Connect to GitHub account"
2. Complete GitHub OAuth login
3. Choose repositories to connect:
   - **All repositories** (recommended for full access)
   - **Select repositories** (books-flutter, books-swift, etc.)

### Step 3: Access Dashboard

After connecting, you'll see:
- Tasks used today: X / 60
- Active tasks: X / 5
- Connected repositories list
- Recent activity

---

## 💡 How to Use Google Jules

### Basic Workflow

**1. Pick a repository**
- Select: books-flutter
- Choose branch: main or create feature branch

**2. Describe your task**

Examples:
```
Fix the N+1 query issue in the library screen

Add unit tests for the DTOMapper class with edge cases

Refactor the scanner feature to use the new Cloudflare Workers API

Implement reading statistics with charts showing books per month
```

**3. Review the plan**

Jules will show:
- Files it wants to modify
- Specific changes planned
- Reasoning for each change

**4. Approve or adjust**

- Click "Approve" to proceed
- Or click "Adjust" to modify the plan
- Or "Cancel" if you want to rethink

**5. Wait for completion**

- Jules works asynchronously (15-60 minutes typical)
- You can close the browser
- Get notified when done (email + in-dashboard)

**6. Review the PR**

- Jules creates a GitHub PR
- Review the code changes
- Request changes if needed
- Merge when satisfied

---

## 🎯 Best Use Cases for Jules

### 1. **Overnight Feature Implementation**

**Scenario:** It's 6 PM, you want a feature by morning

**Task:**
```
Implement reading statistics feature:
- Show books read per month (chart)
- Show favorite genres (pie chart)
- Show reading streak counter
- Add export to CSV functionality

Use Flutter charts package for visualizations.
Follow the patterns in lib/features/library/ for consistency.
Add unit tests for all business logic.
```

**Jules will:**
- Work overnight while you sleep
- Create all necessary files
- Generate tests
- Create PR by morning

**Your work:** Review PR, make tweaks, merge

### 2. **Large Refactoring Tasks**

**Scenario:** Need to update API integration across 20 files

**Task:**
```
Update all API calls to use new Cloudflare Workers v2 API:
- Change endpoint from /api/v1/ to /api/v2/
- Update DTOs to match new schema (publicationDate is now DateTime)
- Add error handling for new error format
- Update tests

Files affected: lib/core/services/, lib/features/*/providers/
```

**Jules will:**
- Identify all affected files
- Make consistent changes
- Update tests
- Ensure no breaking changes

### 3. **Test Generation**

**Scenario:** Code works but needs comprehensive tests

**Task:**
```
Generate comprehensive unit tests for lib/core/services/dto_mapper.dart:
- Happy path tests
- Edge cases (null values, empty lists)
- Error scenarios
- Mock Firestore data

Use the existing test patterns in test/core/services/
```

**Jules will:**
- Analyze the code
- Generate thorough tests
- Follow project patterns
- Create test fixtures

### 4. **Documentation Updates**

**Scenario:** Code comments are outdated

**Task:**
```
Update all documentation in lib/core/database/:
- Add JSDoc-style comments to all public methods
- Update outdated comments
- Add code examples for complex functions
- Create README.md explaining the database architecture

Follow the documentation style in CLAUDE.md
```

### 5. **Bug Fixes**

**Scenario:** Bug reported, need it fixed systematically

**Task:**
```
Fix: DTOMapper returns wrong authors for books

Issue: When fetching books, the author field sometimes shows the wrong author.
Likely cause: N+1 query or incorrect JOIN logic.

Files to investigate:
- lib/core/services/dto_mapper.dart
- lib/core/database/database.dart

Add tests to prevent regression.
```

**Jules will:**
- Investigate the issue
- Propose a fix
- Add regression tests
- Document the solution

---

## ⚡ Advanced Jules Techniques

### 1. **Multi-Phase Tasks**

Break complex work into phases:

**Phase 1:**
```
Phase 1: Set up reading statistics data models

Create database tables for:
- MonthlyStats (books_read_count, month, year)
- GenreStats (genre, book_count)
- ReadingStreak (current_streak, longest_streak)

Add migrations and update database.dart
```

**Phase 2 (after reviewing Phase 1):**
```
Phase 2: Implement UI for reading statistics

Create screens using the data models from PR #123:
- StatisticsScreen with tab navigation
- MonthlyChart widget (use fl_chart package)
- GenreDistribution widget
- StreakCounter widget

Follow Material Design 3 patterns from lib/shared/widgets/
```

### 2. **Cross-Repository Work**

**Scenario:** Same feature in Flutter + Swift apps

**Task for books-flutter:**
```
Implement bookshelf scanning API integration (Flutter side):
- Create ScanSessionProvider using Riverpod
- Add WebSocket connection to Cloudflare Workers
- Implement real-time progress updates
- Add error handling

See books-swift PR #42 for the Swift implementation.
Match the API contract exactly.
```

**Task for books-swift (separate):**
```
Implement bookshelf scanning API integration (Swift side):
- Create ScanSessionViewModel using @Observable
- Add WebSocket connection to Cloudflare Workers
- Implement real-time progress updates
- Add error handling

See books-flutter PR #89 for the Flutter implementation.
Match the API contract exactly.
```

**Jules will ensure consistency across repos!**

### 3. **Learning from Existing Code**

**Give Jules examples:**

```
Refactor the scanner screen to follow the same patterns as library screen:
- Use StatefulShellRoute like lib/core/router/app_router.dart
- Use Riverpod providers like lib/features/library/providers/
- Follow the widget composition in lib/shared/widgets/
- Match the error handling pattern in lib/core/services/

Make it consistent with the rest of the codebase.
```

**Jules will learn from your code!**

---

## 🤝 Jules + Copilot + Claude Code Workflow

**The Ultimate AI Team Workflow:**

### Morning (9 AM): Assign to Jules
```
# On jules.google.com
Task: Implement reading statistics feature with charts
(Detailed requirements)

# Close browser, go make coffee
```

### During the Day: Use Copilot
```
# In your IDE
Work on other features with Copilot autocomplete
Chat with Copilot for quick questions
Review other PRs with Copilot assistance
```

### Afternoon (3 PM): Jules PR Ready
```
# Notification: Jules finished!
# Review PR on GitHub

# Use Claude Code to refine:
"Review Jules' PR and ensure it follows CLAUDE.md patterns"

# Claude Code makes adjustments
```

### Evening (5 PM): Validate with Zen MCP
```
# In Claude Code terminal
/code-review files=lib/features/statistics/ review_type=full

# Zen MCP validates with Gemini 2.5 Pro
# Reports any issues
```

### Next Morning: Merge!
```
# All checks passed
# Tests passing
# Code reviewed by 3 AIs
# Merge with confidence
```

---

## 💰 Cost Comparison

| Approach | Time | AI Cost | Your Time |
|----------|------|---------|-----------|
| **Manual coding** | 8 hours | $0 | 8 hours |
| **Copilot only** | 4 hours | ~10 requests | 4 hours |
| **Jules only** | 2 hours (AI work) | 1 task | 1 hour review |
| **Jules + Copilot + Zen MCP** | 2 hours (AI) | 1 task + 5 requests + $0.50 | 45 min review |

**Your setup saves:** 7+ hours per feature!

---

## 📊 Monthly Quotas

### What You Have

| Service | Monthly Quota | Value |
|---------|---------------|-------|
| **Google Jules** | 60 tasks/day | ~1,800 tasks/month |
| **GitHub Copilot Plus** | 1,500 premium requests | ~50/day |
| **Zen MCP** | Unlimited | Pay per use (~$2-5/month) |
| **Claude Code** | Unlimited (local Haiku) | Included with Claude Max |

### How to Maximize

**Jules (60 tasks/day):**
- Use for large features (overnight work)
- Use for refactoring (async work)
- Use for test generation
- **Save:** Real-time coding for Copilot

**Copilot (1,500 requests/month):**
- Use for autocomplete (unlimited, free!)
- Use for quick questions
- Use for PR reviews
- **Save:** Deep analysis for Zen MCP

**Zen MCP (pay-per-use):**
- Use for security audits
- Use for architecture decisions
- Use local Haiku for simple tasks (free!)
- **Save:** Routine work for Jules/Copilot

**Claude Code (unlimited Haiku):**
- Use for orchestration
- Use for simple refactoring
- Use as glue between other AIs
- **Save:** Premium models for complex work

---

## 🎓 Jules Pro Tips

### 1. Be Specific About Patterns

**❌ Vague:**
```
Add a new screen for statistics
```

**✅ Specific:**
```
Add a new statistics screen following these patterns:
- Use StatefulShellRoute like lib/core/router/app_router.dart
- Create StatisticsProvider using Riverpod with code generation
- Follow Material Design 3 like lib/shared/widgets/main_scaffold.dart
- Add to bottom navigation like existing screens
```

### 2. Reference Existing Code

```
Implement the bookshelf scanner following the same architecture as:
- lib/features/library/ (screen structure)
- lib/features/search/ (API integration)
- lib/shared/widgets/ (widget patterns)

Match the code style exactly.
```

### 3. Provide Context

```
Fix the author mapping bug in DTOMapper.

Context:
- Issue reported in GitHub issue #42
- Affects the library screen when loading books
- Happens when books share authors
- Root cause likely in lib/core/services/dto_mapper.dart

See CLAUDE.md section 4.2 for our DTOMapper patterns.
```

### 4. Request Audio Summaries

```
[Same task description]

Please provide an audio summary of the changes when done.
```

**Jules will generate:** Audio changelog explaining what changed and why

### 5. Break Down Large Tasks

**Instead of:**
```
Build entire reading statistics feature
```

**Do this:**
```
Phase 1: Create data models and database tables for reading statistics
(Review this PR before Phase 2)
```

Then after review:
```
Phase 2: Build UI using the data models from PR #145
```

---

## 🔧 Troubleshooting

### Jules Task Failed

**Check:**
1. Is the task too vague? → Be more specific
2. Are files too large? → Break into smaller tasks
3. Conflicting with recent changes? → Pull latest from main
4. Tests failing? → Review test setup in the task

### Jules Made Mistakes

**Common issues:**
- Didn't follow project patterns → Reference specific files next time
- Broke tests → Include "ensure all tests pass" in task
- Wrong architecture → Point to CLAUDE.md sections

**Solution:** Review PR, request changes, Jules can iterate

### Hit Daily Limit

**Free tier:** 5 tasks/day
**Gemini Pro:** 60 tasks/day (you have this!)

**If you hit 60:**
- Use Copilot Plus for remaining work
- Save complex tasks for tomorrow
- Use Claude Code + Zen MCP for immediate needs

---

## 📚 Resources

**Google Jules:**
- Access: https://jules.google.com
- Docs: https://jules.google/docs/
- API: https://developers.google.com/jules/api

**Your AI Team:**
- Copilot Guide: [COPILOT_GUIDE.md](./COPILOT_GUIDE.md)
- AI Collaboration: [AI_COLLABORATION.md](./AI_COLLABORATION.md)
- Zen MCP Setup: [../GITHUB_ZEN_SETUP.md](../GITHUB_ZEN_SETUP.md)

---

**Last Updated:** November 12, 2025
**Your Access:** ✅ Google Jules via Gemini Pro (60 tasks/day)
**Recommendation:** Use Jules for overnight work, Copilot for real-time coding

### In Pull Requests

Simply mention `@jules` in any PR comment or review:

```markdown
@jules review this PR for security issues
```

Jules will analyze the PR and respond with findings.

### Common Jules Commands

#### Code Review
```markdown
@jules review this PR
@jules review this PR for security vulnerabilities
@jules review this PR for Flutter best practices
@jules review this PR for performance issues
@jules review this file for potential bugs
```

#### Explanations
```markdown
@jules explain this change
@jules what does this function do?
@jules why was this refactored?
@jules summarize this PR
```

#### Suggestions
```markdown
@jules suggest improvements
@jules suggest performance optimizations
@jules how can I make this more readable?
@jules are there any edge cases I'm missing?
```

#### Flutter/Dart Specific
```markdown
@jules check for Riverpod best practices
@jules review this widget for performance
@jules is this the correct way to use Drift?
@jules suggest Material Design 3 improvements
```

#### Testing
```markdown
@jules what tests should I add?
@jules review test coverage for this change
@jules suggest edge cases to test
```

---

## Jules in Your Workflow

### 1. Before Creating PR

Use Jules to self-review your code:

```bash
# Create PR
gh pr create

# Add comment asking Jules to review
gh pr comment --body "@jules review this PR for Flutter best practices"
```

### 2. During PR Review

Reviewers can use Jules for help:

```markdown
# On any line of code in PR:
@jules is this the best approach for state management?

# In general PR comment:
@jules summarize the changes in this PR
@jules what are the potential risks?
```

### 3. In Issues

Jules can help understand issues:

```markdown
@jules this error is happening when I try to scan books. What could be the cause?
@jules how should we implement this feature?
```

### 4. In Discussions

```markdown
@jules what's the difference between Riverpod and Provider?
@jules should we use Drift or Isar for local database?
```

---

## Jules vs Other AI Tools

You have multiple AI tools available. Here's when to use each:

### Use Jules When:
- ✅ Reviewing PRs on GitHub.com
- ✅ Discussing code in issues/discussions
- ✅ Quick questions about specific code changes
- ✅ Collaborating with team members (Jules responses are visible to all)
- ✅ Need context from entire PR/issue thread

### Use Zen MCP When:
- ✅ Deep code analysis (security audits, architecture review)
- ✅ Complex debugging with multiple models
- ✅ Planning large features
- ✅ Comparing approaches (consensus tool)
- ✅ Need specific models (Gemini 2.5 Pro, Grok 4, etc.)

### Use GitHub Copilot (IDE) When:
- ✅ Writing code (autocomplete)
- ✅ Real-time suggestions as you type
- ✅ Quick refactoring
- ✅ Generating tests
- ✅ Inline explanations

### Use Claude Code (Me!) When:
- ✅ Multi-file changes
- ✅ Project-wide refactoring
- ✅ Following project guidelines (CLAUDE.md)
- ✅ Complex tasks requiring multiple steps
- ✅ Using Zen MCP tools with local Haiku optimization

---

## Jules Best Practices

### 1. Be Specific

❌ Bad:
```markdown
@jules review this
```

✅ Good:
```markdown
@jules review this widget for performance issues and suggest optimizations
```

### 2. Ask Follow-up Questions

Jules maintains context in the conversation:

```markdown
You: @jules review this state management approach
Jules: [provides review]
You: @jules what about using AsyncNotifier instead?
Jules: [compares approaches]
```

### 3. Reference Specific Files

```markdown
@jules review lib/features/scanner/bookshelf_scanner.dart for memory leaks
```

### 4. Use for Learning

```markdown
@jules why is this pattern better than what I had before?
@jules can you explain the trade-offs of this approach?
```

### 5. Combine with Human Review

Jules is an assistant, not a replacement for human review:

```markdown
@jules review this PR
# Then: add human reviewers
gh pr edit --add-reviewer @friend1,@friend2
```

---

## Jules in Automated Workflow

Our `.github/workflows/copilot-review.yml` workflow automatically posts Jules commands on every PR.

**Automated message includes:**
- Files changed count
- Automated checks status
- Jules command suggestions
- Quick reference for Copilot tools

**You can customize** the workflow to automatically invoke Jules:

Add to `.github/workflows/copilot-review.yml`:

```yaml
- name: 🤖 Invoke Jules for automatic review
  uses: actions/github-script@v7
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
    script: |
      // Post comment that invokes Jules
      await github.rest.issues.createComment({
        owner: context.repo.owner,
        repo: context.repo.repo,
        issue_number: context.issue.number,
        body: '@jules review this PR for Flutter best practices, security issues, and performance optimizations'
      });
```

**Note:** This will automatically invoke Jules on every PR. May consume Copilot quota.

---

## Jules Examples for This Project

### Example 1: Review Database Code

```markdown
@jules review lib/core/database/database.dart for:
- SQL injection vulnerabilities
- N+1 query issues
- Proper indexing
- Migration safety
```

### Example 2: Review State Management

```markdown
@jules review lib/features/library/providers/library_provider.dart for:
- Proper Riverpod usage
- Memory leaks
- Stale state issues
- Loading state handling
```

### Example 3: Review UI Performance

```markdown
@jules review lib/shared/widgets/book_card.dart for:
- Unnecessary rebuilds
- Image loading performance
- Widget composition
- Material Design 3 compliance
```

### Example 4: Explain Cloudflare Integration

```markdown
@jules explain how the Cloudflare Workers integration works in this PR
@jules what are the benefits of this approach over a traditional backend?
```

### Example 5: Suggest Test Cases

```markdown
@jules what edge cases should I test for the bookshelf scanner?
@jules suggest unit tests for lib/core/services/dto_mapper.dart
```

---

## Jules Limitations

### What Jules CAN Do:
- ✅ Analyze code in PRs, issues, discussions
- ✅ Reference files in the current PR
- ✅ Maintain conversation context
- ✅ Suggest improvements
- ✅ Explain code
- ✅ Answer Flutter/Dart questions

### What Jules CANNOT Do:
- ❌ Write code directly (use Copilot in IDE)
- ❌ Create commits or modify files
- ❌ Run tests or build code
- ❌ Access your local development environment
- ❌ Remember across different PRs/issues
- ❌ Use external tools (like Zen MCP models)

For these tasks, use:
- **Copilot in IDE** - Writing code, running tests
- **Zen MCP** - Advanced analysis with specific models
- **Claude Code** - Project-wide changes, multi-step tasks

---

## Jules + Zen MCP Workflow

**Optimal workflow combining both:**

1. **Write code** with GitHub Copilot in IDE
2. **Create PR** and ask Jules for initial review:
   ```markdown
   @jules review this PR for obvious issues
   ```
3. **For deeper analysis**, use Zen MCP:
   ```bash
   # In Claude Code
   /code-review files=lib/features/scanner/ review_type=security
   ```
4. **Address Jules + Zen MCP feedback**
5. **Human reviewers** provide final approval
6. **Merge** with confidence

---

## Cost & Quota

**Jules is included** with GitHub Copilot Plus at no extra cost.

**Usage limits:**
- Subject to Copilot Plus fair use policy
- No published hard limits
- If overused, GitHub may rate-limit responses

**Cost optimization:**
- Use Jules for quick questions and PR reviews
- Use Zen MCP (with local Haiku) for complex analysis
- Use Copilot in IDE for code generation
- This balances cost and capability

---

## Tips for Team Members

When your friends review your PRs, remind them about Jules:

```markdown
## Review Notes

Feel free to use **@jules** for help reviewing:

- `@jules summarize this PR` - Quick overview
- `@jules review this PR for Flutter best practices`
- `@jules explain [specific function]`

Also check the automated Copilot review comment for suggestions.
```

---

## Troubleshooting

### Jules Not Responding?

1. **Check spelling:** Must be exactly `@jules` (lowercase)
2. **Copilot Plus active?** Verify at github.com/settings/copilot
3. **In correct location?** Jules works in PRs, issues, discussions (not in code files)
4. **Wait a moment:** Jules may take 10-30 seconds to respond
5. **Check quota:** If heavily used, may be rate-limited

### Jules Gave Incorrect Answer?

Jules is AI-powered and can make mistakes:

1. **Ask for clarification:** `@jules can you explain that differently?`
2. **Be more specific:** Provide more context
3. **Verify with Zen MCP:** Use specialized models for critical decisions
4. **Human review:** Always have humans verify important changes

### Jules Doesn't Know Project Context?

Jules only sees the current PR/issue, not your entire codebase:

1. **Reference files explicitly:** `@jules look at lib/core/database/database.dart`
2. **Provide context:** Explain project patterns
3. **Use CLAUDE.md:** Project guidelines help Jules understand conventions
4. **Link related issues:** Help Jules understand background

---

## Quick Reference

### Most Useful Jules Commands

```markdown
# General review
@jules review this PR

# Specific focus
@jules review for security issues
@jules review for performance
@jules review for Flutter best practices

# Explanations
@jules explain this change
@jules summarize this PR

# Suggestions
@jules suggest improvements
@jules what edge cases am I missing?

# Testing
@jules what should I test?
@jules review test coverage
```

---

## Next Steps

1. **Try Jules** on your next PR:
   ```bash
   gh pr create
   gh pr comment --body "@jules review this PR"
   ```

2. **Experiment** with different commands

3. **Share** Jules tips with your team

4. **Combine** with Zen MCP for comprehensive review:
   - Jules for quick checks
   - Zen MCP for deep analysis

---

**Last Updated:** November 12, 2025
**Your Plan:** GitHub Copilot Plus (includes Jules)
**Documentation:** https://docs.github.com/copilot/using-github-copilot/copilot-chat-in-github
