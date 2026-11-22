/* Cookie-free counting (2026-11-22). Google Analytics only sees the visitors
   who accept its cookies (about a quarter), so this counts everyone, the same
   way the Download buttons are counted: one row in our own Google Sheet per
   page view, Buy-button click, checkout opened and purchase. Sent: site,
   what happened, page, the page you came from, browser language and time
   zone. No cookies, no storage, no IP address, nothing that identifies you.
   Crawlers and automated browsers are not counted. */
(function () {
  var URL = 'https://script.google.com/macros/s/AKfycbyx9RacY_l5KDK0RBBmLk41uKv3McyR_UJmCTWqnRqklh6fYgeXvYecddcQDGzRx5-F/exec';
  var nav = window.navigator || {};
  if (nav.webdriver || /bot|crawl|spider|slurp|lighthouse|headless|preview|facebookexternalhit|bingpreview/i.test(nav.userAgent || '')) return;
  if (typeof nav.sendBeacon !== 'function') return;
  function count(kind, what) {
    try {
      var tz = '';
      try { tz = (window.Intl && Intl.DateTimeFormat().resolvedOptions().timeZone) || ''; } catch (e) {}
      nav.sendBeacon(URL, JSON.stringify({
        site: window.location.hostname, product: kind, version: what || '',
        page: window.location.pathname, referrer: window.document.referrer || '', lang: nav.language || '', tz: tz
      }));
    } catch (e) {}
  }
  // a visit from the app's Buy button (index.html sets __mmFromApp) is marked "app"
  var APP = window.__mmFromApp ? 'app' : '';
  count('View', APP);
  // the page already tells gtag when a Buy button, a checkout or a purchase
  // happens (consent or not): count the same moments
  var KINDS = { buy_button_click: 'Buy', runtime_order_click: 'Buy', begin_checkout: 'Checkout', purchase: 'Purchase' };
  var g = window.gtag;
  if (typeof g === 'function') {
    window.gtag = function (a, b, p) {
      try { if (a === 'event' && KINDS[b]) count(KINDS[b], ((p && (p.event_label || p.product)) || '') + (APP ? ' (app)' : '')); } catch (e) {}
      return g.apply(this, arguments);
    };
  }
})();
