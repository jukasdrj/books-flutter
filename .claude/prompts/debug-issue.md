# Debug Issue with PAL MCP

Use the PAL MCP `debug` tool for systematic debugging with hypothesis testing and expert AI analysis.

## Instructions

Debug the following issue:

**Issue Description:**
{{issue_description}}

**Steps to Reproduce:**
{{steps}}

**Expected Behavior:**
{{expected}}

**Actual Behavior:**
{{actual}}

**Affected Files:**
{{files}}

**Platform:**
{{platform}}

Use Gemini 2.5 Pro or DeepSeek V3 for debugging analysis.

## Example Usage

```
/debug-issue \
  issue_description="DTOMapper returns wrong authors for books" \
  files=lib/core/services/dto_mapper.dart \
  platform=all
```

## Expected Output

- Root cause analysis
- Hypothesis testing results
- Fix recommendations with code examples
- Test cases to prevent regression
