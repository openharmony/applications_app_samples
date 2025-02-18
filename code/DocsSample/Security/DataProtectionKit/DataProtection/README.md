# 数据防泄漏服务开发指导

### 介绍

DLP是系统提供的系统级的数据防泄漏解决方案，提供一种称为DLP的文件格式。后缀格式为“原始文件名（包含原始文件后缀）.dlp”，例如“test.docx.dlp”，文件由授权凭证和原始文件密文组成。

应用需要访问DLP文件时，系统会自动安装应用的DLP沙箱分身应用，相当于完全独立的应用，数据和配置会继承原应用，但相互之间并不共享。分身应用在运行时会处于DLP沙箱环境中，访问外部的权限会被限制，以防止数据的泄漏。每当打开一个新的DLP文件会生成一个应用沙箱分身，沙箱应用之间也是相互隔离的，当应用关闭后应用分身会自动卸载，沙箱期间产生的临时数据也会丢弃。

正常情况下，应用不会感知到沙箱的存在，访问的也是解密后的明文，和访问普通文件没有区别，但由于DLP沙箱会限制其访问外部的权限（例如网络、剪切板、截屏、录屏、蓝牙等）。为了更好的用户体验，需要应用进行适配，例如文件只读的情况下，不应显示“保存”按钮，不应主动联网等。

本示例主要展示了数据防泄漏服务开发指导，该工程中展示的代码详细描述可查如下链接中业务扩展场景介绍部分。

- [数据防泄漏服务开发指导](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/DataProtectionKit/dlp-guidelines.md)

### 效果预览

| 首页效果图                                                   |
| ------------------------------------------------------------ |
| <img src="./screenshots/DataProtection.png" style="zoom: 50%;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面呈现上述执行结果图效果，并且具有说明账号未登录，请登录账号后重试的弹窗。
3. 运行测试用例DataProtection.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets                // 数据防泄漏服务开发指导示例代码
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       ├── Ability.test.ets
 │   │       ├── DataProtection.test.ets  // 自动化测试代码
 │   │       └── List.test.ets
```

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568。

2.本示例为Stage模型，支持API16版本SDK，版本号：5.0.4.150，镜像版本号：OpenHarmony_5.0.2.58。

3.本示例需要使用DevEco Studio 5.0.4 Release (Build Version: 5.0.11.100, built on March 28, 2025)及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/Security/DataProtectionKit/DataProtection > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````
