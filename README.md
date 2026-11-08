# NodeLane Comics App

「NodeLane漫译」（其他语言为 NodeLane Comics）是基于 [Mangayomi](https://github.com/kodjodevf/mangayomi) 开发的手机漫画应用，首版面向 iOS 和 Android，项目仓库为 [Wy2926/node-comics-app](https://github.com/Wy2926/node-comics-app)。

产品目标是将漫画阅读、网站适配与 NodeLane 翻译结合起来，并提供内置多标签浏览器，在原网页中翻译漫画图片。

NodeLane 应用版本为 **0.1.0**（构建号 **1**），[上游基线](UPSTREAM.md)为 Mangayomi **v0.9.9**。应用提供书架、阅读器、来源、多标签浏览器和翻译账号入口。官方插件包含 Comix、S2READ 与瓜子漫画，目录地址为 `https://comics-extensions.nodelane.net/stable/index.json`。

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

macOS 本地 DMG 与发行流水线使用同一打包入口，产物位于 `build/macos/dmg/`：

```sh
flutter build macos --release
python3 -B tool/package_macos_dmg.py
```

源码与安装包共用本仓库。发行入口为 Actions → **Build & Release**：填写已有的 `v<应用版本>` 标签并选择平台，默认 `macos`；推送标签本身不触发全平台发布。发布成功后会自动生成更新清单 Actions 产物，需要手动上传到 `https://comics-updates.nodelane.net/stable/index.json`；安装包下载地址仍指向 GitHub。生成和上传方式见[应用更新说明](docs/APP_UPDATES.md)。

## 许可证

上游代码采用 [Apache License 2.0](LICENSE)，原始版权和第三方许可声明继续保留。应用内图形标识的来源与许可见[品牌素材说明](docs/design/nodelane-brand-assets.md)。
