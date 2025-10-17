# HiTraceChain NDK接口使用样例

###  介绍

本示例主要展示了使用HiTraceChain提供分布式跟踪接口。

HiTraceChain是基于云计算分布式跟踪调用链思想，在端侧业务流程（涉及跨线程、跨进程、跨设备）中的一种轻量级实现。hiTraceChain在业务控制面流程中，生成和传递唯一跟踪标识，在业务流程中输出的各类信息中（包括应用事件、系统时间、日志等）记录该跟踪标识。在调试、问题定位过程中，开发者可以通过该唯一跟踪标识将本次业务流程端到端的各类信息快速关联起来。

该工程中的展示的代码详细描述可查如下链接：

- [使用HiTraceChain打点（C/C++）](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/dfx/hitracechain-guidelines-ndk.md)


###  效果预览

|                             主页                             |
| :----------------------------------------------------------: |
| <img src="./screenshots/Snipaste_2025-10-17_15-32-47.png" alt="z" width = "400"> |

#### 使用说明

1. 点击设备上的“clickTime=0”按钮触发业务逻辑。 使用关键字“testTag”过滤日志，查看该业务代码打印的hilog日志。
```
06-05 21:26:01.006   9944-9944     C02D33/com.exa...tion/HiTraceC  com.examp...lication  I     [a92ab19ae90197d 0 0]HiTraceBegin name:testTag: hiTraceChain begin flags:0x00.
06-05 21:26:01.006   9944-9944     A00000/com.exa...ation/testTag  com.examp...lication  I     [a92ab19ae90197d 0 0]HiTraceId is valid
06-05 21:26:01.006   9944-9944     A00000/com.exa...ation/testTag  com.examp...lication  I     [a92ab19ae90197d 0 0]HITRACE_FLAG_INCLUDE_ASYNC is enabled
06-05 21:26:01.007   9944-9944     A00000/com.exa...ation/testTag  com.examp...lication  I     Add, HiTraceChain end
06-05 21:26:01.007   9944-9944     A00000/com.exa...ation/testTag  com.examp...lication  I     Test NAPI 2 + 3 = 5
06-05 21:26:01.007   9944-13961    A00000/com.exa...ation/testTag  com.examp...lication  I     [a92ab19ae90197d 2544fdb 0]Print1
06-05 21:26:01.007   9944-13961    A00000/com.exa...ation/testTag  com.examp...lication  I     Print1, HiTraceChain end
06-05 21:26:01.008   9944-13962    A00000/com.exa...ation/testTag  com.examp...lication  I     [a92ab19ae90197d 236699a 2544fdb]Print2
06-05 21:26:01.008   9944-13962    A00000/com.exa...ation/testTag  com.examp...lication  I     Print2, HiTraceChain end
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
echo code/DocsSample/PerformanceAnalysisKit/HiTrace/HitraceChain_NDK/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
