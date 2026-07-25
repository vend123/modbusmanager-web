# Parandab avalehe "Workspace files" kaardi teksti — eemaldab valed vaited
# (gateway mapping ja connections EI salvestu workspace-faili).
# Jooksuta mm-web kaustas. Ohutu korduvalt jooksutada.

$ErrorActionPreference = 'Stop'
$enc = New-Object System.Text.UTF8Encoding($false)
$p = (Resolve-Path 'index.html').Path
$t = [IO.File]::ReadAllText($p)

$old = 'Save an entire setup — connections, poll windows, tags, dashboards and gateway mapping — into one workspace file. Reopen it next week or hand it to a colleague and everything is exactly as you left it.'
$new = 'Save a whole setup — poll windows, tags, dashboards, chart series, slave blocks and scripts — into one workspace file. Reopen it next week or hand it to a colleague and everything is exactly as you left it.'

if ($t.Contains($new)) {
  Write-Host "juba parandatud" -ForegroundColor DarkGray
} elseif ($t.Contains($old)) {
  [IO.File]::WriteAllText($p, $t.Replace($old, $new), $enc)
  Write-Host "parandatud: Workspace files kaardi tekst" -ForegroundColor Green
} else {
  Write-Host "ANKRUT EI LEITUD - kontrolli kaardi teksti kasitsi" -ForegroundColor Red
}

Write-Host ""
if ((Select-String -Path index.html -SimpleMatch 'gateway mapping — into one workspace').Count -eq 0) {
  Write-Host "OK: vale vaide eemaldatud" -ForegroundColor Green
} else {
  Write-Host "HOIATUS: vale vaide on veel lehel" -ForegroundColor Red
}
