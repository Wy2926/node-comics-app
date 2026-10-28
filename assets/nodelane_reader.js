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
  let next = 0, seq = 0, active = false, translated = true, timer, disposed = false;
  let input = null, output = null, observer, restoreTimer;
  const MAX_BYTES = 32 * 1024 * 1024, CHUNK = 128 * 1024;
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
  function place() {
    for (const [id, value] of overlays) {
      const rec = records.get(id);
      if (!rec || !rec.el.isConnected || revision(rec.el) !== value.revision) { drop(id); continue; }
      const box = rec.el.getBoundingClientRect();
      const visible = active && translated && box.bottom >= 0 && box.top <= innerHeight && box.right >= 0 && box.left <= innerWidth;
      value.canvas.style.display = visible ? 'block' : 'none';
      if (visible) Object.assign(value.canvas.style, {left: box.left + 'px', top: box.top + 'px', width: box.width + 'px', height: box.height + 'px'});
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
      candidates.push({id, revision: version, slot: index, url, kind: url === 'canvas' ? 'canvas' : url.startsWith('blob:') ? 'blob' : 'http', top: box.top});
    }
    candidates.sort((a,b) => a.top - b.top);
    const selected = candidates.slice(0, 4);
    const keep = new Set(selected.map(item => item.id));
    for (const id of records.keys()) if (!keep.has(id)) { records.delete(id); drop(id); }
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
      if (!active) { input = null; output = null; for (const id of [...overlays.keys()]) drop(id); }
      place(); if (active) schedule(); return true;
    }
    if (!active) throw Error('BRIDGE_INVALID');
    if (operation === 'inputBegin') {
      if (input) throw Error('RESOURCE_LIMIT');
      const {el} = record(args.id, args.revision);
      let blob;
      if (el instanceof HTMLCanvasElement) {
        if (!config.canvas || el.width * el.height * 12 > 64 * 1024 * 1024) throw Error('RESOURCE_LIMIT');
        blob = await new Promise((resolve, reject) => { try { el.toBlob(resolve, 'image/png'); } catch(e) { reject(e); } });
      } else {
        const url = new URL(source(el), location.href);
        if (url.protocol !== 'blob:' || url.origin !== location.origin) throw Error('SOURCE_MISSING');
        const response = await fetch(url.href, {signal: AbortSignal.timeout(15000)});
        if (!response.ok) throw Error('SOURCE_MISSING');
        const reader = response.body.getReader(), chunks = []; let size = 0;
        try { while (true) { const part = await reader.read(); if (part.done) break; size += part.value.length;
          if (size > MAX_BYTES) throw Error('RESOURCE_LIMIT'); chunks.push(part.value); } }
        finally { reader.cancel(); }
        blob = new Blob(chunks);
      }
      record(args.id, args.revision);
      if (!blob || blob.size > MAX_BYTES || !active) throw Error('RESOURCE_LIMIT');
      input = {blob, id: args.id, revision: args.revision, offset: 0}; return {size: blob.size};
    }
    if (operation === 'inputChunk') {
      if (!input || args.id !== input.id || args.offset !== input.offset) throw Error('BRIDGE_INVALID');
      record(input.id, input.revision);
      const bytes = new Uint8Array(await input.blob.slice(input.offset, input.offset + CHUNK).arrayBuffer());
      input.offset += bytes.length; return encode(bytes);
    }
    if (operation === 'inputEnd') { const value = input; input = null; if (value) record(value.id, value.revision); return true; }
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
        if (!active || disposed || bitmap.width * bitmap.height * 8 > 64 * 1024 * 1024) throw Error('RESOURCE_LIMIT');
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
    disposed = true; clearTimeout(timer); cancelRestore(); observer?.disconnect();
    removeEventListener('scroll', schedule, true); removeEventListener('resize', schedule);
    document.removeEventListener('load', schedule, true);
    removeEventListener('pointerdown',cancelRestore); removeEventListener('wheel',cancelRestore);
    for (const id of [...overlays.keys()]) drop(id);
    records.clear(); input = null; output = null;
  }
  window.__nodelaneReader = {call, dispose};
  addEventListener('scroll', schedule, {passive:true,capture:true}); addEventListener('resize', schedule, {passive:true});
  document.addEventListener('load', schedule, true);
  addEventListener('pointerdown',cancelRestore,{passive:true}); addEventListener('wheel',cancelRestore,{passive:true});
  observer = new MutationObserver(changes => {
    if (changes.some(change => !(change.target instanceof Element && change.target.closest('[data-nodelane-overlay]')))) schedule();
  });
  observer.observe(document.documentElement, {subtree:true,childList:true,attributes:true,attributeFilter:['src','srcset','sizes','width','height']});
})();
