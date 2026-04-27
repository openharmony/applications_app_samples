# 输入源项目

### 介绍

输入源应用是一个面向 OpenHarmony 电视设备的输入源示例工程，覆盖以下核心能力：

- HDMI / AV / DTV 等输入源展示与切换；
- 输入源信号检测、无信号状态处理与自动恢复；
- 页面生命周期联动（进入/离开页面时的绑定、解绑定、事件发布）；
- TV 专有接口联动（`@ohos.tvservice.*`）与 Native 渲染组件协同。

应用入口位于 `entry/src/main/ets/entryability/EntryAbility.ets`，输入源主页面位于
`entry/src/main/ets/pages/Index.ets`，HDMI 页面位于 `entry/src/main/ets/pages/HdmiPage.ets`，
并通过 `entry/src/main/cpp` 下的 Native 模块参与渲染与底层能力扩展。

使用说明：

1. 安装并启动应用，按设备要求授予输入源相关权限。
2. 进入首页后可查看可用输入源并执行切换。
3. 进入 HDMI/DTV 页面后，应用会自动进行信号检查与播放状态处理。
4. 发生无信号时，页面会展示无信号提示并支持返回输入源列表。

### 截图预览
![](./entry/src/main/resources/base/media/page_bg.png)

### 工程目录
```text
entry/src/main/ets/
|---entryability/
|   |---EntryAbility.ets             // 应用主入口 Ability
|---common
|   |---AutomatedSearch.ets          // 自动搜索逻辑
|   |---DeleteChannel.ets            // 删台逻辑
|   |---DtvNoChannel.ets             // 无频道状态
|   |---PointerUtil.ets              // 指针样式工具
|---model
|   |---BaseModel.ets                // 业务基础模型
|   |---InputSourceModel.ets         // 输入源模型
|---manager
|   |---SourceManager.ets            // 输入源管理
|   |---PlayerManager.ets            // 播放与事件管理
|   |---DtvManager.ets               // DTV 业务管理
|---pages
|   |---Index.ets                    // 输入源首页
|   |---HdmiPage.ets                 // HDMI 页面
|   |---SearchPage.ets               // 搜索页
|   |---NoSignal.ets                 // 无信号页
|---controller
|   |---SourceListController.ets     // 输入源列表控制器
|---utils
|   |---InputSourceUtil.ets          // 输入源工具
|   |---SettingUtil.ets              // 设置读写与事件发布
|   |---KeyEvent.ets                 // 按键注入
|---sdk
|   |---DtvSdk.ets                   // TV 专有声明

entry/src/ohosTest/ets/test/
|---List.test.ets                    // 测试入口
|---*.test.ets                       // Hypium 单元与场景测试
```

### 具体实现

- 首页能力封装在 [Index.ets](entry/src/main/ets/pages/Index.ets)，负责输入源入口展示、焦点与跳转控制。
- HDMI 业务封装在 [HdmiPage.ets](entry/src/main/ets/pages/HdmiPage.ets)：
    * 进入页面后绑定输入源并检查信号状态；
    * 根据信号状态切换“播放态 / 搜索态 / 无信号态”；
    * 处理返回键与 CEC 相关行为。
- 输入源与设备侧能力封装在 [SourceManager.ets](entry/src/main/ets/manager/SourceManager.ets)：
    * 查询支持输入源、可用输入源与设备时序信息；
    * 管理输入源相关监听器。
- 播放与事件发布封装在 [PlayerManager.ets](entry/src/main/ets/manager/PlayerManager.ets)：
    * 统一输入源绑定/解绑定；
    * 统一发布播放开始/结束事件。
- DTV 核心逻辑封装在 [DtvManager.ets](entry/src/main/ets/manager/DtvManager.ets)，负责搜索、频道列表和频道操作。

### 相关权限

| 权限名                                              | 权限说明                                 | 级别 |
|--------------------------------------------------|--------------------------------------|------|
| ohos.permission.MANAGE_MISSIONS                  | 任务栈管理能力                              | system_basic |
| ohos.permission.MANAGE_SECURE_SETTINGS           | 系统设置管理能力                            | system_basic |
| ohos.permission.INTERNET                         | 网络访问能力                              | normal |
| ohos.permission.ACCESS_NOTIFICATION_POLICY       | 通知策略访问能力                            | system_basic |
| ohos.permission.MODIFY_AUDIO_SETTINGS            | 音频设置修改能力                            | system_basic |
| ohos.permission.MANAGE_AUDIO_CONFIG              | 音频配置管理能力                            | system_basic |

### 依赖

- OpenHarmony API（ArkUI/AbilityKit/BasicServicesKit/InputKit 等）
- Native 构建链（`CMakeLists.txt` + `libentry.so`）
- TV 专有声明（`entry/src/main/ets/sdk/DtvSdk.ets`，用于 `@ohos.tvservice.*` 类型承载）
- 测试框架：Hypium（`entry/src/ohosTest`）

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568, V900。

2.本示例为Stage模型，支持API10版本SDK，SDK版本号(API Version 12 Release),镜像版本号(5.0 Release)

3.本示例需要使用DevEco Studio 版本号(5.0 Release)及以上版本才可编译运行。

4.本示例涉及部分接口需要配置系统应用签名，可以参考[特殊权限配置方法](https://gitcode.com/openharmony/docs/blob/master/zh-cn/device-dev/subsystems/subsys-app-privilege-config-guide.md)
，把配置文件中的“apl”字段信息改为“system_core”。

`

### 下载

如需单独下载本工程，执行如下命令：

```bash
git init
git config core.sparsecheckout true
echo code/SystemFeature/TV/TVInputSource > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
