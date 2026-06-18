# GlobalReuse（全局复用）

### 介绍

本示例通过使用[全局复用](https://gitcode.com/openharmony/docs/blob/master/zh-cn/application-dev/ui/arkts-arkui-update-global-reuse.md)中各场景开发实例，主要展示了全局复用池的使用方法和多种常见的使用场景，便于开发者学习与理解。

全局复用是ArkUI提供的组件复用机制，通过配置全局复用池，可以实现跨组件、跨层级的组件复用，提升应用性能和内存使用效率。

### 工程目录

```
entry/src/main/ets/
|---entryability
|---entrybackupability
|---pages
|   |---Index.ets                                         // 主页
|   |---GlobalReuseDefault.ets                           // 默认全局复用池场景
|   |---GlobalReusePool.ets                              // 全局复用池配置场景
|   |---GlobalReusePoolGet.ets                           // 全局复用池信息获取场景
|   |---GlobalReusePoolMultiLevel.ets                    // 多级全局复用池场景
|   |---GlobalReusePoolPerInstance.ets                   // perInstance所有权模式场景
|   |---GlobalReusePoolPrerender.ets                     // 预渲染场景
|   |---GlobalReusePoolReuseID.ets                       // reuseId配置场景
|   |---GlobalReusePoolShared.ets                        // shared共享池场景
```

### 具体实现

* 默认全局复用池场景，展示默认复用池的行为，源码参考[GlobalReuseDefault.ets](./entry/src/main/ets/pages/GlobalReuseDefault.ets)；
  * 使用@ReusableV2装饰ReusableComponent，使其具备复用能力；
  * 在ChildComponentA和ChildComponentB中都使用ReusableComponent；
  * 由于使用默认复用池，在父组件Index的if分支切换时，ChildComponentA被销毁，其默认复用池也随之销毁，ReusableComponent无法被ChildComponentB复用；
* 全局复用池配置场景，展示全局复用池的配置方法，源码参考[GlobalReusePool.ets](./entry/src/main/ets/pages/GlobalReusePool.ets)；
  * 在父组件Index上配置reusePool: 'shared'，启用全局复用池；
  * 通过poolAccepts指定接纳ReusableComponent；
  * 在if分支切换时，ReusableComponent被全局复用池接纳，可被ChildComponentB复用；
* 全局复用池信息获取场景，展示如何获取和操作复用池信息，源码参考[GlobalReusePoolGet.ets](./entry/src/main/ets/pages/GlobalReusePoolGet.ets)；
  * 使用UIUtils.getCustomComponentContext().getReusePool()获取复用池；
  * 通过pool.getReusableInfo(component)获取指定组件的复用信息；
  * 通过修改info.maxCount来控制复用池大小，设置为0时释放对应组件实例；
* 多级全局复用池场景，展示多层级组件复用池的嵌套使用，源码参考[GlobalReusePoolMultiLevel.ets](./entry/src/main/ets/pages/GlobalReusePoolMultiLevel.ets)；
  * EntryComp配置全局复用池接纳ChildA；
  * ParentA配置全局复用池接纳ReusableLeaf；
  * 演示了多层级复用池的协同工作，ReusableLeaf跟随ChildA存入EntryComp的复用池中；
* perInstance所有权模式场景，展示perInstance所有权模式的使用，源码参考[GlobalReusePoolPerInstance.ets](./entry/src/main/ets/pages/GlobalReusePoolPerInstance.ets)；
  * 使用reusePool: 'perInstance'配置perInstance所有权模式；
  * 演示了@Provider和@Consumer在复用组件中的状态同步；
  * 在aboutToReuse中修改@Consumer状态变量，能同步到父组件的@Provider状态变量；
* 预渲染场景，展示如何使用预渲染功能，源码参考[GlobalReusePoolPrerender.ets](./entry/src/main/ets/pages/GlobalReusePoolPrerender.ets)；
  * 使用pool.preRender()方法预渲染复用组件；
  * 通过pool.getReusableInfo()检查复用池状态；
* reuseId配置场景，展示如何使用reuseId进行细粒度复用控制，源码参考[GlobalReusePoolReuseID.ets](./entry/src/main/ets/pages/GlobalReusePoolReuseID.ets)；
  * 通过reuse({ reuseId: () => 'xxx' })为组件指定reuseId；
  * 不同reuseId的组件在复用池中独立管理；
  * 可以通过指定reuseId来清除特定组件的复用实例；
* shared共享池场景，展示多个组件实例共享全局复用池，源码参考[GlobalReusePoolShared.ets](./entry/src/main/ets/pages/GlobalReusePoolShared.ets)；
  * 多个CompA实例共享同一个ReusableCompA的全局复用池；
  * 演示了在删除和添加不同CompA实例时，ReusableCompA如何在多个实例间复用；

### 相关权限

无。

### 依赖

无。

### 约束与限制

1. 本示例仅支持标准系统上运行，支持设备如：RK3568；
2. 本示例为Stage模型，仅支持API12及以上版本SDK；
3. 全局复用池仅支持@ComponentV2装饰的组件；
4. 复用组件必须使用@ReusableV2装饰器；
5. reusePool配置支持'shared'和'perInstance'两种模式；
6. freezeWhenInactive默认为false，可设置为true启用组件冻结。

### 下载

如需单独下载本工程，在本地目录使用git执行如下命令：

```
git init
git config core.sparsecheckout true
echo code/DocsSample/GlobalReuse > .git/info/sparse-checkout
git remote add origin https://gitcode.com/openharmony/applications_app_samples.git
git pull origin master
```
