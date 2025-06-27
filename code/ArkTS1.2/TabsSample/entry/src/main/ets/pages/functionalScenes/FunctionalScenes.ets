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

import  promptAction  from '@ohos.promptAction';
import { Text, List, ListItem, Column, Button, Image, Row, Stack,ListItemGroup, Divider, Blank,
  Tabs, TabContent, Flex, FlexOptions, Callback, px2vp, ItemAlign, BackgroundBrightnessOptions,
  ButtonAttribute, ClickEvent, Component, BuilderParam, Padding, $r, SafeAreaEdge, BackgroundBlurStyleOptions,
  BarState, NestedScrollOptions, NestedScrollMode, Color, JSON, Alignment, FlexDirection, BarPosition,
  FlexAlign, BlurStyle, LazyForEach, ForEach, Builder, Margin, SafeAreaType, MenuItemOptions,
  TabsController, TabsOptions ,StackOptions, ThemeColorMode, AdaptiveColor, ResourceStr, SizeOptions,
  Reusable, TextOverflowOptions, ListOptions, LinearGradientOptions, Menu, MenuItem, Axis, BorderRadiuses,
  WaterFlow, FlowItem, ImageFit, TextAlign, Scroll, ScrollAlign, Scroller, TextOverflow, ShadowStyle, TabsAnimationEvent,
  OnTabsAnimationStartCallback, Rating, RatingOptions, GestureGroup, GestureEvent, GestureMode, TapGesture, $$,
  SheetSize, SheetType, ScrollSizeMode, SheetOptions, CustomBuilder, Entry
} from '@ohos.arkui.component'
import { State, StateDecoratedVariable, MutableState, stateOf, AppStorage,
  observableProxy,ObjectLink, Observed, Consume, Link, Provide, Watch} from '@ohos.arkui.stateManagement'
import display from '@ohos.display';
import { SceneModuleInfo } from '../../model/functionalScenes/SceneModuleInfo';
import { WaterFlowDataSource } from '../../model/functionalScenes/WaterFlowDataSource';
import { TAB_DATA, TabDataModel } from '../../model/functionalScenes/TabsData';
import { SCENE_MODULE_LIST } from '../../model/functionalScenes/SceneModuleDatas'
import { CollapseMenuSection } from '../collapsemenu/CollapseMenuSection';
import { UIContext } from '@ohos.arkui.UIContext'

/**
 * 主页瀑布流列表
 */
@Entry
@Component
export struct FunctionalScenes {
  listData: SceneModuleInfo[] = SCENE_MODULE_LIST;
  dataSource: WaterFlowDataSource<SceneModuleInfo> = new WaterFlowDataSource<SceneModuleInfo>(this.listData);
  @State tabsIndex: number = 0;
  tabsController: TabsController = new TabsController();
  private scrollController: Scroller = new Scroller();
  items:number[] = [1,2,3,4,5,6,7,8,9,10] as number[];
  @Builder
  tabBuilder(index: number, name: string | undefined) {
    Stack() {
      Column() {
      }
      .width(this.tabsIndex === index ? 97 : 71)
      .backgroundColor(this.tabsIndex === index ? '#0A59F7' : '#000000')
      .opacity(this.tabsIndex === index ? 1 : 0.05)
      .height(38)
      .borderRadius(21)
      Text(name)
        .fontSize(14)
        .fontColor(this.tabsIndex === index ? Color.White : Color.Black)
        .opacity(this.tabsIndex === index ? 1 : 0.8)
        .height('100%')
        .id('section')
    }
    .margin(index !== 0 && index !== TAB_DATA.length ? { left: 9 } as Margin : {
      left: 0,
      right: 0
    } as Margin)
    .align(Alignment.Center)
    .onClick((e: ClickEvent) => {
      this.tabsIndex = index;
      this.tabsController.changeIndex(index);
    })
  }

  @Builder
  tabsMenu() {
    Menu() {
      ForEach(TAB_DATA, (item: TabDataModel) => {
        MenuItem({ content: item.navData } as MenuItemOptions)
          .onClick((e: ClickEvent) => {
            this.tabsIndex = item.id;
            this.tabsController.changeIndex(item.id);
          })
          .id('menu_item')
      })
    }
  }

