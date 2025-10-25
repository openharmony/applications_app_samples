# OH_ArkUI_RunTaskInScope跨实例组件操作示例

### 介绍

本示例演示了如何使用OH_ArkUI_RunTaskInScope接口实现NDK多窗口场景下的跨实例组件操作。通过动态切换执行上下文，确保在页面B中安全地修改页面A创建的组件属性，避免因实例上下文不匹配导致的接口调用异常。[示例文档](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/ndk-scope-task.md)。

### 使用说明
1. 安装编译生成的hap包，并启动应用程序；
2. 进入首页，选择First选项，进入页面；
3. 返回首页，点击ModifyFirstPage按钮修改First页面的按钮属性；

### 工程目录
```
entry/src/main/cpp/
├── CMakeLists.txt (CMake脚本)
└── napi_init.cpp

entry/src/main/ets/
|---entryability
|---pages
|   |---Firstpage_index.ets
|   |---Index.ets
|   |---Secondpage_index.ets     

entry/src/ohosTest/
|---ets
|   |---interface.test.ets                 // 示例代码测试代码
```

### 具体实现

1. 在目标页面创建组件时设置唯一ID，便于跨实例查找定位；

2. 在另一页面通过OH_ArkUI_NodeUtils_GetAttachedNodeHandleById获取目标组件句柄；

3. 使用OH_ArkUI_GetContextByNode获取组件对应的上下文实例；

4. 调用OH_ArkUI_RunTaskInScope在正确的上下文范围内执行组件属性设置操作；

### 相关权限

不涉及

### 依赖

不涉及

### 约束和限制

1. 本示例支持标准系统上运行，支持设备：RK3568;

2. 本示例支持API22版本SDK，版本号：6.0.2.54;

3. 本示例已支持使DevEco Studio 支持API22版本SDK，版本号：6.0.0.55，镜像版本号：OpenHarmony_6.0.0.55编译运行;

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/NdkScopeTask > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```