#!/bin/sh
# /ruvex:logout - tokenlarni serverda bekor qilib, lokal faylni o'chiradi
set -eu
API="${RUVEX_API_URL:-http://localhost:8080}"
CRED="$HOME/.ruvex/credentials"
[ -f "$CRED" ] || { echo "Siz login qilmagansiz (~/.ruvex/credentials yo'q)."; exit 0; }
CLI=$(sed -n 's/.*"cli_token":[[:space:]]*"\([^"]*\)".*/\1/p' "$CRED")
if [ -n "$CLI" ]; then
  RESP=$(curl -s -X POST "$API/api/v1/auth/plugin/logout" -H "Authorization: Bearer $CLI" || echo '')
  case "$RESP" in
    *revoked*) N=$(printf '%s' "$RESP" | sed -n 's/.*"revoked":\([0-9]*\).*/\1/p'); echo "✔ Serverda $N ta token bekor qilindi (mcp + cli)." ;;
    *) echo "! Serverda bekor qilib bo'lmadi - token allaqachon yaroqsiz bo'lishi mumkin." ;;
  esac
fi
rm -f "$CRED"
echo "✔ Lokal kredensiallar o'chirildi: $CRED"
echo "Eslatma: RUVEX_MCP_TOKEN env shell profilingizda qolgan bo'lsa, uni ham olib tashlang. Qayta kirish: /ruvex:login"
