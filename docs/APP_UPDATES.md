# 发行与应用更新

客户端默认从 `https://comics-updates.nodelane.net/stable/index.json` 读取静态清单，不需要 GitHub 凭据，也不直接查询 GitHub Releases API。安装包和发布页可以使用任意 HTTP／HTTPS 地址，包括自建服务器、CDN、端口、查询参数和片段。清单入口可通过 `NODELANE_UPDATE_MANIFEST_URL` 构建参数替换。

## 平台身份与构建

发行版本和基础构建号维护在 `pubspec.yaml`，关于页显示实际安装包信息。NodeLane 使用独立应用身份，不覆盖上游 Mangayomi 或迁移其私有数据；后续覆盖安装须保持包标识与兼容签名。

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

在 Actions 的默认分支手动运行 `.github/workflows/release.yml` 的 **Build & Release**，输入已推送的 `v<应用版本>` 标签和平台，默认 macOS，`all` 构建全部平台。应用从标签指向的提交构建；发布脚本和策略固定到校验标签时的默认分支提交，包括补发旧标签。构建、签名或新整包验证失败不发布。

新 Release 先上传草稿，成功后公开；重试可继续草稿，补发平台保留已有说明和资源。产物名为 `nodelane-comics-<tag>-<platform>.<ext>`，Android／TV 在平台后附 ABI；CI 调试产物为 `nodelane-comics-<platform>-debug`。缺少预期文件时失败。执行发布仍需明确授权。

### iOS 侧载订阅

`repo/update_source.py` 按 `repo/config.json` 生成 `repo/source.json`，源 ID 为 `com.nodelane.comics.source`，应用 ID 为 `com.nodelane.comics`。只收录项目公开 Releases 中正式版本及同仓库已上传的 `nodelane-comics-<tag>-ios.ipa`，无 IPA 时 `apps`／`news` 为空。

