/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import { TitleBar } from '../../../../common/TitleBar';
import { LEFT_PADDING, RIGHT_PADDING } from '../../ComponentData';
import { PropertiesControlPanel } from './SwiperControlPanel';
import { CustomAnimationPropertiesControlPanel } from './SwiperCustomAnimationControlPanel';

@Extend(Column) function backgroundStyle() {
  .width('100%')
  .padding({ left: 12, right: 12, top: 4, bottom: 4 })
  .borderRadius(16)
  .backgroundColor(Color.White)
  .justifyContent(FlexAlign.Start)
}

@Extend(Text) function swiperItemStyle(bgColor: Resource) {
  .width('100%')
  .height('100%')
  .fontSize(30)
  .textAlign(TextAlign.Center)
  .backgroundColor(bgColor)
}

const DISPLAY_COUNT: number = 2;
const MIN_SCALE: number = 0.75;

@Entry
@Component
struct SwiperSample {
  // Common interfaces and properties
  @State isDisableSwipe: boolean = false;
  @State itemSpace: number = 0;
  @State isVertical: boolean = false;
  @State duration: number = 400;
  @State loop: boolean = false;
  @State autoPlay: boolean = false;
  @State interval: number = 1000;

  // properties of custom transition animation
  @State changeOpacity: boolean = false;
  @State changeScale: boolean = false;
  @State closeTwoPagesTogether: boolean = false;
  @State cancelDefaultTranslate: boolean = false;
  @State customAnimationAutoPlay: boolean = false;
  @State customAnimationDuration: number = 400;
  @State customAnimationCurve: string = 'Linear';
  @State backgroundColorList: Resource[] = [
    $r('app.color.background_blue'),
    $r('app.color.background_orange'),
    $r('app.color.background_green'),
    $r('app.color.background_pink')
  ];
  @State opacityList: number[] = [];
  @State scaleList: number[] = [];
  @State translateList: number[] = [];
  @State zIndexList: number[] = [];

  private controller: SwiperController = new SwiperController();
  private data: number[] = [];

