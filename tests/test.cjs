const fs=require('fs'),vm=require('vm'),assert=require('assert');
function setup(kind,full=false){
 class Element{constructor(tag){this.tag=tag;this.children=[];this.style={};this.parentNode=null;}appendChild(x){this.children.push(x);x.parentNode=this;}removeChild(x){this.children=this.children.filter(y=>y!==x);x.parentNode=null;}}
 const body=new Element('body'),timers=[];class WS{constructor(){this.readyState=1;this.sends=[];}send(s){this.sends.push(JSON.parse(s));}addEventListener(t,fn){this.listener=fn;}reply(id,result={},error){this.listener({data:JSON.stringify(error?{id,error}:{id,result})});}}
 const c={WebSocket:WS,document:{body,createElement:t=>new Element(t),getElementById:()=>null},setTimeout:(f,t)=>timers.push([f,t]),addEventListener:()=>{},navigator:{userAgent:'Chrome/87'},console:{error:()=>{}}};c.window=c;vm.createContext(c);
 vm.runInContext(fs.readFileSync(`source/${kind}/assets/${full?'polyfills':'setup-hook'}.js`,'utf8'),c);return{c,body,timers,WS};
}
function request(c,serial='HUB_TEST_A',id=1){return{id,method:'characteristic.update',serial,params:{characteristic:{update:c}}};}
const cases=[{aId:90,sId:13,cId:16,control:{value:{intValue:0}}},{aId:91,sId:77,cId:94,control:{value:{intValue:100}}},{aId:92,sId:21,cId:24,control:{value:{intValue:0}}},{aId:93,sId:17,cId:20,control:{value:{intValue:100}}},{aId:94,sId:100,cId:200,control:{value:{boolValue:true}}}];
for(const kind of ['Lock','Garage','Swing','Sliding','Wicket']){
 for(const full of [false,true])for(const cmd of cases){
  let{c,body,WS}=setup(kind,full),w=new WS(),q=request(cmd);w.send(JSON.stringify(q));assert(!c.__gateSetupReady);w.reply(999);assert.equal(body.children.length,0);w.reply(1);assert.equal(body.children.length,1);assert(!c.__gateSetupReady);
  const card=body.children[0].children[0];card.children[2].onclick();assert(c.__gateSetupReady);assert.equal(body.children.length,0);assert.deepEqual(JSON.parse(JSON.stringify(c.__gateSetupCommand)),cmd);assert.equal(c.__gateSetupSerial,'HUB_TEST_A');assert.equal(w.sends.length,1);
  const login=fs.readFileSync(`source/${kind}/smali/ru/gates/app/LoginActivity.smali`,'utf8');const l=login.split('\n').find(x=>x.includes('const-string v2, "(function(){if(!window.__gateSetupReady'));const js=JSON.parse(l.slice(l.indexOf(', ')+2));c.localStorage={getItem:k=>k.endsWith('/auth')?'{"token":"TEST_ONLY","cid":"TEST_CID"}':k.endsWith('/settings')?'{"lastHubSerial":"WRONG_HUB"}':'{}'};
  const parts=vm.runInContext(js,c).split('\n@@@\n');assert.deepEqual(JSON.parse(JSON.parse(parts[0]).gateCommand),cmd);assert.equal(JSON.parse(parts[2]).lastHubSerial,'HUB_TEST_A');
 }
 {const{c,body,WS}=setup(kind),w=new WS();w.send(JSON.stringify(request(cases[0])));w.reply(1,{}, {code:401});assert(!c.__gateSetupReady);assert.equal(body.children.length,0);}
 {const{c,body,WS}=setup(kind),w=new WS();w.send(JSON.stringify(request(cases[0])));w.reply(1);body.children[0].children[0].children[3].onclick();assert(!c.__gateSetupReady);assert.equal(body.children.length,0);w.send(JSON.stringify(request(cases[2],'HUB_TEST_B',2)));w.reply(2);body.children[0].children[0].children[2].onclick();assert.equal(c.__gateSetupSerial,'HUB_TEST_B');}
 {const{c,body,WS,timers}=setup(kind),w=new WS();w.send(JSON.stringify(request(cases[0])));timers[0][0]();w.reply(1);assert.equal(body.children.length,0);assert(!c.__gateSetupReady);}
 {const{c,body,WS}=setup(kind),w=new WS();w.send(JSON.stringify(request(cases[0])));w.reply(1);const stale=body.children[0].children[0].children[2];w.send(JSON.stringify(request(cases[2],'NEW',2)));stale.onclick();assert(!c.__gateSetupReady);w.reply(2);body.children[0].children[0].children[2].onclick();assert.equal(c.__gateSetupSerial,'NEW');}
 for(const cmd of [{...cases[0],sId:0},{...cases[0],control:{value:{intValue:NaN}}},{...cases[0],control:{value:{strValue:'bad'}}}]){const{c,body,WS}=setup(kind),w=new WS();w.send(JSON.stringify(request(cmd)));w.reply(1);assert(!c.__gateSetupReady);assert.equal(body.children.length,0);}
 console.log('PASS',kind,'dynamic addresses / 0 and 100 / lock / door / bool / exact replay bridge / explicit save / errors / stale responses / timeout / one write / full injected script');
}
