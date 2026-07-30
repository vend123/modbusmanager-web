# Asendab neljal uuel seadmelehel vale OG-pildi (og-gateway.png) oma pildiga.
# Eeldab, et og-powerflex-525.png, og-wattnode.png, og-yaskawa.png ja og-gs20.png
# on samas kaustas. Jooksuta mm-web kaustas. Ohutu korduvalt jooksutada.

$ErrorActionPreference = 'Stop'
$enc = New-Object System.Text.UTF8Encoding($false)
$changed = 0

$map = @{
  'powerflex-525-modbus.html'  = 'og-powerflex-525.png'
  'wattnode-modbus.html'       = 'og-wattnode.png'
  'yaskawa-v1000-modbus.html'  = 'og-yaskawa.png'
  'durapulse-gs20-modbus.html' = 'og-gs20.png'
}

foreach ($k in $map.Keys) {
  $img = $map[$k]
  if (-not (Test-Path $k))   { Write-Host "  puudub leht: $k" -ForegroundColor Yellow; continue }
  if (-not (Test-Path $img)) { Write-Host "  puudub pilt: $img" -ForegroundColor Red; continue }
  $p = (Resolve-Path $k).Path
  $t = [IO.File]::ReadAllText($p)
  if ($t.Contains($img)) { Write-Host "  juba OK: $k" -ForegroundColor DarkGray; continue }
  $n = $t.Replace('https://modbusmanager.com/og-gateway.png', 'https://modbusmanager.com/' + $img)
  if ($n -eq $t) { Write-Host "  og-gateway.png ei leitud: $k" -ForegroundColor Yellow; continue }
  [IO.File]::WriteAllText($p, $n, $enc)
  Write-Host ("  uuendatud: {0,-30} -> {1}" -f $k, $img) -ForegroundColor Green
  $changed++
}

Write-Host ""
Write-Host "Muudetud faile: $changed" -ForegroundColor Cyan
Write-Host ""
Write-Host "KONTROLL - OG-pilt lehe kohta:" -ForegroundColor Yellow
Get-ChildItem -Filter *.html | Sort-Object Name | ForEach-Object {
  $c = [IO.File]::ReadAllText($_.FullName)
  $m = [regex]::Match($c, 'property="og:image" content="https://modbusmanager\.com/([^"]+)"')
  if ($m.Success) {
    $img = $m.Groups[1].Value
    $ok = Test-Path $img
    $col = if ($ok) { 'Green' } else { 'Red' }
    Write-Host ("  {0,-42} {1}{2}" -f $_.Name, $img, $(if ($ok) { '' } else { '   FAIL PUUDUB!' })) -ForegroundColor $col
  }
}
