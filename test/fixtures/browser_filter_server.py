"""Run locally, then open the printed address via adb reverse on an Android device."""
import argparse
import base64
from http.server import BaseHTTPRequestHandler, ThreadingHTTPServer
from urllib.parse import urlsplit

PIXEL = base64.b64decode(
    'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8'
    '/x8AAwMCAO+j4/kAAAAASUVORK5CYII=')

PAGE = b"""<!doctype html><meta name="viewport" content="width=device-width">
<title>Checking filter</title><h1 id="result">Checking filter</h1>
<p>Both images use the same bytes; only the request path differs.</p>
<a href="/chapter" target="_blank">Open another tab</a><br>
<input placeholder="Keep this text when switching tabs">
<div style="height:200vh"></div><p>End of chapter</p>
<script>
async function image(path) {
  return new Promise(resolve => {
    const img = new Image();
    img.onload = () => resolve(true);
    img.onerror = () => resolve(false);
    img.src = path + '?' + Date.now();
    document.body.prepend(img);
  });
}
Promise.all([image('/book/page.png'), image('/ads/banners/creative.png')]).then(([book, ad]) =>
  document.title = document.querySelector('#result').textContent =
    !book ? 'FAIL: comic missing' : ad ? 'Site filter OFF' : 'Site filter ON');
</script>"""

# Both controls traverse the same SPA; a new document increments the counter.
NAVIGATION = b"""<!doctype html><meta name="viewport" content="width=device-width">
<title>Navigation fixture</title><h1>Navigation fixture</h1>
<p id="state"></p><input aria-label="Draft" autocomplete="off">
<button id="chapter">Open chapter</button>
<button onclick="history.back()">Page back</button>
<a href="/navigation?background=1">Background chapter</a>
<p>needle one, needle two</p>
<script>
const load = Number(sessionStorage.fixtureLoads || 0) + 1;
sessionStorage.fixtureLoads = load;
const draft = document.querySelector('input');
function render() {
  document.querySelector('#state').textContent =
    `Load ${load} | ${location.search ? 'Chapter' : 'Contents'} | ${draft.value || 'empty'}`;
}
document.querySelector('#chapter').onclick = () => {
  draft.value ||= 'draft';
  history.pushState({}, '', '?chapter=1');
  render();
};
draft.oninput = render;
addEventListener('popstate', render);
render();
</script>"""

def reading(chapter):
    return (f'<!doctype html><meta name="viewport" content="width=device-width">'
            f'<title>Fixture chapter {chapter}</title><style>*{{margin:0}}img{{width:100%;height:150vh;display:block}}'
            'output{position:fixed;right:0;top:0;background:white}</style>'
            + ''.join(f'<img data-page-number="{page}" alt="Panel {page}" src="/panel/{page}.svg">' for page in range(1,5))
            + ('<a href="/read/2">Next chapter</a>' if chapter == '1' else 'End')
            + '''<output></output><script>
function report(){
  for (const img of document.images){
    const b=img.getBoundingClientRect(), f=(innerHeight/2-b.top)/b.height;
    if(f>=0 && f<=1){document.querySelector('output').textContent=img.alt+' @ '+Math.round(100*f)+'%';break;}
  }
}
addEventListener('scroll',report);addEventListener('resize',report);report();
</script>''').encode()


class Fixture(BaseHTTPRequestHandler):
    def do_GET(self):
        path = urlsplit(self.path).path
        if path == '/cookie':
            logged = 'audit=1' in self.headers.get('Cookie', '')
            body = f'<!doctype html><meta name="viewport" content="width=device-width"><title>Cookie fixture</title><p>Cookie {"present" if logged else "absent"}</p><a href="/cookie?login">Set test cookie</a>'.encode()
            mime = 'text/html'
        elif path in [f'/read/{n}' for n in range(1,7)]:
            body,mime = reading(path[-1]),'text/html'
        elif path in [f'/panel/{n}.svg' for n in range(1,5)]:
            n = int(path[7])
            body = (f'<svg xmlns="http://www.w3.org/2000/svg" width="320" height="860" viewBox="0 0 320 860">'
                    f'<rect width="320" height="860" fill="{["#e4ede7","#e4e8fb","#f9e4dd","#ddf3fa"][n-1]}"/>'
                    + ''.join(f'<text x="24" y="{100+i*170}" font-size="22">Panel {n} / line {i+1}</text>' for i in range(5))
                    + '</svg>').encode()
            mime='image/svg+xml'
        elif path in ('/', '/chapter'):
            body, mime = PAGE, 'text/html'
        elif path == '/navigation':
            body, mime = NAVIGATION, 'text/html'
        elif path in ('/book/page.png', '/ads/banners/creative.png'):
            if 'fixture=reader' not in self.headers.get('Cookie', ''):
                self.send_error(403)
                return
            body, mime = PIXEL, 'image/png'
        else:
            self.send_error(404)
            return
        self.send_response(200)
        self.send_header('Content-Type', mime)
        if path == '/cookie' and urlsplit(self.path).query == 'login':
            self.send_header('Set-Cookie', 'audit=1; Path=/; HttpOnly; SameSite=Strict')
        elif path in ('/', '/chapter'):
            self.send_header('Set-Cookie', 'fixture=reader; Path=/; HttpOnly; SameSite=Strict')
        self.send_header('Cache-Control', 'no-store')
        self.end_headers()
        self.wfile.write(body)


if __name__ == '__main__':
    parser = argparse.ArgumentParser()
    parser.add_argument('--port', type=int, default=8769)
    port = parser.parse_args().port
    with ThreadingHTTPServer(('127.0.0.1', port), Fixture) as server:
        print(f'adb reverse tcp:{port} tcp:{port}  ->  http://127.0.0.1:{port}/', flush=True)
        server.serve_forever()
