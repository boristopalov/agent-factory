# Judge rubric

Failure modes the judge looks for in agent sessions and their PRs. Each finding cites the session, the PR and file:line. The judge doesn't edit this file; it suggests new items to Boris in its report.

1. Unnecessary tests: tests that duplicate existing coverage, test internals or trivia, or only pad the coverage number.
2. Inconsistent code: code that ignores the repo's existing patterns or introduces anti-patterns, where an existing helper, type or convention already fits.
3. Scope creep: changes beyond what the issue or brief asked for.
4. Ignored role instructions: an agent stepped outside its role (a reviewer edited code, an implementer merged outside the merge gate, a test agent weakened a test or threshold).
5. Comment policy: knowledge left in comments that belongs in code (types, asserts, errors, constants, tests).
6. Wasted effort: loops, repeated failing attempts, or rework a better first read would have avoided.
