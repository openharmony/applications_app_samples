# 聊天实例应用

### 介绍

这是一个仿聊天类应用，使用了静态布局搭建了不同的页面。为了优化内存与性能体验，在部分list场景使用了懒加载。  

本示例用到了 图片处理能力接口[@ohos.multimedia.image](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-image.md )。  

文件存储管理能力接口[@ohos.fileio](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/apis/js-apis-fileio.md) 。  


### 效果预览
|主页|通讯录|发现|个人页面|
|-------|-------|-------|-------|
|![](screenshots/device/chat_home.png)|![](screenshots/device/chat_address.png)|![](screenshots/device/chat_found.png)|![](screenshots/device/chat_me.png)|

使用说明

1.应用包含“聊天”、”通讯录“、”发现“、”我“四个主页面，使用Tabs组件实现模块的切换，“聊天”和“通讯录”模块使用了LazyForEach懒加载功能。

2.聊天内容页面右上角的图标点击进入聊天信息页面。

3.二级及以上页面左上角都有一个返回按钮。

4.聊天内容页面的下方输入框点击可以输入内容，表情的图标点击可以发送图片。

5.“发现”页面的“聊天社区”点击会进入“聊天社区”页面。

### 工程目录
```
entry/src/main/MainAbility
|---/common
|   |---BasicDataSource.ets                // 封装整个FeatureAbility模块启用，监听Ability对应的窗口等逻辑
|   |---Loggger.ets                        // 封装整个日志
|   |---MsgBase.ets                        // 组件传值定义页面
|---/components                                 
|   |---Header.ets                         // 定义应用头部导航栏
|---/pages                                                               
|   |---ChatDetailPage.ets                 // 具体的某一聊天页面            
|   |---ChatListPage.ets                   // 整体聊天页面
|   |---DiscoverPage.ets                   // 发现页面
|   |---FriendsMomentsPage.ets             // 朋友圈页面
|   |---FriendsPage.ets                    // 通讯录页面
|   |---Index.ets                          // 首页
|   |---SettingPage.ets                    // 我的页面
|---resources/images                       // 放置图片，icon资源等           
                                            
```
#### 相关概念

懒加载：开发框架提供数据懒加载（LazyForEach组件）从提供的数据源中按需迭代数据，并在每次迭代过程中创建相应的组件。

### 具体实现
1、定义要跳转子页面：在entry/pages/index.ets中通过TabContent()定义要跳转的子页面，[源码参考](./entry/src/main/ets/pages/Index.ets)   
例如：跳转通讯录界面：TabContent() {
FriendsPage() }。  
2、使用LazyForEach数据懒加载对“聊天”和“通讯录”模块进行数据渲染：当LazyForEach在滚动容器中使用，框架会根据滚动容器可视区域按需创建组件，当组件划出可视区域外时，框架会进行组件销毁回收以降低内存占用，[源码参考](./entry/src/main/ets/pages/FriendsPage.ets )。  
3、页面之间的跳转通过在config.json中先配置好相关路由，并通过router.push()进行页面跳转,例如：跳转到搜索页面router.push({ url: 'pages/SearchPage' })。  
4、页面组件加载前，通过fileio.readSync以同步的方式读取数据，在EntryAbility生命周期中获取对应的Want信息。

### 相关权限

不涉及。

### 依赖

不涉及。

### 约束与限制

1.本示例已适配API version 10版本SDK，版本号：4.0.7.5。

2.本示例需要使用DevEco Studio 3.1 Release (Build Version: 3.1.0.500, built on April 28, 2023)及以上才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：

````
git init
git config core.sparsecheckout true
echo code/Solutions/IM/Chat/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
````