# 使用配置文件开发意图

### 介绍

从API version 11及以上版本，支持通过配置文件开发意图。主要包含两个环节：

通过json配置文件定义意图，声明意图执行器的代码路径、绑定的Ability组件等意图信息。

通过InsightIntentExecutor实现意图执行逻辑。

### 效果图

不涉及

### 使用说明

1. insightintent.json配置文件定义意图，声明意图执行器的代码路径、绑定的Ability组件等意图信息。
2. 选择意图垂域、意图框架入口代码文件名以及意图配置。意图配置包含意图名称和绑定的Ability组件。
3. 通过insightIntentDriver.execute调用意图，需要配置EXECUTEINSIGHTINTENT系统权限，要需full_sdk全量包。

### 运行机制

意图执行器实现需要继承InsightIntentExecutor，实现onExecuteInUIAbilityForegroundMode等方法。开发者响应意图执行通过onExecuteInUIAbilityForegroundMode等接口实现，在不同的意图执行模式下，接口的触发时机也不同。

### 工程目录

```
entry/src/main
├── module.json5                  # 模块配置文件（声明能力、权限等）
├── ets                           # ArkTS 源码目录
│   ├── abilities                 # 应用能力（Ability）
│   │   ├── EntryAbility.ets      # 主入口能力
│   │   └── MusicPlayerAbility.ets # 音乐播放能力
│   ├── insightintents            # 意图相关扩展
│   │   ├── ExtensionExecutor.ets  # 扩展执行器
│   │   ├── PlayMusicExecutor.ets  # 音乐播放意图执行器
│   │   └── ServiceExecutor.ets    # 服务执行器
│   └── pages                     # 页面组件
│       ├── Index.ets             # 首页
│       └── PlayerPage.ets        # 播放器页面
└── resources                     # 应用资源目录
    ├── base                      # 基础资源（默认配置）
    │   ├── element               # 基础元素（文本、颜色等）
    │   │   ├── color.json        # 颜色定义
    │   │   ├── float.json        # 浮点数常量（如尺寸）
    │   │   └── string.json       # 字符串资源
    │   ├── media                 # 媒体资源（图片等）
    │   └── profile               # 配置文件（页面路由、能力等）
    │       ├── backup_config.json # 备份配置
    │       ├── insightintent.json # 意图配置
    │       └── main_pages.json   # 主页面路由配置
    ├── dark                      # 深色模式资源
    └── rawfile                   # 原始资源文件

```

### 具体实现

1. 选中模块或模块下的文件，右键单击New > InsightIntent，进入意图框架配置界面。
2. 选择意图垂域、意图框架入口代码文件名以及意图配置。意图配置包含意图名称和绑定的Ability组件。
3. 点击Finish，完成意图框架创建。 此时将在module目录 > src > main > resource > base >
   profile中，生成json文件，可在该文件查看当前意图框架配置的相关信息。
4. 在module目录 > src > main > ets > insightintents目录下生成入口代码文件。开发者在意图执行函数中实现意图的功能代码。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行，支持设备：RK3568。

2.本示例已适配API version 20版本SDK，版本号：6.0.0。

3.本示例需要使用DevEco Studio 6.0及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/Ability/InsightIntentConfigDevelopment/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```