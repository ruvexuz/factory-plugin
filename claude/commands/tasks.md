---
description: Show my Ruvex Factory tasks and let me pick one manually
---

You are working with Ruvex Factory via the `ruvex` MCP server.

1. Call `ruvex_get_rules` FIRST. On an authentication error: tell the user to
   authenticate (`/mcp` -> ruvex -> authenticate) and STOP.
2. Call `ruvex_my_tasks`, show the list, and let the USER choose (unlike /ruvex:start,
   which auto-picks the first one).
3. After the pick: `ruvex_task_context` + the FOLDER DISCIPLINE from the rules, then the
   role workflow.
