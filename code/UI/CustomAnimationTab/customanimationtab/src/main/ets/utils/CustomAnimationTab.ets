/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { ComponentUtils, curves } from '@kit.ArkUI';
import { CommonConstants } from '../common/CommonConstants';
import { AnimationAttribute } from '../model/AnimationAttribute';
import { BaseInterface } from '../model/BaseInterface';
import { ComponentFactory } from '../model/ComponentFactory';
import { CustomAnimationTabController } from '../model/CustomAniamtionTabController';
import { IndicatorAnimationInfo } from '../model/IndicatorAniamtionInfo';
import { IndicatorBarAttribute } from '../model/IndicatorBarAttribute';
import { logger } from '../utils/Logger';
import { SizeMode } from '../model/SizeMode';
import { TabBarAttribute } from '../model/TabBarAttribute';
import { TabBarItemInterface } from '../model/TabBarItemInterface';
import { TabInfo } from '../model/TabInfo';

/**
 * 功能描述:
 * 1. 选中页签，字体放大加粗且后面有背景条，起到强调作用
 * 2. 手势触摸tab内容滑动，背景条跟随手势一起滑动。抬手时，当tab内容滑动距离不足一半时，会自动回弹，而当tab内容滑动距离大于一半时，
 *    背景条则会移动到下一个页签。当背景条滑动到一定距离后开始滑动页签条，使背景条始终能够保持在可视范围内
 * 3. 点击页签，可以进行页签切换
 * 4. 滑动页签条，背景条也会随之一起滑动，然后滑动tab内容，页签条会滑动到原处，使背景条处于可视范围内，之后背景条开始跟随手势滑动
 * 5. 动画承接，背景条滑动过程中，触摸屏幕，背景条动画停止，松开手势，背景条继续滑动
 *
 * 实现原理：
 * 1. 通过getScrollInfo函数获取每个页签被选中时背景条位置以及页签条偏移信息
 * 2. 在Swiper的onChange回调中判断点击事件，并实现对应的点击页签动画效果
 * 3. 在Swiper的onGestureSwipe回调中实现背景条跟手滑动效果
 * 4. 在Swiper的onContentDidScroll回调中实现背景条自动滑动效果
 *
 * @param {AnimationAttribute} animationAttribute - 动效属性(必需)
 * @param {TabInfo[]} [tabsInfo] - tab信息
 * @param {IndicatorBarAttribute} [indicatorBarAttribute] - 背景条属性
 * @param {TabBarAttribute} [tabBarAttribute] - 页签条属性
 * @param {CustomAnimationTabController} [tabController] - tab控制器
 * @param {Scroller} [scroller] - 页签条控制器
 * @param {number} [animationDuration] - 页签切换时长
 * @param {number} [startIndex] - 起始页签索引
 */
