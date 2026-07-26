# Uuendab ulejaanud lehtede <title> ja <meta name="description"> tekstid
# nii, et need mahuvad Google-i kuvatavatesse piiridesse (60 / 155 markki).
# Muudab AINULT neid ridu. Jooksuta mm-web kaustas:
#   powershell -ExecutionPolicy Bypass -File .\fix-titles-meta-2.ps1
# Ohutu korduvalt jooksutada.

$ErrorActionPreference = 'Stop'
$enc = New-Object System.Text.UTF8Encoding($false)
$changed = 0

function Set-Meta([string]$file, [string]$newTitle, [string]$newDesc) {
  if (-not (Test-Path $file)) { Write-Host "  puudub: $file" -ForegroundColor DarkGray; return }
  $p = (Resolve-Path $file).Path
  $t = [IO.File]::ReadAllText($p)
  $orig = $t
  if ($newTitle) {
    $m = [regex]::Match($t, '<title>.*?</title>', 'Singleline')
    if ($m.Success) { $t = $t.Replace($m.Value, '<title>' + $newTitle + '</title>') }
  }
  if ($newDesc) {
    $m = [regex]::Match($t, '<meta name="description" content=".*?"', 'Singleline')
    if ($m.Success) { $t = $t.Replace($m.Value, '<meta name="description" content="' + $newDesc + '"') }
  }
  if ($t -ne $orig) {
    [IO.File]::WriteAllText($p, $t, $enc)
    Write-Host "  uuendatud: $file" -ForegroundColor Green
    $script:changed++
  } else { Write-Host "  muutusi ei olnud: $file" -ForegroundColor DarkGray }
}

Set-Meta 'modbus-gateway-software.html' 'Modbus Gateway Software for Windows: Many Devices, One Map' 'Read registers from many Modbus RTU and TCP devices and serve them as one register map your PLC reads with a single connection. Free 14-day trial.'
Set-Meta 'abb-acs880-modbus.html' $null 'Embedded fieldbus or FSCA-01 adapter, ABB Drives profile control word, status and reference registers, plus a free ready-made workspace for Windows.'
Set-Meta 'manual.html' $null 'How to connect over Modbus TCP, RTU and ASCII, poll and write registers, run the slave simulator, build dashboards and set up the gateway.'
Set-Meta 'modbus-alarm-software.html' $null 'Get alerted when Modbus values cross your limits: warning and critical levels, hysteresis, delay, acknowledge, history and sound. Free 14-day trial.'
Set-Meta 'modbus-data-logger-software.html' $null 'Log Modbus registers and tags to a local database on Windows. Trend charts, time ranges, deadband and CSV export. No cloud, no server. Free trial.'
Set-Meta 'modbus-poll-alternative.html' $null 'Windows Modbus master and slave in one tool: built-in slave mode, HMI dashboard and data logging. From $49 one-time, no subscription. Free trial.'
Set-Meta 'modbus-hmi-siemens-s7-1200.html' $null 'Turn ModbusManager Pro into a live HMI for your S7-1200 over Modbus TCP. Free demo project with SCL code and workspace you can run on real hardware.'
Set-Meta 'modbus-hmi-dashboard.html' $null 'Drag-and-drop gauges, trends, lamps and alarms for Modbus devices. No SCADA server, no OPC licenses, no subscription. $119 one-time, free trial.'
Set-Meta 'index.html' 'Modbus Poll &amp; HMI Dashboard Software for Windows' 'Professional Modbus master and slave tool for Windows: test, debug, monitor and simulate RTU and TCP devices. One-time license from $49.'

Write-Host ""
Write-Host "Muudetud faile: $changed" -ForegroundColor Cyan
Write-Host ""
Write-Host "KONTROLL - kuvatavad pikkused (HTML-olemid arvestatud):" -ForegroundColor Yellow
Add-Type -AssemblyName System.Web
$bad = 0
Get-ChildItem -Filter *.html | Sort-Object Name | ForEach-Object {
  $c = [IO.File]::ReadAllText($_.FullName)
  $mt = [regex]::Match($c, '<title>(.*?)</title>', 'Singleline')
  $md = [regex]::Match($c, '<meta name="description" content="(.*?)"', 'Singleline')
  if ($mt.Success -and $md.Success) {
    $tl = [System.Web.HttpUtility]::HtmlDecode($mt.Groups[1].Value).Length
    $dl = [System.Web.HttpUtility]::HtmlDecode($md.Groups[1].Value).Length
    $w = ''
    if ($tl -gt 60)  { $w += '  title>60';  $bad++ }
    if ($dl -gt 155) { $w += '  desc>155'; $bad++ }
    $col = if ($w) { 'Yellow' } else { 'Green' }
    Write-Host ("  {0,-42} T={1,-4} D={2,-4}{3}" -f $_.Name, $tl, $dl, $w) -ForegroundColor $col
  }
}
Write-Host ""
if ($bad -eq 0) { Write-Host "Koik lehed on piirides." -ForegroundColor Green }
else { Write-Host "Ule piiri: $bad kohta" -ForegroundColor Yellow }
