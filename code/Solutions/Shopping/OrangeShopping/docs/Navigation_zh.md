# Navigation开发示例应用

## 简介

在应用开发时，我们常常遇到，需要在应用内多页面跳转场景时中使用`Navigation`导航组件做统一的页面跳转管理，它提供了一系列属性方法来设置页面的标题栏、工具栏以及菜单栏的各种展示样式。除此之外还拥有动态加载，navPathStack路由跳转，挎包引用Hsp等能力。

本文就以Navigation开发示例应用为例，来展开讲解Navigation以上的技术点，帮助开发者快速学习。

## 场景概述

ArkUI中，应用内导航组件Navigation一般作为Page页面的根容器， Navigation组件主要包含主页和内容页。

主页由标题栏、内容区和工具栏组成，其中内容区默认首页显示导航内容(Navigation的子组件) 或非首页显示(NavDestination的子组件)，首页和非首页通过路由进行切换。

Navigation的路由切换的方式有两种，本次示例主要介绍NavPathStack的使用。

* 在API Version 9上，首页导航内容需要配合NavRouter组件实现页面路由。
* 从API Version 10开始，首页推荐使用NavPathStack配合NavDestination属性进行页面路由。

> 通过本篇文章的学习，你将学会：
>
> 1.如何使用**NavPathStack路由转场**
>
> 2.如何在**Navigation中跨包引用hsp**
>
> 3.如何在**Navigation中使用动态加载**

## Router场景与Navigation适用场景对比

| 组件  | 适用场景 | 特点                | 专场动画效果对比 |
|-----|------|-------------------|----------|
| Router | 模块间与模块内页面切换  | 通过每个页面的url实现模块间解耦 | 页面平推转场效果 |
| Navigation | 模块内页面切换  | 通过组件级路由统一路由管理     | 向右折叠转场效果 |

## 使用NavPathStack路由转场
NavPathStack是Navigation路由栈，通过对栈内元素的操作，完成页面的路由转场。详细API如下表：

| API             | 描述                                                        |
| --------------- | ----------------------------------------------------------- |
| pushPath        | 将info指定的NavDestination页面信息入栈。                    |
| pushPathByName  | 将name指定的NavDestination页面信息入栈，传递的数据为param。 |
| pop             | 弹出路由栈栈顶元素。                                        |
| popToName       | 回退路由栈到第一个名为name的NavDestination页面。            |
| popToIndex      | 回退路由栈到index指定的NavDestination页面。                 |
| moveToTop       | 将第一个名为name的NavDestination页面移到栈顶。              |
| moveIndexToTop  | 将index指定的NavDestination页面移到栈顶。                   |
| clear           | 清除栈中所有页面。                                          |
| getAllPathName  | 获取栈中所有NavDestination页面的名称。                      |
| getParamByIndex | 获取index指定的NavDestination页面的参数信息。               |
| getParamByName  | 获取全部名为name的NavDestination页面的参数信息。            |
| getIndexByName  | 获取全部名为name的NavDestination页面的位置索引。            |



### 实现思路

NavPathStack通过pushPath跳转页面，通过pop返回：  
1、通过pushPath跳转，如主页—>商品详情页，通过使用源码参考[MainPage.ets](CommonAppDevelopment/feature/navigationhome/src/main/ets/view/MainPage.ets)，

```
this.pageStack.pushPath({ name: 'GoodsDetailView', param: item })
```

2、NavPathStack通过pop返回，从详情页—>返回到主页，[GoodsDetailView.ets](CommonAppDevelopment/feature/navigationhome/src/main/ets/view/GoodsDetailView.ets)

```
.onBackPressed(() => {this.pageStack.pop(); return true;})
```

### 开发步骤

1、在pageMap组件中定义需要用到的页面，定义NavPathStack对象，并用provider传递给全部子组件，Product模块的Home页面build中，定义navigation容器并设置navDestination()属性加载PageMap组件，并将需要使用容器的组件引入并调用。

```javascript
import { NavigationHomePage} from '@ohos/navigation-component';

@Provide('pageStack') pageStack: NavPathStack = new NavPathStack();

@Builder
PageMap(name: string) {
  if (name === HomeConstants.GOODS_NAME) {
    // 商品列表详情页
    GoodsDetailView()
  } else if (name === HomeConstants.VIDEO_NAME) {
    // 商品视频介绍页
    VideoView()
  } else if (name === HomeConstants.LIVE_NAME) {
    // 直播页
    LiveView()
  }
}

build() {
  Navigation(this.pageStack) {
    NavigationHomePage();
  }
  .hideTitleBar(true)
  .navDestination(this.PageMap)
}
```



2、NavigationHomePage中定义NavDestination并包括需要被加载的组件。

```javascript
export struct NavigationHomePage {

NavDestination() {
  MainPage()
   }
}
```

3、在mainpage中Consume引入pageStack，通过NavPathStack的api触发切换组件。

```javascript
@Consume('pageStack') pageStack: NavPathStack;

.onClick(() => {
 this.pageStack.pushPath({ name: 'GoodsDetailView', param: item })
 })
```

