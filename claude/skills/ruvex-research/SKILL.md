---
name: ruvex-research
description: Use when the user is a Ruvex MANAGER working on a research task - interview, organize findings into research/*.md, check via MCP, confirm proposals
---

# Ruvex Factory MANAGER research workflow

## Hard rules
- LOGIN FIRST: if any ruvex MCP tool fails with an authentication error, STOP everything
  and tell the user to authenticate (/mcp -> ruvex -> authenticate). No Ruvex work before login.
- ALWAYS call `ruvex_get_rules` FIRST and follow the returned canonical rules - they are
  ROLE-SPECIFIC (MANAGER.md) and may be newer than this skill.
- NEVER call the Ruvex REST API (any http URL with /api/v1/...) directly - not with curl,
  not with fetch, not through any tool. You only use the `ruvex` MCP tools.
- FOLDER DISCIPLINE (from the rules) is mandatory before touching files: one project = one
  dedicated folder; confirm/bind with `ruvex_set_project_path`; if the user declines the
  folder - STOP. Research files live under `<bound path>/research/`.
- AI NEVER invents facts. Write down exactly what the user said; if there is no source,
  mark the line "manba: user"; if it is a guess, mark it "taxmin".
- A MANAGER has at most ONE ACTIVE research task at a time - the rest wait in queue
  (`ruvex_next_task` will not surface them). Do not try to work two research tasks at once.

## Flow
1. `ruvex_next_task(cwd)` -> `ruvex_task_context`. If it reports a RESEARCH task
   (origin=RESEARCH), call `ruvex_research_context(task_id)` to get the project info,
   BOUND LOCAL PATH, deadline + lateness, the active checklist (numbered questions), the
   list of proposals sent "O'rganishga" (ref `P/N`, e.g. `3/11` + full text + author + date), any BUSINESS
   return comments, the last check report (if any), the presentation status and the
   document version (v1/v2). If the reply says the task is
   queued (Navbatda), tell the user which research is active first and STOP - do not
   start interviewing.
2. Set up (or reuse) the `research/` folder inside the bound project path, one file per
   checklist question in checklist order (e.g. `01-bozor.md`, `02-raqobat.md`,
   `03-auditoriya.md`, `04-monetizatsiya.md`, `05-oqimlar.md`, `06-funksiyalar.md`,
   `07-xavflar.md` - if a checklist question was added on the server, use `NN-<slug>.md`).
   Any file the user hands you goes into `research/manba/`, unmodified.
3. Interview the user - GUIDED, ONE QUESTION PER TURN (details in the MANAGER rules):
   - GOAL = every checklist question answered + every proposal (ref `P/N`) covered; keep a
     ledger ("3/7 savol, 2/5 taklif") and steer every question at the empty part.
   - Open by explaining the project (title, description, proposals) and the GOAL in a few
     lines, so the MANAGER understands what the project is about along the way.
   - Question FORMAT: if the answer is a choice from a known set (customer type, channel,
     payment model, yes/no/not sure...) ask with the AskUserQuestion tool - 2-4 options,
     `multiSelect` when several apply, help in the option descriptions ("Other" stays for
     free text). If the answer is free text (number, name, price, description) ask in
     chat. Never make the user type what could be a click; one call = one question.
   - Ask ONE concrete question, attach the help needed to answer it (why it matters, what
     to look at, where to find it: "shularni o'rgan...", "bunday ishlaydi...", "buni nima
     qilamiz?"). If the user does not know - split the question, suggest where to look, or
     record an explicit `taxmin`. Never leave the user without a next step.
   - After each answer: write it into the matching section file at once (never invent
     facts - see Hard rules), acknowledge in one line, update the ledger, next question.
   - Files the user gives you go into `research/manba/`; summarize into the section with
     the source cited.
   - When the ledger is complete, announce it: summary per question/proposal +
     "Tadqiqot yakunlandi - jo'natishga tayyormiz. Tekshiruvga yuboraymi?" and wait for
     the user's yes.
4. When the GOAL is collected and the user agreed (or says "bo'ldi"/"tayyor" earlier): assemble
   `research/TADQIQOT.md` (sections = checklist order). If `pandoc` is available, also
   produce `research/TADQIQOT.pdf`; otherwise send the markdown as-is.
5. `ruvex_research_sync(task_id, files[{path, content}], manifest[])` with the `research/**`
   files (manifest = full relative-path list of that folder, mirroring `ruvex_sync_files`
   semantics).
6. `ruvex_research_check(task_id, file_name, content | content_base64)` with the
   assembled document (md/txt as `content`, docx/pdf as `content_base64`, ≤20MB).
   - `ok=false`: show the gap report to the user verbatim (missing items / open
     questions / extra material / proposal coverage) and go back to step 3 for the
     missing parts. If the SAME gap repeats 2+ checks in a row, ask the user "shu bandni
     ataylab bo'sh qoldiramizmi?" - but do not offer to submit as-is either way; the
     server rejects incomplete research regardless.
   - `ok=true`: you get an `UPLOAD_TOKEN`, an AI summary, and a per-proposal line
     (`P/N coverage decision reason summary`). Show this list to the user and get their
     explicit confirmation or changes before moving on.
7. `ruvex_research_confirm(task_id, upload_token, summary, decisions[{id, decision}], mode?)`
   with the user-approved decisions. If the reply says `merge_mode_required` (the project has an
   open prototype version vN, possibly SENT to review), ask the user with AskUserQuestion:
   "add the accepted proposals to vN (mode=merge; a SENT version is retracted from review and the
   PROTOTYPER continues)" or "new version vN+1 (mode=new)" - then call again with `mode`. Report the result to the user verbatim (submission
   confirmation, accepted/archived/returned-to-idea counts, "BIZNES tasdig'i kutiladi",
   and the `/projects/<id>` link).
8. Call `ruvex_next_task` again - if another research task activated for this MANAGER,
   switch the folder per FOLDER DISCIPLINE (one project = one folder, no mixing) and
   restart the flow from step 1.

`ruvex_working` at the start of each working turn (work-time tracking), same as the
prototyping workflow. State/deadline/lateness are reported by `ruvex_research_context` -
mention them to the user at the start of the session.
