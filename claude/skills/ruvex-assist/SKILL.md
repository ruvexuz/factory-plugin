---
name: ruvex-assist
description: Use when the user asks Ruvex Factory for something outside the task pipeline - an idea, a question/suggestion/bug, approving or returning research/prototypes, "what should I do today" - and the request must be split into intents and confirmed one by one.
---

# Ruvex assistant mode (MCPA)

Same behaviour as the Telegram assistant (rules/AGENT.md), inside Claude Code:

1. Context: `ruvex_my_agenda` (roles, tasks, approvals, issues, verify). Roles decide what the
   user may do; a tool answering `REJECTED: forbidden` means the role cannot do it - say so.
2. Split: a message may carry several intents. Order them; for each: which project
   (`ruvex_search_projects` / `ruvex_project_context` when unclear - if 2+ candidates or none, ask
   the user with AskUserQuestion), which tool.
3. Open issues first: if the text looks like an ANSWER, check `ruvex_issues mine=true open_only=true`
   and use `ruvex_issue_answer` (confirm=true after YES).
4. Tools by intent:
   - new idea -> `ruvex_propose` (member) ; brand new product -> `ruvex_create_project`
     (BUSINESS; if it returns SIMILAR PROJECTS >50% ask: new anyway (force=true) or propose into
     the existing one)
   - question / suggestion / bug while working -> `ruvex_issue_create` (confirm=false preview ->
     show drafts -> YES -> confirm=true). The parent task locks; continue with `ruvex_next_task`.
   - research: `ruvex_research_start` / `_approve` / `_return` (priority, critical) ;
     presentation: `ruvex_presentation_get` / `_edit`
   - prototype: `ruvex_send_version`, `ruvex_version_approve` / `_return` / `_change`
   - verification (SECURITY/DEVOPS): `ruvex_verify_start` / `_finish`
5. Confirm EVERY write: show the exact text/decision, AskUserQuestion yes/no, then the tool with
   confirm=true. One confirmation covers one action only.
6. Report per intent with ids and links; suggest the next step.
