// SPDX-License-Identifier: GPL-3.0-or-later
// UI adapter for the bundled uBO; only the host's isolated top frame can ask about its own tab.
import ubo from './js/background.js';

browser.runtime.onMessageExternal.addListener((request, sender) => {
    if (sender.id !== 'reader@nodelane.net' || sender.frameId !== 0 ||
        request?.what !== 'nodelaneSiteProtection' || !sender.tab?.active) return;
    const id = sender.tab.id;
    const tab = ubo.tabContextManager.lookup(id);
    const page = ubo.pageStoreFromTabId(id);
    if (!ubo.readyToFilter || !page || !tab || !/^https?:\/\//.test(tab.rawURL) ||
        tab.rawURL.split('#')[0] !== request.url || sender.url?.split('#')[0] !== request.url) return;
    if (typeof request.enabled === 'boolean') {
        page.toggleTrustedStatus(tab.normalURL, '', !request.enabled);
        ubo.updateToolbarIcon(id);
    }
    return Promise.resolve({
        enabled: !page.isTrusted(),
        blocked: page.counts.blocked.any,
        total: ubo.requestStats.blockedCount,
    });
});
