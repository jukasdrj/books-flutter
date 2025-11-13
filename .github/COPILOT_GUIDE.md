# GitHub Copilot Guide
**Your Copilot Plus Plan - Features & Usage**

Based on the latest 2025 information, here's everything you can do with your GitHub Copilot Plus (Pro+) plan.

---

## 📊 Copilot Plans Comparison (2025)

| Feature | Free | Pro ($10/mo) | **Pro+ ($39/mo)** ← You Have This | Business | Enterprise |
|---------|------|--------------|-----------------------------------|----------|------------|
| **Premium Requests/Month** | 50 | 300 | **1,500** | 500 | Unlimited |
| **Code Completions** | ✅ | ✅ | ✅ | ✅ | ✅ |
| **Copilot Chat** | ✅ Limited | ✅ | ✅ | ✅ | ✅ |
| **Model Selection** | ❌ | Limited | **✅ All Models** | Limited | ✅ All Models |
| **Claude Opus 4** | ❌ | ❌ | **✅** | ❌ | ✅ |
| **OpenAI o3** | ❌ | ❌ | **✅** | ❌ | ✅ |
| **GPT-4.5** | ❌ | ❌ | **✅** | ❌ | ✅ |
| **OpenAI Codex** | ❌ | ❌ | **✅** | ❌ | ✅ |
| **Jules (@jules)** | ❌ | ❌ | **✅** | ✅ | ✅ |
| **Copilot Workspace** | ❌ | ✅ Limited | **✅ Full** | ✅ | ✅ |
| **Multi-file Edits** | ❌ | ✅ | **✅ Enhanced** | ✅ | ✅ |
| **Code Reviews** | ❌ | ✅ | **✅ Advanced** | ✅ | ✅ |
| **Priority Support** | ❌ | ❌ | **✅** | ✅ | ✅ |

**Extra requests cost:** $0.04 per premium request after quota

---

## 🎯 What You Get with Copilot Plus (Pro+)

### 1. **Premium Requests: 1,500/month**

**What counts as a premium request:**
- Copilot Chat conversations
- Agent mode (multi-file edits)
- Jules (@jules) interactions
- Code reviews
- Model selection (using specific models)

**What's FREE (doesn't count):**
- Code completions (autocomplete) - **unlimited**
- Inline suggestions - **unlimited**

**Your quota:** 1,500 requests = ~50 requests/day
- Enough for heavy daily use
- Monitor at: github.com/settings/copilot

### 2. **Access to Latest AI Models**

**Available models in your IDE:**
- **Claude Opus 4** - Best for complex reasoning
- **OpenAI o3** - Latest reasoning model
- **GPT-4.5** - Advanced code generation
- **OpenAI Codex** - Specialized coding model
- **Gemini 2.5 Pro** - Google's latest
- **Claude Sonnet 4** - Balanced performance

**How to select model:**
```
In VSCode:
1. Open Copilot Chat
2. Click model dropdown (top of chat)
3. Select your preferred model

Or in chat:
@workspace /model claude-opus-4
```

### 3. **Jules - AI Assistant on GitHub**

**Where:** Pull requests, issues, discussions on GitHub.com

**Usage:**
```markdown
# In any PR comment
@jules review this PR for security issues
@jules explain this change
@jules suggest improvements
```

**Quota:** Included in your 1,500 premium requests

See: [JULES_GUIDE.md](./JULES_GUIDE.md) for detailed usage

### 4. **Copilot Workspace** (Full Access)

**What is it:** AI-powered development environment for complex tasks

**Access:** github.com/copilot/workspace

**Features:**
- Multi-file editing across entire project
- Natural language task descriptions
- Automated PR creation
- Context-aware code generation

**Example:**
```
Task: "Add reading statistics feature with charts showing books read per month"

Copilot Workspace will:
1. Analyze your codebase
2. Plan the implementation
3. Generate code across multiple files
4. Create a PR with all changes
```

**Your plan:** Full access (Pro/Free have limited sessions)

### 5. **Advanced Code Reviews**

**In PR:** Full codebase context, not just changed files

