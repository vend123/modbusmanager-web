# rename-ga-event.ps1
# Renames the custom GA event 'file_download' -> 'trial_download' in all .html files.
#
# WHY: 'file_download' is also a GA4 built-in Enhanced Measurement event that fires
# automatically on .exe / .zip / .pdf link clicks. Using the same name for our own
# button tracking merged two different behaviours into one metric and double-counted
# every installer click. Renaming ours separates them:
#   trial_download  = someone clicked a Standard/Pro installer button   (our event)
#   file_download   = someone grabbed a free asset: zip, pdf            (GA4 automatic)
#
# Run from the website folder:  powershell -ExecutionPolicy Bypass -File .\rename-ga-event.ps1
# index.html is skipped - it is delivered already fixed.

$ErrorActionPreference = "Stop"
$old = "gtag('event', 'file_download'"
$new = "gtag('event', 'trial_download'"

$total = 0
$touched = 0

Get-ChildItem -Path . -Filter *.html | ForEach-Object {

    if ($_.Name -eq "index.html") {
        Write-Host ("SKIP  {0,-45} (delivered pre-fixed)" -f $_.Name) -ForegroundColor DarkGray
        return
    }

    $text = [System.IO.File]::ReadAllText($_.FullName)
    $count = ([regex]::Matches($text, [regex]::Escape($old))).Count

    if ($count -eq 0) {
        Write-Host ("  --  {0,-45} no custom download events" -f $_.Name) -ForegroundColor DarkGray
        return
    }

    $text = $text.Replace($old, $new)

    # safety: nothing left behind, nothing lost
    if ($text.Contains($old)) { throw "$($_.Name): replacement incomplete" }
    $newCount = ([regex]::Matches($text, [regex]::Escape($new))).Count
    if ($newCount -lt $count) { throw "$($_.Name): expected >= $count new events, got $newCount" }

    [System.IO.File]::WriteAllText($_.FullName, $text, (New-Object System.Text.UTF8Encoding($false)))

    Write-Host ("  OK  {0,-45} {1} event(s) renamed" -f $_.Name, $count) -ForegroundColor Green
    $total += $count
    $touched++
}

Write-Host ""
Write-Host "Done: $total event(s) renamed across $touched file(s)." -ForegroundColor Cyan
Write-Host "Next: git add -A ; git status ; git commit ; git push"
