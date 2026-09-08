---
description: Producer commit - commit & push the version branch (never main)
---

The user wants to commit the current code state. Follow this EXACT order:

1. Make sure the project's tests/build pass locally first. If they fail, tell the user
   and STOP - do not commit broken code unless the user explicitly insists.
2. Identify the current task (the one you are working on; `ruvex_next_task` if unsure)
   and its CODE REPOS from `ruvex_task_context`.
3. For EACH repo folder (`code/<name>/`) with changes:
   - `git branch --show-current` MUST be `v<N>` (the task's version). If it is `main`
     or anything else: create/checkout `v<N>` first. NEVER commit or push to main.
   - Verify no secrets (.env*, keys) or artifacts (node_modules, dist, build) are
     staged - .gitignore must cover them.
   - `git add` + `git commit` with a short imperative message, then `git push origin v<N>`.
4. Report the result per repo (branch, commit summary).
5. FALLBACK: if git access fails (auth error on push), use `ruvex_sync_code` with the
   COMPLETE manifest - the server commits+pushes to v<N> for you.

main changes ONLY via pull requests opened from the web UI and merged by a human.
