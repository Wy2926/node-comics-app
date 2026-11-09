# 漫画翻译架构

本文只描述手机 App 的当前实现与验证边界。开发约定与许可见 [AGENTS](../AGENTS.md)、[UPSTREAM](../UPSTREAM.md)。

## 模块边界

| 模块 | 职责 |
| --- | --- |
| [contracts.dart](../lib/services/translation/contracts.dart) | 来源读取、页面定位、渠道运行时、状态与图片租约；不依赖 WebView 或官方 API |
| [source_images.dart](../lib/services/translation/source_images.dart) | 当前窗口内合并原图读取与 SHA-256 计算，离窗释放压缩文件，不保留解码位图 |
| [translation_service.dart](../lib/services/translation/translation_service.dart) | 当前账号、语言和渠道的组合入口 |
| [channels/nodelane](../lib/services/translation/channels/nodelane/) | 官方认证、逐图 UUID、上传、状态订阅、重试与结果读取 |
| [image_work.dart](../lib/services/translation/image_work.dart)、[translation_repository.dart](../lib/repositories/translation_repository.dart) | 串行图片准备／合成，私有回执、输入与完整译图缓存 |
| [translation_view_controller.dart](../lib/modules/translation/translation_view_controller.dart) | 原译图选择、窗口、图内状态、单图动作和显示租约 |
| [reader_translation.dart](../lib/modules/manga/reader/reader_translation.dart) | 阅读器原始页定位与取图，不覆盖来源页数据 |
| [translation_bridge.dart](../lib/modules/webview/translation_bridge.dart)、[nodelane_reader.js](../assets/nodelane_reader.js) | 网页图片发现、取图、显示定位与传输，没有 Comipo 特判 |

当前仅接入 NodeLane 官方 classic 渠道。阅读器与网页依赖统一渠道契约；完整图片 FakeChannel 验证替换边界，不要求其他渠道实现官方 UUID、SSE、覆盖图或计费协议。同级 PC 插件仅作设计参考，不是运行时依赖。

## 内容身份、缓存与任务

TranslationPage.key/revision 只标识当前来源定位。网页使用文档代次、元素 ID 和元素修订，DOM 序号不参与翻译身份；元素换源或移除只取消旧位置的工作与显示，不向新图片报告“原图变化”。

1. 读取当前图片并计算内容 SHA-256，当前窗口的恢复与送译共用原图及摘要。
2. 按服务／账号作用域、图片 hash、目标语言查找已有记录。
3. 完整译图缓存命中直接显示，不重新核验旧回执的原图，不重复计算译图摘要、下载或合成。
4. 已有任务复用原 UUID；本地缓存缺失时读取该任务的结果，不自动重调模型。
5. 没有对应记录才准备输入并新建任务。新 hash 是新图片，正常翻页无需手动重译。

新定位首次仍需读取图片以确定 hash，不能用 URL、页码或相同尺寸代替内容身份。同一内容的多个元素共用任务和缓存，各自保持显示定位。旧页槽回执一次性改为内容绑定，保留 UUID、输入与结果，移除旧绑定及持久页面修订字段。

官方 scope 包含服务地址、稳定账号 ID 和协议版本；语言参与内容绑定。来源地址、Cookie 与 headers 只留在取图层。账号或渠道切换不会读取其他 scope 的任务。

## 使用与生命周期

首次显示原图，自动翻译开关默认开启；仅前台显示译图且自动翻译开启时自动送译。切回原图停止新增送译并保留开关选择。关闭自动翻译仍可显示缓存、读取已有结果和显式操作单张图片。

阅读器从当前页向后取，拆页共用同一源图，窗口上限为 min(visibleCount + 2, 4)。网页选取当前视口及下方附近已加载图片，最多四张。最多两个本地调度任务在途，像素工作、提交／上传分别串行；服务端控制执行并发和限流，不根据累计旧任务数量阻止新图片。

离窗取消本地工作，原图文件在最后一个使用者释放后清理；结果显示租约独立释放。后台已受理任务可以继续完成。迟到结果不能贴到已经替换的元素上。原译图切换不重建来源页、不改变阅读位置。