  /**
   * 主页通过瀑布流和LazyForeach加载
   * WaterFlow+LazyForEach详细用法可参考性能范例：
   * waterflow_optimization.md/
   */
  build() {
    Column() {
      Row() {
        Text($r('app.string.custom_return'))
      }
      .margin(3)
      .width('100%')
      .onClick((e: ClickEvent) => {
        this.getUIContext().getRouter().back();
      })
      Row() {
        Stack() {
          List({ scroller: this.scrollController } as ListOptions) {
            ForEach(TAB_DATA, (tabItem: TabDataModel) => {
              ListItem() {
                this.tabBuilder(tabItem.id, tabItem.navData);
              }
            })
          }
          .id('MainList')
          .margin({ top: 3 } as Margin)
          .height(38)
          .listDirection(Axis.Horizontal)
          .padding({ right: 46 } as Padding)
          .scrollBar(BarState.Off)
          Row() {
            Row() {
              Image($r('app.media.ic_public_more'))
                .width(20)
                .id('mainPageTabsImage')
            }
            .bindMenu(this.tabsMenu)
            .justifyContent(FlexAlign.Center)
            .width(43)
            .height(43)
            .borderRadius(100)
            .backgroundColor('rgba(216, 216, 216, 0)')
            .id('menu_button')
          }
          .linearGradient({
            angle: 90,
            colors: [['rgba(241, 241, 241, 0)', 0], ['#F1F3F5', 0.2], ['#F1F3F5', 1]]
          } as LinearGradientOptions)
          .justifyContent(FlexAlign.End)
          .width(60)
          .height(43)
        }
        .alignContent(Alignment.TopEnd)
      }
      .padding({
        left: 13,
        right: 13
      } as Padding)
      .margin({ top: 8 } as Margin)
      Tabs({ controller: this.tabsController } as TabsOptions) {
        ForEach(TAB_DATA, (tabItem: TabDataModel) => {
          TabContent() {
            if (tabItem.navData === '全部') {
              List() {
                LazyForEach(this.dataSource, (waterFlowItem: SceneModuleInfo) => {
                  ListItem(){
                    methodPoints({ listData: waterFlowItem })
                  }
                }, (waterFlowItem: SceneModuleInfo) => JSON.stringify(waterFlowItem))
              }
              .nestedScroll({
                scrollForward: NestedScrollMode.PARENT_FIRST,
                scrollBackward: NestedScrollMode.SELF_FIRST
              } as NestedScrollOptions)
              .width('100%')
              .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
              .padding({ bottom: $r('app.integer.functional_scenes_water_flow_padding_bottom') } as Padding)
            } else {
              Column() {
                Text(tabItem.navData).fontSize(20)
              }
              .height('100%')
              .width('100%')
              .justifyContent(FlexAlign.Center)
              .align(Alignment.Center)
            }
          }
          .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
          .align(Alignment.TopStart)
          .alignSelf(ItemAlign.Start)
        })
      }
      .margin({ top: 8 } as Margin)
      .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
      .padding({
        left: 13,
        right: 13
      } as Padding)
      .barWidth(0)
      .barHeight(0)
      .onAnimationStart((index: number, targetIndex: number, extraInfo: TabsAnimationEvent) => {
        this.tabsIndex = targetIndex;
        this.scrollController.scrollToIndex(targetIndex, true, ScrollAlign.START);
      } as OnTabsAnimationStartCallback)
    }
    .height('100%')
    .backgroundColor('#F1F1F1')
    .expandSafeArea([SafeAreaType.SYSTEM], [SafeAreaEdge.BOTTOM])
  }
}

/**
 * 瀑布流列表项组件布局
 *
 * @param listData 组件列表信息
 */
// TODO:知识点：
// 1.@Reusable标识自定义组件具备可复用的能力，它可以被添加到任意的自定义组件上。
// 2.复用自定义组件时避免一切可能改变自定义组件的组件树结构和可能使可复用组件中产生重新布局的操作以将组件复用的性能提升到最高。

@Reusable
@Component
struct methodPoints {
  @State listData: SceneModuleInfo =
    new SceneModuleInfo($r('app.media.functional_scenes_address_exchange'), '地址交换动画',
      'addressexchange/AddressExchangeView', '动效', 1);
  @State helperUrl: string = 'about://blank';
  @State screenW: number = px2vp(display.getDefaultDisplaySync().width);
  @State isNeedClear: boolean = false;
  private deviceSize: number = 600; // 依据Navigation的mode属性说明，如使用Auto，窗口宽度>=600vp时，采用Split模式显示；窗口宽度<600vp时，采用Stack模式显示。
  // 当前屏幕折叠态（仅折叠屏设备下有效）
  curFoldStatus: display.FoldStatus = display.FoldStatus.FOLD_STATUS_UNKNOWN;
  // 从AppStorage中获取设别类别，判断是否为折叠屏
  isFoldable: boolean | undefined = AppStorage.get('isFoldable');
  @State @Watch('onShowReadMeChange') isShowReadMe: boolean = false;

  aboutToAppear(): void {
    if (display.isFoldable()) {
      this.regDisplayListener();
    } else {
      if (this.screenW >= this.deviceSize) {
        this.isNeedClear = true;
      } else {
        this.isNeedClear = false;
      }
    }
  }

  /**
   * 组件的生命周期回调，在可复用组件从复用缓存中加入到组件树之前调用
   * @param params：组件更新时所需参数
   */
  aboutToReuse(params: Record<string, SceneModuleInfo>): void {
    const listData = params['listData'];
    if (listData) {
      this.listData = listData as SceneModuleInfo;
    }
  }

