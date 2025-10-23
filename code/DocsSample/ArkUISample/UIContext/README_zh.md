# 使用UI上下文接口操作界面（UIContext）指南文档示例

### 介绍

本示例通过使用[ArkUI指南文档](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui)中各场景的开发示例，
展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

1. [使用UI上下文接口操作界面（UIContext）](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-global-interface.md)。

### 效果预览

| index.ets                 |      LocalStoragePage.ets                 |
|---------------------------|---------------------------|
| ![](pictures/image01.png) | ![](pictures/image02.png) |

### 使用说明

1. 在主界面，可以点击对应卡片，选择需要参考的组件示例。

2. 在组件目录选择详细的示例参考。

3. 进入示例界面，查看参考示例。

4. 通过自动测试框架可进行测试及维护。

### 工程目录
```
entry/src/main/ets/
|---Common
|   |---ContextUtils.ets                    // 定义UIContext接口
|   |---UIContext.ets                      //通过UIContext接口使用像素单位转换接口
|---entryability
|---pages
|   |---Index.ets                           // 传入UIContext调用getHostContext     
|   |---LocalStoragePage.ets                  // 使用UIContext接口替换全局接口     
entry/src/ohosTest/
|---ets
|   |---index.test.ets                      // 对应页面测试代码
|   |---LocalStoragePage.test.ets              // 对应页面测试代码
```

### 具体实现

一、像素单位转换接口的UIContext替换（支持多实例适配）
1. 定义静态成员uiContext存储全局UIContext，通过setUIContext方法在UI实例就绪后赋值（如Ability的loadContent回调中）；
2. 实现vp2px/fp2px/lpx2px方法：优先使用传入的uiContext或全局uiContext，若无效则vp2px通过display.getDefaultDisplaySync获取默认屏幕密度计算，fp2px/lpx2px返回undefined以保持行为一致；
3. 调用uiContext.isAvailable()验证UIContext有效性，避免异常。

二、Ability的Context获取（基于UIContext绑定）
1. 定义静态成员context存储默认Ability Context，通过setContext方法在Ability onCreate时赋值（直接使用Ability的this.context）；
2. 实现getContext方法：优先通过传入的uiContext.getHostContext()获取当前UI实例所属Ability的Context，无传入时返回默认context。

三、LocalStorage的UIContext替换（页面级共享存储）
1. 页面组件通过@Entry({useSharedStorage: true})启用共享LocalStorage，替代全局LocalStorage.getShared()；
2. 通过uiContext.getSharedLocalStorage()获取当前UI实例关联的共享存储，支持setOrCreate/读取操作；
3. 在Ability的onWindowStageCreate中，创建LocalStorage实例并传入windowStage.loadContent，确保页面初始化时获取到存储实例。

四、多窗口UIContext管理（基于窗口获焦状态）
1. 实现registerWindowCallback方法：为窗口注册windowEvent监听，当窗口触发WINDOW_ACTIVE（获焦）时，调用window.getUIContext()记录为activeUIContext；
2. 实现vp2px方法：优先使用传入的uiContext或activeUIContext，无效时通过display.getDefaultDisplaySync获取密度计算；
3. 提供unregisterWindowCallback方法，在窗口销毁前注销监听，避免内存泄漏。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：Mate 70 Pro、开发板。

2.本示例为Stage模型，支持API18版本full-SDK，版本号：5.1.0.107，镜像版本号：OpenHarmony_5.1.0 Release。

3.本示例需要使用DevEco Studio 5.0.5 Release (Build Version: 5.0.13.200， built on May 13, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/UIContext > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````