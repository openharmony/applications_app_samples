# Node-API常见问题

### 介绍

本工程展示了napi_wrap如何保证被wrap的对象按期望顺序析构。详细描述可查如下链接。

- [常见基本功能问题汇总](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/napi/napi-faq-about-common-basic.md)

### 效果预览

|                              首页                               |                               执行及结果即时反馈                               |
| :-------------------------------------------------------------: |:---------------------------------------------------------------------:|
| <img src="./screenshots/NodeAPIDeconstructInOrder_1.png" style="zoom:33%;" width="360;" /> | <img src="./screenshots/NodeAPIDeconstructInOrder_2.png" style="zoom:33%;" width="360;" /> |

### 使用说明

1. 在主界面，可以点击Hello World，开始执行。
2. 执行结果会即时反馈在屏幕中央,并在控制台打印log。

### 工程目录

```
entry/src/
 ├── main
 │   ├── cpp
 │   │   ├── types
 │   │   │   └── libentry
 │   │   ├── CMakeLists.txt
 │   │   ├── napi_init.cpp               // 系统模块加载
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   └── pages
 │   │       └── Index.ets               // 加载模块
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       ├── Ability.test.ets
 │   │       ├── List.test.ets
 │   │       └── NodeAPIDeconstructInOrder.test.ets  // 自动化测试代码
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API20版本SDK，版本号：6.0.0.40，镜像版本号：OpenHarmony_6.0.0.40。

3.本示例需要使用DevEco Studio 5.1.1 Release (Build Version: 5.1.1.820, built on June 28, 2025)及以上版本才可编译运行。。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/NodeAPI/NodeAPIFaqs/NodeAPIDeconstructInOrder > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```