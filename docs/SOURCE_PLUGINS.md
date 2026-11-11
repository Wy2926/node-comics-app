# 来源插件与宿主

来源位于独立的 [nodelane-comics-extensions](https://github.com/Wy2926/nodelane-comics-extensions)，App 通过 HTTP 目录下载产物，两仓库没有构建或运行时目录依赖。新增／修复网站使用插件仓库的 [nodelane-source-adapter 技能](https://github.com/Wy2926/nodelane-comics-extensions/blob/main/.agents/skills/nodelane-source-adapter/SKILL.md)。站点协议留在插件，App 负责通用运行、书架、阅读进度、下载与翻译。

## 本地联调

在插件仓库按[维护说明](https://github.com/Wy2926/nodelane-comics-extensions/blob/main/docs/MAINTENANCE.md)构建并启动服务。App 默认目录为 `https://comics-extensions.nodelane.net/stable/index.json`，可通过 `--dart-define=NODELANE_CATALOG_URL=http://127.0.0.1:8787/index.json` 切换。iOS 模拟器可使用 Mac 回环地址；真机使用开发机局域网 IP，插件服务器需绑定局域网接口。

插件仓库的 `npm run test:app -- --app /明确的App绝对路径` 显式运行 QuickJS 契约检查；App 普通 CI 不读取相邻仓库。APK 通过 Mihon 桥单独验证，不能用 QuickJS 测试代替。

## 目录与安装

官方目录自动安装全部兼容的缺失插件并更新已有插件，不受第三方自动更新开关、语言或成人内容显示偏好控制；第三方只按已有开关更新已安装项。目录先整批保存并展示，安装共用串行队列，同仓库／来源／版本／摘要合并请求。点击缺失项优先处理，已安装项立即打开当前版本；更新不强制重载正在阅读的来源。

成功同步后 12 小时、失败后 15 分钟内不自动重试，手动刷新可绕过；记录按目录地址隔离。后台／锁定后停止启动新自动安装，当前项可完成，恢复时补查缺失项；暂停和进程中断不记失败。单项失败保留旧版本，不阻塞其他来源；写入时保留用户在安装期间修改的固定、显示和最近使用状态。

包安装检查仓库／来源身份、同源下载地址、兼容性、文件大小和 SHA-256；下载禁止跳转，上限 1 MiB，初始化成功才替换。旧版本不能覆盖新版本，同版本改摘要会拒绝；目录损坏整批失败，版本不兼容不等于来源已删除。下载有 25 秒上限；JS 初始化经工作线程执行，QuickJS 单次执行限 5 秒、线程响应限 40 秒，超时线程重建。安装和阅读的连接／超时分开管理。

永久来源 ID、仓库身份和 slug 不随改名、域名或版本变化；另一仓库相同 ID 拒绝写入。目录格式和能力声明见插件仓库的 [CONTRACT.md](https://github.com/Wy2926/nodelane-comics-extensions/blob/main/docs/CONTRACT.md)，本文件不重复字段表。

### 来源卡片资料

`catalogMetadata` 与顶层 `isNsfw` 只驱动展示，不改变安装和阅读权限。[字段定义](https://github.com/Wy2926/nodelane-comics-extensions/blob/main/docs/CONTRACT.md#来源卡片资料)由插件仓库维护。缺失资料保持未标注，不推断免费；资料随来源备份，可独立于插件版本刷新，迟到的旧记录不能覆盖新资料或用户状态。

## 运行边界

- **原版 APK**：沿用 `m_extension_server` 与 Mihon 桥。上游 64 位 ID 以字符串保存在 `additionalParams.mihonSourceId`，安装与调用使用相同身份，本地数据库 ID 不变。作品／章节网址由原扩展解析，Android 图片沿用其拦截器及本地代理。更换运行类型不保证旧 URL 可用，不自动增加站点映射或删除书籍。
- **JavaScript**：QuickJS 实例化 `DefaultExtension extends MProvider`，通过 `this.source` 取得元数据；不提供 Node 或完整浏览器环境。`Client` 按声明的精确 HTTPS 主机校验请求和重定向，现有预算见契约。释放运行时清理 JS 引用和定时器，宿主 HTTP／提取器／WebView 桥在调用者 Zone 中运行，不能误关阅读共享连接。
- **网页验证**：复用现有设备 WebView；Cookie、UA 留设备。隐藏页面与可见浏览器的会话共享须实测，不把所有 403 当作 Cloudflare，也不承诺自动解题。日志隐藏凭据和查询值。
- **图片处理**：`PageUrl.imageProcessing` 声明通用操作，具体参数留插件。当前 `image.tile-shuffle.v1` 由公共图片层还原，阅读、下载、翻译共用结果；缓存键包含处理参数，成功才缓存。既有实现每张限 12 MiB、800 万像素、256 块、单帧，后台串行处理且最多排队 4 项。这是当前图块处理边界，不是普通图片准入规则，也不授权新增限制。

章节按作品内完整 URL 匹配，不能因同名／同编号删除不同 URL；页面保留重复 URL 的页槽。上传日期按插件毫秒字符串处理，未知不改成抓取时间，刷新保留阅读位置与书签。具体数据语义见契约，App 不解析站点目录规则。

## 代码与验证入口

| 职责 | 实现与回归 |
| --- | --- |
| 目录、包与安装 | `lib/services/source_package.dart`、`lib/services/fetch_sources_list.dart`；`test/services/source_package_test.dart`、`test/services/nodelane_catalog_test.dart` |
| 原生来源身份与失败恢复 | `lib/eval/mihon/source_identity.dart`、`lib/eval/mihon/service.dart`；`test/eval/mihon/` |
| JS 请求与资源释放 | `lib/eval/javascript/http.dart`、`source_runtime.dart`；`test/eval/js_http_test.dart`、`js_http_lifecycle_test.dart` |
| 图片还原与缓存 | `lib/services/source_images/tile_shuffle.dart`；`test/services/source_image_processing_test.dart` |
| 章节身份与进度 | `test/modules/manga/detail/chapter_catalog_identity_test.dart` |
| 跨仓库 JS 契约 | `tool/source_plugin_contract_test.dart`，由插件仓库显式传入构建产物与样本 |

静态检查、合成样本、真实 HTTP、QuickJS、Android／iOS 模拟器与真机分开报告。包安装、目录或图片清单成功不等于正文阅读通过。各来源当前验证范围只维护在插件仓库 `src/<slug>/README.md`，此处不复制易过期的版本和站点验收记录。APK 的 iOS、ARM 真机与 Windows JVM 转换兼容性仍需分别验收；移动端性能、内存和耗电未完成真机测量。

App 保留 Apache-2.0 上游声明；原版 APK 与 GPL-3.0-only 插件分别保留许可。图块算法由 App 独立实现，未复制浏览器项目的 GPL TypeScript；具体协议参数留在 GPL 插件。来源记录见 [THIRD_PARTY.md](../THIRD_PARTY.md)及[插件第三方声明](https://github.com/Wy2926/nodelane-comics-extensions/blob/main/THIRD_PARTY.md)。
