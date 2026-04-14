# ContactsKit

### 介绍

Contacts Kit（联系人服务）可以帮助开发者轻松实现联系人的增删改查等功能。该kit提供了一系列API，可以让开发者在应用中快速集成联系人管理功能。

### 效果预览

![Index](screenshots/index.png)

### 使用说明

1. 使用Picker选择联系人。
2. 联系人管理（受限开放）API添加联系人。
3. 使用picker新建联系人。
4. 使用picker更新联系人。

### 工程目录

```
entry/src/
|---main
|   |---ets
|   |   |---pages
|   |   |   |---Index.ets                          // 首页
|---ohosTest               
|   |---ets
|   |   |---tests
|   |   |   |---Ability.test.ets                   // 自动化测试用例
```

### 具体实现
* 使用Picker选择联系人:调用contact.selectContacts使用picker选择联系人。
* 联系人管理（受限开放）API添加联系人:使用abilityAccessCtrl.createAtManager().requestPermissionsFromUser获取权限，调用contact.addContact添加联系人。
* 使用picker新建联系人:调用contact.addContactViaUI()使用picker添加联系人。
* 使用picker更新联系人:调用contact.saveToExistingContactViaUI()使用picker更新联系人。

### 相关权限

[ohos.permission.READ_CONTACTS](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/restricted-permissions#ohospermissionread_contacts)

[ohos.permission.WRITE_CONTACTS](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides/restricted-permissions#ohospermissionwrite_contacts)

### 依赖

不涉及。

### 约束与限制

1.本示例仅支持标准系统上运行, 支持设备：RK3568、PHONE、Tablet。

2.本示例仅支持API20版本SDK，镜像版本号：OpenHarmony 6.0.0.x及之后的版本。

3.本示例需要使用DevEco Studio 6.0.0 release (Build Version: 6.0.0.858)才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/DocsSample/Contacts/ContactsKit > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
````