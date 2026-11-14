# NodeLane Comics App

基于 Mangayomi 的 Flutter / Rust 应用，首版面向 iOS、Android；专题按需读 `docs/`。

- 保留漫画／小说／动画及用户修改。来源、阅读器、翻译解耦，网页与阅读器共用翻译；任务按来源／账号／渠道隔离，图片、缓存、WebView 明确释放。
- 网站适配按[插件技能](https://github.com/Wy2926/nodelane-comics-extensions/blob/main/.agents/skills/nodelane-source-adapter/SKILL.md)：新站先实测 Keiyoushi 原版，既有 JS 守原契约；App 只修通用宿主，保留永久 ID，不擅自迁移／删数据。
- 控制移动端并发与窗口，不擅自加能力门禁或图片尺寸／体积限制；缓存预算不是准入条件。
- 沿用 CI，按改动验证失败、重试、恢复和位置保持；Android、iOS、真实服务分别报告，静态／模拟测试不算设备验收。
- 本地 Android 用 MuMu，MuMuManager 查实际 ADB 地址；CLI／Dart MCP 与 `android/local.properties` 共用 SDK，Windows Pub 缓存与项目同盘，启动加 `--print-dtd`。
- 同级 `node-comics` 先读 README，仅供参考，未经要求不修改、不引入目录依赖。保留 LICENSE、[上游](UPSTREAM.md)与[第三方声明](THIRD_PARTY.md)，记录新增来源／许可，区分 Apache-2.0 与 GPL-3.0-only。
- 凭据、敏感数据、签名地址不入仓库或默认日志，供应商密钥留后端。提交／推送／发布／部署各需本次授权；默认只改工作区，中文说明结果与未验证项。
- 文档只留现状、用法、验证边界和待办，每项事实维护一处；删流水与重复论证，历史交给 Git，README 面向用户。
