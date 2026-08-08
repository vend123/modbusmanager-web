# add-rtu-logger-links.ps1
#
# Uus leht modbus-rtu-rs485-data-logger.html on lisatud, aga leht ilma
# navigatsioonita on pool tood. See skript teeb kaks asja KOIGIL lehtedel:
#
#   1. Features rippmenuusse kirje "RTU / RS-485 Logging" kohe "Data Logger" jarele
#   2. Jalusesse link "RTU Logging" kohe "Data Logger" jarele
#
# Idempotentne: kui kirje on juba olemas, jaetakse fail vahele. Voib mitu korda
# jooksutada, midagi ei dubleeru.
#
# Kaivita mm-web kaustast:
#   powershell -ExecutionPolicy Bypass -File .\add-rtu-logger-links.ps1

$ErrorActionPreference = "Stop"

# NB: ankrud algavad reavahetusega. Ilma selleta on jaluse muster (4 tuhikut)
# nav-mustri (8 tuhikut) ALAMSONE, ja .Replace() lisaks jaluse lingi ka nav-i
# sisse. Reavahetus teeb mustrid uksteist valistavaks.
$navAnchor = "`n" + '        <a href="/modbus-data-logger-software.html">Data Logger</a>'
$navNew    = "`n" + '        <a href="/modbus-rtu-rs485-data-logger.html">RTU / RS-485 Logging</a>'

$footAnchor = "`n" + '    <a href="/modbus-data-logger-software.html">Data Logger</a>'
$footNew    = "`n" + '    <a href="/modbus-rtu-rs485-data-logger.html">RTU Logging</a>'

$navCount  = 0
$footCount = 0
$files     = 0

Get-ChildItem -Path . -Filter *.html | ForEach-Object {

    $text = [System.IO.File]::ReadAllText($_.FullName)
    $orig = $text
    $did  = @()

    # ── 1. nav
    if ($text.Contains($navNew)) {
        $did += "nav juba olemas"
    } elseif ($text.Contains($navAnchor)) {
        $text = $text.Replace($navAnchor, $navAnchor + $navNew)
        $did += "nav lisatud"
        $navCount++
    } else {
        $did += "nav ankrut ei ole"
    }

    # ── 2. jalus
    if ($text.Contains($footNew)) {
        $did += "jalus juba olemas"
    } elseif ($text.Contains($footAnchor)) {
        $text = $text.Replace($footAnchor, $footAnchor + $footNew)
        $did += "jalus lisatud"
        $footCount++
    } else {
        $did += "jaluse ankrut ei ole"
    }

    if ($text -ne $orig) {
        # kontroll: kumbki kirje tohib esineda ainult uks kord
        $n1 = ([regex]::Matches($text, [regex]::Escape($navNew))).Count
        $n2 = ([regex]::Matches($text, [regex]::Escape($footNew))).Count
        if ($n1 -gt 1) { throw "$($_.Name): nav kirje dubleerus ($n1)" }
        if ($n2 -gt 1) { throw "$($_.Name): jaluse kirje dubleerus ($n2)" }

        [System.IO.File]::WriteAllText($_.FullName, $text, (New-Object System.Text.UTF8Encoding($false)))
        Write-Host ("  OK  {0,-45} {1}" -f $_.Name, ($did -join ", ")) -ForegroundColor Green
        $files++
    } else {
        Write-Host ("  --  {0,-45} {1}" -f $_.Name, ($did -join ", ")) -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "Muudetud $files faili: $navCount nav-kirjet, $footCount jaluse linki." -ForegroundColor Cyan
Write-Host ""
Write-Host "Jargmine: git add -A ; git status ; git commit ; git push"
Write-Host "Seejarel Search Console -> URL Inspection -> Request Indexing uuele lehele."
