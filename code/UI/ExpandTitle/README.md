# 标题下拉缩放案例

### 介绍

本文以备忘录应用为示例，介绍如何在实现标题跟随手势移动并放缩的动效。

### 效果图预览

![](./entry/src/main/resources/base/media/expand_title.gif)

**使用说明**：

1. 进入页面，起初标题并没有展开，与增加/分享的菜单在同一行。
2. 进行第一次下拉操作，此时标题跟随手势慢慢放大，并渐渐显示笔记数目信息。
3. 继续下拉，标题与菜单都下拉一段距离，并放大，达到阈值距离后标题大小不再发生变化；松手后回弹至第一次下拉后的状态。
4. 向上滑动，标题随手势折叠，回到初始时的状态。

### 实现思路

1. 标题高度变化，通过状态变量heightValue控制，通过onScrollFrameBegin获取list偏移，并将其分配给标题高度变化和实际list偏移。源码参考[TitleExpansion.ets](./entry/src/main/ets/utils/TitleExpansion.ets)。

   ```ts
   List({ space: Constants.SEARCH_MEMO_SPACE, scroller: this.scroller }) {
     ListItem() {
       // 内容
       this.content();
     }
   }
   .onScrollFrameBegin((offset: number, state: ScrollState) => {
     let listOffset: number = 0;
     console.log(`offset: ${offset}`)
     // 保证list没有在顶部时以list滑动为主
     if (offset < 0) {
       listOffset = Math.max(offset, -this.scroller.currentOffset().yOffset);
       offset -= listOffset;
     }
     // 标题高度变化
     let titleHeightChange = this.getTitleHeightChangeOptions(-offset);
     this.heightValue += titleHeightChange;
     // list滑动距离
     offset += titleHeightChange;
     offset += listOffset;
     return {offsetRemain: offset};
   })
   ```

2. 标题展开继续下拉偏移，通过状态变量curOffset控制，通过onDidScroll获取标题展开后，标题继续下拉的偏移。 源码参考[TitleExpansion.ets](./entry/src/main/ets/utils/TitleExpansion.ets)。

   ```ts
   List({ space: Constants.SEARCH_MEMO_SPACE, scroller: this.scroller }) {
     ListItem() {
       // 内容
       this.content();
     }
   }
   // 获取标题展开后，标题继续下拉偏移
   .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
     this.curOffset = this.scroller.currentOffset().yOffset;
   })
   ```
   
3. 滚动停止动画，通过onScrollStop获取滚动停止时的标题高度。当标题高度大于阈值时，产生展开标题动画；相反，则产生收缩标题动画。源码参考[TitleExpansion.est](./entry/src/main/ets/utils/TitleExpansion.ets)

```typescript
List({ space: Constants.SEARCH_MEMO_SPACE, scroller: this.scroller }) {
  ListItem() {
    // 内容
    this.content();
  }
}
// TODO: 知识点: 在滚动停止时判断是否需要展开或者收缩标题
.onScrollStop(() => {
  if (this.heightValue >= this.thresholdValue) {
    this.animateToThrottle(() => {
      this.heightValue = Constants.EXPAND_TITLE_HEIGHT;
    }, this.delay)
  } else {
    this.animateToThrottle(() => {
      this.heightValue = Constants.NORMAL_TITLE_HEIGHT;
    }, this.delay)
  }
})
```

4. 响应状态变量，标题和菜单的tranlate和scale参数以及笔记数量的opacity参数在下拉过程中会更新。源码参考[TitleExpansion.ets](./entry/src/main/ets/utils/TitleExpansion.ets)。

  ```ts
  /**
   * 获取标题展开时，继续下拉的菜单栏Translate参数
   * @returns {TranslateOptions} 标题展开后继续下拉的菜单栏Translate参数
   */
  getMenuTranslateOptions(): TranslateOptions {
    return { y: Math.max(-this.curOffset, 0) };
  }

  /**
   * 获取标题展开时，继续下拉的标题栏Translate参数
   * @returns {TranslateOptions} 标题展开后继续下拉的标题栏Translate参数
   */
  getTitleTranslateOptions(): TranslateOptions {
    return {y: Math.max(-this.curOffset, 0)};
  }

  /**
   * 获取标题栏高度变化参数
   * @param offset: 当前产生的偏移
   * @returns {number} 标题栏高度变化值
   */
  getTitleHeightChangeOptions(offset: number): number {
    return Math.max(Math.min(offset, this.animationAttribute.expandTitleHeight - this.heightValue), this.animationAttribute.normalTitleHeight - this.heightValue);
  }

  /**
   * 获取主标题缩放的Scale参数
   * @returns {ScaleOptions} 主标题缩放系数
   */
  getTitleScaleOptions(): ScaleOptions {
    let scaleRatio = 1 + (this.animationAttribute.titleScale - 1) *
      Math.min((this.heightValue - this.animationAttribute.normalTitleHeight + Math.max(-this.curOffset, 0)) / this.animationAttribute.continuePullThreshold, 1);
    return {
      x: scaleRatio,
      y: scaleRatio,
      centerX: Constants.INIT_COORDINATE,
      centerY: Constants.INIT_COORDINATE
    };
  }

  /**
   * 获取子标题显隐参数
   * @returns {number} 子标题显隐系数
   */
  getTitleOpacityOptions(): number {
    return (this.heightValue - this.animationAttribute.normalTitleHeight) /
      (this.animationAttribute.expandTitleHeight - this.animationAttribute.normalTitleHeight)
  }
  ```

### 高性能知识点

本示例使用了[LazyForEach](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.0-Release/zh-cn/application-dev/quick-start/arkts-rendering-control-lazyforeach.md)进行数据懒加载以及[显式动画animateTo](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.0-Release/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-explicit-animation.md)实现文本偏移。

### 工程结构&模块类型

```
expandtitle                                     // har类型
|---constants
|   |---Constants.ets                           // 常量池
|---model
|   |---AnimationAttribute.ets                  // 动效属性
|   |---TitleAttribute.ets                      // 标题属性
|---pages
|   |---Configure.ets                           // 样例配置文件
|   |---DataSource.ets                          // 懒加载数据源
|   |---MemoInfo.ets                            // 数据类型
|   |---MemoItem.ets                            // 笔记视图
|   |---MockData.ets                            // 模拟数据
|   |---TitleContent.ets                        // 内容界面
|   |---Index.ets                               // 标题扩展组件UI样例
|   |---TitleMenu.ets                           // 菜单栏
|---utils
|   |---TitleExpansion.ets                      // 标题扩展组件
```

### 参考资料

[显式动画animateTo](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.0-Release/zh-cn/application-dev/reference/apis-arkui/arkui-ts/ts-explicit-animation.md)

[数据懒加载LazyForEach](https://gitee.com/openharmony/docs/blob/OpenHarmony-5.0.0-Release/zh-cn/application-dev/quick-start/arkts-rendering-control-lazyforeach.md)

### 约束与限制

1.本示例仅支持在标准系统上运行。

2.本示例需要使用DevEco Studio 5.0.0 Release 才可编译运行。

### 下载

如需单独下载本工程，执行如下命令：
```javascript
git init
git config core.sparsecheckout true
echo /code/UI/ExpandTitle/ > .git/info/sparse-checkout
git remote add origin https://gitee.com/openharmony/applications_app_samples.git
git pull origin master
```