# 创建Native子进程（C/C++）

### 介绍

本示例展示了[创建支持参数传递的Native子进程](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-models/capi_nativechildprocess_development_guideline.md#创建支持参数传递的native子进程)的方法：

1. 创建子进程，并传递字符串和fd句柄参数到子进程。适用于需要传递参数到子进程的场景；
2. 创建的子进程会随着父进程的退出而退出，无法脱离父进程独立运行。

### 测试代码说明

1.SUB_Ability_AbilityRuntime_NativeStartChildProcess_0300：验证通过TestChildProcess启动带参数（entryParams）和文件描述符（fdList）的 Native 子进程功能，检查启动返回值，处理多进程模式禁用或子进程功能禁用的场景。

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
│   │   ├── ChildGetStartParams.cpp //子进程获取启动参数代码
│   │   ├── ChildProcessSample.cpp  //子进程示例代码
│   │   ├── ChildProcessSample.h
│   │   ├── CMakeLists.txt
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
2.从API version 17开始，支持子进程获取启动参数。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/NativeChildProcessParams/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```