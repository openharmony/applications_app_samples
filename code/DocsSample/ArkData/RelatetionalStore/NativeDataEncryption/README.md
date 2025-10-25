# 通过关系型数据库实现数据持久化 (C/C++)

### 介绍

此示例提供了一套完整的对本地数据库进行管理的机制，包括但不限于增、删、改、查操作。

### 效果预览

| 首页                                                     |
| -------------------------------------------------------- |
| <img src="./browse/start.png" style="zoom:50%;" /> | 

使用说明：

1. 在主页面中通过点击相应的按钮，。

### 工程目录

```
\entry\src\main
            │  module.json5					// 配置文件，用于配置权限等信息
            ├─cpp
            │  └─types
            │     └─libentry
            │         Index.d.ts            // 方法声明文件
            │     CMakeLists.txt            // C/C++编译配置文件
            ├─ets
            │  ├─common
            │  │      Logger.ts				// 打印工具类
            │  ├─entryability
            │  ├─entrybackupability
            │  └─pages
            │          Index.ets			// 主页面，代码参考页面
            └─resources
                ├─base						// 资源文件,内容为英文
                │  ├─element
                │  ├─media
                │  └─profile
                └─zh_CN
                   └─element                // 资源文件,内容为中文

```

### 具体实现

- 本示例提供了一套完整的对本地数据库进行管理的机制，对外提供了一系列的增、删、改、查等接口，也可以直接运行用户输入的SQL语句来满足复杂的场景需要，源码参考：napi_init.cpp。

### 相关权限

无

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行。

2.本示例为Stage模型，支持API20版本SDK。

3.本示例需要使用DevEco Studio 6.0.0 Release及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/UserAuthentication > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```
