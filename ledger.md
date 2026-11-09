# Judge ledger

One entry per judge run, newest first. The judge appends; Boris fills in a rejection's reason when he closes a proposal.

Entry format:

```
## YYYY-MM-DD
Sessions reviewed: N. Findings: unnecessary tests N, inconsistent code N, scope creep N, ignored role instructions N, comment policy N, wasted effort N.
Proposals:
- <short name>: <file>. Status: open (PR link) | merged | rejected (reason). Check next run: <how we'll know it worked>.
One-offs logged (no proposal): <pattern> (run count so far).
Follow-up on earlier merged changes: <change>: target failure up, down or flat.
```

## 2026-11-09
Sessions reviewed: 42 (38 thread sessions, 3 coordinator sessions, 1 hourly loop run), and 37 PRs (cmudb 23 to 58, agent-factory 16). Transcripts read for every thread session, most in full; the coordinator from 11-03 00:18 to 20:54 UTC wasn't read. The SDLC loop has been paused since 11-03 00:07 UTC, so almost all of this is 11-02 and 11-03. Findings: unnecessary tests 1, inconsistent code 1, scope creep 3, ignored role instructions 12, comment policy 2, wasted effort 8. Outside the rubric: 1 false or unverified claim by an agent (plus 3 borderline), 1 by the coordinator.
Proposals:
- Triage doesn't split an issue meant to stay whole: agents/triage.md. Status: open (this run's PR). Check next run: count issues triage splits against their own description; this week 1 (BOR-89 split into BOR-90 to 92 by the 11-03 00:07 loop run, though it said "One issue, but land it as one PR per phase"; Boris had it folded back).
- Merge only a head that contains current main, and a conditional go-ahead means the gate: agents/implement.md. Status: open (this run's PR). Check next run: count merges whose checks ran on a base main had moved past, and merges that missed the gate on a conditional go-ahead; this week PR 45 merged 4 s after PR 43 and PR 41 4 s after PR 39 on stale bases, PR 56 (merged by Boris, unrebased) broke main with PR 52 until PR 57, and PR 42 merged 11 s after a review with Confidence: medium.
- Answer every review follow-up in a PR comment: agents/implement.md. Status: open (this run's PR). Check next run: count review follow-ups left unanswered, and findings the reviewer raises again after an inline answer; this week 4 unanswered (PR 34, PR 35, PR 44 parser.rs doc rule, PR 57 checkpoint follow-up) and 1 re-raised after an inline reply (PR 30), plus 2 borderline (PR 37, PR 42).
One-offs logged (no proposal): review bot hit its 30-turn limit (PR 46 re-run passed; PR 56 failed 3 runs, agent reviewed locally) (1, seen in 2 sessions, left out only by the 3-proposal cap); `just` not installed, so 8 sessions ran its recipes by hand while 4 pip-installed it (1); PRs with no Linear issue (47, 49, 57, agent-factory 16), mostly ad-hoc tasks briefed without the implement role (1); new test file with its own setup (tests/persistence.rs, PR 40) (1); pushed before running fmt (PR 40) (1); built a page-delete path that an open PR already had (PR 36) (1); shipped then removed the same change in two stacked PRs (PR 32, PR 35) (1); Kani trial with 6+ out-of-memory runs (PR 58) (1); no unsubscribe after merge (PR 43, PR 46, agent-factory 16) (1).
Follow-up on earlier merged changes: reviewer doesn't re-raise answered findings (PR 11): down, 20 last week to 1 (PR 30), and every remaining case is an inline reply the reviewer can't read. Tests build on shared helpers (PR 11): down, 7 to 1. Report only what was checked (PR 11): down, 23 agent claims to 1 (PR 42 told Boris checks and review passed again, after a review with Confidence: medium); coordinator 8 to 1 (said PR 58's Kani proofs run in CI; they don't). Small follow-ups fixed in the same PR (PRs 14, 15): followed on most PRs; the 4 unanswered follow-ups above are the gap. Triage works highest priority first (PR 16): no problem seen.

## 2026-11-02
Sessions reviewed: 12 (11 thread sessions plus the coordinator, full transcripts with tool calls), and 18 PRs (cmudb 3 to 9, agent-factory 1 to 11). cmudb review threads were read only through the transcripts, since the cmudb GitHub API wasn't reachable. Findings: unnecessary tests 6, inconsistent code 8, scope creep 17, ignored role instructions 15, comment policy 5, wasted effort 24. Outside the rubric: 23 false or unverified claims by agents, 8 by the coordinator.
This entry replaces two earlier runs the same day (about 01:21 and 01:27 UTC). Both judged from git and PR data without transcripts and disagreed with each other, so neither is kept.
Proposals:
- Reviewer doesn't re-raise answered findings: agents/review.md. Status: merged (https://github.com/boristopalov/agent-factory/pull/11). Check next run: count findings raised again after the author answered; this week the reviewer raised the latch rule 8 times and the undo order 5 times on cmudb PR 5, the bench CI ask in 5 rounds after it was answered on PR 8, and 2 answered findings again on PR 4.
- Tests build on shared helpers: agents/implement.md. Status: merged (https://github.com/boristopalov/agent-factory/pull/11). Check next run: count new test files or modules with their own database setup; this week 7 across cmudb PRs 3, 5, 6 and 8, 4 of them written after tests/common existed.
- Report only what was checked: agents/implement.md. Status: merged (https://github.com/boristopalov/agent-factory/pull/11). Check next run: count claims to Boris or on PRs that the session's own tool output contradicts; this week 23.
One-offs logged (no proposal): reworded comments to pass check_comments.py while keeping the rule in a doc comment (cmudb PR 5, 2 sessions, covered for now by the reviewer edit) (1); pushed a fix for a review nit (cmudb PR 9) (1); PR body carried the gate's own Verdict/Risk/Confidence lines (agent-factory 4, 5, 6, cmudb 7, 1 session) (1); first fix for a perf PR made the hot path slower (cmudb PR 4 5d90bd6) (1); duplicate assert (cmudb PR 8 src/buffer_pool.rs:555-556) (1).
Follow-up on earlier merged changes: none; no judge proposal has merged yet.
