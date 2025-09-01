# ArkUI使用NODE IMAGE指南文档示例

### 介绍

本示例通过使用[ArkUI指南文档](https://gitcode.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)中各场景的开发示例，
展示在工程中，帮助开发者更好的理解并合理使用ArkUI提供的组件以及组件属性。通过该工程可以创建IMAGE组件并可以设置、获取、重置组件对应
节点属性，对已创建的IMAGE组件进行销毁操作。该工程中代码详细描述可参考[显示图片 (Image)](https://gitcode.com/openharmony/docs/blob/OpenHarmony-5.0.0-Release/zh-cn/application-dev/ui/arkts-graphics-display.md)。

### 效果预览

| 首页                               | 设置图像内容顺时针旋转90度显示                   |
|------------------------------------|---------------------------------|
| ![](screenshots/device/image1.png) |![](screenshots/device/result.png) |

### 使用说明

1. 在主界面，可以点击“选择节点类型”，创建需要的组件。

2. 选择组件对应的“选择节点属性”菜单列。

3. 通过文本输入，设置属性值。

4. 点击“设置属性值”，查看效果。

5. 点击“获取属性值”，查看已设置的属性值。

6. 点击“重置”，清除设置的属性。

7. 点击“清理”，移除创建的组件节点。

### 工程目录
```
entry/src/main/cpp
|---CMakeLists.txt                   // 编译脚本
|---napi_init.cpp                      // 实现创建、设置、获取、重置组件属性
|---manager.cpp                        // 管理组件节点
|---types
    |---Index.d.ts                      // napi对外接口定义
entry/src/main/ets/
|---entryability
|---pages
|   |---Index.ets                      // 应用主页面
entry/src/ohosTest/
|---ets
|   |---index.test.ets                 // 示例代码测试代码
```

### 具体实现

1. 在[Index.ets](entry%2Fsrc%2Fmain%2Fets%2Fpages%2FIndex.ets)文件中，通过点击按钮创建IMAGE组件节点，并通过文本输入框设置、获取、重置属性值。
2. 在[Index.d.ts](entry%2Fsrc%2Fmain%2Fcpp%2Ftypes%2Flibentry%2FIndex.d.ts)文件中，定义napi对外接口。
3. 在[napi_init.cpp](entry%2Fsrc%2Fmain%2Fcpp%2Fnapi_init.cpp)文件中，实现Index.d.ts中对外的接口。
4. 在[manager.cpp](entry%2Fsrc%2Fmain%2Fcpp%2Fmanager.cpp)文件中，通过调用ArkUI的接口实现创建、设置、获取、重置组件属性。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例支持标准系统上运行, 支持设备：RK3568等。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.47，镜像版本号：OpenHarmony_5.0.2.57。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUIDocSample/NativeNodeSample > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````