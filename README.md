# factory-plugin

AI agentlar uchun Ruvex Factory integratsiyalari. Hozircha: `claude/` — Claude Code plugin.

## O'rnatish (foydalanuvchi uchun)

Talab: Claude Code o'rnatilgan, `app.ruvx.uz` da akkaunt (admin yaratadi).

```bash
claude plugin marketplace add ruvexuz/factory-plugin   # bir marta
claude plugin install ruvex@ruvex
```

Birinchi ishlatish (yangi Claude Code sessiyada):

1. `/mcp` -> `ruvex` -> **Authenticate** - brauzer ochiladi (`api.ruvx.uz` -> `app.ruvx.uz` consent), login qilib ruxsat berasiz.
2. `/ruvex:ping` - plugin javob beradi. `/ruvex:start` - birinchi task avtomatik.

Yangilanish - ikki yo'l:

- **Avtomatik (tavsiya, bir marta yoqiladi):** `/plugin` -> **Marketplaces** -> `ruvex` -> **Enable auto-update**.
  Claude Code har sessiya boshida (10 daqiqagacha kechikish bilan) yangi versiyani tortadi va
  `/reload-plugins` ni taklif qiladi; aks holda keyingi sessiyada yangi versiya ishlaydi.
  (Tashqi marketplace'lar uchun auto-update default O'CHIQ - shuning uchun yoqish kerak.)
- **Qo'lda:**

```bash
claude plugin marketplace update ruvex && claude plugin update ruvex@ruvex
```

O'chirish: `claude plugin uninstall ruvex@ruvex`

Prod manzillar plugin ichida default: MCP `https://api.ruvx.uz/mcp`, activity `https://api.ruvx.uz`.

## Dev (lokal backend bilan)

```bash
export RUVEX_MCP_URL=http://localhost:8080/mcp
export RUVEX_API_URL=http://localhost:8080
claude plugin marketplace add ~/projects/ruvex/ruvexfactory/factory-plugin
claude plugin install ruvex@ruvex
```

Plugin fayllarini o'zgartirgandan keyin: `claude plugin marketplace update ruvex && claude plugin update ruvex@ruvex`.

Til qoidasi: AI o'qiydigan kontent (commands, skills, rules, tool descriptions) - ENGLISH;
kod izohlari va README - uz.

## Qoida: versiya

Plugin tarkibi HAR o'zgarganda versiya IKKI joyda oshiriladi (bir xil qiymat, kamida patch):
`claude/.claude-plugin/plugin.json` va `.claude-plugin/marketplace.json` (plugin entry `version`).
Marketplace'dagi versiya o'zgarmasa userlar kesh nusxada qoladi. O'zgarish versiyasiz commit qilinmaydi.
