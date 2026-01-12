# Worker与主线程共享JSON格式的UI布局

### 介绍

在Worker线程中下载JSON格式的UI布局，使用`quick-transformer`将其转换为Sendable对象，并通过共享内存机制传输到主线程进行UI渲染，实现Worker与主线程间高效的UI布局数据共享。

该工程中展示的代码详细描述可查如下链接：

- [Worker与主线程共享JSON格式的UI布局](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/arkts-utils/worker-and-sendable.md)

### 效果预览

|                                         首页                                          |                                  执行及结果即时反馈                                   |
| :-----------------------------------------------------------------------------------: | :-----------------------------------------------------------------------------------: |
| <img src="./screenshots/SendableJson_1.jpeg" style="zoom: 30%;" width="360;" /> | <img src="./screenshots/SendableJson_2.jpeg" style="zoom: 30%;" width="360;" /> |

### 使用说明

1. 在主界面，点击任意按钮进行跳转，点击Hello World执行程序。
2. 执行结果Text会即时反馈在屏幕中央。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── layout
 │   │   │   └── Layout.ets                              // Sendable UI布局组件
 │   │   ├── pages
 │   │   │   └── Index.ets                               // 首页
 │   │   └── workers
 │   │       └── Worker.ets                              // Worker线程处理
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       └── Ability.test.ets                        // 自动化测试代码
```

### 相关权限

不涉及。

### 依赖

1.安装@kwai_harmony/quick-transformer&class-transformer依赖：

```bash
npm install quick-transformer-codegen-plugin
ohpm install @kwai_harmony/quick-transformer
ohpm install class-transformer
```

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API22版本SDK，版本号：6.0.2.636，镜像版本号：OpenHarmony_6.0.2.636。

3.本示例需要使用DevEco Studio 6.0.2 Release及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkTS/ArkTsConcurrent/ConcurrentThreadCommunication/InterThreadCommunicationObjects/SendableObject/SendableJson > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```