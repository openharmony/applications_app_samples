# 节点释放时崩溃示例

### 介绍

本示例主要展示了FrameNode与其衍生对象Dispose顺序不当引发的cppcrash问题。节点在其衍生资源释放前dispose，有可能导致衍生资源释放时或释放后仍访问了已释放节点，造成use-after-free crash。快速点击页面中的“创建/销毁XComponent”即可触发crash。

### 使用说明

本示例包含2个功能：
1. 创建XComponent组件以及关联该XComponent组件的衍生对象。
2. 销毁XComponent组件以及关联该XComponent组件的衍生对象。

### 工程目录

```
DisposeNodeCrash

entry/src/main
+--- cpp
|   |-- BindCallback.h
|   |-- BindCallback.cpp
|   |-- CMakeLists.txt
|   |-- napi_init.cpp
|   |-- types
|   |   `-- libentry
|   |       |-- Index.d.ts
|   |       `-- oh-package.json5
|-- ets
|   |-- entryability
|   |   `-- EntryAbility.ets
|   |-- entrybackupability
|   |   `-- EntryBackupAbility.ets
|   `-- pages
|       `-- Index.ets         
```

### 具体实现

1. **创建XComponent组件及衍生对象**
   - 调用typeNode.createNode创建XComponent类型节点，再调用OH_ArkUI_SurfaceHolder_Create创建OH_ArkUI_SurfaceHolder对象。
2. **销毁XComponent组件及衍生对象**
   - 调用disposeNode释放XComponent节点，再调用OH_ArkUI_SurfaceHolder_Dispose销毁OH_ArkUI_SurfaceHolder对象。


### 相关权限

不涉及

### 依赖

不涉及

### 约束与限制

1. 本示例仅支持标准系统上运行, 支持设备：手机、平板、2in1。（部分字段可能仅支持部分设备，可参考使用说明）
2. api22以上版本

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/DisposeNodeCrash > .git/info/sparse-checkout
git remote add origin https://gitCode.com/openharmony/applications_app_samples.git
git pull origin master
````