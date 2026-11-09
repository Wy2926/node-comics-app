/* NodeLane mobile image bridge. Independently implemented; no extension runtime. */
(() => {
  'use strict';
  if (window.top !== window) return;
  const old = window.__nodelaneReader;
  if (old) old.dispose();
  const config = __NODELANE_CONFIG__;
  const records = new Map();
  const ids = new WeakMap();
  const overlays = new Map();
  const badges = new Map();
  const menus = new Map();
  let press = null, pressTimer, menuBusy = false, suppressClick = null;
  let theme = {};
  let next = 0, seq = 0, active = false, translated = false, timer, disposed = false;
  let input = null, output = null, observer, restoreTimer;
  const MAX_BYTES = 32 * 1024 * 1024, PIXEL_BUDGET = 64 * 1024 * 1024, CHUNK = 128 * 1024;
  const encode = bytes => {
    let text = '';
    for (let at = 0; at < bytes.length; at += 8192) text += String.fromCharCode(...bytes.subarray(at, at + 8192));
    return btoa(text);
  };
  function source(el) { return el instanceof HTMLCanvasElement ? 'canvas' : el.currentSrc || el.src || ''; }
  function revision(el) { return source(el) + ':' + (el.naturalWidth || el.width) + ':' + (el.naturalHeight || el.height); }
  function record(id, version) {
    const rec = records.get(id);
    if (!rec || !rec.el.isConnected || revision(rec.el) !== version) throw Error('SOURCE_CHANGED');
    return rec;
  }
  function drop(id) {
    const value = overlays.get(id);
    if (!value) return;
    value.canvas.remove(); overlays.delete(id);
  }
  function dropBadge(id) {
    badges.get(id)?.host.remove(); badges.delete(id);
  }
  function dropMenu(id) {
    const value=menus.get(id);
    if (!value) return;
    if (value.callout) value.el.style.setProperty('-webkit-touch-callout',value.callout,value.priority);
    else value.el.style.removeProperty('-webkit-touch-callout');
    menus.delete(id);
    if (press?.item.id===id) cancelPress();
  }
  function updateMenus(items) {
    const keep=new Set();
    for (const item of items) {
      if (!item.menu) continue;
      let rec;
      try { rec=record(item.id,item.revision); } catch (_) { continue; }
      keep.add(item.id);
      let value=menus.get(item.id);
      if (!value) {
        value={el:rec.el,callout:rec.el.style.getPropertyValue('-webkit-touch-callout'),
          priority:rec.el.style.getPropertyPriority('-webkit-touch-callout')};
        rec.el.style.setProperty('-webkit-touch-callout','none','important');
        menus.set(item.id,value);
      }
      value.item=item;
    }
    for (const id of menus.keys()) if (!keep.has(id)) dropMenu(id);
  }
  function menuItem(event) {
    if (!active || disposed) return null;
    for (const el of event.composedPath()) {
      const value=menus.get(ids.get(el));
      if (value) return value.item;
    }
    return null;
  }
  function cancelPress() { clearTimeout(pressTimer); press=null; }
  function sendAction(item, action) {
    return window.flutter_inappwebview.callHandler('nodelaneImages', {
      token:config.token, seq:++seq, id:item.id, revision:item.revision, action,
    });
  }
  async function openMenu(item) {
    if (!active || disposed || menuBusy || !menus.has(item.id)) return;
    try { record(item.id,item.revision); } catch (_) { return; }
    menuBusy=true;
    suppressClick={id:item.id,until:Date.now()+800};
    try {
      await sendAction(item, 'menu');
    } catch (_) {} finally { menuBusy=false; }
  }
  function startPress(event) {
    cancelPress();
    if (event.isPrimary===false || event.button!==0) return;
    const item=menuItem(event);
    if (!item) return;
    press={item,x:event.clientX,y:event.clientY,pointer:event.pointerId};
    pressTimer=setTimeout(()=>{ const held=press; cancelPress(); if(held) openMenu(held.item); },550);
  }
  function movePress(event) {
    if (press && (event.pointerId!==press.pointer || Math.hypot(event.clientX-press.x,event.clientY-press.y)>12)) cancelPress();
  }
  function contextMenu(event) {
    const item=menuItem(event);
    if (!item) return;
    event.preventDefault(); event.stopPropagation(); cancelPress();
    if (suppressClick?.id===item.id && Date.now()<suppressClick.until) return;
    openMenu(item);
  }
  function afterPress(event) {
    const item=menuItem(event);
    if (item && suppressClick?.id===item.id && Date.now()<suppressClick.until) {
      event.preventDefault(); event.stopPropagation(); suppressClick=null;
    }
  }
  function updateBadges(items) {
    const keep = new Set();
    for (const item of items) {
      try { record(item.id, item.revision); } catch (_) { continue; }
      if (item.visible === false) continue;
      keep.add(item.id);
      let badge = badges.get(item.id);
      if (!badge) {
        const host = document.createElement('div'); host.dataset.nodelaneOverlay = 'status';
        // Isolate typography and buttons from arbitrary website styles.
        host.style.cssText = 'all:initial;position:fixed;z-index:2147483647;pointer-events:none';
        const root = host.attachShadow({mode:'open'}), style = document.createElement('style');
        style.textContent = `
          :host { --surface: #fff; --ink: #171a21; --line: #e7eaf0; --accent: #006eff; --error: #b3261e;
            --radius:24px; --gap:8px; --padding:12px; --tap:44px; --fontSize:13px; }
          .badge { box-sizing:border-box; display:flex; flex-wrap:wrap; align-items:center; width:fit-content;
            max-width:100%; border:1px solid var(--line); border-radius:var(--radius); background:var(--surface);
            color:var(--ink); font:500 var(--fontSize)/1.3 -apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;
            padding-left:var(--padding); overflow:hidden; }
          .label { display:flex; align-items:center; gap:var(--gap); padding:var(--gap) var(--padding) var(--gap) 0; }
          .icon { color:var(--accent); } .issue .icon { color:var(--error); }
          .working .icon { width:1em; height:1em; box-sizing:border-box; border:2px solid var(--line);
            border-top-color:var(--accent); border-radius:50%; animation:spin 1s linear infinite; }
          .still .icon { animation:none; }
          button { all:unset; box-sizing:border-box; pointer-events:auto; cursor:pointer; color:var(--accent);
            min-width:var(--tap); min-height:var(--tap); padding:0 var(--padding); text-align:center; font-weight:600; }
          button:focus-visible { outline:2px solid var(--accent); outline-offset:-4px; border-radius:var(--radius); }
          button:disabled { opacity:.5; } button[hidden] { display:none; }
          @keyframes spin { to { transform:rotate(360deg); } }
          @media (prefers-reduced-motion:reduce) { .working .icon { animation:none; } }
        `;
        const row=document.createElement('div'); row.className='badge';
        const label=document.createElement('span'); label.className='label';
        const icon=document.createElement('span'); icon.className='icon'; icon.setAttribute('aria-hidden','true');
        const text=document.createElement('span'); text.setAttribute('role','status');
        const button=document.createElement('button'); button.type='button';
        label.append(icon,text); row.append(label,button); root.append(style,row);
        badge={host,row,icon,text,button,item};
        button.addEventListener('pointerdown', event => event.stopPropagation());
        button.addEventListener('click', async event => {
          event.preventDefault(); event.stopPropagation();
          const current=badge.item, action=current.action;
          if (!active || button.disabled || !action) return;
          try { record(current.id,current.revision); } catch (_) { dropBadge(current.id); return; }
          button.disabled=true;
          try {
            await sendAction(current, action);
          } catch (_) {} finally {
            if (badge.item===current) button.disabled=false;
          }
        });
        document.documentElement.append(host); badges.set(item.id,badge);
      }
      badge.item=item;
      for (const key of ['surface','ink','line','accent','error']) {
        if (typeof theme[key]==='string' && /^#[0-9a-f]{6}$/i.test(theme[key])) badge.host.style.setProperty('--'+key,theme[key]);
      }
      for (const key of ['radius','gap','padding','tap','fontSize']) {
        if (Number.isFinite(theme[key])) badge.host.style.setProperty('--'+key,theme[key]+'px');
      }
      badge.row.className='badge'+(item.working?' working':'')+(item.issue?' issue':'')+(theme.reduceMotion?' still':'');
      badge.icon.textContent=item.working?'':item.issue?'!':'Aa';
      badge.text.textContent=item.label; badge.row.title=item.detail || item.label;
      badge.button.textContent=item.actionLabel;
      badge.button.setAttribute('aria-label',item.actionSemanticLabel || item.actionLabel);
      badge.button.hidden=!item.action; badge.button.disabled=!item.action;
    }
    for (const id of badges.keys()) if (!keep.has(id)) dropBadge(id);
  }
  function place() {
    for (const [id, value] of overlays) {
      const rec = records.get(id);
      if (!rec || !rec.el.isConnected || revision(rec.el) !== value.revision) { drop(id); continue; }
      const box = rec.el.getBoundingClientRect();
      const visible = active && translated && box.bottom >= 0 && box.top <= innerHeight && box.right >= 0 && box.left <= innerWidth;
      value.canvas.style.display = visible ? 'block' : 'none';
      if (visible) Object.assign(value.canvas.style, {left: box.left + 'px', top: box.top + 'px', width: box.width + 'px', height: box.height + 'px'});
    }
    for (const [id, badge] of badges) {
      const rec=records.get(id);
      if (!rec || !rec.el.isConnected || revision(rec.el)!==badge.item.revision) { dropBadge(id); continue; }
      const box=rec.el.getBoundingClientRect(), inset=theme.inset || 8;
      const visible=active && box.bottom>inset && box.top<innerHeight && box.right>0 && box.left<innerWidth;
      badge.host.style.display=visible?'block':'none';
      if (visible) {
        const left=Math.max(0,box.left)+inset;
        Object.assign(badge.host.style, {left:left+'px', top:(Math.max(0,box.top)+inset)+'px',
          width:Math.max(0,Math.min(innerWidth,box.right)-left-inset)+'px'});
        if (Math.max(0,box.top)+inset+badge.host.getBoundingClientRect().height>box.bottom) badge.host.style.display='none';
      }
    }
  }
  async function scan() {
    if (!active || disposed || document.visibilityState === 'hidden') return;
    const candidates = [];
    // Broad ordinary-image fallback only. Site-specific canvas mappings remain gated.
    const elements = document.querySelectorAll(config.canvas ? 'img,canvas' : 'img');
    for (let index = 0; index < Math.min(elements.length, 512); index++) {
      const el = elements[index];
      if (el.dataset.nodelaneOverlay) continue;
      const box = el.getBoundingClientRect();
      if (box.width < 180 || box.height < 180 || box.bottom < 0 || box.top > innerHeight * 3 || getComputedStyle(el).visibility === 'hidden') continue;
      const style = getComputedStyle(el);
      if (style.transform !== 'none' || !['fill','contain'].includes(style.objectFit)) continue;
      if (el instanceof HTMLImageElement && (!el.complete || el.naturalWidth < 180 || el.naturalHeight < 180)) continue;
      if (!ids.has(el)) ids.set(el, String(++next));
      const id = ids.get(el), version = revision(el), url = source(el);
      if (!/^(https?:|blob:)/.test(url) && url !== 'canvas') continue;
      records.set(id, {el, revision: version});
      candidates.push({id, revision: version, url, kind: url === 'canvas' ? 'canvas' : url.startsWith('blob:') ? 'blob' : 'http', top: box.top});
    }
    candidates.sort((a,b) => a.top - b.top);
    const selected = candidates.slice(0, 4);
    const keep = new Set(selected.map(item => item.id));
    for (const id of records.keys()) if (!keep.has(id)) { records.delete(id); drop(id); dropBadge(id); dropMenu(id); }
    place();
    try { await window.flutter_inappwebview.callHandler('nodelaneImages', {token: config.token, seq: ++seq, items: selected}); } catch (_) {}
  }
  function schedule() {
    place();
    if (!timer) timer = setTimeout(() => { timer = null; scan(); }, 100);
  }
  function anchor() {
    const elements = document.querySelectorAll('img,canvas');
    for (let index=0; index<Math.min(elements.length,512); index++) {
      const el=elements[index], box=el.getBoundingClientRect();
      if (el.dataset.nodelaneOverlay || box.width<180 || box.height<180 || box.bottom<innerHeight/2 || box.top>innerHeight/2) continue;
      return {slot:index, fraction:(innerHeight/2-box.top)/box.height, x:scrollX, y:scrollY};
    }
    return {x:scrollX,y:scrollY};
  }
  function cancelRestore() { clearTimeout(restoreTimer); }
  function restore(value, attempt=0) {
    cancelRestore();
    const el=Number.isInteger(value.slot) && value.slot>=0 && value.slot<512 ? document.querySelectorAll('img,canvas')[value.slot] : null;
    const box=el?.getBoundingClientRect();
    const y=box?.height>0 && Number.isFinite(value.fraction) ? scrollY+box.top+Math.max(0,Math.min(1,value.fraction))*box.height-innerHeight/2 : value.y;
    if (Number.isFinite(y) && Number.isFinite(value.x)) scrollTo(value.x,Math.max(0,y));
    if (attempt<4) restoreTimer=setTimeout(()=>restore(value,attempt+1),200);
  }
  async function call(token, operation, args) {
    if (token !== config.token || disposed) throw Error('BRIDGE_INVALID');
    if (operation === 'anchor') return anchor();
    if (operation === 'restore') { restore(args); return true; }
    if (operation === 'state') {
      active = args.active; translated = args.translated;
      if (args.theme) theme=args.theme;
      if (args.items) { updateBadges(active ? args.items : []); updateMenus(active ? args.items : []); }
      if (!active) { cancelPress(); for (const id of [...menus.keys()]) dropMenu(id); input = null; output = null; for (const id of [...overlays.keys()]) drop(id); for (const id of [...badges.keys()]) dropBadge(id); }
      place(); if (active) schedule(); return true;
    }
    if (!active) throw Error('BRIDGE_INVALID');
    if (operation === 'inputBegin') {
      if (input) throw Error('RESOURCE_LIMIT');
      const {el} = record(args.id, args.revision);
      const isCanvas = el instanceof HTMLCanvasElement;
      if (isCanvas) {
        if (!config.canvas) throw Error('SOURCE_MISSING');
      } else {
        const url = new URL(source(el), location.href);
        if (url.protocol !== 'blob:' || url.origin !== location.origin || !el.complete) throw Error('SOURCE_MISSING');
      }
      const width = isCanvas ? el.width : el.naturalWidth, height = isCanvas ? el.height : el.naturalHeight;
      if (!width || !height) throw Error('SOURCE_MISSING');
      if (width * height * 12 > PIXEL_BUDGET) throw Error('RESOURCE_LIMIT');
      const value = {blob: null, id: args.id, revision: args.revision, offset: 0};
      input = value;
      let canvas;
      try {
        let blob;
        try {
          // Read decoded pixels consistently, even when the page revoked its Blob URL.
          canvas = isCanvas ? el : document.createElement('canvas');
          if (!isCanvas) {
            canvas.width = width; canvas.height = height;
            canvas.getContext('2d').drawImage(el, 0, 0);
          }
          blob = await new Promise(resolve => canvas.toBlob(resolve, 'image/png'));
        } catch (_) { throw Error('SOURCE_MISSING'); }
        record(args.id, args.revision);
        if (input !== value || !active || disposed) throw Error('BRIDGE_INVALID');
        if (!blob || !blob.size) throw Error('SOURCE_MISSING');
        if (blob.size > MAX_BYTES) throw Error('RESOURCE_LIMIT');
        value.blob = blob;
        return {size: blob.size};
      } catch (error) {
        if (input === value) input = null;
        throw error;
      } finally {
        if (canvas && !isCanvas) canvas.width = canvas.height = 0;
      }
    }
    if (operation === 'inputChunk') {
      const value = input;
      if (!value?.blob || args.id !== value.id || args.offset !== value.offset) throw Error('BRIDGE_INVALID');
      record(value.id, value.revision);
      const bytes = new Uint8Array(await value.blob.slice(value.offset, value.offset + CHUNK).arrayBuffer());
      record(value.id, value.revision);
      if (input !== value) throw Error('BRIDGE_INVALID');
      value.offset += bytes.length; return encode(bytes);
    }
    if (operation === 'inputEnd') { const value = input; input = null; if (value) record(value.id, value.revision); return true; }
    if (operation === 'resultClear') { drop(args.id); return true; }
    if (operation === 'resultBegin') {
      record(args.id, args.revision);
      if (output || args.size < 1 || args.size > MAX_BYTES) throw Error('RESOURCE_LIMIT');
      output = {...args, chunks: [], offset: 0}; return true;
    }
    if (operation === 'resultChunk') {
      if (!output || args.id !== output.id || args.offset !== output.offset || args.data.length > 174764) throw Error('BRIDGE_INVALID');
      const raw = atob(args.data), bytes = Uint8Array.from(raw, c => c.charCodeAt(0));
      output.offset += bytes.length;
      if (output.offset > output.size) throw Error('RESOURCE_LIMIT');
      output.chunks.push(bytes); return true;
    }
    if (operation === 'resultEnd') {
      const value = output; output = null;
      if (!value || value.id !== args.id || value.offset !== value.size) throw Error('BRIDGE_INVALID');
      record(value.id, value.revision);
      const bitmap = await createImageBitmap(new Blob(value.chunks, {type:'image/png'}));
      try {
        if (!active || disposed || bitmap.width * bitmap.height * 8 > PIXEL_BUDGET) throw Error('RESOURCE_LIMIT');
        record(value.id, value.revision);
        const canvas = document.createElement('canvas'); canvas.dataset.nodelaneOverlay = 'true';
        canvas.width = bitmap.width; canvas.height = bitmap.height;
        Object.assign(canvas.style, {position:'fixed', pointerEvents:'none', zIndex:'2147483646', margin:'0', padding:'0', border:'0'});
        canvas.getContext('2d').drawImage(bitmap, 0, 0);
        drop(value.id); document.documentElement.append(canvas);
        overlays.set(value.id, {canvas, revision:value.revision}); place(); return true;
      } finally { bitmap.close(); }
    }
    if (operation === 'resultAbort') { output = null; return true; }
    throw Error('BRIDGE_INVALID');
  }
  function dispose() {
    disposed = true; cancelPress(); clearTimeout(timer); cancelRestore(); observer?.disconnect();
    removeEventListener('scroll', schedule, true); removeEventListener('resize', schedule);
    document.removeEventListener('load', schedule, true);
    removeEventListener('pointerdown',cancelRestore); removeEventListener('wheel',cancelRestore);
    for (const id of [...overlays.keys()]) drop(id);
    for (const id of [...badges.keys()]) dropBadge(id);
    for (const id of [...menus.keys()]) dropMenu(id);
    removeEventListener('pointerdown',startPress,true); removeEventListener('pointermove',movePress,true);
    removeEventListener('pointerup',cancelPress,true); removeEventListener('pointercancel',cancelPress,true);
    removeEventListener('scroll',cancelPress,true); removeEventListener('contextmenu',contextMenu,true);
    removeEventListener('click',afterPress,true);
    records.clear(); input = null; output = null;
  }
  window.__nodelaneReader = {call, dispose};
  addEventListener('scroll', schedule, {passive:true,capture:true}); addEventListener('resize', schedule, {passive:true});
  document.addEventListener('load', schedule, true);
  addEventListener('pointerdown',cancelRestore,{passive:true}); addEventListener('wheel',cancelRestore,{passive:true});
  addEventListener('pointerdown',startPress,{passive:true,capture:true});
  addEventListener('pointermove',movePress,{passive:true,capture:true});
  addEventListener('pointerup',cancelPress,{passive:true,capture:true});
  addEventListener('pointercancel',cancelPress,{passive:true,capture:true});
  addEventListener('scroll',cancelPress,{passive:true,capture:true});
  addEventListener('contextmenu',contextMenu,true); addEventListener('click',afterPress,true);
  observer = new MutationObserver(changes => {
    if (changes.some(change => !(change.target instanceof Element && change.target.closest('[data-nodelane-overlay]')))) schedule();
  });
  observer.observe(document.documentElement, {subtree:true,childList:true,attributes:true,attributeFilter:['src','srcset','sizes','width','height']});
})();
