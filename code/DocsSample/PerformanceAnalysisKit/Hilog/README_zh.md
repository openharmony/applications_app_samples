# 使用HiLog打印日志

###  介绍

本示例主要展示了使用HiLog打印日志相关的功能，在应用开发过程中，可在关键代码处输出日志信息。在运行应用后，通过查看日志信息来分析应用执行情况（如应用是否正常运行、代码运行时序、运行逻辑分支是否正常等）。

HiLog日志系统，提供给系统框架、服务、以及应用，用于打印日志，记录用户操作、系统运行状态等。

该工程中的展示的代码详细描述可查如下链接：

- [使用HiLog打印日志（ArkTS）](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/dfx/hilog-guidelines-arkts.md)

- [使用HiLog打印日志（C/C++）](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/dfx/hilog-guidelines-ndk.md)

###  效果预览

|                             主页                             |
| :----------------------------------------------------------: |
| <img src="./screenshots/Screenshot_20250219094412587.jpeg" alt="z" width = "400" /> |

#### 使用说明

##### 1.Hilog（ArkTS）使用说明

1.在应用侧主界面，点击"HiLog ArkTS"按钮；

2.在DevEco界面切换到"Log"窗口，日志过滤选择"No filters",搜索内容设置为"testTag"。此时窗口仅显示符合条件的日志，打印日志结果为：

```
01-16 14:46:54.316   2997-2997     A0ff00/testTag                  com.sampl...logarkts  I     hilog_info_test
01-16 14:46:54.316   2997-2997     A0ff00/testTag                  com.sampl...logarkts  D     hilog_debug_test
01-16 14:46:54.316   2997-2997     A0ff00/testTag                  com.sampl...logarkts  W     hilog_warn_test
01-16 14:46:54.316   2997-2997     A0ff00/testTag                  com.sampl...logarkts  F     hilog_fatal_test
01-16 14:46:54.316   2997-2997     A0ff00/testTag                  com.sampl...logarkts  E     hilog_error_test
01-16 14:46:54.316   2997-2997     A0ff00/testTag                  com.sampl...logarkts  I     A log with a domainID of 0xFF00 and a label of testTag can print logs at the Info level or higher.
```

##### 2.HiLog（C++）使用说明

1.在主界面，点击"HiLog C++"按钮；

2.切换到"Log"窗口，日志过滤选择"No filters"，搜索内容设置为"Failed to test"。此时窗口显示报错的日志，打印日志结果为"Failed to test"。

###  工程目录

```
entry/src/main
├─cpp
│  ├─CMakeLists.txt  //导入so链接
│  └─napi_init.cpp   //功能函数
│
└─ets
   └─pages
     └─Index.ets     //主页

```

###  具体实现

1.ArkTS实现时只需在按钮的点击事件中添加各种类型日志的打印函数

2.C++实现时在napi_init.cpp添加具有打印功能的函数，在主页按钮中增加一个单击事件，并调用功能函数打印一条日志。

###  相关权限

不涉及。

###  依赖

不涉及。

###  约束与限制

1. 本示例仅支持标准系统上运行，支持设备：RK3568；
2. 本示例已适配API14版本SDK，版本号：5.0.2.58，镜像版本号：OpenHarmony5.0.2.58；
3. 本示例需要使用DevEco Studio(5.0.3.910)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/PerformanceAnalysisKit/Hilog/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```