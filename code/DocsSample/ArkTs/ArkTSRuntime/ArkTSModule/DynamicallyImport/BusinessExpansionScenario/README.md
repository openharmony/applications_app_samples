# ArkTS动态加载(业务扩展场景介绍)

### 介绍

本示例主要展示了HAP动态import HAR包harlibrary，并调用静态成员函数staticAdd()、成员函数instanceAdd()，以及全局方法addHarlibrary()。该工程中展示的代码详细描述可查如下链接中业务扩展场景介绍部分。

- [动态加载](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/arkts-dynamic-import.md)

### 效果预览

| 执行结果图                                                   |
| ------------------------------------------------------------ |
| <img src="./screenshots/BusinessExpansionScenario.png" style="zoom: 50%;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面呈现Business Expansion Scenario效果，和一个按钮，点击按钮后可以动态加载并调用函数，然后在控制台中打印出对应日志。
3. 运行测试用例DynamicImport.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets               // 动态加载示例代码
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       ├── Ability.test.ets 
 │   │       ├── DynamicImport.test.ets  // 自动化测试代码
 │   │       └── List.test.ets
 harlibrary/
 ├── src
 │   ├── main
 │   │   ├── ets
 │   │   │   ├── utils
 │   │   │   │   └── Calc.ets            // har模块函数实现
 │   │   │   └── components  
 │   │   │   │   └── MainPage.ets
 │   ├── module.json5
 │   └── resources
 ├── index.ets
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
echo code/DocsSample/ArkTs/ArkTSRuntime/ArkTSModule/DynamicallyImport/BusinessExpansionScenario > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````