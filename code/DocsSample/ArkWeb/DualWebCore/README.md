# 双内核代码示例

### 介绍

本工程主要实现了对以下指南文档中 https://gitcode.com/openharmony-tpc/chromium_src/blob/132_trunk/web/ReleaseNote/CompatibleWithLegacyWebEngine.md 示例代码片段的工程化，保证指南中示例代码与sample工程文件同源。

### 使用说明

1. 在Web组件初始化之前设置114内核，加载出百度界面代表运行成功。也可通过接口获取当前所使用内核，以判断是否设置成功。

### 工程目录

```
├── entry
│   └── src
│       └── main
│           ├── cpp                                 // C++代码区
│           │   ├── CMakeLists.txt                  // CMAKE配置文件
│           │   ├── napi_init.cpp                   // Native业务代码实现
│           │   └── types
│           │       └── libentry                    // C++接口导出
│           │           ├── Index.d.ts
│           │           └── oh-package.json5
│           ├── ets                                 // ArkTS代码区
│           │   ├── entryability
│           │   │   └── EntryAbility.ets            // 入口类
│           │   ├── entrybackupability
│           │   │   └── EntryBackupAbility.ets      // 备份恢复框架
│           │   └── pages
│           │       └── Index.ets                   // 主页
│           └── resources                           // 应用资源文件
```

### 相关权限

无。

### 依赖

不涉及。

### 约束与限制

1. 本示例仅支持标准系统上运行, 支持设备: Phone。
2. 本示例支持API18版本SDK，SDK版本号(API Version 18 Release)。
3. 本示例使用DevEco Studio版本号(5.1.0 Release)可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkWeb/DualWebCore > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```