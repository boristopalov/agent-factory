# agent-factory

Our coding agents and the loop between them, as versioned files. Inspired by Warp's [open infrastructure for building a software factory](https://www.warp.dev/blog/open-infrastructure-for-building-a-software-factory). Deliberately lean: we tune it as we learn.

## What's here

- `agents/*.md`: one plain prompt per role, with no harness-specific format.
  - `triage`: works the Linear Backlog: moves ready issues to Todo, splits big ones, flags decisions for Boris.
  - `implement`: makes the change and opens a PR. Never merges.
  - `review`: reviews a PR diff and ranks findings by severity with file:line. Read-only; never approves.
  - `test`: adds tests toward the coverage gate. Never weakens tests or thresholds.
  - `benchmark`: measures a change against its base, by hand, never in CI.
- `factory.yaml`: the loop, plus each role's settings. Linear is the queue (Backlog, Todo, In Progress, Done). It lists each stage's trigger and handoff, the merge gates, and when Boris gets pinged. `agents:` gives each role a description, a model tier (`strong` or `fast`) and its tools; `targets:` maps those to each harness.
- `generate.py`: writes each harness's files from `agents/` and `factory.yaml`: `.claude/agents/` for Claude Code and `codex/AGENTS.md` for Codex. Those are generated; don't edit them by hand.
- `.github/workflows/review.yml`: the Claude PR review as a reusable workflow, running the `review` agent.
- `templates/claude-review.yml`: the short workflow each repo uses to call it.
- `install.sh`: bootstraps a repo in one command.

Repo-specific knowledge (architecture, comment policy, how to run tests) stays in each repo's `CLAUDE.md` or `CONTRIBUTING.md`; every agent reads those first.

## One-time setup

- Install the Claude GitHub app on all your repos (choose "All repositories" when installing), so new repos need nothing here.
- Get a review token with `claude setup-token` and keep it in your shell, for example in your password manager or an env file you don't commit. Personal GitHub accounts have no account-wide secrets, so `install.sh` sets it on each repo.
- This repo is private. A private repo's reusable workflow can only be called by your other private repos, and only after you allow it under this repo's Settings, Actions, General, Access ("Accessible from repositories owned by the user"). For public repos like cmudb to call it, make this repo public, or keep a copy of the workflow in that repo instead.

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

The review workflow reads the agent from the PR's own checkout, so a PR can change its reviewer's prompt. That's fine for a solo repo where only you open PRs (fork PRs get no secrets, so they're not reviewed). The Claude Action also only runs once the caller workflow is on the default branch, so it can't review the PR that adds it.

## Changing an agent

Edit `agents/<role>.md` or the role's settings in `factory.yaml`, run `./generate.py` (needs PyYAML), and commit the generated files with it. `./generate.py --check` fails if they're out of date. Then rerun `install.sh` in each repo that uses it.

## Adding a harness

Add an entry under `targets:` in `factory.yaml` and a small function in `generate.py` that turns a role's prompt and settings into that harness's files.
