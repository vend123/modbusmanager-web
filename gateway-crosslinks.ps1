# Lisab gateway-lehele kontekstipõhised sisemised lingid.
# Jooksuta mm-web kaustas:  powershell -ExecutionPolicy Bypass -File .\gateway-crosslinks.ps1
# Ohutu korduvalt jooksutada — juba lisatud lehed jäetakse vahele.

$ErrorActionPreference = 'Stop'
$enc = New-Object System.Text.UTF8Encoding($false)
$changed = 0

function Insert-Section([string]$file, [string]$html) {
  if (-not (Test-Path $file)) { Write-Host "  puudub:  $file" -ForegroundColor DarkGray; return }
  $p = (Resolve-Path $file).Path
  $t = [IO.File]::ReadAllText($p)
  if ($t.Contains('GATEWAY CROSS-LINK')) { Write-Host "  juba OK: $file" -ForegroundColor DarkGray; return }
  if ($t.Contains('<div class="cta-strip">')) {
    $t2 = $t.Replace('<div class="cta-strip">', $html + "`r`n" + '<div class="cta-strip">')
    $where = 'enne CTA'
  } elseif ($t.Contains('<footer>')) {
    $t2 = $t.Replace('<footer>', $html + "`r`n" + '<footer>')
    $where = 'enne jalust'
  } else { Write-Host "  ANKRUT EI LEITUD: $file" -ForegroundColor Red; return }
  [IO.File]::WriteAllText($p, $t2, $enc)
  Write-Host "  lisatud ($where): $file" -ForegroundColor Green
  $script:changed++
}


$html = @'
<div class="divider-line"></div>

<!-- GATEWAY CROSS-LINK -->
<section class="section">
  <div class="sec-label">// more than one meter?</div>
  <h2 class="sec-title">Several SDM630s, one register map</h2>
  <div style="max-width:820px;margin:0 auto;background:var(--plate);border:2px solid var(--ink);border-radius:3px;padding:1.5rem 1.8rem">
    <p style="color:var(--body);line-height:1.75;margin:0 0 1.1rem">One SDM630 is easy. Ten of them on the same RS-485 line, read by a PLC that has a single Modbus connection, is a different job. ModbusManager Pro can poll every meter and republish just the values you need — total active power, per-phase currents, energy counters — as one common register map the PLC reads in a single request. The FLOAT32 pairs stay floats, or get scaled into integers if that is what the PLC block expects.</p>
    <a href="/modbus-gateway-software.html" style="font-family:'IBM Plex Mono',monospace;font-size:0.8rem;font-weight:600;color:var(--amber-ink);text-decoration:none;letter-spacing:0.04em;text-transform:uppercase">Modbus gateway software &rarr;</a>
  </div>
</section>
'@
Insert-Section 'eastron-sdm630-modbus.html' $html


$html = @'
<div class="divider-line"></div>

<!-- GATEWAY CROSS-LINK -->
<section class="section">
  <div class="sec-label">// sub-metering with many meters</div>
  <h2 class="sec-title">Forty SDM120s behind one address</h2>
  <div style="max-width:820px;margin:0 auto;background:var(--plate);border:2px solid var(--ink);border-radius:3px;padding:1.5rem 1.8rem">
    <p style="color:var(--body);line-height:1.75;margin:0 0 1.1rem">SDM120 meters are usually installed by the dozen — one per circuit, per tenant, per machine. Reading forty of them from a PLC means forty Modbus configurations in the control program. ModbusManager Pro polls them all on the RS-485 line and presents the registers you care about as one contiguous block, so the PLC or SCADA system reads a single slave and every meter lands at a predictable address.</p>
    <a href="/modbus-gateway-software.html" style="font-family:'IBM Plex Mono',monospace;font-size:0.8rem;font-weight:600;color:var(--amber-ink);text-decoration:none;letter-spacing:0.04em;text-transform:uppercase">Modbus gateway software &rarr;</a>
  </div>