**Usage:**
```markdown
# Automatic in workflows
# Or invoke manually:
@jules review this PR with full codebase context
```

**Your plan:** See entire project, not just PR diff

### 6. **Multi-File Agent Mode**

**In IDE Chat:**
```
@workspace refactor the authentication flow to use the new Firebase API

# Copilot will edit multiple files:
- lib/core/auth/auth_service.dart
- lib/features/login/login_screen.dart
- lib/features/signup/signup_screen.dart
- etc.
```

**Your plan:** Enhanced with more context and better model selection

### 7. **Priority Model Access**

**What you get:**
- First access to new model releases
- Beta features before public release
- Latest model updates

**Recent additions (2025):**
- GPT-4.5 (Pro+ exclusive at launch)
- Claude Opus 4
- OpenAI o3 reasoning model

---

## 🚀 How to Use Your Copilot Plus Features

### In Your IDE (VSCode, Cursor, etc.)

#### 1. Code Completions (Unlimited, Free)

**What:** Autocomplete as you type

**How:**
- Just start typing
- Press Tab to accept suggestion
- Press Alt+[ or Alt+] to cycle suggestions

**Example:**
```dart
// Type: "Future<List<Book>> fetchBooks"
// Copilot suggests entire function implementation
Future<List<Book>> fetchBooksFromAPI(String query) async {
  final response = await dio.get('/api/search', queryParameters: {'q': query});
  return (response.data as List).map((json) => Book.fromJson(json)).toList();
}
```

