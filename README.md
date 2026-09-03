# factory-plugin

AI agentlar uchun Ruvex Factory integratsiyalari. Hozircha: `claude/` — Claude Code plugin.

## Lokal o'rnatish (testlash)

```bash
# 1. Marketplace sifatida lokal papkani qo'shish (bir marta)
claude plugin marketplace add ~/projects/ruvex/ruvexfactory/factory-plugin

# 2. O'rnatish
claude plugin install ruvex@ruvex

# 3. Tekshirish - yangi Claude Code sessiyada:
#    /ruvex:ping   -> "Ruvex plugin o'rnatilgan va ishlayapti."
```

Plugin fayllarini o'zgartirgandan keyin yangilash:

```bash
claude plugin marketplace update ruvex
claude plugin update ruvex@ruvex
```

O'chirish: `claude plugin uninstall ruvex@ruvex`

## Keyingi qadamlar (factory-prototype/docs/TASKS.md, PLUGIN.md)

- MCP server ulanishi (api.ruvx.uz/mcp, PAT bilan) - 5-qadam
- `/ruvex:login` device-flow, `/ruvex:tasks`, `/ruvex:done` (API orqali)
- SessionStart hook: agent har sessiyada "Ruvex bo'yicha ishlaysizmi?" deb so'raydi

Til qoidasi: AI o'qiydigan kontent (commands, skills, rules, tool descriptions) - ENGLISH;
kod izohlari va README - uz.

## Qoida: versiya

Plugin tarkibi HAR o'zgarganda `claude/.claude-plugin/plugin.json` dagi `version` oshiriladi (kamida patch). O'zgarish versiyasiz commit qilinmaydi.

## v0.1.1 - MCP ulandi (scriptlar sh+curl / PowerShell - node talab qilinmaydi)

1. `/ruvex:login` - brauzerda kod tasdiqlaysiz, ikkita token keladi:
   - `RUVEX_MCP_TOKEN` (AI uchun, faqat /mcp da ishlaydi)
   - cli token (~/.ruvex/credentials, faqat scriptlar uchun - AI ko'rmaydi)
2. Export qilingan env bilan YANGI terminalda `claude` oching - `ruvex` MCP ulanadi.
3. `/ruvex:tasks` - vazifalar; AI prototip yasab `ruvex_sync_files` bilan sync qiladi.
4. `/ruvex:done` - topshirish (terminal tanlov + yes/no, REST API orqali).

Dev uchun: `export RUVEX_API_URL=http://localhost:8080` (default shu).