@Component
export struct CustomAnimationTab {
  // -------------------对外暴露变量-----------------------
  // 动效属性
  @Link animationAttribute: AnimationAttribute;
  // tab信息
  tabsInfo: TabInfo[] = [
    new TabInfo(CommonConstants.DEFAULT_TITLE1_TAB, wrapBuilder(baseBuilder), wrapBuilder(tabBar)),
    new TabInfo(CommonConstants.DEFAULT_TITLE2_TAB, wrapBuilder(baseBuilder), wrapBuilder(tabBar)),
    new TabInfo(CommonConstants.DEFAULT_TITLE3_TAB, wrapBuilder(baseBuilder), wrapBuilder(tabBar)),
    new TabInfo(CommonConstants.DEFAULT_TITLE4_TAB, wrapBuilder(baseBuilder), wrapBuilder(tabBar))
  ];
  // 背景条属性
  indicatorBarAttribute: IndicatorBarAttribute = new IndicatorBarAttribute(indicatorBar, SizeMode.Normal,
    CommonConstants.DEFAULT_INDICATOR_WIDTH, CommonConstants.DEFAULT_INDICATOR_HEIGHT);
  // 页签条属性
  tabBarAttribute: TabBarAttribute =
    new TabBarAttribute(CommonConstants.DEFAULT_LIST_ITEM_WIDTH, CommonConstants.DEFAULT_BAR_HEIGHT);
  // tab控制器
  tabController: CustomAnimationTabController = new CustomAnimationTabController();
  // 页签条控制器
  scroller: Scroller = new Scroller();
  // 页签切换时长
  animationDuration: number = CommonConstants.DEFAULT_ANIMATION_DURATION;
  // 起始页签索引
  startIndex: number = 0;
  /**
   * 手势滑动动效
   * @param {number} index - 起始页签索引
   * @param {number} targetIndex - 目标页签索引
   * @param {[number, number][]} elementsInfo - 页签信息[背景条左端位置, 页签条偏移]
   * @param {number} ratio - 当前手势滑动比例
   * @returns
   */
  gestureAnimation: (index: number, targetIndex: number, elementsInfo: IndicatorAnimationInfo[],
    ratio: number) => void =
    (index: number, targetIndex: number, elementsInfo: IndicatorAnimationInfo[], ratio: number): void => {
      this.animationAttribute.left =
        elementsInfo[index].left + (elementsInfo[targetIndex].left - elementsInfo[index].left) * ratio;
      this.scroller!.scrollTo({
        xOffset: elementsInfo[index].offset + (elementsInfo[targetIndex].offset - elementsInfo[index].offset) * ratio,
        yOffset: 0
      });
      let indicatorSize: [number, number] = this.getIndicatorSize(ratio, index, targetIndex);
      this.animationAttribute.indicatorBarWidth = indicatorSize[0];
      this.animationAttribute.indicatorBarHeight = indicatorSize[1];
    };
  /**
   * 自动滑动动效
   * @param {number} index - 起始页签索引
   * @param {number} targetIndex - 目标页签索引
   * @param {[number, number][]} elementsInfo - 页签动效信息[背景条左端位置, 页签条偏移]
   * @param {number} ratio - 当前tab滑动比例
   * @returns
   */
  autoAnimation: (index: number, targetIndex: number, elementsInfo: IndicatorAnimationInfo[], ratio: number) => void =
    (index: number, targetIndex: number, elementsInfo: IndicatorAnimationInfo[], ratio: number): void => {
      this.animationAttribute.left =
        elementsInfo[index].left + (elementsInfo[targetIndex].left - elementsInfo[index].left) * ratio;
      this.scroller!.scrollTo({
        xOffset: elementsInfo[index].offset + (elementsInfo[targetIndex].offset - elementsInfo[index].offset) * ratio,
        yOffset: 0
      });
      let indicatorSize: [number, number] = this.getIndicatorSize(ratio, index, targetIndex);
      this.animationAttribute.indicatorBarWidth = indicatorSize[0];
      this.animationAttribute.indicatorBarHeight = indicatorSize[1];
    };
  /**
   * 点击页签动效
   * @param {number} index - 当前页签索引
   * @param {number} targetIndex - 目标页签索引
   * @param {Record<string, number>} indexInfo - 当前页签信息(center: 页签中心, width: 页签宽度)
   * @param {Record<string, number>} targetIndexInfo - 目标页签信息(center: 页签中心, width: 页签宽度)
   * @param {[number, number][]} elementsInfo - 页签动效信息[背景条左端位置, 页签条偏移]
   * @returns
   */
  clickAnimation: (targetIndex: number, targetIndexInfo: Record<string, number>,
    elementsInfo: IndicatorAnimationInfo[]) => void =
    (targetIndex: number, targetIndexInfo: Record<string, number>, elementsInfo: IndicatorAnimationInfo[]): void => {
      // 根据targetIndex页签当前位置获取对应的背景条位置
      this.animationAttribute.left = targetIndexInfo.center - this.elementsInfo[targetIndex].width / 2;
      this.animationAttribute.indicatorBarWidth = this.elementsInfo[targetIndex].width;
      this.animationAttribute.indicatorBarHeight = this.elementsInfo[targetIndex].height;
      this.scroller!.scrollTo({
        xOffset: elementsInfo[targetIndex].offset,
        yOffset: 0,
        animation: { duration: this.animationDuration, curve: Curve.Linear }
      });
    };
  /**
   * 获取页签对应的背景条位置以及页签条偏移
   * @param {number} center - 页签中心点
   * @param {number} width - 背景条宽度
   * @returns {[number, number]} 背景条位置以及页签条偏移[背景条左端位置, 页签条偏移]
   */
  getScrollInfo: (center: number, width: number) => [number, number] =
    (center: number, width: number): [number, number] => {
      // 获取背景条位置
      let indicatorLeft: number = center - width / 2;
      // TODO: 知识点: 当背景条位置大于默认的背景条最大位置时，选取背景条最大位置作为背景条实际位置
      let finalIndicatorLeft: number =
        this.maxIndicatorBarLeft >= 0 ? Math.min(indicatorLeft, this.maxIndicatorBarLeft) : indicatorLeft;
      // TODO: 知识点: 背景条产生的多余距离作为页签条滑动距离
      let listOffset: number = indicatorLeft - finalIndicatorLeft;
      // TODO: 知识点: 当页签条偏移大于页签条可偏移量，选取页签条可偏移量作为页签条实际偏移
      let finalListOffset: number = Math.min(listOffset, Math.max(this.maxListOffset, 0));
      // TODO: 知识点: 页签条多余的偏移作为背景条后续的滑动距离
      finalIndicatorLeft += listOffset - finalListOffset;
      return [finalIndicatorLeft, finalListOffset];
    };
  // --------------------私有属性----------------------------
  @State curIndex: number = 0;
  @State barTitles: string[] = [];
  @State barHeight: Length | undefined = undefined; // 页签条高度
  private componentUtils: ComponentUtils = this.getUIContext().getComponentUtils();
  private tabsWidth: number = 0;
  private listTouchState: number = 0; // 1：changIndex切换事件, 0：tab滑动切换事件
  private maxListOffset: number = 0; // 页签条最大可偏移长度
  private isReachBorder: boolean = true; // 判断tab是否到达边界
  private elementsInfo: IndicatorAnimationInfo[] = []; // 页签对应的背景条位置、页签条偏移、背景条高度以及背景条宽度
  private isAnimationStart: boolean = false;
  @BuilderParam private indicatorBar: (index: BaseInterface) => void; // 自定义背景条
  private maxIndicatorBarLeft: number = 0; // 背景条最大偏移(<0: 无上限, >=0: maxIndicatorBarLeft)
  private indicatorBarAlign: VerticalAlign = VerticalAlign.Top; // 背景条垂直布局
  private barEdgeEffect: EdgeEffect = EdgeEffect.Spring; // 页签条边缘滑动效果(目前仅支持EdgeEffect.Spring和EdgeEffect.None)
  private scrollable: boolean = true; // 是否可以滚动页签条(等分所有页签宽度，barItemWidth失效)
  private factory: ComponentFactory = new ComponentFactory();
  private indicatorExpand: number = CommonConstants.DEFAULT_INDICATOR_EXPAND;
  private sizeMode: SizeMode = SizeMode.Normal;
  private vertical: boolean = false;
  private barTitleSize: [number, number][] = [];
  private isInit: boolean = false;
  private barItemWidth: Length | undefined = undefined; // 页签宽度
  private leftMargin: number = 0;
  private indicatorHeight: number = 0;
  private indicatorWidth: number = 0;

