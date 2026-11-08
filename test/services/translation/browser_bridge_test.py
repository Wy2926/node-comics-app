"""One real-DOM fixture for the bundled script; not a mobile WebView verdict.

Run: python3 test/services/translation/browser_bridge_test.py
Uses an installed Chrome in a disposable profile and a loopback-only fixture.
"""
import http.server
import os
from pathlib import Path
import shutil
import subprocess
import tempfile
import threading
import time

ROOT = Path(__file__).resolve().parents[3]
SCRIPT = (ROOT / 'assets/nodelane_reader.js').read_text().replace(
    '__NODELANE_CONFIG__', '{token:"fixture",canvas:false}')
FIXTURE = r'''
<html><body style="margin:0"><pre id="result">pending</pre>
<script>
const windows = [], actions = [];
window.flutter_inappwebview = {callHandler: async (name, value) => { if (value.action) actions.push(value); else windows.push(value); return true; }};
</script><script>__SCRIPT__</script><script>
const assert = (value, text) => { if (!value) throw Error(text); };
const wait = ms => new Promise(resolve => setTimeout(resolve, ms));
const call = (operation, args) => window.__nodelaneReader.call('fixture', operation, args);
(async () => {
  const canvas = document.createElement('canvas'); canvas.width=512; canvas.height=768;
  const pixels = canvas.getContext('2d').createImageData(512,768);
  let seed=7;
  for(let at=0;at<pixels.data.length;at++) { seed=(seed*1664525+1013904223)>>>0; pixels.data[at]=at%4===3?255:seed>>>24; }
  canvas.getContext('2d').putImageData(pixels,0,0);
  const blob = await new Promise(resolve => canvas.toBlob(resolve,'image/png'));
  const url = URL.createObjectURL(blob);
  const img = document.createElement('img'); img.src=url; img.style='display:block;width:256px;height:384px';
  document.body.append(img); await img.decode();
  for(let i=0;i<5;i++) { const el=img.cloneNode(); document.body.append(el); }
  await call('state',{active:true,translated:true}); await wait(250);
  const item=windows.at(-1).items[0];
  assert(windows.at(-1).items.length<=4,'unbounded discovery');
  let rejected=false; try { await window.__nodelaneReader.call('stale','state',{}); } catch { rejected=true; }
  assert(rejected,'stale document token accepted');
  const meta=await call('inputBegin',item); const chunks=[]; let offset=0;
  while(offset<meta.size) {
    const data=await call('inputChunk',{id:item.id,offset}); const length=atob(data).length;
    assert(length<=128*1024,'oversized bridge chunk'); chunks.push({data,offset}); offset+=length;
  }
  assert(chunks.length>1,'fixture must cross chunk boundaries');
  await call('inputEnd',{});
  const original=img.src, top=img.getBoundingClientRect().top, before=scrollY;
  await call('resultBegin',{...item,size:meta.size});
  for(const chunk of chunks) await call('resultChunk',{id:item.id,...chunk});
  await call('resultEnd',{id:item.id});
  assert(document.querySelectorAll('[data-nodelane-overlay]').length===1,'overlay missing');
  assert(img.src===original && img.getBoundingClientRect().top===top && scrollY===before,'source or reading anchor mutated');
  const theme={surface:'#1e242c',ink:'#f0f3f8',line:'#353e4a',accent:'#006eff',error:'#ff8888',inset:8,gap:8,padding:12,radius:24,tap:44,fontSize:13,reduceMotion:true};
  const failed={...item,label:'翻译失败',detail:'连接失败，请重试',issue:true,working:false,action:'retry',actionLabel:'重试',actionSemanticLabel:'重试此图片'};
  await call('state',{active:true,translated:true,theme,items:[failed]});
  const badge=document.querySelector('[data-nodelane-overlay="status"]');
  assert(badge,'image status missing');
  assert(badge.style.getPropertyValue('--surface')===theme.surface,'native theme tokens missing');
  assert(Math.abs(badge.getBoundingClientRect().left-img.getBoundingClientRect().left-8)<1,'badge not on image top-left');
  assert(img.src===original && img.getBoundingClientRect().top===top && scrollY===before,'status changed reading position');
  const button=badge.shadowRoot.querySelector('button');
  assert(button.getAttribute('aria-label')==='重试此图片','localized image action missing');
  await call('state',{active:true,translated:true,theme,items:[{...failed,label:'Translation failed',actionLabel:'Retry',actionSemanticLabel:'Retry this image'}]});
  assert(button.textContent==='Retry' && button.getAttribute('aria-label')==='Retry this image','locale switch did not update visible and accessible actions');
  button.click(); button.click(); await wait(1);
  assert(actions.length===1 && actions[0].id===item.id && actions[0].action==='retry','single image retry duplicated or misrouted');
  await call('state',{active:true,translated:false,items:[{...failed,label:'状态待确认',action:'verify',actionLabel:'核实'}]});
  assert(badge.style.display!=='none','original display hid image status');
  button.click(); await wait(1);
  assert(actions.at(-1).action==='verify','unknown result creates retry instead of verifying');
  await call('state',{active:true,translated:false,items:[{...failed,label:'正在翻译',working:true,action:null,actionLabel:''}]});
  assert(button.hidden && button.disabled,'running translation allows resubmission');
  for (const label of ['已翻译','无可译文字']) {
    await call('state',{active:true,translated:true,items:[{...failed,label,visible:false,menu:true,action:null,actionLabel:''}]});
    assert(!document.querySelector('[data-nodelane-overlay="status"]'),'completed image has corner controls');
    img.dispatchEvent(new MouseEvent('contextmenu',{bubbles:true,cancelable:true})); await wait(1);
    assert(actions.at(-1).action==='menu' && actions.at(-1).id===item.id,'long-press menu directly regenerated or targeted a different image');
    await wait(810);
  }
  const beforeHold=actions.length;
  img.dispatchEvent(new PointerEvent('pointerdown',{bubbles:true,button:0,isPrimary:true,pointerId:1,clientX:20,clientY:20}));
  img.dispatchEvent(new PointerEvent('pointermove',{bubbles:true,pointerId:1,clientX:20,clientY:60}));
  await wait(580);
  assert(actions.length===beforeHold,'scroll gesture opened image menu');
  img.dispatchEvent(new PointerEvent('pointerdown',{bubbles:true,button:0,isPrimary:true,pointerId:1,clientX:20,clientY:20}));
  await wait(580);
  assert(actions.length===beforeHold+1 && actions.at(-1).action==='menu','stationary long press did not open menu');
  img.dispatchEvent(new PointerEvent('pointerup',{bubbles:true,pointerId:1}));
  await call('state',{active:true,translated:true,items:[{...failed,label:'无可译文字',visible:false,menu:false,action:null}]});
  assert(!document.querySelector('[data-nodelane-overlay="status"]'),'empty image controls leaked');
  assert(!img.style.getPropertyValue('-webkit-touch-callout'),'image callout style not restored');
  const saved=await call('anchor',{});
  scrollTo(0,800); await call('restore',saved); await wait(1000);
  assert(Math.abs(scrollY-before)<2,'cold tab anchor restoration failed');
  await call('state',{active:true,translated:false});
  assert(document.querySelector('canvas[data-nodelane-overlay]').style.display==='none','original toggle failed');
  img.src=URL.createObjectURL(blob); await img.decode();
  rejected=false; try { await call('resultBegin',{...item,size:meta.size}); } catch { rejected=true; }
  assert(rejected,'stale element revision accepted');
  await call('state',{active:true,translated:true,items:[failed]});
  assert(!document.querySelector('[data-nodelane-overlay="status"]'),'stale image status survived replacement');
  await call('state',{active:false,translated:true});
  const count=windows.length; dispatchEvent(new Event('scroll')); await wait(250);
  assert(windows.length===count,'hidden page submitted work');
  assert(!document.querySelector('[data-nodelane-overlay]'),'hidden display leaked');
  window.__nodelaneReader.dispose();
  document.getElementById('result').textContent='NODELANE_BRIDGE_PASS';
})().catch(error => document.getElementById('result').textContent='NODELANE_BRIDGE_FAIL: '+error.message);
</script></body></html>
'''.replace('__SCRIPT__', SCRIPT)


