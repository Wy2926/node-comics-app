# NodeLane Comics App

「NodeLane漫译」（其他语言为 NodeLane Comics）是基于 [Mangayomi](https://github.com/kodjodevf/mangayomi) 开发的手机漫画应用，项目仓库为 [Wy2926/node-comics-app](https://github.com/Wy2926/node-comics-app)。当前开发与首版验收以 iOS 为主，各平台验证范围见下方专题文档。

产品目标是将漫画阅读、网站适配与 NodeLane 翻译结合起来，并提供内置多标签浏览器，在原网页中翻译漫画图片。

NodeLane 应用版本为 **0.1.0**（构建号 **1**），上游代码基线为 Mangayomi **v0.9.9**。应用提供书架、阅读器、来源、多标签浏览器和翻译账号入口；已接入独立翻译契约与官方渠道恢复。官方插件由独立仓库维护，本地测试来源为 Comix 与 S2READ，正式目录尚未部署。当前能力和验收边界见下方专题文档。

## 开发导航

| 入口 | 用途 |
| --- | --- |
| [开发约定](AGENTS.md) | 产品边界、翻译解耦、性能与验证要求 |
| [翻译架构与实现状态](docs/TRANSLATION_ARCHITECTURE.md) | 接入方式、共享渠道、回执恢复、资源预算及尚未通过的验收门槛 |
| [手机界面与视觉令牌](docs/MOBILE_UI_DESIGN.md) | 书架、来源、更新、详情、阅读工具栏、浏览器、更多／设置、翻译账号、平台底栏及验证边界 |
| [上游基线](UPSTREAM.md) | 来源、固定提交、许可证和摘要 |
| [Mangayomi 原始说明](README.mangayomi.md) | 上游功能、构建说明和致谢 |
| [Flutter 配置](pubspec.yaml) | Dart SDK 与依赖要求 |
| [漫画阅读器](lib/modules/manga/reader) | 阅读交互和页面呈现 |
| [手机浏览器首页](lib/modules/webview/mobile_browser_home.dart) | 地址、已打开标签与常用网站 |
| [手机网页入口](lib/modules/webview/mobile_browser.dart) | 有限保活的多标签与原位翻译；桌面继续使用上游 WebView |
| [翻译契约](lib/services/translation/contracts.dart) | 来源、渠道运行时、结果与释放边界 |
| [章节图片入口](lib/services/get_chapter_pages.dart) | 来源页面清单获取 |
| [独立插件仓库与主机契约](docs/SOURCE_PLUGINS.md) | 本地联调、目录与包校验、CF、图片还原及验证入口 |
| [CI](.github/workflows/ci.yml)／[发行构建](.github/workflows/release.yml) | 静态分析、测试、各平台构建与 NodeLane 产物上传 |
| [iOS 侧载订阅配置](repo/config.json) | NodeLane 订阅元数据；生成规则与发行前置条件见[应用更新](docs/MOBILE_UI_DESIGN.md#关于与应用更新) |

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

这些是各平台运行入口，实际验证范围按任务授权执行，不代表完整功能验收。应用 GitHub、反馈及更新查询统一指向项目仓库；各平台身份、图标、安装验证及发行待办见[手机界面与视觉令牌](docs/MOBILE_UI_DESIGN.md#关于与应用更新)。iOS Release IPA 已通过个人签名真机安装及启动，正式发行、覆盖更新与部署尚未验收。

macOS 本地 DMG 与发行流水线使用同一打包入口，产物位于 `build/macos/dmg/`：

```sh
flutter build macos --release
python3 -B tool/package_macos_dmg.py
```

源码与安装包共用本仓库。发行入口为 Actions → **Build & Release**：填写已有的 `v<应用版本>` 标签并选择平台，默认 `macos`；推送标签本身不再触发全平台发布。详细规则及公开下载、iOS 签名的验收边界见[应用更新](docs/MOBILE_UI_DESIGN.md#关于与应用更新)。

## 既有 NodeLane 能力

同级 `node-comics` 仓库提供现有浏览器插件和翻译后端。设计时先从其 README 导航，按需核对翻译契约、渠道、网页原位翻译和网站适配文档及代码。该仓库作为参考，不随手机 App 构建隐式引入。

## 许可证

上游代码采用 [Apache License 2.0](LICENSE)，原始版权和第三方许可声明继续保留。复制其他项目代码时，逐项记录其来源、版本和许可证；不能将 `node-comics` 的 GPL-3.0-only 代码默认视为 Apache-2.0 代码。应用内图形标识的来源、版本、摘要及许可单独记录于[品牌素材说明](docs/design/nodelane-brand-assets.md)。
