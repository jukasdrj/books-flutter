# Plan Feature with PAL MCP

Use the PAL MCP `planner` tool for interactive, sequential planning of complex features with expert AI validation.

## Instructions

Plan the following feature:

**Feature:** {{feature_name}}

**Description:** {{description}}

**Requirements:**
{{requirements}}

**Phase:** {{phase}}

**Estimated Effort:** {{effort}}

Use Claude Opus 4 or GPT-5 Pro for architecture planning.

## Example Usage

```
/plan-feature \
  feature_name="AI Bookshelf Scanner" \
  phase="Phase 3" \
  effort="3 weeks"
```

## Expected Output

- Detailed implementation plan
- Component breakdown
- Database schema changes
- UI/UX considerations
- API integration requirements
- Testing strategy
- Risk assessment
- Timeline with milestones
