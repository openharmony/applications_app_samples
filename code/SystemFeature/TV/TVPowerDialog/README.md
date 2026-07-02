# TVPowerDialog

### 介绍

本示例主要展示了TV形态下电源对话框功能，使用[@ohos.power](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-basic-services-kit/js-apis-power.md)、
[@ohos.commonEventManager](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-basic-services-kit/js-apis-commonEventManager.md)、
[@ohos.app.ability.UIExtensionAbility](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/js-apis-app-ability-uiExtensionAbility.md)、
[@ohos.app.ability.UIAbility](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/js-apis-app-ability-uiAbility.md)、
[@ohos.display](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkui/js-apis-display.md)、
[@ohos.hilog](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-performance-analysis-kit/js-apis-hilog.md)、
[@kit.InputKit](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-input-kit/js-apis-pointer.md)、
[@kit.ImageKit](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-image-kit/js-apis-image.md)
等接口，实现了熄屏、关机、重启等系统电源操作功能，支持遥控器焦点导航和鼠标悬停交互方式。

### 效果预览

| 电源对话框                         |
|-------------------------------|
| ![](screenshots/figure1.jpeg) |

使用说明：
编译前将[api](apis)目录下的文件替换sdk对应文件

1. 设备正常启动后，通过长按电源键或系统触发方式弹出电源对话框.
2. 在电源对话框中，使用遥控器方向键或鼠标在各选项间切换焦点，选中项会高亮显示.
3. 遥控器选中"熄屏"按钮并确认，屏幕熄灭并发送熄屏公共事件.
4. 遥控器选中"关机"按钮并确认，设备正常关机.
5. 遥控器选中"重启"按钮并确认，设备正常重启.
6. 鼠标悬停至各按钮上时，按钮高亮且鼠标样式切换为点击样式.
7. 按遥控器返回键或系统返回手势，可关闭电源对话框.

### 工程目录

```
entry/src/main/ets/
|---Application
|   |---MyAbilityStage.ets                   // 应用级AbilityStage
|---MainAbility
|   |---MainAbility.ets                      // 主Ability
|---ServiceExtAbility
|   |---PowerDialogAbility.ets               // 电源对话框UIExtensionAbility
|---common
|   |---CommonEventUtil.ets                  // 公共事件工具
|   |---Constant.ets                         // 常量定义
|   |---EventUtil.ets                        // 事件工具
|   |---KeyCode.ets                          // 按键码枚举
|   |---Logger.ets                           // 日志工具
|   |---PointerUtil.ets                      // 鼠标指针工具
|---model
|   |---PowerItemInfo.ets                    // 电源选项数据模型
|---pages
|   |---PowerDialog.ets                      // 电源对话框主页面
|   |---Transparent.ets                      // 透明占位页面
```

### 具体实现

* 电源对话框页面功能在PowerDialog中实现，源码参考：[PowerDialog.ets](entry/src/main/ets/pages/PowerDialog.ets)
    * 使用@ohos.power中的power.shutdown()接口实现关机功能.
    * 使用@ohos.power中的power.reboot()接口实现重启功能.
    * 使用@ohos.power中的power.suspend()接口实现熄屏功能.
    * 通过@ohos.commonEventManager中的commonEvent.publish()接口发布熄屏公共事件，通知SystemUI模块执行熄屏逻辑.

* 电源对话框通过UIExtensionAbility方式承载，参考[PowerDialogAbility.ets](entry/src/main/ets/ServiceExtAbility/PowerDialogAbility.ets)
    * 继承UIExtensionAbility，在onSessionCreate中加载pages/powerDialog页面.
    * 通过session.setWindowBackgroundColor()设置窗口背景为透明.
    * 使用LocalStorage将session传递给子组件，用于对话框的terminateSelf等操作.

* 遥控器交互支持通过onKeyEvent事件实现，源码参考：[PowerDialog.ets](entry/src/main/ets/pages/PowerDialog.ets)
    * 监听onKeyEvent事件，处理遥控器方向键和确认键（KEY_ENTER）.
    * 通过onFocus和onBlur事件控制按钮的焦点状态.

* 鼠标交互支持通过onHover和onTouch事件实现，源码参考：[PowerDialog.ets](entry/src/main/ets/pages/PowerDialog.ets)
    * 使用onHover事件实现鼠标悬停时按钮高亮效果.
    * 通过PointerUtil.changePointStyle()
      切换鼠标指针样式，源码参考：[PointerUtil.ets](entry/src/main/ets/common/PointerUtil.ets).
    * 使用pointer.setCustomCursorSync()设置自定义鼠标样式.

* 电源选项的数据模型定义在PowerItemInfo中，源码参考：[PowerItemInfo.ets](entry/src/main/ets/model/PowerItemInfo.ets)
    * 使用@Observed装饰器实现数据变化监听，驱动UI刷新.
    * 包含图标、焦点图标、焦点状态、名称、操作类型等属性.

### 相关权限

[ohos.permission.REBOOT](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionreboot)

[ohos.permission.POWER_MANAGER](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/AccessToken/permissions-for-system-apps.md#ohospermissionpower_manager)

### 依赖

本示例通过commonEvent.publish()发布熄屏事件，依赖SystemUI模块接收并处理熄屏逻辑.

### 约束与限制

1. 本示例仅支持OpenHarmony标准系统上运行，支持设备：RK3568.
2. 本示例为Stage模型，支持API 18版本SDK，版本号：4.1.0.
3. 本示例需要使用DevEco Studio（5.0.3.900）及以上版本才可编译运行.
4. 本示例涉及系统接口（sysDialog/power类型的UIExtensionAbility），需要配置系统应用签名，
可以参考[特殊权限配置方法](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/security/hapsigntool-overview.md)
，把配置文件中的"app-feature"字段信息改为"hos_system_app".
5. 本示例中的电源操作（关机、重启、熄屏）仅在真机上有效，模拟器不支持相关功能.

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/SystemFeature/TV/TVPowerDialog/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
