# Ruvex login (device flow) - PowerShell: toza Windows'da qo'shimcha talabsiz.
$ErrorActionPreference = 'Stop'
$API = if ($env:RUVEX_API_URL) { $env:RUVEX_API_URL } else { 'http://localhost:8080' }

try {
  $start = Invoke-RestMethod -Method Post -Uri "$API/api/v1/auth/device/start" -ContentType 'application/json' -Body '{}'
} catch {
  Write-Host "X Serverga ulanib bo'lmadi: $API - backend ishlayaptimi? RUVEX_API_URL to'g'rimi?"
  exit 1
}
$approve = "$($start.verify_url)?code=$($start.user_code)"

Write-Host ""
Write-Host "  RUVEX LOGIN (device flow)"
Write-Host "  -------------------------"
Write-Host "  Hozir brauzerda shu sahifa ochiladi: $approve"
Write-Host "  Sahifadagi kod TERMINALDAGI bilan bir xil bo'lishi kerak: $($start.user_code)"
Write-Host "  Login bo'lmagan bo'lsangiz avval kirasiz, keyin 'Tasdiqlash' bosasiz."
Write-Host ""
Read-Host "Davom etish uchun ENTER bosing" | Out-Null
Start-Process $approve
Write-Host "Kutilmoqda..."

for ($i = 0; $i -lt 120; $i++) {
  Start-Sleep -Seconds 5
  try {
    $resp = Invoke-RestMethod -Method Post -Uri "$API/api/v1/auth/device/poll" -ContentType 'application/json' -Body (@{device_code = $start.device_code} | ConvertTo-Json)
  } catch {
    if ($_.Exception.Response.StatusCode.value__ -eq 400) { Write-Host "X Kod muddati tugadi."; exit 1 }
    continue
  }
  if ($resp.mcp_token) {
    $dir = Join-Path $env:USERPROFILE '.ruvex'
    New-Item -ItemType Directory -Force -Path $dir | Out-Null
    $resp | ConvertTo-Json | Set-Content (Join-Path $dir 'credentials')
    Write-Host ""
    Write-Host "OK Muvaffaqiyatli: $($resp.login) sifatida ulandingiz."
    Write-Host "MCP uchun (doimiy o'rnatish), keyin YANGI terminalda claude oching:"
    Write-Host "  [Environment]::SetEnvironmentVariable('RUVEX_MCP_TOKEN','$($resp.mcp_token)','User')"
    Write-Host "  [Environment]::SetEnvironmentVariable('RUVEX_MCP_URL','$API/mcp','User')"
    exit 0
  }
}
Write-Host "X Vaqt tugadi."
exit 1
