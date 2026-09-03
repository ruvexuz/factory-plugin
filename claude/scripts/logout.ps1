# /ruvex:logout - PowerShell
$API = if ($env:RUVEX_API_URL) { $env:RUVEX_API_URL } else { 'http://localhost:8080' }
$cred = Join-Path $env:USERPROFILE '.ruvex\credentials'
if (-not (Test-Path $cred)) { Write-Host "Siz login qilmagansiz."; exit 0 }
$cli = (Get-Content $cred | ConvertFrom-Json).cli_token
try {
  $r = Invoke-RestMethod -Method Post -Uri "$API/api/v1/auth/plugin/logout" -Headers @{ Authorization = "Bearer $cli" }
  Write-Host "OK Serverda $($r.revoked) ta token bekor qilindi (mcp + cli)."
} catch { Write-Host "! Serverda bekor qilib bo'lmadi - token allaqachon yaroqsiz bo'lishi mumkin." }
Remove-Item $cred -Force
Write-Host "OK Lokal kredensiallar o'chirildi. RUVEX_MCP_TOKEN env'ni ham olib tashlang. Qayta kirish: /ruvex:login"