</section>
'@
Insert-Section 'eastron-sdm120-modbus.html' $html


$html = @'
<div class="divider-line"></div>

<!-- GATEWAY CROSS-LINK -->
<section class="section">
  <div class="sec-label">// several drives on one line</div>
  <h2 class="sec-title">Many drives, one shared register map</h2>
  <div style="max-width:820px;margin:0 auto;background:var(--plate);border:2px solid var(--ink);border-radius:3px;padding:1.5rem 1.8rem">
    <p style="color:var(--body);line-height:1.75;margin:0 0 1.1rem">A line with several ACS580 drives means several Modbus nodes for the PLC to address. ModbusManager Pro can collect the status word, actual speed and current of every drive into one register map — and forward speed references written by the PLC back to the correct drive. During commissioning this lets you prove the data mapping works before the PLC program is finished.</p>
    <a href="/modbus-gateway-software.html" style="font-family:'IBM Plex Mono',monospace;font-size:0.8rem;font-weight:600;color:var(--amber-ink);text-decoration:none;letter-spacing:0.04em;text-transform:uppercase">Modbus gateway software &rarr;</a>
  </div>
</section>
'@
Insert-Section 'abb-acs580-modbus.html' $html


$html = @'
<div class="divider-line"></div>

<!-- GATEWAY CROSS-LINK -->
<section class="section">
  <div class="sec-label">// multi-drive systems</div>
  <h2 class="sec-title">Multiple ACS880 drives behind one address</h2>
  <div style="max-width:820px;margin:0 auto;background:var(--plate);border:2px solid var(--ink);border-radius:3px;padding:1.5rem 1.8rem">
    <p style="color:var(--body);line-height:1.75;margin:0 0 1.1rem">ACS880 installations are rarely a single drive. When a PLC or SCADA system needs a few values from each drive in a multi-drive line, ModbusManager Pro can poll them all and expose the selected registers as one Modbus TCP slave, converting data types and scaling on the way. Setpoints written into that map are routed back to the individual drive.</p>
    <a href="/modbus-gateway-software.html" style="font-family:'IBM Plex Mono',monospace;font-size:0.8rem;font-weight:600;color:var(--amber-ink);text-decoration:none;letter-spacing:0.04em;text-transform:uppercase">Modbus gateway software &rarr;</a>
  </div>
</section>
'@
Insert-Section 'abb-acs880-modbus.html' $html


$html = @'
<div class="divider-line"></div>

<!-- GATEWAY CROSS-LINK -->
<section class="section">
  <div class="sec-label">// a switchboard full of meters</div>
  <h2 class="sec-title">From many meters to one register map</h2>
  <div style="max-width:820px;margin:0 auto;background:var(--plate);border:2px solid var(--ink);border-radius:3px;padding:1.5rem 1.8rem">
    <p style="color:var(--body);line-height:1.75;margin:0 0 1.1rem">The PM5000 family shares a register map, which makes a switchboard full of them straightforward to read one meter at a time. Combining them for a control system is the harder part. ModbusManager Pro polls each meter — over RS-485 or Ethernet, mixed if needed — and republishes the selected registers as a single Modbus TCP slave, with the data types and scaling the PLC actually expects.</p>
    <a href="/modbus-gateway-software.html" style="font-family:'IBM Plex Mono',monospace;font-size:0.8rem;font-weight:600;color:var(--amber-ink);text-decoration:none;letter-spacing:0.04em;text-transform:uppercase">Modbus gateway software &rarr;</a>
  </div>
</section>
'@
Insert-Section 'schneider-powerlogic-pm5000-modbus.html' $html


$html = @'
<div class="divider-line"></div>

