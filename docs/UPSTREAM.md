# 上游来源与构建

## 固定基线

| 项目 | 值 |
| --- | --- |
| 官方仓库 | [kodjodevf/mangayomi](https://github.com/kodjodevf/mangayomi) |
| 标签 | [v0.9.7](https://github.com/kodjodevf/mangayomi/releases/tag/v0.9.7) |
| 完整提交 | `08843f58f90efac49197b3cdf97deae36c0397df` |
| 上游应用版本 | `0.9.7+125` |
| 自有仓库 | `origin`，[Wy2926/node-comics-app](https://github.com/Wy2926/node-comics-app)，默认分支 `main` |
| 本地分支 | `nodelane/main`，跟踪 `origin/main` |
| 上游远程 | `upstream`，`https://github.com/kodjodevf/mangayomi.git` |
| 主代码许可 | [Apache-2.0](../LICENSE) |
| 当前检出 LICENSE SHA-256 | `2f28b7257ec775a1eb17c170588c1bc411f2c809096ee8daddbc3c0426ff5908` |

Git 历史和上游标签完整保留。NodeLane 账号与平台配置在此基线上改造，Dart 与 Rust 锁文件保持原解析版本。[原始 README](../README.upstream.md)按原字节保存。以后更新上游先检查差异、锁文件、图源和阅读器回归，再显式合入；不要直接把本工程切换到上游 main。

## 工具链

| 组件 | 真实配置与准备事项 |
| --- | --- |
| Flutter / Dart | [pubspec.yaml](../pubspec.yaml)要求 Dart `^3.13.4`；本机隔离 SDK 为 Flutter `3.47.6` / Dart `3.13.5`，官方 tag 提交 `5fc346839b5d0eef006ed8404392afb4dfae428d`。上游 CI 仍只指定 stable，尚需单独固定。 |
| Rust | 本机 Rust `1.95.0`，已安装 `x86_64-linux-android` 与 debug 构建附带的 `i686-linux-android` target。[Cargo.toml](../rust/Cargo.toml)使用 `flutter_rust_bridge =2.13.0`；保留 [Cargo.lock](../rust/Cargo.lock)。 |
| Android | [Gradle 配置](../android/app/build.gradle)使用 Java 17 字节码、compile SDK 36，Gradle `9.3.1` / AGP `9.1.0`。本机构建 JVM 为 Android Studio JBR `21.0.8`；Flutter 默认 NDK `28.2.13676358`、最低 API 24。模拟器为 API 36.1、x86_64；其他 ABI 与真机分别验收。 |
| iOS | [Podfile](../ios/Podfile)最低 iOS 15.0；需要 macOS、Xcode、CocoaPods 和相应 Rust iOS target。真机与发行还需自有签名配置。 |
| 依赖 | 保留 [pubspec.lock](../pubspec.lock)。pubspec 中多项 Git 依赖引用 main/master，锁文件记录已解析提交；初始化不运行 `flutter pub upgrade`。 |

Windows 本机使用 `D:\Tools\flutter-3.47.6`，保留原 `D:\flutter` 安装。`flutter doctor -v` 全部通过，`flutter pub get --enforce-lockfile` 已完成且未升级依赖。构建与运行验收状态见 README，不将 doctor 或依赖解析视为 APK 构建证据。

本机全局 `~/.gradle/init.gradle` 镜像脚本与 Flutter Gradle 插件的仓库规则冲突，因此[启动脚本](../scripts/android.ps1)为当前进程设置独立 `GRADLE_USER_HOME`（默认 `D:\Tools\gradle-nodelane-native`），保留全局配置。本机独立目录内的 `init.gradle` 仅将已有 Google、Maven Central 与 Gradle Plugin Portal 仓库 URL 改到阿里云对应镜像，不新增仓库；用于修复本机 Java 下载依赖时的 TLS 断连。其他机器按实际网络配置。Gradle `9.3.1` 的 Kotlin DSL 在符号链接路径存在兼容问题，SDK 与 Gradle 目录使用实体路径。

工程在 `D:`、Pub 缓存在 `C:` 时，Kotlin 增量缓存会报路径根目录不同。本机独立 Gradle 目录的 `gradle.properties` 关闭 Kotlin 增量编译并改为进程内编译，避免影响其他项目；构建 worker 限为 8。此配置仅影响本机构建，未改变 App 运行性能。

## 首次运行与代码生成

在工程根目录使用本机脚本准备、诊断、构建和运行 Android debug：

```powershell
.\scripts\android.ps1 prepare
.\scripts\android.ps1 doctor
.\scripts\android.ps1 build
.\scripts\android.ps1 run -ShowEmulator
```

脚本默认 Flutter、Android Studio 和模拟器路径与本机安装一致，可通过 `-FlutterRoot`、`-AndroidStudioRoot`、`-AndroidSdkRoot`、`-GradleUserHome`、`-Avd`、`-Device` 覆盖。`build` 面向 x86_64 模拟器；`run` 在设备离线时启动已有 AVD，并默认显示模拟器窗口（可用 `-ShowEmulator:$false` 隐藏启动）。App 默认使用已登记的公开 NodeLane native client ID；其他环境可传 `-ClientId '<Logto native client ID>'`，仅作为 `NODELANE_CLIENT_ID` 编译参数覆盖，也可通过当前进程同名环境变量提供。不得传入 client secret 或用户令牌。实际回调为 `net.nodelane.comics://oauth/callback`，详见[账号规范](NODELANE_INTEGRATION.md)。

随后在 Mac 完成 iOS debug 基线。首次依赖解析若改动锁文件，先检查原因，不把工具链不符造成的依赖降级作为修复。

生成文件已有上游版本。修改 Riverpod / Isar 模型或注解后使用已有 build_runner：

```powershell
dart run build_runner build --delete-conflicting-outputs
```

修改 Rust API 后，使用与 [Rust 依赖](../rust/Cargo.toml)一致的 FRB CLI 版本，按 [flutter_rust_bridge.yaml](../flutter_rust_bridge.yaml)生成绑定：

```powershell
cargo install flutter_rust_bridge_codegen --version 2.13.0 --locked
flutter_rust_bridge_codegen generate
```

生成前后检查 diff，避免无关的全量生成或自动升级。具体平台编译步骤以 [上游 release 工作流](../.github/workflows/release.yml)和 Flutter / Rust 实际诊断为准。

## 双端发布条件

上游 release 提供 Android APK 和 iOS IPA。[工作流](../.github/workflows/release.yml)的 iOS 路径是 Mac 上构建未签名应用，再使用 P12、profile 和 zsign 打包；[原始 README](../README.upstream.md)提供侧载入口。该证据不表示本项目已构建、已签名、已通过 TestFlight 或 App Store。

第一阶段更换自有应用 ID、名称、图标、登录回调、升级地址与数据命名，并调整自有 CI。发布前准备自己的 Android keystore、Apple 签名与分发配置；不沿用上游发布密钥或把上游更新当成 NodeLane 更新。

iOS 目标仍是完整原生 App。App Store 分发作为独立验收项：届时结合实际扩展执行方式、内容与付费入口检查 [Apple 官方审核规则](https://developer.apple.com/app-store/review/guidelines/)。不能用“能生成 IPA”估算审核结果或审核时间。

## 扩展与第三方来源

[扩展分发](../lib/eval/lib.dart)已包含 JS、Dart、Mihon、LNReader 和 Aidoku。JS 由本机 QuickJS 执行，Dart 由 D4rt 解释；不是把图源代码送到 NodeLane 后端执行。上游也包含 Mihon 服务与 `m_extension_server` 依赖，首版仍只按 JS 漫画图源建立双端兼容清单，其他格式逐项验收。

保留原作者 `Copyright 2023 Moustapha Kodjo Amadou`、LICENSE 与已有版权声明。字体、原生运行库、Git 插件、图源代码各有许可；发布包需汇总实际包含的依赖与许可。本次没有完成全量依赖许可审计。

Node Comics 的 TS 图片处理模块作为协议语义参考；Flutter 实现需符合相同契约。若直接移植其 GPL-3.0-only 代码，先确定本项目的许可处理，不能仅凭 Mangayomi 根 LICENSE 认定所有新增代码适用 Apache-2.0。
