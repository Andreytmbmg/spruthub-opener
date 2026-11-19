(function () {
  if (window.__tvNav) return;
  window.__tvNav = true;

  var CLS = '__tvfocus';
  // Рамка выбора рисуется отдельным слоем поверх страницы (position:fixed): её не обрезают
  // родительские блоки с overflow:hidden, и она повторяет скругление углов выбранного элемента.
  var ov = null, ovKey = '', radiusCss = '12px', raf = 0, fr = 0, occluded = false;

  function ensureOv() {
    if (ov && ov.isConnected) return ov;
    ov = document.createElement('div');
    ov.style.cssText = 'position:fixed;left:0;top:0;width:0;height:0;display:none;z-index:2147483646;' +
      'pointer-events:none;box-sizing:border-box;border:2px solid #4FC3F7;' +
      'box-shadow:0 0 0 1px rgba(0,0,0,.5);';
    document.documentElement.appendChild(ov);
    return ov;
  }

  // Радиус скругления выбранного элемента (или вложенного/родительского блока, который «рисует» ячейку)
  function radiusOf(el) {
    var r = el.getBoundingClientRect();
    var lim = Math.min(r.width, r.height) / 2;
    function read(e) {
      var cs = getComputedStyle(e), out = [], any = false;
      ['borderTopLeftRadius', 'borderTopRightRadius', 'borderBottomRightRadius', 'borderBottomLeftRadius'].forEach(function (p) {
        var v = cs[p] || '0px', n = parseFloat(v) || 0;
        if (v.indexOf('%') >= 0) n = n * Math.min(r.width, r.height) / 100;
        if (n > 0) any = true;
        out.push(Math.min(n, lim));
      });
      return any ? out : null;
    }
    function near(e) {
      var q = e.getBoundingClientRect();
      return Math.abs(q.left - r.left) < 8 && Math.abs(q.top - r.top) < 8 &&
             Math.abs(q.right - r.right) < 8 && Math.abs(q.bottom - r.bottom) < 8;
    }
    var v = read(el);
    if (!v) {
      var kids = el.getElementsByTagName('*');
      for (var i = 0; i < kids.length && i < 40 && !v; i++) if (near(kids[i])) v = read(kids[i]);
    }
    if (!v && el.parentElement && near(el.parentElement)) v = read(el.parentElement);
    if (!v) { var d = Math.min(12, lim); v = [d, d, d, d]; }
    return v.map(function (n) { return Math.round(n) + 'px'; }).join(' ');
  }

  function isProxy(e) { return !!(e && e.getAttribute && e.getAttribute('data-tvproxy')); }

  function tick() {
    raf = 0;
    if (!ov) return;
    if (!cur || !document.contains(cur)) { ov.style.display = 'none'; return; }
    var r = cur.getBoundingClientRect();
    fr++;
    if (fr % 6 === 1) {   // окно закрыло выбранный элемент?
      occluded = isProxy(cur) ? !(innerHost && hit(innerHost)) : !(hit(cur) || scrollClipped(cur));
    }
    if (occluded || r.width < 2 || r.height < 2) { ov.style.display = 'none'; }
    else {
      var key = r.left + '|' + r.top + '|' + r.width + '|' + r.height;
      if (key !== ovKey) {
        ovKey = key;
        ov.style.left = r.left + 'px'; ov.style.top = r.top + 'px';
        ov.style.width = r.width + 'px'; ov.style.height = r.height + 'px';
      }
      ov.style.display = 'block';
    }
    raf = requestAnimationFrame(tick);   // следим за элементом, пока он движется (прокрутка, анимации)
  }

  var SEL = 'a[href],button,input,select,textarea,summary,[role=button],[role=link],[role=tab],' +
    '[role=switch],[role=checkbox],[role=menuitem],[role=option],[onclick],[tabindex]:not([tabindex="-1"])';

  var cur = null;
  var clippedSet = new WeakSet();
  var activeLayer = null;        // корни окон, лежащих поверх страницы (или null)
  var innerHost = null;          // плитка, внутри которой сейчас выбираем её кнопки (режим «внутри»)
  var pendingTap = null;         // отложенное нажатие на плитке с вложенными кнопками (ждём второго OK)
  var dcPress = null;            // нажатие OK на такой плитке до выяснения «короткое / долгое / двойное»

  function isPtr(e) { return getComputedStyle(e).cursor === 'pointer'; }

  // «Вложенная кнопка»: значок без текста, на который страница повесила нажатие, с курсором «рука»
  function isStrictInner(e) {
    if (e.nodeType !== 1 || !isPtr(e)) return false;
    var tracked = window.__tvClickables && window.__tvClickables.has(e);
    var p = e.parentElement;
    var boundary = !p || getComputedStyle(p).cursor !== 'pointer';
    if (!(tracked || boundary)) return false;
    return iconText(e);
  }

  // Текст пустой или это «лигатура» иконки (у сайта значки вроде mic_off, wifi — шрифт Material Symbols)
  function iconText(e) {
    var t = (e.textContent || '').trim();
    if (!t) return true;
    if (t.length > 40 || !/^[a-z0-9_]+$/.test(t)) return false;
    var f = getComputedStyle(e).fontFamily || '';
    if (/symbol|icon|material|glyph/i.test(f)) return true;
    var r = e.getBoundingClientRect();
    return r.width <= 80 && r.height <= 80;
  }

  var hasPopup = false;   // поверх страницы есть окно (фикс. или абсолютное с z-index)
  function isPopupLike(root) {
    for (var p = root; p && p !== document.documentElement; p = p.parentElement) {
      var cs = getComputedStyle(p);
      if (cs.position === 'fixed') return true;
      if (cs.position === 'absolute' && parseInt(cs.zIndex, 10) > 0) return true;
    }
    return false;
  }
  var tileHostSet = new WeakSet();   // плитки со вложенными кнопками: выбираем целиком, кнопки через двойное OK
  function inFixed(e) {
    for (var p = e; p && p !== document.documentElement; p = p.parentElement) {
      if (getComputedStyle(p).position === 'fixed') return true;
    }
    return false;
  }
  // Ряд сегментов («Все / Wi-Fi / нет сети»): 2+ кнопки в один ряд, рядом друг с другом
  function isSegmentedRow(inners) {
    if (inners.length < 2) return false;
    var rs = inners.map(function (x) { return x.getBoundingClientRect(); });
    rs.sort(function (a, b) { return a.left - b.left; });
    var cy = (rs[0].top + rs[0].bottom) / 2;
    for (var i = 0; i < rs.length; i++) {
      if (Math.abs((rs[i].top + rs[i].bottom) / 2 - cy) > 14) return false;
      if (i && rs[i].left - rs[i - 1].right > Math.max(rs[i - 1].width, rs[i].width, 60) * 4) return false;
    }
    return true;
  }

  function innerControls(host) {
    var hr = host.getBoundingClientRect(), ha = hr.width * hr.height;
    var all = host.getElementsByTagName('*'), res = [];
    for (var i = 0; i < all.length && i < 400; i++) {
      var d = all[i];
      if (!isStrictInner(d) || !visible(d)) continue;
      var r = d.getBoundingClientRect();
      if (r.width < 14 || r.height < 14) continue;
      if (ha && r.width * r.height > ha * 0.6) continue;
      if (!hit(d)) continue;
      res.push(d);
    }
    return res.filter(function (d) { return !res.some(function (o) { return o !== d && o.contains(d); }); });
  }

  // Элемент частично или целиком скрыт внутри прокручиваемого родителя (overflow auto/scroll/hidden)
  function scrollClipped(e) {
    var r = e.getBoundingClientRect();
    for (var p = e.parentElement; p && p !== document.body && p !== document.documentElement; p = p.parentElement) {
      var cs = getComputedStyle(p);
      if (!/(auto|scroll|hidden)/.test(cs.overflowY + ' ' + cs.overflowX)) continue;
      if (p.scrollHeight <= p.clientHeight + 2 && p.scrollWidth <= p.clientWidth + 2) continue;
      var pr = p.getBoundingClientRect();
      if (r.bottom > pr.bottom + 1 || r.top < pr.top - 1 || r.right > pr.right + 1 || r.left < pr.left - 1) return true;
    }
    return false;
  }

  function visible(el) {
    var r = el.getBoundingClientRect();
    if (r.width < 4 || r.height < 4) return false;
    if (r.bottom < 0 || r.right < 0 || r.top > innerHeight || r.left > innerWidth) {
      // за пределами экрана тоже годится (прокрутим), но не слишком далеко
      if (r.top > innerHeight * 8 || r.bottom < -innerHeight * 8) return false;
    }
    var cs = getComputedStyle(el);
    if (cs.visibility === 'hidden' || cs.display === 'none' || cs.pointerEvents === 'none') return false;
    if (el.disabled) return false;
    // тонкие полоски (разделители, полосы прокрутки, подчёркивания) выбирать не нужно
    var mn = Math.min(r.width, r.height), mx = Math.max(r.width, r.height);
    if (mn < 16 && mx / Math.max(mn, 1) > 6) {
      var tg = el.tagName, role = el.getAttribute('role');
      var isRange = tg === 'INPUT' || tg === 'SELECT' || tg === 'TEXTAREA' || role === 'slider' ||
                    /slider|range|seek|progress/i.test(el.getAttribute('class') || '');
      if (!isRange) return false;
    }
    return true;
  }

  // Проверка 9 точек элемента: сколько из них реально «его» (не закрыты окном/подложкой поверх)
  function hitInfo(el) {
    var r = el.getBoundingClientRect(), f = [0.15, 0.5, 0.85], tested = 0, ok = 0, occ = null;
    for (var i = 0; i < 3; i++) for (var j = 0; j < 3; j++) {
      var x = r.left + r.width * f[i], y = r.top + r.height * f[j];
      if (x < 0 || y < 0 || x >= innerWidth || y >= innerHeight) continue;
      tested++;
      var tg = document.elementFromPoint(x, y);
      if (tg && (tg === el || el.contains(tg))) ok++;
      else if (tg && !occ) occ = tg;
    }
    return { tested: tested, ok: ok, occ: occ };
  }

  // Элемент виден пользователю: закрыто окном не больше четверти точек
  function hitOk(h) { return h.tested === 0 || h.ok >= Math.ceil(h.tested * 0.75); }
  function hit(el) { return hitOk(hitInfo(el)); }

  function isHuge(r) { return r.width > innerWidth * 0.9 && r.height > innerHeight * 0.9; }

  function candidates() {
    var set = new Set();
    document.querySelectorAll(SEL).forEach(function (e) { set.add(e); });
    // элементы, на которые страница повесила обработчики нажатий
    if (window.__tvClickables) {
      window.__tvClickables.forEach(function (e) {
        if (document.contains(e)) set.add(e); else window.__tvClickables.delete(e);
      });
    }
    // элементы, которые выглядят кликабельными (cursor:pointer), но не помечены как кнопки
    var all = document.body ? document.body.getElementsByTagName('*') : [];
    for (var i = 0; i < all.length && i < 6000; i++) {
      var e = all[i];
      if (set.has(e)) continue;
      if (e.onclick || e.onmousedown || e.onmouseup || e.onpointerdown || e.onpointerup || e.ontouchstart) { set.add(e); continue; }
      var cs = getComputedStyle(e);
      if (cs.cursor === 'pointer') {
        var p = e.parentElement;
        // берём самый внешний из подряд идущих pointer-элементов, не вложенные кусочки
        if (p && getComputedStyle(p).cursor === 'pointer') continue;
        set.add(e);
      }
    }
    var hm = findHome();
    if (hm) set.add(hm);
    var out = [];
    set.forEach(function (e) {
      if (e === document.body || e === document.documentElement) return;
      if (!visible(e)) return;
      if (isHuge(e.getBoundingClientRect())) return; // корневой контейнер, а не кнопка
      out.push(e);
    });
    // убираем то, что закрыто другим окном (подложка меню и т.п.)
    // Элементы, обрезанные прокручиваемым блоком (камеры ниже края правой панели), тоже оставляем:
    // к ним можно «доехать» с прокруткой. Отбрасываем только то, что закрыто окном поверх.
    clippedSet = new WeakSet();
    var layerRoots = [];
    hasPopup = false;
    var free = out.filter(function (e) {
      var h = hitInfo(e);
      if (hitOk(h)) return true;
      if (scrollClipped(e)) { clippedSet.add(e); return true; }
      if (h.occ) {   // чем закрыт: запоминаем «окно» поверх страницы
        var root = h.occ;
        while (root.parentElement && !root.parentElement.contains(e)) root = root.parentElement;
        if (!root.contains(e)) {
          if (inFixed(root) && layerRoots.indexOf(root) < 0) layerRoots.push(root);
          if (isPopupLike(root)) hasPopup = true;
        }
      }
      return false;
    });
    var list = free.length ? free : out;

    // Одна остановка на строку/плитку: вложенные элементы с обработчиками убираем,
    // оставляем внешний (нужный внутренний элемент потом находит findControl).
    // Настоящие кнопки, ссылки и поля ввода остаются отдельными остановками.
    var vpArea = innerWidth * innerHeight;
    function strong(e) {
      var t = e.tagName, role = e.getAttribute('role');
      return t === 'A' || t === 'BUTTON' || t === 'INPUT' || t === 'SELECT' || t === 'TEXTAREA' || t === 'SUMMARY' ||
             role === 'button' || role === 'link' || role === 'tab' || role === 'menuitem' || role === 'option';
    }
    // Вложенные кнопки внутри строки или плитки (значки камеры, сегменты переключателя).
    //  · внутри плитки (курсор «рука»): отдельными остановками не делаем, к ним ведёт двойное нажатие OK;
    //  · внутри обычной строки, если их 2 и больше (сегменты «Все / Wi-Fi / нет сети»): сама строка
    //    не нужна, остановками становятся сами сегменты;
    //  · если кнопка одна (переключатель в строке): остаётся строка, нажатие уходит на переключатель.
    var listSet = new Set(list), groups = new Map(), dropSet = new Set(), flatSet = new Set();
    function nearestHost(e) {
      for (var p = e.parentElement; p; p = p.parentElement) if (listSet.has(p)) return p;
      return null;
    }
    list.forEach(function (e) {
      if (!isStrictInner(e)) return;
      var h = nearestHost(e);
      if (!h) return;
      var hr = h.getBoundingClientRect(), er = e.getBoundingClientRect();
      if (er.width * er.height > hr.width * hr.height * 0.6) return;   // почти вся строка: это не вложенная кнопка
      if (isStrictInner(h)) { dropSet.add(e); return; }                  // кнопка внутри кнопки
      if (!groups.has(h)) groups.set(h, []);
      groups.get(h).push(e);
    });
    groups.forEach(function (inners, h) {
      if (isSegmentedRow(inners) && (inFixed(h) || !isPtr(h))) { flatSet.add(h); return; }
      inners.forEach(function (x) { dropSet.add(x); });
      if (inners.length >= 2) tileHostSet.add(h);
    });

    // Значки без своей плитки в списке (превью камеры с микрофоном/динамиком): ищем плитку-превью,
    // в которой лежит видео, и делаем её остановкой; значки доступны двойным OK.
    var orphans = list.filter(function (e) { return isStrictInner(e) && !dropSet.has(e) && !nearestHost(e); });
    var synth = new Map();
    orphans.forEach(function (e) {
      var er = e.getBoundingClientRect(), ea = er.width * er.height, best = null;
      for (var p = e.parentElement; p && p !== document.body && p !== document.documentElement; p = p.parentElement) {
        var r = p.getBoundingClientRect();
        if (r.width * r.height > vpArea * 0.3 || r.height > innerHeight * 0.7) break;
        var other = false;
        for (var i = 0; i < list.length; i++) {
          if (list[i] !== e && !isStrictInner(list[i]) && p.contains(list[i])) { other = true; break; }
        }
        if (other) break;
        if (r.width * r.height >= ea * 4 && p.querySelector('video,canvas,img,iframe')) best = p;
      }
      if (!best) return;
      if (!synth.has(best)) synth.set(best, []);
      synth.get(best).push(e);
    });
    synth.forEach(function (inners, h) {
      if (isSegmentedRow(inners) && (inFixed(h) || !isPtr(h))) return;
      inners.forEach(function (x) { dropSet.add(x); });
      tileHostSet.add(h);
      list.push(h);
    });
    list = list.filter(function (e) { return !dropSet.has(e) && !flatSet.has(e); });

    // Поле ввода значения («78 %» с карандашом) внутри строки с ползунком отдельной остановкой не нужно:
    // строка с ползунком регулируется целиком
    list = list.filter(function (e) {
      if (e.tagName !== 'INPUT') return true;
      for (var p = e.parentElement, n = 0; p && n < 6; p = p.parentElement, n++) {
        if (p.querySelector && p.querySelector('.vue-slider-dot')) return false;
      }
      return true;
    });

    // Большие контейнеры (весь левый блок, вся панель), внутри которых уже есть свои элементы,
    // сами выбирать не нужно.
    list = list.filter(function (a) {
      if (strong(a)) return true;
      var r = a.getBoundingClientRect();
      // контейнер = высокий блок (как весь левый список) или очень большая площадь;
      // широкие, но невысокие строки меню контейнерами не считаем
      var big = r.height > innerHeight * 0.3 || r.width * r.height > vpArea * 0.25;
      if (!big) return true;
      var n = 0;
      for (var i = 0; i < list.length; i++) {
        if (list[i] !== a && a.contains(list[i])) n++;
      }
      return n < 2;
    });

    var outers = list.filter(function (a) {
      var r = a.getBoundingClientRect();
      return r.width * r.height < vpArea * 0.25 && r.height < innerHeight * 0.4;
    });
    var res = list.filter(function (e) {
      if (strong(e)) return true;
      for (var i = 0; i < outers.length; i++) {
        var o = outers[i];
        if (o !== e && o.contains(e)) return false;
      }
      return true;
    });

    // Если поверх страницы открыто окно (меню, всплывающая панель), выбирать можно только в нём
    activeLayer = null;
    if (layerRoots.length) {
      var inLay = res.filter(function (e) { return layerRoots.some(function (r) { return r.contains(e); }); });
      if (inLay.length) { activeLayer = layerRoots; res = inLay; }
    }
    return res;
  }

  function inLayer(e) { return !activeLayer || activeLayer.some(function (r) { return r.contains(e); }); }

  function center(r) { return { x: r.left + r.width / 2, y: r.top + r.height / 2 }; }

  // Выбор соседа в духе Android FocusFinder: сначала те, кто лежит «на луче» (перекрывается
  // по поперечной оси с текущим), среди них ближайший; если таких нет, то по формуле 13*major² + minor².
  function onScreen(r) {
    return r.right > 0 && r.bottom > 0 && r.left < innerWidth && r.top < innerHeight;
  }

  function pickFrom(dir, list, from) {
    var horiz = dir === 'ArrowLeft' || dir === 'ArrowRight';
    var fcx = (from.left + from.right) / 2, fcy = (from.top + from.bottom) / 2;
    var best = null, bestKey = Infinity;
    list.forEach(function (e) {
      if (e === cur) return;
      var r = e.getBoundingClientRect();
      var cx = (r.left + r.right) / 2, cy = (r.top + r.bottom) / 2;
      var delta, dist, overlap, minor;
      if (horiz) {
        delta = dir === 'ArrowRight' ? cx - fcx : fcx - cx;
        dist = dir === 'ArrowRight' ? r.left - from.right : from.left - r.right;
        overlap = Math.min(r.bottom, from.bottom) - Math.max(r.top, from.top);
        minor = Math.abs(cy - fcy);
      } else {
        delta = dir === 'ArrowDown' ? cy - fcy : fcy - cy;
        dist = dir === 'ArrowDown' ? r.top - from.bottom : from.top - r.bottom;
        overlap = Math.min(r.right, from.right) - Math.max(r.left, from.left);
        minor = Math.abs(cx - fcx);
      }
      if (delta <= 2) return;                 // не в нужную сторону
      var major = Math.max(0, dist);
      var score = 13 * major * major + minor * minor;
      // Приоритеты: 1) на луче и на экране, 2) на луче, но за краем (с прокруткой),
      // 3) сбоку на экране, 4) сбоку за краем. Так фокус не «убегает» в соседний блок,
      // пока в текущем есть, куда ехать.
      var off = !onScreen(r) || clippedSet.has(e);
      var key = ((overlap > 0 ? 0 : 2) + (off ? 1 : 0)) * 1e12 + score;
      if (key < bestKey) { bestKey = key; best = e; }
    });
    return best;
  }

  function pick(dir, list) {
    var from;
    if (cur && document.contains(cur)) {
      from = cur.getBoundingClientRect();
    } else {
      from = { left: innerWidth / 2, right: innerWidth / 2, top: innerHeight / 2, bottom: innerHeight / 2, width: 0, height: 0 };
    }
    if (cur && document.contains(cur) && (dir === 'ArrowUp' || dir === 'ArrowDown')) {
      // внутри прокручиваемого списка (комнаты слева) сначала проходим весь список, и только потом выходим из него
      var sc = scrollerOf(cur);
      if (sc) {
        var same = list.filter(function (e) { return sc.contains(e); });
        var n = pickFrom(dir, same, from);
        if (n) return n;
      }
    }
    return pickFrom(dir, list, from);
  }
  function scrollerOf(e) {
    for (var p = e.parentElement; p && p !== document.body && p !== document.documentElement; p = p.parentElement) {
      var oy = getComputedStyle(p).overflowY;
      if ((oy === 'auto' || oy === 'scroll') && p.scrollHeight > p.clientHeight + 4) return p;
    }
    return null;
  }

  function setFocus(el) {
    if (pendingTap && el !== pendingTap.el) flushPending();
    if (cur) cur.classList.remove(CLS);
    cur = el;
    occluded = false;
    ensureOv();
    ov.style.borderColor = (innerHost || adjCtl) ? '#FFB300' : '#4FC3F7';
    if (dbgOn) renderDebug();
    if (!el) { ov.style.display = 'none'; return; }
    el.classList.add(CLS);
    try { el.scrollIntoView({ block: 'nearest', inline: 'nearest' }); } catch (e) {}
    radiusCss = radiusOf(el);
    ov.style.borderRadius = radiusCss;
    ovKey = '';
    if (!raf) raf = requestAnimationFrame(tick);
  }

  // Имитация мыши в центре элемента. Нажатие OK = кнопка мыши вниз,
  // отпускание OK = кнопка вверх + click. Если OK удержана дольше LONG_MS,
  // это долгое нажатие: сайт получает «зажатую» кнопку и событие contextmenu,
  // а обычный click не отправляется (чтобы не сработало ещё и короткое нажатие).
  var LONG_MS = 600;
  var press = null;

  // Внутри выбранной строки ищем сам переключатель/чекбокс/ползунок: нажимать надо на него,
  // а не в пустое место посередине строки.
  var CTL_CLASS = /(^|[\s_-])(switch|toggle|checkbox|slider|knob|thumb)([\s_-]|$)/i;
  function findControl(el) {
    if (tileHostSet.has(el)) return null;
    var r0 = el.getBoundingClientRect(), area0 = r0.width * r0.height;
    var t0 = el.tagName, role0 = el.getAttribute && el.getAttribute('role');
    if (t0 === 'INPUT' || t0 === 'BUTTON' || t0 === 'SELECT' || role0 === 'switch' || role0 === 'checkbox') return null;
    var all = el.getElementsByTagName('*'), best = null, bestArea = 0;
    for (var i = 0; i < all.length && i < 400; i++) {
      var d = all[i], t = d.tagName;
      var role = d.getAttribute('role');
      var cls = d.getAttribute('class') || '';
      var ok = t === 'INPUT' || t === 'SELECT' || role === 'switch' || role === 'checkbox' || CTL_CLASS.test(cls);
      if (!ok) continue;
      var r = d.getBoundingClientRect();
      if (r.width < 8 || r.height < 8) continue;
      if (area0 && r.width * r.height > area0 * 0.5) continue;
      var cs = getComputedStyle(d);
      if (cs.visibility === 'hidden' || cs.display === 'none') continue;
      var a = r.width * r.height;
      if (a > bestArea) { bestArea = a; best = d; }   // самый крупный из найденных = внешняя обёртка переключателя
    }
    if (best) return best;

    // Названия классов у сайта зашифрованы. Если сама строка не выглядит кнопкой (курсор не «рука»),
    // ищем внутри неё элемент без текста, у которого есть обработчик нажатия и курсор «рука».
    if (getComputedStyle(el).cursor !== 'pointer' && window.__tvClickables) {
      for (var j = 0; j < all.length && j < 400; j++) {
        var c = all[j];
        if (!window.__tvClickables.has(c)) continue;
        var cs2 = getComputedStyle(c);
        if (cs2.cursor !== 'pointer' || cs2.visibility === 'hidden' || cs2.display === 'none') continue;
        if ((c.textContent || '').trim() !== '') continue;
        var rc = c.getBoundingClientRect();
        if (rc.width < 8 || rc.height < 8) continue;
        if (area0 && rc.width * rc.height > area0 * 0.5) continue;
        var ac = rc.width * rc.height;
        if (ac > bestArea) { bestArea = ac; best = c; }
      }
    }
    return best;
  }

  function mk(el) {
    var ref = findControl(el) || el;
    var r = ref.getBoundingClientRect();
    var x = Math.min(Math.max(r.left + r.width / 2, 1), innerWidth - 1);
    var y = Math.min(Math.max(r.top + r.height / 2, 1), innerHeight - 1);
    var tg = document.elementFromPoint(x, y);
    if (!isProxy(ref) && (!tg || !(ref === tg || ref.contains(tg) || tg.contains(ref)))) tg = ref;
    if (!tg) tg = ref;
    var base = { bubbles: true, cancelable: true, composed: true, view: window,
                 clientX: x, clientY: y, screenX: x, screenY: y, button: 0 };
    return {
      tg: tg,
      ptr: function (type, buttons) {
        try {
          tg.dispatchEvent(new PointerEvent(type, Object.assign({}, base, {
            pointerId: 1, pointerType: 'mouse', isPrimary: true, buttons: buttons,
            width: 1, height: 1, pressure: buttons ? 0.5 : 0 })));
        } catch (e) {}
      },
      mouse: function (type, buttons) {
        tg.dispatchEvent(new MouseEvent(type, Object.assign({}, base,
          { buttons: buttons, button: type === 'contextmenu' ? 2 : 0, detail: type === 'click' ? 1 : 0 })));
      }
    };
  }

  function pressStart(el, longMs) {
    if (press) return;
    var m = mk(el);
    press = { el: el, m: m, long: false, timer: null };
    m.ptr('pointerover', 0); m.mouse('mouseover', 0);
    m.ptr('pointermove', 0); m.mouse('mousemove', 0);
    m.ptr('pointerdown', 1); m.mouse('mousedown', 1);
    try { if (m.tg.focus) m.tg.focus({ preventScroll: true }); } catch (e) {}
    press.timer = setTimeout(function () {
      if (!press) return;
      press.long = true;
      if (isHomeTarget(press.el)) { showSettings(); return; }
      press.m.mouse('contextmenu', 2);
      if (press.el) press.el.classList.add(CLS);
    }, longMs || LONG_MS);
  }

  function pressEnd() {
    if (!press) return;
    var p = press; press = null;
    clearTimeout(p.timer);
    p.m.ptr('pointerup', 0); p.m.mouse('mouseup', 0);
    if (!p.long) p.m.mouse('click', 0);
  }

  // Мгновенный щелчок целиком (нажал-отпустил-click); для отложенного нажатия на плитке
  function quickClick(el) {
    if (!document.contains(el)) return;
    var m = mk(el);
    m.ptr('pointerover', 0); m.mouse('mouseover', 0);
    m.ptr('pointermove', 0); m.mouse('mousemove', 0);
    m.ptr('pointerdown', 1); m.mouse('mousedown', 1);
    try { if (m.tg.focus) m.tg.focus({ preventScroll: true }); } catch (e) {}
    m.ptr('pointerup', 0); m.mouse('mouseup', 0);
    m.mouse('click', 0);
  }

  var DC_LONG_START = 250, DC_DOUBLE_MS = 300;

  function flushPending() {
    if (!pendingTap) return;
    var el = pendingTap.el;
    clearTimeout(pendingTap.timer);
    pendingTap = null;
    quickClick(el);
  }

  // Выбираемые позиции внутри плитки/строки: значки плитки или варианты переключателя-сегментов
  // Для каждого варианта делаем прозрачную рамку-«прокси» на весь сегмент (ширина слайдера / число вариантов)
  var proxies = [], proxyHost = null;
  function clearProxies() { proxies.forEach(function (x) { if (x.parentNode) x.parentNode.removeChild(x); }); proxies = []; proxyHost = null; }
  function segTargets(sg) {
    // рамки создаются один раз при входе; иначе при каждом нажатии стрелки текущая рамка пропадала бы
    if (proxyHost === sg.ctl && proxies.length === sg.marks.length && proxies.every(function (x) { return document.contains(x); })) return proxies;
    clearProxies();
    proxyHost = sg.ctl;
    var cr = sg.ctl.getBoundingClientRect(), n = sg.marks.length, w = cr.width / n;
    return sg.marks.map(function (m) {
      var mr = m.getBoundingClientRect(), x = mr.left + mr.width / 2;
      var l = Math.max(cr.left, Math.min(cr.right - w, x - w / 2));
      var d = document.createElement('div');
      d.setAttribute('data-tvproxy', '1');
      d.style.cssText = 'position:fixed;pointer-events:none;visibility:hidden;left:' + l + 'px;top:' + cr.top + 'px;width:' + w + 'px;height:' + cr.height + 'px;border-radius:' + Math.round(cr.height / 2) + 'px';
      document.documentElement.appendChild(d);
      proxies.push(d);
      return d;
    });
  }
  function innerItems(host) {
    var sg = segMarks(host);
    return sg ? segTargets(sg) : innerControls(host);
  }

  function enterInner(host) {
    var items = innerItems(host);
    if (!items.length) { quickClick(host); return; }
    var sg = segMarks(host), first = items[0];
    if (sg) {
      var dot = sg.ctl.querySelector('.vue-slider-dot');
      if (dot) {
        var dr = dot.getBoundingClientRect(), dx = dr.left + dr.width / 2, bd = Infinity;
        items.forEach(function (it) {
          var r = it.getBoundingClientRect(), d = Math.abs(r.left + r.width / 2 - dx);
          if (d < bd) { bd = d; first = it; }
        });
      }
    } else {
      items.sort(function (a, b) {
        var ra = a.getBoundingClientRect(), rb = b.getBoundingClientRect();
        return (Math.round(ra.top / 20) - Math.round(rb.top / 20)) || (ra.left - rb.left);
      });
      first = items[0];
    }
    innerHost = host;
    setFocus(first);
  }

  function exitInner() {
    var h = innerHost;
    innerHost = null;
    clearProxies();
    if (h && document.contains(h)) setFocus(h); else setFocus(null);
  }

  // Плитка с вложенными кнопками: короткое OK ждёт 0,3 с (вдруг будет второе);
  // два быстрых OK = выбор вложенных кнопок; долгое OK = долгое нажатие, как раньше.
  // Переключение варианта: сначала обычный клик; если «ползунок» не сдвинулся, перетаскиваем его мышью, затем касанием
  function evAt(x, y, type, buttons, tg) {
    var base = { bubbles: true, cancelable: true, composed: true, view: window, clientX: x, clientY: y, screenX: x, screenY: y, button: 0, buttons: buttons };
    try {
      if (/^pointer/.test(type)) tg.dispatchEvent(new PointerEvent(type, Object.assign({}, base, { pointerId: 1, pointerType: 'mouse', isPrimary: true })));
      else tg.dispatchEvent(new MouseEvent(type, base));
    } catch (e) {}
  }
  function touchAt(type, x, y, tg) {
    try {
      var t = new Touch({ identifier: 7, target: tg, clientX: x, clientY: y, pageX: x, pageY: y, screenX: x, screenY: y });
      tg.dispatchEvent(new TouchEvent(type, { bubbles: true, cancelable: true, composed: true, view: window,
        touches: type === 'touchend' ? [] : [t], targetTouches: type === 'touchend' ? [] : [t], changedTouches: [t] }));
    } catch (e) {}
  }
  function activateSeg(sg, tx, ty) {
    var ctl = sg.ctl, dot = ctl.querySelector('.vue-slider-dot'), log = [];
    window.__tvSegLog = '';
    function dx() { if (!dot) return null; var r = dot.getBoundingClientRect(); return r.left + r.width / 2; }
    function done() { var d = dx(); return d === null || Math.abs(d - tx) < 20; }
    function under(x, y) { return document.elementFromPoint(x, y) || document.body; }
    function stepClick() {
      var m = { x: tx, y: ty }, tg = under(m.x, m.y);
      evAt(m.x, m.y, 'pointerover', 0, tg); evAt(m.x, m.y, 'mouseover', 0, tg);
      evAt(m.x, m.y, 'pointermove', 0, tg); evAt(m.x, m.y, 'mousemove', 0, tg);
      evAt(m.x, m.y, 'pointerdown', 1, tg); evAt(m.x, m.y, 'mousedown', 1, tg);
      evAt(m.x, m.y, 'pointerup', 0, tg); evAt(m.x, m.y, 'mouseup', 0, tg); evAt(m.x, m.y, 'click', 0, tg);
      log.push('клик');
    }
    function stepDrag() {
      var r = dot.getBoundingClientRect(), sx = r.left + r.width / 2, sy = r.top + r.height / 2;
      var tg = dot.querySelector('.vue-slider-dot-handle') || dot;   // прямо на бегунок, даже если его что-то перекрывает
      evAt(sx, sy, 'pointerdown', 1, tg); evAt(sx, sy, 'mousedown', 1, tg);
      for (var i = 1; i <= 6; i++) {
        var x = sx + (tx - sx) * i / 6;
        evAt(x, sy, 'pointermove', 1, document); evAt(x, sy, 'mousemove', 1, document);
        evAt(x, sy, 'pointermove', 1, document.body); evAt(x, sy, 'mousemove', 1, document.body);
      }
      evAt(tx, sy, 'pointerup', 0, document); evAt(tx, sy, 'mouseup', 0, document);
      log.push('перетаскивание');
    }
    function stepTouch() {
      var r = dot ? dot.getBoundingClientRect() : null, sx = r ? r.left + r.width / 2 : tx, sy = r ? r.top + r.height / 2 : ty, tg = under(sx, sy);
      touchAt('touchstart', sx, sy, tg);
      for (var i = 1; i <= 6; i++) touchAt('touchmove', sx + (tx - sx) * i / 6, sy, tg);
      touchAt('touchend', tx, sy, tg);
      log.push('касание');
    }
    stepClick();
    if (!dot) { window.__tvSegLog = log.join('+'); return; }
    setTimeout(function () {
      if (done()) { window.__tvSegLog = log.join('+') + ' OK'; return; }
      stepDrag();
      setTimeout(function () {
        if (done()) { window.__tvSegLog = log.join('+') + ' OK'; return; }
        stepTouch();
        setTimeout(function () { window.__tvSegLog = log.join('+') + (done() ? ' OK' : ' не помогло'); }, 450);
      }, 450);
    }, 450);
  }

  // ---- Ползунок (громкость, яркость): OK включает режим регулировки, стрелки влево/вправо меняют значение ----
  var adjCtl = null, adjHostEl = null, adjX = null, adjT = 0, adjLast = 0;
  function sliderOnly(el) {
    if (!el || el.nodeType !== 1 || segMarks(el)) return null;
    var ctl = sliderRoot(el);
    if (!ctl) return null;
    return ctl.querySelector('.vue-slider-dot') ? ctl : null;
  }
  function enterAdjust(el, ctl) {
    adjCtl = ctl; adjHostEl = el; adjX = null;
    setFocus(el);   // перекрасит рамку в оранжевый
  }
  function exitAdjust() {
    adjCtl = null;
    if (adjHostEl && document.contains(adjHostEl)) setFocus(adjHostEl);
    adjHostEl = null;
  }
  function adjustSlider(dir, ctlArg) {
    var ctl = ctlArg || adjCtl, dot = ctl && ctl.querySelector('.vue-slider-dot');
    if (!dot) return;
    var rail = ctl.querySelector('.vue-slider-rail') || ctl, rr = rail.getBoundingClientRect();
    var dr = dot.getBoundingClientRect(), sy = dr.top + dr.height / 2;
    var cx = (adjX !== null && Date.now() - adjT < 600) ? adjX : dr.left + dr.width / 2;
    var nx = Math.max(rr.left + 1, Math.min(rr.right - 1, cx + dir * rr.width * 0.04));
    adjX = nx; adjT = Date.now();
    var sx = dr.left + dr.width / 2, tg = dot.querySelector('.vue-slider-dot-handle') || dot;
    evAt(sx, sy, 'pointerdown', 1, tg); evAt(sx, sy, 'mousedown', 1, tg);
    for (var i = 1; i <= 3; i++) {
      var x = sx + (nx - sx) * i / 3;
      evAt(x, sy, 'pointermove', 1, document); evAt(x, sy, 'mousemove', 1, document);
      evAt(x, sy, 'pointermove', 1, document.body); evAt(x, sy, 'mousemove', 1, document.body);
    }
    evAt(nx, sy, 'pointerup', 0, document); evAt(nx, sy, 'mouseup', 0, document);
    // запасные способы, если ползунок не сдвинулся
    var before = sx;
    setTimeout(function () {
      var r2 = dot.getBoundingClientRect();
      if (Math.abs(r2.left + r2.width / 2 - before) >= 2) { window.__tvSegLog = 'ползунок: перетаскивание OK'; return; }
      try {
        dot.focus && dot.focus();
        var key = dir > 0 ? 'ArrowRight' : 'ArrowLeft';
        ['keydown', 'keyup'].forEach(function (t) {
          var e = new KeyboardEvent(t, { key: key, code: key, bubbles: true, cancelable: true });
          try { Object.defineProperty(e, 'keyCode', { get: function () { return dir > 0 ? 39 : 37; } }); } catch (x) {}
          dot.dispatchEvent(e);
        });
        window.__tvSegLog = 'ползунок: перетаскивание не сработало, послал клавиши';
      } catch (e) {}
    }, 260);
  }

  function onEnterDown(el) {
    if (adjCtl) { exitAdjust(); return; }
    if (!innerHost) { var sl = sliderOnly(el); if (sl) { enterAdjust(el, sl); return; } }
    if (!innerHost && segMarks(el)) { enterInner(el); return; }   // строка-переключатель: OK открывает выбор вариантов
    if (innerHost && segMarks(innerHost)) {                        // выбран вариант: нажимаем и возвращаемся к строке
      var hostRow = innerHost, idx = proxies.indexOf(el);
      var sg0 = segMarks(hostRow), box = el.getBoundingClientRect();
      var tcx = box.left + box.width / 2, tcy = box.top + box.height / 2;
      exitInner();
      activateSeg(sg0, tcx, tcy);
      return;
    }
    if (innerHost) { pressStart(el); return; }
    var dc = (tileHostSet.has(el) || (isPtr(el) && !findControl(el))) && innerControls(el).length > 0;
    if (!dc) { pressStart(el); return; }
    dcPress = { el: el, timer: null };
    dcPress.timer = setTimeout(function () {
      if (!dcPress) return;
      if (pendingTap) { clearTimeout(pendingTap.timer); pendingTap = null; }
      pressStart(dcPress.el, LONG_MS - DC_LONG_START);
    }, DC_LONG_START);
  }

  function isMediaTile(el) {
    try { return !!el.querySelector('video,canvas,img,iframe'); } catch (e) { return false; }
  }

  // Ряд-переключатель из vue-slider с метками («Все / Wi-Fi / нет сети»): стрелки влево/вправо
  // кликают соседнюю метку, OK ничего не делает (иначе нажмётся середина).
  var segLast = new WeakMap();
  // Корень слайдера (vue-slider) внутри выбранного элемента: findControl может вернуть вложенный «бегунок»
  function sliderRoot(el) {
    if (!el || el.nodeType !== 1) return null;
    if (/(^|\s)vue-slider(\s|$)/.test(el.getAttribute('class') || '')) return el;
    var all = el.querySelectorAll('.vue-slider');
    if (all.length === 1) return all[0];
    if (all.length > 1) return null;
    var c = findControl(el);
    return (c && c.closest) ? c.closest('.vue-slider') : null;
  }
  function segMarks(el) {
    var ctl = sliderRoot(el);
    if (!ctl) return null;
    var cont = ctl.querySelector('.vue-slider-marks'), marks = [];
    if (cont && cont.children.length >= 2) marks = [].slice.call(cont.children);
    else marks = [].slice.call(ctl.querySelectorAll('.vue-slider-mark'));
    if (marks.length < 2 || marks.length > 6) return null;
    marks.sort(function (a, b) { return a.getBoundingClientRect().left - b.getBoundingClientRect().left; });
    return { ctl: ctl, marks: marks };
  }
  function stepSeg(sg, dir) {
    var cx = function (e) { var r = e.getBoundingClientRect(); return r.left + r.width / 2; };
    var idx = 0, rec = segLast.get(sg.ctl);
    if (rec && Date.now() - rec.t < 800) idx = rec.i;
    else {
      var dot = sg.ctl.querySelector('.vue-slider-dot'), x = dot ? cx(dot) : null, bd = Infinity;
      if (x !== null) sg.marks.forEach(function (m, i) { var d = Math.abs(cx(m) - x); if (d < bd) { bd = d; idx = i; } });
    }
    var t = Math.max(0, Math.min(sg.marks.length - 1, idx + dir));
    segLast.set(sg.ctl, { i: t, t: Date.now() });
    if (t !== idx) quickClick(sg.marks[t]);
  }

  function isEnterKey(ev) {
    var k = ev.key;
    return k === 'Enter' || k === 'NumpadEnter' || k === 'Select' || ev.keyCode === 13 || ev.keyCode === 23;
  }

  function isEditable(el) {
    if (!el) return false;
    var t = el.tagName;
    return t === 'TEXTAREA' || (t === 'INPUT' && !/^(button|checkbox|radio|submit|reset|range|color|file|image)$/i.test(el.type));
  }

  document.addEventListener('keydown', function (ev) {
    var k = ev.key;
    var a = document.activeElement;
    if (aboutEl) {                       // окно «О приложении»: стрелки листают текст, OK закрывает
      if (k === 'ArrowUp' || k === 'ArrowDown') { if (aboutBox) aboutBox.scrollTop += (k === 'ArrowDown' ? 80 : -80); }
      else if (isEnterKey(ev)) { if (!ev.repeat) closeAbout(); }
      ev.preventDefault(); ev.stopPropagation();
      return;
    }
    // пока человек печатает в поле, стрелки влево/вправо не трогаем
    if (isEditable(a) && (k === 'ArrowLeft' || k === 'ArrowRight')) return;

    if (k === 'ArrowUp' || k === 'ArrowDown' || k === 'ArrowLeft' || k === 'ArrowRight') {
      if (isEditable(a)) { a.blur(); }
      if (adjCtl && (!document.contains(adjCtl) || !cur || cur !== adjHostEl)) { adjCtl = null; adjHostEl = null; }
      if (adjCtl) {
        if (k === 'ArrowLeft' || k === 'ArrowRight') {
          var nowT = Date.now();
          if (!ev.repeat || nowT - adjLast > 70) { adjLast = nowT; adjustSlider(k === 'ArrowRight' ? 1 : -1); }
          ev.preventDefault(); ev.stopPropagation();
          return;
        }
        exitAdjust();      // вверх/вниз: выходим из регулировки и идём к соседнему элементу
      }
      if (innerHost && (!document.contains(innerHost) || !hit(innerHost))) { innerHost = null; }
      if (innerHost) {
        // режим «внутри плитки»: стрелки двигаются только между её кнопками; дальше края = выход к плитке
        var wasSeg = !!segMarks(innerHost);
        var items = innerItems(innerHost);
        var nx = items.length ? pick(k, items) : null;
        if (nx) { setFocus(nx); ev.preventDefault(); ev.stopPropagation(); return; }
        exitInner();
        // у переключателя вверх/вниз сразу уходят к соседней строке
        if (!wasSeg) { ev.preventDefault(); ev.stopPropagation(); return; }
      }
      // широкая строка с ползунком (громкость): стрелки влево/вправо сразу меняют значение, OK не нужен
      if ((k === 'ArrowLeft' || k === 'ArrowRight') && cur && !innerHost && document.contains(cur)) {
        var dsl = sliderOnly(cur);
        if (dsl && cur.getBoundingClientRect().width >= innerWidth * 0.4) {
          var nt = Date.now();
          if (!ev.repeat || nt - adjLast > 70) { adjLast = nt; adjustSlider(k === 'ArrowRight' ? 1 : -1, dsl); }
          ev.preventDefault(); ev.stopPropagation();
          return;
        }
      }
      var list = candidates();
      var next;
      if (cur && activeLayer && !inLayer(cur)) { setFocus(null); }   // открылось окно: начинаем с него
      // если выбранный элемент пропал или оказался закрыт (открылось меню), начинаем сначала
      if (cur && (!document.contains(cur) || (!hit(cur) && !scrollClipped(cur)))) { setFocus(null); }
      if (!cur || !document.contains(cur)) {
        // первое нажатие: выбираем самый верхний левый видимый элемент
        next = null;
        var bestPos = Infinity;
        list.forEach(function (e) {
          var r = e.getBoundingClientRect();
          if (r.bottom < 0 || r.top > innerHeight) return;
          var pos = Math.round(r.top / 20) * 10000 + r.left;
          if (pos < bestPos) { bestPos = pos; next = e; }
        });
        if (!next && list.length) next = list[0];
      } else {
        next = pick(k, list);
      }
      if (next) {
        setFocus(next);
      } else if (k === 'ArrowDown') {
        window.scrollBy(0, 240);
      } else if (k === 'ArrowUp') {
        window.scrollBy(0, -240);
      } else if (!cur && list.length) {
        setFocus(list[0]);
      }
      ev.preventDefault();
      ev.stopPropagation();
    } else if (isEnterKey(ev)) {
      if (cur && document.contains(cur) && !isEditable(a)) {
        if (isEditable(cur)) { if (!ev.repeat) cur.focus(); }
        else if (!ev.repeat) { onEnterDown(cur); }
        ev.preventDefault();
        ev.stopPropagation();
      }
    }
  }, true);

  document.addEventListener('keyup', function (ev) {
    if (!isEnterKey(ev)) return;
    if (press) {                                   // долгое нажатие или обычное: отпускаем «мышь»
      pressEnd();
      if (dcPress) { clearTimeout(dcPress.timer); dcPress = null; }
      ev.preventDefault();
      ev.stopPropagation();
    } else if (dcPress) {                          // короткое OK на плитке с вложенными кнопками
      var d = dcPress; dcPress = null;
      clearTimeout(d.timer);
      if (isMediaTile(d.el)) {                     // плитка камеры: одно OK сразу открывает выбор микрофона/динамика
        if (pendingTap) { clearTimeout(pendingTap.timer); pendingTap = null; }
        enterInner(d.el);
      } else if (pendingTap && pendingTap.el === d.el) {  // второе быстрое OK: выбираем вложенные кнопки
        clearTimeout(pendingTap.timer); pendingTap = null;
        enterInner(d.el);
      } else {                                     // ждём: вдруг будет второе OK
        pendingTap = { el: d.el, timer: setTimeout(function () {
          var el = pendingTap && pendingTap.el; pendingTap = null;
          if (el) quickClick(el);
        }, DC_DOUBLE_MS) };
      }
      ev.preventDefault();
      ev.stopPropagation();
    }
  }, true);

  // ---- Кнопка «Назад»: выйти из режима «внутри» или закрыть открытое окно ----
  var lastBack = 0;
  function fireKey(type, key, code) {
    var e = new KeyboardEvent(type, { key: key, code: code, bubbles: true, cancelable: true });
    try { Object.defineProperty(e, 'keyCode', { get: function () { return 27; } }); } catch (x) {}
    try { Object.defineProperty(e, 'which', { get: function () { return 27; } }); } catch (x) {}
    (document.activeElement || document.body).dispatchEvent(e);
  }
  // Щелчок в «пустом» месте за пределами окна: так закрываются всплывающие панели
  function outsideClick() {
    var best = null, bestD = -1;
    var lr = activeLayer && activeLayer[0] ? activeLayer[0].getBoundingClientRect() : null;
    var lcx = lr ? (lr.left + lr.right) / 2 : innerWidth / 2, lcy = lr ? (lr.top + lr.bottom) / 2 : innerHeight / 2;
    var vp = innerWidth * innerHeight;
    for (var x = 24; x < innerWidth; x += 56) for (var y = 24; y < innerHeight; y += 56) {
      var el = document.elementFromPoint(x, y);
      if (!el) continue;
      if (activeLayer && activeLayer.some(function (r) { return r.contains(el); })) continue;
      var bad = false;
      for (var p = el; p && p !== document.documentElement; p = p.parentElement) {
        var r = p.getBoundingClientRect();
        if (r.width * r.height > vp * 0.25) continue;     // огромные контейнеры не считаем
        if ((window.__tvClickables && window.__tvClickables.has(p)) || isPtr(p) ||
            /^(A|BUTTON|INPUT|SELECT|TEXTAREA)$/.test(p.tagName)) { bad = true; break; }
      }
      if (bad) continue;
      var d = (x - lcx) * (x - lcx) + (y - lcy) * (y - lcy);
      if (d > bestD) { bestD = d; best = { el: el, x: x, y: y }; }
    }
    if (!best) return;
    var base = { bubbles: true, cancelable: true, composed: true, view: window, clientX: best.x, clientY: best.y, button: 0 };
    function pe(t, b) { try { best.el.dispatchEvent(new PointerEvent(t, Object.assign({}, base, { pointerId: 1, pointerType: 'mouse', isPrimary: true, buttons: b }))); } catch (x) {} }
    function me(t, b) { best.el.dispatchEvent(new MouseEvent(t, Object.assign({}, base, { buttons: b }))); }
    pe('pointerdown', 1); me('mousedown', 1); pe('pointerup', 0); me('mouseup', 0); me('click', 0);
  }
  // true = «Назад» обработано здесь; false = пусть приложение сделает «назад»/выйдет
  window.__tvBack = function () {
    if (aboutEl) { closeAbout(); return true; }
    if (setEl) { closeSettings(); return true; }
    if (adjCtl) { exitAdjust(); return true; }
    if (innerHost) { exitInner(); return true; }
    candidates();                                  // обновляем сведения об открытых окнах
    if (!activeLayer && !hasPopup) return false;
    var now = Date.now();
    if (now - lastBack < 1500) { lastBack = 0; return false; }   // окно не закрывается: второй «Назад» выходит из приложения
    lastBack = now;
    fireKey('keydown', 'Escape', 'Escape'); fireKey('keyup', 'Escape', 'Escape');
    setTimeout(function () { candidates(); if (activeLayer || hasPopup) outsideClick(); }, 150);
    return true;
  };

  // ---- Значок «Дом» слева вверху: долгое нажатие открывает настройки приложения ----
  function findHome() {
    // 1) ссылка «Дом» (значок-эмодзи + название) в левом верхнем углу
    var lbest = null, lbs = Infinity, links = document.querySelectorAll('a[href]');
    for (var li = 0; li < links.length && li < 200; li++) {
      var lr = links[li].getBoundingClientRect();
      if (lr.width < 40 || lr.height < 24 || lr.height > 130 || lr.width > 520) continue;
      if (lr.top < -5 || lr.top > 150 || lr.left < -5 || lr.left > 300) continue;
      if (links[li].closest('#__tvset')) continue;
      var lsc = lr.left + lr.top;
      if (lsc < lbs) { lbs = lsc; lbest = links[li]; }
    }
    if (lbest) return lbest;
    var best = null, bs = Infinity, nodes = document.querySelectorAll('img,svg,picture,canvas');
    function consider(e) {
      var r = e.getBoundingClientRect();
      if (r.width < 24 || r.height < 24 || r.width > 170 || r.height > 170) return;
      if (r.top < 0 || r.top > 170 || r.left < 0 || r.left > 280) return;
      if (e.closest && e.closest('[data-tvproxy],#__tvset')) return;
      var sc = r.left + r.top;
      if (sc < bs) { bs = sc; best = e; }
    }
    for (var i = 0; i < nodes.length && i < 300; i++) consider(nodes[i]);
    if (!best && document.body) {
      var all = document.body.getElementsByTagName('*');
      for (var j = 0; j < all.length && j < 1500; j++) {
        var r = all[j].getBoundingClientRect();
        if (r.top > 170 || r.left > 280 || r.width < 24) continue;
        if (getComputedStyle(all[j]).backgroundImage !== 'none') consider(all[j]);
      }
    }
    return best;
  }
  function isHomeTarget(el) {
    var h = findHome();
    if (!h || !el) return false;
    if (el === h || h.contains(el)) return true;
    if (el.contains(h)) { var r = el.getBoundingClientRect(); return r.height < 200 && r.width < 500; }
    return false;
  }

  var setEl = null, setPrev = null, lastShow = 0, suppClickUntil = 0;
  function noPullNow() { try { return localStorage.getItem('tvNoPull') === '1'; } catch (e) { return false; } }
  function closeSettings() {
    if (!setEl) return;
    setEl.remove(); setEl = null;
    var pv = setPrev; setPrev = null;
    if (pv && document.contains(pv)) setFocus(pv); else setFocus(null);
  }
  function uiFont() {
    try { return getComputedStyle(document.body).fontFamily || 'sans-serif'; } catch (e) { return 'sans-serif'; }
  }
  // Цвет окна берём у самого интерфейса (панель под центром экрана), иначе синий по умолчанию
  function themeBg() {
    var pts = [[0.3, 0.6], [0.7, 0.6], [0.5, 0.45], [0.5, 0.8]];
    for (var i = 0; i < pts.length; i++) {
      var e = document.elementFromPoint(innerWidth * pts[i][0], innerHeight * pts[i][1]);
      for (var n = 0; e && n < 12; e = e.parentElement, n++) {
        var m = /rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*([\d.]+))?\)/.exec(getComputedStyle(e).backgroundColor || '');
        if (m && (m[4] === undefined || parseFloat(m[4]) > 0.25)) {
          var r = +m[1], g = +m[2], b = +m[3];
          if (r + g + b > 90 && r + g + b < 720) return [r, g, b];
        }
      }
    }
    return [58, 96, 170];
  }
  // Берём оформление у настоящих панелей Sprut.hub: фон, градиент, размытие, рамка, тень
  function sprutPanelCss() {
    try {
      var vp = innerWidth * innerHeight, best = null, ba = 0;
      var all = document.body.getElementsByTagName('*');
      for (var i = 0; i < all.length && i < 5000; i++) {
        var e = all[i];
        if (e.closest && e.closest('#__tvset,#__tvabout')) continue;
        var r = e.getBoundingClientRect(), a = r.width * r.height;
        if (a < vp * 0.08 || a > vp * 0.7) continue;
        if (r.right < 0 || r.bottom < 0 || r.left > innerWidth || r.top > innerHeight) continue;
        var cs = getComputedStyle(e);
        if (cs.display === 'none' || cs.visibility === 'hidden') continue;
        if (!(parseFloat(cs.borderTopLeftRadius) >= 14)) continue;
        var m = /rgba?\((\d+),\s*(\d+),\s*(\d+)(?:,\s*([\d.]+))?\)/.exec(cs.backgroundColor || '');
        var hasCol = m && (m[4] === undefined || parseFloat(m[4]) > 0.05);
        var hasImg = cs.backgroundImage && cs.backgroundImage !== 'none' && /gradient/.test(cs.backgroundImage);
        if (!hasCol && !hasImg) continue;
        var bfx = cs.backdropFilter || cs.webkitBackdropFilter;
        var glass = bfx && bfx !== 'none' ? 1 : 0;       // настоящие «стеклянные» панели важнее обычных блоков
        var sc = glass * 1e9 + a;
        if (sc <= ba) continue;
        best = { cs: cs, m: m, hasCol: hasCol, hasImg: hasImg }; ba = sc;
        window.__tvPanelLog = '<' + e.tagName.toLowerCase() + ' ' + String(e.getAttribute('class') || '').slice(0, 30) + '> bg=' + cs.backgroundColor +
          ' img=' + String(cs.backgroundImage).slice(0, 70) + ' blur=' + (bfx || 'нет') + ' ' + Math.round(r.width) + 'x' + Math.round(r.height);
      }
      if (!best) return null;
      var cs2 = best.cs, css = '';
      if (best.hasCol) {
        var al = best.m[4] === undefined ? 1 : parseFloat(best.m[4]);
        css += 'background-color:rgba(' + best.m[1] + ',' + best.m[2] + ',' + best.m[3] + ',' + al + ');';   // прозрачность как у сайта
      } else css += 'background-color:rgba(40,70,140,.7);';
      if (best.hasImg) css += 'background-image:' + cs2.backgroundImage + ';';
      var bf = cs2.backdropFilter || cs2.webkitBackdropFilter;
      css += '-webkit-backdrop-filter:' + (bf && bf !== 'none' ? bf : 'blur(22px)') + ';backdrop-filter:' + (bf && bf !== 'none' ? bf : 'blur(22px)') + ';';
      var bw = parseFloat(cs2.borderTopWidth) || 0;
      css += bw > 0 ? 'border:' + cs2.borderTopWidth + ' ' + cs2.borderTopStyle + ' ' + cs2.borderTopColor + ';'
                    : 'border:1px solid rgba(255,255,255,.35);';
      css += 'box-shadow:' + (cs2.boxShadow && cs2.boxShadow !== 'none' ? cs2.boxShadow : '0 14px 50px rgba(0,0,0,.45)') + ';color:#fff;';
      return css;
    } catch (e) { return null; }
  }
  // Тёмное стекло в тон интерфейсу Sprut.hub: тёмно-синий полупрозрачный фон, размытие, тонкая светлая рамка
  function glassTheme() {
    return 'background-color:rgba(24,32,52,.86);' +
      'background-image:linear-gradient(160deg,rgba(255,255,255,.10),rgba(255,255,255,0) 55%);' +
      '-webkit-backdrop-filter:blur(24px);backdrop-filter:blur(24px);border:1px solid rgba(255,255,255,.2);' +
      'box-shadow:0 14px 50px rgba(0,0,0,.55);color:#fff;';
  }
  var GLASS = 'background:linear-gradient(160deg,rgba(135,155,170,.80),rgba(88,108,124,.86));' +
    '-webkit-backdrop-filter:blur(22px);backdrop-filter:blur(22px);border:1px solid rgba(255,255,255,.38);' +
    'box-shadow:0 14px 50px rgba(0,0,0,.5);color:#fff;';
  function backdrop(id) {
    var w = document.createElement('div');
    w.id = id;
    w.style.cssText = 'position:fixed;left:0;top:0;right:0;bottom:0;z-index:2147483000;background:rgba(0,0,0,.1);' +
      '-webkit-backdrop-filter:blur(8px);backdrop-filter:blur(8px);display:flex;align-items:center;justify-content:center;font-family:' + uiFont();
    return w;
  }

  // ---- «О приложении» ----
  var aboutEl = null, aboutBox = null, aboutPrev = null;
  function closeAbout() {
    if (!aboutEl) return;
    aboutEl.remove(); aboutEl = null; aboutBox = null;
    var pv = aboutPrev; aboutPrev = null;
    if (pv && document.contains(pv)) setFocus(pv);   // возвращаем рамку на пункт меню
  }
  function showAbout() {
    if (aboutEl) return;
    aboutPrev = cur;
    setFocus(null);                                  // рамка выбора не должна висеть над текстом
    var w = backdrop('__tvabout');
    var panel = document.createElement('div');
    panel.style.cssText = glassTheme() + 'border-radius:32px;padding:22px 26px;width:min(560px,90vw);max-height:84vh;overflow-y:auto;box-sizing:border-box';
    var h = document.createElement('div');
    h.textContent = 'О приложении';
    h.style.cssText = 'font:700 22px/1.2 ' + uiFont() + ';text-align:center;text-transform:uppercase;margin-bottom:14px';
    panel.appendChild(h);
    var paras = [
      ['Неофициальное приложение.', true],
      ['Это приложение создано независимым разработчиком и представляет собой альтернативную оболочку веб-интерфейса Sprut.hub.', false],
      ['Приложение не является официальным продуктом Sprut.hub и не связано с его разработчиками.', false],
      ['Sprut.hub — обозначение, принадлежащее соответствующему правообладателю. Все права на оригинальный веб-интерфейс и связанные материалы сохраняются за их законными правообладателями.', false],
      ['Приложение предоставляется бесплатно «как есть».', false]
    ];
    paras.forEach(function (pr) {
      var d = document.createElement('div');
      d.textContent = pr[0];
      d.style.cssText = 'font:' + (pr[1] ? '700 19px/1.35 ' : '400 17px/1.4 ') + uiFont() + ';margin:0 0 12px';
      panel.appendChild(d);
    });
    var hint = document.createElement('div');
    hint.textContent = 'Назад или OK — закрыть';
    hint.style.cssText = 'font:400 14px ' + uiFont() + ';opacity:.7;text-align:center;margin-top:6px';
    panel.appendChild(hint);
    w.appendChild(panel);
    w.addEventListener('click', function (ev) { ev.stopPropagation(); closeAbout(); });
    document.documentElement.appendChild(w);
    aboutEl = w; aboutBox = panel;
  }

  // ---- Настройки приложения (долгое нажатие на «Дом») ----
  function showSettings() {
    if (setEl || Date.now() - lastShow < 700) return;
    lastShow = Date.now();
    suppClickUntil = lastShow + 900;   // «щелчок» от долгого касания не должен закрыть окно или открыть ссылку
    setPrev = cur;
    var fam = uiFont();
    var w = backdrop('__tvset');
    var panel = document.createElement('div');
    panel.style.cssText = glassTheme() + 'border-radius:32px;padding:20px 22px 18px;width:min(520px,92vw);max-height:90vh;overflow-y:auto;box-sizing:border-box';
    var title = document.createElement('div');
    title.textContent = 'Настройки приложения';
    title.style.cssText = 'font:700 22px/1.2 ' + fam + ';text-align:center;text-transform:uppercase;margin:0 0 4px';
    panel.appendChild(title);
    var css = document.createElement('style');
    css.textContent = '.tvg>button{border-bottom:1px solid rgba(255,255,255,.26)!important}.tvg>button:last-child{border-bottom:0!important}';
    panel.appendChild(css);
    var grp = null;
    // группа-«карточка» с маленьким заголовком капсом, как разделы в интерфейсе Sprut.hub
    function group(head) {
      grp = document.createElement('div');
      grp.className = 'tvg';
      grp.style.cssText = 'background:rgba(255,255,255,.12);border:1px solid rgba(255,255,255,.18);border-radius:26px;padding:2px 18px 2px;margin:14px 0 0';
      var h = document.createElement('div');
      h.textContent = head;
      h.style.cssText = 'font:500 14px/1 ' + fam + ';letter-spacing:.06em;text-transform:uppercase;opacity:.85;padding:14px 4px 12px;border-bottom:1px solid rgba(255,255,255,.26)';
      grp.appendChild(h);
      panel.appendChild(grp);
    }

    // строка в стиле интерфейса Sprut.hub: подпись слева (и пояснение), переключатель справа, тонкая линия снизу
    function row(label, note, fn, sw, last, valFn) {
      var b = document.createElement('button');
      b.type = 'button';
      b.style.cssText = 'display:flex;align-items:center;justify-content:space-between;width:100%;box-sizing:border-box;' +
        'text-align:left;margin:0;padding:15px 6px;background:transparent;border:0;color:#fff;cursor:pointer;font-family:' + fam + ';' +
        '';
      var left = document.createElement('div');
      left.style.cssText = 'flex:1;min-width:0';
      var l1 = document.createElement('div');
      l1.style.cssText = 'font:600 20px/1.25 ' + fam;
      left.appendChild(l1);
      var l2 = document.createElement('div');
      l2.style.cssText = 'font:400 14px/1.3 ' + fam + ';opacity:.78;margin-top:4px;white-space:normal';
      left.appendChild(l2);
      b.appendChild(left);
      var knob = null, track = null, valEl = null;
      if (valFn) {
        valEl = document.createElement('div');
        valEl.style.cssText = 'flex:none;margin-left:14px;min-width:84px;text-align:center;padding:7px 12px;border-radius:18px;box-sizing:border-box;' +
          'border:2px solid rgba(255,255,255,.45);background:rgba(255,255,255,.14);font:600 18px/1 ' + fam;
        b.appendChild(valEl);
      }
      if (sw) {
        track = document.createElement('div');
        track.style.cssText = 'flex:none;margin-left:14px;width:64px;height:34px;border-radius:17px;box-sizing:border-box;' +
          'border:2px solid rgba(255,255,255,.45);background:rgba(255,255,255,.14);position:relative';
        knob = document.createElement('div');
        knob.style.cssText = 'position:absolute;top:2px;width:26px;height:26px;border-radius:13px;box-sizing:border-box;border:2px solid #FFA400;transition:left .15s';
        track.appendChild(knob);
        b.appendChild(track);
      }
      function paint() {
        var st = sw ? sw.get() : null;
        l1.textContent = typeof label === 'function' ? label(st) : label;
        var nt = typeof note === 'function' ? note(st) : note;
        l2.textContent = nt || '';
        l2.style.display = nt ? 'block' : 'none';
        if (valEl) valEl.textContent = valFn();
        if (knob) {
          knob.style.left = st ? '32px' : '2px';
          knob.style.background = st ? '#FFA400' : 'transparent';
        }
      }
      paint();
      b.addEventListener('click', function (ev) { ev.stopPropagation(); fn(b); paint(); });
      (grp || panel).appendChild(b);
      return b;
    }

    group('Страница');
    var first = row('Обновить страницу', '', function () { location.reload(); });
    row('Обновление страницы свайпом вниз', 'Только для телефонов и планшетов', function () {
      try { localStorage.setItem('tvNoPull', noPullNow() ? '0' : '1'); } catch (e) {}
    }, { get: function () { return !noPullNow(); } });
    // масштаб интерфейса (как DPI): нужен для головных устройств автомобиля с мелким экраном
    if (window.TvBridge && window.TvBridge.getScale && window.TvBridge.setScale) {
      var STEPS = [100, 115, 130, 150, 175, 200];
      group('Экран');
      row('Масштаб интерфейса', 'Для головного устройства автомобиля. Нажмите, чтобы увеличить, после 200% — снова 100%. При переходе с 100% и обратно страница перезагрузится', function (b) {
        var c = +window.TvBridge.getScale() || 100, i = 0;
        for (var k = 0; k < STEPS.length; k++) if (STEPS[k] <= c) i = k;
        window.TvBridge.setScale(STEPS[(i + 1) % STEPS.length]);
        setTimeout(function () { if (document.contains(b)) { setFocus(null); setFocus(b); } }, 400);   // рамка выбора перестраивается после смены масштаба
      }, null, false, function () { return (+window.TvBridge.getScale() || 100) + '%'; });
    }
    group('Приложение');
    row('О приложении', '', function () { showAbout(); });
    var dbgRow = row('Отладка', function () { return null; }, function () { window.__tvSetDebugArmed(!dbgArmed); }, { get: function () { return dbgArmed; } });
    // подпись отладки меняется при включении: подсказка, чем её вызывать
    var dbgNote = dbgRow.querySelector('div > div:nth-child(2)');
    function dbgHint() {
      if (dbgNote) {
        dbgNote.textContent = dbgArmed ? 'Для показа панели закройте меню и нажмите на пульте кнопку МЕНЮ, INFO или 0'
                                       : 'Показ сведений об элементе для разработчика';
        dbgNote.style.display = 'block';
      }
    }
    dbgHint();
    dbgRow.addEventListener('click', dbgHint);
    row('Выйти из приложения', '', function () {
      if (window.TvBridge && window.TvBridge.exit) window.TvBridge.exit(); else window.close();
    }, null, true);
    w.appendChild(panel);
    w.addEventListener('click', function (ev) { if (ev.target === w) closeSettings(); });
    document.documentElement.appendChild(w);
    setEl = w;
    setFocus(first);
  }
  // сенсорный экран/мышь: долгое нажатие на значок (контекстное меню) тоже открывает настройки
  document.addEventListener('contextmenu', function (ev) {
    if (setEl) return;
    if (isHomeTarget(ev.target)) { showSettings(); ev.preventDefault(); ev.stopPropagation(); }
  }, true);
  (function () {
    var tm = null, sx = 0, sy = 0;
    document.addEventListener('touchstart', function (ev) {
      clearTimeout(tm);
      if (setEl || ev.touches.length !== 1) return;
      var t = ev.touches[0]; sx = t.clientX; sy = t.clientY;
      if (!isHomeTarget(ev.target)) return;
      tm = setTimeout(function () { showSettings(); }, 650);
    }, { passive: true, capture: true });
    document.addEventListener('touchmove', function (ev) {
      var t = ev.touches[0];
      if (t && Math.abs(t.clientX - sx) + Math.abs(t.clientY - sy) > 14) clearTimeout(tm);
    }, { passive: true, capture: true });
    ['touchend', 'touchcancel'].forEach(function (n) {
      document.addEventListener(n, function () { clearTimeout(tm); }, { passive: true, capture: true });
    });
    document.addEventListener('click', function (ev) {      // после долгого нажатия обычный клик не нужен
      if (ev.isTrusted && Date.now() < suppClickUntil) { ev.stopPropagation(); ev.preventDefault(); }
    }, true);
  })();

  // ---- Отладочная панель: показывает, как устроен выбранный элемент ----
  var dbgBox = null, dbgOn = false;
  function esc(s) { return String(s).replace(/&/g, '&amp;').replace(/</g, '&lt;'); }
  function shortCls(k) { var c = (k.getAttribute('class') || '').replace(/\s+/g, ' '); return c.length > 46 ? c.slice(0, 46) + '…' : c; }
  // Отладка включается в настройках (долгое нажатие на «Дом») и сама показывает сведения о выбранном элементе
  function renderDebug() {
    if (!dbgOn) { if (dbgBox) { dbgBox.remove(); dbgBox = null; } return; }
    if (!dbgBox || !dbgBox.isConnected) {
      dbgBox = document.createElement('div');
      dbgBox.style.cssText = 'position:fixed;left:0;right:0;bottom:0;max-height:62vh;overflow:hidden;z-index:2147483647;' +
        'background:rgba(0,0,0,.93);color:#7CFC00;font:12px/1.22 monospace;padding:6px 10px;white-space:pre-wrap;word-break:break-all;pointer-events:none';
      document.documentElement.appendChild(dbgBox);
    }
    var el = cur, txt;
    if (!el) {
      txt = 'Отладка включена. Выберите элемент стрелками.';
    } else {
      var ctl = findControl(el);
      var tr = (ctl || el).getBoundingClientRect(), r0 = el.getBoundingClientRect();
      var lines = [];
      lines.push('EL: <' + el.tagName.toLowerCase() + '> class="' + shortCls(el) + '" id="' + el.id + '"  ' +
        Math.round(r0.width) + 'x' + Math.round(r0.height) + ' @' + Math.round(r0.left) + ',' + Math.round(r0.top));
      lines.push('tracked=' + !!(window.__tvClickables && window.__tvClickables.has(el)) + ' cursor=' + getComputedStyle(el).cursor +
        (tileHostSet.has(el) ? ' TILE' : '') + (isMediaTile(el) ? ' MEDIA' : '') + (isProxy(el) ? ' PROXY' : ''));
      lines.push('CONTROL: ' + (ctl ? '<' + ctl.tagName.toLowerCase() + '> class="' + shortCls(ctl) + '"' : 'нет (нажатие в центр)'));
      var sgd = segMarks(el), cont = ctl && ctl.querySelector && ctl.querySelector('.vue-slider-marks');
      lines.push('SEG: ' + (sgd ? 'меток ' + sgd.marks.length : 'нет') + (cont ? ' детей=' + cont.children.length : '') +
        (window.__tvSegLog ? '  LOG: ' + window.__tvSegLog : ''));
      if (window.__tvPanelLog) lines.push('PANEL: ' + window.__tvPanelLog);
      lines.push('TAP at ' + Math.round(tr.left + tr.width / 2) + ',' + Math.round(tr.top + tr.height / 2) +
        '  layer=' + (activeLayer ? 'да' : 'нет') + ' popup=' + (hasPopup ? 'да' : 'нет') + ' inner=' + (innerHost ? 'да' : 'нет'));
      var kids = el.getElementsByTagName('*'), n = 0;
      for (var i = 0; i < kids.length && n < 24; i++) {
        var k = kids[i], tracked = window.__tvClickables && window.__tvClickables.has(k);
        var cp = getComputedStyle(k).cursor === 'pointer';
        if (tracked || cp || /INPUT|BUTTON|SELECT|SVG/i.test(k.tagName) || k.getAttribute('role')) {
          lines.push(' · <' + k.tagName.toLowerCase() + '> ' + shortCls(k) +
            (k.getAttribute('role') ? ' role=' + k.getAttribute('role') : '') + (tracked ? ' [L]' : '') + (cp ? ' [P]' : ''));
          n++;
        }
      }
      txt = esc(lines.join('\n')) + '\n' + esc(el.outerHTML.slice(0, 360));
    }
    dbgBox.innerHTML = txt;
  }
  // Отладка: включается в меню «Дом»; после этого кнопки МЕНЮ / INFO / 0 показывают и прячут панель
  var dbgArmed = false;
  try { dbgArmed = sessionStorage.getItem('tvDbgArmed') === '1'; } catch (e) {}
  window.__tvSetDebugArmed = function (v) {
    dbgArmed = !!v;
    try { sessionStorage.setItem('tvDbgArmed', v ? '1' : '0'); } catch (e) {}
    if (!v) { dbgOn = false; renderDebug(); }
  };
  window.__tvDebugKey = function () {
    if (!dbgArmed) return false;
    dbgOn = !dbgOn; renderDebug(); return true;
  };
  document.addEventListener('keydown', function (ev) {
    if (ev.key === 'ContextMenu' || ev.key === 'F1' || ev.key === 'Info' || ev.key === '0') {
      if (window.__tvDebugKey()) ev.preventDefault();
    }
  }, true);
  setInterval(function () { if (dbgOn) renderDebug(); }, 700);

  // ---- Обновление страницы: свайп вниз от верха страницы и удержание 1 секунду (сенсорный экран) ----
  (function () {
    var PULL_PX = 90, HOLD_MS = 1000, DRAG_MAX = 260;
    function noPull() { try { return localStorage.getItem('tvNoPull') === '1'; } catch (e) { return false; } }
    var t0 = null, armedAt = 0, timer = null, bar = null, startX = 0, startY = 0, tracking = false;

    function atTop(target) {
      if ((window.scrollY || document.documentElement.scrollTop || 0) > 0) return false;
      for (var p = target; p && p !== document.documentElement; p = p.parentElement) {
        if (p.nodeType !== 1) continue;
        var cs = getComputedStyle(p);
        if (/(auto|scroll)/.test(cs.overflowY) && p.scrollHeight > p.clientHeight + 2 && p.scrollTop > 0) return false;
      }
      return true;
    }

    function ui() {
      if (bar && bar.isConnected) return bar;
      bar = document.createElement('div');
      bar.style.cssText = 'position:fixed;left:50%;top:0;transform:translate(-50%,-100%);z-index:2147483647;' +
        'pointer-events:none;background:rgba(20,20,20,.92);color:#fff;font:600 15px/1 sans-serif;' +
        'padding:12px 18px 14px;border-radius:0 0 16px 16px;min-width:200px;text-align:center;' +
        'box-shadow:0 4px 14px rgba(0,0,0,.5);transition:transform .15s';
      bar.innerHTML = '<div id="__ptrtxt">Потяните вниз и удерживайте</div>' +
        '<div style="margin-top:9px;height:4px;border-radius:2px;background:rgba(255,255,255,.2);overflow:hidden">' +
        '<div id="__ptrfill" style="height:100%;width:0;background:#4FC3F7"></div></div>';
      document.documentElement.appendChild(bar);
      return bar;
    }

    function reset() {
      clearTimeout(timer); timer = null; armedAt = 0; tracking = false;
      if (bar) { bar.style.transform = 'translate(-50%,-100%)'; var f = bar.querySelector('#__ptrfill'); if (f) { f.style.transition = 'none'; f.style.width = '0'; } }
    }

    function arm() {
      if (armedAt) return;
      armedAt = Date.now();
      var b = ui(), f = b.querySelector('#__ptrfill');
      b.querySelector('#__ptrtxt').textContent = 'Держите…';
      f.style.transition = 'none'; f.style.width = '0';
      void f.offsetWidth;
      f.style.transition = 'width ' + HOLD_MS + 'ms linear'; f.style.width = '100%';
      timer = setTimeout(function () {
        ui().querySelector('#__ptrtxt').textContent = 'Обновляю…';
        location.reload();
      }, HOLD_MS);
    }

    document.addEventListener('touchstart', function (ev) {
      if (ev.touches.length !== 1) { reset(); return; }
      var t = ev.touches[0];
      startX = t.clientX; startY = t.clientY;
      tracking = atTop(ev.target) && !noPull();
    }, { passive: true, capture: true });

    document.addEventListener('touchmove', function (ev) {
      if (!tracking || ev.touches.length !== 1) return;
      var t = ev.touches[0], dy = t.clientY - startY, dx = Math.abs(t.clientX - startX);
      if (dy < 0 || dx > Math.max(60, dy)) { if (armedAt || dy < -20) reset(); return; }   // не вниз: отменяем
      var b = ui();
      var shift = Math.min(dy, DRAG_MAX) * 0.35;
      b.style.transform = 'translate(-50%,' + (-100 + shift / 0.6) + '%)';
      if (dy >= PULL_PX) arm();
      else if (armedAt) reset(), tracking = true;   // вернули палец вверх: начинаем заново
    }, { passive: true, capture: true });

    ['touchend', 'touchcancel'].forEach(function (n) {
      document.addEventListener(n, function () { reset(); }, { passive: true, capture: true });
    });
  })();

  // если окно потеряло фокус при зажатой кнопке, отпускаем «мышь»
  window.addEventListener('blur', function () { pressEnd(); });

  // если страница сменилась (SPA), старый элемент мог исчезнуть
  new MutationObserver(function () {
    if (cur && !document.contains(cur)) cur = null;
  }).observe(document.documentElement, { childList: true, subtree: true });
})();
