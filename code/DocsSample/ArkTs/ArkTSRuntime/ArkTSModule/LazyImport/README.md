# ArkTS延迟加载（lazy import）

### 介绍

本工程主要对比了延迟加载与普通加载的区别，并展示延迟加载的错误使用方法。该工程中展示的代码详细描述可查如下链接部分。

- [延迟加载](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/arkts-lazy-import.md)

### 效果预览

| 首页                                                         | 依次点击按钮后结果图                                         |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshots/LazyImport1.png" style="zoom:50%;" /> | <img src="./screenshots/LazyImport2.png" style="zoom:50%;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面中Text组件呈现LazyImport效果，依次点击五个button，Text依次现实显示‘Call a success result: a = mod1 a executed’，‘‘Call b success result: b = mod1 b executed’, ‘‘Call c success result: c = mod2 c executed’, ‘Not advisable to use one error: ReferenceError: c is not initialized’, ‘Not advisable to use two error: ReferenceError: module environment is undefined’。
3. 运行测试用例LazyImport.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── A.ets               
 │   │       ├── A_ns.ets  
 │   │       ├── B.ets  
 │   │       ├── C.ets  
 │   │       ├── fail_example.ets  
 │   │       ├── Index.ets         // 延迟加载
 │   │       ├── middle.ets  
 │   │       ├── mod1.ets  
 │   │       ├── mod2.ets  
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       ├── Ability.test.ets 
 │   │       ├── LazyImport.test.ets  // 自动化测试代码
 │   │       └── List.test
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API14版本SDK，版本号：5.0.2.57，镜像版本号：OpenHarmony_5.0.2.58。

3.本示例需要使用DevEco Studio 5.0.1 Release (Build Version: 5.0.5.306, built on December 6, 2024)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTs/ArkTSRuntime/ArkTSModule/LazyImport > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````