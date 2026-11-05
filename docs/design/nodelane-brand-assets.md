# NodeLane 品牌素材来源

应用内标识与账号默认标识通过同一个 `NodeLaneBrandMark` 组件显示，分别读取 `assets/brand/app-mark.png` 与 `assets/brand/account-mark.png`。通知、备份／恢复结果、更多页和侧栏也复用应用标识，不再随机选择红／黑上游图标或按主题重染品牌颜色。两份资源当前使用同一品牌图形，保留独立文件以便分别替换；不随构建读取同级仓库。

- 来源：同级 `node-comics` 的 `output/imagegen/nodelane-logo-v1/icon-512.png`，素材提交 `4ced10a5e8987e2a7385078150a1c3563fc3be61`。
- 版本：`nodelane-logo-v1`，512 × 512 RGBA PNG；应用内素材保留原始字节，不重绘、不改色、不分发字体。
- 两份 PNG 的 SHA-256：`dce89a469d12bbfaacb3e67d7176ca20bd46a57e362f089d8c2985f637ff6406`。
- 来源素材清单记载由 `gpt-image-2` 生成，经过透明边缘清理、裁切、留边和缩放。图形为对白框、N 字母与粉色折页。
- 许可记录：来源仓库声明 `GPL-3.0-only`，素材目录没有单独声明其他许可，因此保留该来源许可信息，不把素材改标为本项目上游的 Apache-2.0。用户指定复用 NodeLane 品牌图形；本次没有复制参考仓库的运行时代码、导出脚本或字体。

关于页和更新流程设计稿见 [统一设计](ios-about-update-v2.png)，由内置 `image_gen` 生成，[完整提示词](ios-about-update-v2.prompts.txt)保留参考角色及约束。图中的版本和更新内容为示例，运行页面只使用真实版本与检查结果。

## 平台图标

平台图标输入为 `assets/brand/nodelane-comics-icon.png`，来自同一素材提交的 `output/imagegen/nodelane-logo-v1/logo-mark-1024.png`，为 1024 × 1024 RGBA PNG，SHA-256 为 `3f220d04f766443abb7be26db011926cf56544c20a737a183e4721e1f8edea2e`。该文件沿用上述来源与许可记录，只用于平台资源导出，不列入 Flutter 运行时资源；应用内仍使用按显示尺寸解码的 512 像素素材。

生成配置位于 `pubspec.yaml` 的 `flutter_launcher_icons`，锁定工具版本见 `pubspec.lock`（当前为 0.14.4）。iOS 的标准图标合成白色背景并移除 alpha，深色图标保留透明背景，着色图标由工具转换为灰度；其余形状与比例保留。输出由 `ios/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json` 声明，目录内不保留未引用的 PNG。现有透明启动占位图保持不变。

macOS 从同一输入导出 16／32／64／128／256／512／1024 像素图标，保留透明背景，供 `macos/Runner/Assets.xcassets/AppIcon.appiconset/Contents.json` 的 10 个尺寸／倍率项引用；无未引用图片。使用同一 `flutter_launcher_icons` 工具，仅启用现有配置中的 macOS 项，不重新生成其他平台资源。

| 1024 像素输出 | SHA-256 |
| --- | --- |
| `Icon-App-1024x1024@1x.png` | `5b66c71d892ece51fd3962ca1847b9b02136c343f394c345a7ddc685acf00ecc` |
| `Icon-App-Dark-1024x1024@1x.png` | `575ae4e8fa6c8324933137b54532bd036d71baabf6a5bf2482ccc384ddcb4f14` |
| `Icon-App-Tinted-1024x1024@1x.png` | `3c0b8071327a076e29a9031e597cfdec14ec43bb43cdb19546c7685915d985b1` |
| macOS `app_icon_1024.png` | `575ae4e8fa6c8324933137b54532bd036d71baabf6a5bf2482ccc384ddcb4f14` |

Android／Windows 的生成输入与本地 Linux 打包图标入口已指向 NodeLane 素材，原生图标输出仍待对应平台处理；各平台发行验收独立进行。`assets/app_icons/icon-red.png` 仅保留供未改动的上游原始 README 展示，不列入 Flutter 运行时资源。
