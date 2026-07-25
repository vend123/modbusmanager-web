# Uuendab 6 lehe <title> ja <meta name="description"> tekstid.
# Muudab AINULT neid kaht rida - lehe sisu ei puutu.
# Jooksuta mm-web kaustas:
#   powershell -ExecutionPolicy Bypass -File .\fix-titles-meta.ps1
# Ohutu korduvalt jooksutada.

$ErrorActionPreference = 'Stop'
$enc = New-Object System.Text.UTF8Encoding($false)
$changed = 0

function Set-Meta([string]$file, [string]$newTitle, [string]$newDesc) {
  if (-not (Test-Path $file)) { Write-Host "  puudub: $file" -ForegroundColor DarkGray; return }
  $p = (Resolve-Path $file).Path
  $t = [IO.File]::ReadAllText($p)
  $orig = $t

  # Literaalne asendus (mitte regex-asendus) - nii ei teki escaping-probleeme
  $mt = [regex]::Match($t, '<title>.*?</title>', 'Singleline')
  if ($mt.Success) { $t = $t.Replace($mt.Value, '<title>' + $newTitle + '</title>') }

  $md = [regex]::Match($t, '<meta name="description" content=".*?"', 'Singleline')
  if ($md.Success) { $t = $t.Replace($md.Value, '<meta name="description" content="' + $newDesc + '"') }

  if ($t -ne $orig) {
    [IO.File]::WriteAllText($p, $t, $enc)
    Write-Host "  uuendatud: $file" -ForegroundColor Green
    $script:changed++
  } else {
    Write-Host "  muutusi ei olnud: $file" -ForegroundColor DarkGray
  }
}

Set-Meta 'huawei-smartlogger-modbus.html' 'Huawei SmartLogger Modbus: SUN2000 Registers + Free Tool' 'Inverter address formula, key SUN2000 registers and status values, plus a free 24-inverter workspace you can open and poll in minutes on Windows.'
Set-Meta 'eastron-sdm630-modbus.html' 'Eastron SDM630 Modbus Register Map + Free Workspace' 'Full SDM630 three-phase register map with FLOAT32 decoding and FC04 addresses, plus a free ready-made workspace to start polling in minutes.'
Set-Meta 'schneider-powerlogic-pm5000-modbus.html' 'Schneider PM5000/PM5300/PM5350 Modbus Registers + File' 'Register map for PM5000 series power meters over Modbus RTU or TCP with FLOAT32 decoding, plus a free ready-made workspace for Windows.'
Set-Meta 'modbus-hmi-ebm-papst.html' 'ebm-papst Modbus: EC Fan Dashboard + Free Demo File' 'Monitor and control a bank of ebm-papst EC fans on one live dashboard. Free 16-fan demo workspace, runs on the built-in simulator or real fans.'
Set-Meta 'eastron-sdm120-modbus.html' 'Eastron SDM120 Modbus Register Map + Free Workspace' 'Complete SDM120 register map with FLOAT32 decoding and 2400 baud defaults, plus a free ready-made workspace you can open and poll in minutes.'
Set-Meta 'abb-acs580-modbus.html' 'ABB ACS580 Modbus: Control Word, Registers + Free File' 'Control word, status word, speed reference and actual value registers for ACS580 over Modbus RTU, plus a free ready-made workspace for Windows.'

Write-Host ""
Write-Host "Muudetud faile: $changed" -ForegroundColor Cyan
Write-Host ""
Write-Host "KONTROLL - pealkirjade ja kirjelduste pikkused:" -ForegroundColor Yellow
Get-ChildItem -Filter *.html | Sort-Object Name | ForEach-Object {
  $c = [IO.File]::ReadAllText($_.FullName)
  $mt = [regex]::Match($c, '<title>(.*?)</title>', 'Singleline')
  $md = [regex]::Match($c, '<meta name="description" content="(.*?)"', 'Singleline')
  if ($mt.Success -and $md.Success) {
    $tl = $mt.Groups[1].Value.Length; $dl = $md.Groups[1].Value.Length
    $w = ''
    if ($tl -gt 60)  { $w += '  title>60' }
    if ($dl -gt 155) { $w += '  desc>155' }
    if ($mt.Groups[1].Value -match '\\') { $w += '  KALDKRIIPS!' }
    $col = if ($w) { 'Yellow' } else { 'Green' }
    Write-Host ("  {0,-42} T={1,-4} D={2,-4}{3}" -f $_.Name, $tl, $dl, $w) -ForegroundColor $col
  }
}
Write-Host ""
Write-Host "Kollased = lehed, mida see skript ei puutunud (voib hiljem korda teha)." -ForegroundColor DarkGray
