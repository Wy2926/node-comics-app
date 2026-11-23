# 漫画翻译架构

本文只描述手机 App 的当前实现与验证边界。开发约定与许可见 [AGENTS](../AGENTS.md)、[UPSTREAM](../UPSTREAM.md)、[第三方声明](../THIRD_PARTY.md)。

## 模块边界

| 模块 | 职责 |
| --- | --- |
| [contracts.dart](../lib/services/translation/contracts.dart) | 来源读取、页面定位、渠道运行时、状态与图片租约；不依赖 WebView 或官方 API |
| [source_images.dart](../lib/services/translation/source_images.dart) | 当前窗口内合并原图读取与 SHA-256 计算，离窗释放压缩文件，不保留解码位图 |
| [translation_service.dart](../lib/services/translation/translation_service.dart) | 当前账号、语言、模型和渠道的组合入口 |
| [channels/nodelane](../lib/services/translation/channels/nodelane/) | 官方认证、逐图 UUID、上传、状态订阅、重试与结果读取 |
| [image_work.dart](../lib/services/translation/image_work.dart)、[translation_repository.dart](../lib/repositories/translation_repository.dart) | 串行图片准备／合成，私有回执、输入与完整译图缓存 |
| [translation_view_controller.dart](../lib/modules/translation/translation_view_controller.dart) | 原译图选择、窗口、图内状态、单图动作和显示租约 |
| [reader_page_image.dart](../lib/modules/manga/reader/reader_page_image.dart) | 阅读器原图入口。显示、预取、长按操作和送译使用同一份来源还原后的图片；页面请求头优先于来源默认值，并发读取共用下载与原子落盘 |
| [reader_translation.dart](../lib/modules/manga/reader/reader_translation.dart) | 将原页定位映射到翻译窗口，把译图投影回原页；不另行请求图片 |
| [translation_bridge.dart](../lib/modules/webview/translation_bridge.dart)、[image_archive.dart](../lib/modules/webview/image_archive.dart)、[nodelane_reader.js](../assets/nodelane_reader.js) | 网页图片发现、浏览器已加载资源取流、显示定位与传输，没有站点特判 |

当前仅接入 NodeLane 官方 classic 渠道。阅读器与网页依赖统一渠道契约；完整图片 FakeChannel 验证替换边界，不要求其他渠道实现官方 UUID、SSE、覆盖图或计费协议。同级 PC 插件仅作设计参考，不是运行时依赖。

## 内容身份、缓存与任务

TranslationPage.key/revision 只标识当前来源定位。网页使用文档代次、元素 ID 和元素修订，DOM 序号不参与翻译身份；元素换源或移除只取消旧位置的工作与显示，不向新图片报告“原图变化”。

1. 读取当前图片并计算内容 SHA-256，当前窗口的恢复与送译共用原图及摘要。
2. 按服务／账号作用域、**原图** SHA-256 和目标语言查找已有任务，优先恢复活动或待核实的任务，否则显示最近一次显式操作的结果。换模型不自动重译，也不切回某个模型的旧结果。默认模型保留旧绑定键，显式模型的请求和回执单独保存。
3. 完整译图缓存命中直接显示，不重新核验旧回执的原图，不重复计算译图摘要、下载或合成。
4. 已有任务复用原 UUID；本地缓存缺失时读取该任务的结果，不自动重调模型。
5. 没有对应记录才准备输入并新建任务。新 hash 是新图片，正常翻页无需手动重译。

新定位首次仍需读取图片以确定 hash，不能用 URL、页码或相同尺寸代替内容身份。同一内容的多个元素共用任务和缓存，各自保持显示定位。旧页槽回执一次性改为内容绑定，保留 UUID、输入与结果，移除旧绑定及持久页面修订字段。

后端按实际送译字节的摘要和执行配置判断能否复用。另一台设备没有本地回执时，同一原图若编码出了不同字节，不保证命中服务端旧任务。

官方 scope 包含服务地址、稳定账号 ID 和协议版本。来源地址、Cookie 与 headers 只留在取图层。账号或渠道切换不会读取其他 scope 的任务。

## 使用与生命周期

首次显示原图，自动翻译开关默认开启；仅前台显示译图且自动翻译开启时自动送译。切回原图停止新增送译并保留开关选择。关闭自动翻译仍可显示缓存、读取已有结果和显式操作单张图片。

