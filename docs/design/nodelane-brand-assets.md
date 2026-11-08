# NodeLane 品牌素材来源

应用内标识与账号默认标识通过同一个 `NodeLaneBrandMark` 组件显示，分别读取 `assets/brand/app-mark.png` 与 `assets/brand/account-mark.png`。通知、备份／恢复结果、更多页和侧栏也复用应用标识，不再随机选择红／黑上游图标或按主题重染品牌颜色。两份资源当前使用同一品牌图形，保留独立文件以便分别替换；不随构建读取同级仓库。

- 来源：同级 `node-comics` 的 `output/imagegen/nodelane-logo-v1/icon-512.png`，素材提交 `4ced10a5e8987e2a7385078150a1c3563fc3be61`。
- 版本：`nodelane-logo-v1`，512 × 512 RGBA PNG；应用内素材保留原始字节，不重绘、不改色、不分发字体。
- 两份 PNG 的 SHA-256：`dce89a469d12bbfaacb3e67d7176ca20bd46a57e362f089d8c2985f637ff6406`。
- 来源素材清单记载由 `gpt-image-2` 生成，经过透明边缘清理、裁切、留边和缩放。图形为对白框、N 字母与粉色折页。
- 许可记录：来源仓库声明 `GPL-3.0-only`，素材目录没有单独声明其他许可，因此保留该来源许可信息，不把素材改标为本项目上游的 Apache-2.0。用户指定复用 NodeLane 品牌图形；本次没有复制参考仓库的运行时代码、导出脚本或字体。
- [GPL 许可全文](../../assets/brand/LICENSE-GPL-3.0-only)来自来源仓库提交 `811e267b6ef82e0d583ab594ad40110fb785e0a8` 的 `LICENSE`，SHA-256 为 `3972dc9744f6499f0f9b2dbf76696f2ae7ad8af9b23dde66d6af86c9dfb36986`。应用代码的上游 Apache-2.0 许可继续由仓库根目录 `LICENSE` 保存。

软件更新参考图见[软件更新设计](software-update.png)，通过本机 imagegen CLI 及 OpenAI 官方 API，使用 `gpt-image-2.6-sunburst` 生成，[完整提示词](software-update.prompts.txt)保留输入。没有输入第三方图片，参考图不随应用打包；运行界面的页纹、页片标记与小角标为 Flutter 几何绘制，不新增字体、图标或第三方素材依赖。既有品牌标识仍沿用上述 GPL-3.0-only 许可，版本与更新说明来自实际查询。

## README 素材

