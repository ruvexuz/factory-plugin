# Ruvex Prototype Rules (fallback copy)

The canonical rules are served by the Ruvex server and MUST be fetched via the
`ruvex_get_rules` MCP tool before any prototype work. This bundled copy is a
fallback for offline reading only and may be outdated.

Key points (see canonical version for the full contract):
- Always work inside the task's project folder; prototype files live in
  `<project>/prototype/v<N>/` mirroring the server layout.
- Ask the user which task to work on; never pick silently.
- Update task state when you actually start/finish work; signal completion
  with `ruvex_signal_done` - the final decision belongs to a human.
- Sync files after every meaningful change with `ruvex_sync_files`.
- Call `ruvex_working` while actively collaborating on project work.
