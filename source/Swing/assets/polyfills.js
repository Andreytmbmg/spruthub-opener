;(function(){
 if(window.__gateDiagnostics)return;
 window.__gateDiagnostics=true;
 var last='';
 function report(message){
   last=String(message).replace(/(?:token|password|authorization)\s*[:=]\s*\S+/ig,'[скрыто]').slice(0,210);
   console.error('GATE_DIAG:'+last+' · Нажмите нижнюю строку для повтора');
 }
 window.addEventListener('error',function(e){
   if(e.target&&e.target.tagName==='SCRIPT')report('Не загружен файл страницы: '+String(e.target.src||'').split('/').pop().split('?')[0]);
   else if(e.message)report('Ошибка страницы: '+e.message+' (строка '+(e.lineno||'?')+')');
 },true);
 window.addEventListener('unhandledrejection',function(e){
   var r=e.reason;
   report('Сбой страницы: '+(r&&r.message?r.message:'ошибка JavaScript'));
 });
 setTimeout(function(){
   var root=document.getElementById('__root');
   if(!root||(!root.children.length&&!root.textContent)){
     if(!last)report('Страница входа не запустилась. WebView '+(navigator.userAgent.match(/Chrome\/([\d.]+)/)||['','?'])[1]);
   }
 },30000);
})();
(function () {
  if (window.__tvPoly) return;
  window.__tvPoly = [];
  function note(n) { try { window.__tvPoly.push(n); } catch (e) {} }
  function def(o, n, f) {
    if (!o[n]) {
      try { Object.defineProperty(o, n, { value: f, writable: true, configurable: true }); note(n); } catch (e) {}
    }
  }

  // Флаг "d" в RegExp (Chrome 90+): принимаем и игнорируем
  try { new RegExp('', 'd'); } catch (e) {
    var N = RegExp;
    var R = function RegExp(p, f) {
      if (typeof f === 'string') f = f.replace(/d/g, '');
      return (this instanceof R) ? new N(p, f) : N(p, f);
    };
    R.prototype = N.prototype;
    try { Object.defineProperty(N.prototype, 'constructor', { value: R, writable: true, configurable: true }); } catch (e2) {}
    try { Object.setPrototypeOf(R, N); } catch (e3) {}
    try { if (N[Symbol.species]) Object.defineProperty(R, Symbol.species, { get: function () { return R; } }); } catch (e4) {}
    window.RegExp = R;
    note('RegExp /d');
  }

  def(Array.prototype, 'at', function (i) { i = Math.trunc(i) || 0; if (i < 0) i += this.length; return this[i]; });
  def(String.prototype, 'at', function (i) { i = Math.trunc(i) || 0; if (i < 0) i += this.length; return this.charAt(i); });
  def(Array.prototype, 'findLast', function (f, t) { for (var i = this.length - 1; i >= 0; i--) if (f.call(t, this[i], i, this)) return this[i]; });
  def(Array.prototype, 'findLastIndex', function (f, t) { for (var i = this.length - 1; i >= 0; i--) if (f.call(t, this[i], i, this)) return i; return -1; });
  def(Array.prototype, 'toSorted', function (c) { return this.slice().sort(c); });
  def(Array.prototype, 'toReversed', function () { return this.slice().reverse(); });
  def(Array.prototype, 'toSpliced', function () { var a = this.slice(); a.splice.apply(a, arguments); return a; });
  def(Array.prototype, 'with', function (i, v) { var a = this.slice(); if (i < 0) i += a.length; a[i] = v; return a; });
  def(Object, 'hasOwn', function (o, k) { return Object.prototype.hasOwnProperty.call(o, k); });
  def(String.prototype, 'replaceAll', function (s, r) {
    if (s instanceof RegExp) {
      if (s.flags.indexOf('g') < 0) throw new TypeError('replaceAll must be called with a global RegExp');
      return this.replace(s, r);
    }
    s = String(s);
    var str = String(this);
    if (typeof r === 'function') {
      var out = '', pos = 0, idx;
      if (s === '') return str.replace(/(?:)/g, function (m, o) { return r(m, o, str); });
      while ((idx = str.indexOf(s, pos)) !== -1) { out += str.slice(pos, idx) + r(s, idx, str); pos = idx + s.length; }
      return out + str.slice(pos);
    }
    return str.split(s).join(String(r).replace(/\$\$/g, '$'));
  });
  if (typeof AggregateError === 'undefined') {
    window.AggregateError = function AggregateError(errs, msg) {
      var e = new Error(msg); e.name = 'AggregateError'; e.errors = Array.prototype.slice.call(errs || []); return e;
    };
    note('AggregateError');
  }
  def(Promise, 'any', function (list) {
    var items = Array.prototype.slice.call(list);
    return new Promise(function (res, rej) {
      var errs = [], left = items.length;
      if (!left) return rej(new AggregateError([], 'All promises were rejected'));
      items.forEach(function (p, i) {
        Promise.resolve(p).then(res, function (e) {
          errs[i] = e; if (--left === 0) rej(new AggregateError(errs, 'All promises were rejected'));
        });
      });
    });
  });
  if (typeof structuredClone !== 'function') {
    window.structuredClone = function (v) {
      return (function c2(x) {
        if (x === null || typeof x !== 'object') return x;
        if (typeof x === 'function') throw new Error('DataCloneError');
        var m = new Map();
        return (function cl(y) {
          if (y === null || typeof y !== 'object') return y;
          if (m.has(y)) return m.get(y);
          var o;
          if (y instanceof Date) return new Date(y.getTime());
          if (y instanceof RegExp) return new RegExp(y.source, y.flags);
          if (y instanceof Map) { o = new Map(); m.set(y, o); y.forEach(function (val, k) { o.set(cl(k), cl(val)); }); return o; }
          if (y instanceof Set) { o = new Set(); m.set(y, o); y.forEach(function (val) { o.add(cl(val)); }); return o; }
          if (ArrayBuffer.isView(y) || y instanceof ArrayBuffer) return y.slice ? y.slice(0) : y;
          o = Array.isArray(y) ? [] : {};
          m.set(y, o);
          Object.keys(y).forEach(function (k) { o[k] = cl(y[k]); });
          return o;
        })(x);
      })(v);
    };
    note('structuredClone');
  }
  try {
    if (window.crypto && !crypto.randomUUID) {
      crypto.randomUUID = function () {
        var b = new Uint8Array(16); crypto.getRandomValues(b);
        b[6] = (b[6] & 15) | 64; b[8] = (b[8] & 63) | 128;
        var h = Array.prototype.map.call(b, function (x) { return ('0' + x.toString(16)).slice(-2); }).join('');
        return h.slice(0, 8) + '-' + h.slice(8, 12) + '-' + h.slice(12, 16) + '-' + h.slice(16, 20) + '-' + h.slice(20);
      };
      note('crypto.randomUUID');
    }
  } catch (e) {}
  try {
    if (window.AbortSignal && !AbortSignal.timeout) {
      AbortSignal.timeout = function (ms) { var c = new AbortController(); setTimeout(function () { c.abort(); }, ms); return c.signal; };
      note('AbortSignal.timeout');
    }
  } catch (e) {}
  try {
    if (window.Element && !Element.prototype.replaceChildren) {
      Element.prototype.replaceChildren = function () {
        while (this.firstChild) this.removeChild(this.firstChild);
        this.append.apply(this, arguments);
      };
      note('replaceChildren');
    }
  } catch (e) {}
})();
;(function(){
  if(window.__gateSetupHook||!window.WebSocket)return;
  window.__gateSetupHook=true;
  var original=window.WebSocket.prototype.send, generation=0, panel=null;
  function status(s){try{console.error('GATE_DIAG:Привязка: '+s);}catch(e){}}
  function number(x){if(typeof x==='number')return isFinite(x)&&Math.floor(x)===x?x:null;if(typeof x==='string'&&/^[0-9]+$/.test(x))return +x;return null;}
  function remove(){if(panel&&panel.parentNode)panel.parentNode.removeChild(panel);panel=null;}
  function command(m){
    var c=m&&m.params&&m.params.characteristic&&m.params.characteristic.update;
    if(!m||!c||!(!m.method||m.method==='characteristic.update'))return null;
    status('команда обнаружена, проверяю адрес');
    var aid=number(c.aId),sid=number(c.sId),cid=number(c.cId);
    if((typeof m.id!=='number'&&typeof m.id!=='string')||typeof m.serial!=='string'||!m.serial||
       aid===null||aid<=0||sid===null||sid<=0||cid===null||cid<=0||!c.control||!c.control.value){status('не удалось прочитать адрес команды');return null;}
    var v=c.control.value;
    if(Object.prototype.hasOwnProperty.call(v,'intValue')){
      if(number(v.intValue)===null){status('неподдерживаемое целочисленное значение');return null;}
    }else if(typeof v.boolValue!=='boolean'){status('ожидается команда intValue или boolValue');return null;}
    return JSON.parse(JSON.stringify({aId:aid,sId:sid,cId:cid,control:c.control}));
  }
  function offer(p){
    if(p.generation!==generation||window.__gateSetupReady)return;
    remove();
    if(!document.body){status('нет области страницы для выбора');return;}
    var box=document.createElement('div');panel=box;
    box.style.cssText='position:fixed;left:0;top:0;right:0;bottom:0;z-index:2147483647;background:rgba(0,0,0,.8);display:flex;align-items:center;justify-content:center;padding:20px;font-family:sans-serif;color:white';
    var card=document.createElement('div');card.style.cssText='max-width:560px;padding:26px;border-radius:20px;background:#252b35;box-shadow:0 8px 36px #000';
    var title=document.createElement('h2');title.textContent='Запомнить выбранное устройство?';
    var desc=document.createElement('p');desc.textContent='SprutHub принял команду. Сохраните её, только если вы сейчас открыли нужный замок, дверь или ворота. Следующие нажатия значка будут повторять эту команду.';
    var save=document.createElement('button');save.textContent='Сохранить';
    var cancel=document.createElement('button');cancel.textContent='Выбрать другое';
    save.style.cssText=cancel.style.cssText='font-size:18px;padding:14px 20px;margin:8px;border:0;border-radius:12px';
    save.onclick=function(){if(p.generation!==generation)return;window.__gateSetupCommand=p.command;window.__gateSetupSerial=p.serial;window.__gateSetupReady=true;remove();status('передаю выбранное устройство приложению');};
    cancel.onclick=function(){generation++;remove();status('выбор отменён — откройте нужное устройство');};
    card.appendChild(title);card.appendChild(desc);card.appendChild(save);card.appendChild(cancel);box.appendChild(card);document.body.appendChild(box);status('команда принята — нажмите «Сохранить» в окне');
  }
  status('готова — войдите и вручную откройте нужное устройство');
  WebSocket.prototype.send=function(data){
    var ws=this;
    if(!ws.__gateListener){
      ws.__gateListener=true;
      ws.addEventListener('message',function(event){try{
        var m=JSON.parse(event.data),p=ws.__gatePending;
        if(!p||String(m.id)!==String(p.id))return;
        ws.__gatePending=null;
        if(m.error){status('SprutHub вернул ошибку команды');return;}if(!Object.prototype.hasOwnProperty.call(m,'result')){status('ответ не содержит подтверждения');return;}
        offer(p);
      }catch(e){status('ошибка обработки ответа');}});
    }
    try{
      var m=JSON.parse(data),c=command(m);
      if(c&&!window.__gateSetupReady){
        remove();var p={id:m.id,serial:m.serial,command:c,generation:++generation};ws.__gatePending=p;status('ожидаю подтверждение команды от SprutHub');
        setTimeout(function(){if(ws.__gatePending===p){ws.__gatePending=null;status('нет ответа на команду за 30 секунд');}},30000);
      }
    }catch(e){status('ошибка чтения команды');}
    return original.apply(this,arguments);
  };
})();
