# Mangayomi 上游基线

| 项目 | 值 |
| --- | --- |
| 源码 | https://github.com/kodjodevf/mangayomi |
| 正式版本 | `v0.9.9` |
| Git 提交 | `34dea5fd450a4b4d7683a32bec31a9ba2f0b555d` |
| 上游许可证 | Apache-2.0；见 [LICENSE](LICENSE) |
| 原始说明 | [README.mangayomi.md](README.mangayomi.md)，保存基线 README 原始字节 |
| LICENSE SHA-256 | `69849221bfb90053de2134ef5e6d540287b4b98062326492f1f96f5da685524b` |
| 原始 README SHA-256 | `772c8a13c1c8a428f38c113d3ac3c90bf53b0bf5746f891f0fd9cae6012656f3` |

本地 Git remote `upstream` 指向上述源码仓库，保留其历史与版本标记。NodeLane 的独立远程仓库尚未配置。

`pubspec.lock`、`rust/Cargo.lock` 及现有第三方版权、许可文件保留上游状态。固定应用提交不代表外部依赖、平台 SDK 或构建结果已经验证；后续构建应核对锁文件与实际解析版本。

更新上游时先核对差异，再显式选择迁移范围。NodeLane 的包标识、更新服务、签名、商店信息及发布工作流在发布前单独配置，不向上游发布 NodeLane 构建。
