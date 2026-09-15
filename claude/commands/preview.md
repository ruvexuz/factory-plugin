---
description: Live-reload preview of the current prototype version (npx live-server) - PROTOTYPER and BUSINESS (version editor)
---

Start a live-reload preview of the prototype the user is working on (rule #111).

1. Determine the version folder: `ruvex_task_context` (VERSION: vN -> `prototype/vN/`) or the
   argument the user passed (`$ARGUMENTS`, e.g. `v2`). The folder must exist locally; if it
   does not, run the FOLDER DISCIPLINE first (bound path / `ruvex_pull_files`).
2. Run in the background (do not block the session):
   `npx -y live-server "prototype/vN" --no-browser --port=5500 --quiet`
   (if 5500 is busy use the next free port). Tell the user the local URL
   (http://127.0.0.1:5500/) and the server PREVIEW URL from `ruvex_task_context`.
3. Keep it running while you edit; every saved file reloads the browser. Stop it when the
   user says so or when the task is done (kill the background process).

Arguments: $ARGUMENTS
