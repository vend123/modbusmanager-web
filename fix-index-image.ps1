# Tostab index.html-is olevad base64-pildid failiks valja.
# Sama 181 kB ekraanipilt on lehel KAKS korda base64-na (482 kB HTML-i sees).
# Failina laetakse see uks kord ja jaab brauseri vahemallu.
# Eeldab, et screenshot-main.png on samas kaustas.
# Jooksuta mm-web kaustas. Ohutu korduvalt jooksutada.

$ErrorActionPreference = 'Stop'
$enc = New-Object System.Text.UTF8Encoding($false)

if (-not (Test-Path 'screenshot-main.png')) {
  Write-Host "VIGA: screenshot-main.png puudub sellest kaustast." -ForegroundColor Red
  exit 1
}

$p = (Resolve-Path 'index.html').Path
$t = [IO.File]::ReadAllText($p)
$before = $t.Length

$n = ([regex]::Matches($t, 'data:image/png;base64,[A-Za-z0-9+/=]{5000,}')).Count
if ($n -eq 0) {
  Write-Host "base64-pilte ei leitud - ilmselt juba parandatud" -ForegroundColor DarkGray
} else {
  Write-Host "leitud $n suurt base64-pilti" -ForegroundColor Cyan
  $t = [regex]::Replace($t, 'data:image/png;base64,[A-Za-z0-9+/=]{5000,}', 'screenshot-main.png')

  # lisa alt-tekst lightboxi pildile (sellel puudus)
  $old = '<img src="screenshot-main.png" style="max-width:95vw'
  $new = '<img src="screenshot-main.png" alt="ModbusManager Pro dashboard and register view, full size" style="max-width:95vw'
  if ($t.Contains($old)) { $t = $t.Replace($old, $new); Write-Host "lisatud alt-tekst lightboxi pildile" -ForegroundColor Green }

  [IO.File]::WriteAllText($p, $t, $enc)
  $after = $t.Length
  Write-Host ("index.html: {0:N0} kB -> {1:N0} kB  (vahe {2:N0} kB)" -f ($before/1KB), ($after/1KB), (($before-$after)/1KB)) -ForegroundColor Green
}

Write-Host ""
Write-Host "KONTROLL:" -ForegroundColor Yellow
$c = [IO.File]::ReadAllText((Resolve-Path 'index.html').Path)
Write-Host ("  base64-pilte alles: " + ([regex]::Matches($c,'data:image/png;base64,[A-Za-z0-9+/=]{5000,}')).Count)
Write-Host ("  viiteid screenshot-main.png: " + ([regex]::Matches($c,'screenshot-main\.png')).Count + "  (ootus 2)")
Write-Host ("  index.html suurus: {0:N0} kB" -f ((Get-Item 'index.html').Length/1KB))
