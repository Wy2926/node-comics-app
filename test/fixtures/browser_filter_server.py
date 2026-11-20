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


class Fixture(BaseHTTPRequestHandler):
    def do_GET(self):
        path = urlsplit(self.path).path
        if path == '/cookie':
            logged = 'audit=1' in self.headers.get('Cookie', '')
            body = f'<!doctype html><meta name="viewport" content="width=device-width"><title>Cookie fixture</title><p>Cookie {"present" if logged else "absent"}</p><a href="/cookie?login">Set test cookie</a>'.encode()
            mime = 'text/html'
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
