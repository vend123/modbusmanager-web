# bump-1.4.2-and-1.8.2.ps1
#
# Vahetab MÕLEMA toote allalaadimislingid kõigil lehtedel:
#   Standard  v1.4.1      -> v1.4.2
#   Pro       pro-v1.8.1  -> pro-v1.8.2
#
# index.html jäetakse vahele — see on tarnitud juba parandatuna ja sisaldab
# lisaks linkidele ka SHA-256 kontrollsummasid, versioonisilte ja JSON-LD-d.
#
# Käivita mm-web kaustast:
#   powershell -ExecutionPolicy Bypass -File .\bump-1.4.2-and-1.8.2.ps1

$ErrorActionPreference = "Stop"

$pairs = @(
  @{ name = "Standard"
     old  = "releases/download/v1.4.1/Modbus.Manager.Setup.1.4.1.exe"
     new  = "releases/download/v1.4.2/Modbus.Manager.Setup.1.4.2.exe" },
  @{ name = "Pro"
     old  = "releases/download/pro-v1.8.1/Modbus.Manager.Pro.Setup.1.8.1.exe"
     new  = "releases/download/pro-v1.8.2/Modbus.Manager.Pro.Setup.1.8.2.exe" }
)

$total = 0
$files = 0

Get-ChildItem -Path . -Filter *.html | ForEach-Object {

    if ($_.Name -eq "index.html") {
        Write-Host ("SKIP  {0,-45} (tarnitud eraldi)" -f $_.Name) -ForegroundColor DarkGray
        return
    }

    $text = [System.IO.File]::ReadAllText($_.FullName)
    $orig = $text
    $hits = @()

    foreach ($p in $pairs) {
        $n = ([regex]::Matches($text, [regex]::Escape($p.old))).Count
        if ($n -gt 0) {
            $text = $text.Replace($p.old, $p.new)
            if ($text.Contains($p.old)) { throw "$($_.Name): $($p.name) asendus jäi poolikuks" }
            $hits += "$($p.name) x$n"
            $total += $n
        }
    }

    if ($text -ne $orig) {
        [System.IO.File]::WriteAllText($_.FullName, $text, (New-Object System.Text.UTF8Encoding($false)))
        Write-Host ("  OK  {0,-45} {1}" -f $_.Name, ($hits -join ", ")) -ForegroundColor Green
        $files++
    } else {
        Write-Host ("  --  {0,-45} linke ei ole" -f $_.Name) -ForegroundColor DarkGray
    }
}

Write-Host ""
Write-Host "Kokku $total linki $files failis." -ForegroundColor Cyan

# Kontroll: vanu viiteid ei tohi järele jääda
$left = Select-String -Path .\*.html -Pattern "Setup\.1\.4\.1\.exe","Pro\.Setup\.1\.8\.1\.exe" -ErrorAction SilentlyContinue
if ($left) {
    Write-Host "HOIATUS - vanu viiteid on veel alles:" -ForegroundColor Yellow
    $left | ForEach-Object { Write-Host ("  " + $_.Filename + ":" + $_.LineNumber) }
} else {
    Write-Host "Vanu 1.4.1 / 1.8.1 viiteid ei ole enam uheski failis." -ForegroundColor Green
}

Write-Host ""
Write-Host "Jargmine: git add -A ; git status ; git commit ; git push"
