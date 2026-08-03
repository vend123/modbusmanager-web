# Lisab modbus-scanner.html:
#  1. Guides-rippmenüü algusesse (esiletõstetuna) kõigil HTML-lehtedel
#  2. sitemap.xml-i
# Jooksuta mm-web kaustas. Ohutu korduvalt (idempotentne).

$ErrorActionPreference = 'Stop'
$enc = New-Object System.Text.UTF8Encoding($false)

# ── 1. Nav: lisa scanner-link Guides-menüü algusesse ──
$anchor = '<div class="nav-drop-menu">'
$newLink = '<div class="nav-drop-menu">' + "`r`n" + `
  '        <a href="/modbus-scanner.html" style="color:#9A6700;font-weight:600">&#9889; Modbus Scanner</a>'

$navChanged = 0
Get-ChildItem -Filter *.html | Sort-Object Name | ForEach-Object {
  if ($_.Name -eq 'modbus-scanner.html') { return }  # ise-lehele mitte
  $p = $_.FullName
  $t = [IO.File]::ReadAllText($p)
  if ($t.Contains('/modbus-scanner.html')) { return }  # juba olemas
  if (-not $t.Contains($anchor)) { return }            # pole Guides-menüüd
  $t2 = $t.Replace($anchor, $newLink)
  [IO.File]::WriteAllText($p, $t2, $enc)
  Write-Host "  nav lisatud: $($_.Name)" -ForegroundColor Green
  $script:navChanged++
}
Write-Host "Nav muudetud: $navChanged faili" -ForegroundColor Cyan

# ── 2. Sitemap ──
if (Test-Path 'sitemap.xml') {
  $sm = [IO.File]::ReadAllText('sitemap.xml')
  if (-not $sm.Contains('modbus-scanner.html')) {
    $entry = "  <url><loc>https://modbusmanager.com/modbus-scanner.html</loc><changefreq>monthly</changefreq><priority>0.8</priority></url>"
    $sm = $sm.Replace('</urlset>', $entry + "`r`n</urlset>")
    [IO.File]::WriteAllText('sitemap.xml', $sm, $enc)
    Write-Host "Sitemap: scanner-leht lisatud" -ForegroundColor Green
  } else {
    Write-Host "Sitemap: juba olemas" -ForegroundColor DarkGray
  }
} else {
  Write-Host "HOIATUS: sitemap.xml puudub" -ForegroundColor Yellow
}

# ── kontroll ──
Write-Host ""
Write-Host ("modbus-scanner.html viiteid kokku: " + (Select-String -Path *.html -SimpleMatch '/modbus-scanner.html').Count) -ForegroundColor Cyan
if (Test-Path 'modbus-scanner.html') {
  Write-Host "modbus-scanner.html on kaustas (OK)" -ForegroundColor Green
} else {
  Write-Host "HOIATUS: modbus-scanner.html pole kaustas! Kopeeri see siia." -ForegroundColor Red
}
if (Test-Path 'og-scanner.png') {
  Write-Host "og-scanner.png on kaustas (OK)" -ForegroundColor Green
} else {
  Write-Host "HOIATUS: og-scanner.png pole kaustas! Kopeeri see siia." -ForegroundColor Red
}
