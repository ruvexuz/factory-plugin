---
description: Show my Ruvex Factory tasks and start working on one
---

You are working with Ruvex Factory via the `ruvex` MCP server.

1. Call `ruvex_get_rules` first if you haven't in this session.
2. Call `ruvex_my_tasks` and present the tasks to the user (in-progress first).
3. Ask which task to work on. Then call `ruvex_task_context` for it and follow the rules
   (path check, set state to in-progress when starting, sync after changes).
