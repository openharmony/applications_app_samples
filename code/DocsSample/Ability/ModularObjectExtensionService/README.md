# ModularObjectExtensionAbility服务端

### 介绍

本示例展示了[ModularObjectExtensionAbility](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/capi-modular-object-extension-ability-h.md)服务端的开发方法：

1. 演示如何创建并注册一个ModularObjectExtensionAbility，对外提供跨进程IPC服务。
2. 演示如何实现IPC Stub，接收并处理来自客户端的远程调用请求。
3. 本示例以一个简单的Calculator（计算器）服务为例，提供Add（加法）运算能力。

### 效果展示

不涉及UI界面交互。本应用作为服务端运行，等待客户端（ModularObjectExtensionClient）连接并调用Add方法，返回计算结果。

### 工程目录

```
entry/src/main/
├── cpp/
│   ├── icalculator.h          // ICalculator接口定义，定义IPC通信的描述符和命令码
│   ├── calculator_stub.h      // CalculatorStub类声明
│   ├── calculator_stub.cpp    // IPC Stub实现，处理客户端请求并执行Add操作
│   ├── moe_ability.cpp        // ModularObjectExtensionAbility实现
│   ├── log_helper.h           // 日志辅助宏
│   └── CMakeLists.txt         // CMake构建配置
├── ets/
│   ├── entryability/
│   ├── entrybackupability/
│   └── pages/
│       └── Index.ets          // 主界面
├── module.json5               // 模块配置，声明SampleModularObjectExtAbility
└── resources/
```

### 使用说明

1. **配置扩展能力**：在`module.json5`的`extensionAbilities`中声明`type: "modularObject"`类型的扩展能力，并通过`srcEntry`指定Native库`libentry.so`。
2. **设置元数据**：配置`launchMode`（启动模式）、`processMode`（进程模式）、`threadMode`（线程模式）等参数，控制扩展能力的运行行为。
3. **实现入口函数**：在Native代码中实现`OH_AbilityRuntime_OnNativeExtensionCreate`入口函数，获取扩展实例并注册生命周期回调。
4. **注册生命周期回调**：通过`OH_AbilityRuntime_ModObjExtensionAbility_RegisterOnCreateFunc`等接口注册`OnCreate`、`OnConnect`、`OnDisconnect`、`OnDestroy`回调。
5. **实现IPC Stub**：在`OnConnect`回调中创建`CalculatorStub`实例，通过`OH_AbilityRuntime_ModObjExtensionContext_CreateIPCRemoteStub`创建IPC RemoteStub并返回。
6. **处理请求**：在Stub的`OnRemoteRequest`中根据命令码分发请求，读取参数并调用业务逻辑，将结果写入reply Parcel返回客户端。

### 具体实现

1. **入口函数注册**（`moe_ability.cpp`）：在`OH_AbilityRuntime_OnNativeExtensionCreate`中调用`OH_AbilityRuntime_ModObjExtensionAbility_GetInstanceFromBase`获取实例，然后注册`OnCreate`、`OnConnect`、`OnDisconnect`、`OnDestroy`四个生命周期回调函数。

2. **生命周期管理**（`moe_ability.cpp`）：
   - `OnCreate`：调用`OH_AbilityRuntime_ModObjExtensionAbility_GetContextFromInstance`获取并保存Context。
   - `OnConnect`：创建`CalculatorStub`实例，调用`GetRemoteStub()`返回IPC RemoteStub。
   - `OnDisconnect`：释放`CalculatorStub`实例。
   - `OnDestroy`：清理保存的Context。

3. **IPC Stub实现**（`calculator_stub.cpp`）：
   - 构造函数中通过`OH_AbilityRuntime_ModObjExtensionContext_CreateIPCRemoteStub`创建RemoteStub，绑定接口描述符和请求处理回调。
   - `OnRemoteRequest`校验Interface Token后根据命令码分发请求。
   - `HandleAdd`从Parcel中读取两个int32_t参数，执行加法运算，将ErrCode和结果写入reply Parcel。

4. **编译配置**（`CMakeLists.txt`）：通过`target_link_libraries`链接`libability_base_want.so`、`libipc_capi.so`、`libability_runtime.so`等依赖库。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 需与客户端应用（ModularObjectExtensionClient）配合使用。
2. ModularObjectExtensionAbility仅支持PC/2in1设备。
3. 本示例为Stage模型，支持API 26.0.0版本SDK，版本号：26.0.0.24。
4. 本示例需要使用DevEco Studio 6.1.1 Beta1及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/ModularObjectExtensionService/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
