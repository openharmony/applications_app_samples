# ArkTS延迟加载（lazy import）

### 介绍

本工程主要对比了延迟加载与普通加载的区别，并展示延迟加载的错误使用方法。该工程中展示的代码详细描述可查如下链接部分。

- [延迟加载](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/arkts-utils/arkts-lazy-import.md)

### 效果预览

| 首页                                                          | 依次点击按钮后结果图                                          |
| ------------------------------------------------------------- | ------------------------------------------------------------- |
| <img src="./screenshots/LazyImport1.png" style="zoom:50%;" width="360; /> | <img src="./screenshots/LazyImport2.png" style="zoom:50%;" width="360; /> |

### 使用说明

1. 运行Index主界面。
2. 页面中Text组件呈现LazyImport效果，依次点击五个button，Text依次现实显示‘Call a success result: a = mod1 a executed’，‘‘Call b success result: b = mod1 b executed’, ‘‘Call c success result: c = mod2 c executed’, ‘Not advisable to use one error: ReferenceError’, ‘Not advisable to use two error: ReferenceError’。
3. 运行测试用例LazyImport.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/
└── src/
    ├── main/
    │   ├── ets/
    │   │   ├── entryability/
    │   │   ├── entrybackupability/
    │   │   ├── pages/
    │   │   │   ├── 1.ets
    │   │   │   ├── A.ets
    │   │   │   ├── A_ns.ets
    │   │   │   ├── B.ets
    │   │   │   ├── C.ets
    │   │   │   ├── fail_example.ets
    │   │   │   ├── index.ets
    │   │   │   ├── innerinner.ets
    │   │   │   ├── main.ets
    │   │   │   ├── middle.ets
    │   │   │   ├── mod1.ets
    │   │   │   ├── mod2.ets
    │   │   │   └── outter.ets
    │   │   ├── util/
    │   │   ├── resources/
    │   │   └── module.json5
    │   └── mock/
    └── ohosTest/
        ├── ets/
        │   └── test/
        │       ├── Ability.test.ets
        │       ├── LazyImport.test.ets
        │       └── List.test.ets
        ├── module.json5
        └── test/
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.34，镜像版本号：OpenHarmony_6.0.0.34。

3.本示例需要使用DevEco Studio 6.0.0及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/ArkTSRuntime/ArkTSModule/LazyImport > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
