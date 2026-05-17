# 创建ArkTS子进程

### 介绍

本示例展示了[创建ArkTS子进程](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/application-models/arktschildprocess-development-guideline.md)相关接口的使用方法：

1. 使用[startChildProcess](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/js-apis-app-ability-childProcessManager.md#childprocessmanagerstartchildprocess)接口创建基础ArkTS子进程，分别演示Promise回调和callback回调两种调用方式；
2. 使用[startArkChildProcess](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-ability-kit/js-apis-app-ability-childProcessManager.md#childprocessmanagerstartarkchildprocess12)接口创建支持参数传递的ArkTS子进程，演示字符串参数和fd句柄参数的传递。

### 效果展示

不涉及。

### 测试代码说明

1. assertContain：基础断言测试，验证测试框架运行正常。

### 工程目录
```
entry/src/
├── main
│   ├── ets
│   │   ├── entryability
│   │   │   └── EntryAbility.ets            // 应用入口Ability，管理应用生命周期
│   │   ├── entrybackupability
│   │   │   └── EntryBackupAbility.ets      // 备份恢复能力
│   │   ├── pages
│   │   │   └── Index.ets                   // 主界面，包含子进程创建操作按钮
│   │   └── process
│   │       ├── DemoProcessNoArg.ets        // 无参数子进程类，继承ChildProcess
│   │       └── DemoProcessArg.ets          // 带参数子进程类，接收entryParams和fd句柄
│   ├── module.json5                        // 模块配置文件
│   └── resources                           // 资源文件
└── ohosTest
    └── ets
        └── test
            ├── Ability.test.ets            // 自动化测试代码
            └── List.test.ets               // 测试套执行列表

```

### 使用说明

1. **创建基础ArkTS子进程（无参数）**：通过`childProcessManager.startChildProcess`接口，传入子进程源文件路径和启动模式（如`SELF_FORK`），启动一个不需要传递参数的简单子进程。支持Promise和callback两种异步回调方式。
2. **创建支持参数传递的ArkTS子进程**：通过`childProcessManager.startArkChildProcess`接口，传入子进程源文件路径、参数对象（`ChildProcessArgs`，包含字符串参数`entryParams`和fd句柄`fds`）以及可选的配置项（`ChildProcessOptions`），启动一个可接收参数的子进程。
3. **注意事项**：必须在代码中引用子进程类（如调用`DemoProcessNoArg.toString()`），防止子进程源文件被构建工具优化掉。

### 具体实现

1. **创建子进程类**：在`entry/src/main/ets/process/`目录下创建子进程源文件，继承`ChildProcess`类并实现`onStart`方法。`DemoProcessNoArg`为无参数子进程，`DemoProcessArg`为带参数子进程，后者通过`onStart(args?: ChildProcessArgs)`接收主进程传递的`entryParams`字符串参数和`fds`文件描述符句柄。

2. **主进程启动子进程（无参数-Promise方式）**：在`Index.ets`中导入子进程类并引用，调用`childProcessManager.startChildProcess("./ets/process/DemoProcessNoArg.ets", childProcessManager.StartMode.SELF_FORK)`，通过Promise异步回调获取子进程pid。

3. **主进程启动子进程（无参数-callback方式）**：调用`childProcessManager.startChildProcess("./ets/process/DemoProcessNoArg.ets", childProcessManager.StartMode.SELF_FORK, callback)`，通过callback异步回调获取子进程pid。

4. **主进程启动子进程（带参数）**：调用`childProcessManager.startArkChildProcess("module1/ets/process/DemoProcess.ets", args, options)`，构造`ChildProcessArgs`传递字符串参数和fd句柄，构造`ChildProcessOptions`配置隔离模式，通过Promise异步回调获取子进程pid。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1. 创建的子进程不支持创建UI界面。
2. 创建的子进程不支持依赖Context的API调用（包括Context模块自身API及将Context实例作为入参的API）。
3. 创建的子进程内不支持再次创建子进程。
4. 通过`startChildProcess`创建的子进程不支持异步ArkTS API调用，仅支持同步ArkTS API调用。
5. 通过`startChildProcess`创建的子进程，其`onStart`函数执行完后子进程会自动销毁；通过`startArkChildProcess`创建的子进程不会自动销毁，需要子进程调用`process.abort`销毁。
6. 创建的子进程会随着父进程的退出而退出，无法脱离父进程独立运行。
7. 接口仅可在Stage模型下使用，且仅支持Tablet、PC/2in1设备类型。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/ArkTsChildProcess/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
