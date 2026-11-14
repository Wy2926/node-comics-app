# 手机界面与视觉令牌

iOS 与 Android 手机共用视觉令牌和基础组件，桌面／电视保留各自布局。页面负责呈现、草稿和回调，查询、持久化、来源解析、播放与翻译由现有服务承担。

专题契约：[阅读设置](design/reader-settings-redesign/design.md)、[来源插件](SOURCE_PLUGINS.md)、[翻译架构](TRANSLATION_ARCHITECTURE.md)、[国际化](INTERNATIONALIZATION.md)、[发行与更新](APP_UPDATES.md)。本文维护界面行为、设计参考和设备验证边界。

## 视觉令牌

数值与主题实现以 [`NodeLaneTokens`](../lib/theme/nodelane_tokens.dart) 为准，业务页面复用文字角色和组件，不单独覆盖字号、圆角、输入装饰或颜色。

| 项目 | 约定 |
| --- | --- |
| 字体 | 继承用户字体及系统缩放；页面标题 34、详情标题 26、作品强调标题 22、面板标题 20、设置名 17、正文／输入 16、书名／值／按钮 15、说明 14、次要信息 13、徽章 12 |
| 间距 | 4／8／12／16／20／24；页面边距 20、分组内边距 16 |
| 圆角 | 封面 10、分组 18、输入／分段／模态 24；文字按钮胶囊形、工具按钮圆形 |
| 几何 | 点击区至少 44，输入／主次按钮高至少 48，设置行至少 56，目录行至少 72；图标 24、紧凑图标 20、网站图标 40 |
| 强调色 | 默认 `#006EFF`，继承用户主题；普通图标用正文色，操作／选中／进度用强调色，错误与破坏性操作用错误色 |
| 无障碍 | 大字号按内容增高或换行；高对比度玻璃改实色；动效遵守减少动态效果；隐藏控件不接收点击、键盘或语义焦点 |

| 色彩角色 | 浅色 | 深色 |
| --- | --- | --- |
| 画布／表面／次级填色 | `#F5F6FA`／`#FFFFFF`／`#EBEEF4` | `#13171D`／`#1E242C`／`#292F39` |
| 正文／辅助文字 | `#171A21`／`#697180` | `#F0F3F8`／`#A9B4C4` |
| 分割线 | `#E7EAF0` | `#353E4A` |
| 输入底色／细边 | `#FFFFFF`／`#DDE2E9` | `#303844`／`#46505F` |

纯黑模式使用黑色画布和 `#0A0A0A` 表面。轻选中态使用 11% 强调色；滚轮用透明覆盖层，避免盖住数字。开关关态由辅助色以 28% 混入表面。

