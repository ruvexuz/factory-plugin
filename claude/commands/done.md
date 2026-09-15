---
description: Open the web page where the user submits the finished work (human decision, in the UI)
---

Submitting a prototype version is a HUMAN decision. Two channels, the user picks:
(a) the web page (below) - or (b) after an explicit YES to an AskUserQuestion
("Prototip v<N> BIZNES tekshiruviga topshirilsinmi?") call
`ruvex_send_version(task_id, confirm=true)` and report the reply.

Web channel:

1. Determine which task the user just finished (the one you worked on in this
   session; if unclear, ask).
2. Call the `ruvex_done_link` MCP tool with that task_id. It returns the
   role-appropriate web URL (the page opens with the submit dialog ready).
3. Open that URL in the user's browser with the OS-matching command:
   - macOS: `open "<url>"`
   - Linux: `xdg-open "<url>"`
   - Windows: `start "" "<url>"` (or `powershell Start-Process "<url>"`)
4. Tell the user: review the prototype and press «Topshirish» in the web page.

Never submit without the user's explicit decision — no REST API calls, ever.
