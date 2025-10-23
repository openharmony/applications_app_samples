# 获取Native子进程退出信息

### 介绍

本示例展示了[获取Native子进程退出信息](https://gitcode.com/tianlongdevcode/docs_xian/blob/form_lyb/zh-cn/application-dev/application-models/capi-nativechildprocess-exit-info.md)的方法：

1. 支持父进程通过注册回调函数监听子进程，获取子进程异常退出信息，以便父进程做后续优化处理;
2. 这里支持监听的子进程必须为OH_Ability_StartNativeChildProcess或startNativeChildProcess接口创建的子进程。

### 效果展示

不涉及。

### 测试代码说明

1. SUB_Ability_AbilityRuntime_RegisterNativeChildProcessExitCallback_0100：验证注册 Native 子进程退出回调函数的功能，检查返回值是否正常。
2. SUB_Ability_AbilityRuntime_UnregisterNativeChildProcessExitCallback_0100：验证注销 Native 子进程退出回调函数的功能，检查返回值是否正常。

### 工程目录
```
entry/src/
├── main
│   ├── cpp
│   │   ├── types
│   │   │   └──  libmainprocesssample   //主进程so包
│   │   │       ├── index.d.ets
│   │   │       └── oh-package.json5
│   │   ├── CMakeLists.txt
│   │   ├── MainProcessFile.cpp  //主进程示例代码
│   │   └── MainProcessFile.h
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

1. 依赖：引入libchild_process.so库及头文件<AbilityKit/native_child_process.h>，仅支持监听通过OH_Ability_StartNativeChildProcess接口创建的子进程。
2. 回调函数实现：定义OH_Ability_OnNativeChildProcessExit类型的回调函数（如OnNativeChildProcessExit），通过参数pid和signal获取子进程 ID 及退出信号，实现日志记录等后续处理逻辑。
3. 注册与解注册操作：调用OH_Ability_RegisterNativeChildProcessExitCallback注册回调，OH_Ability_UnregisterNativeChildProcessExitCallback解注册，通过返回值是否为NCP_NO_ERROR判断操作成败，失败时打印错误日志。
4. 编译配置：在主进程的CMakeLists.txt中，通过target_link_libraries链接libchild_process.so依赖库，确保编译通过。

### 具体实现

1.引入依赖与头文件：在主进程代码中包含头文件#include <AbilityKit/native_child_process.h>，确保工程依赖动态库libchild_process.so。

2.实现退出回调函数：定义OnNativeChildProcessExit回调函数，接收子进程的pid和退出信号signal，实现信息打印或后续处理逻辑（如日志记录）。

3.实现注册与解注册函数：分别调用OH_Ability_RegisterNativeChildProcessExitCallback和OH_Ability_UnregisterNativeChildProcessExitCallback接口，传入回调函数，通过返回值判断操作是否成功（NCP_NO_ERROR为成功），失败时打印错误日志。

4.配置编译依赖：在主进程CMakeLists.txt中，通过target_link_libraries添加libchild_process.so依赖，确保编译通过。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.从API version 20开始，支持父进程通过注册回调函数监听子进程，获取子进程异常退出信息，以便父进程做后续优化处理。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/NativeChildProcessExit/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```