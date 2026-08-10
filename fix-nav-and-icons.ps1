# fix-nav-and-icons.ps1
#
# ASENDAB varasema add-logging-cluster-links.ps1 - ARA seda enam kasuta.
# Pohjus: RTU nav-kirje on juba live'is (esimene skript sai jooksutatud), ja
# vana skript oleks selle teist korda juurde lisanud.
#
# See skript NORMALISEERIB nav-i ja jaluse olenemata praegusest seisust:
# ta korjab olemasolevad logimise alamkirjed maha ja kirjutab need kindlas
# jarjekorras tagasi. Voib jooksutada mitu korda, tulemus on sama.
#
# MIDA TEEB
#
# 1. Features menuu ja jaluse linkide ette RAKENDUSEGA SAMA ikoon:
#
#      Rakenduse tab       Kodulehe leht                       Ikoon
#      Slave/Addr Scan     modbus-scanner.html                 U+1F50D  luup
#      Dashboard           modbus-hmi-dashboard.html           U+1F4CA  tulpdiagramm
#      Historian           modbus-data-logger-software.html    U+1F4C8  touseb graafik
#      Alarms              modbus-alarm-software.html          U+1F514  kell
#      Gateway             modbus-gateway-software.html        U+1F500  segamine
#
#    Skanneri kirjel oli U+26A1 (valk). Valk on rakenduses SLAVE-tabi ikoon,
#    seega see oli vale funktsiooni mark. Nuud luup, nagu skanni-tabidel.
#
# 2. Kolm logimise alamlehte (RTU / Interval / CSV) saavad taande, MITTE ikooni:
#    neile ei vasta rakenduses eraldi tab, nad on Historiani alamteemad.
#    Jarjekord fikseeritakse: Data Logger -> RTU -> Interval -> CSV.
#
# 3. Skanneri kirje oli enamikul lehtedel KAHES rippmenuus (Features ja Guides).
#    Guides-duplikaat eemaldatakse; index.html oli juba korras.
#
# Kaivita mm-web kaustast:
#   powershell -ExecutionPolicy Bypass -File .\fix-nav-and-icons.ps1

$ErrorActionPreference = "Stop"

# href, nav-silt, jaluse-silt
$sub = @(
  @{ href = "modbus-rtu-rs485-data-logger.html";     nav = "RTU / RS-485 Logging"; foot = "RTU Logging" },
  @{ href = "modbus-logging-interval-deadband.html"; nav = "Interval &amp; Deadband"; foot = $null },
  @{ href = "modbus-to-csv-logging.html";            nav = "CSV Export"; foot = "CSV Export" }
)

# href, link-tekst, HTML-olem
$icons = @(
  @{ href = "modbus-hmi-dashboard.html";         label = "HMI Dashboard"; ent = "&#128202;" },
  @{ href = "modbus-data-logger-software.html";  label = "Data Logger";   ent = "&#128200;" },
  @{ href = "modbus-alarm-software.html";        label = "Alarms";        ent = "&#128276;" },
  @{ href = "modbus-gateway-software.html";      label = "Gateway";       ent = "&#128256;" }
)

$changed = 0

Get-ChildItem -Path . -Filter *.html | ForEach-Object {

    $text = [System.IO.File]::ReadAllText($_.FullName)
    $orig = $text

    # ── 1. skanner: valk -> luup, koik esinemised
    $text = [regex]::Replace($text, '(<a href="/modbus-scanner\.html"[^>]*>)&#9889; ', '$1&#128269; ')

    # ── 2. Guides duplikaat maha, esimene jaab
    $m = [regex]::Match($text, '\n *<a href="/modbus-scanner\.html" style="color:#9A6700;font-weight:600">[^<]*</a>')
    if ($m.Success) {
        $second = $text.IndexOf($m.Value, $m.Index + $m.Length)
        if ($second -ge 0) {
            $text = $text.Remove($second, $m.Value.Length)
        }
    }

    # ── 3. ikoonid (nav ja jalus korraga - muster ei soltu taandest)
    foreach ($i in $icons) {
        $pat = '(<a href="/' + [regex]::Escape($i.href) + '">)' + [regex]::Escape($i.label) + '</a>'
        $text = [regex]::Replace($text, $pat, '$1' + $i.ent + ' ' + $i.label + '</a>')
    }

    # ── 4. eemalda koik olemasolevad alamlehe read (nav ja jalus)
    foreach ($s in $sub) {
        $pat = '\n *<a href="/' + [regex]::Escape($s.href) + '"[^\n]*</a>'
        $text = [regex]::Replace($text, $pat, '')
    }

    # ── 5. nav grupp tagasi, kindlas jarjekorras (8 tuhikut)
    $navAnchor = "`n" + '        <a href="/modbus-data-logger-software.html">&#128200; Data Logger</a>'
    if ($text.Contains($navAnchor)) {
        $block = ""
        foreach ($s in $sub) {
            $block += "`n" + '        <a href="/' + $s.href + '" style="padding-left:1.5rem">' + $s.nav + '</a>'
        }
        $idx = $text.IndexOf($navAnchor)
        $text = $text.Insert($idx + $navAnchor.Length, $block)
    }

    # ── 6. jaluse grupp tagasi (4 tuhikut, ilma Interval-lehe)
    $ftAnchor = "`n" + '    <a href="/modbus-data-logger-software.html">&#128200; Data Logger</a>'
    if ($text.Contains($ftAnchor)) {
        $block = ""
        foreach ($s in $sub) {
            if ($s.foot) {
                $block += "`n" + '    <a href="/' + $s.href + '">' + $s.foot + '</a>'
            }
        }
        $idx = $text.IndexOf($ftAnchor)
        $text = $text.Insert($idx + $ftAnchor.Length, $block)
    }

    if ($text -ne $orig) {
        # kontroll: ukski alamleht ei tohi esineda ule kolme korra (nav + jalus + sisulink)
        foreach ($s in $sub) {
            $n = ([regex]::Matches($text, [regex]::Escape('href="/' + $s.href + '"'))).Count
            if ($n -gt 3) { throw "$($_.Name): $($s.href) esineb $n korda" }
        }
        [System.IO.File]::WriteAllText($_.FullName, $text, (New-Object System.Text.UTF8Encoding($false)))
        Write-Host ("  OK  {0}" -f $_.Name) -ForegroundColor Green
        $changed++
    } else {
        Write-Host ("  --  {0}  muutmata" -f $_.Name) -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "Normaliseeritud: $changed faili." -ForegroundColor Cyan

$left = Select-String -Path .\*.html -Pattern "&#9889; Modbus Scanner" -SimpleMatch -ErrorAction SilentlyContinue
if ($left) {
    Write-Host "HOIATUS - vana valgu-ikoon on veel alles:" -ForegroundColor Yellow
    $left | ForEach-Object { Write-Host ("  " + $_.Filename + ":" + $_.LineNumber) }
} else {
    Write-Host "Skanneri ikoon on koigil lehtedel luup." -ForegroundColor Green
}

Write-Host ""
Write-Host "Jargmine: git add -A ; git status ; git commit ; git push"
