# agent-factory

Our coding agents and the loop between them, as versioned files. Inspired by Warp's [open infrastructure for building a software factory](https://www.warp.dev/blog/open-infrastructure-for-building-a-software-factory). Deliberately lean: we tune it as we learn.

## What's here

- `.claude/agents/*.md`: one file per role, in Claude Code's subagent format (frontmatter: `name`, `description`, `tools`, `model`; body: the prompt).
  - `triage`: decides implement, spec or wait. Read-only.
  - `implement`: makes the change and opens a PR. Never merges.
  - `review`: reviews a PR diff and ranks findings by severity with file:line. Read-only; never approves.
  - `test`: adds tests toward the coverage gate. Never weakens tests or thresholds.
  - `benchmark`: measures a change against its base, by hand, never in CI.
- `factory.yaml`: the stages, their triggers and handoffs, and the merge gates. Each stage and gate says whether a real workflow enforces it (`enforced_by`) or a person or session starts it (`manual`).
- `install.sh`: copies the agents and `factory.yaml` into another repo.

Repo-specific knowledge (architecture, comment policy, how to run tests) stays in each repo's `CLAUDE.md` or `CONTRIBUTING.md`; every agent reads those first.

## Using it in a repo

```sh
./install.sh ../cmudb
```

Claude Code picks the agents up from `.claude/agents/`. In a session, ask for one by name ("use the review agent on PR 6"), or start a session as one:

```sh
claude --agent implement
```

In GitHub Actions, `anthropics/claude-code-action` loads the same file:

```yaml
- uses: anthropics/claude-code-action@v1
  with:
    claude_code_oauth_token: ${{ secrets.CLAUDE_CODE_OAUTH_TOKEN }}
    prompt: |
      REPO: ${{ github.repository }}
      PR NUMBER: ${{ github.event.pull_request.number }}
      Review this pull request.
    claude_args: --agent review --max-turns 30 --allowedTools "mcp__github_inline_comment__create_inline_comment,Bash(gh pr comment:*),Bash(gh pr diff:*),Bash(gh pr view:*),Read,Grep,Glob"
```

The Action reads the agent from the checked-out PR branch, so a PR can change its own reviewer's prompt. That's fine for a solo repo where only you open PRs (fork PRs get no secrets, so they're not reviewed).

## Changing an agent

Edit it here, then rerun `install.sh` in each repo that uses it. Check the agents still parse with `claude agents` from the target repo.
