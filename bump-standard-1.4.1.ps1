# bump-standard-1.4.1.ps1
#
# Vahetab Standardi allalaadimislingid v1.4.0 -> v1.4.1 kõigil lehtedel.
# index.html jäetakse vahele — see on tarnitud juba parandatuna (seal on ka
# uus SHA-256 kontrollsumma ja versioonisilt, mida siin skriptis ei ole).
#
# Pro linke (pro-v1.8.0) EI puututa.
#
# Käivita mm-web kaustast:
#   powershell -ExecutionPolicy Bypass -File .\bump-standard-1.4.1.ps1

$ErrorActionPreference = "Stop"

$old = "releases/download/v1.4.0/Modbus.Manager.Setup.1.4.0.exe"
$new = "releases/download/v1.4.1/Modbus.Manager.Setup.1.4.1.exe"

$total = 0
$touched = 0

Get-ChildItem -Path . -Filter *.html | ForEach-Object {

    if ($_.Name -eq "index.html") {
        Write-Host ("SKIP  {0,-45} (tarnitud eraldi, sisaldab ka SHA-256)" -f $_.Name) -ForegroundColor DarkGray
        return
    }

    $text = [System.IO.File]::ReadAllText($_.FullName)
    $count = ([regex]::Matches($text, [regex]::Escape($old))).Count

    if ($count -eq 0) {
        Write-Host ("  --  {0,-45} Standardi linki ei ole" -f $_.Name) -ForegroundColor DarkGray
        return
    }

    $text = $text.Replace($old, $new)

    if ($text.Contains($old)) { throw "$($_.Name): asendus jäi poolikuks" }
    if (-not $text.Contains($new)) { throw "$($_.Name): uus link puudub" }

    [System.IO.File]::WriteAllText($_.FullName, $text, (New-Object System.Text.UTF8Encoding($false)))

    Write-Host ("  OK  {0,-45} {1} link" -f $_.Name, $count) -ForegroundColor Green
    $total += $count
    $touched++
}

Write-Host ""
Write-Host "Kokku: $total link $touched failis." -ForegroundColor Cyan

# Kontroll: kas kuhugi jäi veel vana viide
$left = Select-String -Path .\*.html -Pattern "Modbus\.Manager\.Setup\.1\.4\.0\.exe" -SimpleMatch -ErrorAction SilentlyContinue
if ($left) {
    Write-Host "HOIATUS - vanu viiteid on veel alles:" -ForegroundColor Yellow
    $left | ForEach-Object { Write-Host ("  " + $_.Filename + ":" + $_.LineNumber) }
} else {
    Write-Host "Vanu v1.4.0 viiteid ei ole enam üheski failis." -ForegroundColor Green
}

Write-Host ""
Write-Host "Järgmine: git add -A ; git status ; git commit ; git push"
