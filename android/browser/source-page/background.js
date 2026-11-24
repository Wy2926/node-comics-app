// Only the native-created, disposable source document receives a task on its reader port.
browser.runtime.onMessageExternal.addListener(async (task, sender) => {
  if (sender.id !== 'reader@nodelane.net' || !sender.tab || sender.frameId !== 0 ||
      !sender.documentId || sender.url !== task.url) return null;
  const origin = new URL(sender.url).origin;
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
