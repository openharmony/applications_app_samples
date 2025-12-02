# 杀死子进程

### 介绍

本示例展示了[杀死子进程](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/capi-native-child-process-h.md#OH_Ability_KillChildProcess())方法：

1. 支持父进程根据pid杀死自己创建的子进程;
2. 调用该接口无法杀死[childProcessManager.startChildProcess](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/js-apis-app-ability-childProcessManager.md#childprocessmanagerstartchildprocess)接口在SELF_FORK模式下启动的子进程。

### 效果展示

不涉及。

### 测试代码说明

1. SUB_Ability_AbilityRuntime_KillChildProcess_0100：验证杀死子进程函数的功能，检查返回值是否正常。

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

1. 依赖：引入libchild_process.so库及头文件<AbilityKit/native_child_process.h>。
2. 杀死子进程操作：调用OH_Ability_KillChildProcess根据传入的pid杀死子进程，通过返回值是否为NCP_NO_ERROR判断操作成败，失败时打印错误日志。 
3. 编译配置：在主进程的CMakeLists.txt中，通过target_link_libraries链接libchild_process.so依赖库，确保编译通过。

### 具体实现

1.引入依赖与头文件：在主进程代码中包含头文件#include <AbilityKit/native_child_process.h>，确保工程依赖动态库libchild_process.so。

2.实现杀死子进程操作函数：调用OH_Ability_KillChildProcess根据传入的pid杀死子进程，通过返回值判断操作是否成功（NCP_NO_ERROR为成功），失败时打印错误日志。

3.配置编译依赖：在主进程CMakeLists.txt中，通过target_link_libraries添加libchild_process.so依赖，确保编译通过。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.从API version 22开始，支持父进程通过调用OH_Ability_KillChildProcess根据传入的pid杀死子进程。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/KillChildProcess/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```