4、在GoodsDetailView中，通过pop出栈，返回前页。

```javascript
@Consume('pageStack') pageStack: NavPathStack;
.onBackPressed(() => {
  this.pageStack.pop();
  return true;
})
```

## Navigation中跨包引用hsp

本示例以创建Navigationhome的hsp包为例，并介绍如何混合编译工程[Hsp包介绍及详细操作步骤](https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/quick-start/in-app-hsp.md/)

### 实现思路

创建navigationhome模块，作为HSP，在product的entry中引用创建的HSP模块。

### 开发步骤

* 在根目录右键新创建module为Shared Library类型的hsp模块，并将模块命名为navigationhome并拖拽至feature文件夹下做包的统一管理；
* 定义hsp出口：在创建后的hsp包内编写业务代码，并在index.ets中export组件。[源码参考](CommonAppDevelopment/feature/navigationhome/src/main/ets/pages/NavigationHomePage.ets)；
* 引用方如何使用hsp：product包通过在oh-package.json5文件中加入定义的hsp依赖。[源码参考](CommonAppDevelopment/product/entry/oh-package.json5)；
 ```
  "dependencies": {
     "@ohos/navigation-component": "file:../../feature/navigationhome"
   }
 ```
* hap中使用：在组件中引入依赖。[源码参考](CommonAppDevelopment/product/entry/src/main/ets/pages/Home.ets)
 ```
 import { NavigationHomePage, GoodsDetailView, VideoView, LiveView } from '@ohos/navigation-component';
 ```
* 编译时需选中detailPageHsp模块，在ide的工具栏中选择build-Make Module 'detailPageHsp'。
* 运行时，需要在运行模块处配置edit Configuration并勾选Deploy Multi Hap Packages进行混合编译，即可运行。[详细操作步骤](https://docs.openharmony.cn/pages/v4.0/zh-cn/application-dev/quick-start/in-app-hsp.md/)



## Navigation中使用动态加载
* 本示例通过定义一个需要被动态加载的组件DetailPage，配合Navigation。源码参考[DetailPage.ets](feature/detailPageHsp/src/main/ets/main/DetailPage.ets)；


### 实现思路

* 定义一个DynamicLoader动态回调类作为容器，用来注册和调用动态加载函数。源码参考[DynamicLoader.ets](feature/navigationHome/src/main/ets/common/DynamicLoader.ets)；
* 将DetailPage组件用DetailPageLoader函数封装，当DetailPageLoader被调用时，会渲染DetailPage页面。源码参考[DetailPageLoader.ets](entry/src/main/ets/pages/DetailPageLoader.ets)；
* 在主页实现动态加载DetailPage的步骤如下：
  由于navDestination无法直接动态import组件（import是函数，组件中无法引用函数），此处采用声明@BuilderParam detailPageLoader函数，在点击时初始化此函数，此时navDestination中可以调用this.detailPageLoader()从而加载组件DetailPage。


## 开发步骤

a)主页Home中定义组件加载函数@BuilderParam detailPageLoader: () => void，用来承接await import异步导入detailPageLoader的结果。源码参考[Home.ets](entry/src/main/ets/pages/Home.ets)，
   ```
   @BuilderParam detailPageLoader: () => void
   ```
b)注册异步函数，点击时为detailPageLoader初始化,当满足key为DetailPage时，此时异步的加载DetailPageLoader，渲染DetailPage源码参考[Home.ets](entry/src/main/ets/pages/Home.ets)，
  ```
  DynamicLoader.getInstance().register(
    async (key: string) => {
      if (key === "DetailPage") {
        let obj = await import("./DetailPageLoader")
        this.detailPageLoader = obj.DetailPageLoader;
      }
    }
  ```
c) 定义NavDestination中动态加载函数，当存在跳转行为时，会调用此函数,源码参考[Home.ets](entry/src/main/ets/pages/Home.ets)；
  ```
   PageMap(name: string, param: NavPathStack) {
     if (name === 'DetailPage') {
       this.detailPageLoader();
   })
  ```
d)按钮触发点击函数，调用detailPageLoader，此时真正的初始化@BuilderParam detailPageLoader，并通过Navigation中PageMap动态加载组件DetailPage。,源码参考[GoodsList.ets](feature/navigationHome/src/main/ets/components/good/GoodsList.ets)，
  ```
  Column() // 首页goodsList组件
    .onClick(() => {
       // 动态加载组件
       DynamicLoader.getInstance().fire('DetailPage').then(()=>{
         this.active = true;
         this.pageStack.pushPathByName('DetailPage', item);
       })
    })
  ```


## 运行效果

 ![shopping.gif](../screenshots/device/shopping.gif) 


## 参考文档

[1] [桔子购物sample · OpenHarmony - Gitee.com](https://gitee.com/openharmony/applications_app_samples/tree/master/code/Solutions/Shopping/OrangeShopping)

[2] [Navigation组件 · OpenHarmony/docs - Gitee.com](https://gitee.com/openharmony/docs/blob/master/zh-cn/application-dev/reference/arkui-ts/ts-basic-components-navigation.md)