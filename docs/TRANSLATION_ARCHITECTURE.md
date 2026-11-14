# 漫画翻译架构

本文只描述手机 App 的当前实现与验证边界。开发约定与许可见 [AGENTS](../AGENTS.md)、[UPSTREAM](../UPSTREAM.md)、[第三方声明](../THIRD_PARTY.md)。

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
| [translation_bridge.dart](../lib/modules/webview/translation_bridge.dart)、[image_archive.dart](../lib/modules/webview/image_archive.dart)、[nodelane_reader.js](../assets/nodelane_reader.js) | 网页图片发现、浏览器已加载资源取流、显示定位与传输，没有站点特判 |

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

阅读器从当前页向后取，拆页共用同一源图，窗口上限为 min(visibleCount + 2, 4)。网页遍历主文档全部 img/canvas，按视口和阅读焦点优先选择附近已加载图片，当前处理窗口最多四张；没有最小尺寸或 DOM 前若干元素截断。小图、图标和广告也可能成为候选，不在客户端判断是否有可译文字。最多两个本地调度任务在途，像素工作、提交／上传分别串行；服务端控制执行并发和限流，不根据累计旧任务数量阻止新图片。

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

### 送译与结果协议

- `X-Translation-Protocol: overlay-v1` 是所有翻译 API 请求的协议头；`result_format` 是新任务的结果格式选择，两者独立。先读取 `/v1/capabilities`，再以 `PUT /v1/translations/{UUID}` 提交冻结的图片描述、`classic` 和目标语言；收到 `needs_input` 才把同一文件的原始字节 PUT 到 `/input`。
- 普通图片省略 `result_format`；归一化输入任一边超过 WebP 的 16383 像素时，按 `representations` 协商 `overlay-tiles-v1`。服务未公布该能力时显示服务暂不可用，显式重试重新读取能力。这是结果编码协商，输入仍保持原尺寸。已冻结请求的恢复、补传和同 UUID 重放使用原请求体；显式新建的重试／重译可协商 tiles。
- 支持 `original`、`overlay-v1`、`overlay-tiles-v1` 和 `full-image-v1`。覆盖结果核对冻结输入身份及尺寸；完整图片按结果声明的输出尺寸解码，无需恢复输入文件。所有译图校验摘要、字节数、MIME 与实际像素后保存为完整 PNG，供阅读器与网页共用；缓存保留输出尺寸，结果过期后仍可读取本地译图。
- tiles 使用 `NCOT0001` 容器：校验清单、每块摘要、位置、范围及不重叠，逐块解码并以 `source-atop` 合成，保留原图透明度；损坏结果不发布半成品。清单与块规格来自协议，不作为原图尺寸或体积上限。
- 结果从鉴权后的 `/result` 入口下载，可跟随 HTTP 重定向；跨 origin 后移除 API 凭据，资源主机的 401 归为结果读取失败。限流等待支持响应头及 `error.retry_after_seconds`。

## 网页取图与资源边界

