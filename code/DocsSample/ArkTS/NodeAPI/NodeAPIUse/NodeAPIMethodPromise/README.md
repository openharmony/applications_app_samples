# ArkTS使用Node-API调用返回值为promise的ArkTS方法

### 介绍

当ArkTS的返回值为promise，开发者可以按照以下方式在自己创建的ArkTS运行环境中调用异步的ArkTS接口。

- [使用Node-API调用返回值为promise的ArkTS方法](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/napi/use-napi-method-promise.md)

### 效果预览

| 首页                                                                     | 执行结果图                                                               |
| ------------------------------------------------------------------------ | ------------------------------------------------------------------------ |
| <img src="./screenshots/NodeAPIMethodPromise1.png" style="zoom: 50%;" /> | <img src="./screenshots/NodeAPIMethodPromise2.png" style="zoom: 50%;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面呈现上述首页效果，点击按钮，随后点击界面显示的文本字符串即可触发程序执行。
3. 运行测试用例NodeAPIMethodPromise.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │       ├── Index.d.ts
 │   │       ├── oh-package.json5
 │   │   ├── CMakeLists.txt
 │   │   ├── hello.cpp
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets                      // 使用Node-API调用返回值为promise的ArkTS方法示例代码
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       ├── Ability.test.ets
 │   │       ├── NodeAPIMethodPromise.test.ets  // 自动化测试代码
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
echo code/DocsSample/ArkTs/NodeAPI/NodeAPIUse/NodeAPIMethodPromise > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
