#!/bin/sh
# /ruvex:done - topshirish (REST, CLI token). POSIX sh + curl.
set -eu
API="${RUVEX_API_URL:-http://localhost:8080}"
CRED="$HOME/.ruvex/credentials"
[ -f "$CRED" ] || { echo "✘ Avval /ruvex:login qiling."; exit 1; }
CLI=$(sed -n 's/.*"cli_token":[[:space:]]*"\([^"]*\)".*/\1/p' "$CRED")
[ -n "$CLI" ] || { echo "✘ cli_token topilmadi - /ruvex:login qayta."; exit 1; }

LIST=$(curl -s "$API/api/v1/my/sendable-versions" -H "Authorization: Bearer $CLI")
case "$LIST" in *'"versions":[]'*)
  echo "Topshirsa bo'ladigan versiya yo'q (vazifa hali Bajarildi emas yoki allaqachon jo'natilgan)."; exit 0 ;;
esac

echo "Topshirishga tayyor versiyalar:"
# {"id":X,...,"version":N} juftlarini chiqarish
printf '%s\n' "$LIST" | tr '{' '\n' | sed -n 's/.*"id":\([0-9]*\),.*"version":\([0-9]*\).*/\1 \2/p' > /tmp/ruvex_vers.$$
n=0
while read -r vid vnum; do
  n=$((n+1)); echo "  $n) v$vnum (version_id=$vid)"
done < /tmp/ruvex_vers.$$

printf "Qaysi birini topshiramiz? (raqam): "
read -r CH
VID=$(sed -n "${CH}p" /tmp/ruvex_vers.$$ | cut -d' ' -f1)
rm -f /tmp/ruvex_vers.$$
[ -n "$VID" ] || { echo "✘ Noto'g'ri tanlov."; exit 1; }

printf "Topshiramizmi? (yes/no): "
read -r YN
case "$YN" in y|yes|ha|Y) ;; *) echo "Bekor qilindi."; exit 0 ;; esac

RESP=$(curl -s -X POST "$API/api/v1/versions/$VID/send" -H "Authorization: Bearer $CLI")
case "$RESP" in
  *'"ok":true'*) echo "✔ Topshirildi (SENT). Endi BUSINESS webda tasdiqlaydi." ;;
  *) echo "✘ Xato: $RESP"; exit 1 ;;
esac
