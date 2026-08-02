# Lisab email-capture.js skripti KÕIGILE lehtedele (enne </body>).
# Skript püüab allalaadimisklõpsud ja näitab vabatahtlikku e-posti paneeli.
# Jooksuta mm-web kaustas. Ohutu korduvalt jooksutada.

$ErrorActionPreference = 'Stop'
$enc = New-Object System.Text.UTF8Encoding($false)
$changed = 0
$tag = '<script src="/email-capture.js" defer></script>'

Get-ChildItem -Filter *.html | Sort-Object Name | ForEach-Object {
  $p = $_.FullName
  $t = [IO.File]::ReadAllText($p)
  if ($t.Contains('email-capture.js')) { Write-Host "  juba OK: $($_.Name)" -ForegroundColor DarkGray; return }
  if (-not $t.Contains('</body>')) { Write-Host "  </body> puudub: $($_.Name)" -ForegroundColor Yellow; return }
  # lisa viimase </body> ette
  $idx = $t.LastIndexOf('</body>')
  $t2 = $t.Substring(0, $idx) + $tag + "`r`n" + $t.Substring($idx)
  [IO.File]::WriteAllText($p, $t2, $enc)
  Write-Host "  lisatud: $($_.Name)" -ForegroundColor Green
  $script:changed++
}

Write-Host ""
Write-Host "Muudetud faile: $changed" -ForegroundColor Cyan
Write-Host ("  email-capture.js viiteid: " + (Select-String -Path *.html -SimpleMatch 'email-capture.js').Count)
if (-not (Test-Path 'email-capture.js')) {
  Write-Host "  HOIATUS: email-capture.js pole kaustas! Kopeeri see siia." -ForegroundColor Red
} else {
  Write-Host "  email-capture.js on kaustas (OK)" -ForegroundColor Green
}
