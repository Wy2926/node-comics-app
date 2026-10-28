# NodeLane Comics App

`nodelane-comics-app` 是基于 [Mangayomi](https://github.com/kodjodevf/mangayomi) 开发的 NodeLane 手机漫画应用，优先支持 Android 和 iOS。

产品目标是将漫画阅读、网站适配与 NodeLane 翻译结合起来，并提供内置多标签浏览器，在原网页中翻译漫画图片。

当前代码基线为 Mangayomi **v0.9.9**。已接入独立翻译契约、官方渠道回执恢复、阅读器显示切换和手机多标签网页桥。设置中的“漫画翻译”用于登录和选择目标语言；阅读器及网页工具栏中的翻译按钮按当前阅读窗口启用。移动端交互、真实账号／服务和性能验收边界见架构文档，应用品牌及发布配置仍沿用上游。

## 开发导航

| 入口 | 用途 |
| --- | --- |
| [开发约定](AGENTS.md) | 产品边界、翻译解耦、性能与验证要求 |
| [翻译架构与实现状态](docs/TRANSLATION_ARCHITECTURE.md) | 接入方式、共享渠道、回执恢复、资源预算及尚未通过的验收门槛 |
| [手机界面与视觉令牌](docs/MOBILE_UI_DESIGN.md) | 书架、浏览与来源、历史与更新、漫画详情、平台底栏及逐页迭代清单 |
| [上游基线](UPSTREAM.md) | 来源、固定提交、许可证和摘要 |
| [Mangayomi 原始说明](README.mangayomi.md) | 上游功能、构建说明和致谢 |
| [Flutter 配置](pubspec.yaml) | Dart SDK 与依赖要求 |
| [漫画阅读器](lib/modules/manga/reader) | 阅读交互和页面呈现 |
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

这些是运行入口，不代表已完成本机编译或真机验证。应用包名、图标、更新地址和发布配置目前仍来自上游，需要在 NodeLane 发布前完成独立配置。

## 既有 NodeLane 能力

同级 `node-comics` 仓库提供现有浏览器插件和翻译后端。设计时先从其 README 导航，按需核对翻译契约、渠道、网页原位翻译和网站适配文档及代码。该仓库作为参考，不随手机 App 构建隐式引入。

## 许可证

上游代码采用 [Apache License 2.0](LICENSE)，原始版权和第三方许可声明继续保留。复制其他项目代码时，逐项记录其来源、版本和许可证；不能将 `node-comics` 的 GPL-3.0-only 代码默认视为 Apache-2.0 代码。