内容分组为实色，无模糊和投影。输入使用 92% 填色、0.75 细边、局部模糊 8 和轻阴影；浮动工具模糊为 16。抽屉／对话框使用 97%→95% 高遮盖度表面和单层细边，遮罩为黑色 54%。高对比度移除玻璃阴影。Flutter 玻璃是有界模糊，系统材质参考 [Apple Materials](https://developer.apple.com/design/human-interface-guidelines/materials)。

Flutter 图标集中在 [`NodeLaneIcons`](../lib/theme/nodelane_icons.dart)，使用已有 `CupertinoIcons`；iOS 原生底栏使用 UIKit SF Symbols。品牌标识共用 `NodeLaneBrandMark`，来源与许可见[品牌素材](design/nodelane-brand-assets.md)及[第三方声明](../THIRD_PARTY.md)。

## 共享组件

常规控件位于 [`nodelane_controls.dart`](../lib/modules/widgets/nodelane_controls.dart)，主题由 `nodeLaneModalTheme` 提供。

| 职责 | 入口 |
| --- | --- |
| 表面与分组 | `NodeLaneSurface`、`NodeLaneGroupSurface`、`NodeLaneGroupDivider`、`NodeLaneGlassSurface` |
| 标题与导航 | `NodeLanePageHeading`、`NodeLaneSectionHeading`、`NodeLaneCatalogHeading`、`NodeLaneReaderHeading`、`nodeLaneAppBar`、`NodeLanePinnedHeader` |
| 输入 | `NodeLaneTextField`，搜索使用 `.search` 配置 |
| 操作 | `NodeLaneIconButton`、`NodeLaneMenuButton`、`NodeLaneCloseButton`、`NodeLaneToolbarAction`、`NodeLaneSecondaryButton`；主按钮沿用共享主题的 Flutter 按钮 |
| 设置 | `NodeLaneRow`／`.card`、`NodeLaneSwitchRow`、`NodeLaneDisclosure`、`MobileSettingsChoice` |
| 选择与数值 | `NodeLaneSegments`、`NodeLaneTabSegments`、`NodeLaneChoiceRow`、`NodeLaneSwitch`、`NodeLaneSliderRow`、`NodeLaneNumberRow`／`NodeLaneNumberPicker` |
| 卡片与标记 | `NodeLaneChoiceCard`、`NodeLaneCoverBadge`；业务卡片组合这些控件 |
| 模态 | `NodeLaneCatalogSheet`、`NodeLaneSheetSurface`、`NodeLaneDialog`、`NodeLaneAlertDialog`、`NodeLaneModalActions`、`NodeLaneDialogAction` |
| 状态 | `NodeLaneNotice`／`showNodeLaneNotice`、`NodeLaneEmptyState`、`NodeLaneSkeleton`、`NodeLaneProgress` |
| 批量选择 | `nodeLaneSelectionAppBar`、`NodeLaneSelectionBar` |

- **输入**：名称放在框上方，单字段表单不重复弹层标题；URL、邮箱、名称、密码单行横向输入，正文／代码才换行。清空和显隐在框内，框外点击或滑动收键盘并保留关键词；取消与保存空值分别处理。
- **设置行**：名称左、值右，说明另起一行。长值最多两行，完整值在选择页或编辑框查看；分类入口不显示其中某个设置的值。开关整行与控件点击只提交一次。
- **选择**：取消或同值不写入；多选、来源筛选和文本编辑保留本地草稿，搜索不丢失隐藏选择。滑块通常松手提交，外观缩放保留实时预览。
- **浮动数字**：从当前控件位置浮出，宽 184、三行、行高至少 44；停止滚动才保存，外部点击关闭，外部值刷新不触发写入。范围仍由业务定义。
- **模态**：短内容随内容展开，长内容有界滚动；标题、关闭和操作区可达，避让键盘及安全区。双操作窄屏纵排，三操作纵排。嵌套返回只关闭当前层，草稿与滚动由所属页面管理。
- **异步操作**：处理中防重入，写入失败保留草稿或提示核对可能的部分结果；结果未知时不自动重放。控制器、订阅和临时状态随所属视图释放，迟到回调不得改写新页面。
- **折叠**：`NodeLaneDisclosure` 管理展开动画和状态，收起后释放隐藏内容；每次重新展开创建新的单订阅流。`NodeLaneRevealScope` 只在搜索直达时定位，开关、清理等动作不自动执行。
- **加载与失败**：请求空态用 `NodeLaneEmptyState.loading/error`，内容骨架用 `NodeLaneSkeleton`；短屏／大字号可滚动，保留业务原有重试和电视焦点。

### 通知与反馈

`NodeLaneNotice` 共用轻提示、结果、错误和进度内容；浮动入口为 `showNodeLaneNotice`，BotToast 只承担宿主、计时和路由生命周期。`toastError` 负责错误整理与记录。

- 轻提示默认 3 秒、错误 6 秒、带操作结果 8 秒；支持关闭或横滑。同一任务通过 `NodeLaneNoticeHandle` 原位更新，旧任务只能关闭自己的提示。
- `NodeLaneNoticeAvoidance` 测量底栏、工具栏、键盘与安全区，浮层上方避让操作区并留 12 间距。路由或根标签切换收起旧提示，关闭提示不取消任务。
- 状态使用共享文字和语义色；长说明、操作换行，进度条高 3。业务动作仍由调用方管理，后台自动更新保持安静。

## 导航与书架

默认底部入口为书架、更新、来源、浏览器、更多；漫画／小说／动画在媒体菜单切换。iOS 使用一个 `UITabBarController`，Android 使用 `NodeLaneFlutterTabBar`。Android 胶囊底栏高至少 64、左右留白 16，外壳只绘制一层玻璃；选中背景包含图标与标签，大字号增高并避让手势区。

书架、更新、来源根页从媒体菜单与操作开始，浏览器从品牌与搜索区开始，更多从账号摘要与搜索开始。二级页复用居中紧凑顶栏，阅读器与网页不显示应用根底栏。隐藏媒体、导航顺序和角标沿用偏好；阅读历史用于恢复、统计和备份，没有独立入口，网页历史见浏览器一节。

- 书架使用 `NodeLanePageHeading.toolbar`、共享搜索与筛选；分类为可横滑胶囊，计数、全选与可见作品使用同一筛选快照。
- 四种显示模式由 `MobileBookshelfCard` 绘制。常规手机舒适两列、紧凑／仅封面三列，随屏宽与字体缩放调整；手机不读取每行列数，桌面／电视和来源保留各自偏好。
- 网格封面比例 1:1.08、圆角 10，书名最多两行，身份单行；列表缩略图 64×92。未读与下载标记分列封面顶部，零值隐藏，超过 999 显示 999+，读屏保留真实数量。
- 本地作品只显示一次本地身份，在线作品按偏好显示来源／语言。续读使用共享圆形按钮，独立于卡片命中；多选隐藏徽章与续读，显示选择圈。
- 未读完恢复原进度，全部已读仍可从阅读顺序中的首章首屏打开，不清空阅读记录。长按或选择作品进入多选，全选／反选只作用于当前可见结果。
- 筛选、排序、显示分区即时保存且各自保持位置；排序条件与方向分开。来源筛选使用可搜索草稿，确认时过滤失效来源；仓库按最新记录只修改目标字段。
- 空库引导浏览对应媒体来源或本地导入；无搜索结果提供清空与调整筛选，不能把分类无结果显示为空库。
- 本地导入使用系统选择器：漫画 ZIP／CBZ、小说 EPUB、动画原视频格式。取消可重选，处理中防重复，未知写入结果提示先核对。
- 批量分类取原对象分类并集，保存前重读记录、过滤失效分类；已收藏单本保留隐藏分类。移除书架记录和下载文件独立选择、默认不选，取消保留选择，失败提示核对部分结果。

### 更新与诊断

更新按日期连续分组、逐条懒构建。刷新／停止直达，清空放更多菜单并确认；封面进入详情，正文阅读章节，下载操作独立。任务由应用级 Provider 容器持有，离页可继续，进度与失败入口使用统一通知。

更新错误保留完整书名、摘要及展开详情，迁移／忽略独立；作品不存在时只提供忽略。错误报告保留倒序、时间、次数、完整堆栈与复制，展开状态按记录身份隔离。App 反馈指向 `Wy2926/node-comics-app` 表单并预填安装版本，来源问题指向插件仓库；外部草稿由用户审核提交。

### 欢迎引导

手机使用两步：品牌与媒体选择，然后浏览来源、本地导入及可展开的第三方来源库；至少选择一种媒体，允许暂时跳过。恢复备份独立显示。浏览来源按所选媒体打开现有目录，添加来源库后可进入对应安装分区。

目录预览只显示已有文件夹、数量和按需展开的最多 40 个名称；失败与空目录分别提示。选择、扫描、恢复和添加期间禁止重复发起或切步；返回先处理内层恢复弹窗。目录选择取消直接返回，草稿按当前媒体保留。

## 来源与搜索

安装、同步频率、来源身份和宿主执行边界见[来源插件](SOURCE_PLUGINS.md)。

- 官方／第三方分区共用 `SourceWebsiteCard`；常用位于首个可见分组，其余目录不重复列出。固定操作通过管理模式或长按菜单，切换媒体／分区退出管理。
- 网站卡片显示名称、语言、分类、收费底带及独立 18+ 切角。标准字号高 136，随窄屏／大字号统一增高；操作位承载安装、更新、重试和常用管理。缺资料保持未标注，成人标记只读取 `isNsfw`。
- 官方网站点击直接进入，缺失插件优先安装；第三方安装／更新操作独立。手动失败浮动提示，自动失败保留旧版本。仓库管理统一进入抽屉，添加时识别预览、去重，迟到结果不得覆盖新输入。
- 网站图标复用 `NodeLaneWebsiteIcon` 与现有网络图片分支的 30 天磁盘缓存，空地址／失败显示占位，不自动发现 favicon。
- 目录语言只控制当前媒体、分区的显示；搜索范围仅选择已安装且允许显示的来源。两者不改写安装状态。来源详情按身份、动态设置、高级操作排列；Cookie、卸载和开发者工具保留原确认及条件。

### 跨来源与站内搜索

- “搜作品”、空态跨来源搜索和键盘提交携带同一关键词；空词只提示输入。编辑草稿保留已提交结果。
- 跨来源只常显有结果的网站，失败／加载／空结果放搜索详情，失败可独立重试。范围为全部／常用／自选，应用时保留未改变来源的请求和位置。
- 全局与迁移搜索共用 `SourceResultSection`、`SourceResultCover`、`GlobalSearchResultCard` 和三路 `FetchGate`。查询变更、离页释放订阅，迟到结果按轮次丢弃；查看全部复用关键词与首屏。
- 站内热门／最新首次访问才请求，各自保持分页、在途读取和位置；搜索或筛选使用一份可替换结果集，首屏、分页与重试共用参数。下拉刷新失败保留内容，隐藏列表不主动翻页。
- 站内操作放更多面板；只有已提交关键词才可保存搜索，只有插件声明筛选才显示筛选入口。筛选采用独立草稿、原字段类型和默认值，三态显式选择，条件与排序方向分开；切换热门／最新恢复默认条件。
- 已保存搜索只保存关键词，点击即执行，管理模式才显示删除。动态单选同值不写入，多选等待保存，文本校验由来源契约决定；通用标签仅在展示层本地化。
- 结果懒构建、封面复用原缓存，空封面显示本地占位。站内页面最多保留两份浏览列表和一份搜索结果，离页释放；跨来源仍可能同时挂载所有来源首屏，尚无全局可见图片窗口。

### 迁移与批量迁移

单次迁移先显示当前作品、目标和可折叠章节，确认／取消固定可达；读取失败可重试，写入失败提示可能部分完成，不自动重放。追踪添加在同页选分类，提交时过滤失效项。

批量迁移按原来源、选作品、目标来源、匹配复核四步进行。逐本匹配保留两秒间隔；更换候选沿用可搜索选择页，读取期间不能开始迁移，失败项不进入执行。确认继续调用原服务，结束显示迁移／跳过／失败及待核对项，不建立另一套事务或后台恢复状态。

## 漫画详情与阅读

- 详情按封面与书名、阅读／收藏、简介与题材、次要操作、目录排列。封面 132×188，点封面查看、点标题搜索、长按复制；空简介不占位，长文及窄屏可换行。
- `MobileDetailOverview`、`MobileDetailPrimaryActions` 和 `MobileDetailShortcuts` 组合共享控件。更多区域按展开创建查询，收起释放；原网页、追踪、日历、迁移、分享及本地编辑条件继续来自业务。
- 刷新保留已有详情与章节，只为缺失区域显示骨架；等待目录时不显示零章节或无结果，收藏仍可用。阅读入口由 `MobileReaderEntryState` 保留封面、书名和章节，失败重试共用原请求。
- 目录设置即时应用三态筛选及独立排序方向；翻译组用可搜索排除草稿，确认前核对仍存在的组。章节列表按需构建，书签、已读、进度与下载各自独立。
- 书架与章节共用批量栏，取消、数量、全选／反选和底部常用动作明确可达。下载／删除按原条件提供；本地删除章节保留原包，在线删除只清理下载，本地目录确实为空才移除漫画。
- 删除确认固定对象范围，完整名单可滚动；处理中防重入和返回，取消保留选择，失败提示核对。写入按最新记录合并，不能重建已删除记录或覆盖期间更新的进度。
- 工具栏叠放而不挤压阅读画面；底部为章节、原图／译图、阅读，上方为返回、书名／章节、书签和更多。隐藏工具栏释放焦点，短屏和大字号可滚动，页码与自动滚动按钮避让安全区。
- 阅读设置、作用范围与位置锚点见[阅读设置](design/reader-settings-redesign/design.md)。设置面板不持有来源、翻译任务或图片缓存。

### 漫画加载与资源调度

- 打开目录与连续跨章共用 `getChapterPages`，依次读本地／下载副本、章节清单缓存、来源结果。清单保留重复 URL、headers、文件名与图片处理参数，旧缓存缺参数需刷新章节。
- 连续阅读按图片顺序接入相邻章，章首使用紧凑标签；章首／章尾区分加载、失败、空图片和目录边界，每方向最多一个请求。失败原地重试，普通滚动不循环重试。
- 上一章前插等待滚动停止，按章节、原图序号、裁切区域及图内偏移恢复；尺寸缓存随页移动，恢复时临时保活锚点图。后台结果等前台再提交，迟到结果和淘汰后重复章被拒绝。
- 进度按实际可见原图发布，位置校正不额外触发章节变更或资源调度。前插、图片变高和设置重排共用锚点流程；用户开始手势、翻页或自动滚动后解除定位。
- `ReaderContentStatus` 统一图片与章尾状态，保留已知尺寸或估算占位；错误可滚动、可重试，成功不留下过渡空白。
- 预取最多三任务在途，优先当前页、阅读方向三页、反向两页；换窗替换等待队列，后台清空队列，在途请求仍占槽且与显示共享。此预算不覆盖可见控件、下载服务和翻译的独立请求。
- 图片数据保留当前与相邻章节，淘汰清除压缩包图片／解码引用，页槽与顺序保留以维持位置。章节清单无有效期，签名地址失效需刷新。
- 来源限流／验证码、Cookie、代理／DNS、TLS 与地址有效期均可能导致失败。普通图片和第三方来源的截止时间、取消及 provider `timeLimit` 尚待统一；官方文本桥的 30 秒限制按请求／响应流阶段执行。

### 阅读目录与图片操作

目录从当前筛选／排序取得一次快照，按章节名或翻译组搜索；定位当前章先清词并按章节 ID 定位，不估算像素。选择当前章只关闭，选择其他章前核验记录及阅读器身份；书签通过原写入队列修改最新记录。

长按图片提供保存、分享、设为封面，明确作用于原始整页，不含译图、拆页或滤镜；图片信息取自身章节。字节复用本地／压缩包／缓存，同次只读一次，失败可显式重试。iOS 保存到应用存储位置的 Pictures，Android 保存到 Pictures/nodelane-comics。设封面沿用小于 5 MB 的既有限制，只限制该动作。保存成功禁用重复保存，分享取消不算发送成功。

## 多标签浏览器

- 开始页与空标签共用 `MobileBrowserStartPage`：品牌标识、搜索与标签总览、历史／书签快捷操作、最近三条访问及常用网站。复用 `NodeLaneBrandMark`、`NodeLaneToolbarAction`、分组行和目录标题；常用网站按 URL 去重、最多八项。逻辑空标签不创建 WebView，提交网址或搜索填入当前空标签。
- 地址使用 `MobileBrowserAddressField` 与共享输入框，网页内原位编辑；网址与域名打开 HTTP(S)，普通文字按当前引擎搜索，拒绝嵌入凭据、控制字符与不安全协议，不把这些地址转发给搜索引擎。默认 Google，支持 Bing、百度、DuckDuckGo、Yahoo、搜狗；地址框左侧显示本地品牌 Logo，点击打开带选中勾的小浮动菜单。选择独立持久化，保留编辑草稿、焦点和选择范围，取消不导航或写入。
- `BrowserLibraryStore` 在设备私有安全存储中保存网页历史、书签及引擎，与标签会话和阅读历史分离。成功加载与页内导航记录标题、URL、时间及可选网站图标地址，同一天同 URL 更新到最前，最多保留 500 条；关闭标签不删除历史。书签按 URL 去重。串行写入成功后更新界面，读取／写入失败可重试，不覆盖未读出的数据。
- 最近访问、历史和书签共用网站图标组件，标题单行省略。图标从当前 DOM 的 icon／apple-touch-icon 链接读取，优先 PNG／触屏图标，使用既有图片缓存；旧记录及仅 SVG 的页面回退同源 `/favicon.ico`，加载失败显示占位，不调用第三方图标服务。
- 历史与书签共用 `MobileBrowserLibrarySheet`，按标题／URL 本地搜索、点击重开、单条删除；历史按本地日期分组并显示时间。清空历史须确认，保留书签和网站登录。开始页与网页菜单共用入口及根导航抽屉。
- 地址栏在加载中显示停止，否则显示刷新。右上角更多采用锚定浮动菜单：顶部为前进、开始页、书签和分享快捷按钮，下方分组提供书签与历史、页内查找、复制链接、系统浏览器和清除网站登录。与引擎菜单共用主题及宽度令牌，无背景遮罩变暗，窄屏／大字可滚动。页内查找复用 `MobileBrowserFindBar` 与 WebView 查找控制器，提交关键词后显示匹配计数及前后匹配；关闭清理高亮，导航／切标签退出查找。
- 网页底栏固定后退、原图／译图与翻译设置、新建和标签；外围位置不随状态变化。工具栏高 56，紧凑地址框高 44，开始页输入至少 48。
- 标签总览为有界抽屉，两列缩略图、标题／域名、当前标记，关闭和选择独立。卡片高 244、间距 12，最多 12 标签；关闭最后一张补一个空标签，不静默删除旧页。
- `BrowserWebViewCache` 以原生 keep-alive 保留最近 3 个网页。网页路由内同时保留这 3 页的显示视图，仅当前页绘制、接收焦点和运行 Flutter 动画；切换复用控制器和翻译桥，不重挂原生视图或重设滚动位置。切标签或回开始页不按时间销毁，命中缓存保留 DOM、表单、JS 和滚动状态。超过容量按最近选择顺序 LRU 回收旧页，系统内存警告卸载并释放后台页，关闭标签显式释放；后台暂停媒体、Android 绘制和翻译资源。
- 标签总览立即打开，截图异步更新、同页截图不并发；切换不等待 JS 阅读锚点。跨路由或回收后重挂时复用已有小尺寸预览，原生页面就绪后只将预览淡出 120 ms，不给原生网页叠加透明度动画；系统减少动态效果时取消淡出。
- 回收页及应用重启后按 URL、滚动坐标和阅读锚点重新加载恢复，未提交表单和 JS 运行状态不持久化。元数据串行写入，隐藏回调与迟到锚点不覆盖位置；预览仅驻内存，每张最多 384 KiB、最多 12 张，关闭释放。
- 主框架失败提供重试与编辑，子资源失败不替代整页。清除网站登录经确认清理 WebView／本地网站 Cookie，不影响 NodeLane 软件账号。
- iOS 新窗口在导航回调转交标签入口并取消原跳转，Android 沿用原新窗口入口。图片发现、归档、原译图显示和任务生命周期见[翻译架构](TRANSLATION_ARCHITECTURE.md)。
- 验证边界：缓存和路由有自动回归测试，包括慢截图／锚点不阻塞切换、显示视图复用、LRU 及内存警告卸载。MuMu 受控 HTTP 页面已验证跨标签、跨开始页及超过 30 秒保留输入／JS／滚动状态，重复切换控制器不变；切换录屏采样区域未见白／黑空帧。已验证四页 LRU 回收与 Android 内存警告保留前台页、回收后恢复滚动位置，以及失败页切回与联网重试。渲染进程异常仅注入回调验证重建。iOS、真实手机、复杂站点长时间运行与发布构建帧率／内存收益待验收。

## 更多与设置

更多首页依次为账号摘要、吸顶搜索、常用、阅读与翻译、应用偏好、数据与管理；分类／统计／日历位于更多工具。搜索索引只包含本地化名称、路径、关键词和现有路由；直达可打开选择页或展开定位，但不执行清理、切开关或写入。子页返回保留查询和位置。

| 设置 | 行为与边界 |
| --- | --- |
| 外观 | 语言、主题、字体和日期共用可搜索选择页；纯黑模式保留隐藏混色值；缩放 85%–125%，拖动预览、结束保存。语言规则见[国际化](INTERNATIONALIZATION.md) |
| 通用／导航 | 频率与 Wi-Fi 偏好独立，隐藏保留值；DoH 开关与高级展开独立；地址原文沿用校验。拖动写新列表，不重建路由器，重启使用保存的首入口 |
| 安全 | 设备能力、验证中、失败分开显示；开关须系统认证成功。锁定页不透明并屏蔽下层语义，保留设备密码回退，取消不修改偏好 |
| 下载 | 并发 1–255、间隔 0–120 秒使用浮动滚轮；文件夹按需展开，选择／移除不自动扫描，同次只打开一个系统选择器 |
| 浏览 | 第三方检查／自动更新保留偏好；官方固定自动安装更新。18+ 缺省显示，保留用户关闭值；清空书架显式选媒体，初始不选 |
| 扩展服务 | iOS 本地解释器与代理地址分组；启动偏好不等于立即启动，手动操作后核实状态，未知结果先刷新。地址只沿用去掉一个尾斜杠的规则，允许显式空值 |
| 统计／分类／日历 | 按媒体查询，隐藏身份不按标签索引换算；分类保存合并最新记录。日历选日筛选、可恢复全部日期，只有七列日期网格限制最大文字缩放 |

### 下载队列

`MobileDownloadQueue` 组合原 `DownloadQueueScreen` 的订阅与回调：进度、拖动排序、开始／重试队列、取消单章或整部排队章节，以及设置入口。拖动区与菜单独立，底部操作可达；返回菜单选择后重新核实任务是否仍待处理。进度只使用服务已有数据。

### 小说与听书

小说工具栏提供章节进度、前后章、目录、字号、听书和设置；控件叠放且隐藏后释放焦点。字号使用 8–40 浮动滚轮；连续进度读取实际控制器范围，模式、分页和阅读记录沿用原服务。

阅读内与全局小说设置复用字体、主题、排版与颜色；页边距 0–50、行高 1.0–3.0，松手保存。单本模式在阅读内设置，全局保留自动双页偏好。听书播放器身份稳定，停止不因等待或失败禁用，关闭后的迟到初始化不开始朗读。

听书语速 0.1–1.0（两倍显示）、音调 0.5–2.0，语言来自设备列表；缺失语言保留原选择。先存偏好再调用引擎，失败显式重试；默认语言只清空偏好，不保证立即重置已初始化引擎。

### 播放器与字幕

播放器设置保留内部播放器、音频、解码、自定义按钮和 MPV 入口。AniSkip 开关与展开独立；音轨语言保存自由文本，音量增强 0–200 松手保存；解码模式保留 rawValue，不以界面选中代表设备支持。

播放设置为有界分层面板，标题与返回固定；首页进入选项后返回首页，快捷入口选中后关闭。画质、轨道、章节、倍速等仍由原播放器生成。输入焦点期间，外部偏好刷新不覆盖草稿。

自定义按钮保存名称、点击／长按／启动代码，编辑页不执行代码。MPV“恢复内置配置”从安装包恢复同名文件，独立于启用开关，失败保留显式重试。

在线字幕入口为“播放器 → 内部播放器 → 在线字幕服务”，默认关闭：

- 可选个人 Wyzie Key 或自有完整 HTTPS 服务，关闭保存清除配置；凭据使用设备安全存储，不进入备份或默认日志。
- 自有服务遵循 [Wyzie 契约](https://docs.wyzie.io/subs/usage/direct)：GET 查询包含 IMDb `id`、`encoding=utf-8`，剧集增加 `season`／`episode`；返回含 `url`、`media`、`language`、`display`、`format` 的数组。下载为 UTF-8 文本，支持 SRT／ASS／SSA／VTT／SUB／TXT。
- 服务地址不带查询、片段或内嵌凭据；同源下载可带服务令牌，跨域只使用响应的签名链接，不自动跟随重定向。
- `SubtitleCatalog` 管作品发现，`SubtitleSource` 管搜索和读取，播放器仅接收字幕文本。配置变化、关闭或离页销毁旧请求和结果；30 秒超时、元数据 2 MiB／字幕 8 MiB 是现有边界。
- NodeLane 云端个人字幕凭据接口、刷新与撤销尚未实现，不提供空来源选项。真实 IMDb／Wyzie／自有服务、原生播放及下载目录仍待验收。

### 同步与追踪

同步仅提供用户填写地址的自建服务，须实现 OAuth PKCE、`/api/version`、`/api/sync/v1` 并登记回调。关闭同步沿用原频率规则；单向上传／下载确认后重查登录和运行状态，展开说明不触发同步。

追踪账号按服务 ID 隔离，登录／退出明确操作，点击名称进入详情。条目编辑复制当前记录，异常先刷新再继续，取消／同值不提交；原首次刷新可能补建远端条目，不能视为纯读取。移除关联不删除远端条目。搜索仅显式提交，迟到结果不改写已退出界面。

Kitsu 表单仅裁剪邮箱首尾空格、密码原样传递；密码默认隐藏，失败保留草稿，取消不保存自动填充。可选追踪书库仍使用共享大标题、搜索和服务切换，分组身份包含服务、媒体、关键词及刷新代次。

## 翻译与账号设置

- 阅读器通过“阅读 → 漫画翻译”进入设置；浏览器底栏提供原图／译图和翻译面板。阅读器与网页共用 `TranslationControlsContent`、单图菜单和 `NodeLaneCatalogSheet`。
- 首次显示原图，自动翻译默认开。前台同时显示译图且开关开启才自动送译；切回原图暂停新增工作，保留开关。关闭自动翻译仍可读缓存和手动操作。
- `TranslationImageStatus` 仅为等待、处理和异常显示左上胶囊；失败重试、未知核实、读取失败重新读取。成功、无文字和未送译无标记，重译在长按菜单内。
- 原生状态在滤镜外显示，网页注入共享主题与文字缩放并用 Shadow DOM 隔离样式；滚动／移动取消长按，动作核验文档和图片修订，切换保留阅读位置。
- 目标语言与界面语言共用 [17 种语言定义](../lib/l10n/languages.dart)，各自保存；`TranslationLanguageRow` 统一选择入口，取消／同值不写入。任务与缓存规则由[翻译服务](TRANSLATION_ARCHITECTURE.md)维护。
- 更多摘要打开 `MobileNodeLaneAccountPage`，显示账号名和一行套餐；未知套餐保留服务名称。详情显示 ID、订阅和免费／订阅／购买三类额度，未知、零和不限量分别表达。
- 账号读取 `GET /v1/me`、`GET /v1/billing/status`，共享快照和一次在途读取；失败保留同账号成功信息，换号／退出取消读取并清快照。官网管理通过系统浏览器打开公开地址，返回刷新一次，不传应用凭据或发起计费变更。

## 关于与应用更新

关于页展示品牌、实际安装版本、更新及项目帮助，诊断按需展开。`NodeLaneBrand` 集中产品标识和仓库地址，品牌资源见[素材说明](design/nodelane-brand-assets.md)。

检查更新与提醒统一进入 `/appUpdate`；提醒只返回查看／稍后的决定。更新页先恢复本地任务，已有发布信息可复用，更新说明和滚动位置不随任务刷新重置。空结果不宣称最新版，检查失败可重试。

Android 显示下载、等待、失败、安装和权限操作；其他平台通过浏览器打开清单地址。下载查询仅页面可见、前台且任务进行中时每秒一次，隐藏后停止查询但系统下载继续；已下载包安装不依赖清单服务器。协议、签名、平台身份和打包方式集中在[发行与更新](APP_UPDATES.md)。

## 应用链接

各平台使用 `nodelane-comics` 协议，Windows 注册当前可执行文件，Linux 桌面入口传 `%u`。导入入口为 `nodelane-comics://add-repo` 与 `nodelane-comics://add-button`：

- 来源参数为 `repo_name`、`repo_url` 和可重复的 `manga_url`／`anime_url`／`novel_url`；按钮使用可重复的 Base64 JSON `button`。确认实际地址或代码后才写入。
- 拒绝凭据、端口、子路径和片段，登录回调不进入导入。仅确认／保存期间去重，完成、取消或失败释放；冷启动等首帧导航就绪再处理。

| 登录入口 | 回调与协议 |
| --- | --- |
| NodeLane | `nodelane-comics://nodelane-auth`，Native public client，PKCE／state 与系统安全存储 |
| AniList | `nodelane-comics://anilist-auth`，自有 Client ID `55972`，Implicit Grant、独立 state，不内置 Client Secret |
| MyAnimeList | `nodelane-comics://myanimelist-auth`，iOS／Android／Other 使用各自 Client ID，PKCE plain、独立 verifier 和 state |
| Simkl | `nodelane-comics://simkl-auth`，AUTH V2、S256 PKCE，核对 `iss=https://simkl.com` 和 `media:read media:write` |
| Trakt | 登录隐藏；缺少自有 Client ID 与 PKCE／HTTPS 回调，相关网络功能不可用，本地记录保留 |
| 自建同步 | 移动端 `nodelane-comics://oauth-callback`，桌面 `http://localhost:48765/callback`，由部署者登记 |

追踪凭据绑定服务与 Client ID，旧身份不复用。`TrackerOAuthBrowser` 在手机／macOS 使用系统会话，在 Windows／Linux 使用外部浏览器及协议监听；监听在完成、失败、释放或十分钟超时后取消，校验回调与唯一参数后保存账号。

Simkl 续期共用一次在途请求；401 先重读新令牌，必要时续期并最多重发一次，未知写入结果或网络错误不自动重放。明确失效才要求重新登录，切号／退出后的迟到结果不回写。真实授权的验证边界见文末。

## 备份、恢复与存储

- 默认文件目录：Android `/storage/emulated/0/nodelane-comics`、桌面 Documents/nodelane-comics、iOS 本应用 Documents。数据库名为 `nodelane-comics`；macOS 位于 Application Support/nodelane-comics/databases，Windows／Linux 位于默认目录的 databases，iOS 位于 Documents/databases，Android 使用应用私有目录。
- 本地来源使用当前配置目录；iOS 旧沙盒路径仅在当前 Documents／Library／tmp 中按相同相对路径核对，不按名称搜全盘。目录授权书签键为 `com.nodelane.comics.local_directory_bookmarks`。不读取、搬迁或删除上游旧数据库。
- 备份和维护快照为 `nodelane-comics_<时间>.backup`，ZIP 内含同名 `.backup.db`，JSON 结构版本为 2；不识别上游旧前缀或结构版本 1，独立 Mihon／Aniyomi／Kotatsu／Neko 导入保留。
- 存储页提供创建、恢复、自动备份、章节／封面／译图缓存及下载位置。封面清理只删 `cacheimagecover`，译图清理保留回执和任务；操作经确认，不因展开执行。
- 创建备份沿用书库、设置、扩展选择，选择即时保存且供自动备份共用；执行时固定快照，敏感设置不自动勾选。密码原文保留，隐藏输入需核对两次，只有存储成功才开启加密。
- 恢复沿用合并／替换、分类冲突、未匹配来源选择、安全快照与同步询问。取消当前选择不提交该选择，但解码阶段可能已保存内嵌密码，不能承诺全流程零副作用。
- 来源维护按原对象与 ID 操作，缺失来源进入迁移预览；删除确认显示影响范围，历史／下载默认不保留，有来源 ID 时默认卸载扩展。重复合并保留原聚类和主条目规则。
- 回滚显示最多三份原安全快照，明确替换数据且无法恢复下载文件；成功后沿用原快照清理。写入处理中防重入，失败不自动重复，快照成功写入后立即刷新列表。

## 设计参考与素材

图稿只指导布局，文字、账号、网站和漫画是示例，实际数据取自应用。当前实现与令牌优先；设计图不是运行截图，也不作为运行时切图。图旁提示词保留生成来源与输入；主要使用 OpenAI `gpt-image-2.6-sunburst` 或提示词中注明的内置生成工具。

| 范围 | 当前参考与生成输入 |
| --- | --- |
| 基础组件 | [材质](design/mobile-foundations-materials.png)／[输入](design/mobile-foundations-materials.prompts.txt)，[控件](design/mobile-foundations-components.png)／[输入](design/mobile-foundations-components.prompts.txt) |
| 根页面 | [书架／更新／来源](design/mobile-titleless-library-updates-sources.png)／[输入](design/mobile-titleless-library-updates-sources.prompts.txt)，[浏览器／更多／追踪](design/mobile-titleless-browser-more-tracking.png)／[输入](design/mobile-titleless-browser-more-tracking.prompts.txt) |
| 来源 | [发现与筛选](design/mobile-titleless-source-discovery.png)／[输入](design/mobile-titleless-source-discovery.prompts.txt)，[仓库管理](design/mobile-titleless-source-management.png)／[输入](design/mobile-titleless-source-management.prompts.txt)，[当前卡片](design/mobile-source-cards-v3.png) |
| 搜索 | [跨来源](design/cross-source-search-v3.png)／[输入](design/cross-source-search-v3.prompts.txt) |
| 浏览器 | [开始页](design/ios-browser-empty-tabs-concept.png)、[状态](design/ios-browser-secondary-states-concept.png)／[输入](design/ios-browser-empty-tabs.prompts.txt)；地址以当前原位输入为准 |
| 模态与通知 | [模态生成输入](design/ios-modal-system-concepts.prompts.txt)、[通知生成输入](design/ios-notifications-concepts.prompts.txt) |
| 书架与详情 | [书架控件](design/ios-bookshelf-components-concept.png)／[输入](design/ios-bookshelf-refinement.prompts.txt)，[详情](design/ios-manga-detail-concept.png)／[输入](design/ios-manga-detail-concept.prompts.txt)，[加载](design/ios-manga-loading-concept.png)／[输入](design/ios-manga-loading-concept.prompts.txt) |
| 阅读与翻译 | [阅读设置](design/reader-settings-redesign/design.md#设计参考)，[连续跨章](design/ios-reader-continuity-concept.png)／[输入](design/ios-reader-continuity-concept.prompts.txt)，[图内翻译](design/mobile-inline-translation.png)／[输入](design/mobile-inline-translation.prompts.txt) |
| 设置与引导 | [账号生成输入](design/ios-settings-account-concepts.prompts.txt)、[搜索框](design/ios-settings-search-v2.png)／[输入](design/ios-settings-search-v2.prompts.txt)、[欢迎页](design/ios-onboarding-welcome-concept.png)／[输入](design/ios-onboarding-welcome-concept.prompts.txt) |
| 导航、下载与更新 | [Android 底栏](design/android-unified-glass.png)／[输入](design/android-unified-glass.prompts.txt)，[下载队列](design/ios-download-queue-concept.png)／[输入](design/ios-download-queue-concept.prompts.txt)，[软件更新](design/software-update.png)／[输入](design/software-update.prompts.txt) |

详情的可运行预览入口为 `test/fixtures/detail_overview_preview.dart`，使用正式组件和示例元数据；通过 `flutter run --print-dtd --target=test/fixtures/detail_overview_preview.dart` 检查平台字体，组件参数 `loading` 用于目录等待状态。预览不初始化数据库或联网。

## 验证边界与待办

按改动运行 `test/modules/` 中对应行为回归及 `test/widgets/nodelane_*_test.dart` 的共享控件检查；设备结果按平台、构建和实际操作报告，不由模拟测试或构建成功外推。

| 范围 | 已有验证范围 | 仍需验收 |
| --- | --- | --- |
| 共享组件 | 单元／widget 覆盖草稿、重复提交、迟到结果、字段合并、释放、窄屏大字号、RTL、深浅色；iOS 模拟器检查输入、选择、滚轮、通知及键盘避让 | Android 各细项运行、完整读屏、原生 Reduce Transparency 联动 |
| 书架与阅读 | iOS 模拟器检查常规书架／详情、本地阅读、设置、双向跨章、前插／变高后的锚点和故障重试；设置细项见[阅读验证](design/reader-settings-redesign/design.md#验证与边界) | Android 阅读设置交互、全模式／格式、长章节、真实分类／书签／删除／导出及恢复 |
| 来源与网页 | iOS 模拟器检查开始页、原位输入、标签及部分恢复；DOM 夹具覆盖桥接；Android 真实翻译与归档范围见[翻译验证](TRANSLATION_ARCHITECTURE.md#验证与待办)，站点验收见[来源文档](SOURCE_PLUGINS.md#代码与验证入口) | 动态站点登录、清除登录、系统回收恢复、iOS 归档与真实送译 |
| 设置与账号 | iOS 模拟器检查导航、表单、部分偏好重启保留和已有账号摘要；系统认证仅调起／取消；OAuth 回调、续期和隔离使用模拟测试 | 真实重新登录／退出、第三方授权、成功启锁、目录授权与扫描 |
| 迁移、追踪与数据 | 临时数据库／内存仓库覆盖选择、失败、合并、备份格式与释放 | 真实迁移、同步、追踪写入、备份加解密、回滚与文件失败恢复 |
| 下载、播放与听书 | 下载与播放器设置使用替身；小说样例检查实际语音暂停／停止及同进程恢复 | 真实下载、原生音视频／字幕／解码、完整 EPUB 和在线小说、队列触摸拖动 |
| 平台与发行 | iOS／Android 模拟器有常规界面与底栏检查；iPhone 仅验证侧载安装与首次启动；构建与更新范围见[发行验证](APP_UPDATES.md#验证边界) | 两平台完整真机功能、其他 API／ABI、TV、大书库内存／帧率／耗电 |

浏览器验证：单元／widget 覆盖地址与搜索分流、六引擎编码及 Logo／ICO 解码、历史去重与容量、图标持久化与旧记录兼容、串行清除、存储失败重试、书签隔离、根／嵌套导航选择、切换／取消保留输入与选区、键盘避让、窄屏大字号菜单与查找。MuMu Android debug 已实测开始页与六家 Logo 菜单、切换引擎保留草稿、右上角浮动菜单及历史入口、网站图标和长标题省略、真实 Google／Bing 页面、书签、页内查找，以及热重启后引擎／历史／书签保留；热重载成功且未发现运行时错误。iOS、真实手机、其余搜索引擎网络访问、软键盘设备交互、系统分享及进程回收恢复仍需验收。

待解决：

- 轻点进度条后切换阅读方向偶发回到首页，完整拖动未复现。
- 日历格式切换的控件测试仍触发 `Build scheduled during frame`，不计入通过范围。
- comix.to 重开页面的位置恢复、大页面归档峰值与特殊图片格式见[翻译待办](TRANSLATION_ARCHITECTURE.md#验证与待办)。
- 统一第三方来源与普通图片的截止时间和取消；跨来源首屏的纵向虚拟化与大量来源内存需要测量。
- 本地包临时文件被系统清理后的重装恢复和持久导入策略、数据写入中的后台与进程回收仍需验证。
- 更多与可选追踪根页需继续按当前图稿复核；播放器主控件、字幕外观和真实引擎应用需完整检查。NodeLane 云端字幕凭据、Trakt 自有授权与 Discord 自有应用配置尚未接入。
