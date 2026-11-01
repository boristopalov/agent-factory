#!/bin/sh
# Copy the agent definitions and factory.yaml into another repo.
# Usage: ./install.sh /path/to/repo
set -eu
target="${1:?usage: ./install.sh /path/to/repo}"
here="$(cd "$(dirname "$0")" && pwd)"
mkdir -p "$target/.claude/agents"
cp "$here"/.claude/agents/*.md "$target/.claude/agents/"
cp "$here/factory.yaml" "$target/factory.yaml"
echo "Copied $(ls "$here"/.claude/agents/*.md | wc -l | tr -d ' ') agents and factory.yaml into $target"
