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
