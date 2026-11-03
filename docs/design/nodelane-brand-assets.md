# NodeLane 品牌素材来源

应用内标识与账号默认标识通过同一个 `NodeLaneBrandMark` 组件显示，分别读取 `assets/brand/app-mark.png` 与 `assets/brand/account-mark.png`。两份资源当前使用同一品牌图形，保留独立文件以便按用户要求分别替换；不随构建读取同级仓库。

- 来源：同级 `node-comics` 的 `output/imagegen/nodelane-logo-v1/icon-512.png`，素材提交 `4ced10a5e8987e2a7385078150a1c3563fc3be61`。
- 版本：`nodelane-logo-v1`，512 × 512 RGBA PNG；本次直接复制，不重绘、不改色、不分发字体。
- 两份 PNG 的 SHA-256：`dce89a469d12bbfaacb3e67d7176ca20bd46a57e362f089d8c2985f637ff6406`。
- 来源素材清单记载由 `gpt-image-2` 生成，经过透明边缘清理、裁切、留边和缩放。图形为对白框、N 字母与粉色折页。
- 许可记录：来源仓库声明 `GPL-3.0-only`，素材目录没有单独声明其他许可，因此保留该来源许可信息，不把素材改标为本项目上游的 Apache-2.0。用户指定复用 NodeLane 品牌图形；本次没有复制参考仓库的运行时代码、导出脚本或字体。

关于页和更新流程设计稿见 [统一设计](ios-about-update-v2.png)，由内置 `image_gen` 生成，[完整提示词](ios-about-update-v2.prompts.txt)保留参考角色及约束。图中的版本和更新内容为示例，运行页面只使用真实版本与检查结果。
