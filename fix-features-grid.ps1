# Parandab avalehe funktsioonide ruudustiku: 17 -> 18 kaarti, et poolik rida
# ei jätaks musta ala (features-grid taust on tume, gap 2px).
# Jooksuta mm-web kaustas. Ohutu korduvalt jooksutada.

$ErrorActionPreference = 'Stop'
$enc = New-Object System.Text.UTF8Encoding($false)
$p = (Resolve-Path 'index.html').Path
$t = [IO.File]::ReadAllText($p)

if ($t.Contains('<h3>Workspace files</h3>')) {
  Write-Host "juba lisatud - midagi ei muudetud" -ForegroundColor DarkGray
} else {
  $anchor = '<h3>100% offline</h3>'
  if (-not $t.Contains($anchor)) { Write-Host "ANKRUT EI LEITUD" -ForegroundColor Red; exit 1 }

  $card = @'
    <div class="feat"><div class="feat-icon">💾</div><h3>Workspace files</h3><p>Save an entire setup — connections, poll windows, tags, dashboards and gateway mapping — into one workspace file. Reopen it next week or hand it to a colleague and everything is exactly as you left it.</p></div>
'@

  $lines = $t -split "`r`n|`n"
  $out = New-Object System.Collections.Generic.List[string]
  $done = $false
  foreach ($ln in $lines) {
    $out.Add($ln)
    if (-not $done -and $ln.Contains($anchor)) { $out.Add($card.Trim()); $done = $true }
  }
  if (-not $done) { Write-Host "sisestus ebaonnestus" -ForegroundColor Red; exit 1 }
  [IO.File]::WriteAllText($p, ($out -join "`r`n"), $enc)
  Write-Host "lisatud: Workspace files kaart" -ForegroundColor Green
}

$n = ([regex]::Matches([IO.File]::ReadAllText($p), '<div class="feat"')).Count
Write-Host ""
Write-Host "Funktsioonikaarte kokku: $n" -ForegroundColor Cyan
foreach ($cols in 3,2,1) {
  $r = $n % $cols
  if ($r -eq 0) { Write-Host ("  $cols veergu: taidetud") -ForegroundColor Green }
  else { Write-Host ("  $cols veergu: " + ($cols-$r) + " tuhja lahtrit (must ala)") -ForegroundColor Yellow }
}
