# app.json5配置文件文档示例

### 介绍

本文面向开发者，介绍如何在自有应用中接入 **应用Skill** 能力。通过 Skill，应用可以将自身的功能暴露给系统智能体（Agent），用户用一句自然语言即可触达。
全文以 **音乐播放** 为示例场景，贯穿 `music-assistant` 这一 Skill 的完整开发过程。

### 效果预览
无

### 使用说明

## 开发步骤总览

| 步骤 | 关键文件 |
| ---- | -------- |
| 1. 创建目录与文件 | `entry/skills/music-assistant/` |
| 2. 配置 module.json5 | `entry/src/main/module.json5` |
| 3. 实现 ETS 函数 | `entry/skills/music-assistant/scripts/MusicSkill.ets` |
| 4. 编写 SKILL.md | `entry/skills/music-assistant/SKILL.md` |

### 工程目录
```
Application/
├── AppScope/
│   ├── app.json5
│   └── resources/
└── entry/
    ├── skills/                            ← 【固定值】当前模块所有 Skill 的根目录
    │   └── music-assistant/                ← Skill 名,需与 SKILL.md 的 name 一致
    │       ├── scripts/                   ← 【固定值】ETS 脚本目录
    │       │   └── MusicSkill.ets         ← Skill 入口脚本
    │       └── SKILL.md                   ← 【固定值】Skill 描述文件
    └── src/
        └── main/
            ├── ets/
            │   ├── entryability/
            │   │   └── EntryAbility.ets
            │   └── service/
            │       └── MusicPlayer.ets    ← 应用内业务服务(被 Skill 入口脚本调用)
            ├── module.json5               ← 添加skillProfiles配置
            └── resources/
```

### 具体实现

1. 在module.json5配置文件中的`module`标签下新增skillProfiles标签，将Skill注册到模块。

2. MusicSkill.ets作为Skill入口脚本，每个public方法对应SKILL.md中声明的一项能力（方法名需与functionName一致），负责入参规整、调用业务服务，并回传结果。

3. MusicPlayer.ets:应用内业务服务，封装具体的搜索与播控逻辑，被入口脚本调用，与Skill机制本身无耦合。

### 相关权限
1. ohos.permission.INTERNET 允许应用访问互联网，进行网络通信的权限。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：tablet（平板或者平板模拟器）。

2.本示例为Stage模型，支持API26.0.0版本SDK，版本号：26.0.0.25，镜像版本号：OpenHarmony_26.0.0.25。

3.本示例需要使用DevEco Studio 6.1.1 beta1及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/bmsSample/ArktsSkillDevelopmentGuide > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````