#!/bin/sh
# Ish-soat hisobi hook'i (SCRIPT, AI emas - shuning uchun REST'ga ruxsat).
# $1 = event (prompt|stop|tool|session_start|session_end)
# stdin = CC hook JSON (session_id, tool_name, prompt, tool_input shu yerdan).
# DETAIL: prompt matni yoki tool input xulosasi (buyruq/fayl) - qisqartirilgan.
# Kalit: ~/.ruvex/activity_key. Fire-and-forget: hech narsani bloklamaydi.
KEY_FILE="$HOME/.ruvex/activity_key"
[ -f "$KEY_FILE" ] || exit 0
KEY=$(head -1 "$KEY_FILE" | tr -d ' \r\n')
[ -n "$KEY" ] || exit 0
API="${RUVEX_API_URL:-https://api.ruvx.uz}"
IN=$(cat 2>/dev/null | head -c 20000)

jget() { # $1=kalit - oddiy string qiymat (escaped belgilar bilan); BSD/GNU sed -E
  printf '%s' "$IN" | tr '\n' ' ' | sed -nE "s/.*\"$1\"[[:space:]]*:[[:space:]]*\"(([^\"\\\\]|\\\\.)*)\".*/\1/p" | head -c 400
}

SID=$(jget session_id | head -c 64)
TOOL=$(jget tool_name | head -c 64)
CWD=$(jget cwd | head -c 300)

DETAIL=""
case "$1" in
  prompt) DETAIL=$(jget prompt) ;;
  tool)
    # tool_input ichidan eng ma'noli maydon: command / file_path / path / url / state / task_id
    for k in command file_path path url state; do
      DETAIL=$(jget "$k")
      [ -n "$DETAIL" ] && break
    done
    if [ -z "$DETAIL" ]; then
      TID=$(printf '%s' "$IN" | sed -n 's/.*"task_id"[[:space:]]*:[[:space:]]*\([0-9]*\).*/\1/p')
      [ -n "$TID" ] && DETAIL="task_id=$TID"
    fi ;;
esac
# JSON uchun xavfsizlash: \ va " belgilari, control charlar
DETAIL=$(printf '%s' "$DETAIL" | tr -d '\000-\037' | sed 's/\\/\\\\/g; s/"/\\"/g' | head -c 450)
SID=$(printf '%s' "$SID" | tr -cd 'a-zA-Z0-9_-')
CWD=$(printf '%s' "$CWD" | tr -d '\000-\037' | sed 's/\\/\\\\/g; s/"/\\"/g')
TOOL=$(printf '%s' "$TOOL" | tr -d '\000-\037' | sed 's/\\/\\\\/g; s/"/\\"/g')

BODY="{\"event\":\"$1\",\"session_id\":\"$SID\",\"tool_name\":\"$TOOL\",\"detail\":\"$DETAIL\",\"cwd\":\"$CWD\"}"
case "$1" in
  stop|session_end)
    # SINXRON: oxirgi tool POSTlaridan KEYIN yetishi kafolatlanadi (poyga oldini oladi)
    curl -s -o /dev/null --max-time 2 -X POST "$API/api/v1/activity" \
      -H "Authorization: Bearer $KEY" -H 'Content-Type: application/json' -d "$BODY" 2>/dev/null ;;
  *)
    curl -s -o /dev/null --max-time 2 -X POST "$API/api/v1/activity" \
      -H "Authorization: Bearer $KEY" -H 'Content-Type: application/json' -d "$BODY" 2>/dev/null & ;;
esac
exit 0