版本按数值降序、同版本去重；订阅按版本号更新，不区分同版本 build。版本、最低系统和权限须与实际签名 IPA 核对，字段遵循 [AltStore Source 格式](https://faq.altstore.io/developers/make-a-source)。请求或解析失败保留旧源，生成成功才原子替换；工作流先运行 `python3 -B -m unittest discover -s repo -p 'test_*.py'`，iOS 构建和发布成功后更新，也可手动重建。

## Android 发布签名

发布沿用同一份签名，不生成替代密钥。Windows 本地备份放在 `%LOCALAPPDATA%\nodelane\signing\node-comics-app\`，包含 `nodelane-comics-release.p12` 和 `signing.json`；两者都不进入 Git。预期包名和公开证书 SHA-256 见 [APK 身份校验](../tool/android_apk.py)。

GitHub Actions 使用仓库 Secrets `SIGNING_KEY_STORE_BASE64`（密钥文件的 Base64）与 `SIGNING_KEY_PROPERTIES`（包含 `storeFile=upload-keystore.jks`、`storeType=PKCS12`、别名和密码的 Java properties）。工作流只向签名步骤传入它们，不把内容写入源码、日志或产物；补丁从签好名的 APK 生成，不需要签名密钥。Secrets 可供获准运行的工作流读取，不替代独立的密钥备份。

发布前核对 APK 的包名、版本、构建号及签名与已发布版本兼容。构建号以实际发布 APK 为准并递增；对外更新说明使用简洁的用户语言，不使用自动生成的提交日志。

## 生成与手动发布

发布后生成 `nodelane-comics-v<版本号>-update-manifest` Actions 产物，清单部署使用以下步骤：

1. 下载并解压该 Actions 产物，得到 `stable/index.json`。
2. 将完整安装包和清单引用的补丁放到对应地址，部署镜像时同步更新 `url`、`delta.url` 和 `page_url`。
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

Android／TV 在上传前用 SDK 的 `aapt2` 读取完整 APK 的包名、版本、实际构建号和 ABI，用 `apksigner` 验证正式签名。每个 APK 随 Release 保存一份 `<文件名>.apk.json`，绑定整包摘要和可选补丁的实际基线；生成清单时与 Release 资源交叉核对。没有记录或没有 GitHub 整包摘要时，下载并检查实际 APK，不从标签推算 Android 构建号。手动生成时将 Android SDK Build Tools 加入 `PATH`；其他平台沿用标签中 `pubspec.yaml` 的构建号。CDN 仅需提供清单引用的文件，客户端不下载 `.apk.json`。

草稿、预发布和未上传完成的资源不进入清单。每个平台／架构独立选择最高版本；桌面同版本多格式优先 DMG、EXE、AppImage。下载 URL 沿用资源地址或指定下载根地址；客户端不依赖生成器，也可直接发布符合下列契约的 JSON。

### Android 差分与整包

进入 `0.2.0` 下载整包。自 `0.2.0+2007` 起，更新器按已装版本、实际构建号和基础 APK 的 SHA-256 匹配补丁；首次安装、跳过基线、非同一份 APK、分体安装或没有可用补丁均可使用完整 APK。差分只降低传输量，设备仍需临时容纳补丁和新包。

- **指定必须整包的版本：** 发布前把目标版本（不带 `v`）加入 [`tool/android_full_updates.json`](../tool/android_full_updates.json)，保留历史条目。生成清单时仍应用这份策略；已生成的补丁也不能跨越新增的整包边界。例如 `0.2.2` 标为整包：`0.2.1 → 0.2.2`、`0.2.1 → 0.2.3` 都下载完整目标 APK；`0.2.2 → 0.2.3` 可重新使用差分。整包是覆盖安装，不是卸载或清空数据。
- **常规发布：** 每个 Android／TV 架构只取上一个有该 APK 的正式版，发布时记录实际基线版本、构建号和摘要；补发中间版本不改变已发布补丁的基线。按 ZIP 条目复用原始压缩字节，签名区、对齐和差异字节原样写入 `nld1` 补丁。节省不足 20% 时不发补丁，此门槛仅由制补丁工具执行；旧包缺失、网络异常、旧包校验或制补丁失败时报告该架构并保留新整包。旧客户端继续读取 schema 1 和完整 `url`。
- **恢复与流量：** 用户点击后开始系统下载；后台或进程重启不会主动另下整包。补丁校验、基线、空间或合成失败，显示完整包大小，由用户决定是否继续。成功后校验目标字节、包名、版本、构建号和同一签名，再交 Android 系统安装。取消移除临时文件；设备不保留上一版本 APK 的副本。

## 清单契约

根对象包含 `schema: 1` 和 `updates` 数组，无更新时数组为空。条目按平台／架构声明目标，不从 URL 或文件名猜测。

| 字段 | 内容 |
| --- | --- |
| `platform` | 必填。当前目标为 `android`、`android-tv`、`ios`、`macos`、`windows`、`linux`；其他平台条目不影响清单解析 |
| `version` | 必填。数字版本，支持点分段、`v` 前缀及预发布／构建后缀；比较沿用数字部分，不按后缀排序 |
| `url` | 必填。安装包 HTTP／HTTPS 地址 |
| `arch` | 可选。Android 默认 `universal`，具体包填写设备 ABI；其他平台默认 `any`。未知架构不会导致整份清单失败 |
| `abis` | 可选。新通用 APK 列出包内的实际 ABI；设备须至少支持其中一种。未声明时保留旧通用包行为 |
| `build` | 可选，默认 `0`。非负整数；用于识别同版本的后续构建 |
| `notes` | 可选，默认空。原样展示更新说明 |
| `page_url` | 可选。iOS／桌面填写时打开此页面，省略或为空时直接打开 `url` |
| `size` / `sha256` | 可选，目标完整 APK 的字节数／小写 SHA-256；提供补丁时两者均必填 |
| `full_only` | 可选。`true` 强制该版本下载整包，即使同时误填 `delta`；异常类型也不使用补丁 |
| `delta` | 可选。`format: "nld1"`，`from_version`、`from_build`、`from_sha256` 标识基线；`url`、`size`、`sha256` 标识补丁。未知格式或无效补丁元数据不影响有效整包 |

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

清单须为合法 JSON 和受支持的 schema。单个无效条目不阻断其他平台或架构；非空列表中所有条目都无效时检查失败，保留原缓存。完整包 `sha256` 缺省兼容旧清单，显式为空或格式错误则拒绝该条目，不降级为免校验下载。

## 客户端行为

- 自动检查使用六小时有效期的持久缓存；手动检查跳过时间限制，携带 ETag 重新验证。缓存按完整清单地址隔离，在途请求合并。请求总超时为 20 秒，失败不覆盖成功缓存，也不把旧缓存作为本次成功结果。
- Android 先按手机／TV、设备 ABI 和已知构建号过滤：版本名再新，也不推荐 `versionCode` 低于已装包的 APK。可安装项取最高版本，同版本取较高构建号，再按设备 ABI 顺序选择，通用包最后。旧清单未声明构建号（或为 0）时仍可发现更高版本；同版本更新需明确更高构建号。
- Android 使用系统 `DownloadManager`。带 SHA-256 的整包会核对摘要、包名、版本及已声明的大小和构建号，签名由系统安装器检查；无摘要的旧清单沿用系统安装器校验。差分合成和校验在后台工作线程执行，只有准备成功才能启动安装器。
- 同时维护一个下载任务。进行中或准备好的任务支持离线恢复。失败后可重新检查清单；进页或点击重试也会重查：离线保留原任务和显式整包选项，新版本、新地址或新补丁则重新展示，用户点击后才下载。取消或移除下载包后重新检查清单。迟到的检查不能清除已恢复为活跃的任务。
- 安装权限通过 Android 系统设置授予，返回后再次点击安装。拒绝权限、取消安装或安装器启动失败保留下载文件；不会仅因打开安装器就标记更新成功。
- iOS 和桌面通过系统浏览器打开清单指定的页面或下载地址，不提供内置安装器。

## 本地验证

```sh
python3 -B -m unittest discover -s tool -p 'test_*.py'
flutter test test/services/check_for_update_test.dart test/modules/more/software_update_test.dart test/utils/version_test.dart
flutter analyze --no-fatal-infos --no-fatal-warnings
flutter build apk --debug
```

生成器和 Dart 客户端共用 `test/fixtures/app_update_manifest.json`。发布工具测试覆盖旧标签补发、后补 ABI、整包边界、旧包 `503`／摘要异常、签名拒绝和收益策略变更。客户端测试覆盖降级过滤、坏条目隔离、重试前目标或地址变更、取消后刷新与离线恢复；模拟网络和平台服务不代替真机及真实发行服务器验收。

差分工具回归使用 Python 3.11+ 和 JDK，直接编译并运行手机端使用的解码器。设备复验用同签名、同架构的两个 APK，目标构建号递增。`python3 tool/apk_delta.py base.apk target.apk change.nld1` 生成补丁；在本地清单填入三个文件的真实 SHA-256、大小和包内构建号，安装基础包后检查更新。将 `full_only` 设为 `true` 时服务应只收到整包请求；改错基础摘要时不应请求补丁；改错补丁摘要时应在手动选择整包前停止。取消后可以重新下载，离页或重启后可以接回任务，合成的 `update.apk` 应与目标文件摘要相同。

复验失效链接：让补丁返回 404，确认整包请求数为零。让清单返回 503 后重新检查，应保留带大小的整包按钮；再恢复清单并更换地址，点击重试应先显示新选项。开始下载后发布更高版本并取消，确认页面显示新版本和大小，新包请求数仍为零。

本地静态服务可通过构建参数切换清单入口：

```sh
flutter run -d <设备ID> --print-dtd --dart-define=NODELANE_UPDATE_MANIFEST_URL=http://<开发机可达地址>:8787/stable/index.json
```

替换命令中的占位值。本地 Android 使用 MuMu，通过 MuMuManager 查询实际 ADB 地址，再确认设备到开发服务的连通性，不假定其他模拟器的宿主机地址。SDK 与缓存要求见 [AGENTS](../AGENTS.md)。覆盖安装保留原应用数据，不通过卸载绕过签名或版本不兼容。

## 验证边界

| 平台／范围 | 已有证据 | 仍需验收 |
| --- | --- | --- |
| Android 更新 | API 36 arm64 模拟器使用本地 HTTP、同签名 Debug 包覆盖后台下载、进程恢复、重复任务、503／404、取消、权限拒绝、安装取消及覆盖安装保留数据 | 真实发行服务器的完整更新链路、ARM 真机、其他 API／ABI 与 TV |
| Android 差分 | MuMu API 32 x86_64、本地清单与同签名 Debug 包：强制整包、基线不符、摘要失败后手动回退、取消和杀进程恢复。混入坏 iOS 条目和降级包时仍选中有效更新；服务收到声明大小为整包 83% 的补丁请求，链接失效不自动另下整包。重查离线保留整包选项，换地址和取消后只展示新目标。`6007 → 6008` 和 `6009 → 6010` 都经系统覆盖安装，已安装 APK 的 SHA-256 与目标一致 | 正式 CDN／GitHub 发布、ARM 真机、TV、真实磁盘耗尽及签名轮换 |
| Android Release | 本地用 `0.1.4` 和 `0.2.0+2006` 的六份正式签名 APK 生成清单，核对包内构建号；修改 APK 字节后签名校验阻断发布准备。MuMu x86_64 已验证 `0.1.4 → 0.2.0+2006` 整包覆盖；`0.1.2 → 0.1.3` 曾验证冷启动及引导状态／翻译语言偏好保留 | ARM 真机、完整书库／阅读进度升级保留及其他发行功能 |
| iOS | 指定 arm64 模拟器构建与更新入口；无签名 Release 打包，个人 Apple ID 重签后在 iPhone 安装和首次启动 | 正式团队／CI 签名、续签、版本间覆盖更新、侧载订阅客户端与完整真机功能 |
| macOS | Apple Silicon 本地通用 Release、ad-hoc 签名、DMG 安装／覆盖、启动及空书库偏好保留 | Intel、旧系统、公开下载 Gatekeeper、Developer ID、公证、真实授权 |
| Windows／Linux／Arch | 配置、脚本及打包目录模拟检查 | 原生构建、实际包安装／升级、桌面展示与回调；Arch 未向 AUR 发布 |
| 自动化与 CI | 清单／客户端共享夹具，版本选择、失败恢复、订阅重复生成、失败保留及工作流选择条件有回归 | 模拟检查不代表远端构建发布或真实安装；每次发行以对应 job 和设备结果为准 |

已知构建边界：通用 iOS 模拟器构建受媒体插件 Swift 架构组合影响，指定模拟器可用；本地 iOS Release 曾需 `--no-tree-shake-icons`，默认字体裁剪仍需复核。macOS 宿主声明最低 12，而既有 torrent 动态库要求 26，支持范围尚待统一，不能据宿主声明承诺旧系统可用。