原生阅读器使用[原图的前向窗口](MOBILE_UI_DESIGN.md#漫画加载与资源调度)，不依赖页码标签、解码进度或后台预取是否完成。网页按视口和阅读焦点从主文档全部 img/canvas 中选取附近已加载图片，窗口仍最多四张。小图、图标和广告也可能成为候选，不在客户端判断是否有可译文字。窗口大小由各入口决定；渠道最多两个自动调度任务在途，像素工作、提交／上传分别串行；服务端控制执行并发和限流。

离窗即结束翻译对原图的等待并让出调度槽；仍供显示或预取的下载可以继续。译图结果按任务共享，最后一个读取者取消时停止排队／下载，有其他读取者时继续。网页提取的临时文件随最后一个租约释放。后台已受理任务可以继续完成。迟到结果不能贴到已经替换的元素上。原译图切换不重建来源页、不改变阅读位置。

阅读器与网页共用处理中／异常状态、长按单图菜单和翻译面板。成功、无文字及未送译图片不显示角标。界面约定见 [MOBILE_UI_DESIGN](MOBILE_UI_DESIGN.md#翻译与账号设置)。

## 官方恢复与错误

- 提交前持久保存 UUID、精确请求体和送译文件。创建或上传响应丢失时先查同一 UUID：服务从未受理且查无记录才原样重放；已受理又查无记录仅供核实。网络错误退避，429 优先按服务给出的等待时间恢复；创建请求的 `Retry-After` 在同账号切模型、重建运行时后仍生效。
- 已有成功回执与完整译图不需要远端核实。缺少本地文件时读取同一结果，下载失败与翻译失败分别处理。
- 创建被明确拒绝（例如额度不足或模型无权）会保存原因，重开页面不自动提交；显式重试相同选择时使用原 UUID 和请求体。已受理任务的终态失败不自动重跑：同模型手动重试用新 UUID 加 `retry_of`，改模型后手动重试是带新选择的普通请求。成功后的手动重译使用 `regenerate_of` 和当前模型选择。服务端分析上限和已撤销的请求不提供普通重试；执行结果不确定时只核实。
- 只有服务需要补传或本地需合成覆盖图时才读取冻结输入；输入被淘汰或损坏后，原字节摘要吻合就直接使用，否则按原方案重建并核对尺寸与摘要。无法重建时保留原 UUID，等待手动恢复；仅已明确以 `INPUT_NOT_NORMALIZED` 失败的上传可手动改用新摘要提交，不能重复发送被拒绝的相同字节。完整译图和完整图片结果均不要求本机能复现旧编码器。
- no_text 保留原图。结果过期仍可显示已保存的完整译图；无本地译图时提示显式重译。
- 区分取图失败、图片无法处理、网络失败、额度／限流、结果读取失败和远端结果待核实。本地取图失败提供重试，不显示远端核实。

SSE 聚合当前窗口的活动 UUID，每批最多 32 项，沿用现有超时与网络退避。隐藏、暂停、换账号或释放后断开，不为旧页保活 WebView。

### 送译与结果协议

- 新任务以 `PUT /v1/translations/{UUID}` 提交冻结的图片描述、`classic` 模式和目标语言；显式选模附 `model_id`，默认省略，不静默换模型。服务漏回 `requested_model_id` 时按已冻结的请求识别；明确回了不同 ID 则核实。收到 `needs_input` 才把同一文件的原始字节 PUT 到 `/input`。翻译任务的协议头 `X-Translation-Protocol: overlay-v1` 与结果格式 `result_format` 独立。
- 普通图片省略 `result_format`；新图片描述的最终送译副本任一边超过 WebP 的 16383 像素时，按 `representations` 协商 `overlay-tiles-v1`。服务未公布该能力时显示服务暂不可用，显式重试重新读取能力。`retry_of`／`regenerate_of` 由服务继承父任务的输入和结果格式，不按当前能力重新协商。
- 支持 `original`、`overlay-v1`、`overlay-tiles-v1` 和 `full-image-v1`。覆盖结果核对冻结输入身份及尺寸；完整图片按结果声明的输出尺寸解码，无需恢复输入文件。所有译图校验摘要、字节数、MIME 与实际像素后保存为完整 PNG，供阅读器与网页共用；缓存保留输出尺寸，结果过期后仍可读取本地译图。
- tiles 使用 `NCOT0001` 容器：校验清单、每块摘要、位置、范围及不重叠，逐块解码并以 `source-atop` 合成，保留原图透明度；损坏结果不发布半成品。清单与块规格来自协议，不作为原图尺寸或体积上限。
- 结果从鉴权后的 `/result` 入口下载，可跟随 HTTP 重定向；跨 origin 后移除 API 凭据，资源主机的 401 归为结果读取失败。限流等待支持响应头及 `error.retry_after_seconds`。

## 网页取图与资源边界

Android GeckoView 通过随包的顶层内容脚本执行同一份阅读脚本，原生消息绑定标签、文档与元素修订。HTTP(S) 图片在 Gecko 会话中按实际元素地址优先读缓存，未命中可能重新请求；失败尝试读取已显示图片的可读像素。与 Blob／Canvas 共用分块传输，不生成 MHTML，不从系统 WebView 复制登录凭据。

系统 WebView 的 HTTP(S) 图片优先复用已加载的原始响应字节。通过现有插件调用 [Android WebView.saveWebArchive](https://developer.android.com/reference/android/webkit/WebView#saveWebArchive(java.lang.String,%20boolean,%20android.webkit.ValueCallback%3Cjava.lang.String%3E)) 或 [iOS WKWebView.createWebArchiveData](https://developer.apple.com/documentation/webkit/wkwebview/createwebarchivedata(completionhandler:))，按当前元素 URL 提取原始图片，不重载页面、不截图、不修改跨域设置。Android 按 MIME 流式解码，iOS 使用系统 property-list 解码；两者都不把 HTML、Cookie 或其他页面资源交给翻译服务。

同一窗口的并发取图合并一次归档，提取后立即删除完整归档，仅保留当前图片窗口需要的压缩文件。离窗、切换账号／渠道、后台或导航时释放缓存所有权，最后一个读取租约释放后删除图片及临时目录；原生归档无法中断时清理其迟到结果。返回图片前重新核验文档代次与 DOM 修订，避免换源时送错图。归档缓存未命中或平台不支持时继续使用原生 HTTP 来源读取；不会因缓存失败取消原有下载能力。

原生 HTTP 来源客户端流式读取到临时文件，不按文件大小、私网或 Fake-IP 地址拒绝，也不固定 DNS 或强制直连。CookieManager 按每次实际目标 URL 提供会话；重定向没有固定跳数，保留重复 URL 循环检测、取消和网络超时。来源客户端不持有翻译服务凭据。若图片不在浏览器归档中且原生请求也被源站拒绝，仍如实报告取图失败。

Blob、data 图片与 Canvas 共用 `pixels` 取图路径，没有站点专用 Blob 适配。图片从已解码 img 按自然尺寸导出 PNG，包括已撤销 Blob URL 的图片。可读 Canvas 默认参与发现；窗口内定时采样其像素修订，重绘后取消旧定位。临时 Canvas 在成功、失败或取消后释放。归档只替代 HTTP(S) 图片的重复网络读取，不能整体替代这条像素路径；平台不允许读取像素时报告取图失败，不上传整页截图。

桥接每块 128 KiB，输入／输出各串行一个传输，原生流式写文件，不限制单张图片的总传输大小。元素修订和文档代次只保证读取、动作及显示仍属于当前元素；data URL 不放入窗口消息，元素修订使用短标识。

原图决定网页上的绘制尺寸，译图文件保留自己的分辨率。img 在原元素上替换 CSS `content`，保留 `src`、`srcset`、布局和事件；Canvas 用不拦截触控的同级图，跟随内容框、裁剪、定位及变换。SVG 可读取时，记录原 `viewBox` 和对齐方式，用自然尺寸的像素送译；系统 WebView 不能导出像素时保留归档原件。

首份译图解码就绪才原位显示。来回对照只切换已准备好的图，不再跨桥传输或重建图片；切回原图时恢复网站绘制。显示资源只保留在当前前台阅读窗口，换源、离窗、后台、切换运行时或关闭文档即释放；迟到的解码不能覆盖用户选择。

脚本重新安装时统一释放旧窗口并重置消息序号；同一文档重复触发加载完成也按新桥接处理。图片发现由脚本合并事件，原生不再额外按时间丢弃窗口更新，也不逐条重复查询当前 URL。

当前不发现 iframe 内图片，也不能导出平台禁止读取的 Canvas。网页缓存与标签释放规则见[多标签浏览器](MOBILE_UI_DESIGN.md#多标签浏览器)。

## 送译副本

阅读器与网页共用同一套送译加工。基准是 [NodeLane Comics 浏览器插件](../THIRD_PARTY.md) 的 `prepareComicPage` → `prepareTranslationInput` 产物：先得到静态 sRGB 阅读像素，再决定上传原字节还是重编码副本。拆页、裁边、缩放、滤镜与现有译图不参与取图；App 的原文件和本地任务绑定不变。

- JPEG 的 APP1/APP2、PNG 的 iCCP/gAMA/cHRM/eXIf/动画块、WebP 的 ICC/EXIF/动画块按规范化路径处理。JPEG/PNG 采用显示方向，WebP 沿用插件画布方向；动图取首帧的完整画布，网页已导出的像素沿用采样帧。
- 短边超过 1800 像素时按比例缩到 1800，不放大。短边已合适且不超过 1 MiB 的合规静态 JPEG、PNG、WebP 只解析元数据，直接使用原文件与摘要。
- 超过 1 MiB 而无需缩图时也尝试有损编码，只在副本更小时采用。缩图或 AVIF 转码时直接采用目标格式。常规副本使用有损 WebP（质量 90，保留透明度）；目标长边为 16384～65500 像素时使用白底 JPEG（质量 30）。
- 目标长边超过 JPEG 编码范围时，已规范化且无需缩放的原图保留原字节；必须缩图或 AVIF 转码时，如插件一样报告无法编码。文件缓存预算（输入 128 MiB／结果 256 MiB）不是准入条件。
- 编码器或平台不同时，重编码文件不保证字节相同。恢复只认该任务冻结的 SHA-256；早期移动端编码方案仅用于恢复已有 UUID。

## 认证与设置

默认服务为 https://comics.nodelane.net，构建可通过 NODELANE_API_BASE 指定兼容服务。账号入口在“更多”，语言与缓存管理复用现有设置。目标语言支持 17 项，首次按应用／系统语言选择，之后保留已保存值。

打开模型选择器时读取 `/v1/capabilities` 的 `translation_models`，登录后按当前账号读取。列表使用服务端 `name` 原文，保留括号及其中的说明；模型名最多两行，超出部分用省略号显示。`requires_paid` 为假用礼物图标，为真用银行卡图标，未声明时用普通翻译图标。读屏可识别已知档位。倍率徽标独立取自 `quota_multiplier`（如 `0.8×`、`1×`），未提供时不显示。

`available: true` 可选；`available: false` 且 `unavailable_reason: quota_exhausted` 时仍可保存为偏好。不可选模型右侧以「升级」替代单选钮，点按钮用系统浏览器打开[官网公开定价页](https://comics.nodelane.net/pricing/)，不传账号信息、不改模型选择；返回后重读目录。没有模型列表的旧服务可继续用默认模型。

选择按服务及账号保存；尚无个人设置时沿用登录前的选择。已有本地任务和译图不查询模型权益。由服务判断是否能复用同账号结果或受理新任务，选择模型本身不消耗额度。

账号、计费、翻译（含上传、结果重定向与 SSE）、原生 OAuth 换令牌、反馈及更新检查共用 [NodeLaneRequests](../lib/services/nodelane_requests.dart) 构造请求。统一 `User-Agent: nodelane-comics/<version>+<build> (<os>; <arch>)`，例如 `nodelane-comics/0.1.2+2003 (android; arm64)`；版本取已安装包信息，平台取运行系统，架构取当前进程 ABI。无构建号时省略 `+<build>`，包信息不可用时版本为 `unknown`。

构造器只提供身份和默认 JSON Accept，不持有账号凭据；各调用保留超时、取消、幂等和重定向策略。来源／WebView 的 UA 独立管理。统一请求头已由本地 HTTP／MockClient 回归覆盖，尚未完成 iOS 或真实后端请求头验收。

移动 OAuth 使用 Native public client，回调为 nodelane-comics://nodelane-auth，使用 PKCE、state、账号隔离和系统安全存储。供应商密钥不进入 App。平台配置见 [应用链接](MOBILE_UI_DESIGN.md#应用链接)。

从账号页或单图额度提示升级时，App 用当前账号向 `POST /v1/billing/app-handoff` 领取一次性码，核对账号后在系统浏览器打开同源套餐页。官网兑换页签专用的短期计费会话，用户选择套餐或页数包后才创建结账；不借用浏览器的登录身份，原生 access/refresh token 不进入网址。兼容服务需同时支持此接口和官网兑换流程；打不开或过期可从 App 再点升级。

## 验证与待办

```sh
flutter test --no-pub test/services/translation test/modules/translation test/modules/manga/reader test/modules/webview test/services/source_image_processing_test.dart
python -B test/services/translation/browser_bridge_test.py
flutter build apk --debug --target-platform android-arm64 --no-pub
```

| 层级 | 覆盖范围 |
| --- | --- |
| Flutter／文件回归 | 页面 Referer 与来源默认值冲突、冷缓存并发读取、插件条带还原和失败重试；内容换页、旧记录恢复、丢失响应、账号隔离、取消与租约释放；短边缩放、1 MiB 临界点、透明度、超长图、16-bit PNG 和动图首帧 |
| 浏览器插件送译对照 | Chrome 157 运行插件原版准备函数，与 MuMu Android 12 的 App 对照 24 张合成输入。逐张核对直传字节、上传格式、尺寸、首帧、方向、解码后的颜色与透明度；含透明 AVIF、带配置文件的 WebP、半透明缩图和长边 16383/16384/65500/65501 的边界。Windows Flutter 测试宿主的 AVIF 解码丢失透明通道，不能代替移动端验证 |
| 阅读器真实来源／官方服务 | MuMu 第 10–11／205 页：清掉单页图片缓存后，用页面请求头重新取到同摘要的原图；送译复用同一文件。两页的真实任务分别有译图和无文字结果，切回原图再切译图，页码、显示尺寸和屏幕坐标一致 |
| 本地协议服务 | 切模型恢复原 UUID、已拥有结果复用、额度／限流后的恢复、换模型手动重译；小图字节直传、有损 WebP／JPEG 和旧版 PNG 冷恢复后的上传摘要；父任务格式继承、tiles 协商、损坏结果、独立输出尺寸、过期缓存、跨源下载 |
| 额度升级 | MuMu Android 12 本地夹具：点重试不翻页，系统浏览器打开绑定测试账号的套餐页，返回保留页码，点按钮旁可翻页。后端用 PostgreSQL 和模拟 Stripe／Creem 验证订单归属与续用；尚未在 iOS 或正式支付服务验收 |
| 浏览器夹具 | Chrome 截图按像素比较不同分辨率和宽高比的译图：响应式 `srcset`、`object-fit`／定位、SVG 留白及旋转裁剪的 Canvas，容器改宽与切回原图。另验解码中切换、缓存隔离和释放；Firefox 隔离内容脚本已验 Canvas、data 图片和已撤销 Blob URL 的分块读取 |
| Android 模拟器 | MuMu Debug 的 Gecko 本地章节：常驻栏和专注浮条在同一位置连续切换，横竖屏录屏逐帧核对原／译文字及背景，未见空白或多余切换。另通过机内 HTTP 接收端核对 WebP、长图 JPEG 和缩图的上传大小、尺寸与摘要；模型选择可在重启后回显或恢复默认 |
| 翻译设置与模型目录 | MuMu Android 12 已登录账号读取正式目录：免费模型额度不足时仍可选；点击付费模型 `0.8×` 旁的「升级」，Chromium 打开官网定价页，返回后仍选中原来的 `1×` 模型。阅读器打开／关闭设置后仍在第 14–15 / 42 页，网页设置保留完成计数。未在 iOS 复验 |
| 真实服务 | MuMu Debug 选模后，850×650 合成页从 1,658,768 字节 PNG 转为 8,296 字节 WebP，回执的请求与实际模型一致。切模型、刷新及重开复用同一 UUID；Gecko 当前窗口四张网页图片均收到成功回执，完整译图可读、可切回原图。x86_64 Release 另覆盖 800×20000 tiles、同 UUID 结果重建及 comix.to 已加载图片复用 |
| iOS | 归档接口与系统 property-list 提取已接入，此归档链路尚未通过 Apple 工具链构建或设备运行验收 |

待验收：真实长图低质量 JPEG 的 OCR／嵌字质量、线上故障与权益变更、ARM 真机、iOS 真实取图与送译、完整图片输出及跨源下载的真实服务、大页面归档峰值、特殊格式与平台失败。

待修复：重开 comix.to 页面可能回到顶部；需核对原生坐标、DOM 锚点和异步加载后的恢复时机。原译图原位切换的验证不覆盖重开页面。
