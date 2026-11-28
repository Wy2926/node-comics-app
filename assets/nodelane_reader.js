/* SPDX-License-Identifier: GPL-3.0-only
 * Image presentation adapted from NodeLane Comics; see ../THIRD_PARTY.md.
 * Standalone mobile bridge; no extension runtime dependency.
 */
(() => {
  'use strict';
  if (window.top !== window) return;
  const old = window.__nodelaneReader;
  if (old) old.dispose();
  const config = __NODELANE_CONFIG__;
  const send = config.send || (message => window.flutter_inappwebview.callHandler('nodelaneImages', message));
  const records = new Map();
  const ids = new WeakMap();
  const versions = new WeakMap();
  const overlays = new Map();
  const badges = new Map();
  const menus = new Map();
  let press = null, pressTimer, menuBusy = false, suppressClick = null, pressedLink = null;
  let theme = {};
  let next = 0, nextVersion = 0, seq = 0, active = false, translated = false, displayScope, timer, disposed = false;
  let input = null, output = null, observer, restoreTimer;
  const near = new Set();
  let viewport, margin, slots;
  const ordered = () => slots ??= Array.from(document.querySelectorAll('img:not([data-nodelane-overlay]),canvas:not([data-nodelane-overlay])'));
  let reading = false, chapterPanel, hints, lastReading;
  const chapterWords = /(?:\b(?:chapter|episode|capítulo|chapitre)\s*[#.: -]?\d|\/(?:chapters?|episodes?|read|reader)[/-]|第\s*[\d一二三四五六七八九十百]+\s*[话話章回]|\d+\s*[話화])/i;
  function chapterHints() {
    const targets = new Set();
    for (const a of document.querySelectorAll('a[href]')) {
      if (a.matches('[aria-disabled="true"],[download]') || a.closest('[hidden],[inert]')) continue;
      const label = (a.getAttribute('aria-label') || a.getAttribute('title') || a.textContent).trim();
      if (!/^(?:next (?:chapter|episode)\b|下(?:一)?[话話章回]|次(?:の(?:話|エピソード)|話)|다음\s*화|siguiente cap[íi]tulo|chapitre suivant)/i.test(label)) continue;
      try {
        const u = new URL(a.href);
        if (/^https?:$/.test(u.protocol) && u.origin === location.origin && !u.username && !u.password &&
            u.href.split('#')[0] !== location.href.split('#')[0]) targets.add(u.href);
      } catch (_) {}
    }
    return {declared: targets.size > 0 || chapterWords.test(location.pathname+' '+document.title),
      next: targets.size === 1 ? [...targets][0] : null};
  }
  function reportReading() {
    hints ??= chapterHints();
    if (!chapterPanel?.isConnected) {
      chapterPanel = null;
      for (const el of viewport ? near : ordered()) {
        const marked = el.closest('[data-page-number],[role="doc-chapter"],[itemtype$="/ComicStory"],.reading-content,#readerarea');
        if ((!marked && !hints.declared) || el.dataset.nodelaneOverlay || el.closest('nav,header,footer,aside')) continue;
        const b = el.getBoundingClientRect();
        // A height-fitted page in a landscape spread can be narrower than half the viewport.
        if (b.width <= 0 || b.height <= 0 || (!marked && (b.width < Math.min(innerWidth, innerHeight) * .5 || b.height < innerHeight * .35)) ||
            b.right <= 0 || b.left >= innerWidth ||
            getComputedStyle(el).visibility !== 'visible' ||
            (el.checkVisibility && !el.checkVisibility({checkOpacity:true,checkVisibilityCSS:true}))) continue;
        chapterPanel = el; break;
      }
    }
    const chapterSeen = !!chapterPanel;
    let end = chapterSeen && !!hints.next && scrollY + innerHeight >= document.documentElement.scrollHeight - innerHeight * .25;
    for (let p=chapterPanel?.parentElement;end && p && p!==document.scrollingElement;p=p.parentElement) {
      const style=getComputedStyle(p);
      if (/^(auto|scroll)$/.test(style.overflowX) && Math.abs(p.scrollLeft)+p.clientWidth*1.25 < p.scrollWidth ||
          /^(auto|scroll)$/.test(style.overflowY) && p.scrollTop+p.clientHeight*1.25 < p.scrollHeight) end=false;
    }
    const nextChapter = end ? hints.next : null;
    const key = JSON.stringify([chapterSeen,nextChapter]);
    if (lastReading === key) return;
    lastReading = key;
    Promise.resolve(send({token:config.token,seq:++seq,reading:{chapter:chapterSeen,nextChapter}})).catch(()=>{});
  }
  function watch(node, added) {
    if (!(node instanceof Element)) return;
    const track = el => {
      slots = null;
      if (!added) { near.delete(el); viewport?.unobserve(el); }
      else if (!el.dataset.nodelaneOverlay) viewport?.observe(el);
    };
    if (node.matches('img,canvas')) track(node);
    node.querySelectorAll('img,canvas').forEach(track);
  }
  function watchViewport() {
    const rootMargin = `0px ${innerWidth * 2}px ${innerHeight * 2}px`;
    if (typeof IntersectionObserver === 'undefined' || margin === rootMargin) return;
    margin = rootMargin;
    viewport?.disconnect();
    near.clear();
    viewport = new IntersectionObserver(entries => {
      for (const e of entries) {
        if (e.isIntersecting && e.target.isConnected) near.add(e.target); else near.delete(e.target);
      }
      schedule();
    }, {rootMargin});
    for (const el of ordered()) if (!el.dataset.nodelaneOverlay) viewport.observe(el);
  }
  const CHUNK = 128 * 1024;
  const probe = document.createElement('canvas'); probe.width = probe.height = 32;
  const encode = bytes => {
    if (typeof bytes.toBase64 === 'function') return bytes.toBase64();
    // Gecko's isolated world cannot use subarray() on some page-owned pixel buffers.
    let text = '';
    for (let at = 0; at < bytes.length; at++) text += String.fromCharCode(bytes[at]);
    return btoa(text);
  };
  function source(el) { return el instanceof HTMLCanvasElement ? 'canvas' : el.currentSrc || el.src || ''; }
  function revision(el) {
    let pixels = '';
    if (el instanceof HTMLCanvasElement) {
      try {
        const context = probe.getContext('2d', {willReadFrequently:true});
        context.clearRect(0, 0, 32, 32); context.drawImage(el, 0, 0, 32, 32);
        pixels = encode(context.getImageData(0, 0, 32, 32).data);
      } catch (_) { probe.width = 32; }
    }
    const url = source(el), width = el.naturalWidth || el.width, height = el.naturalHeight || el.height;
    let value = versions.get(el);
    if (!value || value.url !== url || value.width !== width || value.height !== height || value.pixels !== pixels) {
      value = {url, width, height, pixels, version:String(++nextVersion)}; versions.set(el, value);
    }
    return value.version;
  }
  function record(id, version) {
    const rec = records.get(id);
    if (!rec || !rec.el.isConnected || revision(rec.el) !== version) throw Error('SOURCE_CHANGED');
    return rec;
  }
  function drop(id) {
    const value = overlays.get(id);
    if (!value) return;
    value.restore(); URL.revokeObjectURL(value.url); value.preview.removeAttribute('src'); overlays.delete(id);
  }
  async function svgViewport(svg) {
    const root = new DOMParser().parseFromString(await svg.text(), 'image/svg+xml').documentElement;
    return root.localName === 'svg' ? {
      viewBox:root.getAttribute('viewBox'), preserveAspectRatio:root.getAttribute('preserveAspectRatio'),
    } : null;
  }
  async function localSvg(url) {
    // Blob/data sources are captured as pixels. Only inspect local bytes; never re-request a website image.
    if (!/^(blob:|data:image\/svg\+xml[;,])/i.test(url)) return null;
    try {
      const response = await fetch(url);
      if (!/^image\/svg\+xml\b/i.test(response.headers.get('content-type') || '')) {
        await response.body?.cancel(); return null;
      }
      return await svgViewport(response);
    } catch (_) {} // A revoked Blob still has readable decoded pixels.
    return null;
  }
  async function displayUrl(el, png, preview) {
    const original = versions.get(el), {width:w,height:h} = original;
    if (original.svg === undefined) original.svg = await localSvg(original.url);
    const svg = original.svg;
    if (!svg && w === preview.naturalWidth && h === preview.naturalHeight) return preview.src;
    let fit = 'none', box = [0,0,w,h];
    if (svg) {
      // Map the natural raster's coordinates back to the SVG viewport, including its alignment and gutters.
      const par = /^(?:defer\s+)?(none|x(Min|Mid|Max)Y(Min|Mid|Max))(?:\s+(meet|slice))?$/.exec(
        (svg.preserveAspectRatio || '').trim()) || ['','xMidYMid','Mid','Mid','meet'];
      fit = par[1] === 'none' ? 'none' : par[1]+' '+(par[4] || 'meet');
      const vb = (svg.viewBox || '').trim().split(/[\s,]+/).map(Number);
      if (fit !== 'none' && vb.length === 4 && vb.every(Number.isFinite) && vb[2] > 0 && vb[3] > 0) {
        const k = (par[4] === 'slice' ? Math.max : Math.min)(w/vb[2], h/vb[3]);
        const bw = vb[2]*k, bh = vb[3]*k, align = {Min:0,Mid:.5,Max:1};
        if (Number.isFinite(bw) && Number.isFinite(bh)) box = [(w-bw)*align[par[2]],(h-bh)*align[par[3]],bw,bh];
      }
    }
    // CSS sizes the original object; only the pixels inside its coordinate system change.
    const parts = [`<svg xmlns="http://www.w3.org/2000/svg" width="${w}" height="${h}" viewBox="${box.join(' ')}" preserveAspectRatio="${fit}"><image width="${w}" height="${h}" preserveAspectRatio="none" href="data:image/png;base64,`];
    const stride = CHUNK - CHUNK % 3;
    for (let at=0; at<png.size; at+=stride) {
      if (!active || disposed || !el.isConnected) throw Error('SOURCE_CHANGED');
      parts.push(new Blob([encode(new Uint8Array(await png.slice(at,at+stride).arrayBuffer()))]));
    }
    parts.push('"/></svg>');
    return URL.createObjectURL(new Blob(parts, {type:'image/svg+xml'}));
  }
  function display(el, preview) {
    if (el instanceof HTMLCanvasElement) {
      // Canvas ignores CSS content in Blink. Keep its backing store and pointer target intact.
      preview.alt = '';
      preview.dataset.nodelaneOverlay = 'translation'; preview.setAttribute('aria-hidden','true');
      const style = preview.style;
      style.cssText = 'all:initial!important;display:block!important;pointer-events:none!important;user-select:none!important;border-color:transparent!important';
      const sync = () => {
        if (preview.previousElementSibling !== el) el.after(preview);
        const css = getComputedStyle(el);
        const props = {position:css.position === 'fixed' ? 'fixed' : 'absolute',left:el.offsetLeft+'px',top:el.offsetTop+'px'};
        for (const name of ['width','height','box-sizing','padding','border-width','border-style','border-radius',
          'object-fit','object-position','transform','transform-origin','translate','rotate','scale','clip-path',
          'overflow','overflow-clip-margin','filter','opacity','visibility','z-index','image-rendering']) props[name] = css.getPropertyValue(name);
        for (const [name, value] of Object.entries(props)) {
          if (style.getPropertyValue(name) !== value) style.setProperty(name,value,'important');
        }
      };
      return {sync, restore:() => preview.remove()};
    }
    const style = el.style, content = 'url("'+preview.src+'")';
    let old, priority, hadStyle, applied;
    const owns = () => applied !== undefined && style.content === applied && style.getPropertyPriority('content') === 'important';
    const sync = () => {
      if (owns()) return;
      hadStyle = el.hasAttribute('style'); old = style.content; priority = style.getPropertyPriority('content');
      style.setProperty('content', content, 'important'); applied = style.content;
    };
    return {sync, restore:() => {
      if (!owns()) return;
      if (old) style.setProperty('content',old,priority); else style.removeProperty('content');
      if (!hadStyle && !style.length) el.removeAttribute('style');
      applied = undefined;
    }};
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
    return send({
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
    // 记录实际按中的链接；相同 href 的不同卡片不能按网址猜测。
    pressedLink = event.isTrusted && event.isPrimary !== false && event.button === 0
      ? event.composedPath().find(el => el.matches?.('a[href]')) : null;
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
        const root = host.attachShadow({mode:'open'}), style = document.createElement('style');
        // Even inline `all` can expand to z-index when positioned, triggering page filters.
        style.textContent = `
          :host { all:initial; position:fixed!important; z-index:2147483647!important; pointer-events:none!important;
            --surface: #fff; --ink: #171a21; --line: #e7eaf0; --accent: #006eff; --error: #b3261e;
            --radius:24px; --gap:8px; --padding:12px; --tap:44px; --fontSize:13px; }
          .badge { box-sizing:border-box; display:flex; flex-wrap:wrap; align-items:center; width:fit-content;
            max-width:100%; border:1px solid var(--line); border-radius:var(--radius); background:var(--surface);
            color:var(--ink); font:500 var(--fontSize)/1.3 -apple-system,BlinkMacSystemFont,"Segoe UI",sans-serif;
            padding-left:var(--padding); overflow:hidden; }
          .label { display:flex; align-items:center; gap:var(--gap); padding:var(--gap) var(--padding) var(--gap) 0;
            box-sizing:border-box; max-width:100%; }
          [role=status] { white-space:pre-line; overflow-wrap:anywhere; }
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
          if (action==='upgrade' && !event.isTrusted) return;
          if (!active || !translated || !button.isConnected || button.disabled || !action) return;
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
      if (!active || !rec || !rec.el.isConnected || revision(rec.el) !== value.revision) { drop(id); continue; }
      if (translated) value.sync(); else value.restore();
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
    if (disposed || document.visibilityState === 'hidden') return;
    if (reading) reportReading();
    if (!active) return;
    const candidates = [];
    const elements = viewport ? near : ordered();
    for (const el of elements) {
      if (el.dataset.nodelaneOverlay) continue;
      const box = el.getBoundingClientRect();
      if (box.width <= 0 || box.height <= 0 || box.bottom < 0 || box.top > innerHeight * 3) continue;
      const style = getComputedStyle(el);
      if (style.visibility !== 'visible' || Number(style.opacity) === 0 ||
          (el.checkVisibility && !el.checkVisibility({checkOpacity:true,checkVisibilityCSS:true}))) continue;
      if (el instanceof HTMLImageElement && (!el.complete || !el.naturalWidth || !el.naturalHeight)) continue;
      if (el instanceof HTMLCanvasElement && (!el.width || !el.height)) continue;
      if (!ids.has(el)) ids.set(el, String(++next));
      const id = ids.get(el), version = revision(el), url = source(el);
      if (!/^(https?:|blob:|data:image\/)/i.test(url) && url !== 'canvas') continue;
      records.set(id, {el});
      const kind = /^https?:/i.test(url) ? 'http' : 'pixels';
      candidates.push({id, revision: version, url:kind === 'http' ? url : '', kind, box});
    }
    const distance = ({box}) => Math.max(0, box.top-innerHeight, -box.bottom) ** 2 + Math.max(0, box.left-innerWidth, -box.right) ** 2;
    const focus = Math.min(innerHeight * .3, 240);
    const focusDistance = ({box}) => Math.max(0, box.top-focus, focus-box.bottom);
    candidates.sort((a,b) => distance(a)-distance(b) || focusDistance(a)-focusDistance(b) || a.box.top-b.box.top);
    const selected = candidates.slice(0, 4).map(({box, ...item}) => item);
    const keep = new Set(selected.map(item => item.id));
    for (const id of records.keys()) if (!keep.has(id)) { records.delete(id); drop(id); dropBadge(id); dropMenu(id); }
    place();
    try { await send({token: config.token, seq: ++seq, items: selected}); } catch (_) {}
  }
  function schedule() {
    if ((!active && !reading) || disposed || document.visibilityState === 'hidden') return;
    place();
    if (!timer) timer = setTimeout(() => { timer = null; scan(); }, 100);
  }
  function anchor() {
    let fallback;
    for (const el of viewport ? near : ordered()) {
      const box=el.getBoundingClientRect();
      if (el.dataset.nodelaneOverlay || box.width<=0 || box.height<=0 || box.right<=0 || box.left>=innerWidth || box.bottom<innerHeight/2 || box.top>innerHeight/2) continue;
      if (el.checkVisibility && !el.checkVisibility({checkOpacity:true,checkVisibilityCSS:true})) continue;
      const across=(innerWidth/2-box.left)/box.width;
      const declared=Number(el.closest('[data-page-number]')?.getAttribute('data-page-number'));
      const position={slot:ordered().indexOf(el), fraction:(innerHeight/2-box.top)/box.height, x:scrollX, y:scrollY,
        ...(Number.isSafeInteger(declared) && declared>0 ? {page:declared} : {})};
      if (across>=0 && across<=1) return {...position,across};
      fallback ??= position;
    }
    return fallback || {x:scrollX,y:scrollY};
  }
  function cancelRestore() { clearTimeout(restoreTimer); }
  function restore(value, attempt=0) {
    cancelRestore();
    let el=Number.isInteger(value.slot) && value.slot>=0 ? ordered()[value.slot] : null;
    if (Number.isSafeInteger(value.page) && value.page>0 && Number(el?.closest('[data-page-number]')?.dataset.pageNumber)!==value.page) {
      const marked=document.querySelector(`[data-page-number="${value.page}"]`);
      el=(marked?.matches('img,canvas') ? marked : marked?.querySelector('img,canvas')) ?? el;
    }
    let x=value.x, y=value.y;
    if (el && el.getBoundingClientRect().height>0 && Number.isFinite(value.fraction)) {
      const offsetY=b=>b.top+Math.max(0,Math.min(1,value.fraction))*b.height-innerHeight/2;
      const offsetX=b=>Number.isFinite(value.across) ? b.left+value.across*b.width-innerWidth/2 : 0;
      for (let p=el.parentElement;p && p!==document.scrollingElement;p=p.parentElement) {
        const style=getComputedStyle(p);
        const h=/^(auto|scroll)$/.test(style.overflowX) && p.scrollWidth>p.clientWidth;
        const v=/^(auto|scroll)$/.test(style.overflowY) && p.scrollHeight>p.clientHeight;
        if (h || v) {
          const b=el.getBoundingClientRect();
          p.scrollBy({left:h?offsetX(b):0,top:v?offsetY(b):0,behavior:'instant'});
        }
      }
      const b=el.getBoundingClientRect();
      if(Number.isFinite(value.across)) x=scrollX+offsetX(b);
      y=scrollY+offsetY(b);
    }
    if (Number.isFinite(y) && Number.isFinite(x)) scrollTo(x,Math.max(0,y));
    if (attempt<4) restoreTimer=setTimeout(()=>restore(value,attempt+1),200);
  }
  async function call(token, operation, args) {
    if (token !== config.token || disposed) throw Error('BRIDGE_INVALID');
    if (operation === 'anchor') return anchor();
    if (operation === 'mangaContext') {
      const index = args.link && pressedLink?.isConnected && pressedLink.href === new URL(args.link).href
        ? Array.prototype.indexOf.call(document.links, pressedLink) : -1;
      return {index, href: pressedLink?.isConnected ? pressedLink.href : null, timeOrigin: performance.timeOrigin};
    }
    if (operation === 'imageMenuClaimed') return !!press || menuBusy || Date.now() < (suppressClick?.until || 0);
    if (operation === 'restore') { restore(args); return true; }
    if (operation === 'state') {
      if (!args.active || args.scope !== displayScope) {
        output = null;
        for (const id of [...overlays.keys()]) drop(id);
      }
      displayScope = args.scope;
      active = args.active; translated = args.translated;
      reading = args.reading === true;
      if (!reading) lastReading = null;
      if (args.theme) theme=args.theme;
      if (args.items) {
        for (const item of args.items) {
          if (item.retainResult === false && overlays.get(item.id)?.revision === item.revision) drop(item.id);
        }
      }
      if (args.items || !active || !translated) updateBadges(active && translated ? args.items : []);
      if (args.items || !active) updateMenus(active ? args.items : []);
      if (!active) { cancelPress(); input?.abort?.abort(); input = null; }
      place(); if (active || reading) schedule(); return true;
    }
    if (!active) throw Error('BRIDGE_INVALID');
    if (operation === 'validate') {
      const {el} = record(args.id, args.revision);
      if (args.svg) versions.get(el).svg = args.svg;
      return true;
    }
    if (operation === 'inputBegin') {
      if (input) throw Error('RESOURCE_LIMIT');
      const {el} = record(args.id, args.revision);
      const isCanvas = el instanceof HTMLCanvasElement;
      if (!isCanvas && !el.complete) throw Error('SOURCE_MISSING');
      const width = isCanvas ? el.width : el.naturalWidth, height = isCanvas ? el.height : el.naturalHeight;
      if (!width || !height) throw Error('SOURCE_MISSING');
      const value = {blob: null, id: args.id, revision: args.revision, offset: 0};
      input = value;
      let canvas, vectorUrl;
      try {
        let blob, pixels = el;
        if (config.readImage && !isCanvas && /^https?:/i.test(source(el))) {
          value.abort = new AbortController();
          try { blob = await config.readImage(el, value.abort.signal); } catch (_) {}
          if (input !== value || !active || disposed) throw Error('SOURCE_CHANGED');
          if (/^image\/svg\+xml\b/i.test(blob?.type || '')) {
            versions.get(el).svg = await svgViewport(blob);
            // The translation pipeline accepts raster pixels. The local copy also works for cross-origin SVGs.
            const copy = new Image(); copy.src = vectorUrl = URL.createObjectURL(blob);
            try { await copy.decode(); pixels = copy; } catch (_) {} // The already displayed image can still be readable.
            blob = null;
          }
        }
        if (!blob?.size) try {
          // Read decoded pixels consistently, even when the page revoked its Blob URL.
          canvas = isCanvas ? el : document.createElement('canvas');
          if (!isCanvas) {
            canvas.width = width; canvas.height = height;
            canvas.getContext('2d').drawImage(pixels, 0, 0, width, height);
          }
          blob = await new Promise(resolve => canvas.toBlob(resolve, 'image/png'));
        } catch (_) { throw Error('SOURCE_MISSING'); }
        record(args.id, args.revision);
        if (input !== value || !active || disposed) throw Error('BRIDGE_INVALID');
        if (!blob || !blob.size) throw Error('SOURCE_MISSING');
        value.blob = blob;
        return {size: blob.size};
      } catch (error) {
        if (input === value) input = null;
        throw error;
      } finally {
        if (vectorUrl) URL.revokeObjectURL(vectorUrl);
        if (canvas && !isCanvas) canvas.width = canvas.height = 0;
      }
    }
    if (operation === 'inputChunk') {
      const value = input;
      if (!value?.blob || args.id !== value.id || args.offset !== value.offset) throw Error('BRIDGE_INVALID');
      record(value.id, value.revision);
      const slice = value.blob.slice(value.offset, value.offset + CHUNK);
      let data;
      try { data = encode(new Uint8Array(await slice.arrayBuffer())); }
      catch (_) { throw Error('SOURCE_MISSING'); }
      record(value.id, value.revision);
      if (input !== value) throw Error('BRIDGE_INVALID');
      value.offset += slice.size; return data;
    }
    if (operation === 'inputEnd') { const value = input; input = null; value?.abort?.abort(); if (value) record(value.id, value.revision); return true; }
    if (operation === 'resultBegin') {
      if (args.scope !== displayScope) throw Error('SOURCE_CHANGED');
      record(args.id, args.revision);
      if (output || !Number.isSafeInteger(args.size) || args.size < 1) throw Error('BRIDGE_INVALID');
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
      const value = output;
      if (!value || value.id !== args.id || value.offset !== value.size || value.decoding) throw Error('BRIDGE_INVALID');
      value.decoding = true;
      record(value.id, value.revision);
      const png = new Blob(value.chunks, {type:'image/png'});
      value.chunks.length = 0;
      let url = URL.createObjectURL(png);
      const preview = new Image(); preview.src = url;
      const decode = async () => {
        // Throw in the reader's realm, not inside Gecko's page-owned decode promise.
        try { await preview.decode(); } catch (_) { throw Error('INVALID_RESULT'); }
      };
      try {
        await decode();
        if (!active || output !== value || disposed) throw Error('SOURCE_CHANGED');
        const {el} = record(value.id, value.revision);
        const sized = await displayUrl(el, png, preview);
        if (sized !== url) {
          URL.revokeObjectURL(url); url = sized; preview.src = url;
          await decode();
        }
        if (!active || output !== value || disposed) throw Error('SOURCE_CHANGED');
        record(value.id, value.revision);
        drop(value.id);
        // Keep the decoded image hot only inside the current reading window. Switching views is paint-only.
        overlays.set(value.id, {...display(el, preview), preview, url, revision:value.revision}); place(); return true;
      } catch (error) { URL.revokeObjectURL(url); throw error; }
      finally { if (output === value) output = null; }
    }
    if (operation === 'resultAbort') {
      output = null;
      if (overlays.get(args.id)?.revision === args.revision) drop(args.id);
      return true;
    }
    throw Error('BRIDGE_INVALID');
  }
  function dispose() {
    pressedLink = null;
    disposed = true; cancelPress(); clearTimeout(timer); clearInterval(canvasTimer); cancelRestore(); observer?.disconnect();
    viewport?.disconnect(); near.clear(); slots=null; removeEventListener('resize', watchViewport);
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
    records.clear(); input?.abort?.abort(); input = null; output = null; probe.width = probe.height = 0;
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
    if (hints && changes.some(c => {
      const el = c.target.parentElement;
      if (c.type === 'characterData') return el?.closest('a,title');
      if (c.target.closest('[data-nodelane-overlay]')) return false;
      if (c.type === 'attributes') return c.target.matches('a');
      return c.target.closest('a,title') || [...c.addedNodes,...c.removedNodes].some(n =>
        n instanceof Element && (n.matches('a,title') || n.querySelector('a[href],title')));
    })) hints=null;
    for (const change of changes) if (change.type === 'childList') {
      change.removedNodes.forEach(node => watch(node,false));
      change.addedNodes.forEach(node => watch(node,true));
    }
    if (changes.some(change => !(change.target instanceof Element && change.target.closest('[data-nodelane-overlay]')))) schedule();
  });
  observer.observe(document.documentElement, {subtree:true,childList:true,characterData:true,attributes:true,attributeFilter:['src','srcset','sizes','width','height','style','class','href','aria-label','title','aria-disabled','hidden','inert']});
  watchViewport(); addEventListener('resize', watchViewport, {passive:true});
  const canvasTimer = setInterval(() => {
    if (active && [...records.values()].some(({el}) => el instanceof HTMLCanvasElement)) schedule();
  }, 500);
})();
