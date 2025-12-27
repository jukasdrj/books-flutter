# Code Review with PAL MCP

Use the PAL MCP `codereview` tool to perform comprehensive code review with expert AI validation.

## Instructions

Review the following files with focus on:

{{files}}

**Focus Areas:**
- Code quality and maintainability
- Performance optimization opportunities
- Security vulnerabilities
- Flutter best practices
- Material Design 3 compliance
- Riverpod state management patterns
- Drift database query optimization

**Review Type:** {{review_type}}

Use Gemini 2.5 Pro or Claude Opus 4 for expert validation.

## Example Usage

```
/code-review files=lib/core/database/database.dart review_type=full
```

## Expected Output

- Security issues (OWASP Top 10)
- Performance bottlenecks
- Code smells and anti-patterns
- Architecture violations
- Recommendations with priority levels
