#!/usr/bin/env bash
# Claude Code Status Line — single line, left/right layout
# Dependencies: jq, git
# Input: JSON from stdin (Claude Code status line protocol)

set -euo pipefail

# ── Colors ──
RST='\033[0m'
BOLD='\033[1m'
DIM='\033[2m'
RED='\033[31m'
GREEN='\033[32m'
YELLOW='\033[33m'
MAGENTA='\033[35m'
CYAN='\033[36m'

# ── Read JSON input ──
INPUT=$(cat)

# ── Extract fields with null-safe defaults ──
MODEL=$(echo "$INPUT" | jq -r '.model.display_name // ""')
CWD=$(echo "$INPUT" | jq -r '.workspace.current_dir // ""')
USED_PCT=$(echo "$INPUT" | jq -r '.context_window.used_percentage // 0')
COST=$(echo "$INPUT" | jq -r '.cost.total_cost_usd // 0')
DURATION_MS=$(echo "$INPUT" | jq -r '.cost.total_duration_ms // 0')
LINES_ADDED=$(echo "$INPUT" | jq -r '.cost.total_lines_added // 0')
LINES_REMOVED=$(echo "$INPUT" | jq -r '.cost.total_lines_removed // 0')

DIR=$(basename "$CWD" 2>/dev/null || echo "")

# ── Git info (cached 5s) ──
CACHE_FILE="/tmp/claude-statusline-git-cache"
CACHE_TTL=5
BRANCH="" AHEAD=0 BEHIND=0 STAGED=0 MODIFIED=0

refresh_git() {
  [ -z "$CWD" ] && return
  cd "$CWD" 2>/dev/null || return

  BRANCH=$(git -c core.useBuiltinFSMonitor=false rev-parse --abbrev-ref HEAD 2>/dev/null || echo "")
  [ -z "$BRANCH" ] && return

  local upstream
  upstream=$(git rev-parse --abbrev-ref '@{upstream}' 2>/dev/null || echo "")
  if [ -n "$upstream" ]; then
    local counts
    counts=$(git rev-list --left-right --count HEAD..."$upstream" 2>/dev/null || echo "0	0")
    AHEAD=$(echo "$counts" | cut -f1)
    BEHIND=$(echo "$counts" | cut -f2)
  fi

  STAGED=$(git diff --cached --numstat 2>/dev/null | wc -l | tr -d ' ')
  MODIFIED=$(git diff --numstat 2>/dev/null | wc -l | tr -d ' ')

  echo "${BRANCH}|${AHEAD}|${BEHIND}|${STAGED}|${MODIFIED}" > "$CACHE_FILE"
}

if [ -n "$CWD" ]; then
  if [ -f "$CACHE_FILE" ] && [ "$(( $(date +%s) - $(stat -f %m "$CACHE_FILE" 2>/dev/null || stat -c %Y "$CACHE_FILE" 2>/dev/null || echo 0) ))" -lt "$CACHE_TTL" ]; then
    IFS='|' read -r BRANCH AHEAD BEHIND STAGED MODIFIED < "$CACHE_FILE"
  else
    refresh_git
  fi
fi

# ── LEFT: Model + Dir + Git ──
LEFT=""

if [ -n "$MODEL" ]; then
  LEFT+=$(printf "${BOLD}${MAGENTA}%s${RST}" "$MODEL")
fi

if [ -n "$DIR" ]; then
  LEFT+=$(printf "  ${BOLD}${CYAN}%s${RST}" "$DIR")
fi

if [ -n "$BRANCH" ]; then
  LEFT+=$(printf "  ${GREEN}%s${RST}" "$BRANCH")
  [ "$AHEAD" -gt 0 ] 2>/dev/null && LEFT+=$(printf " ${GREEN}↑%s${RST}" "$AHEAD")
  [ "$BEHIND" -gt 0 ] 2>/dev/null && LEFT+=$(printf " ${RED}↓%s${RST}" "$BEHIND")
  [ "$STAGED" -gt 0 ] 2>/dev/null && LEFT+=$(printf " ${GREEN}+%s${RST}" "$STAGED")
  [ "$MODIFIED" -gt 0 ] 2>/dev/null && LEFT+=$(printf " ${YELLOW}~%s${RST}" "$MODIFIED")
fi

# ── RIGHT: Context bar + Cost + Lines + Duration ──
RIGHT=""

# Context bar
BAR_WIDTH=10
FILLED=$(( USED_PCT * BAR_WIDTH / 100 ))
EMPTY=$(( BAR_WIDTH - FILLED ))

if [ "$USED_PCT" -ge 90 ]; then
  BAR_COLOR="$RED"
elif [ "$USED_PCT" -ge 70 ]; then
  BAR_COLOR="$YELLOW"
else
  BAR_COLOR="$GREEN"
fi

BAR=""
for ((i=0; i<FILLED; i++)); do BAR+="█"; done
for ((i=0; i<EMPTY; i++)); do BAR+="░"; done

RIGHT+=$(printf "${BAR_COLOR}%s${RST} ${BAR_COLOR}%s%%${RST}" "$BAR" "$USED_PCT")

# Cost
if [ "$(echo "$COST > 0" | bc 2>/dev/null || echo 0)" = "1" ]; then
  COST_FMT=$(printf '%.2f' "$COST")
  RIGHT+=$(printf " ${DIM}│${RST} ${YELLOW}\$%s${RST}" "$COST_FMT")
fi

# Lines +/-
if [ "$LINES_ADDED" -gt 0 ] 2>/dev/null || [ "$LINES_REMOVED" -gt 0 ] 2>/dev/null; then
  RIGHT+=$(printf " ${DIM}│${RST}")
  [ "$LINES_ADDED" -gt 0 ] 2>/dev/null && RIGHT+=$(printf " ${GREEN}+%s${RST}" "$LINES_ADDED")
  [ "$LINES_REMOVED" -gt 0 ] 2>/dev/null && RIGHT+=$(printf " ${RED}-%s${RST}" "$LINES_REMOVED")
fi

# Duration
if [ "$DURATION_MS" -gt 0 ] 2>/dev/null; then
  TOTAL_SECS=$(( DURATION_MS / 1000 ))
  MINS=$(( TOTAL_SECS / 60 ))
  SECS=$(( TOTAL_SECS % 60 ))
  if [ "$MINS" -gt 0 ]; then
    DUR_FMT="${MINS}m ${SECS}s"
  else
    DUR_FMT="${SECS}s"
  fi
  RIGHT+=$(printf " ${DIM}│ %s${RST}" "$DUR_FMT")
fi

# ── Output: single line, left ··· right ──
printf "%s  ${DIM}│${RST}  %s" "$LEFT" "$RIGHT"