class Handler(http.server.BaseHTTPRequestHandler):
    def do_GET(self):
        body = FIXTURE.encode()
        self.send_response(200)
        self.send_header('Content-Type', 'text/html; charset=utf-8')
        self.send_header('Content-Length', str(len(body)))
        self.end_headers()
        self.wfile.write(body)

    def log_message(self, *_):
        pass


if __name__ == '__main__':
    chrome = os.environ.get('CHROME_BINARY') or shutil.which('chromium') or '/Applications/Google Chrome.app/Contents/MacOS/Google Chrome'
    server = http.server.ThreadingHTTPServer(('127.0.0.1', 0), Handler)
    thread = threading.Thread(target=server.serve_forever, daemon=True)
    thread.start()
    try:
        with tempfile.TemporaryDirectory(prefix='nodelane-dom-') as profile:
            browser = subprocess.Popen([chrome, '--headless', '--disable-gpu', '--no-first-run',
                '--no-default-browser-check', '--no-proxy-server', f'--user-data-dir={profile}',
                '--remote-debugging-port=0', 'about:blank'], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
            try:
                port_file = Path(profile) / 'DevToolsActivePort'
                for _ in range(100):
                    if port_file.exists(): break
                    time.sleep(.1)
                port = port_file.read_text().splitlines()[0]
                node = os.environ.get('NODE_BINARY') or shutil.which('node') or '/Users/wy/.local/opt/node/bin/node'
                probe = r'''
const endpoint=process.argv[1], url=process.argv[2];
const tab=await (await fetch(endpoint+'/json/new?'+encodeURIComponent(url),{method:'PUT'})).json();
const ws=new WebSocket(tab.webSocketDebuggerUrl), pending=new Map(); let seq=0;
ws.onmessage=event=>{const value=JSON.parse(event.data);if(value.id){pending.get(value.id)?.(value);pending.delete(value.id);}};
await new Promise((resolve,reject)=>{ws.onopen=resolve;ws.onerror=reject;});
const send=(method,params)=>new Promise(resolve=>{const id=++seq;pending.set(id,resolve);ws.send(JSON.stringify({id,method,params}));});
let status='pending';
for(let attempt=0;attempt<150;attempt++) {
 const result=await send('Runtime.evaluate',{expression:'document.getElementById("result")?.textContent',returnByValue:true});
 status=result.result?.result?.value??'pending';
 if(status!=='pending') break;
 await new Promise(resolve=>setTimeout(resolve,100));
}
ws.close(); console.log(status); if(status!=='NODELANE_BRIDGE_PASS') process.exitCode=1;
'''
                run = subprocess.run([node, '--input-type=module', '-e', probe,
                    f'http://127.0.0.1:{port}', f'http://127.0.0.1:{server.server_port}'], capture_output=True, text=True, timeout=25)
                if run.returncode: raise SystemExit(run.stdout.strip() or run.stderr[:500])
                print('PASS: image status, native theme, targeted retry/verify, duplicate guard, original/position, chunked transfer, stale revision and hidden release')
            finally:
                browser.terminate()
                browser.wait(timeout=10)
    finally:
        server.shutdown()
        server.server_close()
