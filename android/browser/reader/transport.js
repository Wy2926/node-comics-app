// Runs in the extension's isolated top-frame world, never in page script.
(() => {
  let port;
  function connect() {
    port = browser.runtime.connectNative('reader');
    port.onMessage.addListener(async ({id, url, operation, token, args}) => {
      const owner = port;
      let value, error;
      try {
        if (url.split('#')[0] !== location.href.split('#')[0]) throw Error('SOURCE_CHANGED');
        if (operation === 'siteProtection') {
          value = await browser.runtime.sendMessage('uBlock0@raymondhill.net', {
            what: 'nodelaneSiteProtection', url: location.href.split('#')[0], enabled: args.enabled,
          });
        } else if (operation === 'install') {
          installReader({token,
            send: message => browser.runtime.sendNativeMessage('reader', {url: location.href, message}),
            readImage: async (el, signal) => {
              const image = new URL(el.currentSrc || el.src);
              if (!['http:', 'https:'].includes(image.protocol) || image.username || image.password)
                throw Error('SOURCE_MISSING');
              const response = await fetch(image.href, {
                credentials: 'include', cache: 'force-cache', signal,
                referrer: location.href, referrerPolicy: 'strict-origin-when-cross-origin',
              });
              // Login redirects can return a successful HTML page instead of an image.
              if (!response.ok) throw Error('SOURCE_MISSING');
              const blob = await response.blob();
              if (!/^image\//i.test(blob.type)) (await createImageBitmap(blob)).close();
              return blob;
            }});
          const icon = [...document.querySelectorAll('link[rel~="icon"],link[rel^="apple-touch-icon"]')]
            .find(link => /^https?:/.test(link.href) && link.type !== 'image/svg+xml');
          value = icon?.href || null;
        } else {
          value = await window.__nodelaneReader.call(token, operation, args);
        }
      } catch (err) {
        error = ['SOURCE_CHANGED', 'RESOURCE_LIMIT', 'SOURCE_MISSING'].includes(err.message)
          ? err.message : 'BRIDGE_INVALID';
      }
      if (port === owner) owner.postMessage({id, value: value ?? null, error: error ?? null});
    });
  }
  connect();
  addEventListener('pagehide', () => {
    window.__nodelaneReader?.dispose();
    port.disconnect();
    port = null;
  });
  addEventListener('pageshow', event => { if (event.persisted) connect(); });
})();