  aboutToAppear(): void {
    // 检查参数是否合法及初始化
    this.checkNotLegal();

    // 加载页面基本数据
    logger.info(`${this.tabsInfo.length}`);
    this.tabsInfo!.forEach(info => {
      this.factory.set(info.title, info);
    });

    // 私有变量初始化
    this.curIndex = this.startIndex;
    this.tabsWidth = 0;
    this.listTouchState = 0;
    this.isReachBorder = true;
    this.elementsInfo = []
    this.isAnimationStart = false;
    this.barTitles = this.factory.toArray();
    logger.info(`${this.barTitles.length}`);
    this.maxListOffset = 0;
    this.indicatorBar = this.indicatorBarAttribute!.indicatorBar;
    this.maxIndicatorBarLeft = this.indicatorBarAttribute!.maxIndicatorBarLeft;
    this.indicatorBarAlign = this.indicatorBarAttribute!.barAlign;
    this.barHeight = this.tabBarAttribute!.barHeight;
    this.scrollable = this.tabBarAttribute!.scrollable;
    this.barEdgeEffect = this.tabBarAttribute!.barEdgeEffect;
    this.indicatorExpand = this.indicatorBarAttribute.indicatorExpand;
    this.sizeMode = this.indicatorBarAttribute.sizeMode;
    this.barItemWidth = this.tabBarAttribute.barItemWidth;
    this.isInit = false;
    this.indicatorHeight = this.indicatorBarAttribute.indicatorHeight;
    this.indicatorWidth = this.indicatorBarAttribute.indicatorWidth;
    if (!this.scrollable) {
      this.barItemWidth = (100 / this.barTitles.length).toString() + '%';
    }
    for (let i = 0; i < this.barTitles.length; i++) {
      this.elementsInfo[i] = {
        left: 0,
        offset: 0,
        width: 0,
        height: 0,
        flag: false
      }
    }
    this.tabController.setListener((state: number) => {
      this.listTouchState = state;
    })
  }

