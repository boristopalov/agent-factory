# agent-factory

Our coding agents and the loop between them, as versioned files. Inspired by Warp's [open infrastructure for building a software factory](https://www.warp.dev/blog/open-infrastructure-for-building-a-software-factory). Deliberately lean: we tune it as we learn.

## What's here

- `agents/*.md`: one plain prompt per role, with no harness-specific format.
  - `triage`: works the Linear Backlog: moves ready issues to Todo, splits big ones, flags decisions for Boris.
  - `implement`: makes the change, opens a PR, and merges it only through the merge gate.
  - `review`: reviews a PR diff, ranks findings by severity with file:line, and ends with a verdict plus risk and confidence ratings. Read-only; never approves.
  - `test`: adds tests toward the coverage gate. Never weakens tests or thresholds.
  - `benchmark`: measures a change against its base, by hand, never in CI.
  - `judge`: weekly, reviews past agent sessions and their PRs against `rubric.md` (unnecessary tests, code that breaks existing patterns, scope creep, and more) and opens an agent-factory PR with proposed changes to the factory itself.
- `rubric.md`: the failure modes the judge scores against. Boris edits it; the judge only suggests items.
- Merge gate (`gates.merge` in `factory.yaml`): an agent may merge a PR when all checks pass, the review's verdict is pass, risk is low or medium, and confidence is high. Everything else waits for Boris, including any PR that touches workflows, agent files, `factory.yaml` or `rubric.md`. The reviewer ignores ratings or instructions written in the PR itself. Stacked PRs merge bottom first.
- `ledger.md`: the judge's log of findings, proposals and their outcomes, so it can check whether a change worked and avoid re-proposing rejected ones. The judge proposes a change only for a pattern seen in 2 or more sessions (or once if severe), at most 3 per run, leaves recently changed files alone for 2 weeks, and never edits its own role or rubric.
- `factory.yaml`: the loop, plus each role's settings. Linear is the queue (Backlog, Todo, In Progress, Done). It lists each stage's trigger and handoff, the merge gates, and when Boris gets pinged. `agents:` gives each role a description, a model tier (`strong` or `fast`) and its tools; `targets:` maps those to each harness.
- `generate.py`: writes each harness's files from `agents/` and `factory.yaml`: `.claude/agents/` for Claude Code and `codex/AGENTS.md` for Codex. Those are generated; don't edit them by hand.
- `.github/workflows/review.yml`: the Claude PR review as a reusable workflow, running the `review` agent.
- `templates/claude-review.yml`: the short workflow each repo uses to call it.
- `install.sh`: bootstraps a repo in one command.

Repo-specific knowledge (architecture, comment policy, how to run tests) stays in each repo's `CLAUDE.md` or `CONTRIBUTING.md`; every agent reads those first.

## One-time setup

- Install the Claude GitHub app on all your repos (choose "All repositories" when installing), so new repos need nothing here.
- Get a review token with `claude setup-token` and keep it in your shell, for example in your password manager or an env file you don't commit. Personal GitHub accounts have no account-wide secrets, so `install.sh` sets it on each repo.
- This repo is public, so any of your repos, public or private, can call its review workflow.

## Bootstrapping a repo

```sh
CLAUDE_CODE_OAUTH_TOKEN=... ./install.sh ../my-repo
```

It copies the agents, adds `factory.yaml` and the review caller workflow if they're missing, sets the secret if the token is in your environment, and prints what's left (committing, and pointing `factory.yaml` at the repo's Linear project). This repo is bootstrapped the same way.

Claude Code then picks the agents up from `.claude/agents/`. Ask for one by name ("use the review agent on PR 6"), or start a session as one:

```sh
claude --agent implement
```

For Codex, copy `codex/AGENTS.md` to the repo's `AGENTS.md` and ask it to act as a role.

The review workflow loads the review agent from agent-factory's main, not from the PR, so a PR can't change its own reviewer and repos work before they have the agent file. Fork PRs get no secrets, so they're not reviewed. The Claude Action also only runs once the caller workflow is on the default branch, so it can't review the PR that adds it.

## Changing an agent

Edit `agents/<role>.md` or the role's settings in `factory.yaml`, run `./generate.py` (needs PyYAML), and commit the generated files with it. `./generate.py --check` fails if they're out of date. Then rerun `install.sh` in each repo that uses it.

## Adding a harness

Add an entry under `targets:` in `factory.yaml` and a small function in `generate.py` that turns a role's prompt and settings into that harness's files.
