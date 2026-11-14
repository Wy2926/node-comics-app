# 发行与应用更新

客户端默认从 `https://comics-updates.nodelane.net/stable/index.json` 读取静态清单，不需要 GitHub 凭据，也不直接查询 GitHub Releases API。安装包和发布页可以使用任意 HTTP／HTTPS 地址，包括自建服务器、CDN、端口、查询参数和片段。清单入口可通过 `NODELANE_UPDATE_MANIFEST_URL` 构建参数替换。

## 平台身份与构建

版本与构建号只以 `pubspec.yaml` 为准，关于页显示实际安装包信息。NodeLane 使用独立应用身份，不覆盖上游 Mangayomi 或迁移其私有数据；后续覆盖安装须保持包标识与兼容签名。

| 平台 | 身份与打包入口 |
| --- | --- |
| iOS | `com.nodelane.comics`，最低 iOS 15；Flutter 构建与既有 IPA 流程，测试目标为 `com.nodelane.comics.RunnerTests` |
| Android／TV | applicationId、namespace 为 `com.nodelane.comics`；APK 按 ABI 分发，TV 使用独立文件名。FileProvider 为 `${applicationId}.fileprovider`，仅共享应用专属 `Download/app-updates/` |
| macOS | `com.nodelane.comics`、`nodelane-comics.app`；`tool/package_macos_dmg.py` 使用 `ditto`、`hdiutil`、Xcode `SetFile`，校验成功才替换 DMG，不自动签名／公证 |
| Windows | 展示名 `nodelane-comics`、发布者 NodeLane，安装器 ID `D80A683F-91A2-4296-BC85-2A903B6E247C` 保持稳定；内部可执行文件仍为 `mangayomi.exe`，使用锁定的 `inno_bundle` |
| Linux | 程序／包名 `nodelane-comics`，桌面标识 `com.nodelane.comics`；`linuxdeploy`、`rpmbuild`、`dpkg-deb` 及现有 CI 分别生成 AppImage／RPM／DEB，安装到 `/opt/nodelane-comics` |
| Arch | `packaging/arch/PKGBUILD.in` 生成 `nodelane-comics-bin` 配方，`pkgver`／`pkgrel` 取应用版本／构建号；解压配方包后在对应目录运行 `makepkg -si`，下载同版 Linux ZIP |

