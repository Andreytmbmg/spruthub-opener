(function () {
  // Запускается как можно раньше: запоминает элементы, на которые страница
  // повесила обработчики нажатий, чтобы пульт мог их выбирать.
  if (window.__tvEarly) return;
  window.__tvEarly = true;
  var S = new Set();
  window.__tvClickables = S;
  var types = { click: 1, mousedown: 1, mouseup: 1, pointerdown: 1, pointerup: 1,
                touchstart: 1, touchend: 1, contextmenu: 1 };
  var orig = EventTarget.prototype.addEventListener;
  EventTarget.prototype.addEventListener = function (t, l, o) {
    try {
      if (types[t] && this instanceof Element &&
          this !== document.documentElement && this !== document.body) S.add(this);
    } catch (e) {}
    return orig.call(this, t, l, o);
  };
})();
