# align-og-titles.ps1
#
# MIKS: Google naitas kolmel lehel SERP-is tapselt og:title vaartust, mitte
# meie <title>-t. og:title on <title>-le konkureeriv signaal, ja kui need
# lahku laavad, voib Google valida og:title. Kolm lehte kuuest kaotasid nii
# 3. augustil tehtud pealkirjatoo taielikult.
#
# MIDA: loeb iga lehe enda <title> sisu ja kirjutab selle ka og:title'sse ja
# twitter:title'sse. Vaartusi ei ole siin skriptis kovakodeeritud - nii ei saa
# tekkida olukorda, kus skript ja fail lahevad lahku.
#
# Kaivita mm-web kaustast:
#   powershell -ExecutionPolicy Bypass -File .\align-og-titles.ps1

$ErrorActionPreference = "Stop"

$pages = @(
    "huawei-smartlogger-modbus.html",
    "schneider-powerlogic-pm5000-modbus.html",
    "eastron-sdm120-modbus.html",
    "eastron-sdm630-modbus.html",
    "modbus-poll-alternative.html",
    "yaskawa-v1000-modbus.html"
)

$changed = 0

foreach ($name in $pages) {

    if (-not (Test-Path $name)) {
        Write-Host ("PUUDUB  {0}" -f $name) -ForegroundColor Yellow
        continue
    }

    $text = [System.IO.File]::ReadAllText($name)

    # 1. loe lehe enda <title>
    $mTitle = [regex]::Match($text, '(?s)<title>(.*?)</title>')
    if (-not $mTitle.Success) { throw "$name : <title> puudub" }
    $title = $mTitle.Groups[1].Value.Trim()

    # 2. leia praegused og:title ja twitter:title
    $mOg = [regex]::Match($text, '<meta property="og:title" content="(.*?)">')
    $mTw = [regex]::Match($text, '<meta name="twitter:title" content="(.*?)">')
    if (-not $mOg.Success) { throw "$name : og:title puudub" }
    if (-not $mTw.Success) { throw "$name : twitter:title puudub" }

    $oldOg = $mOg.Groups[1].Value
    $oldTw = $mTw.Groups[1].Value

    if ($oldOg -eq $title -and $oldTw -eq $title) {
        Write-Host ("  --   {0,-42} juba kooskolas" -f $name) -ForegroundColor DarkGray
        continue
    }

    # 3. asenda - taielik silt korraga, et sisu ei satuks mujale
    $text = $text.Replace(
        '<meta property="og:title" content="' + $oldOg + '">',
        '<meta property="og:title" content="' + $title + '">')
    $text = $text.Replace(
        '<meta name="twitter:title" content="' + $oldTw + '">',
        '<meta name="twitter:title" content="' + $title + '">')

    # 4. kontroll enne kirjutamist
    $chkOg = [regex]::Match($text, '<meta property="og:title" content="(.*?)">').Groups[1].Value
    $chkTw = [regex]::Match($text, '<meta name="twitter:title" content="(.*?)">').Groups[1].Value
    if ($chkOg -ne $title) { throw "$name : og:title asendus ebaonnestus" }
    if ($chkTw -ne $title) { throw "$name : twitter:title asendus ebaonnestus" }

    [System.IO.File]::WriteAllText($name, $text, (New-Object System.Text.UTF8Encoding($false)))

    Write-Host ("  OK   {0}" -f $name) -ForegroundColor Green
    Write-Host ("       vana og : {0}" -f $oldOg) -ForegroundColor DarkGray
    Write-Host ("       uus  og : {0}" -f $title)
    $changed++
}

Write-Host ""
Write-Host "Kooskolla viidud: $changed lehte." -ForegroundColor Cyan
Write-Host "Jargmine: git add -A ; git status ; git commit ; git push"
Write-Host "Seejarel Search Console -> URL Inspection -> Request Indexing nendele lehtedele."
