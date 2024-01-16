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

@Extend(Column) function backgroundStyle() {
  .width('100%')
  .padding(12)
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


@Entry
@Component
struct SwiperSample {
  @State isDisableSwipe: boolean = false;
  @State itemSpace: number = 0;
  @State isVertical: boolean = false;
  @State duration: number = 400;
  @State loop: boolean = false;
  @State autoPlay: boolean = false;
  @State interval: number = 1000;
  private controller: SwiperController = new SwiperController();
  private data: number[] = [];

  @Styles commonButtonStyle(){
    .backgroundColor($r('app.color.background_blue'))
    .padding(12)
    .borderRadius(10)
  }

  aboutToAppear() {
    for (let i = 1; i < 11; i++) {
      this.data.push(i)
    }
  }

  build() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Start }) {
      TitleBar({ title: $r('app.string.swiper_title') })
        .flexGrow(0)
      IntroductionTitle({ introduction: $r('app.string.swiper_introduction') })
      // component
      Swiper(this.controller) {
        ForEach(this.data, (item: number, index) => {
          if (index % 2 === 0) {
            Text(item.toString())
              .swiperItemStyle($r('app.color.background_orange'))
          } else {
            Text(item.toString())
              .swiperItemStyle($r('app.color.background_light_gray'))
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
      .width('100%')
      .height(200)
      .flexGrow(0)

      Scroll() {
        // 控制面板
        Column() {
          IntroductionTitle({ introduction: $r('app.string.swiper_introduction_arguments') })
          Column() {
            Row() {
              Text($r('app.string.swiper_controller_next'))
                .fontColor($r('app.color.background_blue'))
                .margin({ right: 40 })
                .onClick(() => {
                  this.controller.showNext()
                })

              Text($r('app.string.swiper_controller_previous'))
                .fontColor($r('app.color.background_blue'))
                .onClick(() => {
                  this.controller.showPrevious()
                })
            }
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
        .justifyContent(FlexAlign.Start)
        .width('100%')
      }
      .flexGrow(1)
      .margin({ bottom: 10 })
    }
    .padding({ left: LEFT_PADDING, right: RIGHT_PADDING })
    .height('100%')
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}