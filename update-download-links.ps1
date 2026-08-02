# Asendab KÕIK Pro allalaadimislingid v1.7.0 -> v1.8.0 kõigil HTML-lehtedel.
# Jooksuta mm-web kaustas. Ohutu korduvalt (idempotentne).
# Kasutab literaalset .Replace() (mitte regex), et vältida escaping-vigu.

$ErrorActionPreference = 'Stop'
$enc = New-Object System.Text.UTF8Encoding($false)

# Vana -> uus (tag JA failinimi)
$oldUrl = 'pro-v1.7.0/Modbus.Manager.Pro.Setup.1.7.0.exe'
$newUrl = 'pro-v1.8.0/Modbus.Manager.Pro.Setup.1.8.0.exe'

# Nähtav versiooninumber tekstis (nt "Pro 1.7.0", "v1.7.0") — ainult Pro kontekstis ettevaatlik.
# Neid EI asenda automaatselt, sest "1.7.0" võib esineda Standard-i juures ka.
# Kui tahad ka nähtava teksti uuendada, tee see käsitsi või ütle.

$changed = 0
$totalReplacements = 0

Get-ChildItem -Filter *.html | Sort-Object Name | ForEach-Object {
  $p = $_.FullName
  $t = [IO.File]::ReadAllText($p)
  $before = ([regex]::Matches($t, [regex]::Escape($oldUrl))).Count
  if ($before -eq 0) { return }
  $t2 = $t.Replace($oldUrl, $newUrl)
  [IO.File]::WriteAllText($p, $t2, $enc)
  Write-Host ("  {0,-42} {1} linki" -f $_.Name, $before) -ForegroundColor Green
  $script:changed++
  $script:totalReplacements += $before
}

Write-Host ""
Write-Host "Muudetud faile: $changed" -ForegroundColor Cyan
Write-Host "Asendatud linke kokku: $totalReplacements" -ForegroundColor Cyan

# Kontroll: kas midagi v1.7.0-st jäi maha?
$leftover = (Select-String -Path *.html -SimpleMatch 'pro-v1.7.0').Count
if ($leftover -gt 0) {
  Write-Host "HOIATUS: $leftover viidet 'pro-v1.7.0' jäi veel alles!" -ForegroundColor Yellow
} else {
  Write-Host "Kontroll: uhtki pro-v1.7.0 linki ei jaanud alles (OK)" -ForegroundColor Green
}
