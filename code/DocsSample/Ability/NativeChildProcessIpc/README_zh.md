# 创建Native子进程（C/C++）

### 介绍

本示例展示了[创建支持IPC通信的Native子进程](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-models/capi_nativechildprocess_development_guideline.md#创建支持ipc通信的native子进程)的方法：

1. 创建子进程，并在父子进程间建立IPC通道，适用于父子进程需要IPC通信的场景；
2. 对IPCKit存在依赖；
3. 创建的子进程会随着父进程的退出而退出，无法脱离父进程独立运行。

### 测试代码说明

1.SUB_Ability_AbilityRuntime_NativeStartChildProcess_0100：验证通过StartNativeChildProcess创建 Native 子进程的功能，包括检查启动返回值、子进程 IPC 通信（加法操作）、退出子进程及重启子进程的流程。
2.SUB_Ability_AbilityRuntime_NativeStartChildProcess_0200：验证通过TestChildProcess创建 Native 子进程的功能，检查启动返回值，处理多进程模式禁用或子进程功能禁用的场景。

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