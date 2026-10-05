# NodeLane Comics App

面向 Android 与 iOS 的漫画阅读和翻译应用，基于 Flutter / Mangayomi 开发。使用 NodeLane 账号与现有翻译服务，图源扩展在设备上运行，书架、阅读进度和译图缓存由 App 本机维护。

**当前状态：NodeLane 账号、官方常规翻译和阅读器接入已实现，Android 模拟器已通过线上账号翻译联调。** 支持单页／有限窗口自动翻译、原译切换、持久恢复、完整译图缓存；MTU 尚未实现，Android / iOS 真机尚未验收。应用身份为 `net.nodelane.comics`，显示名称为 NodeLane Comics；图标、升级地址和发布工作流仍沿用上游，发行前需完成自有配置。

## 已确定范围

- Android 与 iOS 共同设计、分别验收，优先保证两端阅读体验。
- 复用现有漫画图源、下载缓存、分页与连续阅读器，首版验收 JS 图源扩展；其他格式按双端实测纳入。
- NodeLane 账号、官方常规翻译、原图／译图切换、持久任务恢复，以及自选 manga-translator-ui 渠道。
- 界面围绕书架、图源、任务和账号改造；一本漫画绑定一个来源。

## 文档导航

| 文档 | 内容 |
| --- | --- |
| [NodeLane 对接](docs/NODELANE_INTEGRATION.md) | 翻译架构与持久模型、移动端账号、任务恢复、阅读器接入点、阶段与验收 |
| [上游与构建](docs/UPSTREAM.md) | 固定版本、许可、工具链、首次构建与发布条件 |
| [上游原始说明](README.upstream.md) | Mangayomi v0.9.7 README 原文 |
| [开发约定](AGENTS.md) | 项目范围、性能与验证要求 |

## 开发准备

上游固定为 [Mangayomi v0.9.7](https://github.com/kodjodevf/mangayomi/releases/tag/v0.9.7)，提交 `08843f58f90efac49197b3cdf97deae36c0397df`。自有仓库为 [Wy2926/node-comics-app](https://github.com/Wy2926/node-comics-app)，远程名为 `origin`，默认分支为 `main`；本地开发分支 `nodelane/main` 跟踪 `origin/main`，远程 `upstream` 指向官方仓库。

本机使用隔离的 Flutter `3.47.6` / Dart `3.13.5`（`D:\Tools\flutter-3.47.6`），满足 [pubspec.yaml](pubspec.yaml) 的 Dart `^3.13.4`；Android SDK、Studio JDK、Rust 和 API 36.1 模拟器已就绪。原全局 Flutter 安装保留，详见[构建条件](docs/UPSTREAM.md)。iOS 构建仍需要 Mac、Xcode 和 CocoaPods。

在本工程目录使用[Android 开发脚本](scripts/android.ps1)。脚本为当前进程配置工具路径与独立 Gradle 缓存，不修改全局环境：

```powershell
.\scripts\android.ps1 -Action doctor
.\scripts\android.ps1 -Action prepare
.\scripts\android.ps1 -Action build
.\scripts\android.ps1 -Action run -ShowEmulator

# 需要覆盖默认移动端应用时：
.\scripts\android.ps1 -Action run -ShowEmulator -ClientId '<native-client-id>'
```

账号入口为“更多 → NodeLane 账号”，支持系统浏览器 PKCE 登录、安全保存凭据、会员／常规翻译额度刷新、退出和切换账号。默认包含已登记的公开 native client ID，移动回调为 `net.nodelane.comics://oauth/callback`；显式清空 client ID 的开发构建会禁用登录。服务端公开的浏览器 client ID 不用于 App。配置和验收边界见[账号对接](docs/NODELANE_INTEGRATION.md#3-nodelane-账号)。

默认主题沿用插件的浅／深蓝语义色、2px 漫画描边、不对称圆角和硬阴影。账号页显示通行证标题、用户名／会员徽章与额度卡片；现有字体、缩放和主题选择继续使用上游设置。

阅读时长按图片可选目标语言、翻译此页、切换原译图或开启自动翻译（当前原页＋后续最多 3 页）。账号页的“翻译任务”可继续同步已有任务。失败恢复沿用原 UUID；“重试翻译／重新翻译”是明确的新尝试。协议、缓存预算与格式边界见[NodeLane 对接](docs/NODELANE_INTEGRATION.md)。

初始化已用 `flutter pub get --enforce-lockfile` 保留上游依赖版本。静态检查与账号测试使用隔离 SDK：

```powershell
& 'D:\Tools\flutter-3.47.6\bin\flutter.bat' analyze --no-pub
& 'D:\Tools\flutter-3.47.6\bin\flutter.bat' test --no-pub --concurrency=2 test/modules/nodelane test/modules/manga/reader test/settings/pure_black_test.dart test/providers/storage_provider_linux_test.dart
```

修改模型或 Rust 接口时按[生成规则](docs/UPSTREAM.md)处理。

账号／翻译／阅读器回归覆盖 token 轮换、会话隔离、同 UUID 恢复、交付失败、取消、窗口和窄屏 UI；Rust 测试覆盖输入冻结、alpha 合成和非法分块包。Android 模拟器已通过线上完整译图落盘和重复操作复用、阅读器切换检查。性能测量与双端未验收项见[验证边界](docs/NODELANE_INTEGRATION.md#7-当前验证与后续范围)。

设备集成测试必须使用 `--no-uninstall`，否则 Flutter 默认会卸载 App 并清理本机数据。先按 Android 脚本配置 JDK／SDK／Gradle 环境，再执行：

```powershell
# 不调用翻译服务：图片准备基准、宽页和阅读位置检查
flutter test integration_test/nodelane_reader_test.dart -d emulator-5554 --no-pub --no-uninstall

# 需明确授权、App 已登录；生成测试图片并调用线上常规翻译
flutter test integration_test/nodelane_translation_live_test.dart -d emulator-5554 --no-pub --no-uninstall --dart-define=NODELANE_LIVE_TEST=true

# 测试后恢复正常入口，保留设备数据
.\scripts\android.ps1 -Action run
```

服务端与浏览器工程为 [Wy2926/node-comics](https://github.com/Wy2926/node-comics)，本机位于同级 `../node-comics`。本工程文档直接链接其权威契约；开发 App 不要求迁移现有后端或修改插件协议。

## 来源与许可

本工程保留 Mangayomi 源码及 [Apache-2.0 LICENSE](LICENSE)；上游 README 原文保存在 [README.upstream.md](README.upstream.md)。第三方字体、原生库和扩展分别保留自身许可，详见[上游来源](docs/UPSTREAM.md)。
