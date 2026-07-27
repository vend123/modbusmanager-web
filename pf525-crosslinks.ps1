# Lisab sisemised lingid uuele PowerFlex 525 lehele.
# Jooksuta mm-web kaustas:
#   powershell -ExecutionPolicy Bypass -File .\pf525-crosslinks.ps1
# Ohutu korduvalt jooksutada.

$ErrorActionPreference = 'Stop'
$enc = New-Object System.Text.UTF8Encoding($false)
$changed = 0

function Insert-Section([string]$file, [string]$html) {
  if (-not (Test-Path $file)) { Write-Host "  puudub:  $file" -ForegroundColor DarkGray; return }
  $p = (Resolve-Path $file).Path
  $t = [IO.File]::ReadAllText($p)
  if ($t.Contains('PF525 CROSS-LINK')) { Write-Host "  juba OK: $file" -ForegroundColor DarkGray; return }
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

<!-- PF525 CROSS-LINK -->
<section class="section">
  <div class="sec-label">// other drives</div>
  <h2 class="sec-title">Allen-Bradley drive on the same panel?</h2>
  <div style="max-width:820px;margin:0 auto;background:var(--plate);border:2px solid var(--ink);border-radius:3px;padding:1.5rem 1.8rem">
    <p style="color:var(--body);line-height:1.75;margin:0 0 1.1rem">If the same line mixes ABB and Rockwell drives, the awkward part is not the register list but the addressing: PowerFlex documentation numbers registers in a way that lands one off on many Modbus masters. The PowerFlex 525 page explains why that happens and how to settle it on the drive itself.</p>
    <a href="/powerflex-525-modbus.html" style="font-family:'IBM Plex Mono',monospace;font-size:0.8rem;font-weight:600;color:var(--amber-ink);text-decoration:none;letter-spacing:0.04em;text-transform:uppercase">PowerFlex 525 Modbus addressing &rarr;</a>
  </div>
</section>
'@
Insert-Section 'abb-acs580-modbus.html' $html


$html = @'
<div class="divider-line"></div>

<!-- PF525 CROSS-LINK -->
<section class="section">
  <div class="sec-label">// other drives</div>
  <h2 class="sec-title">Mixed ABB and Rockwell installations</h2>
  <div style="max-width:820px;margin:0 auto;background:var(--plate);border:2px solid var(--ink);border-radius:3px;padding:1.5rem 1.8rem">
    <p style="color:var(--body);line-height:1.75;margin:0 0 1.1rem">Retrofits often leave two drive families on one bus. The ACS880 register map is straightforward; PowerFlex addressing is the one that costs an afternoon, because the documented address and the address your master wants can differ by one.</p>
    <a href="/powerflex-525-modbus.html" style="font-family:'IBM Plex Mono',monospace;font-size:0.8rem;font-weight:600;color:var(--amber-ink);text-decoration:none;letter-spacing:0.04em;text-transform:uppercase">PowerFlex 525 Modbus addressing &rarr;</a>
  </div>
</section>
'@
Insert-Section 'abb-acs880-modbus.html' $html


$html = @'
<div class="divider-line"></div>

<!-- PF525 CROSS-LINK -->
<section class="section">
  <div class="sec-label">// reading drives from a plc</div>
  <h2 class="sec-title">When the PLC talks to a PowerFlex drive</h2>
  <div style="max-width:820px;margin:0 auto;background:var(--plate);border:2px solid var(--ink);border-radius:3px;padding:1.5rem 1.8rem">
    <p style="color:var(--body);line-height:1.75;margin:0 0 1.1rem">Reading a Rockwell drive from a Siemens PLC over Modbus RTU is common in mixed plants, and the first obstacle is always addressing rather than the protocol. Confirm the offset and scaling from a laptop before writing the MB_CLIENT logic.</p>
    <a href="/powerflex-525-modbus.html" style="font-family:'IBM Plex Mono',monospace;font-size:0.8rem;font-weight:600;color:var(--amber-ink);text-decoration:none;letter-spacing:0.04em;text-transform:uppercase">PowerFlex 525 Modbus addressing &rarr;</a>
  </div>
</section>
'@
Insert-Section 'modbus-hmi-siemens-s7-1200.html' $html


$html = @'
<div class="divider-line"></div>

<!-- PF525 CROSS-LINK -->
<section class="section">
  <div class="sec-label">// worked example</div>
  <h2 class="sec-title">A real addressing problem, start to finish</h2>
  <div style="max-width:820px;margin:0 auto;background:var(--plate);border:2px solid var(--ink);border-radius:3px;padding:1.5rem 1.8rem">
    <p style="color:var(--body);line-height:1.75;margin:0 0 1.1rem">The clearest test of a Modbus tool is a device whose documentation is ambiguous. PowerFlex 520-series drives qualify: the manual itself notes that addresses may need a +1 offset depending on the master. Seeing decimal, hex and binary at once turns that into a ten-second check.</p>
    <a href="/powerflex-525-modbus.html" style="font-family:'IBM Plex Mono',monospace;font-size:0.8rem;font-weight:600;color:var(--amber-ink);text-decoration:none;letter-spacing:0.04em;text-transform:uppercase">PowerFlex 525 Modbus addressing &rarr;</a>
  </div>
</section>
'@
Insert-Section 'modbus-poll-alternative.html' $html


Write-Host ""
Write-Host "Muudetud faile: $changed" -ForegroundColor Cyan
Write-Host ("  PF525-linke kokku: " + (Select-String -Path *.html -SimpleMatch 'powerflex-525-modbus.html').Count)
$bad = Select-String -Path index.html -SimpleMatch 'tab-gateway'
if ($bad) { Write-Host "  HOIATUS: index.html sisaldab rakenduse koodi!" -ForegroundColor Red } else { Write-Host "  index.html on koduleht (korras)" -ForegroundColor Green }