平台图标与许可见[品牌素材](design/nodelane-brand-assets.md)，组合应用的分发条款见[第三方声明](../THIRD_PARTY.md)。包内保留上游基线、许可与素材来源；应用协议配置见[应用链接](MOBILE_UI_DESIGN.md#应用链接)。

macOS Podfile 在解析前准备锁定 media-kit 库，失败即终止；CI 预装 `aarch64-apple-darwin`、`x86_64-apple-darwin` 两个 Rust 目标，再使用锁定 Pods 构建。DMG 包含完整 `.app`、Applications 快捷方式、卷图标及许可文件。Linux 各格式共用桌面文件和图标，Arch 配方使用实际资源摘要。

## 发布入口

`.github/workflows/release.yml` 的 **Build & Release** 由 Actions 手动运行，输入已推送的 `v<应用版本>` 标签和平台，默认 macOS，`all` 构建全部平台。校验标签与正整数构建号后固定到同一提交，只等待所选平台；失败／取消不发布，同标签运行不自动互相取消。

新 Release 先上传草稿，成功后公开；重试可继续草稿，补发平台保留已有说明和资源。产物名为 `nodelane-comics-<tag>-<platform>.<ext>`，Android／TV 在平台后附 ABI；CI 调试产物为 `nodelane-comics-<platform>-debug`。缺少预期文件时失败。执行发布仍需明确授权。

### iOS 侧载订阅

`repo/update_source.py` 按 `repo/config.json` 生成 `repo/source.json`，源 ID 为 `com.nodelane.comics.source`，应用 ID 为 `com.nodelane.comics`。只收录项目公开 Releases 中正式版本及同仓库已上传的 `nodelane-comics-<tag>-ios.ipa`，无 IPA 时 `apps`／`news` 为空。

版本按数值降序、同版本去重；订阅按版本号更新，不区分同版本 build。版本、最低系统和权限须与实际签名 IPA 核对，字段遵循 [AltStore Source 格式](https://faq.altstore.io/developers/make-a-source)。请求或解析失败保留旧源，生成成功才原子替换；工作流先运行 `python3 -B -m unittest discover -s repo -p 'test_*.py'`，iOS 构建和发布成功后更新，也可手动重建。

## Android 发布签名

发布沿用同一份签名，不生成替代密钥。Windows 本地备份放在 `%LOCALAPPDATA%\nodelane\signing\node-comics-app\`，包含 `nodelane-comics-release.p12` 和 `signing.json`；两者都不进入 Git。证书 SHA-256 为 `88e9e506650f50c76cb4ef8bb70ecaf885723d81f12417c6064270e4d5d804bc`。

GitHub Actions 使用仓库 Secrets `SIGNING_KEY_STORE_BASE64`（密钥文件的 Base64）与 `SIGNING_KEY_PROPERTIES`（包含 `storeFile=upload-keystore.jks`、`storeType=PKCS12`、别名和密码的 Java properties）。工作流只向签名步骤传入它们，不把内容写入源码或日志；产物只上传 APK。Secrets 可供获准运行的工作流读取，不替代独立的密钥备份。

发布前核对 APK 的包名、版本、构建号及签名与已发布版本兼容。构建号以实际发布 APK 为准并递增；对外更新说明使用简洁的用户语言，不使用自动生成的提交日志。

## 生成与手动发布

发布后生成 `nodelane-comics-v<版本号>-update-manifest` Actions 产物，清单部署使用以下步骤：

1. 下载并解压该 Actions 产物，得到 `stable/index.json`。
2. 按需修改条目的 `url` 和 `page_url`，将安装包放到对应地址。
3. 上传清单至服务器临时文件，再原子替换为 `stable/index.json`。
4. 若有 CDN，刷新该路径的缓存；在应用“更多 → 关于与帮助 → 检查更新”验证。

服务器应返回 `Content-Type: application/json; charset=utf-8`，建议 `Cache-Control: public, max-age=300` 并支持 ETag/304。404、HTML、无效 JSON 或网络错误会显示检查失败。

也可以本地生成，无需重新构建安装包：

```sh
python3 -B tool/generate_update_manifest.py

# 安装包按 <下载根地址>/<标签>/<文件名> 存放；iOS／桌面直接打开下载地址。
python3 -B tool/generate_update_manifest.py \
  --download-base-url https://downloads.example.com/comics
```

输出默认为 `build/app-updates/stable/index.json`，可通过 `--output` 指定。`--download-base-url` 仅改写清单，不上传或镜像安装包；指定后生成空 `page_url`，需要安装说明页时可自行填写。脚本使用 Python 标准库，可选 `GH_TOKEN` 仅用于请求 GitHub API，不写入产物。请求或生成失败时保留旧输出。

该生成器是现有 GitHub 发行流水线的适配工具：按现有文件名识别平台／架构，读取正式 `vX.Y.Z` 标签下 `pubspec.yaml` 的构建号，跳过草稿、预发布和未上传完成的资源。每个平台／架构独立选择最高版本；桌面同版本多格式优先选择 DMG、EXE、AppImage。下载 URL 使用资源提供的地址或指定的下载根地址，不核对仓库路径、资源大小或摘要。客户端不依赖该生成器，可以直接发布符合下列契约的 JSON。

## 清单契约

根对象包含 `schema: 1` 和 `updates` 数组，无更新时数组为空。条目按平台／架构声明目标，不从 URL 或文件名猜测。

| 字段 | 内容 |
| --- | --- |
| `platform` | 必填。当前目标为 `android`、`android-tv`、`ios`、`macos`、`windows`、`linux`；其他平台条目不影响清单解析 |
| `version` | 必填。数字版本，支持点分段、`v` 前缀及预发布／构建后缀；比较沿用数字部分，不按后缀排序 |
| `url` | 必填。安装包 HTTP／HTTPS 地址 |
| `arch` | 可选。Android 默认 `universal`，具体包填写设备 ABI；其他平台默认 `any`。未知架构不会导致整份清单失败 |
| `build` | 可选，默认 `0`。非负整数；用于识别同版本的后续构建 |
| `notes` | 可选，默认空。原样展示更新说明 |
| `page_url` | 可选。iOS／桌面填写时打开此页面，省略或为空时直接打开 `url` |

最小示例：

```json
{
  "schema": 1,
  "updates": [
    {
      "platform": "android",
      "version": "0.2.0",
      "url": "https://downloads.example.com/comics/app.apk"
    }
  ]
}
```

清单只输出当前契约字段。清单仍需合法 JSON、正确字段类型和可用的 HTTP／HTTPS URL；无效数据会显示检查失败。

## 客户端行为

- 自动检查使用六小时有效期的持久缓存；手动检查跳过时间限制，携带 ETag 重新验证。缓存按完整清单地址隔离，在途请求合并。请求总超时为 20 秒，失败不覆盖成功缓存，也不把旧缓存作为本次成功结果。
- Android 匹配设备支持的 ABI，通用包排在具体 ABI 之后，手机和 TV 分开。选择更高版本，或相同版本且构建号更高的条目；同版本优先较高构建号，再按 ABI 顺序选择。更高版本不再要求构建号同时递增。
- Android 使用系统 `DownloadManager`。下载成功且本地文件存在、非空即可调用系统安装器；应用不检查摘要、APK 包名、包内版本／构建号或声明大小。能否安装、签名与降级限制由系统决定。
- 同时维护一个下载任务，重复请求复用；替换任务前需取消旧任务，取消和安装按任务身份匹配。任务可在离页、后台和进程重建后恢复；创建任务时记录应用安装时间，查询时清理不属于当前安装的任务。
- 安装权限通过 Android 系统设置授予，返回后再次点击安装。拒绝权限、取消安装或安装器启动失败保留下载文件；不会仅因打开安装器就标记更新成功。
- iOS 和桌面通过系统浏览器打开清单指定的页面或下载地址，不提供内置安装器。

## 本地验证

```sh
python3 -B -m unittest discover -s tool -p 'test_*.py'
flutter test test/services/check_for_update_test.dart test/modules/more/software_update_test.dart test/utils/version_test.dart
flutter analyze --no-fatal-infos --no-fatal-warnings
flutter build apk --debug
```

生成器和 Dart 客户端共用 `test/fixtures/app_update_manifest.json` 验证契约。服务和页面测试覆盖自建地址、精简清单、同版本构建更新、失败重试、任务恢复与页面位置保持，使用模拟网络／平台服务；静态检查和 Android 编译不能代替 iOS／Android 真机、实际下载服务器和系统覆盖安装验收。

本地静态服务可通过构建参数切换清单入口：

```sh
flutter run -d <设备ID> --print-dtd --dart-define=NODELANE_UPDATE_MANIFEST_URL=http://<开发机可达地址>:8787/stable/index.json
```

替换命令中的占位值。本地 Android 使用 MuMu，通过 MuMuManager 查询实际 ADB 地址，再确认设备到开发服务的连通性，不假定其他模拟器的宿主机地址。SDK 与缓存要求见 [AGENTS](../AGENTS.md)。覆盖安装保留原应用数据，不通过卸载绕过签名或版本不兼容。

## 验证边界

| 平台／范围 | 已有证据 | 仍需验收 |
| --- | --- | --- |
| Android 更新 | API 36 arm64 模拟器使用本地 HTTP、同签名 Debug 包覆盖后台下载、进程恢复、重复任务、503／404、取消、权限拒绝、安装取消及覆盖安装保留数据 | 真实发行服务器的完整更新链路、ARM 真机、其他 API／ABI 与 TV |
| Android Release | x86_64 模拟器使用正式签名包完成真实翻译，范围见[翻译验证](TRANSLATION_ARCHITECTURE.md#验证与待办) | 不据此推断其他平台或全部发行功能通过 |
| iOS | 指定 arm64 模拟器构建与更新入口；无签名 Release 打包，个人 Apple ID 重签后在 iPhone 安装和首次启动 | 正式团队／CI 签名、续签、版本间覆盖更新、侧载订阅客户端与完整真机功能 |
| macOS | Apple Silicon 本地通用 Release、ad-hoc 签名、DMG 安装／覆盖、启动及空书库偏好保留 | Intel、旧系统、公开下载 Gatekeeper、Developer ID、公证、真实授权 |
| Windows／Linux／Arch | 配置、脚本及打包目录模拟检查 | 原生构建、实际包安装／升级、桌面展示与回调；Arch 未向 AUR 发布 |
| 自动化与 CI | 清单／客户端共享夹具，版本选择、失败恢复、订阅重复生成、失败保留及工作流选择条件有回归 | 模拟检查不代表远端构建发布或真实安装；每次发行以对应 job 和设备结果为准 |

已知构建边界：通用 iOS 模拟器构建受媒体插件 Swift 架构组合影响，指定模拟器可用；本地 iOS Release 曾需 `--no-tree-shake-icons`，默认字体裁剪仍需复核。macOS 宿主声明最低 12，而既有 torrent 动态库要求 26，支持范围尚待统一，不能据宿主声明承诺旧系统可用。
