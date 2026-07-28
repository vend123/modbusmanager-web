# Lisab neli uut seadmelehte nav-menüü "Guides" rippmenüüsse KÕIGIL lehtedel.
# Jooksuta mm-web kaustas:
#   powershell -ExecutionPolicy Bypass -File .\add-nav-guides.ps1
# Ohutu korduvalt jooksutada.

$ErrorActionPreference = 'Stop'
$enc = New-Object System.Text.UTF8Encoding($false)
$changed = 0

$anchor = '<a href="/abb-acs880-modbus.html">ABB ACS880</a>'
$marker = '<a href="/powerflex-525-modbus.html">PowerFlex 525</a>'

$add = @'
        <a href="/powerflex-525-modbus.html">PowerFlex 525</a>
        <a href="/durapulse-gs20-modbus.html">DURApulse GS20</a>
        <a href="/yaskawa-v1000-modbus.html">Yaskawa V1000</a>
        <a href="/wattnode-modbus.html">WattNode</a>
'@

Get-ChildItem -Filter *.html | Sort-Object Name | ForEach-Object {
  $p = $_.FullName
  $t = [IO.File]::ReadAllText($p)
  if ($t.Contains($marker)) { Write-Host "  juba OK: $($_.Name)" -ForegroundColor DarkGray; return }
  if (-not $t.Contains($anchor)) { Write-Host "  nav-ankrut pole: $($_.Name)" -ForegroundColor Yellow; return }
  $new = $anchor + "`r`n" + $add.TrimEnd("`r","`n")
  [IO.File]::WriteAllText($p, $t.Replace($anchor, $new), $enc)
  Write-Host "  lisatud: $($_.Name)" -ForegroundColor Green
  $script:changed++
}

Write-Host ""
Write-Host "Muudetud faile: $changed" -ForegroundColor Cyan
Write-Host ""
Write-Host "KONTROLL - mitu lehte viitab igale uuele lehele:" -ForegroundColor Yellow
foreach ($f in 'powerflex-525-modbus.html','durapulse-gs20-modbus.html','yaskawa-v1000-modbus.html','wattnode-modbus.html') {
  $n = (Select-String -Path *.html -SimpleMatch $f).Count
  Write-Host ("  {0,-32} {1} viidet" -f $f, $n)
}
$bad = Select-String -Path index.html -SimpleMatch 'tab-gateway'
if ($bad) { Write-Host "  HOIATUS: index.html sisaldab rakenduse koodi!" -ForegroundColor Red } else { Write-Host "  index.html on koduleht (korras)" -ForegroundColor Green }