<!-- GATEWAY CROSS-LINK -->
<section class="section">
  <div class="sec-label">// beyond the inverters</div>
  <h2 class="sec-title">SmartLogger plus everything else in the plant</h2>
  <div style="max-width:820px;margin:0 auto;background:var(--plate);border:2px solid var(--ink);border-radius:3px;padding:1.5rem 1.8rem">
    <p style="color:var(--body);line-height:1.75;margin:0 0 1.1rem">The SmartLogger already concentrates the inverters behind it, but a plant is rarely only inverters: there are revenue meters, weather stations, trackers, sometimes a second SmartLogger. ModbusManager Pro can poll the SmartLogger over TCP and the other devices over RS-485 at the same time, then expose the plant values that matter — total power, irradiance, meter energy — as one register map for the SCADA system.</p>
    <a href="/modbus-gateway-software.html" style="font-family:'IBM Plex Mono',monospace;font-size:0.8rem;font-weight:600;color:var(--amber-ink);text-decoration:none;letter-spacing:0.04em;text-transform:uppercase">Modbus gateway software &rarr;</a>
  </div>
</section>
'@
Insert-Section 'huawei-smartlogger-modbus.html' $html


$html = @'
<div class="divider-line"></div>

<!-- GATEWAY CROSS-LINK -->
<section class="section">
  <div class="sec-label">// when the plc reads many devices</div>
  <h2 class="sec-title">One MB_CLIENT block instead of twelve</h2>
  <div style="max-width:820px;margin:0 auto;background:var(--plate);border:2px solid var(--ink);border-radius:3px;padding:1.5rem 1.8rem">
    <p style="color:var(--body);line-height:1.75;margin:0 0 1.1rem">Every device an S7-1200 talks to costs a connection, an MB_CLIENT call and its own configuration in TIA Portal. If the PLC only needs a handful of values from a dozen devices, ModbusManager Pro can do the collecting: it polls the devices, converts the data types, and serves one Modbus TCP slave that a single MB_CLIENT block reads. Setpoints written by the PLC are forwarded back to the right device.</p>
    <a href="/modbus-gateway-software.html" style="font-family:'IBM Plex Mono',monospace;font-size:0.8rem;font-weight:600;color:var(--amber-ink);text-decoration:none;letter-spacing:0.04em;text-transform:uppercase">Modbus gateway software &rarr;</a>
  </div>
</section>
'@
Insert-Section 'modbus-hmi-siemens-s7-1200.html' $html


$html = @'
<div class="divider-line"></div>

<!-- GATEWAY CROSS-LINK -->
<section class="section">
  <div class="sec-label">// fan arrays</div>
  <h2 class="sec-title">A wall of fans, one register map</h2>
  <div style="max-width:820px;margin:0 auto;background:var(--plate);border:2px solid var(--ink);border-radius:3px;padding:1.5rem 1.8rem">
    <p style="color:var(--body);line-height:1.75;margin:0 0 1.1rem">Fan arrays are the classic case: sixteen EC fans on one RS-485 line, each with its own speed setpoint and status registers. ModbusManager Pro can collect every fan’s speed, status and temperature into one register map, and write setpoints back to individual fans from a shared block — so the PLC or BMS addresses the array as one device instead of sixteen.</p>
    <a href="/modbus-gateway-software.html" style="font-family:'IBM Plex Mono',monospace;font-size:0.8rem;font-weight:600;color:var(--amber-ink);text-decoration:none;letter-spacing:0.04em;text-transform:uppercase">Modbus gateway software &rarr;</a>
  </div>
</section>
'@
Insert-Section 'modbus-hmi-ebm-papst.html' $html


$html = @'
<div class="divider-line"></div>

<!-- GATEWAY CROSS-LINK -->
<section class="section">
  <div class="sec-label">// beyond polling</div>
  <h2 class="sec-title">Something a polling tool does not do</h2>
  <div style="max-width:820px;margin:0 auto;background:var(--plate);border:2px solid var(--ink);border-radius:3px;padding:1.5rem 1.8rem">
    <p style="color:var(--body);line-height:1.75;margin:0 0 1.1rem">Polling tools show you registers. Merging registers from several devices into one map that a PLC can read — with data type and scale conversion in both directions, and writes forwarded back to the original device — is a different capability. It is built into ModbusManager Pro, and during commissioning it means you can prove a gateway design before ordering the hardware.</p>
    <a href="/modbus-gateway-software.html" style="font-family:'IBM Plex Mono',monospace;font-size:0.8rem;font-weight:600;color:var(--amber-ink);text-decoration:none;letter-spacing:0.04em;text-transform:uppercase">Modbus gateway software &rarr;</a>
  </div>
