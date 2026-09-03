---
description: Log out of Ruvex Factory (revokes tokens, deletes local credentials)
allowed-tools: Bash
---

Detect the operating system YOU are running on and run the matching script,
showing its output to the user verbatim. The script is interactive - run it in
the foreground and let the user answer its prompts:

- Windows:
  `powershell -ExecutionPolicy Bypass -File "${CLAUDE_PLUGIN_ROOT}/scripts/logout.ps1"`
- macOS / Linux (and anything else):
  `sh "${CLAUDE_PLUGIN_ROOT}/scripts/logout.sh"`

These scripts use only default OS tools (sh+curl / PowerShell) - no node/python needed.
