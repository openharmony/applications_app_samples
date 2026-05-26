/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { router } from '@kit.ArkUI';
import { KeyCode } from '@kit.InputKit';
import { globalIdle } from '../utils/GlobalScreenSaver';


@Component
export struct SupportPage {
  @Link isTab: boolean;
  @State focusIndex: number = -1;
  // 在组件类中添加防抖变量
  private lastHoverTime: number = 0;
  private readonly HOVER_DEBOUNCE_TIME = 500; // 500ms内不重复触发
  childrenOnBlur = () => {
  }; // 父组件的失焦处理函数
  @State isFocus: boolean = false;
  private supportSwiperController: SwiperController = new SwiperController();
  @State currentImageIndex: number = 0;
  @State imageResources: ResourceStr[] = [
    $r('app.media.service'),
    $r('app.media.sm1'),
    $r('app.media.sm3')
  ];
  @State scale1: number = 1;
  @State opacity1: number = 1;
  @State focusId: number = 0;

  @Builder
  IndicatorBuilder() {
    Stack() {
      // 用于当作获取焦点、背景、以及获取焦点后的背景改变
      Text(' ')
        .borderRadius('35lpx')
        .width('100lpx')
        .focusable(true)
        .defaultFocus(true)
        .onFocus(() => {
          this.isFocus = true;
          this.isTab = false;
        })
        .onBlur(() => {
          this.isFocus = false;
        })
        .onKeyEvent((e) => {
          globalIdle.resetTimer();
          console.log('hsq', '33332');
          if (e.keyCode == KeyCode.KEYCODE_DPAD_RIGHT && e.type == KeyType.Down) {
            this.supportSwiperController.showNext();
          }
          if (e.keyCode == KeyCode.KEYCODE_DPAD_LEFT && e.type == KeyType.Down) {
            this.supportSwiperController.showPrevious();
          }
        })
        .margin({ bottom: '135lpx' })

        .backgroundColor(this.isFocus ? 'rgba(255,255,255,0.7)' : 'rgba(255,255,255,0.2)');
      Row() {
        ForEach(this.imageResources, (item: ResourceStr, index: number) => {

          Rect()
            .width(this.currentImageIndex === index ? '20lpx' : '12lpx')
            .height('10lpx')
            .radius(this.currentImageIndex === index ? '60lpx' : '6lpx')
            .fill(this.currentImageIndex === index ? '#FFF1F3F5' : '#33F1F3F5')
            .margin('5lpx');

        }, (item: ResourceStr, index: number) => item.toString() + index);
      }
      .width('100%')
      .height('20lpx')
      .justifyContent(FlexAlign.Center) // 水平居中
      .margin({ bottom: '135lpx' })


      .zIndex(188);
    }.alignContent(Alignment.Center);
  }

  build() {
    Stack() {
      Swiper(this.supportSwiperController) {
        ForEach(this.imageResources, (item: ResourceStr, index: number) => {
          Stack() {
            Image(item)
              .width('100%')
              .height('100%')
              .objectFit(ImageFit.Fill);
            Row() {
              Image($r('app.media.swiper_arrow_left'))
                .width(this.focusId == 1 ? '45lpx' : '40lpx')
                .id('FeatureComponent1' + index)
                .onClick(() => {
                  globalIdle.resetTimer();
                  this.supportSwiperController.showPrevious();
                })
                .focusable(false)
                .onFocus(() => {
                  this.focusId = 1;
                  this.isTab = false;
                })
                .onHover((isHover: boolean) => {
                  if (isHover) {
                    const currentTime = Date.now();
                    if (currentTime - this.lastHoverTime > this.HOVER_DEBOUNCE_TIME) {
                      this.focusId = 1;
                      this.isTab = false;
                      this.supportSwiperController.showPrevious();
                      this.lastHoverTime = currentTime;
                    }
                  }
                })
                .visibility(index <= 0 ? Visibility.None : Visibility.Visible)
                .stateStyles({
                  focused: {
                    .border({
                      color: Color.White
                    });
                  }
                });
              // 占位
              Text('    ')
                .fontSize(16);
              Image($r('app.media.swiper_arrow_right'))
                .id('FeatureComponent2' + index)
                .width(this.focusId == 2 ? '45lpx' : '40lpx')
                .onClick(() => {
                  globalIdle.resetTimer();
                  this.supportSwiperController.showNext();
                })
                .onHover((isHover: boolean) => {

                  if (isHover) {
                    const currentTime = Date.now();
                    if (currentTime - this.lastHoverTime > this.HOVER_DEBOUNCE_TIME) {
                      this.supportSwiperController.showNext();
                      this.focusId = 2;
                      this.isTab = false;
                      this.lastHoverTime = currentTime;
                    }
                  }
                })
                .focusable(false)
                .onFocus(() => {
                  this.focusId = 2;
                  this.isTab = false;
                })
                .visibility(index >= this.imageResources.length - 1 ? Visibility.None : Visibility.Visible)
                .stateStyles({
                  focused: {
                    .border({
                      color: Color.White
                    });
                  }
                });
            }
            .width('100%')
            .padding('12lpx')
            .justifyContent(FlexAlign.SpaceBetween)
            .alignItems(VerticalAlign.Center)
            .height('70lpx')
            .position({ top: '46%' });

          }
          .alignContent(Alignment.Start)
          .width('100%')
          .height('100%');

        });

      }
      .loop(false)
      .indicator(false)


      .curve(Curve.Linear)
      .index(this.currentImageIndex)
      .onChange((index) => {
        this.currentImageIndex = index;
      });


      this.IndicatorBuilder();
    }
    .alignContent(Alignment.Bottom)
    .width('100%')
    .onBlur(() => {
      this.focusIndex = -1;
    })
    .onHover(() => {
      globalIdle.resetTimer();
    })
    .stateStyles({
      focused: {
        .border({
          color: Color.White
        });
      }
    })
    .onKeyEvent((e) => {
      globalIdle.resetTimer();
      if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
        this.childrenOnBlur();
      }
    })
    .height('100%');

  }
}


@Extend(Text)
function textExtend(size: number, fontWeight: number, lineHeight: number) {
  .fontColor('rgba(255,255,255,0.9)')
  .fontSize(size + 'lpx')

  .width('100%')
  .textOverflow({ overflow: TextOverflow.Ellipsis })
  .fontWeight(fontWeight)
  .lineHeight(lineHeight + 'lpx')
  .letterSpacing(0)
  .textAlign(TextAlign.Start);
}

@Extend(Text)
function buttonText() {
  .fontSize('18lpx')
  .fontFamily('HarmonyHeiTi')
  .fontWeight(500)
  .width('72lpx')
  .height('24lpx')
  .fontColor('#E6FFFFFF')
  .focusable(true);
}

@Extend(Button)
function buttonExtend(ifFocus: number, type: number) {
  .width('168lpx')
  .height('38lpx')
  .borderRadius('43lpx')
  .padding({
    left: '24lpx',
    right: '24lpx',
  })
  .border({
    width: 1,
    color: 'rgba(255, 255, 255, 0.1)',
    style: BorderStyle.Solid
  })
  .backgroundColor(ifFocus === type ? 'rgba(255, 255, 255, 0.3)' : 'rgba(255, 255, 255, 0.1)');
}

