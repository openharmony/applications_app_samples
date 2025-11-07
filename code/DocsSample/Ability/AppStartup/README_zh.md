# 应用启动框架AppStartup

### 介绍

应用启动时通常需要执行一系列初始化启动任务，如果将启动任务都放在HAP的UIAbility组件的onCreate生命周期中，那么只能在主线程中依次执行，不但影响应用的启动速度，而且当启动任务过多时，任务之间复杂的依赖关系还会使得代码难以维护。

AppStartup提供了一种应用启动方式，可以支持任务的异步启动。同时，通过在一个配置文件中统一设置多个启动任务的执行顺序以及依赖关系，使启动任务的代码更简洁、清晰、易维护。

### 运行机制
启动框架支持以自动模式或手动模式执行启动任务，默认采用自动模式。在构造AbilityStage过程中开始加载开发者配置的启动任务，并执行自动模式的启动任务。开发者也可以在AbilityStage创建完后调用startupManager.run方法，执行手动模式的启动任务。

### 使用说明

1. 当前工程应用启动框架共包含6个启动任务，启动工程会自动并发执行自动模式任务
2. 001—004为自动任务，当AbilityStage完成创建后，自动执行启动任务
3. 005-006为手动任务，在EntryAbility中通过startupManager.run方法来执行启动任务与so预加载任务

### 工程目录
```
entry/src/main/
│  module.json5               # 模块核心配置（设备类型、系统能力、权限等）
│  
├─ cpp/                       # Native层so源码目录
│  │  CMakeLists.txt          # C++编译配置脚本（控制so生成）
│  │  
│  └─ types/                  # so类型定义（供ArkTS调用的接口声明）
│  
├─ ets/                       # ArkTS业务代码目录（应用功能核心）
│  ├─ entryability/           # 应用启动入口（Ability组件）
│  │  └─ EntryAbility.ets     # 主Ability，控制应用生命周期
│  │  
│  ├─ entrybackupability/     # 备份能力（非必需，按需保留）
│  │  └─ EntryBackupAbility.ets
│  │  
│  ├─ pages/                  # 页面组件目录（用户交互界面）
│  │  └─ Index.ets            # 首页界面代码
│  │  
│  └─ startup/                # AppStartup启动任务目录（启动流程控制）
│  
└─ resources/                 # 模块资源目录（界面与业务依赖的资源）
   └─ base/
      └─ profile/            # 配置文件（路由、启动任务等）
         └─ startup_config.json  # 启动任务配置（任务顺序、依赖等）

```

### 关系图
**图1** 启动任务依赖关系图
![img_1.png](img_1.png)

**图2** so预加载任务依赖关系图
![img.png](img.png)

注意:so文件和任务需自己进行相关配置，代码只做展示

### 具体实现

1. 在HAP的“resources/base/profile”路径下，新建启动框架配置文件。文件名可以自定义，本文以"startup_config.json"为例。
2. 在module.json5配置文件的appStartup标签中，添加启动框架配置文件的索引。
3. 在“ets/startup”路径下，创建启动参数配置文件。本例中的文件名为StartupConfig.ets。
4. 在启动框架配置文件startup_config.json中，添加启动参数配置文件的相关信息。
5. 在“ets/startup”路径下，依次创建启动任务文件。
6. 在启动框架配置文件startup_config.json中，添加启动任务配置
7. 创建so文件。
8. 在启动框架配置文件startup_config.json中，添加预加载so任务配置。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例已适配API version 20版本SDK，版本号：6.0.0。

3.本示例需要使用DevEco Studio 6.0 及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/AppStartup/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```