</section>
'@
Insert-Section 'modbus-poll-alternative.html' $html


$html = @'
<div class="divider-line"></div>

<!-- GATEWAY CROSS-LINK -->
<section class="section">
  <div class="sec-label">// dashboards across many devices</div>
  <h2 class="sec-title">One dashboard, devices on different buses</h2>
  <div style="max-width:820px;margin:0 auto;background:var(--plate);border:2px solid var(--ink);border-radius:3px;padding:1.5rem 1.8rem">
    <p style="color:var(--body);line-height:1.75;margin:0 0 1.1rem">A dashboard is easiest when every value comes from one connection. If your values are spread across a serial line and several IP addresses, the gateway can merge them into a single register map first — then the dashboard, the Historian and the alarm system all bind to one consistent set of addresses instead of many separate connections.</p>
    <a href="/modbus-gateway-software.html" style="font-family:'IBM Plex Mono',monospace;font-size:0.8rem;font-weight:600;color:var(--amber-ink);text-decoration:none;letter-spacing:0.04em;text-transform:uppercase">Modbus gateway software &rarr;</a>
  </div>
</section>
'@
Insert-Section 'modbus-hmi-dashboard.html' $html


$html = @'
<div class="divider-line"></div>

<!-- GATEWAY CROSS-LINK -->
<section class="section">
  <div class="sec-label">// logging many devices</div>
  <h2 class="sec-title">Log a whole installation from one map</h2>
  <div style="max-width:820px;margin:0 auto;background:var(--plate);border:2px solid var(--ink);border-radius:3px;padding:1.5rem 1.8rem">
    <p style="color:var(--body);line-height:1.75;margin:0 0 1.1rem">Logging becomes simpler when the values you want already sit in one place. The gateway can collect registers from every device — RTU and TCP together — into one common register map, with engineering units applied. The Historian then logs a tidy, consistent address range instead of chasing scattered devices and mismatched data types.</p>
    <a href="/modbus-gateway-software.html" style="font-family:'IBM Plex Mono',monospace;font-size:0.8rem;font-weight:600;color:var(--amber-ink);text-decoration:none;letter-spacing:0.04em;text-transform:uppercase">Modbus gateway software &rarr;</a>
  </div>
</section>
'@
Insert-Section 'modbus-data-logger-software.html' $html


$html = @'
<div class="divider-line"></div>

<!-- GATEWAY CROSS-LINK -->
<section class="section">
  <div class="sec-label">// alarms across many devices</div>
  <h2 class="sec-title">Alarms on values from the whole plant</h2>
  <div style="max-width:820px;margin:0 auto;background:var(--plate);border:2px solid var(--ink);border-radius:3px;padding:1.5rem 1.8rem">
    <p style="color:var(--body);line-height:1.75;margin:0 0 1.1rem">Alarm definitions are easier to maintain when every monitored value lives in one register map with proper engineering units. The gateway collects registers from all your devices and applies scale and type conversion first, so an alarm on “pump 3 pressure” points at a stable address rather than a raw count on a device-specific connection.</p>
    <a href="/modbus-gateway-software.html" style="font-family:'IBM Plex Mono',monospace;font-size:0.8rem;font-weight:600;color:var(--amber-ink);text-decoration:none;letter-spacing:0.04em;text-transform:uppercase">Modbus gateway software &rarr;</a>
  </div>
</section>
'@
Insert-Section 'modbus-alarm-software.html' $html


