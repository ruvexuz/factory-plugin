---
name: ruvex-prototype
description: Use when the user wants to work on a Ruvex Factory task - building or fixing a UI prototype through the ruvex MCP server (tasks, sync, states).
---

# Ruvex Factory prototyping workflow

## Hard rules
- LOGIN FIRST: if any ruvex MCP tool fails with an authentication error, STOP everything
  and tell the user to authenticate (/mcp -> ruvex -> authenticate). No Ruvex work before login.
- ALWAYS call `ruvex_get_rules` FIRST and follow the returned canonical rules - they are
  ROLE-SPECIFIC and may be newer than this skill.
- NEVER call the Ruvex REST API (any http URL with /api/v1/...) directly - not with curl,
  not with fetch, not through any tool. You only use the `ruvex` MCP tools. Submission is
  human-only: /ruvex:done just opens the web page (via `ruvex_done_link`), the user submits there.
- /ruvex:start auto-picks the TOP task (critical/priority); /ruvex:tasks lets the user pick.
- FOLDER DISCIPLINE (from the rules) is mandatory before touching files: one project = one
  dedicated folder; confirm/bind with ruvex_set_project_path; restore a lost folder with
  ruvex_pull_files; if the user declines the folder - STOP.

## Flow
1. `ruvex_my_tasks` -> show list -> user picks.
2. `ruvex_task_context` -> read the spec (accepted proposals), version, preview URL,
   bound local path. If CWD differs from the bound path, suggest switching (or bind the
   current one with `ruvex_set_project_path` if the user agrees).
3. `ruvex_set_task_state` to "Jarayonda" when you actually start.
4. Build static prototype files under prototype/v<N>/ locally; after every meaningful
   change push them with `ruvex_sync_files` and give the user the preview URL.
5. `ruvex_working` at the start of each working turn (work-time tracking).
6. When done: `ruvex_set_task_state` to "Bajarildi", then run /ruvex:done flow:
   `ruvex_done_link` -> open the returned URL in the browser -> the USER reviews and
   submits in the web UI.
