# 应用更新清单

客户端默认从 `https://comics-updates.nodelane.net/stable/index.json` 读取静态清单，不需要 GitHub 凭据，也不直接查询 GitHub Releases API。安装包和发布页可以使用任意 HTTP／HTTPS 地址，包括自建服务器、CDN、端口、查询参数和片段。清单入口可通过 `NODELANE_UPDATE_MANIFEST_URL` 构建参数替换。

## 生成与手动发布

Actions → **Build & Release** 继续从已有的 `v<版本号>` 标签构建并发布 GitHub 安装包，随后生成 `nodelane-comics-v<版本号>-update-manifest` Actions 产物。此流程不部署服务器。

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
flutter run --dart-define=NODELANE_UPDATE_MANIFEST_URL=http://10.0.2.2:8787/stable/index.json
```

`10.0.2.2` 用于 Android 模拟器访问宿主机。覆盖安装本地调试包时保留原应用数据，不通过卸载绕过签名或版本不兼容。
