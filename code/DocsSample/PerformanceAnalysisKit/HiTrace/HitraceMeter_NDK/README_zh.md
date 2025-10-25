# HiTraceMeter NDK接口使用样例

###  介绍

本示例主要展示了使用HiTraceMeter提供系统性能打点接口。开发者通过在关键代码位置调用HiTraceMeter接口提供的API接口，能够有效跟踪进程轨迹、查看系统性能。

该工程中的展示的代码详细描述可查如下链接：

- [使用HiTraceMeter跟踪性能（C/C++）](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/dfx/hitracemeter-guidelines-ndk.md)


###  效果预览

|                             主页                             |
| :----------------------------------------------------------: |
| <img src="./screenshots/Snipaste_2025-10-17_14-47-32.png" alt="z" width = "400"> |

#### 使用说明

1.在主界面点击Hello World文本；DevEco Studio Terminal 中执行如下命令：

```
PS D:\xxx\xxx> hdc shell
$ hitrace --trace_begin app
```

2.执行抓取trace命令后，先在设备中点击几次HiTraceMeter ArkTS按钮，继续在Terminal窗口执行命令：

```
$ hitrace --trace_dump | grep myTest
```

3.成功输出如下数据即为成功：

```
<...>-49837   (-------) [002] .... 349137.708093: tracing_mark_write: S|49837|H:myTestAsyncTrace|1001|M62|categoryTest|key=value
<...>-49837   (-------) [002] .... 349137.708103: tracing_mark_write: C|49837|H:myTestCountTrace|1|M62
<...>-49837   (-------) [002] .... 349137.708201: tracing_mark_write: S|49837|H:myTestAsyncTrace|1002|M62|categoryTest|key=value
<...>-49837   (-------) [002] .... 349137.708209: tracing_mark_write: C|49837|H:myTestCountTrace|2|M62
<...>-49837   (-------) [002] .... 349137.708239: tracing_mark_write: F|49837|H:myTestAsyncTrace|1001|M62
<...>-49837   (-------) [002] .... 349137.708246: tracing_mark_write: F|49837|H:myTestAsyncTrace|1002|M62
<...>-49837   (-------) [002] .... 349137.708252: tracing_mark_write: B|49837|H:myTestSyncTrace|M62|key=value
<...>-49837   (-------) [002] .... 349137.708301: tracing_mark_write: S|49837|H:myTestAsyncTrace|1003|M62|categoryTest|key0=value0,key1=value1,key2=value2,key3=value3,key4=value4,key5=value5,key6=value6,key7=value7,key8=value8,key9=value9
<...>-49837   (-------) [002] .... 349137.708323: tracing_mark_write: F|49837|H:myTestAsyncTrace|1003|M62
```

4. 停止采集trace
```
$ hitrace --trace_finish
```

###  工程目录

```
└── entry
    └── src
        └── main
            ├── cpp
            │   ├── CMakeLists.txt
            │   ├── napi_init.cpp
            │   └── types
            │       └── libentry
            │           ├── Index.d.ts
            │           └── oh-package.json5
            └── ets
                ├── entryability
                │   └── EntryAbility.ets
                ├── entrybackupability
                │   └── EntryBackupAbility.ets
                └── pages
                    └── Index.ets
```

###  具体实现

1. ArkTS项目可以在"@kit.PerformanceAnalysisKit"中导入对应模块即可在各种场景下调用对应函数，如在index.ets中直接调用，或者在EntryAbility.ets函数中在应用的各个生命周期内添加功能函数以实现应用自动在“启动”或“结束”时进行性能分析。
2. C++项目可以在CMakeLists.txt里的target_link_libraries中添加对应功能的包，在napi_init.cpp中添加注册自定义C++功能函数（还需在index.d.ts中声明）后，即可在各种场景下通过"libentry.so"库自定义一个对象来调用注册声明的测试函数即可。

###  相关权限

不涉及。

###  依赖

不涉及。

###  约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568；
2. 本示例已适配API20版本SDK，版本号：6.0.0.47，镜像版本号：OpenHarmony6.0.2.55；
3. 本示例需要使用DevEco Studio(6.0.0.858)及以上版本才可编译运行。

###  下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/PerformanceAnalysisKit/HiTrace/HitraceMeter_NDK/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
