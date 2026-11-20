# 0.2.0 内置浏览器验证

功能和资源上限见[多标签浏览器](MOBILE_UI_DESIGN.md#多标签浏览器)。以下用例使用本地页面，不需要账号或翻译服务。

| 检查 | 用法与通过条件 |
| --- | --- |
| 导航与历史 | 按[过滤复验说明](MOBILE_UI_DESIGN.md#验证边界与待办)启动服务、映射端口，打开 [`/navigation`](../test/fixtures/browser_filter_server.py)。点 `Open chapter`，用 App 后退再前进：`Load` 数字不变、草稿仍为 `draft`；历史能找到 `?chapter=1`，即使网站没有图标。 |
| 查找、后台标签与误关 | 同页查 `needle` 有两处，关闭重开应显示零匹配。长按 `Background chapter` 在后台打开，目录位置不变；总览关闭再撤销，原章节和标签数恢复。 |
| 广告过滤与阅读通道 | [设备冒烟入口](../test/fixtures/gecko_reader_smoke.dart)检查首屏广告未加载、带 HttpOnly Cookie 的原图逐字节一致，然后在两个本地主机间连续切换四次。MuMu 输出 `GECKO_SMOKE_PASS`；旧文档的通道由网页或引擎关闭，宿主只取消旧请求。 |
| 分站清理 | 给同一服务的两个不同本地主机分别访问 `/cookie?login`，再访问 `/cookie` 确认均显示 `present`。从 A 的盾牌清除本站 Cookie；A 应为 `absent`、B 仍为 `present`。只改端口不能区分 Cookie 站点。 |
| 会话可靠性 | [存储回归](../test/modules/webview/browser_library_store_test.dart)模拟读写失败、重试、20 个标签各带 20 个长历史地址、拒绝第 21 张、关闭／撤销再读回。测试使用模拟私有存储，不改设备数据。 |
| 长章开销 | 桌面 Chrome、同一 1,000 张图的章末视口：单轮读取图片边界 **1,000 → 3** 次，取一次阅读锚点 **999 → 2** 次，两版均选中 3 张图。此为 DOM 调用次数，不是手机帧率。[真实 DOM 回归](../test/services/translation/browser_bridge_test.py)还覆盖动态新增、隐藏图、小图、Canvas 重绘、取消和重试。 |

MuMu API 32 x86_64 Debug 已实测：App 往返同一文档保留草稿、无图标章节历史、查找归零、后台开章、关闭／撤销，以及清除 A 站后 B 站的 HttpOnly Cookie 仍有效。渲染器退出后改址重建、慢截图不阻塞退出由 widget 测试覆盖。

自动回归：`flutter test test/modules/webview test/l10n/supported_languages_test.dart test/modules/translation test/widgets/nodelane_modals_test.dart`；真实 DOM：`python test/services/translation/browser_bridge_test.py`。

待设备验收：ARM 真机 Release 的滚动／退出 P95、Android 7 系统 WebView、iOS、真实站点登录与翻译服务。
