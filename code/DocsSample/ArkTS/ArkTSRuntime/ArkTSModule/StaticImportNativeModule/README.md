# 静态方式加载native模块

### 介绍

在ECMAScript 6模块设计中，使用import语法加载其他文件导出的内容是ECMA规范定义的语法规则。本项目介绍了如何使用该功能导入native模块（so）导出的内容。

- [静态方式加载native模块](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/arkts-utils/arkts-import-native-module.md)

### 效果预览

| 首页                                                          | 依次点击按钮后结果图                                                                  |
| ------------------------------------------------------------- |-----------------------------------------------------------------------------|
| <img src="./screenshots/StaticImportNativeModule1.png" style="zoom:50%;" width="360;" /> | <img src="./screenshots/StaticImportNativeModule2.png" style="zoom:50%;" width="360;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面中组件呈现静态方式加载native模块效果，依次点击button，跳转页面依次现实显示'5'，'5'，'5'，'5'，'5'，'hilog.info','5'。
3. 运行测试用例StaticImportNativeModule.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/
├── src/
│   ├── main/
│   │   ├── cpp/
│   │   ├── ets/
│   │   │   ├── entryability/
│   │   │   ├── entrybackupability/
│   │   │   ├── pages/
│   │   │   │   ├── DirectImport/
│   │   │   │   │   └── test.ets
│   │   │   │   ├── DefaultImport/
│   │   │   │   │   └── test.ets
│   │   │   │   ├── NamedImport/
│   │   │   │   │   └── test.ets
│   │   │   │   ├── NamespaceImport/
│   │   │   │   │   └── test.ets
│   │   │   │   ├── DynamicImport/
│   │   │   │   │   └── DirectImport/
│   │   │   │   │       └── test.ets
│   │   │   │   ├── IndirectImport/
│   │   │   │   │   ├── NegativeExample.ets
│   │   │   │   │   ├── test1.ets
│   │   │   │   │   └── test2.ets
│   │   │   │   ├── ExportNamedAndImport/
│   │   │   │   │   ├── test1.ets
│   │   │   │   │   └── test2.ets
│   │   │   │   ├── ExportNamespaceAndImport/
│   │   │   │   │   ├── NegativeExample.ets
│   │   │   │   │   ├── test1.ets
│   │   │   │   │   └── test2.ets
│   │   │   │   └── Index.ets
│   │   │   ├── util/
│   │   │   ├── resources/
│   │   │   └── module.json5
│   │   └── mock/
│   └── ohosTest/
│       ├── ets/
│       │   └── test/
│       │       ├── Ability.test.ets
│       │       ├── List.test.ets
│       │       └── StaticImportNativeModule.test.ets
│       ├── module.json5
│       └── test/
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.40，镜像版本号：OpenHarmony_6.0.0.40。

3.本示例需要使用DevEco Studio 5.1.1 Release (Build Version: 5.1.1.820, built on June 28, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/ArkTSRuntime/ArkTSModule/StaticImportNativeModule > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
