#!/bin/bash

# Flutter Post-Tool-Use Hook
# Suggests appropriate agents based on tool usage patterns

TOOL_NAME="${CLAUDE_TOOL_NAME:-}"
FILES_CHANGED="${CLAUDE_FILES_CHANGED:-}"

# Colors for output
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

INVOKE_AGENT=""
AGENT_CONTEXT=""

# Detect Flutter-specific triggers
if [[ "$TOOL_NAME" == "Bash" ]]; then
  # Flutter commands → flutter-agent
  if echo "$CLAUDE_TOOL_INPUT" | grep -qE "flutter (build|run|test|pub|analyze)"; then
    INVOKE_AGENT="flutter-agent"
    AGENT_CONTEXT="Flutter command detected"
  fi

  # Build runner commands → flutter-agent
  if echo "$CLAUDE_TOOL_INPUT" | grep -q "dart run build_runner"; then
    INVOKE_AGENT="flutter-agent"
    AGENT_CONTEXT="Code generation command detected"
  fi

  # Firebase commands → flutter-agent
  if echo "$CLAUDE_TOOL_INPUT" | grep -q "firebase deploy"; then
    INVOKE_AGENT="flutter-agent"
    AGENT_CONTEXT="Firebase deployment detected"
  fi
fi

# Detect file edit patterns
if [[ "$TOOL_NAME" == "Edit" || "$TOOL_NAME" == "Write" || "$TOOL_NAME" == "MultiEdit" ]]; then
  # Dart files → Consider code review
  if echo "$FILES_CHANGED" | grep -qE "\.dart$"; then
    # Check if it's a provider or database file (requires code generation)
    if echo "$FILES_CHANGED" | grep -qE "(provider|database|drift|riverpod)"; then
      INVOKE_AGENT="flutter-agent"
      AGENT_CONTEXT="Riverpod/Drift file changed - code generation likely needed"
    fi
  fi

  # pubspec.yaml changes → flutter-agent
  if echo "$FILES_CHANGED" | grep -q "pubspec.yaml"; then
    INVOKE_AGENT="flutter-agent"
    AGENT_CONTEXT="pubspec.yaml changed - run pub get and code generation"
  fi

  # Firebase rules or config → zen-mcp-master
  if echo "$FILES_CHANGED" | grep -qE "(firestore.rules|firebase.json|storage.rules)"; then
    INVOKE_AGENT="zen-mcp-master"
    AGENT_CONTEXT="Firebase configuration changed - security review recommended"
  fi

  # Multiple file changes → project-manager
  if [[ "$TOOL_NAME" == "MultiEdit" ]]; then
    FILE_COUNT=$(echo "$FILES_CHANGED" | wc -l | tr -d ' ')
    if [ "$FILE_COUNT" -gt 5 ]; then
      INVOKE_AGENT="project-manager"
      AGENT_CONTEXT="Multiple files changed ($FILE_COUNT files)"
    fi
  fi
fi

# Output suggestion if agent identified
if [ -n "$INVOKE_AGENT" ]; then
  echo ""
  echo -e "${CYAN}💡 Agent Suggestion${NC}"
  echo -e "   ${YELLOW}Context:${NC} $AGENT_CONTEXT"
  echo -e "   ${YELLOW}Suggested:${NC} /skill $INVOKE_AGENT"
  echo ""
fi

exit 0
