# 证书管理

### 介绍

证书管理主要提供系统级的证书管理能力，实现证书全生命周期（安装、存储、使用和销毁）的管理和安全使用。

本示例主要展示了证书管理中证书管理与证书管理对话框的使用场景。该工程中展示的代码详细描述可查如下链接中介绍。

- [证书管理开发指导](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/DeviceCertificateKit/certManager-guidelines.md)
- [证书管理对话框开发指导](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.1-Release/zh-cn/application-dev/security/DeviceCertificateKit/certManagerDialog-guidelines.md)

### 效果预览

| 首页效果图                                                   | 执行结果图                                                   |
| ------------------------------------------------------------ | ------------------------------------------------------------ |
| <img src="./screenshots/CertificateManagement1.png" style="zoom: 50%;" /> | <img src="./screenshots/CertificateManagement2.png" style="zoom: 50%;" /> |

### 使用说明

1. 运行Index主界面。
2. 页面呈现上述执行结果图效果，点击不同按钮可以跳转到不同功能页面，点击跳转页面中按钮可以执行对应操作，并更新文本内容。
3. 运行测试用例CertificateManagement.test.ets文件对页面代码进行测试可以全部通过。

### 工程目录

```
entry/src/
 ├── main
 │   ├── ets
 │   │   ├── entryability
 │   │   ├── entrybackupability
 │   │   ├── pages
 │   │       ├── Index.ets               // 证书管理示例代码
 │   │       ├── CertManagerGuidelines.ets
 │   │       ├── CertManagerDialogGuidelines.ets
 │   ├── module.json5
 │   └── resources
 ├── ohosTest
 │   ├── ets
 │   │   └── test
 │   │       ├── Ability.test.ets 
 │   │       ├── CertificateManagement.test.ets  // 自动化测试代码
 │   │       └── List.test.ets
```

### 相关权限

[ohos.permission.ACCESS_CERT_MANAGER](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/security/AccessToken/permissions-for-all.md#ohospermissionaccesscertmanager)

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
echo code/DocsSample/Security/DeviceCertificateKit/CertificateManagement > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````