**Cost:** FREE (doesn't use premium requests)

#### 2. Copilot Chat (Uses Premium Requests)

**Open Chat:**
- VSCode: `Cmd+Shift+I` (Mac) or `Ctrl+Shift+I` (Windows)
- Or click Copilot icon in sidebar

**Ask anything:**
```
How do I implement pagination with Drift?
Review this code for performance issues
Generate unit tests for this function
Explain what this regex does
```

**Model selection:**
```
@workspace /model claude-opus-4
Now using Claude Opus 4 for complex reasoning
```

**Cost:** ~1 premium request per conversation

#### 3. Multi-File Edits (Uses Premium Requests)

**Invoke agent mode:**
```
@workspace refactor the entire scanner feature to use the new API
@workspace add error handling to all network requests
@workspace update all DTOs to match the new schema
```

**Copilot will:**
1. Analyze relevant files
2. Propose changes across multiple files
3. Show preview of all changes
4. Apply when you approve

**Cost:** ~2-5 premium requests depending on complexity

#### 4. Code Reviews in IDE

**Select code → Right click → Copilot → Review**

Or in chat:
```
Review the selected code for:
- Security vulnerabilities
- Performance issues
- Best practices violations
```

**With your Pro+ plan:** Uses advanced models and full codebase context

**Cost:** ~1-2 premium requests

#### 5. Generate Tests

**Select function → Copilot Chat:**
```
Generate comprehensive unit tests for this function including edge cases
```

Or use slash command:
```
/tests
```

**Copilot will generate:**
- Test setup/teardown
- Happy path tests
- Edge cases
- Error scenarios

**Cost:** ~1 premium request

### On GitHub.com

#### 1. Jules in Pull Requests

**In PR comment or review:**
```markdown
@jules review this PR for Flutter best practices

@jules what are the potential risks of this change?

@jules suggest performance improvements
```

**Jules will:**
- Analyze the PR
- Review code changes
- Suggest improvements
- Answer questions

**Cost:** ~1 premium request per Jules interaction

See: [JULES_GUIDE.md](./JULES_GUIDE.md)

#### 2. Copilot Workspace

**Access:** github.com/copilot/workspace

**Start a task:**
```
Create a new reading statistics feature that shows:
- Books read per month (chart)
- Favorite genres (pie chart)
- Reading streak (days)
- Export to CSV functionality
```

**Copilot Workspace will:**
1. Ask clarifying questions
2. Plan the implementation
3. Generate code for all necessary files
4. Create a PR

**Cost:** ~5-10 premium requests for complex tasks

#### 3. GitHub Issues

**Invoke Copilot:**
```markdown
@copilot suggest implementation approaches for this feature

@copilot what tests should we add?

@copilot estimate complexity
```

**Cost:** ~1 premium request per interaction

---

## 💡 Best Practices for Your Pro+ Plan

### 1. Use Model Selection Wisely

**Simple tasks** (autocomplete, basic questions):
- Use default model
- **Cost:** Free (completions) or 1 request (chat)

**Complex reasoning** (architecture, design decisions):
```
@workspace /model claude-opus-4
[Ask your complex question]
```
- **Cost:** 1-2 premium requests, but better quality

**Code generation** (specialized):
```
@workspace /model openai-codex
Generate optimized algorithm for...
```
- **Cost:** 1-2 premium requests

### 2. Combine with Zen MCP

**Use Copilot Plus for:**
- Real-time coding (autocomplete)
- Quick questions in IDE
- Multi-file refactoring
- PR reviews with Jules

**Use Zen MCP for:**
- Deep security audits (gemini-2.5-pro)
- Architecture decisions (o3-pro via OpenRouter)
- Complex debugging (thinkdeep tool)
- Multi-model consensus

**Why both?**
- Copilot Plus: Integrated workflow, fast, GitHub native
- Zen MCP: More model control, cost optimization, specialized tools

### 3. Monitor Your Quota

**Check usage:**
```
github.com/settings/copilot
```

**Track monthly:**
- Premium requests used: X / 1,500
- Extra requests: $0.04 each

**Optimization:**
- Use autocomplete (free) when possible
- Batch questions in one chat session
- Use Zen MCP for deep analysis (cheaper)

### 4. Leverage Jules for Team Collaboration

**Jules responses are public** - great for team reviews:

```markdown
# You invoke Jules
@jules review this PR for security issues

# Jules responds publicly
# Your team sees the review
# Everyone benefits from AI insights
```

**Better than:** Using Copilot Chat privately (team doesn't see)

---

## 📊 Cost Comparison: Copilot Plus vs Zen MCP

| Use Case | Copilot Plus | Zen MCP | Recommendation |
|----------|--------------|---------|----------------|
| Code autocomplete | FREE | N/A | **Use Copilot** |
| Quick questions | ~1 request | ~$0.01-0.10 | **Use Copilot** |
| PR reviews | ~1-2 requests | ~$0.10-0.50 | **Use Jules (Copilot)** |
| Multi-file edits | ~2-5 requests | ~$0.50-1.00 | **Use Copilot Workspace** |
| Security audits | ~5-10 requests | ~$0.50 (gemini-2.5-pro) | **Use Zen MCP** (cheaper) |
| Complex debugging | ~10-20 requests | ~$1-2 (thinkdeep) | **Use Zen MCP** (specialized) |
| Architecture planning | ~10-20 requests | ~$1-2 (planner, consensus) | **Use Zen MCP** (multi-model) |

**Your optimal strategy:**
1. **Copilot Plus** for coding workflow (autocomplete, chat, PR reviews)
2. **Zen MCP** for deep analysis (security, architecture, debugging)
3. **Jules** for team collaboration on PRs
4. **Claude Code** as orchestrator (combines both!)

**Monthly cost:**
- Copilot Plus: $39 (fixed)
- Zen MCP: ~$2-5 (optimized with Haiku)
- Total: ~$41-44/month

**Value:** $5000+ in productivity

---

## 🎓 Advanced Copilot Plus Features

### 1. Copilot CLI (Terminal)

**Install:**
```bash
gh extension install github/gh-copilot
```

**Usage:**
```bash
# Explain commands
gh copilot explain "git rebase -i HEAD~5"

# Suggest commands
gh copilot suggest "undo last commit"

# Answer questions
gh copilot ask "how do I deploy to Cloudflare Workers?"
```

**Cost:** Uses premium requests (~1 per command)

### 2. Copilot in GitHub Actions

**In workflows:**
```yaml
- name: Review with Copilot
  uses: github/copilot-code-review@v1
  with:
    github-token: ${{ secrets.GITHUB_TOKEN }}
```

**Your workflows already use this!** See `.github/workflows/copilot-review.yml`

### 3. Fine-tuning (Enterprise only)

**Not available in Pro+**, but you can:
- Use custom instructions
- Reference `CLAUDE.md` for context
- Provide examples in chat

### 4. Copilot Extensions

**Coming soon:** Custom extensions for Copilot

**Example use cases:**
- Integrate with Jira/Linear
- Custom linting rules
- Company-specific patterns

---

## ⚠️ Limitations of Copilot Plus

### What Copilot Plus Can't Do

**❌ Multi-model orchestration**
- Can only use one model at a time
- Can't run consensus between models
- **Solution:** Use Zen MCP consensus tool

**❌ Custom workflows**
- No planner, thinkdeep, debug tools
- Limited to chat/completion/review
- **Solution:** Use Zen MCP specialized tools

**❌ Cost optimization for heavy analysis**
- Complex tasks use many premium requests
- No "use cheaper model for simple parts"
- **Solution:** Use Zen MCP with Haiku for simple tasks

**❌ Deep security audits**
- Good for basic reviews
- Not specialized for OWASP Top 10
- **Solution:** Use Zen MCP secaudit tool

**❌ Local model support**
- All models are cloud-based
- Can't use Ollama/local models
- **Solution:** Zen MCP can integrate with local models

### What You Should Use Zen MCP For Instead

See: [AI_COLLABORATION.md](./AI_COLLABORATION.md) for full comparison

---

## 🔧 Setup & Configuration

### 1. Install Copilot in Your IDE

**VSCode:**
```
1. Install "GitHub Copilot" extension
2. Install "GitHub Copilot Chat" extension
3. Sign in with GitHub account
4. Verify Pro+ plan: Cmd+Shift+P → "Copilot: Check Status"
```

**Cursor:**
```
Already includes Copilot
Just sign in with GitHub
```

**JetBrains (IntelliJ, etc.):**
```
Settings → Plugins → Install "GitHub Copilot"
Sign in with GitHub
```

### 2. Configure Model Preferences

**VSCode Settings:**
```json
{
  "github.copilot.editor.enableAutoCompletions": true,
  "github.copilot.chat.defaultModel": "claude-opus-4",
  "github.copilot.chat.welcomeMessage": "show"
}
```

### 3. Enable All Features

**Settings:**
- ✅ Code completions
- ✅ Chat
- ✅ Inline chat (Cmd+I)
- ✅ Agent mode (@workspace)
- ✅ Multi-file edits

---

## 📚 Resources

**Official Docs:**
- GitHub Copilot: https://docs.github.com/copilot
- Copilot Chat: https://docs.github.com/copilot/using-github-copilot/using-copilot-chat
- Copilot Workspace: https://githubnext.com/projects/copilot-workspace

**Your Guides:**
- [JULES_GUIDE.md](./JULES_GUIDE.md) - Using @jules
- [AI_COLLABORATION.md](./AI_COLLABORATION.md) - AI-to-AI communication
- [GITHUB_ZEN_SETUP.md](../GITHUB_ZEN_SETUP.md) - Zen MCP integration

**Monitor Usage:**
- Quota: https://github.com/settings/copilot
- Billing: https://github.com/settings/billing

---

## 🎯 Quick Reference

### Common Copilot Commands

**In IDE Chat:**
```
/explain - Explain code
/tests - Generate tests
/fix - Fix bugs
/doc - Generate documentation
/model - Change AI model
```

**With @workspace:**
```
@workspace refactor this entire feature
@workspace add error handling everywhere
@workspace review security across the project
```

**On GitHub:**
```markdown
@jules review this PR
@copilot suggest implementation
```

### Keyboard Shortcuts (VSCode)

```
Cmd+I         - Inline chat
Cmd+Shift+I   - Open Copilot Chat
Tab           - Accept suggestion
Esc           - Dismiss suggestion
Alt+[         - Previous suggestion
Alt+]         - Next suggestion
```

---

**Last Updated:** November 12, 2025
**Your Plan:** GitHub Copilot Plus (Pro+) - $39/month
**Premium Requests:** 1,500/month + $0.04 per extra
**Best Used With:** Zen MCP for deep analysis, Jules for team reviews