阅读器与网页共用处理中／异常状态、长按单图菜单和翻译面板。成功、无文字及未送译图片不显示角标。界面约定见 [MOBILE_UI_DESIGN](MOBILE_UI_DESIGN.md#翻译与账号设置)。

## 官方恢复与错误

- 提交前持久保存 UUID、精确请求体和送译文件；响应丢失、超时或断网后查询同一个 UUID，不生成重复请求。
- 已有成功回执与完整译图不需要远端核实。缺少本地文件时读取同一结果，下载失败与翻译失败分别处理。
- 显式重试使用 retry_of，成功任务重译使用 regenerate_of；未知执行先核实，避免重复执行与扣费。
- 补传旧任务或重新合成结果时，输入必须匹配任务冻结的摘要与尺寸。这项一致性检查不限制翻页到新图片。
- no_text 保留原图。结果过期仍可显示已保存的完整译图；无本地译图时提示显式重译。
- 区分取图失败、图片无法处理、网络失败、额度／限流、结果读取失败和远端结果待核实。本地取图失败提供重试，不显示远端核实。

SSE 聚合当前窗口的活动 UUID，每批最多 32 项，沿用现有超时与网络退避。隐藏、暂停、换账号或释放后断开，不为旧页保活 WebView。

## 网页取图与资源边界

HTTP(S) 图片由原生来源客户端读取到临时文件，CookieManager 按实际目标 URL 提供会话，跨站重定向不盲目转发敏感 headers。当前网页来源客户端仍限制私网地址，Fake-IP 代理解析可能被拒绝，尚未解决。

Blob 图片统一从已解码 img 按自然尺寸导出 PNG，包括已撤销 Blob URL 的图片，不再 fetch Blob URL。临时 Canvas 在成功、失败或取消后释放。不能读取像素时报告取图失败，不上传整页截图。

桥接每块 128 KiB，输入／输出各串行一个传输，原生流式写文件。元素修订和文档代次只保证读取、动作及覆盖仍属于当前元素。译图采用不拦截触控的独立 Canvas 覆盖层，不改写原始 src/srcset。

脚本重新安装时统一释放旧窗口并重置消息序号；同一文档重复触发加载完成也按新桥接处理。图片发现由脚本合并事件，原生不再额外按时间丢弃窗口更新，也不逐条重复查询当前 URL。

新增像素工作预算为 64 MiB，原图传输上限 32 MiB；输入和完整结果磁盘预算为 128 MiB、256 MiB。它们限制实际分配与缓存占用，不是 App 总内存的实测保证。像素估算仍较保守，部分高清页会被拒绝。

Canvas 主动发现由 NODELANE_READABLE_CANVAS 默认关闭。data URL、跨域 iframe、受污染 Canvas、CSS 变换／cover 图形、16-bit／ICC／动画／AVIF、超预算图片和 tiles 结果未作为可用能力交付。网页活动 1 个、温存 1 个／30 秒，最多 12 个逻辑标签；空标签不创建 WebView。

## 认证与设置

默认服务为 https://comics.nodelane.net，构建可通过 NODELANE_API_BASE 指定兼容服务。账号入口在“更多”，语言与缓存管理复用现有设置。目标语言支持 17 项，首次按应用／系统语言选择，之后保留已保存值。

移动 OAuth 使用 Native public client，回调为 nodelane-comics://nodelane-auth。PKCE、state、账号隔离和系统安全存储属于正常认证流程，内容绑定调整不修改它们。供应商密钥不进入 App。平台配置见 [应用链接](MOBILE_UI_DESIGN.md#应用链接)。

## 验证与待办

```sh
flutter test --no-pub test/services/translation test/modules/translation test/modules/webview
python -B test/services/translation/browser_bridge_test.py
flutter build apk --debug --target-platform android-arm64 --no-pub
```

回归关注内容换页、返回旧图、同内容合并、冷缓存恢复、旧记录升级、重复脚本安装、丢失响应、取消释放、账号隔离与原译图切换。

MuMu Android 12 使用真实官方服务验证了 Comipo 样本 BJ02519788：连续翻阅第 1–8 页、相邻页预读、冷启动缓存恢复、刷新后翻页及原译图切换。返回和刷新复用原 UUID，没有新增翻译任务。

桌面 Chrome 夹具、Flutter 测试、Android 构建与 MuMu 运行分别验收，不能替代真机或所有源站兼容性。iOS WebView、真实设备峰值内存、长图和特殊格式仍未验收。
