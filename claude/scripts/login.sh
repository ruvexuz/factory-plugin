#!/bin/sh
# Ruvex login (device flow) - POSIX sh + curl: toza macOS/Linux'da qo'shimcha talabsiz.
set -eu
API="${RUVEX_API_URL:-http://localhost:8080}"

http_post() { # $1=path $2=body
  if command -v curl >/dev/null 2>&1; then
    curl -s -X POST "$API$1" -H 'Content-Type: application/json' -d "$2"
  else
    wget -q -O - --post-data="$2" --header='Content-Type: application/json' "$API$1"
  fi
}

json_get() { # $1=json $2=kalit  (oddiy string qiymatlar uchun)
  printf '%s' "$1" | sed -n "s/.*\"$2\":\"\([^\"]*\)\".*/\1/p"
}

START=$(http_post /api/v1/auth/device/start '{}' ) || {
  echo "✘ Serverga ulanib bo'lmadi: $API - backend ishlayaptimi? RUVEX_API_URL to'g'rimi?"; exit 1; }
DEVICE=$(json_get "$START" device_code)
CODE=$(json_get "$START" user_code)
VURL=$(json_get "$START" verify_url)
[ -n "$CODE" ] || { echo "✘ device/start xatosi: $START"; exit 1; }
APPROVE="$VURL?code=$CODE"

echo ""
echo "  RUVEX LOGIN (device flow)"
echo "  -------------------------"
echo "  Hozir brauzerda shu sahifa ochiladi: $APPROVE"
echo "  Sahifadagi kod TERMINALDAGI bilan bir xil bo'lishi kerak: $CODE"
echo "  Login bo'lmagan bo'lsangiz avval kirasiz, keyin «Tasdiqlash» bosasiz."
echo "  Tasdiqlagach bu terminal avtomatik davom etadi (10 daqiqa muddat)."
echo ""
printf "Davom etish uchun ENTER bosing... "
read -r _ || true

if [ "$(uname)" = "Darwin" ]; then open "$APPROVE" 2>/dev/null || true
else xdg-open "$APPROVE" 2>/dev/null || echo "Brauzer ochilmadi - qo'lda oching: $APPROVE"; fi
echo "Kutilmoqda..."

i=0
while [ $i -lt 120 ]; do
  sleep 5; i=$((i+1))
  RESP=$(http_post /api/v1/auth/device/poll "{\"device_code\":\"$DEVICE\"}") || continue
  case "$RESP" in
    *mcp_token*)
      mkdir -p "$HOME/.ruvex"
      printf '%s' "$RESP" > "$HOME/.ruvex/credentials"
      chmod 600 "$HOME/.ruvex/credentials" 2>/dev/null || true
      MCP=$(json_get "$RESP" mcp_token)
      LOGIN=$(json_get "$RESP" login)
      echo ""
      echo "✔ Muvaffaqiyatli: $LOGIN sifatida ulandingiz."
      echo "  Tokenlar: $HOME/.ruvex/credentials"
      echo ""
      echo "MCP uchun shell profilingizga qo'shing va YANGI terminalda claude oching:"
      echo "  export RUVEX_MCP_TOKEN=$MCP"
      echo "  export RUVEX_MCP_URL=$API/mcp"
      exit 0 ;;
    *device_code_expired*)
      echo "✘ Kod muddati tugadi - /ruvex:login ni qayta ishga tushiring."; exit 1 ;;
  esac
done
echo "✘ Vaqt tugadi."; exit 1
