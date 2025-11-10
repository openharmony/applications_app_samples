# @Type装饰器：标记类属性的类型

### 介绍

本示例展示了在一个Stage模型中，开发基于ArkTS UI的@Type装饰器：标记类属性的类型的应用，具体可参考[@Type装饰器：标记类属性的类型](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/state-management/arkts-new-type.md)。

应用通过@Type配合PersistenceV2使用
### 效果预览

| 进入页面,点击childNumber                      | 点击后                        | 删除应用进程                     | 再次点击桌面应用启动                 | 最终页面还是点击childNumber后的效果    |
|----------------------------|----------------------------|----------------------------|----------------------------|----------------------------|
| ![image](screenshot/1.png) | ![image](screenshot/2.png) | ![image](screenshot/3.png) | ![image](screenshot/4.png) | ![image](screenshot/5.png) |

使用说明

1. 进入应用，点击childNumber。

2. 删除应用进程，再次点击进入应用，观察效果是不是和点击childNumber后的效果一致。

### 工程目录

给出项目中关键的目录结构并描述它们的作用，示例如下：

```
entry/src/main/ets/
|---pages
|   |---Index.ets                          // 应用入口页面
|   |---DataModel.ets                      // 数据模型
```

### 具体实现

* 通过@ObservedV2和@Trace创建一个子类，再@ObservedV2和@Trace创建一个包含子类对象的父类；
* 创建PersistenceV2c持久化父类的实例；


### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.  本示例支持标准系统上运行，支持设备：RK3568；

2. 本示例支持API20版本SDK，版本号：6.0.0.47；

3.  本示例已支持使DevEco Studio 6.0.0 Release (构建版本：6.0.0.858，构建 2024年12月12日)编译运行；

4. 高等级APL特殊签名说明：无；

### 下载

如需单独下载本工程，执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/ArkUISample/NewType > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```