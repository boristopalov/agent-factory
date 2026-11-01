#!/bin/sh
# Bootstrap a repo for the agent loop in one command:
#   - copies the agent files (.claude/agents) and, if missing, factory.yaml
#   - adds the Claude review caller workflow, if missing
#   - sets the CLAUDE_CODE_OAUTH_TOKEN secret from your environment, if set
# Usage: CLAUDE_CODE_OAUTH_TOKEN=... ./install.sh /path/to/repo
set -eu
target="$(cd "${1:?usage: ./install.sh /path/to/repo}" && pwd)"
here="$(cd "$(dirname "$0")" && pwd)"
todo=""

if [ "$target" != "$here" ]; then
  mkdir -p "$target/.claude/agents"
  cp "$here"/.claude/agents/*.md "$target/.claude/agents/"
  echo "Copied agents into $target/.claude/agents"
  if [ -e "$target/factory.yaml" ]; then
    echo "Kept the existing factory.yaml"
  else
    cp "$here/factory.yaml" "$target/factory.yaml"
    todo="$todo
- Edit factory.yaml's queue: line to point at this repo's Linear project."
  fi
fi

wf="$target/.github/workflows/claude-review.yml"
if [ -e "$wf" ]; then
  echo "Kept the existing .github/workflows/claude-review.yml"
else
  mkdir -p "$(dirname "$wf")"
  cp "$here/templates/claude-review.yml" "$wf"
  echo "Added .github/workflows/claude-review.yml"
fi

if [ -n "${CLAUDE_CODE_OAUTH_TOKEN:-}" ]; then
  if (cd "$target" && printf %s "$CLAUDE_CODE_OAUTH_TOKEN" | gh secret set CLAUDE_CODE_OAUTH_TOKEN); then
    echo "Set the CLAUDE_CODE_OAUTH_TOKEN secret"
  else
    todo="$todo
- Setting the secret failed (is gh logged in, and does the repo have a GitHub remote?). Set CLAUDE_CODE_OAUTH_TOKEN by hand."
  fi
else
  todo="$todo
- Set the review secret: run 'claude setup-token', then rerun with CLAUDE_CODE_OAUTH_TOKEN set."
fi

echo "
Left to do:
- Commit and push the new files. Reviews start on PRs opened after the workflow is on the default branch.$todo"
