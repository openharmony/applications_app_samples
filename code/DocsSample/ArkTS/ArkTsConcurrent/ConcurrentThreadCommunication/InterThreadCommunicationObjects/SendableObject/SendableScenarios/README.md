# ArkTS Sendable使用场景

### 介绍

Sendable对象可以在不同并发实例间通过引用传递。通过引用传递方式传输对象相比序列化方式更加高效，同时不会丢失class上携带的成员方法。因此，Sendable主要可以解决两个场景的问题：

- 跨并发实例传输大数据（例如可能达到100KB以上的数据）。
- 跨并发实例传递带方法的class实例对象。

该工程中展示的代码详细描述可查如下链接：

- [Sendable使用场景](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/arkts-utils/sendable-guide.md)

### 效果预览

|                         bigdata模块                          |                     crossconcurrency模块                     |
| :----------------------------------------------------------: | :----------------------------------------------------------: |
| <img src="./screenshots/SendableScenarios_1.png" style="zoom: 50%;" /> | <img src="./screenshots/SendableScenarios_2.png" style="zoom: 50%;" /> |

### 使用说明

1. 运行bigdata模块，分别点击Listener task和Data processing task执行程序
2. 执行结果会即时反馈在屏幕中,并在控制台打印log。
3. 运行crossconcurrency模块，点击Hello World执行程序
4. 执行结果会即时反馈在屏幕中,并在控制台打印log。

### 工程目录

```
bigdata/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets               // 跨并发实例传输大数据场景示例代码
 │   │       ├── sendable.ets            // 跨并发实例传输大数据场景示例代码
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets        // 自动化测试代码
 crossconcurrency/src/
 ├── main
 │   ├── ets
 │   │   ├── crossconcurrencyability
 │   │   ├── pages
 │   │       ├── Index.ets               // 跨并发实例传递带方法的class实例对象示例代码
 │   │       ├── sendable.ets            // 跨并发实例传递带方法的class实例对象示例代码
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   ├── test
 │   │       ├── Ability.test.ets        // 自动化测试代码
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
echo code/DocsSample/ArkTs/ArkTsConcurrent/ConcurrentThreadCommunication/InterThreadCommunicationObjects/SendableObject/SendableScenarios > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````