  aboutToAppear() {
    for (let i = 1; i < 11; i++) {
      this.data.push(i)
    }
    for (let i = 1; i < this.backgroundColorList.length; i++) {
      this.opacityList.push(1.0)
      this.scaleList.push(1.0)
      this.translateList.push(0.0)
      this.zIndexList.push(0)
    }
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.swiper_name') })

      Tabs() {
        TabContent() {
          this.CommonPropertiesPage()
        }.tabBar(SubTabBarStyle.of($r('app.string.swiper_common_interfaces_and_properties')))

        TabContent() {
          this.CustomPropertiesPage()
        }.tabBar(SubTabBarStyle.of($r('app.string.swiper_custom_properties')))
      }
      .padding({ left: LEFT_PADDING, right: RIGHT_PADDING, bottom: 56 })
      .barMode(BarMode.Scrollable)
      .barBackgroundColor($r('app.color.background_shallow_grey'))
    }
    .backgroundColor($r('app.color.background_shallow_grey'))
  }

  @Builder CommonPropertiesPage() {
    Column() {
      // component
      Swiper(this.controller) {
        ForEach(this.data, (item: number, index) => {
          if (index % 2 === 0) {
            Text(item.toString())
              .swiperItemStyle($r('app.color.background_orange'))
          } else {
            Text(item.toString())
              .swiperItemStyle($r('app.color.background_green'))
          }
        })
      }
      .disableSwipe(this.isDisableSwipe)
      .itemSpace(this.itemSpace)
      .vertical(this.isVertical)
      .duration(this.duration)
      .loop(this.loop)
      .interval(this.interval)
      .autoPlay(this.autoPlay)
      .borderRadius(16)
      .backgroundColor(Color.White)
      .height(216)

      Scroll() {
        // 控制面板
        Column() {
          IntroductionTitle({ introduction: $r('app.string.swiper_introduction_arguments') })
          Column() {
            Row() {
              Text($r('app.string.swiper_controller_next'))
                .fontColor($r('app.color.background_blue'))
                .padding(20)
                .onClick(() => {
                  this.controller.showNext()
                })

              Text($r('app.string.swiper_controller_previous'))
                .fontColor($r('app.color.background_blue'))
                .padding(20)
                .onClick(() => {
                  this.controller.showPrevious()
                })
            }
            .height(56)
            .alignItems(VerticalAlign.Center)
          }
          .backgroundStyle()

          IntroductionTitle({ introduction: $r('app.string.swiper_introduction_properties') })
          Column() {
            PropertiesControlPanel({
              isDisableSwipe: $isDisableSwipe,
              itemSpace: $itemSpace,
              isVertical: $isVertical,
              duration: $duration,
              loop: $loop,
              autoPlay: $autoPlay,
              interval: $interval
            })
          }
          .backgroundStyle()
        }
      }
      .height('calc(100% - 216vp)')
    }
    .height('100%')
    .width('100%')
  }

  @Builder CustomPropertiesPage() {
    Column() {
      Swiper() {
        ForEach(this.backgroundColorList, (backgroundColor: Resource, index: number) => {
          Column()
            .width('100%')
            .height('100%')
            .backgroundColor(backgroundColor)
            .opacity(this.changeOpacity ? this.opacityList[index] : 1.0)
            .scale(this.changeScale ? { x: this.scaleList[index], y: this.scaleList[index] } : {})
            .translate((this.closeTwoPagesTogether || this.cancelDefaultTranslate) ?
              { x: this.translateList[index] } : {})
            .zIndex(this.zIndexList[index])
        })
      }
      .displayCount(DISPLAY_COUNT, true)
      .autoPlay(this.customAnimationAutoPlay)
      .duration(this.customAnimationDuration)
      .curve(this.customAnimationCurve.toLowerCase())
      .customContentTransition({
        transition: (proxy: SwiperContentTransitionProxy) => {
          if (proxy.position <= proxy.index % DISPLAY_COUNT ||
            proxy.position >= DISPLAY_COUNT + proxy.index % DISPLAY_COUNT) {
            // 同组页面往左滑或往右完全滑出视窗外时，重置属性值
            this.opacityList[proxy.index] = 1.0;
            this.scaleList[proxy.index] = 1.0;
            this.translateList[proxy.index] = 0.0;
            this.zIndexList[proxy.index] = 0;
          } else {
            // 同组页面往右滑且未滑出视窗外时，对同组中左右两个页面，逐帧根据position、mainAxisLength修改属性值
            let relativePosition = proxy.position - proxy.index % DISPLAY_COUNT;
            this.opacityList[proxy.index] = 1 - relativePosition / DISPLAY_COUNT;
            this.scaleList[proxy.index] = MIN_SCALE + (1 - MIN_SCALE) * (1 - relativePosition / DISPLAY_COUNT);
            let translate = 0.0;
            if (this.changeScale && this.closeTwoPagesTogether) {
              let itemSpace = (1 - this.scaleList[proxy.index]) * proxy.mainAxisLength;
              if (proxy.index % DISPLAY_COUNT === 0) {
                translate += itemSpace / 2.0;
              } else {
                translate -= itemSpace / 2.0;
              }
            }
            if (this.cancelDefaultTranslate) {
              translate -= relativePosition * proxy.mainAxisLength;
            }
            this.translateList[proxy.index] = translate;
            this.zIndexList[proxy.index] = -1;
          }
        }
      })
      .borderRadius(16)
      .height(216)

      Scroll() {
        // 控制面板
        Column() {
          IntroductionTitle({ introduction: $r('app.string.swiper_modify_custom_properties') })
          Column() {
            CustomAnimationPropertiesControlPanel({
              changeOpacity: $changeOpacity,
              changeScale: $changeScale,
              closeTwoPagesTogether: $closeTwoPagesTogether,
              cancelDefaultTranslate: $cancelDefaultTranslate,
              customAnimationAutoPlay: $customAnimationAutoPlay,
              customAnimationDuration: $customAnimationDuration,
              customAnimationCurve: $customAnimationCurve
            })
          }
          .backgroundStyle()
        }
        .height('calc(100% - 216vp)')
      }
    }
    .height('100%')
    .width('100%')
  }
}