中英文 README 的明暗横向 Logo 原样复制自 [`node-comics`](https://github.com/Wy2926/node-comics) 提交 `29ccc9360456aa693fefdb12f9e503144e0ca618` 的 `apps/extension/src/assets/brand/`，保存在本仓库 `docs/images/`，不依赖同级目录。四份 WebP 沿用来源仓库的 `GPL-3.0-only` 许可，许可全文见上述 GPL 文件。

| 文件 | SHA-256 |
| --- | --- |
| `logo-horizontal-zh-light.webp` | `3bab8e6227e9a68de9d2cc2f34a1cb0d60ad1de15e937294e87d602ece0add7a` |
| `logo-horizontal-zh-dark.webp` | `13f4247055ce0ffe62e8e71d3839b7a945b8decc97b08ea1493b51877aa165a4` |
| `logo-horizontal-en-light.webp` | `abac28ef1514504dfcfee05374a85d230987809ce906cd08d864f19d79801023` |
| `logo-horizontal-en-dark.webp` | `8839d406415ea21d39a6cf90f34b257a11cd73a978c46df7bda45afe6ffb4143` |

`ios-library.png`、`ios-sources.png` 和 `ios-reader.png` 为应用在 iOS 模拟器中实际运行的截图，未重绘界面；其中漫画内容与封面版权归各自权利人所有。

## 平台图标

平台图标输入为 `assets/brand/nodelane-comics-icon.png`，来自同一素材提交的 `output/imagegen/nodelane-logo-v1/logo-mark-1024.png`，为 1024 × 1024 RGBA PNG，SHA-256 为 `3f220d04f766443abb7be26db011926cf56544c20a737a183e4721e1f8edea2e`。该文件沿用上述来源与许可记录，只用于平台资源导出，不列入 Flutter 运行时资源；应用内仍使用按显示尺寸解码的 512 像素素材。

生成配置位于 `pubspec.yaml` 的 `flutter_launcher_icons`，锁定工具版本见 `pubspec.lock`（当前为 0.14.4）。iOS 的标准图标合成白色背景并移除 alpha，深色图标保留透明背景，着色图标由工具转换为灰度；其余形状与比例保留。输出由 `ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json` 声明，目录内不保留未引用的 PNG。现有透明启动占位图保持不变。

macOS 从同一输入导出 16／32／64／128／256／512／1024 像素图标，保留透明背景，供 `macos/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json` 的 10 个尺寸／倍率项引用；无未引用图片。使用同一 `flutter_launcher_icons` 工具，仅启用现有配置中的 macOS 项，不重新生成其他平台资源。

Windows 使用同一工具与输入导出 `windows/runner/resources/app_icon.ico`，内含 256 × 256、32 位透明图标，应用资源与 `inno_bundle.installer_icon` 共用该文件；按平台单独生成，不更新其他平台资源。

Linux 的 `linux/packaging/icons/hicolor/<尺寸>/apps/nodelane-comics.png` 复用上述 macOS 的 16／32／64／128／256／512 像素输出，通过仓库内相对符号链接引用；发行打包时解引用为 PNG，安装后不依赖 macOS 目录。桌面入口、AppImage、RPM 与 Debian 共用这些资源，不另存重复图片。

Android 使用同一工具与输入导出五种密度的 `launcher_icon.png`，以及自适应图标的 `ic_launcher_foreground.png`；背景为白色，前景留边为 24%，避免圆形遮罩裁切对白框尾部。生成时只启用 Android，不更新其他平台资源。手机与 TV 共用图标，已删除未引用的旧 `ic_launcher.png`、启动视频、重复 TV 图标目录及构建覆盖步骤。

TV 横幅为 320 × 180 PNG，复用品牌图形并合成浅色背景与应用名称；英文显示 NodeLane Comics，中文显示 NodeLane漫译。文字使用 macOS 系统字体栅格化，只分发 PNG，不引入字体文件。`drawable-xhdpi/tv_banner.png` 为默认横幅，`tv_banner_zh.png` 由简繁中文资源映射共用；没有按地区复制图片。尺寸及文字规则依据 [Android TV 图标指南](https://developer.android.com/design/ui/tv/guides/system/tv-app-icon-guidelines)。

| 平台输出 | SHA-256 |
| --- | --- |
| `Icon-App-1024x1024@1x.png` | `5b66c71d892ece51fd3962ca1847b9b02136c343f394c345a7ddc685acf00ecc` |
| `Icon-App-Dark-1024x1024@1x.png` | `575ae4e8fa6c8324933137b54532bd036d71baabf6a5bf2482ccc384ddcb4f14` |
| `Icon-App-Tinted-1024x1024@1x.png` | `3c0b8071327a076e29a9031e597cfdec14ec43bb43cdb19546c7685915d985b1` |
| macOS `app_icon_1024.png` | `575ae4e8fa6c8324933137b54532bd036d71baabf6a5bf2482ccc384ddcb4f14` |
| Windows `app_icon.ico`（256 像素） | `f04976df67739514c76663bcc190be1e22de6cee7dd1da12648d6e3139370c0b` |
| Android `mipmap-xxxhdpi/launcher_icon.png` | `c1c6492b64a94c6cf8b29d7db50de83c5756e16573c50c8120201ca1716cebfe` |
| Android `drawable-xxxhdpi/ic_launcher_foreground.png` | `2b53764b10041d340e01bd86f5d929633a984f4d71c1c756dbaa115b42a0d0de` |
| Android `drawable-xhdpi/tv_banner.png` | `742b54adfe8d82a3ecb6582699c9dc1a477d7d5f1e28c6a8ca195a406c69f3f1` |
| Android `drawable-xhdpi/tv_banner_zh.png` | `aa16b356b7ab0fbeb66ac6b8b644ec918e9838c8cae3a82c69087e9697338f9d` |

各平台发行验收独立进行。`assets/app_icons/icon-red.png` 仅保留供未改动的上游原始 README 展示，不列入 Flutter 运行时资源。
