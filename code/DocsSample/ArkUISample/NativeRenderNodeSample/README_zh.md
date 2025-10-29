# ArkUI使用RenderNode指南文档示例

### 介绍

本示例通过使用[ArkUI指南文档](https://gitcode.com/openharmony/docs/tree/master/zh-cn/application-dev/ui)中各场景的开发示例，展示在工程中，帮助开发者更好的理解并合理使用ArkUI提供的组件以及组件属性。通过该工程可以创建RenderNode组件并可以设置、获取、重置组件对应节点属性

### 使用说明

1. 在主界面，可以点击首页的列表，选择查看绘制节点相关的接口类型。

2. 点击“RenderNode节点操作demo”查看renderNode相关的节点树操作接口。

3. 点击“RenderNode属性设置demo”查看renderNode各属性设置及其效果。

4. 点击“RenderNode自定义绘制demo”查看实现renderNode的自定义绘制能力。

### 工程目录

```
entry/src/main/cpp
|---CMakeLists.txt                   // 编译脚本
|---napi_init.cpp                      // 实现与TS的交互层逻辑
|---NativeEntry.cpp                        // Demo实现逻辑
|---types
    |---Index.d.ts                      // napi对外接口定义
entry/src/main/ets/
|---entryability
|---pages
|   |---custom.ets                      // RenderNode自定义绘制实现页面
|   |---entry.ets                      // RenderNode组件树操作页面
|   |---index.ets                      // 应用主页面
|   |---property.ets                      // RenderNode属性设置实现页面
```

### 具体实现
- 本示例展示获取渲染组件接入页面的使用方式，使用CAPI新增的RenderNodeUtils相关能力，通过接口构造渲染树，设置渲染节点的绘制属性等，而后将其挂载在CAPI的CUSTOM节点下即可实现。

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