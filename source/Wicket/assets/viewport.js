(function () {
  // Масштаб интерфейса через <meta viewport>: страница получает меньший «экран» в CSS-пикселях и рисуется сразу крупно и чётко.
  // Java перед скриптом задаёт window.__tvVp = {z: масштаб (1.3 = 130%), w: ширина экрана в dp}.
  var inc = window.__tvVp;
  if (!inc) return;
  var VP = window.__tvVpS || (window.__tvVpS = { z: 1, w: 0 });   // общее состояние: старый наблюдатель не вернёт прежний масштаб
  VP.z = inc.z; VP.w = inc.w;
  var busy = false;
  function wanted() {
    var z = VP.z, w = VP.w;
    if (!(z > 1.001) || !(w > 0)) return 'width=device-width, initial-scale=1';
    return 'width=' + Math.round(w / z) + ', initial-scale=' + z + ', minimum-scale=' + z + ', maximum-scale=' + z + ', user-scalable=no';
  }
  function apply() {
    if (busy) return;
    busy = true;
    try {
      var root = document.documentElement;
      if (!root) return;
      var m = document.querySelector('meta[name="viewport"]');
      var want = wanted();
      if (!m) {
        m = document.createElement('meta');
        m.setAttribute('name', 'viewport');
        (document.head || root).appendChild(m);
      }
      if (m.getAttribute('content') !== want) m.setAttribute('content', want);
    } catch (e) {} finally { busy = false; }
  }
  window.__tvVpApply = function (z, w) { VP.z = z; VP.w = w; apply(); };
  if (!window.__tvVpInit) {
    window.__tvVpInit = true;
    apply();
    try {
      // сайт (или его фреймворк) может переписать тег viewport — возвращаем наш
      new MutationObserver(function () { apply(); }).observe(document.documentElement, { childList: true, subtree: true, attributes: true, attributeFilter: ['content', 'name'] });
    } catch (e) {}
    document.addEventListener('DOMContentLoaded', apply);
  } else {
    apply();
  }
})();