HTTP(S) 图片优先复用 WebView 已加载的原始响应字节。通过现有插件调用 [Android WebView.saveWebArchive](https://developer.android.com/reference/android/webkit/WebView#saveWebArchive(java.lang.String,%20boolean,%20android.webkit.ValueCallback%3Cjava.lang.String%3E)) 或 [iOS WKWebView.createWebArchiveData](https://developer.apple.com/documentation/webkit/wkwebview/createwebarchivedata(completionhandler:))，按当前元素 URL 提取原始图片，不重载页面、不截图、不修改跨域设置。Android 按 MIME 流式解码，iOS 使用系统 property-list 解码；两者都不把 HTML、Cookie 或其他页面资源交给翻译服务。

同一窗口的并发取图合并一次归档，提取后立即删除完整归档，仅保留当前图片窗口需要的压缩文件。离窗、切换账号／渠道、后台或导航时释放缓存所有权，最后一个读取租约释放后删除图片及临时目录；原生归档无法中断时清理其迟到结果。返回图片前重新核验文档代次与 DOM 修订，避免换源时送错图。归档缓存未命中或平台不支持时继续使用原生 HTTP 来源读取；不会因缓存失败取消原有下载能力。

原生 HTTP 来源客户端流式读取到临时文件，不按文件大小、私网或 Fake-IP 地址拒绝，也不固定 DNS 或强制直连。CookieManager 按每次实际目标 URL 提供会话；重定向没有固定跳数，保留重复 URL 循环检测、取消和网络超时。来源客户端不持有翻译服务凭据。若图片不在浏览器归档中且原生请求也被源站拒绝，仍如实报告取图失败。

Blob、data 图片与 Canvas 共用 `pixels` 取图路径，没有站点专用 Blob 适配。图片从已解码 img 按自然尺寸导出 PNG，包括已撤销 Blob URL 的图片。可读 Canvas 默认参与发现；窗口内定时采样其像素修订，重绘后取消旧定位。临时 Canvas 在成功、失败或取消后释放。归档只替代 HTTP(S) 图片的重复网络读取，不能整体替代这条像素路径；平台不允许读取像素时报告取图失败，不上传整页截图。

桥接每块 128 KiB，输入／输出各串行一个传输，原生流式写文件，不限制单张图片的总传输大小。元素修订和文档代次只保证读取、动作及显示仍属于当前元素；data URL 不放入窗口消息，元素修订使用短标识。

沿用 NodeLane Comics 扩展的显示方式：img 通过 CSS content 显示译图，保留 src/srcset、裁剪、变换及事件；Canvas 使用不拦截触控的同级图片覆盖，跟随原元素的变换。切回原图、离窗或关闭页面时恢复属性并释放对象 URL。

脚本重新安装时统一释放旧窗口并重置消息序号；同一文档重复触发加载完成也按新桥接处理。图片发现由脚本合并事件，原生不再额外按时间丢弃窗口更新，也不逐条重复查询当前 URL。

客户端不设图片宽高、像素数、文件体积或解码预算硬上限，也不自动缩到固定短边。服务 capabilities 中的尺寸字段不再作为本地拒收条件，服务端最终响应仍按实际结果处理。输入和完整结果缓存的 128 MiB、256 MiB 仅用于淘汰未使用文件；当前大文件、在途输入和显示租约可超过目标，不因此拒收。磁盘实际不足、平台解码失败或服务端限制仍可能导致失败；取消客户端限制不代表设备资源无限。

图片使用现有 image 解码器，不按 ICC、16-bit、色彩元数据或动画预先拒绝。EXIF 方向归一化；原生动图取首帧，网页像素导出取当前显示帧。Dart 解码器不支持的格式交由 Flutter 平台编解码器，AVIF 可使用已有解码实现；实际可用格式取决于平台。没有实现 iframe 内图片发现或平台禁止读取的 Canvas。网页活动 1 个、温存 1 个／30 秒，最多 12 个逻辑标签；空标签不创建 WebView。

## 认证与设置

默认服务为 https://comics.nodelane.net，构建可通过 NODELANE_API_BASE 指定兼容服务。账号入口在“更多”，语言与缓存管理复用现有设置。目标语言支持 17 项，首次按应用／系统语言选择，之后保留已保存值。

移动 OAuth 使用 Native public client，回调为 nodelane-comics://nodelane-auth，使用 PKCE、state、账号隔离和系统安全存储。供应商密钥不进入 App。平台配置见 [应用链接](MOBILE_UI_DESIGN.md#应用链接)。

## 验证与待办

```sh
flutter test --no-pub test/services/translation test/modules/translation test/modules/webview
python -B test/services/translation/browser_bridge_test.py
flutter build apk --debug --target-platform android-arm64 --no-pub
```

| 层级 | 覆盖范围 |
| --- | --- |
| Flutter／文件回归 | 内容换页与合并、冷缓存及旧记录恢复、丢失响应、账号隔离、取消与租约释放；原尺寸长图、HTTP 流、重定向循环、软淘汰、16-bit PNG 和动图首帧 |
| 本地协议服务 | tiles 协商、冻结请求精确重放、显式重试、损坏结果、独立输出尺寸、过期缓存、跨源下载；使用合成图片 |
| Chrome DOM 夹具 | 小图与大量元素、data／Blob／Canvas、CSS 变换、Canvas 重绘、脚本重装、原译图切换及释放 |
| Android 模拟器／真实服务 | 正式签名 x86_64 Release 与真实账号验证原尺寸 800×20000 tiles、原位切换、重启缓存及同 UUID 结果重建；comix.to 验证已加载图片归档取流、HTTP 403 时复用原图、翻译显示、离页释放和任务复用 |
| iOS | 归档接口与系统 property-list 提取已接入，此归档链路尚未通过 Apple 工具链构建或设备运行验收 |

待验收：ARM 真机、iOS 真实取图与送译、完整图片输出及跨源下载的真实服务、大页面归档峰值、特殊格式与平台失败。线上匿名 capabilities 检查不代表完整协议验收。

待修复：重开 comix.to 页面可能回到顶部；需核对原生坐标、DOM 锚点和异步加载后的恢复时机。原译图原位切换的验证不覆盖重开页面。
