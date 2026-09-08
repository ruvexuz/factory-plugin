---
description: Producer commit - sync code to the server; the server commits & pushes to GitHub
---

The user wants to commit the current code state. Follow this EXACT order:

1. Make sure the project's tests/build pass locally first. If they fail, tell the user
   and STOP - do not commit broken code unless the user explicitly insists.
2. Identify the current task (the one you are working on; `ruvex_next_task` if unsure)
   and its CODE REPOS from `ruvex_task_context`.
3. For EACH declared repo whose local `code/<name>/` folder has changes:
   call `ruvex_sync_code` with:
   - the COMPLETE manifest (every file path in that folder; NEVER include secrets
     (.env*, keys) or artifacts (node_modules, dist, build, .git) - the server
     rejects them anyway);
   - the changed files (chunk across calls with the same manifest if large);
   - a short imperative commit message describing what changed.
   The server commits and pushes to the repo's v<N> branch and confirms in the reply.
4. Report the result per repo to the user (branch, files synced/removed).

Git commands on the user's machine are FORBIDDEN - the server owns the GitHub side.