  /**
   * 注册屏幕状态监听 (仅限折叠屏)
   * @returns {void}
   */
  regDisplayListener(): void {
    this.changeNeedClear(display.getFoldStatus());
    display.on('foldStatusChange', (curFoldStatus: display.FoldStatus) => {
      // 同一个状态重复触发不做处理
      if (this.curFoldStatus === curFoldStatus) {
        return;
      }
      // 缓存当前折叠状态
      this.curFoldStatus = curFoldStatus;
      this.changeNeedClear(this.curFoldStatus);
    })
  }

  changeNeedClear(status: number): void {
    if (status === display.FoldStatus.FOLD_STATUS_FOLDED) {
      this.isNeedClear = false;
    } else {
      this.isNeedClear = true;
    }
  }

  changeHelpUrl(): void {
    this.helperUrl = this.listData.helperUrl;
  }

  onShowReadMeChange(text: string): void {
    if (!this.isShowReadMe) {

    }
  }

  // 帮助功能：半模态弹窗显示对应案例README
  @Builder
  buildReadMeSheet(): void {
    Column() {
      Row() {
        Row() {
          Text(this.listData.name)
            .textOverflow({ overflow: TextOverflow.Clip } as TextOverflowOptions)
            .fontColor(Color.White)
            .fontWeight(700)
            .fontSize($r('app.integer.nav_destination_title_text_size'))
        }
        .width($r('app.integer.readme_sheet_text_size'))

        Column() {
          Stack() {
            Column() {
            }
            .width($r('app.integer.readme_sheet_size'))
            .height($r('app.integer.readme_sheet_size'))
            .borderRadius($r('app.integer.nav_destination_title_image_border_radius'))
            .backgroundColor(Color.White)
            .opacity(0.05)
            Image($r('app.media.ic_public_cancel'))
              .fillColor(Color.White)
              .width($r('app.integer.readme_sheet_cancel_image_width'))
          }
        }
        .onClick((e: ClickEvent) => {
          this.isShowReadMe = false;
        })
        .justifyContent(FlexAlign.Center)
        .width($r('app.integer.readme_sheet_size'))
        .height($r('app.integer.readme_sheet_size'))
        .borderRadius($r('app.integer.nav_destination_title_image_border_radius'))
      }
      .padding({ left: $r('app.integer.readme_sheet_padding'), right: $r('app.integer.readme_sheet_padding') } as Padding)
      .margin({ top: $r('app.integer.readme_sheet_margin')} as Margin)
      .justifyContent(FlexAlign.SpaceBetween)
      .width('100%')
    }
    .width('100%')
    .height('100%')
  }

  build() {
    Column() {
      Image($r('app.media.background_pic_3'))
        .borderRadius({
          topLeft: 8,
          topRight: 8,
          bottomLeft: 0,
          bottomRight: 0
        } as BorderRadiuses)
        .objectFit(ImageFit.Contain)
        .width('100%')

      Text(this.listData?.serialNumber?.toString() + '. ' + this.listData.name)
        .padding({
          left: 10,
          right: 10
        } as Padding)
        .width('100%')
        .fontColor(Color.Black)
        .textAlign(TextAlign.Start)
        .maxLines(2)
        .fontSize(14)
        .margin({
          top: 10,
          bottom: 10
        } as Margin)
        .textOverflow({ overflow: TextOverflow.Ellipsis } as TextOverflowOptions)

      Row() {
        Button($r('app.string.functional_scenes_readme'))
          .fontSize(12)
          .fontColor(Color.White)
        .height(25)
        .width(100)
        .margin({ left: 6, right: 10 } as Margin)
        .gesture(
          GestureGroup(
            GestureMode.Exclusive,
            TapGesture({ fingers: 1, count: 1 })
              .onAction(() => {
                this.getUIContext().getRouter().pushUrl({url: 'pages/collapsemenu/Concent'})
              })
          )
        )

        Text($r('app.string.functional_scenes_difficulty'))
          .fontColor(Color.Black)
          .opacity(0.6)
          .textAlign(TextAlign.Start)
          .maxLines(1)
          .height(18)
          .fontSize(12)
          .width(25)

        Rating({
          rating: this.listData.ratingNumber,
          indicator: true
        } as RatingOptions)
          .stars(5)
          .width(70)
      }
      .margin({ bottom: 10 } as Margin)
      .width('100%')
      .justifyContent(FlexAlign.Start)
    }
    .shadow(ShadowStyle.OUTER_DEFAULT_XS)
    .backgroundColor(Color.White)
    .width('100%')
    .borderRadius(8)
    .margin({
      top: 4,
      bottom: 4
    } as Margin)
    .onClick((e: ClickEvent) => {
    })
  }
}

