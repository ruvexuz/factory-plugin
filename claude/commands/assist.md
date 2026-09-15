---
description: Free-form Ruvex request (idea, question, approval, "what should I do today") - handled step by step with confirmation
---

The user wants something from Ruvex Factory outside the task pipeline (or does not know what to do).

1. Call `ruvex_get_rules` (auth error -> tell the user to authenticate the ruvex MCP server and STOP).
2. Call `ruvex_my_agenda` and show a short summary: my tasks (queue/blocked), approvals waiting,
   issues waiting for my answer, verification tasks.
3. If the user wrote a request (the text after /ruvex:assist, or their next message): split it into
   intents (several things at once are normal), resolve the project with `ruvex_search_projects`
   when it is named loosely, and handle intents ONE BY ONE following the `ruvex-assist` skill:
   show exactly what will be written, ask a yes/no question (AskUserQuestion), then call the tool
   with confirm=true. Never write without the user's YES.
4. Report what was done per intent (ids, links) and the next step.

Arguments: $ARGUMENTS
