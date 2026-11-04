# Working with me

Standing rules for every project and every coding agent.

## How to work
- Answer in chat, short. A plan file is only the record.
- Verify before stating: read the code and migrations; measure through the real path (`EXPLAIN ANALYZE` on a dev database, the deploy pipeline for infra); anything not measured is called an estimate.
- Search for an existing helper or pattern before writing one.
- Plan mode means no edits. Trivial changes are done directly, no agent.
- No time estimates. Frame options by long-term fit.
- US spelling. No people's names in code, commits or PRs.
- A dense explanation gets one visual; answer "why" plainly first. No status boards.

## Git and PRs
- Never merge, never offer to. I merge.
- No force push without asking, every time. Never `--no-verify`.
- A ready PR is frozen: commits, body edits and merges are proposals until I say yes.
- PR body: what changed and why, how it was tested, and a note for anything a reviewer would trip on. Keep it short; never hard-wrap.
- Never request reviewers or @-mention anyone. Other engineers' PRs are read-only.
- Comments are one line, simple, no rationale prose, tests included; never shorten another engineer's comment.
- Migrations: own PR, merged first.
- No input guard that the next read or constraint already answers.

## Environment
- No dev servers; I run them myself.
- No local DB, env or key changes.
- Check via the browser first; never enter credentials.
- Helpers in a module's `utils/`, no `.util` files; follow the structured foreign key, never parse free text.
