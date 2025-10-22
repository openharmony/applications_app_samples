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

### 具体实现
1.准备工程依赖：确保 Native 工程包含头文件#include <AbilityKit/native_child_process.h>，并依赖动态库libchild_process.so。

2.子进程实现入口函数：在子进程代码（如ChildProcessSample.cpp）中，导出自定义入口函数（如Main），通过NativeChildProcess_Args接收entryParams参数和fdList文件描述符链表，实现业务逻辑。

3.编译子进程动态库：修改CMakeLists.txt，将子进程代码编译为动态库（如libchildprocesssample.so），并链接libchild_process.so依赖。

4.主进程构建传递参数：主进程中定义NativeChildProcess_Args，分配内存设置entryParams（如字符串 "testParam"），构建fdList链表（包含 fd 名称和通过open获取的文件描述符），并配置NativeChildProcess_Options（如隔离模式）。

5.主进程启动子进程：调用OH_Ability_StartNativeChildProcess，传入子进程动态库名 + 入口函数（如 "libchildprocesssample.so:Main"）、参数、选项和 pid 指针，启动子进程并获取 pid。

6.释放资源与配置依赖：主进程在子进程启动后（无论成功与否）释放entryParams和fdList的内存；修改主进程CMakeLists.txt，链接libchild_process.so确保编译通过。

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