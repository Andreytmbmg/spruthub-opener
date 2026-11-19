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
