# 创建Native子进程（C/C++）

### 介绍

本示例展示了[创建支持IPC通信的Native子进程](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-models/capi_nativechildprocess_development_guideline.md#创建支持ipc通信的native子进程)的方法：

1. 创建子进程，并在父子进程间建立IPC通道，适用于父子进程需要IPC通信的场景；
2. 对IPCKit存在依赖；
3. 创建的子进程会随着父进程的退出而退出，无法脱离父进程独立运行。

### 效果展示

不涉及。

### 测试代码说明

1.SUB_Ability_AbilityRuntime_NativeStartChildProcess_0200：验证通过TestChildProcess创建 Native 子进程的功能，检查启动返回值，处理多进程模式禁用或子进程功能禁用的场景。

### 工程目录
```
entry/src/
├── main
│   ├── cpp
│   │   ├── types
│   │   │   ├── libchildprocesssample   //子进程so包
│   │   │       ├── index.d.ets
│   │   │       └── oh-package.json5
│   │   │   ├── libmainprocesssample   //主进程so包
│   │   │       ├── index.d.ets
│   │   │       └── oh-package.json5
│   │   ├── ChildProcess.cpp
│   │   ├── ChildProcess.h
│   │   ├── ChildProcessSample.cpp  //子进程示例代码
│   │   ├── ChildProcessSample.h
│   │   ├── CMakeLists.txt
│   │   ├── Ipchelper.h
│   │   ├── IpcInterface.cpp
│   │   ├── IpcInterface.h
│   │   ├── IpcProxy.cpp
│   │   ├── IpcProxy.h
│   │   ├── IpcStub.cpp
│   │   ├── IpcStub.h
│   │   ├── loghelper.h
│   │   ├── MainProcessSample.cpp  //主进程示例代码
│   │   └── MainProcessSample.h
│   ├── ets
│   │   ├── entryability
│   │   ├── entrybackupability
│   │   └── pages
│   │       └── Index.ets
│   ├── module.json5
│   ├── syscap.json
│   └── resources
└── ohosTest
    └── ets
        └── test
            ├── Ability.test.ets  // 自动化测试代码
            └── List.test.ets    // 测试套执行列表

```

### 使用说明

1. 依赖准备：需引入libipc_capi.so、libchild_process.so库及对应头文件。
2. 子进程实现：导出NativeChildProcess_OnConnect（返回 IPC 通信的 Stub 对象）和NativeChildProcess_MainProc（业务入口），编译为动态库并链接libipc_capi.so。
3. 主进程操作：调用OH_Ability_CreateNativeChildProcess启动子进程，通过回调OnNativeChildProcessStarted处理结果，保存OHIPCRemoteProxy用于 IPC，使用后需释放。
4. 编译配置：主进程和子进程的CMakeLists.txt需分别链接依赖库，确保编译通过。

### 具体实现

1. 准备基础工程：基于现有 Native 应用开发工程，确保包含 IPC 和 AbilityKit 相关头文件（ipc_kit.h、native_child_process.h）。
2. 实现子进程核心函数：在子进程代码（如ChildProcessSample.cpp）中，实现导出函数NativeChildProcess_OnConnect（返回 IPC Stub 对象，处理主进程消息）和NativeChildProcess_MainProc（子进程业务逻辑入口）。
3. 编译子进程动态库：修改CMakeLists.txt，将子进程代码编译为动态库（如libchildprocesssample.so），并链接libipc_capi.so等依赖库。
4. 主进程实现启动回调：主进程中定义OnNativeChildProcessStarted回调函数，处理子进程启动结果（成功时保存OHIPCRemoteProxy用于 IPC 通信，失败时做异常处理）。
5. 主进程启动子进程：调用OH_Ability_CreateNativeChildProcess接口，传入子进程动态库名和回调函数，启动子进程（仅主进程可调用）。
6. 主进程配置编译依赖：修改主进程CMakeLists.txt，链接libipc_capi.so、libchild_process.so等依赖库，确保编译通过。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.从API version 14开始，支持2in1和Tablet设备。API version 13及之前版本，仅支持2in1设备。 从API version 15开始，单个进程最多支持启动50个Native子进程。API version 14及之前版本，单个进程只能启动1个Native子进程。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/NativeChildProcessIpc/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```