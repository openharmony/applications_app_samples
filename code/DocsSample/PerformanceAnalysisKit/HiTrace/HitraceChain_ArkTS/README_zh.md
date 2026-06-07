# HiTraceChain ArkTS接口使用样例

###  介绍

本示例主要展示了使用HiTraceChain提供分布式跟踪接口。

HiTraceChain是基于云计算分布式跟踪调用链思想，在端侧业务流程（涉及跨线程、跨进程、跨设备）中的一种轻量级实现。hiTraceChain在业务控制面流程中，生成和传递唯一跟踪标识，在业务流程中输出的各类信息中（包括应用事件、系统时间、日志等）记录该跟踪标识。在调试、问题定位过程中，开发者可以通过该唯一跟踪标识将本次业务流程端到端的各类信息快速关联起来。

本样例介绍在async/await和promise/then异步任务中使用HiTraceChain。

该工程中的展示的代码详细描述可查如下链接：

- [使用HiTraceChain打点（ArkTS）](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/dfx/hitracechain-guidelines-arkts.md)



###  效果预览

|                             主页                              |
|:-----------------------------------------------------------:|
| <img src="./screenshots/example.jpg" alt="z" width = "400"> |

#### 使用说明

1.在主页面上点击设备上的“testHiTraceIdPassedAutomatically”按钮，触发业务逻辑。 使用关键字“testTag”过滤日志，查看该业务代码打印的hilog日志。
```
05-28 11:38:40.809   26674-26674   A00000/testTag                  com.examp...sample_a  I     Ability onForeground
05-28 11:38:42.089   26674-26674   A00000/testTag                  com.examp...sample_a  I     HiTraceId is invalid, begin hiTraceChain
05-28 11:38:42.089   26674-26674   C02d33/HiTraceC                 com.examp...sample_a  I     [a92ab1b8c215ca8, 0, 0] HiTraceBegin name:testTag: hiTraceChain begin flags:0x01.
05-28 11:38:42.089   26674-26674   A00000/testTag                  com.examp...sample_a  I     [a92ab1b8c215ca8, 0, 0] record with traceId at first task
05-28 11:38:42.090   26674-26674   A00000/testTag                  com.examp...sample_a  I     hiTraceChain end in main thread
05-28 11:38:42.090   26674-26674   A00000/testTag                  com.examp...sample_a  I     [a92ab1b8c215ca8, 6897b7, 0] record with traceId at task 1
05-28 11:38:42.091   26674-26674   A00000/testTag                  com.examp...sample_a  I     [a92ab1b8c215ca8, 3063577, 6897b7] record with traceId at task 2
05-28 11:38:42.091   26674-26674   A00000/testTag                  com.examp...sample_a  I     [a92ab1b8c215ca8, 2a7cb16, 3063577] record with traceId at task 3
05-28 11:38:42.091   26674-26674   A00000/testTag                  com.examp...sample_a  I     [a92ab1b8c215ca8, 3d0ce5c, 2a7cb16] record with traceId at task 4
05-28 11:38:42.091   26674-26674   A00000/testTag                  com.examp...sample_a  I     [a92ab1b8c215ca8, 26b40d, 3d0ce5c] record with traceId at task 5
05-28 11:38:42.091   26674-26674   A00000/testTag                  com.examp...sample_a  I     [a92ab1b8c215ca8, 2f94e79, 26b40d] record with traceId at task 6
05-28 11:38:42.091   26674-26674   A00000/testTag                  com.examp...sample_a  I     [a92ab1b8c215ca8, 1cb2996, 2f94e79] record with traceId at task 7
05-28 11:38:42.091   26674-26674   A00000/testTag                  com.examp...sample_a  I     [a92ab1b8c215ca8, 274b78e, 1cb2996] record with traceId at task 8
05-28 11:38:42.092   26674-26674   A00000/testTag                  com.examp...sample_a  I     [a92ab1b8c215ca8, 3ea2ad1, 274b78e] record with traceId at task 9
05-28 11:38:42.092   26674-26674   A00000/testTag                  com.examp...sample_a  I     [a92ab1b8c215ca8, 14713c6, 3ea2ad1] record with traceId at task 10
05-28 11:38:42.092   26674-26674   A00000/testTag                  com.examp...sample_a  I     [a92ab1b8c215ca8, c2ce31, 14713c6] record with traceId at then function
```
2.在主页面上点击设备上的“testHiTraceIdPassedManually”按钮，触发业务逻辑。 使用关键字“testTag”过滤日志，查看该业务代码打印的hilog日志。

```
05-28 11:39:10.109   26674-26674   A00000/testTag                  com.examp...sample_a  I     HiTraceId is invalid, begin hiTraceChain
05-28 11:39:10.109   26674-26674   C02d33/HiTraceC                 com.examp...sample_a  I     [a92ab2b8de1accb, 0, 0] HiTraceBegin name:testTag: hiTraceChain begin flags:0x01.
05-28 11:39:10.109   26674-26674   A00000/testTag                  com.examp...sample_a  I     [a92ab2b8de1accb, 0, 0] start testHiTraceIdPassedManually async trace
05-28 11:39:10.110   26674-26674   A00000/testTag                  com.examp...sample_a  I     hiTraceChain end in main thread
05-28 11:39:10.212   26674-26674   A00000/testTag                  com.examp...sample_a  I     [a92ab2b8de1accb, 2783332, 0] end testHiTraceIdPassedManually async trace
```

###  工程目录

```
└── entry
    └── src
        └── main
            └── ets
                ├── entryability
                │   └── EntryAbility.ets
                ├── entrybackupability
                │   └── EntryBackupAbility.ets
                └── pages
                    └── Index.ets     		//主页
```

###  具体实现

1. ArkTS项目可以在"@kit.PerformanceAnalysisKit"中导入对应模块即可在各种场景下调用对应函数，如在index.ets中直接调用，或者在EntryAbility.ets函数中在应用的各个生命周期内添加功能函数以实现应用自动在“启动”或“结束”时进行性能分析。

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
echo code/DocsSample/PerformanceAnalysisKit/HiTrace/HitraceChain_ArkTS/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
