# StageServiceWidgetCards测试用例归档

## 用例表

|测试功能|预置条件|输入|预期输出|是否自动|测试结果|
|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|--------------------------------|
|关闭应用|应用正常启动|根据坐标点击屏幕上的返回按钮|应用返回到桌面|否|Pass|
|添加卡片|桌面存在app|长按app，点击服务卡片选项。右滑选择"This is a service widget with animation property."描述卡片，并点击“添加到桌面”。|页面中成功添加属性动画卡片| 是       |Pass|
| 在桌面卡片内测试动画效果            | 桌面上已有一张属性动画卡片 | 点击“改变旋转角度”按钮 | 按钮产生旋转动画效果   | 否       | Pass |
| 添加卡片 | 桌面存在app | 长按app，点击服务卡片选项。右滑选择"This is a service widget with page custom drawing."描述卡片，并点击“添加到桌面”。 | 页面中成功添加自定义绘制能力卡片 | 是 | Pass |
| 测试卡片使用自定义绘制能力 | 桌面上已有一张卡片 | 观察卡片显示 | 显示蓝色笑脸 | 否 | Pass |
| 添加卡片                              | 桌面存在app                    | 长按app，点击服务卡片选项。右滑选择使用"This is a service widget for router event."描述卡片，并点击“添加到桌面”。 | 页面中成功添加router event卡片 | 是 | Pass |
| 测试使用router事件跳转到指定UIAbility | 桌面上已有一张卡片         | 先后点击“功能A”，“功能B”按钮                                  | 先后分别跳转到<功能A>，<功能B>页面                             | 否 | Pass |
| 添加卡片                              | 桌面存在app                    | 长按app，点击服务卡片选项。右滑选择"This is a service widget update by message."描述卡片，并点击“添加到桌面”。 | 页面中成功添加通过message事件刷新卡片内容卡片                | 是       | Pass |
| 测试通过message事件刷新卡片内容       | 桌面上已有一张卡片           | 点击“Update”按钮                                             | title信息更新为'Title Update.'文字信息更新为'Description update success.' | 否 | Pass |
| 添加卡片 | 桌面存在app | 长按app，点击服务卡片选项。右滑选择"This is a service widget using callee to pull UIAbility"描述卡片，并点击“添加到桌面”。 | 页面中成功添加使用call事件拉起指定UIAbility到后台卡片 | 是 | Pass |
| 使用call事件拉起指定UIAbility到后台 | 桌面上已有一张卡片 | 先后点击“功能A”，“功能B”按钮 | 先后分别后台打印FunACall param及FunBCall param | 否 | Pass |
| 添加卡片 | 桌面存在app | 长按app，点击服务卡片选项。右滑选择"Update Card By Router or Call"描述卡片，并点击“添加到桌面”。 | 页面中成功添加通过router或call事件刷新卡片内容卡片 | 是 | Pass |
| 通过router或call事件刷新卡片内容 | 桌面上已有一张卡片 | 1. 点击“router事件跳转”按钮；点击Home键返回桌面，查看卡片内容2. 点击“callee拉至后台”按钮，查看卡片内容 | 1. 拉起对应UIAbility；内容从“init”更新为“RouterFromCard”:UIAbility2. 内容从“init”更新为“CallFrom” | 否 | Pass |
| 添加卡片                              | 桌面存在app                    | 长按app，点击服务卡片选项。右滑选择"Update duration"描述卡片，并点击“添加到桌面”。 | 页面中成功添加定时刷新卡片      | 是 | Pass |
| 测试卡片定时刷新能力                  | 桌面上已有一张卡片         | 等待30min后观察卡片显示                                      | 标题从‘Title default’更新为'Title Update.'文字从‘定时刷新’更新为'Description update success.' | 否 | Pass |
| 添加卡片                              | 桌面存在app                    | 长按app，点击服务卡片选项。右滑选择"Scheduled update time"描述卡片，并点击“添加到桌面”。 | 页面中成功添加定点刷新卡片                 | 是 | Pass |
| 测试卡片定点刷新能力                  | 桌面上已有一张卡片         | 配置文件中配置10:30时刻更新，等待到该时间后观察卡片显示             | 标题从‘Title default’更新为'Title Update.'文字从‘定点刷新’更新为'Description update success.' | 否 | Pass |
| 添加卡片                              | 桌面存在app                    | 长按app，点击服务卡片选项。右滑选择"Next refresh time"描述卡片，并点击“添加到桌面”。 | 页面中成功添加下次刷新时间卡片       | 是 | Pass |
| 测试卡片固定时间后刷新能力            | 桌面上已有一张卡片         | 点击<Update>按钮，等待5min后观察卡片显示                     | 标题从‘Title default’更新为'Title Update.'文字从‘Description default’更新为'Description update success.' | 否 | Pass |
| 添加卡片                              | 桌面存在app                    | 长按app，点击服务卡片选项。右滑选择"Widget image update"描述卡片，并点击“添加到桌面”。 | 页面中成功添加<刷新本地图片和网络图片>的卡片          | 是 | Pass |
| 刷新本地图片和网络图片                | 桌面上已有一张卡片         | 点击“刷新”按钮                                               | 在服务卡片滑动选择时显示默认图片；添加到桌面后显示本地图片；刷新后更新为网络下载图片     | 否 | Pass |
| 添加卡片                              | 桌面存在app                    | 长按app，点击服务卡片选项。右滑选择"widget update by status"描述卡片，并点击“添加到桌面”。 | 页面中成功添加<根据卡片状态刷新不同内容>的卡片        | 是 | Pass |
| 根据卡片状态刷新不同内容              | 桌面上已有两张卡片         | 在已添加的两张卡片中分别勾选“状态A”及“状态B”，等待一小时后观察卡片显示 | 卡片中只更新状态A文字“待刷新”为“AAA”；卡片中只更新状态B文字“待刷新”为“BBB”  | 否 | Pass |
| 安装应用 | 安装“共享数据”应用 | 安装“共享数据”应用hap包，进入主页面 | 页面中成功添加“更新过程数据”按钮 | 否 | Pass |
| 添加卡片                               | 桌面存在app                | 长按app，点击服务卡片选项。右滑选择"Widget update by proxy with persistent data"描述卡片，并点击“添加到桌面”。 | 页面中成功添加<卡片代理刷新(持久化数据)>的卡片，卡片中央内容显示“a” | 是 | Pass |
| 添加卡片                              | 桌面存在app                    | 长按app，点击服务卡片选项。右滑选择"Widget update by proxy with process data"描述卡片，并点击“添加到桌面”。 | 页面中成功添加<卡片代理刷新(过程数据)>的卡片，卡片中央内容显示“加载中...” | 是 | Pass |
| 在桌面应用里刷新卡片 | 已安装数据更新应用 | 返回“共享数据”应用主页面，点击<更新持久化数据>，点击Home键返回桌面，观察卡片显示 | 弹出“更新持久化数据成功”提示。卡片中央内容刷新，从“a”更新为”snow“，该过程卡片提供方应用没有被拉起 | 否 | Pass |
| 在桌面应用里刷新卡片                | 已安装数据更新应用             | 返回“共享数据”应用主页面，点击<更新过程数据>，点击Home键返回桌面，观察卡片显示 | 弹出“更新过程数据成功”提示。卡片中央内容刷新，从“加载中...”更新为”Qing“，该过程卡片提供方应用没有被拉起 | 否       | Pass |
| 使用方刷新卡片内容（仅对系统应用开放） | 无 | 由于卡片ets文件中无法使用requestForm接口，故该功能无法测试。 | 无 | 否 | Pass |
| 添加卡片                              | 桌面存在app                    | 长按app，点击服务卡片选项。右滑选择"JS UI widget development"描述卡片，并点击“添加到桌面”。 | 页面中成功添加<开发基于JS UI的卡片>的卡片                    | 是 | Pass |
| JS卡片内容刷新                        | 桌面上已有一张卡片           | 等待30min后观察卡片显示                                      | title从“titleOnCreate”刷新为“titleOnUpdate”;文字内容从“detailOnCreat”刷新为“detailOnUpdate” | 否       | Pass |
|                                       |                                |                                                              |                                                              |          |          |