  /**
   * 检查输入参数合法性
   */
  private checkNotLegal(): void {
    if (this.tabsInfo === undefined || this.tabsInfo.length <= 0) {
      this.tabsInfo = [
        new TabInfo(CommonConstants.DEFAULT_TITLE1_TAB, wrapBuilder(baseBuilder), wrapBuilder(tabBar)),
        new TabInfo(CommonConstants.DEFAULT_TITLE2_TAB, wrapBuilder(baseBuilder), wrapBuilder(tabBar)),
        new TabInfo(CommonConstants.DEFAULT_TITLE3_TAB, wrapBuilder(baseBuilder), wrapBuilder(tabBar)),
        new TabInfo(CommonConstants.DEFAULT_TITLE4_TAB, wrapBuilder(baseBuilder), wrapBuilder(tabBar))
      ];
    }
    if (this.indicatorBarAttribute === undefined) {
      this.indicatorBarAttribute = new IndicatorBarAttribute(indicatorBar, SizeMode.Normal,
        CommonConstants.DEFAULT_INDICATOR_WIDTH, CommonConstants.DEFAULT_INDICATOR_HEIGHT);
    }
    if (this.tabBarAttribute === undefined) {
      this.tabBarAttribute =
        new TabBarAttribute(CommonConstants.DEFAULT_LIST_ITEM_WIDTH, CommonConstants.DEFAULT_BAR_HEIGHT);
    }
    if (this.tabController === undefined) {
      this.tabController = new CustomAnimationTabController();
    }
    if (this.scroller! === undefined) {
      this.scroller = new Scroller();
    }
    if (this.animationDuration <= 0) {
      console.error(`IllegalArgumentException(animationDuration: ${this.animationDuration}): animationDuration cannot be less than 0.`);
    }
    if (this.startIndex < 0 || this.startIndex >= this.tabsInfo.length) {
      console.error(`IllegalArgumentException(startIndex: ${this.startIndex}): animationDuration must take a value between [0, ${this.factory.toArray()
        .length}].`);
    }
  }

