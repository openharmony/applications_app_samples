# TVPhotos 测试用例归档

## 用例表

| 测试功能 | 预置条件 | 输入 | 预期输出 | 是否自动 | 测试结果 |
|---|---|---|---|---|---|
| 应用启动与 Ability 契约校验 | 1. 完成工程编译 <br/> 2. 安装主应用与 `entry_test` 测试包 <br/> 3. 可正常拉起 TV 应用 | 执行 `Ability.test.ets` | 校验 `EntryAbility`、`MainAbility`、`PickerAbility` 的启动参数、关闭逻辑与存储清理行为符合预期 | 是 | Pass |
| 首页入口与核心标签校验 | 1. 完成工程编译 <br/> 2. 安装主应用与 `entry_test` 测试包 <br/> 3. TV 设备可进入首页 | 执行 `Index.test.ets` | 首页可正常拉起，首页标签、菜单候选与旋转矩阵等核心信息可被正确识别 | 是 | Pass |
| 首页选择与菜单交互校验 | 1. 完成工程编译 <br/> 2. 安装主应用与 `entry_test` 测试包 <br/> 3. TV 遥控按键事件可用 | 执行 `HomeSelectionInteraction.test.ets` | 首页选择、菜单弹出、焦点切换与编辑入口行为正确 | 是 | Pass |
| 相册导航交互校验 | 1. 完成工程编译 <br/> 2. 安装主应用与 `entry_test` 测试包 <br/> 3. 相册页可正常进入 | 执行 `AlbumNavigationInteraction.test.ets` | 相册卡片焦点移动、分类切换与页面跳转逻辑正确 | 是 | Pass |
| 本地媒体加载校验 | 1. 完成工程编译 <br/> 2. 安装主应用与 `entry_test` 测试包 <br/> 3. 设备存在本地媒体样本或模拟数据 | 执行 `LocalMediaLoader.test.ets` | 本地媒体加载顺序、分页、缓存和结果集处理符合预期 | 是 | Pass |
| 本地页面交互校验 | 1. 完成工程编译 <br/> 2. 安装主应用与 `entry_test` 测试包 <br/> 3. 可进入本地媒体页面 | 执行 `LocalPageInteraction.test.ets` | 本地页面的焦点流转、翻页、选中与状态更新行为正确 | 是 | Pass |
| 照片列表交互校验 | 1. 完成工程编译 <br/> 2. 安装主应用与 `entry_test` 测试包 <br/> 3. 相册内存在可浏览媒体数据 | 执行 `PhotoListInteraction.test.ets` | 照片列表的选择、全选、删除、分享、返回处理、网格焦点移动与预览跳转逻辑正确 | 是 | Pass |
| 最近删除与预览校验 | 1. 完成工程编译 <br/> 2. 安装主应用与 `entry_test` 测试包 <br/> 3. 最近删除或预览页面可进入 | 执行 `TrashAndWatchInteraction.test.ets` | 最近删除页面与图片/视频预览页面的焦点、操作与返回逻辑正确 | 是 | Pass |
| 分布式分享与接收校验 | 1. 完成工程编译 <br/> 2. 安装主应用与 `entry_test` 测试包 <br/> 3. 网络与分布式能力可用 | 执行 `DistributedAndReceiveInteraction.test.ets` | 分布式分享、接收弹窗、进度展示、设备选择和接收完成状态处理正确 | 是 | Pass |
| NAS 客户端交互校验 | 1. 完成工程编译 <br/> 2. 安装主应用与 `entry_test` 测试包 <br/> 3. 同一网络存在可访问 NAS 或已配置模拟对象 | 执行 `NasClientInteraction.test.ets` | NAS 登录、鉴权、对话框交互、失败处理与客户端状态切换逻辑正确 | 是 | Pass |
| NAS 会话交互校验 | 1. 完成工程编译 <br/> 2. 安装主应用与 `entry_test` 测试包 <br/> 3. NAS 会话能力可初始化 | 执行 `NasSessionInteraction.test.ets` | NAS 会话建立、文件浏览、断连恢复和状态同步逻辑正确 | 是 | Pass |
| 基础能力校验 | 1. 完成工程编译 <br/> 2. 安装主应用与 `entry_test` 测试包 | 执行 `Foundation.test.ets` | 基础测试数据、断言工具、焦点矩阵、覆盖计划与通用测试辅助能力正确 | 是 | Pass |
| 业务场景目录校验 | 1. 完成工程编译 <br/> 2. 安装主应用与 `entry_test` 测试包 | 执行 `BusinessScenarioCatalog.test.ets` | 业务场景目录定义完整，可映射首页、本地、NAS、分布式等主要业务链路 | 是 | Pass |
| 启动链路目录校验 | 1. 完成工程编译 <br/> 2. 安装主应用与 `entry_test` 测试包 | 执行 `LaunchChainCatalog.test.ets` | 主能力、选择器能力、入口能力等启动链路矩阵与场景域定义完整 | 是 | Pass |

