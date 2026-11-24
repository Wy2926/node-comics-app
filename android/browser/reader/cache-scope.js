// Invalidate source caches on account changes without exporting cookie names or values.
browser.cookies.onChanged.addListener(({cookie}) => {
  browser.runtime.sendNativeMessage('sourceCache', cookie.domain).catch(() => {});
});
