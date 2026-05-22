# ModularObjectExtensionAbility客户端

### 介绍

本示例展示了[ModularObjectExtensionAbility](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/capi-modular-object-extension-ability-h.md)客户端的开发方法：

1. 演示如何通过`OH_AbilityRuntime_ConnectModularObjectExtensionAbility`连接服务端的ModularObjectExtensionAbility。
2. 演示如何实现IPC Proxy，向服务端发起远程调用请求。
3. 本示例以Calculator（计算器）服务的客户端为例，连接服务端并调用Add（加法）运算。

### 效果展示

不涉及。

### 工程目录

```
entry/src/main/
├── cpp/
│   ├── icalculator.h          // ICalculator接口定义（与服务端一致），定义IPC通信的描述符和命令码
│   ├── calculator_proxy.h     // CalculatorProxy类声明
│   ├── calculator_proxy.cpp   // IPC Proxy实现，封装向服务端发起远程调用的逻辑
│   ├── napi_init.cpp          // N-API模块注册，导出testConnect、testDisconnect、testAdd函数
│   ├── log_helper.h           // 日志辅助宏
│   └── CMakeLists.txt         // CMake构建配置
├── ets/
│   ├── entryability/
│   ├── entrybackupability/
│   └── pages/
│       └── Index.ets          // 主界面，提供TestConnect、Disconnect、Add三个测试按钮
├── module.json5               // 模块配置
└── resources/
```

### 使用说明

1. **创建Want**：构造`AbilityBase_Element`指定目标服务端的`bundleName`（`com.samples.modularobjectextensionservice`）、`moduleName`（`entry`）和`abilityName`（`SampleModularObjectExtAbility`），通过`OH_AbilityBase_CreateWant`创建Want。
2. **创建ConnectOptions**：调用`OH_AbilityRuntime_CreateConnectOptions`创建连接选项，通过`OH_AbilityRuntime_ConnectOptions_SetOnConnectCallback`等接口注册`OnConnect`、`OnDisconnect`、`OnFailed`三个回调函数。
3. **发起连接**：调用`OH_AbilityRuntime_ConnectModularObjectExtensionAbility`，传入Want和ConnectOptions，获取`connectionId`。
4. **处理连接回调**：在`OnConnectCallback`中获取`OHIPCRemoteProxy`，用于后续IPC调用。
5. **调用远程方法**：使用`CalculatorProxy`包装`OHIPCRemoteProxy`，调用`Add`方法，Proxy内部通过`OH_IPCRemoteProxy_SendRequest`发送同步IPC请求。
6. **断开连接**：调用`OH_AbilityRuntime_DisconnectModularObjectExtensionAbility`，传入`connectionId`断开连接。

### 具体实现

1. **N-API函数导出**（`napi_init.cpp`）：在`Init`函数中注册`testConnect`、`testDisconnect`、`testAdd`三个N-API函数，供ArkTS前端页面调用。

2. **连接逻辑**（`napi_init.cpp` - `TestConnect`）：
   - 构建`AbilityBase_Element`，指定目标服务端信息。
   - 创建`ConnectOptions`，注册`OnConnectCallback`、`OnDisconnectCallback`、`OnFailedCallback`。
   - 调用`OH_AbilityRuntime_ConnectModularObjectExtensionAbility`发起连接，保存`connectionId`。

3. **IPC Proxy实现**（`calculator_proxy.cpp` - `CalculatorProxy::Add`）：
   - 创建`OHIPCParcel`用于发送数据和接收回复。
   - 写入Interface Token和两个int32_t参数（a、b）。
   - 通过`OH_IPCRemoteProxy_SendRequest`以同步模式发送请求，命令码为`COMMAND_ADD`。
   - 从reply Parcel中读取ErrCode和计算结果。

4. **测试界面**（`Index.ets`）：提供三个可点击文本按钮，分别触发`testConnect`、`testDisconnect`、`testAdd`。

5. **编译配置**（`CMakeLists.txt`）：通过`target_link_libraries`链接`libace_napi.z.so`、`libipc_capi.so`、`libability_runtime.so`等依赖库。

### 相关权限

不涉及。

### 依赖

本示例依赖服务端应用ModularObjectExtensionService，需先安装并运行服务端应用。

### 约束与限制

1. 需与服务端应用（ModularObjectExtensionService）配合使用，服务端需先安装到设备上。
2. ModularObjectExtensionAbility仅支持PC/2in1设备。
3. 本示例为Stage模型，支持API 26.0.0版本SDK，版本号：26.0.0.24。
4. 本示例需要使用DevEco Studio 6.1.1 Beta1及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/ModularObjectExtensionClient/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