  build() {
    RelativeContainer() {
      // tab
      Swiper(this.tabController) {
        ForEach(this.barTitles, (item: string, index: number) => {
          this.factory.getContent(item)?.builder(this.factory.getParams(item));
          // TODO: 知识点: InnerBarItem为自定义组件，使用默认的键值生成规则可能会导致JSON.stringify()无法字符串化自定义类
          // TODO(接上): 知识点: 1.可以自定义键值生成规则；2.在自定义类中引入toString或者toJSON自定义字符串化形式。
        }, (item: string, index: number) => index.toString())
      }
      .id('tabContent')
      .loop(false)
      .vertical(this.vertical)
      .index(this.startIndex)
      .duration(this.animationDuration)
      // TODO: 知识点: 动画曲线配置需要谨慎使用，因为这会影响onContentDidScroll函数调用情况，导致最终position无法接近100%
      // TODO: 知识点: 某些插值类型不受duration的控制，因此会导致duration无效
      .curve(Curve.Ease)
      .indicator(false)
      .width(CommonConstants.FULL_PERCENT)
      .alignRules(
        {
          bottom: this.tabBarAttribute!.barVertical === BarPosition.Start ?
            { anchor: '__container__', align: VerticalAlign.Bottom } :
            { anchor: 'tabItems', align: VerticalAlign.Top },
          top: this.tabBarAttribute!.barVertical === BarPosition.Start ?
            { anchor: 'tabItems', align: VerticalAlign.Bottom } :
            { anchor: '__container__', align: VerticalAlign.Top }
        }
      )
      .onChange((index: number) => {
        if (this.listTouchState === 1 && index !== this.curIndex) {
          let targetIndexInfo: Record<string, number> = this.getElementInfo(index);
          this.clickAnimation(index, targetIndexInfo, this.elementsInfo);
        }
        this.curIndex = index;
      })
      .onContentDidScroll((selectedIndex: number, index: number, position: number, mainAxisLength: number) => {
        // 动画启动，选取当前index索引页签的属性来执行背景条和页签条滑动
        if (this.isAnimationStart && index === this.curIndex) {
          // 使用选中页签相对于Swiper主轴起始位置的移动比例判断滑动的目标页签targetIndex的位置
          let targetIndex: number = position < 0 ? index + 1 : index - 1;
          if (targetIndex >= this.barTitles.length || targetIndex < 0) {
            console.warn(`Warning: targetIndex exceeds the limit range:
            selectedIndex: ${selectedIndex}, curIndex: ${this.curIndex}, index: ${index},
            targetIndex: ${targetIndex}, position: ${position}, mainAxisLength: ${mainAxisLength}`);
            targetIndex = index; // 保证背景条在index页签位置
          }
          let ratio: number = Math.abs(position);
          // 通过页签比例计算当前页签条和背景条的位置
          this.autoAnimation(index, targetIndex, this.elementsInfo, ratio);
        }
      })
      .onAnimationStart((index: number, targetIndex: number, event: TabsAnimationEvent) => {
        if (this.isReachBorder) { // 若tab到达边界，则不继续执行动画
          return;
        }

        this.isAnimationStart = true;
        this.listTouchState = 0;
      })
      .onAnimationEnd(() => {
        this.isAnimationStart = false;
      })
      .onGestureSwipe((index: number, event: TabsAnimationEvent) => {
        this.listTouchState = 0;
        let curOffset: number = event.currentOffset;
        let targetIndex: number = index;
        this.isReachBorder = false;
        // tab组件到达边界使背景条和页签条跳转到终点位置
        // TODO: 知识点: 这里不能判断到边界直接退出，因为onGestureSwipe每一帧触发回调，当手势滑动较快，上一帧背景条没有到达边界
        // TODO(接上): 知识点: 下一帧content超出边界，这时候背景条没有更新，退出将导致背景条停滞在上一帧位置无法更新。
        if ((index === 0 && curOffset > 0) ||
          (index === this.barTitles.length - 1 && curOffset < 0)) {
          this.isReachBorder = true;
          curOffset = 0;
        }

        let ratio: number = Math.abs(curOffset / this.tabsWidth); // tab滑动比例
        if (curOffset < 0) { // tab右滑
          targetIndex = index + 1;
        } else if (curOffset > 0) { // tab左滑
          targetIndex = index - 1;
        }
        // 获取背景条位置及页签条偏移
        this.gestureAnimation(index, targetIndex, this.elementsInfo, ratio);
      })
      .onAreaChange((oldValue: Area, newValue: Area) => {
        let width: number = Number.parseFloat(newValue.width.toString());
        this.tabsWidth = Number.isNaN(width) ? 0 : width;
      })

      Stack({ alignContent: Alignment.Start }) {
        // 背景条
        Row() {
          Column() {
            this.indicatorBar({ 'curIndex': this.curIndex });
          }
          .id('backgroundBar')
          .height(this.animationAttribute.indicatorBarHeight)
          .width(this.animationAttribute.indicatorBarWidth)
          .margin({ left: this.animationAttribute.left })
        }
        .alignItems(this.indicatorBarAlign)
        // TODO: 知识点: 通过clip保证超出容器的部分被截断
        .clip(true)
        .height(CommonConstants.FULL_PERCENT)
        .width(CommonConstants.FULL_PERCENT)

        // 页签条
        // TODO: 知识点: 通过scroll将list内部所有item加载出来, 否则只能获取部分页签项的背景条位置和页签条偏移
        Scroll(this.scroller!) {
          List() {
            ForEach(this.barTitles, (item: string, index: number) => {
              ListItem() {
                Column() {
                  if (this.factory.getBar(item) !== undefined) {
                    this.factory.getBar(item)?.builder({ curIndex: this.curIndex, index: index, title: item });
                  } else {
                    tabBar({ curIndex: this.curIndex, index: index, title: item });
                  }
                }
                .padding(this.sizeMode === SizeMode.Padding ?
                  {
                    left: this.indicatorWidth,
                    right: this.indicatorWidth,
                    top: this.indicatorHeight,
                    bottom: this.indicatorHeight
                  }
                  : 0)
                // TODO: 知识点: 通过column与padding组合获取内边距模式下背景条的尺寸
                .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions): void => {
                  if (this.barTitleSize[index] === undefined && newValue.width !== undefined &&
                    newValue.height !== undefined) {
                    let width: number = Number.parseFloat(newValue.width.toString());
                    let height: number = Number.parseFloat(newValue.height.toString());
                    this.barTitleSize[index] = [width, height];
                    if (this.barHeight === undefined) {
                      this.barHeight = height;
                    }
                  }
                })
              }
              .id(index.toString())
              .height(CommonConstants.FULL_PERCENT)
              .width(this.barItemWidth)
              .onClick(() => {
                this.tabController!.changeIndex(index);
              })
              // TODO: 知识点: 利用onSizeChange在onAreaChange前调用的性质，初始化变量
              .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
                // TODO: 知识点: 通过list内部组件宽度总和-list宽度获取list最大可偏移量
                if (newValue.width !== undefined && newValue.height !== undefined && !this.isInit) {
                  let width: number = Number.parseFloat(newValue.width.toString());
                  let height: number = Number.parseFloat(newValue.height.toString());
                  if (this.sizeMode === SizeMode.Normal) {
                    this.indicatorWidth = this.indicatorWidth === 0 ? width : this.indicatorWidth;
                    this.indicatorHeight = this.indicatorHeight === 0 ? height : this.indicatorHeight;
                  }
                  this.maxListOffset += width;
                  console.log(`maxListOffset: ${this.maxListOffset}`);
                }
              })
              .onAreaChange((oldValue: Area, newValue: Area) => {
                console.log(`onAreaChange item`);
                if (newValue.position.x !== undefined && !this.elementsInfo[index].flag) {
                  let width: number = Number.parseFloat(newValue.width.toString());
                  let positionX: number = Number.parseFloat(newValue.position.x.toString());
                  // 内边距模式下背景条的尺寸
                  if (this.sizeMode === SizeMode.Padding) {
                    this.indicatorHeight = this.barTitleSize[index][1];
                  }
                  if (this.sizeMode === SizeMode.Padding) {
                    this.indicatorWidth = this.barTitleSize[index][0];
                  }
                  // 计算每一个页签对应的背景条位置与页签条偏移
                  // TODO: 知识点: 当页签宽度之和小于List大小时，需要加上差值的一半
                  let scrollInfo: [number, number] =
                    this.getScrollInfo(positionX + width / 2 - Math.min(0, this.maxListOffset) / 2,
                      this.indicatorWidth);
                  scrollInfo[0] += this.elementsInfo[index].left;
                  this.elementsInfo[index] = {
                    left: scrollInfo[0],
                    offset: scrollInfo[1],
                    height: this.indicatorHeight,
                    width: this.indicatorWidth,
                    flag: true
                  };
                  if (this.curIndex === index) {
                    this.animationAttribute.left = this.elementsInfo[index].left;
                    this.scroller!.scrollTo({ xOffset: this.elementsInfo[index].offset, yOffset: 0 });
                    this.animationAttribute.indicatorBarWidth = this.indicatorWidth;
                    this.animationAttribute.indicatorBarHeight = this.indicatorHeight;
                  }
                  this.isInit = true;
                }
              })
            }, (item: string, index: number) => index.toString())
          }
          .alignListItem(ListItemAlign.Center)
          .listDirection(Axis.Horizontal)
          .scrollBar(BarState.Off)
          .height(CommonConstants.FULL_PERCENT)
        }
        .margin(this.tabBarAttribute.barMargin)
        .edgeEffect(this.barEdgeEffect)
        .scrollable(ScrollDirection.Horizontal)
        .scrollBar(BarState.Off)
        .height(CommonConstants.FULL_PERCENT)
        .width(CommonConstants.FULL_PERCENT)
        .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
          if (newValue.width !== undefined && !this.isInit) {
            let width: number = Number.parseFloat(newValue.width.toString());
            this.maxListOffset -= width;
            console.log(`maxListOffset: ${this.maxListOffset}`);
          }
        })
        .onAreaChange((oldValue: Area, newValue: Area) => {
          this.leftMargin = newValue.position.x === undefined ? 0 : Number.parseFloat(newValue.position.x.toString());
          for (let i = 0; i < this.barTitles.length; i++) {
            this.elementsInfo[i].left += this.leftMargin;
          }
        })
        .onTouch((event: TouchEvent) => {
          if (event.type === TouchType.Move) {
            this.listTouchState = 1;
          }
        })
        .onDidScroll((scrollOffset: number, scrollState: ScrollState) => {
          // changIndex事件切换, 背景条跟随页签条一起滑动
          // TODO: 知识点: 使用scrollTo实现页签条动画，并通过状态变量赋值来执行背景条动画，可以使两者动画同时进行
          // TODO（接上）: 知识点: 具体可见line.111上添加动画this.startAnimateTo(index, this.animationDuration,
          // TODO（接上）: 知识点: this.elementsInfo[index][0], CommonConstants.DEFAULT_INDICATOR_WIDTH)对比效果
          if (this.listTouchState === 1) {
            this.animationAttribute.left -= scrollOffset;
          }
        })
      }
      .id('tabItems')
      .height(this.barHeight)
      .backgroundColor(this.tabBarAttribute.barBackgroundColor)
      // TODO: 知识点: 通过赋值null使得对应的对其方式失效
      .alignRules({
        top: this.tabBarAttribute!.barVertical === BarPosition.Start ?
          { anchor: '__container__', align: VerticalAlign.Top } :
          undefined,
        bottom: this.tabBarAttribute!.barVertical === BarPosition.Start ?
          undefined :
          { anchor: '__container__', align: VerticalAlign.Bottom },
        right: { anchor: '__container__', align: HorizontalAlign.End },
        left: { anchor: '__container__', align: HorizontalAlign.Start }
      })
    }
    .width(CommonConstants.FULL_PERCENT)
    .height(CommonConstants.FULL_PERCENT)
    .onSizeChange((oldValue: SizeOptions, newValue: SizeOptions) => {
      // 保证背景条最大偏移不会超出屏幕
      let width = newValue.width === undefined ? 0 : Number.parseFloat(newValue.width.toString());
      this.maxIndicatorBarLeft = this.maxIndicatorBarLeft > width ? (width / 2) : this.maxIndicatorBarLeft;
    })
  }

  /**
   * 获取id为index组件的中心点信息
   * @param {number} index - 组件id
   * @returns {Record<string, number>} index页签当前的中心位置以及其宽度
   */
  private getElementInfo(index: number): Record<string, number> {
    let rectangle = this.componentUtils.getRectangleById(index.toString());
    let width: number = rectangle.size.width;
    let center: number = rectangle.localOffset.x + width / 2;
    // TODO: 知识点: 由于页签条使用offset进行偏移，因此localOffset.x等于页签在页签条中的位置，为了得到相对于tab容器的位置，需要减去一个页签条的偏移
    // TODO: 知识点: 当页签宽度之和小于List大小时，需要加上差值的一半
    return {
      'center': px2vp(center) - Math.min(0, this.maxListOffset) / 2 - this.scroller!.currentOffset().xOffset +
      this.leftMargin,
      'width': width
    };
  }

  /**
   * 获取背景条宽度
   * @param {number} ratio - tab偏移比例
   * @param {number} fromIndex - 起始索引
   * @param {number> toIndex - 终止索引
   * @returns {[number, number]} [背景条宽度, 背景条高度]
   */
  private getIndicatorSize(ratio: number, fromIndex: number, toIndex: number): [number, number] {
    ratio = Math.abs(ratio);
    let width: number = 0;
    let height: number = 0;
    // 获取背景条扩展阶段的起始宽度和终止宽度
    let fromWidth: number = this.elementsInfo[fromIndex].width;
    let toWidth: number =
      (this.elementsInfo[fromIndex].width + this.elementsInfo[toIndex].width) * this.indicatorExpand / 2;
    let fromHeight: number = this.elementsInfo[fromIndex].height;
    let toHeight: number = this.elementsInfo[toIndex].height;
    let stageRatio: number = ratio * 2;
    // 获取背景条缩短阶段的起始宽度和终止宽度
    if (ratio >= 0.5) {
      fromWidth = toWidth;
      toWidth = this.elementsInfo[toIndex].width;
      stageRatio = (ratio - 0.5) * 2;
    }
    // 获取当前ratio，背景条的实际宽度
    width = (toWidth - fromWidth) * stageRatio + fromWidth;
    height = (toHeight - fromHeight) * ratio + fromHeight;
    return [width, height];
  }
}