$html = @'
<div class="divider-line"></div>

<!-- GATEWAY CROSS-LINK -->
<section class="section">
  <div class="sec-label">// gateway</div>
  <h2 class="sec-title">Combining devices into one register map</h2>
  <div style="max-width:820px;margin:0 auto;background:var(--plate);border:2px solid var(--ink);border-radius:3px;padding:1.5rem 1.8rem">
    <p style="color:var(--body);line-height:1.75;margin:0 0 1.1rem">ModbusManager Pro can act as a Modbus gateway: it polls several RTU and TCP devices as a master and republishes the registers you select as a single Modbus TCP slave, with data type and scale conversion in both directions. The full walkthrough — endpoints, mapping rows, the PLC side and background operation — is on its own page.</p>
    <a href="/modbus-gateway-software.html" style="font-family:'IBM Plex Mono',monospace;font-size:0.8rem;font-weight:600;color:var(--amber-ink);text-decoration:none;letter-spacing:0.04em;text-transform:uppercase">Modbus gateway software &rarr;</a>
  </div>
</section>
'@
Insert-Section 'manual.html' $html


# ── AVALEHT: funktsioonikaart + lause Pro-lõigus ──
$p = (Resolve-Path 'index.html').Path
$t = [IO.File]::ReadAllText($p)
$orig = $t

$cardAnchor = '<h3>Alarm system <span class="pro-tag">PRO</span></h3>'
if ($t.Contains($cardAnchor) -and -not $t.Contains('Modbus gateway <span class="pro-tag">PRO</span>')) {
  $lines = $t -split "`r`n|`n"
  $new = New-Object System.Collections.Generic.List[string]
  $card = @'
    <div class="feat" style="border:1px solid #F2A90080"><div class="feat-icon">🔀</div><h3>Modbus gateway <span class="pro-tag">PRO</span></h3><p>Poll several RTU and TCP devices at once and republish the registers you choose as one common register map — with data type and scale conversion both ways. A PLC reads the whole installation over a single Modbus TCP connection. <a href="/modbus-gateway-software.html" style="color:var(--amber-ink)">Modbus gateway software →</a></p></div>
'@
  $done = $false
  foreach ($ln in $lines) {
    $new.Add($ln)
    if (-not $done -and $ln.Contains($cardAnchor)) { $new.Add($card.Trim()); $done = $true }
  }
  if ($done) { $t = ($new -join "`r`n"); Write-Host "  lisatud: avalehe funktsioonikaart" -ForegroundColor Green }
}

$proOld = 'Dashboard HMI</a> — gauges, trends and a fullscreen runtime mode.</p>'
$proNew = 'Dashboard HMI</a> — gauges, trends and a fullscreen runtime mode, and a <a href="/modbus-gateway-software.html" style="color:var(--amber-ink)">Modbus gateway</a> that merges several devices into one register map for a PLC.</p>'
if ($t.Contains($proOld)) {
  $t = $t.Replace($proOld, $proNew)
  Write-Host "  lisatud: avalehe Pro-lõigu lause" -ForegroundColor Green
}

if ($t -ne $orig) { [IO.File]::WriteAllText($p, $t, $enc); $changed++ }

Write-Host ""
Write-Host "Muudetud faile: $changed" -ForegroundColor Cyan
Write-Host ""
Write-Host "KONTROLL:" -ForegroundColor Yellow
Write-Host ("  gateway-linke kokku: " + (Select-String -Path *.html -SimpleMatch 'modbus-gateway-software.html').Count)
Write-Host ("  kontekstisektsioone: " + (Select-String -Path *.html -SimpleMatch 'GATEWAY CROSS-LINK').Count)
$bad = Select-String -Path index.html -SimpleMatch 'tab-gateway'
if ($bad) { Write-Host "  HOIATUS: index.html sisaldab rakenduse koodi!" -ForegroundColor Red } else { Write-Host "  index.html on koduleht (korras)" -ForegroundColor Green }
