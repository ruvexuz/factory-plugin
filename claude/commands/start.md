---
description: Start Ruvex work - auto-picks the top task and enforces folder discipline
---

The user starts Ruvex Factory work. Follow this EXACT order:

1. Call `ruvex_get_rules`. If it fails with an authentication error: tell the user to
   authenticate the ruvex MCP server (`/mcp` -> ruvex -> authenticate) and STOP - no
   Ruvex command works before login.
2. Call `ruvex_next_task` - the SERVER decides which single task to work on (kanban
   order: in-progress first, then queued; critical, priority). Work on exactly that
   task; do not pick from a list. Tell the user which task was picked and for which
   project. (`/ruvex:tasks` + `ruvex_my_tasks` remain for manual browsing only.)
3. Call `ruvex_task_context` and apply the FOLDER DISCIPLINE from the rules (compare
   BOUND LOCAL PATH with CWD; ask the user the exact questions from the rules; use
   `ruvex_pull_files` to restore into a new empty folder when the old one is gone;
   bind with `ruvex_set_project_path`). If the user declines the folder - STOP.
4. Only after the folder is confirmed: proceed with the role workflow from the rules.
