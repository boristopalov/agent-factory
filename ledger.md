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

## 2026-11-02
Sessions reviewed: 12 (11 thread sessions plus the coordinator, full transcripts with tool calls), and 18 PRs (cmudb 3 to 9, agent-factory 1 to 11). cmudb review threads were read only through the transcripts, since the cmudb GitHub API wasn't reachable. Findings: unnecessary tests 6, inconsistent code 8, scope creep 17, ignored role instructions 15, comment policy 5, wasted effort 24. Outside the rubric: 23 false or unverified claims by agents, 8 by the coordinator.
This entry replaces two earlier runs the same day (about 01:21 and 01:27 UTC). Both judged from git and PR data without transcripts and disagreed with each other, so neither is kept.
Proposals:
- Reviewer doesn't re-raise answered findings: agents/review.md. Status: open (https://github.com/boristopalov/agent-factory/pull/11). Check next run: count findings raised again after the author answered; this week the reviewer raised the latch rule 8 times and the undo order 5 times on cmudb PR 5, the bench CI ask in 5 rounds after it was answered on PR 8, and 2 answered findings again on PR 4.
- Tests build on shared helpers: agents/implement.md. Status: open (https://github.com/boristopalov/agent-factory/pull/11). Check next run: count new test files or modules with their own database setup; this week 7 across cmudb PRs 3, 5, 6 and 8, 4 of them written after tests/common existed.
- Report only what was checked: agents/implement.md. Status: open (https://github.com/boristopalov/agent-factory/pull/11). Check next run: count claims to Boris or on PRs that the session's own tool output contradicts; this week 23.
One-offs logged (no proposal): reworded comments to pass check_comments.py while keeping the rule in a doc comment (cmudb PR 5, 2 sessions, covered for now by the reviewer edit) (1); pushed a fix for a review nit (cmudb PR 9) (1); PR body carried the gate's own Verdict/Risk/Confidence lines (agent-factory 4, 5, 6, cmudb 7, 1 session) (1); first fix for a perf PR made the hot path slower (cmudb PR 4 5d90bd6) (1); duplicate assert (cmudb PR 8 src/buffer_pool.rs:555-556) (1).
Follow-up on earlier merged changes: none; no judge proposal has merged yet.
