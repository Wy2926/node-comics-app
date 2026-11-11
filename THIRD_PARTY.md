# 第三方与参考实现

Mangayomi 上游基线采用 Apache-2.0，原始许可见 [LICENSE](LICENSE)，基线见 [UPSTREAM.md](UPSTREAM.md)。

`assets/nodelane_reader.js` 的图片呈现、Canvas 同级覆盖与视口排序基于 [NodeLane Comics](https://github.com/Wy2926/node-comics) 的 `apps/extension/src/inline/display.ts`、`canvas-display.ts`、`window.ts` 适配，参考提交为 `92f16b548da98431be1607eed57bb561b239156d`。该脚本采用 **GPL-3.0-only**，条款见 [GPL 许可全文](assets/brand/LICENSE-GPL-3.0-only)；不应将它标为 Apache-2.0。分发包含该代码的组合应用需遵循 GPL-3.0-only，保留上游 Apache-2.0 及其他第三方声明。

没有引入同级仓库的运行时路径依赖。图片解码继续使用项目已有的 `image`、Flutter 平台编解码器与 AVIF 支持。

来源图块协议参考 `node-comics` 提交 `af3df6ee75276ba1970ba0a7dc22488d54712e18` 的 `images.ts`（SHA-256 `3a7eedd0c9a8fbf1a14e67f89285d71f71dfc2e40d60fa3ce67e66ce0ad92113`）。App 的通用 Dart 置换独立实现，未复制该 GPL TypeScript 文件；具体种子掩码留在独立 GPL 插件仓库。

官方翻译协议对照 [NodeLane Comics](https://github.com/Wy2926/node-comics) 提交 `74204b088df724797fb95be9302d47104c3ca67e` 的 `apps/extension/src/api.ts`、`translation/channels/adapters/nodelane/` 与 `shared/translation-images/`（**GPL-3.0-only**），并核对服务端 HTTP 契约。Dart 适配器按请求、结果描述及 `NCOT0001` 容器格式独立实现互通；测试 WebP 是自行生成的合成像素，不含第三方漫画素材，也未增加编码器运行时依赖。

网页归档提取直接使用 [Dart mime](https://pub.dev/packages/mime) 的流式 MIME multipart 解析器，许可为 **BSD-3-Clause**（[源码与许可](https://github.com/dart-lang/tools/tree/main/pkgs/mime)）。该包从既有间接依赖改为显式依赖，版本沿用锁文件；分发时随 Flutter 依赖许可保留原始声明。WebView 归档创建继续使用现有 `flutter_inappwebview`，iOS property-list 解码使用系统 Foundation。
