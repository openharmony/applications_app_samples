# E类加密数据库Sample

### 介绍

从安全角度考虑，为满足部分敏感数据的安全特性，提供了E类加密数据库的方案以提高锁屏下数据的安全性。应用在申请ohos.permission.PROTECT_SCREEN_LOCK_DATA权限后会在EL5路径下创建一个E类数据库，在锁屏的情况下（未调用Access接口获取保留文件密钥）会触发文件密钥的销毁，此时E类数据库不可读写。当锁屏解锁后，密钥会恢复，E类数据库恢复正常读写操作。这样的设计可以有效防止用户数据的泄露。本示例主要展示了[E类加密数据库的使用指南](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/database/encrypted_estore_guidelines.md)中ArkTS场景的开发示例，帮助开发者更好地理解和使用E类加密数据库。

### 效果预览

| 主UI界面 |
|------|
| ![image](screenshots/main.PNG) |

使用说明

1. 启动应用。
2. 点击加锁/解锁和StoreType按钮切换和查询当前数据库类型estore或cstore。
3. 通过Put，Get，Delete，Update等按钮，执行相应的功能。

### 工程目录

给出项目中关键的目录结构并描述它们的作用，示例如下：

```
entry/src/main/ets
|---entryability
|   |---Mover.ts                   // 提供数据库数据迁移接口。
|   |---Store.ts                   // 提供了获取数据库，在数据库中插入、删除、更新数据等接口。
|   |---SecretKeyObserver.ts       // 提供了获取当前密钥状态的接口。
|   |---EntryAbility.ets           // 提供了ECStoreManager类用于管理应用的E类数据库和C类数据库。
|   |---EntryAbility.ets           // 模拟应用启动期间，注册公共事件的监听，并配置相应的数据库信息、密钥状态信息等。
|---pages
|   |---Index.ets                  // UI界面布局，Index按键事件。
```

### 具体实现

* 主UI界面，使用Button按钮，通过点击按钮来模拟应用操作数据库，如插入数据、删除数据、更新数据和获取数据数量的操作等，展示数据库基本的增删改查能力，源码参考：[Index.ets](entry/src/main/ets/pages/Index.ets)。
    * 使用加锁/解锁模拟应用数据库密钥加锁和解锁状态。
    * 通过StoreType查询当前数据库类型estore或cstore。
    * 通过Put创建或打开数据库并且插入一条数据。
    * 通过Get创建或打开数据库并且查询当前数据库有多少条数据。
    * 通过Delete创建或打开数据库并且删除一条数据。
    * 通过Update创建或打开数据库并且修改一条数据。
* Mover提供数据库数据迁移接口，在锁屏解锁后，若C类数据库中存在数据，使用该接口将数据迁移到E类数据库，源码参考：[Mover.ets](entry/src/main/ets/entryability/Mover.ts)。
* Store提供了获取数据库，在数据库中插入数据、删除数据、更新数据和获取当前数据数量的接口，源码参考：[Store.ets](entry/src/main/ets/entryability/Store.ts)。
* SecretKeyObserver该类提供了获取当前密钥状态的接口，在密钥销毁后，关闭E类数据库，源码参考：[SecretKeyObserver.ets](entry/src/main/ets/entryability/SecretKeyObserver.ts)。
* ECStoreManager用于管理应用的E类数据库和C类数据库。支持配置数据库信息、配置迁移函数的信息，可根据密钥状态为应用提供相应的数据库句柄，并提供了关闭E类数据库、数据迁移完成后销毁C类数据库等接口，源码参考：[ECStoreManager.ets](entry/src/main/ets/entryability/ECStoreManager.ts)。
* EntryAbility，模拟应用启动期间，注册对COMMON_EVENT_SCREEN_LOCK_FILE_ACCESS_STATE_CHANGED公共事件的监听，并配置相应的数据库信息、密钥状态信息等，源码参考：[EntryAbility.ets](entry/src/main/ets/entryability/EntryAbility.ets)。

### 相关权限

1.ohos.permission.PROTECT_SCREEN_LOCK_DATA。

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