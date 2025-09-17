# TaskPool线程中操作关系型数据库实现案例

### 介绍

本示例通过通讯录场景实例进行讲解，介绍了在 TaskPool 线程中操作关系型数据库的方法。

### 效果预览

效果如下所示：

| 主界面                                                          |详情页|编辑新增页|
|--------------------------------------------------------------|--------------------------------|--------------------------------|
| ![Alt text](entry/src/main/resources/base/media/index.png) |![Alt text](entry/src/main/resources/base/media/index2.png)|![Alt text](entry/src/main/resources/base/media/index3.png)



使用说明

1. 在主界面，点击列表数据。
    * 跳转详情页。
2.  在详情页，点击编辑和删除按钮。
    * 点击编辑按钮跳转编辑页
    * 点击删除按钮跳转主界面，删除数据
3.  在编辑页，修改数据后点击确定。
    * 跳转主界面，修改数据
4.  在主界面，点击加号图标按钮跳转新增页。
    * 修改数据后点击确定跳转主界面，新增数据


### 工程目录

```
entry/src/main/ets/
|---pages
|   |---constant
|   |   |---CommonConstant.ets                 // 使用数据定义
|   |   |---RdbConstant.ets                    // 数据库代码定义        
|   |---model
|   |   |---Contact.ets                        // 数据类型定义         
|   |---view
|   |   |---AddressBookDetail.ets              // 详情页
|   |   |---AddressBookEdit.ets                // 编辑页
|   |   |---AddressBookList.ets                // 主界面列表组件
|   |   |---DatabaseConnection.ets             // 数据库接口定义
|   |   |---OperateRDBInTaskPool.ets           // 主界面
|   |   |---TaskPool.ets                       // 多线程接口定义
```

### 具体实现

* TaskPool线程中操作关系型数据库
    * 创建任务池（taskpool）为数据库操作提供一个多线程的运行环境，将创建好的任务(新增、删除、修改、查询操作)放入taskpool内部任务队列，在子线程中实现数据库增删改查的任务，以此防止阻塞主线程。执行完成后，将结果回调至主线程，从而在主线程中更新数据源和用户界面。这样做不仅提升了应用的响应速度，还确保了用户交互的流畅性。

### 相关权限

无

### 依赖

无

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备：Phone;
2. 本示例为Stage模型，支持API20版本SDK，SDK版本号(API Version 20),镜像版本号(6.0.0.31)。
3. 本示例需要使用DevEco Studio 版本号(6.0.0.6)版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/ArkTS1.2/OperaterdbintaskpoolSample/ > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull
```