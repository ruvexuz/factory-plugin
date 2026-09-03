# /ruvex:done - topshirish (REST, CLI token). PowerShell.
$ErrorActionPreference = 'Stop'
$API = if ($env:RUVEX_API_URL) { $env:RUVEX_API_URL } else { 'http://localhost:8080' }
$cred = Join-Path $env:USERPROFILE '.ruvex\credentials'
if (-not (Test-Path $cred)) { Write-Host "X Avval /ruvex:login qiling."; exit 1 }
$cli = (Get-Content $cred | ConvertFrom-Json).cli_token
$h = @{ Authorization = "Bearer $cli" }

$list = Invoke-RestMethod -Uri "$API/api/v1/my/sendable-versions" -Headers $h
if ($list.versions.Count -eq 0) { Write-Host "Topshirsa bo'ladigan versiya yo'q."; exit 0 }

Write-Host "Topshirishga tayyor versiyalar:"
for ($i = 0; $i -lt $list.versions.Count; $i++) {
  $v = $list.versions[$i]
  Write-Host "  $($i+1)) v$($v.version) (version_id=$($v.id))"
}
$n = [int](Read-Host "Qaysi birini topshiramiz? (raqam)")
$v = $list.versions[$n-1]
if (-not $v) { Write-Host "X Noto'g'ri tanlov."; exit 1 }
$yn = Read-Host "v$($v.version) ni topshiramizmi? (yes/no)"
if ($yn -notin @('y','yes','ha')) { Write-Host "Bekor qilindi."; exit 0 }
Invoke-RestMethod -Method Post -Uri "$API/api/v1/versions/$($v.id)/send" -Headers $h | Out-Null
Write-Host "OK Topshirildi (SENT). Endi BUSINESS webda tasdiqlaydi."
