// Open a ready workspace straight in ModbusManager (modbusmanager:// link, ModbusManager 1.9.9 / 1.4.9 or newer).
// Written by tools/web-research/open-in-app.js — edit it there.
(function () {
  var FILES = ["SDM630_workspace.json","SDM120_workspace.json","SchneiderPM5000_workspace.json","SchneiderPM3200_workspace.json","Eastron_SDM230_SDM72.json","CarloGavazzi_EM340.json","Janitza_UMG96PA.json","ABB_ACS580_monitor_workspace.json","ABB_ACS880_monitor_workspace.json","ABB_ACH580_Modbus_monitor.json","Danfoss_FC102_monitor.json","Schneider_ATV320_monitor.json","Siemens_G120_monitor.json","Huawei_SUN2000.json","SmartLogger_24inv.json","Sungrow_SG.json","SunSpec_Inverter.json","Deye_Hybrid_1P.json","Victron_CerboGX.json","GoodWe_ET_Hybrid.json","ebmpapst_16fans_workspace.json","Siemens_S7_PUT_GET.json","Huawei_SUN2000_HomeAssistant.json","SDM630_MQTT_HomeAssistant.json"];
  var done = {};
  [].forEach.call(document.querySelectorAll('a[download][href$=".json"]'), function (a) {
    var file = (a.getAttribute('href') || '').replace(/^.*\//, '');
    if (FILES.indexOf(file) < 0 || done[file]) return;
    done[file] = 1;
    var b = document.createElement('a');
    b.href = 'modbusmanager://open?ws=' + encodeURIComponent(file);
    b.className = a.className;
    b.setAttribute('data-open-ws', file);
    b.textContent = '\u25B6 Open in ModbusManager';
    b.title = 'Opens this workspace in ModbusManager Pro 1.9.9 or newer on this PC (asks before replacing yours)';
    if (!a.className) b.style.marginRight = '0.8rem';
    b.addEventListener('click', function () {
      // An older version, or none, does not know the link: nothing opens, or
      // Windows offers to look for an app (which takes the focus, so the focus
      // tells nothing). Unless the page went away, say what the button needs.
      setTimeout(function () {
        if (document.hidden || document.getElementById('oia-note-' + file)) return;
        var n = document.createElement('div');
        n.id = 'oia-note-' + file;
        n.style.cssText = 'font-size:0.85rem;margin:0.5rem 0;color:inherit;opacity:0.85';
        n.innerHTML = 'Nothing opened? This button needs <b>ModbusManager Pro 1.9.9 or newer</b> on this PC. With an older version, or none, <a href="/#download">download the latest ModbusManager</a> (it installs over the old one), or download the .json file below and use <i>Open workspace</i>.';
        b.parentNode.insertBefore(n, b.nextSibling && b.nextSibling.nextSibling ? b.nextSibling.nextSibling : null);
      }, 1500);
    });
    a.parentNode.insertBefore(b, a);
    if (a.className) a.parentNode.insertBefore(document.createTextNode(' '), a);
  });
})();
