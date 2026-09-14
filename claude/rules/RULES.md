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

## MANAGER (research) fallback

Canonical rules for MANAGER research tasks are served via `ruvex_get_rules` (adds
`MANAGER.md` alongside CORE). This bundled summary is a fallback only, see the
`ruvex-research` skill for the full flow:
- Research files live under `<project>/research/` (one file per checklist question,
  `research/manba/` for user-provided source files, `research/TADQIQOT.md` as the
  assembled document).
- Interview the user question by question; never invent facts - mark unsourced answers
  "manba: user" and guesses "taxmin".
- Sync with `ruvex_research_sync`, validate with `ruvex_research_check`, loop on gaps,
  then confirm the AI's proposal decisions with `ruvex_research_confirm` only after the
  user approves them.
- One active research task at a time; call `ruvex_working` while collaborating.
