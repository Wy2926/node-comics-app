browser.runtime.onMessageExternal.addListener(async (task, sender) => {
  if (sender.id !== 'reader@nodelane.net' || !sender.tab || sender.frameId !== 0 ||
      !sender.documentId || !sender.url) return null;
  const origin = new URL(sender.url).origin;
  if (typeof task.preview === 'string') {
    // hash / pushState 保留 documentId，Gecko 的 sender.url 可能仍是初始网址。
    // 先核对来源；program 在该文档中再核对当前完整 URL 与 timeOrigin。
    if (new URL(task.url).origin !== origin) return null;
    // 可见页只在本次顶层文档的用户脚本世界执行，不继承内置扩展的 API。
    const [reply] = await browser.userScripts.execute({
      target: {tabId: sender.tab.id, documentIds: [sender.documentId]},
      world: 'USER_SCRIPT', js: [{code: task.preview}],
    });
    if (reply?.error) throw Error('Preview unavailable');
    return reply?.result ?? null;
  }
  if (sender.url !== task.url) return null;
  const start = `if (location.origin === ${JSON.stringify(origin)} && window === top) {
    globalThis.flutter_inappwebview = {callHandler(name, value) {
      if (name === 'setResponse' && typeof value === 'string') finish(value);
      return Promise.resolve();
    }};`;
  // Site scripts run with page privileges, never with the built-in extension's APIs.
  const js = `new Promise(finish => { ${start}\n${task.scripts.join('\n;\n')}\n} })`;
  const [reply] = await browser.userScripts.execute({
    target: {tabId: sender.tab.id, documentIds: [sender.documentId]},
    world: 'MAIN', js: [{code: js}],
  });
  return typeof reply?.result === 'string' ? reply.result : null;
});
