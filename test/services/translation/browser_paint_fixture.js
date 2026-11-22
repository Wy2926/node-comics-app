// Test artwork is red in the original and blue in an independently sized PNG.
async function preparePaintFixture() {
  const result = document.querySelector('#result'), stage = document.createElement('div');
  result.hidden = true;
  document.body.replaceChildren(result, stage);
  stage.style = 'margin:20px;display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px';
  const art = document.createElement('canvas');
  art.width = 80; art.height = 56;
  const pen = art.getContext('2d');
  pen.fillStyle = 'red'; pen.fillRect(0,0,64,24); pen.fillRect(20,24,28,32);
  const responsive = new Image(), crop = new Image(), vector = new Image();
  responsive.srcset = art.toDataURL()+' 2x';
  responsive.style = 'width:78%;height:auto';
  crop.src = art.toDataURL();
  crop.style = 'width:80%;height:62px;object-fit:none;object-position:75% 25%;border:2px solid black';
  vector.src = 'data:image/svg+xml,'+encodeURIComponent(
    '<svg xmlns="http://www.w3.org/2000/svg" width="40" height="60" viewBox="10 20 30 30" preserveAspectRatio="xMaxYMin meet"><path fill="red" d="M10 20h30v12H22v18H10z"/></svg>');
  vector.style = 'width:100%;height:80px';
  art.style = 'width:72%;height:64px;object-fit:cover;object-position:80% 35%;padding:3px;border:2px solid black;transform:rotate(5deg);clip-path:inset(2% 0 5% 8%)';
  const elements = [responsive,crop,vector,art];
  stage.append(...elements);
  await Promise.all([responsive.decode(),crop.decode(),vector.decode()]);
  scrollTo(0,0);
  const frame = () => new Promise(done => requestAnimationFrame(() => requestAnimationFrame(done)));
  const originals = new Map();
  let prepared = false;
  window.paintLayout = async (mode,width) => {
    stage.style.width = width+'px';
    const translated = mode === 'translated';
    await call('state',{active:true,translated}); await frame();
    if (translated && !prepared) {
      await wait(240);
      const items = windows.at(-1).items;
      assert(items.length === elements.length,'paint fixture not in reading window');
      for (const item of items) {
        const {chunks} = await readInput(item);
        const bitmap = await createImageBitmap(new Blob(chunks.map(c => Uint8Array.from(atob(c.data),b=>b.charCodeAt(0)))));
        const out = document.createElement('canvas');
        out.width = bitmap.width*3; out.height = bitmap.height*2;
        const ctx = out.getContext('2d');
        ctx.imageSmoothingEnabled = false; ctx.drawImage(bitmap,0,0,out.width,out.height); bitmap.close();
        ctx.globalCompositeOperation = 'source-in'; ctx.fillStyle = 'blue'; ctx.fillRect(0,0,out.width,out.height);
        const data = out.toDataURL().split(',')[1];
        await call('resultBegin',{...item,size:atob(data).length});
        await call('resultChunk',{id:item.id,offset:0,data}); await call('resultEnd',item);
      }
      prepared = true;
    }
    await frame();
  };
  window.checkPaint = async (mode,width,screenshot) => {
    const img = new Image(); img.src = 'data:image/png;base64,'+screenshot; await img.decode();
    const bitmap = document.createElement('canvas');
    bitmap.width = img.width; bitmap.height = img.height;
    const ctx = bitmap.getContext('2d'); ctx.drawImage(img,0,0);
    const blue = mode === 'translated';
    for (const [i,el] of elements.entries()) {
      const b = el.getBoundingClientRect(), key = width+':'+i;
      const rect = [b.left,b.top,b.width,b.height], rgba = ctx.getImageData(...rect).data, mask = [];
      for (let p=0;p<rgba.length;p+=4) mask.push(rgba[p+(blue?2:0)]-rgba[p+(blue?0:2)] > 120);
      const count = mask.filter(Boolean).length;
      assert(count > 150,`${key}: ${mode} artwork was not painted (${count} pixels)`);
      if (mode === 'original') originals.set(key,{rect,mask,count});
      else {
        const before = originals.get(key);
        assert(rect.every((n,k)=>Math.abs(n-before.rect[k])<.1),`${key}: ${mode} changed the layout box`);
        const changed = mask.reduce((n,p,k)=>n+(p!==before.mask[k]),0);
        assert(changed < before.count*.06,`${key}: ${mode} changed painted bounds/crop (${changed} differences, ${count} painted, was ${before.count})`);
      }
    }
  };
}
