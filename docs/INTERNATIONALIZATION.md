# 国际化

界面沿用 Flutter `gen-l10n`：英文模板为 `lib/l10n/app_en.arb`，生成文件在 `lib/l10n/generated/`。各语言资源覆盖全部模板词条，资源完整性由 `test/l10n/supported_languages_test.dart` 检查。

界面语言与漫画翻译目标共用 `lib/l10n/languages.dart`，名称和顺序与 [NodeLane 漫画翻译官网](https://comics.nodelane.net/) 一致：简体中文、繁體中文、English、日本語、한국어、Français、Español、Português (Brasil)、Deutsch、Italiano、Русский、Polski、Українська、Türkçe、Tiếng Việt、Bahasa Indonesia、العربية。两种选择各自保存，切换界面语言不会改写已选择的翻译目标。

应用使用 `zh-Hans`、`zh-Hant`、`pt-BR` 等完整语言标记。Flutter 生成器要求基础语言资源，因此 `app_zh.arb` 存放简体中文，`app_zh_Hant.arb` 存放繁体中文，`app_pt.arb` 存放巴西葡萄牙语；不会额外提供通用葡萄牙语选项。中文脚本与地区字段随界面设置保存和备份。不迁移或转换旧语言设置；不在当前名单内的已保存值使用英文显示，不重写存储值。首次启动仍根据系统语言偏好选择支持的语言。

保留原有翻译；补齐的非中文词条经 Google 翻译服务生成并校对关键术语，繁体中文由项目的简体资源通过 [OpenCC Python](https://github.com/yichen0831/opencc-python)（Apache-2.0，仅生成时使用）转换并校对关键界面词条。未引入翻译工具运行时依赖或复制 GPL 参考项目的语言资源。占位符和 ICU 选择结构独立保留，编译与测试验证关联完整性；译文措辞仍需母语校对。

| 范围 | 资源与接入位置 |
| --- | --- |
| 来源目录、分类、收费、仓库、筛选、保存搜索 | `source_*`、`repository_*`；来源资料标签显式接收当前 `AppLocalizations` |
| 跨来源搜索、范围、进度、失败重试 | `search_*`；数量通过 ICU 参数和复数规则生成完整句子 |
| 浏览器、标签页、网址、登录状态清理 | `browser_*`；可见文案和无障碍提示共同使用资源 |
| 阅读器和网页图片翻译、设置、状态、错误 | `translation_*`；网页桥接传入当前语言，并随界面语言变化更新；JS 不拼接中文后缀 |
| 引导、电视端、追踪列表、播放器、扩展编辑器、内存面板、Discord 状态 | 对应 `onboarding_*`、`tv_*`、`tracker_*`、`player_*`、`source_code_*`、`memory_*`、`discord_*` 词条 |
| iOS 应用名称和权限说明 | `ios/Runner/*.lproj/InfoPlist.strings`，声明相同的 17 种语言，跟随系统语言 |
| Android 应用名称与系统语言选项 | `android/app/src/main/res/values*/strings.xml`、`res/xml/locales_config.xml`；声明相同的 17 种语言并启用 RTL |

## 文案与数据边界

- Widget 使用 `context.l10n`；可复用展示函数显式传入 `AppLocalizations`。没有 `BuildContext` 的通知和服务文案沿用 `localizedMessage`，应用 Navigator 尚未挂载时使用英文。
- 保留第三方来源返回的标题、作者、分类原值、用户输入、语言自称、品牌、算法名称、URL、协议键、错误码和开发诊断原文。来源通用筛选标签只在展示层翻译，不改变插件参数。
- 追踪列表的缓存键与显示标题分离，沿用原缓存标识；播放器的 MPV 命令、存储的着色器名称与选择比较不使用翻译后的文本。
- 数量、名称、进度和完整提示句使用 ARB 参数，不用字符串拼接构造固定语序。英文数量使用 ICU 复数规则。
- 来源搜索标题和引导标记支持长译文及大字号换行。

## 更新与验证

修改 ARB 后运行 `flutter gen-l10n`，将生成文件一起保留。新增用户文案应补齐全部语言，检查占位符类型，并在相关组件测试中声明语言和本地化代理。应用与语言选择器使用 `nodeLaneSupportedLocales` 保证名称、顺序和完整语言标记一致。

```sh
flutter gen-l10n
flutter analyze --no-fatal-infos --no-fatal-warnings
flutter test
python3 test/services/translation/browser_bridge_test.py
plutil -lint ios/Runner/*.lproj/InfoPlist.strings ios/Runner/Info.plist ios/Runner.xcodeproj/project.pbxproj
```

回归覆盖 17 种语言的资源加载、日期格式、RTL、设置保存与备份、语言切换、数量表达、窄屏大字号、网页按钮可访问名称、追踪缓存连续性及原有失败、重试行为。Flutter 测试和桌面 Chrome DOM 测试不代表 iOS/Android 真机或真实翻译服务验收。系统语言设置、权限弹窗和实际移动 WebView 仍需设备验证。
