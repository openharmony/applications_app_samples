# 应用启动框架AppStartup

### 介绍

应用启动时通常需要执行一系列初始化启动任务，如果将启动任务都放在HAP的UIAbility组件的onCreate生命周期中，那么只能在主线程中依次执行，不但影响应用的启动速度，而且当启动任务过多时，任务之间复杂的依赖关系还会使得代码难以维护。

AppStartup提供了一种简单高效的应用启动方式，可以支持任务的异步启动，加快应用启动速度。同时，通过在一个配置文件中统一设置多个启动任务的执行顺序以及依赖关系，让执行启动任务的代码变得更加简洁清晰、容易维护。

### 运行机制
启动框架支持以自动模式或手动模式执行启动任务，默认采用自动模式。在构造AbilityStage过程中开始加载开发者配置的启动任务，并执行自动模式的启动任务。开发者也可以在AbilityStage创建完后调用startupManager.run方法，执行手动模式的启动任务。

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

注意:so和任务需自己进行相关配置，代码只做展示

### 使用说明
1. 当前工程应用启动框架共包含6个启动任务，启动工程化会自动并发执行启动任务
2. 001—004为自动任务，005.006为手动任务

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例已适配API version 10版本SDK，版本号：4.0.10.13。

3.本示例需要使用DevEco Studio 4.0 (Build Version: 4.0.0.600 构建 2023年10月17日)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/Performance/MetaCompetence/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```