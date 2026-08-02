/* ModbusManager — vabatahtlik e-posti kogumine allalaadimise järel.
 * Allalaadimine algab KOHE (link on avalik, värav ei kaitse midagi).
 * Seejärel ilmub pehme paneel: meeldetuletus + boonusfailid.
 * Torustik: see vorm -> Make.com webhook -> Google Sheet + Gmail.
 * GDPR: nõusoleku-linnuke ei ole ette märgitud; privacy.html mainib kogumist.
 */
(function () {
  'use strict';

  var WEBHOOK = 'https://hook.eu1.make.com/gaspnwphnxp8cvufudbb1rmcd266jgix';
  var SHOWN_KEY = 'mm_email_panel_shown';

  // Tuvasta allalaadimislingid (GitHub releases .exe)
  function isDownloadLink(a) {
    var h = a.getAttribute('href') || '';
    return /modbusmanager-downloads\/releases\/.*\.exe$/i.test(h);
  }

  // Milline toode? (pealkirja jaoks)
  function productFromHref(href) {
    if (/Pro\.Setup/i.test(href) || /pro-v/i.test(href)) return 'Pro';
    return 'Standard';
  }

  function buildPanel(product) {
    var overlay = document.createElement('div');
    overlay.id = 'mmEmailOverlay';
    overlay.style.cssText =
      'position:fixed;inset:0;z-index:100000;background:rgba(10,12,14,0.55);' +
      'display:flex;align-items:center;justify-content:center;padding:20px;' +
      'font-family:-apple-system,BlinkMacSystemFont,"Segoe UI",Roboto,sans-serif';

    var card = document.createElement('div');
    card.style.cssText =
      'background:#fff;max-width:440px;width:100%;border-radius:10px;padding:28px 30px;' +
      'box-shadow:0 20px 60px rgba(0,0,0,0.3);position:relative';

    card.innerHTML =
      '<button id="mmEmailClose" aria-label="Close" style="position:absolute;top:14px;right:16px;' +
      'background:none;border:none;font-size:22px;line-height:1;color:#999;cursor:pointer">\u00d7</button>' +
      '<div style="font-size:13px;color:#0a8a3f;font-weight:600;margin-bottom:6px">' +
      '\u2193 ' + esc(product) + ' download started</div>' +
      '<h3 style="font-size:19px;margin:0 0 10px;color:#16181a;line-height:1.3">' +
      'Want a reminder before your trial ends?</h3>' +
      '<p style="font-size:14px;color:#555;line-height:1.6;margin:0 0 18px">' +
      'We\u2019ll send a heads-up before the 14-day trial expires \u2014 plus ready-made ' +
      'workspace files and the user manual to get you polling faster. No spam.</p>' +
      '<div id="mmEmailForm">' +
        '<input id="mmEmailInput" type="email" inputmode="email" autocomplete="email" ' +
        'placeholder="you@company.com" style="width:100%;box-sizing:border-box;padding:11px 13px;' +
        'font-size:15px;border:1px solid #ccc;border-radius:6px;margin-bottom:12px;outline:none">' +
        '<label style="display:flex;align-items:flex-start;gap:9px;font-size:12.5px;color:#666;' +
        'line-height:1.5;margin-bottom:16px;cursor:pointer">' +
          '<input id="mmEmailConsent" type="checkbox" style="margin-top:2px;flex-shrink:0">' +
          '<span>I agree to receive the trial reminder and resource emails. ' +
          'See our <a href="/privacy.html" target="_blank" style="color:#0a6ad6">privacy policy</a>. ' +
          'You can unsubscribe anytime.</span>' +
        '</label>' +
        '<button id="mmEmailSend" style="width:100%;padding:12px;font-size:15px;font-weight:600;' +
        'background:#0a8a3f;color:#fff;border:none;border-radius:6px;cursor:pointer">Send me the reminder</button>' +
        '<button id="mmEmailSkip" style="width:100%;padding:9px;font-size:13px;color:#999;' +
        'background:none;border:none;cursor:pointer;margin-top:8px">No thanks, just downloading</button>' +
      '</div>' +
      '<div id="mmEmailDone" style="display:none;text-align:center;padding:14px 0">' +
        '<div style="font-size:34px;margin-bottom:8px">\u2713</div>' +
        '<p style="font-size:15px;color:#16181a;margin:0">Thanks \u2014 check your inbox shortly.</p>' +
      '</div>';

    overlay.appendChild(card);
    return overlay;
  }

  function esc(s) {
    return String(s).replace(/[&<>"]/g, function (c) {
      return { '&': '&amp;', '<': '&lt;', '>': '&gt;', '"': '&quot;' }[c];
    });
  }

  function validEmail(v) {
    return /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v);
  }

  function track(action, label) {
    try {
      if (typeof gtag === 'function') {
        gtag('event', action, { event_category: 'EmailCapture', event_label: label || '' });
      }
    } catch (e) {}
  }

  function showPanel(product) {
    // Näita üks kord seansi kohta, et mitte tüüdata
    try { if (sessionStorage.getItem(SHOWN_KEY)) return; sessionStorage.setItem(SHOWN_KEY, '1'); } catch (e) {}

    var overlay = buildPanel(product);
    document.body.appendChild(overlay);
    var input = overlay.querySelector('#mmEmailInput');
    if (input) setTimeout(function () { input.focus(); }, 100);

    function close() { if (overlay.parentNode) overlay.parentNode.removeChild(overlay); }

    overlay.querySelector('#mmEmailClose').onclick = function () { track('email_dismiss', product); close(); };
    overlay.querySelector('#mmEmailSkip').onclick = function () { track('email_skip', product); close(); };
    overlay.addEventListener('click', function (e) { if (e.target === overlay) { track('email_dismiss', product); close(); } });

    overlay.querySelector('#mmEmailSend').onclick = function () {
      var email = (input.value || '').trim();
      var consent = overlay.querySelector('#mmEmailConsent').checked;
      if (!validEmail(email)) { input.style.borderColor = '#d33'; input.focus(); return; }
      if (!consent) {
        var lbl = overlay.querySelector('#mmEmailConsent').parentNode;
        lbl.style.color = '#d33';
        return;
      }
      var btn = overlay.querySelector('#mmEmailSend');
      btn.disabled = true; btn.textContent = 'Sending\u2026';

      var payload = {
        email: email,
        product: product,
        consent: true,
        page: location.pathname,
        referrer: document.referrer || '',
        ts: new Date().toISOString()
      };

      fetch(WEBHOOK, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
      }).then(function () {
        track('email_submit', product);
        overlay.querySelector('#mmEmailForm').style.display = 'none';
        overlay.querySelector('#mmEmailDone').style.display = 'block';
        setTimeout(close, 2200);
      }).catch(function () {
        // Isegi kui webhook ebaõnnestub, ära blokeeri kasutajat
        btn.disabled = false; btn.textContent = 'Send me the reminder';
        track('email_error', product);
        overlay.querySelector('#mmEmailForm').style.display = 'none';
        overlay.querySelector('#mmEmailDone').style.display = 'block';
        setTimeout(close, 2200);
      });
    };
  }

  // Haaki kõik allalaadimislingid — allalaadimist EI takista, paneel tuleb peale
  document.addEventListener('click', function (e) {
    var a = e.target.closest ? e.target.closest('a') : null;
    if (!a || !isDownloadLink(a)) return;
    // ära preventDefault — allalaadimine algab normaalselt
    var product = productFromHref(a.getAttribute('href'));
    track('download_click', product);
    setTimeout(function () { showPanel(product); }, 800);
  }, true);
})();
