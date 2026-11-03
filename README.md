# NodeLane Comics App

「NodeLane漫译」（其他语言为 NodeLane Comics）是基于 [Mangayomi](https://github.com/kodjodevf/mangayomi) 开发的手机漫画应用，项目仓库为 [Wy2926/node-comics-app](https://github.com/Wy2926/node-comics-app)。当前开发与首版验收以 iOS 为主，Android 测试暂缓。

产品目标是将漫画阅读、网站适配与 NodeLane 翻译结合起来，并提供内置多标签浏览器，在原网页中翻译漫画图片。

当前代码基线为 Mangayomi **v0.9.9**。已接入独立翻译契约、官方渠道回执恢复、阅读器显示切换和手机多标签网页桥。手机默认底栏为书架、更新、来源、浏览器和更多；来源区分 NodeLane 临时目录与第三方，云端目录尚未接入。独立历史页已移除，阅读进度继续保留。手机“更多”页整合账号、订阅额度与设置入口；翻译语言直接弹层选择，译图缓存清理位于存储与备份，阅读器及网页工具栏中的翻译按钮按当前阅读窗口启用。关于页、账号默认标识与应用内名称使用 NodeLane 品牌；移动端交互、真实账号／服务和性能验收边界见架构与界面文档。

## 开发导航

| 入口 | 用途 |
| --- | --- |
| [开发约定](AGENTS.md) | 产品边界、翻译解耦、性能与验证要求 |
| [翻译架构与实现状态](docs/TRANSLATION_ARCHITECTURE.md) | 接入方式、共享渠道、回执恢复、资源预算及尚未通过的验收门槛 |
| [手机界面与视觉令牌](docs/MOBILE_UI_DESIGN.md) | 书架、来源、更新、详情、阅读工具栏、浏览器、更多／设置、翻译账号、平台底栏及迭代清单 |
| [上游基线](UPSTREAM.md) | 来源、固定提交、许可证和摘要 |
| [Mangayomi 原始说明](README.mangayomi.md) | 上游功能、构建说明和致谢 |
| [Flutter 配置](pubspec.yaml) | Dart SDK 与依赖要求 |
| [漫画阅读器](lib/modules/manga/reader) | 阅读交互和页面呈现 |
| [手机浏览器首页](lib/modules/webview/mobile_browser_home.dart) | 地址、已打开标签与常用网站 |
| [手机网页入口](lib/modules/webview/mobile_browser.dart) | 有限保活的多标签与原位翻译；桌面继续使用上游 WebView |
| [翻译契约](lib/services/translation/contracts.dart) | 来源、渠道运行时、结果与释放边界 |
| [章节图片入口](lib/services/get_chapter_pages.dart) | 来源页面清单获取 |
| [CI](.github/workflows/ci.yml) | 上游静态分析、测试和各平台构建流程 |

## 本地运行与检查

需要满足 `pubspec.yaml` 的 Flutter / Dart SDK，以及 Rust 工具链。Android 需对应 Android SDK / Java 环境；iOS 需 macOS / Xcode。原生桥生成与平台准备见上游说明和 CI。

```sh
flutter doctor
flutter pub get
flutter run
```

沿用现有验证入口：

```sh
flutter analyze --no-fatal-infos --no-fatal-warnings
flutter test
flutter build apk --debug
flutter build ios --debug --no-codesign
```

这些是各平台运行入口，不代表已完成本机编译或真机验证；当前按开发约定只推进 iOS 平台验证，Android 命令暂不执行。iOS／Android 显示名已本地化，应用 GitHub、反馈及更新查询统一指向项目仓库。包标识、启动图标、版本号、签名和各平台发行配置仍需在 NodeLane 发布前独立核对；本轮没有发布构建产物。

## 既有 NodeLane 能力

同级 `node-comics` 仓库提供现有浏览器插件和翻译后端。设计时先从其 README 导航，按需核对翻译契约、渠道、网页原位翻译和网站适配文档及代码。该仓库作为参考，不随手机 App 构建隐式引入。

## 许可证

上游代码采用 [Apache License 2.0](LICENSE)，原始版权和第三方许可声明继续保留。复制其他项目代码时，逐项记录其来源、版本和许可证；不能将 `node-comics` 的 GPL-3.0-only 代码默认视为 Apache-2.0 代码。应用内图形标识的来源、版本、摘要及许可单独记录于[品牌素材说明](docs/design/nodelane-brand-assets.md)。