/**
 * 默认tabContent样式
 */
@Builder
function baseBuilder(params: ESObject) {
  Column() {
    Text('Text')
      .fontSize(CommonConstants.DEFAULT_TAB_CONTENT_FONT_SIZE)
  }
  .justifyContent(FlexAlign.Center)
  .height(CommonConstants.FULL_PERCENT)
  .width(CommonConstants.FULL_PERCENT)
}

/**
 * 默认tabBar样式
 * @param {TabBarItemInterface} $$ - 返回的页签信息
 */
@Builder
function tabBar($$: TabBarItemInterface) {
  Text($$.title)
    .fontSize($$.curIndex === $$.index ? CommonConstants.DEFAULT_TAB_BAR_SELECT_FONT_SIZE :
    CommonConstants.DEFAULT_TAB_BAR_UNSELECT_FONT_SIZE)
    .fontColor(CommonConstants.DEFAULT_TAB_BAR_FONT_COLOR)
    .fontWeight($$.curIndex === $$.index ? FontWeight.Bold : FontWeight.Medium)
    .textAlign(TextAlign.Center)
}

/**
 * 默认背景条样式
 * @param {BaseInterface} $$ - 返回的基本信息
 */
@Builder
function indicatorBar($$: BaseInterface) {
  Column()
    .height(CommonConstants.FULL_PERCENT)
    .width(CommonConstants.FULL_PERCENT)
    .backgroundColor(Color.Red)
    .borderRadius(CommonConstants.DEFAULT_INDICATOR_BORDER_RADIUS)
}