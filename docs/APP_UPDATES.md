# 应用更新清单

客户端从 `https://comics-updates.nodelane.net/stable/index.json` 读取静态清单，安装包仍从本项目的 GitHub Releases 下载。清单无需登录，客户端不携带 GitHub 凭据，也不直接查询 GitHub Releases API。

## 生成与手动发布

正常发行继续使用 Actions → **Build & Release**。选择已有的 `v<版本号>` 标签和平台；安装包成功上传并发布后，流程自动生成清单，保存为 `nodelane-comics-v<版本号>-update-manifest` Actions 产物。此流程不访问或部署你的服务器。

1. 下载并解压该 Actions 产物，得到 `stable/index.json`。
2. 将文件上传至域名对应静态目录的临时文件，例如 `stable/index.json.tmp`。
3. 在服务器上将临时文件原子替换为 `stable/index.json`，避免客户端读到未上传完的 JSON。
4. 若有 CDN，刷新该路径的缓存；在应用“更多 → 关于与帮助 → 检查更新”验证。

服务器应返回 `Content-Type: application/json; charset=utf-8`，建议 `Cache-Control: public, max-age=300` 并支持 ETag/304。保留上一次文件便于恢复。域名返回 404、HTML、无效 JSON 或网络错误时，手动检查会显示失败。

也可以在仓库根目录本地重新生成，无需重新构建安装包：

```sh
python3 -B tool/generate_update_manifest.py
```

输出为 `build/app-updates/stable/index.json`。可通过 `--output` 指定位置。脚本使用 Python 标准库；可选的 `GH_TOKEN` 仅用于生成阶段请求 GitHub API，令牌不写入产物。任何请求、元数据校验或文件替换失败都会使命令失败，并保留旧输出。

## 清单契约

根对象包含 `schema: 1` 和 `updates` 数组。无已发布安装包时，生成有效的空数组。每个条目代表一个平台/架构的最高正式版本：

| 字段 | 内容与来源 |
| --- | --- |
| `platform` | `android`、`android-tv`、`ios`、`macos`、`windows` 或 `linux` |
| `arch` | Android 使用 ABI 名称或 `universal`；其他平台为 `any` |
| `version` | 正式标签 `vX.Y.Z` 中的版本号 |
| `build` | 该标签下 `pubspec.yaml` 的构建号，必须与版本匹配 |
| `notes` | GitHub Release 的更新说明 |
| `page_url` | 本项目该版本的 GitHub Release 页面 |
| `url` | GitHub 返回的公开 `browser_download_url`，不保存重定向后的临时签名地址 |
| `sha256` | GitHub 安装包元数据的 SHA-256，64 位小写十六进制 |

生成器扫描全部公开正式 Release，按项目现有安装包命名识别平台和架构；草稿、预发布、未上传完成及无安装包版本不参与。每个目标独立选择最高版本，因此只发布 macOS 不会移除 Android 的可用版本。桌面同版本多种格式优先选择 DMG、EXE、AppImage；客户端在桌面和 iOS 上仍打开 Release 页面。

文件名解析仅在生成器中进行。客户端只读取清单明确声明的平台与架构，不再从 URL 猜测。清单里的来源地址限定为本项目的 GitHub Release 地址。

## 客户端行为

- 自动检查使用六小时有效期的持久缓存；手动检查跳过此时间限制，携带 ETag 重新验证。缓存按完整清单地址隔离，同一客户端合并在途请求。
- 请求总超时为 20 秒，超时或客户端释放时终止请求。失败不覆盖成功缓存，也不把旧缓存作为本次检查成功结果。
- Android 按设备支持的 ABI 顺序匹配，通用包排在具体 ABI 之后，手机和 TV 分开。选择最高兼容版本，并要求版本号及构建号都高于当前安装版本。
- Android 由系统下载管理器负责下载。完成后核对包名、版本、构建号与 SHA-256，通过后才可发起系统安装；安装签名仍由 Android 校验。旧版没有校验元数据的应用更新下载会被清理后重新检测，不影响书架和普通下载。
- iOS 和桌面显示更新说明并打开 GitHub Release 页面，安装方式保持原平台行为。

## 本地验证

```sh
python3 -B -m unittest discover -s tool -p 'test_*.py'
flutter test test/services/check_for_update_test.dart test/modules/more/software_update_test.dart test/utils/version_test.dart
flutter analyze --no-fatal-infos --no-fatal-warnings
flutter build apk --debug
```

生成器和 Dart 客户端共用 `test/fixtures/app_update_manifest.json` 验证清单契约。服务、页面测试使用模拟网络，不能代替服务器部署或真实安装包升级验收。

本地静态服务可通过构建参数切换清单入口：

```sh
flutter run --dart-define=NODELANE_UPDATE_MANIFEST_URL=http://10.0.2.2:8787/stable/index.json
```

`10.0.2.2` 仅用于 Android 模拟器访问宿主机；正式入口应使用 HTTPS。覆盖安装本地调试包前核对已安装版本和签名，避免工具自动卸载原应用。
