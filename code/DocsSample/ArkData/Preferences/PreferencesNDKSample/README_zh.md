# 用户首选项Sample

### 介绍

本示例主要展示了[通过用户首选项实现数据持久化指南](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/database/data-persistence-by-preferences.md)中C接口场景的开发示例，通过[OH_Preferences_Open](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis-arkdata/capi-oh-preferences-h.md#oh_preferences_open)打开一个Preferences实例对象并创建指向它的指针，调用OH_Preferences_RegisterDataObserver，OH_Preferences_SetInt，OH_Preferences_SetBool，OH_Preferences_SetString以及对应的Get等接口实现对Preferences实例中的名为给定Key的存储键值对增删改查等功能。

### 效果预览

| 主UI界面 |
|------|
| ![image](screenshots/main.PNG) |

使用说明

1. 启动应用。
2. 点击弹出页面中的唯一按钮打开一个Preferences实例对象并创建指向它的指针,并进行增删改查等操作。
3. 使用完毕后会自动调用OH_Preferences_Close删除指定的Preferences实例，若Preferences实例有对应的持久化文件，则同时删除其持久化文件。


### 工程目录

给出项目中关键的目录结构并描述它们的作用，示例如下：

```
entry/src/main/cpp
|   |---napi_init.cpp                      // NKD接口增删改查
entry/src/main/ets
|---pages
|   |---Index.ets                          // UI界面布局
|   |---PreferencesInterface.ets           // 接口调用实现
```

### 具体实现

* 主UI界面，功能包括创建Preference实例，增，删，查，订阅和删除Preference实例，源码参考：[Index.ets](entry/src/main/ets/pages/Index.ets)。
    * 点击弹出页面中的唯一按钮打开一个Preferences实例对象并创建指向它的指针,并进行增删改查等操作。
    * 使用完毕后会自动调用OH_Preferences_Close删除指定的Preferences实例，若Preferences实例有对应的持久化文件，则同时删除其持久化文件。

* 接口实现端，实现主UI界面按键功能，源码参考：[napi_init.cpp](entry/src/main/cpp/napi_init.cpp)。

### 约束与限制

1. 本示例支持标准系统上运行，支持设备：RK3568，Phone。

2. 本示例支持API20版本SDK，版本号：6.0.0 Release。

3. 本示例需要使用DevEco Studio 5.1.1 Release（5.1.1.840）及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/DriverDevelopmentKit > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```