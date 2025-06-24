# ArkTS使用Node-API接口进行模块加载

### 介绍

Node-API中的napi_load_module_with_info接口的功能是进行模块的加载，当模块加载出来之后，可以使用函数napi_get_property获取模块导出的变量，也可以使用napi_get_named_property获取模块导出的函数，该函数可以在新创建的ArkTS基础运行时环境中使用。

本工程展示了使用napi_load_module_with_info接口进行对不同内容的加载，代码详细描述可查如下链接。

- [使用Node-API接口进行模块加载](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/napi/use-napi-load-module-with-info.md)

### 效果预览

| 首页图                                                                        | 执行结果图                                                                    |
| ----------------------------------------------------------------------------- | ----------------------------------------------------------------------------- |
| <img src="./screenshots/NodeApiLoadModuleWithInfo1.png" style="zoom: 50%;" /> | <img src="./screenshots/NodeApiLoadModuleWithInfo2.png" style="zoom: 50%;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面呈现LoadModule效果和六个按钮，点击按钮后可以调用napi_load_module_with_info接口进行对不同内容进行加载，并修改Text文本内容。
3. 运行测试用例NodeApiLoadModuleWithInfo.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │       ├── libentry
 │   │       └── libentryone
 │   │       └── libentrytwo
 │   │       └── libentrythree
 │   │       └── libentryfour
 │   │   ├── api.cpp                     // 加载API模块
 │   │   ├── har_name.cpp                // 加载HAR模块名
 │   │   ├── file.cpp                    // 加载模块内文件路径
 │   │   ├── CMakeLists.txt
 │   │   ├── napi_init.cpp               // 加载Native库
 │   │   ├── remote_har.cpp              // 加载远程HAR模块名
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
 │   │       ├── NodeApiLoadModuleWithInfo.test.ets  // 自动化测试代码
 │   │       └── List.test.ets
 har1/                                // HAR加载HAR模块名
 har2/                                // HAR加载HAR模块名
 library/                             // 加载HAR模块名
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
echo code/DocsSample/ArkTS/NodeAPI/NodeAPIClassicUseCases/NodeAPILoadModuleWithInfo > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
