# ArkTS使用Node-API接口在主线程中进行模块加载

### 介绍

本工程展示了使用Node-API接口在主线程中进行系统模块加载与ArkTS单文件加载。详细描述可查如下链接中。

- [使用Node-API接口在主线程中进行模块加载](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-napi-load-module.md)

### 效果预览

| 首页                                                                  | 执行结果图                                                            |
| --------------------------------------------------------------------- | --------------------------------------------------------------------- |
| <img src="./screenshots/NodeApiLoadModule1.png" style="zoom: 67%;" /> | <img src="./screenshots/NodeApiLoadModule2.png" style="zoom: 67%;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面呈现如上图效果和两个按钮，依次点击按钮后可以加载系统模块和单文件模块，并将成功结果呈现到text文本中。
3. 运行测试用例NodeApiLoadModule.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │       ├── libentry
 │   │       └── libentry1
 │   │   ├── file.cpp                    // ArkTS单文件加载
 │   │   ├── CMakeLists.txt
 │   │   ├── napi_init.cpp               // 系统模块加载
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets               // 加载模块
 │   │   ├── Test.ets
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       ├── Ability.test.ets
 │   │       ├── NodeApiLoadModule.test.ets  // 自动化测试代码
 │   │       └── List.test.ets
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

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/NodeAPI/NodeAPIClassicUseCases/NodeAPILoadModule > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
