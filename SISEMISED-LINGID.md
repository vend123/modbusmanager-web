# Gateway sisemised lingid — analüüs ja paigaldus

## Mida skript teeb

`gateway-crosslinks.ps1` lisab igale lehele **kontekstipõhise** lõigu (mitte sama lauset kõikjal) ja lingi gateway-lehele. Avalehele lisab funktsioonikaardi + lause Pro-lõiku.

Skript on **ohutu korduvalt jooksutada** — juba lisatud lehed jäetakse vahele.


## Lehed ja tekstid (prioriteet Search Console andmete järgi)

| Leht | Lisatud pealkiri | Klikke | Näitamisi | CTR | Pos |
|---|---|---|---|---|---|
| `huawei-smartlogger-modbus.html` | SmartLogger plus everything else | 29 | 1157 | 2.5% | 6.0 |
| `abb-acs580-modbus.html` | Many drives, one shared register map | 21 | 573 | 3.7% | 5.7 |
| `schneider-powerlogic-pm5000-modbus.html` | From many meters to one register map | 18 | 601 | 3.0% | 5.2 |
| `index.html` | Feature card + Pro paragraph | 17 | 286 | 5.9% | 10.5 |
| `eastron-sdm630-modbus.html` | Several SDM630s, one register map | 14 | 535 | 2.6% | 7.5 |
| `eastron-sdm120-modbus.html` | Forty SDM120s behind one address | 2 | 199 | 1.0% | 6.5 |
| `abb-acs880-modbus.html` | Multiple ACS880 drives behind one address | – | – | – | – |
| `modbus-hmi-siemens-s7-1200.html` | One MB_CLIENT block instead of twelve | – | – | – | – |
| `modbus-hmi-ebm-papst.html` | A wall of fans, one register map | – | – | – | – |
| `modbus-poll-alternative.html` | Something a polling tool does not do | – | – | – | – |
| `modbus-hmi-dashboard.html` | One dashboard, devices on different buses | – | – | – | – |
| `modbus-data-logger-software.html` | Log a whole installation from one map | – | – | – | – |
| `modbus-alarm-software.html` | Alarms on values from the whole plant | – | – | – | – |
| `manual.html` | Combining devices into one register map | – | – | – | – |

Kliki-/näitamisandmed on 27.06–19.07.2026 ekspordist. Ülemised kolm lehte toovad juba
päris liiklust, seega **nendelt tulev sisemine link on kõige väärtuslikum** — lugeja on
täpselt õiges mõtteseisus (tal *on* mitu seadet) ja Google näeb, et gateway-leht on
seotud lehtedega, mis juba edestavad.

`eastron-sdm120-modbus.html` on eraldi tähelepanu väärt: positsioon 6,5 ja 199 näitamist,
aga **CTR ainult 1,0%** — seal on kliki-potentsiaali lauale jäetud. Sisemine link seda ei
paranda; selleks on vaja title/meta ümberkirjutust. Eraldi töö.

## Paigaldus

1. Kopeeri `gateway-crosslinks.ps1` kausta `C:\Users\Simatic\Desktop\mm-web`
2. Jooksuta:

```cmd
cd /d C:\Users\Simatic\Desktop\mm-web
powershell -ExecutionPolicy Bypass -File .\gateway-crosslinks.ps1
```

Skript prindib iga lehe kohta, kas lisas või jättis vahele, ja lõpus kontrolli:
- gateway-linke kokku (peaks olema ~45: 2 nav/jalus × 15 lehte + 14 sisulinki)
- kontekstisektsioone: **13**
- kinnitus, et `index.html` on koduleht (mitte rakenduse fail)

3. Vaata paar lehte brauseris üle (ava fail otse), siis:

```cmd
git add -A
git commit -m "Add contextual internal links to gateway page"
git push
```

## Miks nii, mitte valmis HTML-failid

Sinu lokaalsed failid on juba muudetud (nav-lingid). Kui tarniksin valmis HTML-id,
kirjutaksin osa neist muudatustest maha — skript töötab sinu tegeliku seisu peal.

## Mis jääb ootele (SEO)

- **eastron-sdm120 title/meta ümberkirjutus** — pos 6,5 juures 1% CTR on suurim üksik kaotus
- **Search Console** → esita `sitemap.xml` uuesti + Request indexing uuele lehele
- Gateway-lehe ekraanipildid (`gw-01…gw-05.png`) — leht töötab ka ilma, aga pildid parandavad nii konversiooni kui lehel veedetud aega
