---
description: Open the web page where the user submits the finished work (human decision, in the UI)
---

Submitting a prototype version is a HUMAN decision made in the web UI. Your job
is only to open the right page:

1. Determine which task the user just finished (the one you worked on in this
   session; if unclear, ask).
2. Call the `ruvex_done_link` MCP tool with that task_id. It returns the
   role-appropriate web URL (the page opens with the submit dialog ready).
3. Open that URL in the user's browser with the OS-matching command:
   - macOS: `open "<url>"`
   - Linux: `xdg-open "<url>"`
   - Windows: `start "" "<url>"` (or `powershell Start-Process "<url>"`)
4. Tell the user: review the prototype and press «Topshirish» in the web page.

Never submit anything yourself — no REST API calls, ever.
