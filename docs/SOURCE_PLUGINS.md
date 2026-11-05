# 官方来源插件与独立仓库

插件源码位于独立仓库 [nodelane-comics-extensions](https://github.com/Wy2926/nodelane-comics-extensions)。本 App 只通过 HTTP 目录下载产物，不依赖同级路径构建或运行。来源 ID 86001001 继续属于 Comix，86001002 属于 S2READ；来源发现、正文图片、阅读状态与翻译契约各自负责。

## 本地联调

在插件仓库运行 `npm ci`、`npm run check`、`npm run release -- testing`、`npm run serve`。App 默认读取 `http://127.0.0.1:8787/index.json`，兼容原本地测试入口。iOS 模拟器可连接 Mac 回环地址；真实 iPhone 使用开发机局域网地址，并以 `--dart-define=NODELANE_CATALOG_URL=http://开发机IP:8787/index.json` 启动 App。开发服务器必须绑定局域网接口，文件服务根目录仅为插件仓库的 `repo/`。

来源页下拉刷新目录，再点网站按需安装或更新。目录离线时保留缓存和已安装代码。第三方来源、漫画／小说／动画及现有功能继续保留。正式托管尚未部署，远程应使用 HTTPS；本地开发地址不作为用户发行配置。

## 分发与身份

手动创建的本地来源以 `nodelane-comics-<语言>.<名称>`（Dart）或 `nodelane-comics-js-<语言>.<名称>`（JavaScript）生成 ID，不查询或迁移上游前缀。JavaScript 模板只包含实现骨架，元数据由运行时通过 `this.source` 提供，不在代码中重复插入用户填写的名称、地址和备注。第三方目录的来源 ID 和运行时接口沿用各自协议。

沿用 Mangayomi 原 JSON 索引，NodeLane 包增加第 1 版 `nodelane` 元数据，包含永久仓库／插件身份、文件 SHA-256 和字节数、精确请求主机与所需主机能力。`Source.packageInfoJson` 保存所安装代码的对应元数据，旧第三方来源保持空值兼容。

安装前核对来源 ID 所有权、元数据与同源产物地址；下载禁止跳转，流式检查 1 MiB 最大包大小和声明字节数，校验 SHA-256，再初始化 QuickJS，成功后才持久替换旧版本。初始化、网络、摘要或能力失败保留已安装代码和固定状态；目录中一条损坏记录会拒绝整次更新，不静默丢行。目录不兼容项仍参与存在性核对，不因客户端版本旧就标记来源消失。重复安装按来源串行执行，迟到的旧版本不能覆盖新版本。

仓库同名不是授权迁移依据。现有官方包可跟随显式配置的官方地址迁移；最早的本地 Comix 依据固定 ID、站点与原回环目录作一次兼容。来自另一仓库的相同 ID 在写入前整批拒绝。永久来源 ID 不随站点名称、域名或版本改变，书架与章节仍使用现有单来源身份。

章节入库按当前作品内的完整 URL 匹配，不按名称或浮点编号删除不同 URL；例如 `64.2` 与 `64.20`、同名的分段上传可以同时存在。旧新目录都只有一条候选、名称一致且旧 URL 不在新目录时，才沿用既有记录处理地址更换并保留进度。顺序阅读仅合并明确标注不同汉化组且每组只有一条的替代版本；未知组或同组同号的多条记录保留。已有作品刷新详情目录后才会同步缺失的记录和最新元数据。

上传日期使用插件返回的毫秒字符串；缺失时留空，不把发现时间写成上传时间。刷新已有章节会补正日期，保留记录 ID、阅读位置与书签；有效日期覆盖旧值，明确空字符串／零表示未知，省略或无效值保留已有日期。纯日期修正不产生新章节通知。

SHA-256 检查内容一致性，当前尚无签名索引／固定验证公钥。正式分发前需要补齐发布者认证与密钥轮换，不能把摘要描述为签名。插件仓库维护不可变版本产物、独立测试／稳定索引，以及“更高版本发布旧实现”的恢复入口；客户端不自动降版。

## 主机能力与开销

`NodeLane.capabilities` 在 QuickJS 中只读提供，`requires` 声明不支持的包不会安装。NodeLane 插件的 `Client` 在 App 请求桥校验精确 HTTPS 主机、每次重定向、1 MiB 请求体、4 MiB 文本响应、30 秒超时和最多 4 次跳转；使用证书验证开启的 Dart HTTP 通道。该边界覆盖此 Client，不宣称上游所有可执行扩展能力已经形成完整恶意代码沙箱。

CF 继续走现有 MClient／设备 WebView，Cookie 和 UA 留设备端。Comix 的 `captcha_required` 单独提示在源站处理；不把所有 403 当作 CF，不自动解题。日志隐藏请求凭据和查询值。

`PageUrl.imageProcessing` 是可选声明式图片操作。`image.tile-shuffle.v1` 接收算法 3 及插件提供的种子掩码，公共图片层根据响应头恢复图块；不含站点判断，不传整章图片到 JS，也不把源站细节加入翻译层。未知协议失败。页面序列保留重复 URL，防止页槽和进度偏移；章节缓存序列化处理参数。

还原限制为每张 12 MiB、800 万像素、256 块和单帧。阅读器后台同时处理一张，最多排队 4 项；下载沿用有限 worker，并在各 worker 内同步处理。缓存键包含处理参数，还原成功才写入缓存或离线 PNG。翻译和图片操作通过相同缓存取得还原后的原图。每个任务会增加解码和输出缓冲，两个 RGBA 缓冲在像素上限约 64 MB，不含编码器及其他阅读缓存；耗时、总内存与耗电未做真机测量。直接在 JS 传 Base64 或复制浏览器运行时会增加桥接／生命周期成本；本实现复用现有图片入口。

## 代码与验证入口

- `lib/services/source_package.dart`：包校验、下载边界与来源归属。
- `lib/eval/javascript/http.dart`：声明主机和文本请求预算。
- `lib/services/source_images/tile_shuffle.dart`：独立通用图块还原，阅读缓存与下载共同使用。
- `test/services/source_package_test.dart`、`nodelane_catalog_test.dart`、`source_image_processing_test.dart`：失败恢复、隔离、重复操作、像素和缓存边界。
- `test/modules/manga/detail/chapter_catalog_identity_test.dart`、`test/modules/manga/reader/min_subsampling_headers_test.dart`：目录入库／顺序阅读的章节身份、重复刷新与进度保留，以及阅读器初始化时安全读取图片请求头。
- `tool/source_plugin_contract_test.dart`：由所选插件仓库的 `npm run test:app -- /App路径` 显式调用；App 普通 CI 不读取相邻仓库。

来源图块协议参考 `node-comics` 提交 `af3df6ee75276ba1970ba0a7dc22488d54712e18` 的 `images.ts`（SHA-256 `3a7eedd0c9a8fbf1a14e67f89285d71f71dfc2e40d60fa3ce67e66ce0ad92113`），App 通用 Dart 置换独立实现，未复制该 GPL TypeScript 文件；具体种子掩码留在 GPL 插件。使用既有 `image` 4.10.1 依赖，不引入模型或字体。独立插件仓库保留其 GPL-3.0-only 许可和移植来源，App 上游 Apache-2.0 声明不改标。

合成样本、QuickJS、真实 HTTP、iOS 模拟器和真机分别记录。S2READ 已在 iOS 27 模拟器验证安装／更新、搜索、完整目录、真实正文首尾页、下一章与后台返回保持位置；图块还原另以合成图片验证真实 HTTP 到阅读器图片入口、像素结果与失败重试。Comix 在设备现有会话中已加载热门与完整章节目录，但章节接口仍要求站点验证码，不能视为真实图片或 CF 已验收。真机与性能尚未验收；Android 按当前开发约定暂缓，没有据此修改 Android 发布配置。
