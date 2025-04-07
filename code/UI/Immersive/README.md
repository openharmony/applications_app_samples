# 沉浸式适配案例

### 介绍

开发应用沉浸式效果主要指通过调整状态栏、应用界面和导航条的显示效果来减少状态栏导航条等系统界面的突兀感，从而使用户获得最佳的UI体验。本案例分别针对Navigation、滚动、Web页、底部弹框等场景实现了沉浸式适配，且介绍了实现沉浸式适配的两种方案。

### 效果图预览

![immersive](./entry/src/main/resources/base/media/immersive.gif)

**使用说明：**

1. 首页顶部是Navigation沉浸式，滑动商品列表是滚动场景沉浸式
2. 点击首页的banner进入web页展示Web页沉浸式
3. 点击商品进入商品详情页，展示普通页沉浸式
4. 点击商品详情页的商品评论弹出评论弹框展示底部弹框沉浸式


### 实现思路
页面的显示区域，默认不与系统设置的非安全区域比如状态栏、导航栏区域重叠，默认情况下开发者开发的界面都被布局在安全区域内。而要实现沉浸式效果，则需要设置组件绘制内容突破安全区域的限制。目前系统提供了两种方案：
1. [组件安全区方案](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-develop-apply-immersive-effects-V5#section202081847174413)
2. [窗口全屏布局方案](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-develop-apply-immersive-effects-V5#section15671730447)(此方案比较适合整个应用进行沉浸式使用，单个页面沉浸式建议使用“组件安全区方案”)

#### 两种方案的实现案例如下：
##### 1、通过设置[expandSafeArea](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-universal-attributes-expand-safe-area.md#expandsafearea)这个组件属性， 可支持组件在不改变布局情况下扩展其绘制区域至安全区外。

###### Navigation沉浸式适配
Navigation沉浸式需要区分不同场景，如果是整个页面的背景色设置在Navigation组件，则对Navigation组件设置expandSafeArea熟悉使其整体绘制延伸至状态栏和导航条。若页面顶部和底部背景色不一致，需分别处理，如本案例单独对顶部组件设置了expandSafeArea熟悉使其绘制延伸至状态栏。详情见[NavImmersive.ets](./casesfeature/immersive/src/main/ets/view/NavImmersive.ets)。
```typescript
Navigation(this.navPathStack) {
   Column({ space: COLUM_SPACE }) {
      ...
   }
   .backgroundColor($r("app.color.immersive_column_bg_color"))
   .width('100%')
    // 设置顶部绘制延伸至状态栏
   .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP])
   ...
}
```
###### 滚动场景沉浸式适配
滚动场景需要对每一个嵌套的带有滚动的组件设置expandSafeArea属性，使其视窗范围扩展至导航条。
1. 设置Scroller组件的视窗范围扩展至导航条。详情见[NavImmersive.ets](./casesfeature/immersive/src/main/ets/view/NavImmersive.ets)。
```typescript
Scroll() {
 ...
}
.backgroundColor($r("app.color.immersive_list_bg_color"))
.padding({ bottom: $r("app.integer.immersive_column_padding_bottom") })
.width('100%')
.layoutWeight(LAYOUT_WEIGHT)
.scrollBar(BarState.Off)
.align(Alignment.Top)
// 将底部绘制延伸至导航条
.expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
```
2. 设置GridRow组件的视窗范围扩展至导航条。详情见[GoodsList.ets](./casesfeature/immersive/src/main/ets/components/GoodsList.ets)。
```typescript
 GridRow({ gutter: { x: GUTTER_X, y: GUTTER_Y }, }) {
   ...
 }
 .padding({
   left: $r("app.integer.immersive_grid_row_padding"),
   right: $r("app.integer.immersive_grid_row_padding"),
   top: $r("app.integer.immersive_grid_row_padding"),
   bottom: $r("app.integer.immersive_grid_row_padding")
 })
 .backgroundColor($r("app.color.immersive_list_bg_color"))
 // 设置列表绘制延伸至状态栏
 .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
```
###### Web沉浸式适配
Web场景则需要分为两块，title以及Web页，分别对其进行处理，然后在Web页中设置网页元素对安全区进行避让
1. 设置Web组件绘制延伸至状态栏和导航条。详情见[WebImmersive.ets](./casesfeature/immersive/src/main/ets/view/WebImmersive.ets)。
```typescript
Web({ src: $rawfile('web_immersive.html'), controller: this.controller })
   .width('100%')
   .layoutWeight(1)
      // 设置Web绘制延伸到状态栏和导航条
   .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.TOP, SafeAreaEdge.BOTTOM])
```
2. 设置网页在可视窗口中的布局方式，且让网页元素对导航条进行避让。详情见[web_immersive.html](./casesfeature/immersive/src/main/resources/rawfile/web_immersive.html)。
```html
...
<meta name='viewport' content='viewport-fit=cover, width=device-width, initial-scale=1.0'>
...
<style>
     ...
     footer {
         /* 网页元素对导航条进行避让 */
         padding-bottom: env(safe-area-inset-bottom);
     }
</style>
```

##### 2、通过设置[setWindowLayoutFullScreen()](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/reference/apis-arkui/js-apis-window.md#setwindowlayoutfullscreen9)这个接口实现窗口强制全屏布局，再通过接口getWindowAvoidArea()和on('avoidAreaChange')获取并动态监听安全区域的高度信息，手动进行避让。
###### 窗口全屏布局方案沉浸式适配示例
1. 设置窗口强制全屏布局。详情见[FullScreenImmersive.ets](./casesfeature/immersive/src/main/ets/view/FullScreenImmersive.ets)。
```typescript
window.getLastWindow(getContext(), (err, windowClass) => {
  ...
  // 设置窗口强制全屏布局
  windowClass.setWindowLayoutFullScreen(true);
  ...
})
```
2. 获取状态栏和导航条的高度。详情见[FullScreenImmersive.ets](./casesfeature/immersive/src/main/ets/view/FullScreenImmersive.ets)。
```typescript
window.getLastWindow(getContext(), (err, windowClass) => {
  ...
  // 获取导航条高度
  this.bottomHeight = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR).bottomRect.height;
  // 获取状态栏高度
  this.topHeight = windowClass.getWindowAvoidArea(window.AvoidAreaType.TYPE_SYSTEM).topRect.height;
})
```
3. 对父组件设置padding，手动对安全区域进行避让。详情见[FullScreenImmersive.ets](./casesfeature/immersive/src/main/ets/view/FullScreenImmersive.ets)。
```typescript
Column() {
  ...
}
.height('100%')
.width('100%')
.backgroundColor($r('app.color.immersive_background_color'))
// 设置padding避让状态栏及导航条
.padding({ top: px2vp(this.topHeight), bottom: px2vp(this.bottomHeight) })
```
###### 底部弹框沉浸式适配
底部弹框沉浸式场景只需要处理导航条，需要获取导航条高度，手动对其进行避让。
1. 获取导航条的高度。详情见[ImmersiveDialog.ets](./casesfeature/immersive/src/main/ets/dialog/ImmersiveDialog.ets)。
```typescript
window.getLastWindow(getContext(), (err, data) => {
  const avoidAreaBottom = data.getWindowAvoidArea(window.AvoidAreaType.TYPE_NAVIGATION_INDICATOR);
  this.bottomHeight = avoidAreaBottom.bottomRect.height;
})
```
2. 设置弹框尾部元素对导航条进行避让。详情见[Comment.ets](./casesfeature/immersive/src/main/ets/components/Comment.ets)。
```typescript
...
List({ space: Constants.COMMENT_SPACE, scroller: this.scroller }) {
  // TODO: 高性能知识点: LazyForEach按需加载，提高加载性能。
  LazyForEach(this.data, (item: number, index: number) => {
    ListItem() {
      this.commentItem(index + 1) // index from 1
    }
    // 设置弹框尾部元素对导航条进行避让
    .margin({ bottom: index === this.data.totalCount() - 1 ? px2vp(this.bottomHeight) : 0 })
  }, (item: number) => item.toString())
}
...
```

#### 高性能知识点

**不涉及**

### FAQ
1. 使用[窗口全屏布局方案](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-develop-apply-immersive-effects-V5#section15671730447)进行沉浸式适配时出现窗口跳动。
   答：setWindowLayoutFullScreen接口是将窗口强制全屏化，也即是当应用设置这个接口时会对所有页面生效。因此该方案只适用于全应用进行沉浸式适配，且所有页面都采用此种方案。如果是单页面适配沉浸式，推荐使用[组件安全区方案](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-develop-apply-immersive-effects-V5#section202081847174413)。
2. 滚动场景使用[窗口全屏布局方案](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-develop-apply-immersive-effects-V5#section15671730447)进行沉浸式适配时，尾项不从导航条底部出现。
   答：滚动场景需特殊处理，父组件只需避让状态栏，也即是只需要设置padding-top，然后对list的尾项做一个对导航条的避让，也即是设置尾项的margin-bottom。

### 工程结构&模块类型

```
immersive                                       // har类型
|---common                                   
|---|---Constants.ets                           // 常量
|---components
|---|---Comment.ets                             // 商品评论
|---|---GoodsList.ets                           // 商品列表
|---mock
|---|---GoodsMock.ets                           // 商品列表mock数据
|---model
|---|---CommentDataSource.ets                   // 商品评论数据源
|---|---GoodsModel.ets                          // 商品实体类
|---dialog
|---|---ImmersiveDialog.ets                     // 底部弹框沉浸式适配
|---view                                      
|---|---WebImmersive.ets                        // Web沉浸式适配
|---|---NavImmersive.ets                        // Navigation场景沉浸式适配,也是沉浸式适配场景入口
|---|---FullScreenImmersive.ets                 // 窗口全屏布局方案示例
|---|---GoodsDetails.ets                        // 商品详情页
```

### 参考资料

1. [开发应用沉浸式效果](https://developer.huawei.com/consumer/cn/doc/harmonyos-guides-V5/arkts-develop-apply-immersive-effects-V5)
2. [网页中安全区域计算和避让适配](https://docs.openharmony.cn/pages/v5.0/zh-cn/application-dev/web/web-safe-area-insets.md)
3. [导航条](https://developer.huawei.com/consumer/cn/doc/design-guides/navigation-0000001957075737)

### 相关权限

不涉及

### 依赖

不涉及

### 约束与限制

1. 本示例仅支持标准系统上运行。

2. 本示例已适配API version 12版本SDK。

3. 本示例需要使用DevEco Studio 5.0.0 Release及以上版本才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：
```bash
git init
git config core.sparsecheckout true
echo /code/UI/Immersive/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```