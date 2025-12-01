# 使用UI上下文接口操作界面（UIContext）指南文档示例

### 介绍

本示例通过使用[ArkUI指南文档](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui)中各场景的开发示例，
展示在工程中，帮助开发者更好地理解ArkUI提供的组件及组件属性并合理使用。该工程中展示的代码详细描述可查如下链接：

1. [使用UI上下文接口操作界面（UIContext）](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-global-interface.md)。

### 效果预览

| 首页                              |
|---------------------------------|
| ![](screenshots/device/simple.png) |


### 使用说明

1. 在主界面点击文本Calculate 20vp to px后执通过resolveUIContext获取UIContext。并调用其中的vp2px方法。

### 工程目录
```
entry/src/main/ets/
|---common
|   |---Utils.ets                           // 自己封装获取uiContext的工具类
|---entryability
|   |---EntryAbility.ets                    // 在启动流程中通过resolveUIContext获取UIContext
|---pages
|   |---Index.ets                            // 在主页面中获取UIContext
```

### 具体实现

一、像素单位转换接口的UIContext替换（支持多实例适配）
1. 定义静态成员uiContext存储全局UIContext，通过setUIContext方法在UI实例就绪后赋值（如Ability的loadContent回调中）；
2. 实现vp2px/fp2px/lpx2px方法：优先使用传入的uiContext或全局uiContext，若无效则vp2px通过display.getDefaultDisplaySync获取默认屏幕密度计算，fp2px/lpx2px返回undefined以保持行为一致；
3. 调用uiContext.isAvailable()验证UIContext有效性，避免异常。


### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API23版本full-SDK，版本号：6.1.0.17，镜像版本号：OpenHarmony_6.1.0 Release。

3.本示例需要使用DevEco Studio 6.0.0 beta5 (Build Version: 6.0.0.848, built on September 12, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/ResolveUIContext > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````