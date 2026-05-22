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

interface FeatureItem {
  icon: Resource;
  title: string;
  description: string;
}

@Component
export struct FeaturePage {
  // 用来左右切换图片的灵犀、触控、触摸上样式的（他并不需要焦点）
  @State focusId: number = -1
  // 在组件类中添加防抖变量
  private lastHoverTime: number = 0
  private readonly HOVER_DEBOUNCE_TIME = 1000 // 500ms内不重复触发
  @Link isTab: boolean
  @Prop isOtherFocusable: boolean
  childrenOnBlur = () => {
  } // 父组件的失焦处理函数
  @State focusIndex: number = -1
  @State startIndex: number = -1
  @State endIndex: number = -1
  scroller: Scroller = new Scroller()
  @State features: FeatureItem[] = [
    {
      icon: $r('app.media.UniversalInterconnection'),
      title: '通用互联',
      description: '多设备协同，一键流转内容'
    },
    {
      icon: $r('app.media.Cast'),
      title: '投屏',
      description: 'Miracast+DLNA，小屏轻松上大屏'
    },
    {
      icon: $r('app.media.AI'),
      title: '智能AI',
      description: 'DeepSeek大模型，有问必答懂你所想'
    },
    {
      icon: $r('app.media.PointingRemoteControl'),
      title: '指向遥控',
      description: '远场语音，无需遥控器操作'
    },
    {
      icon: $r('app.media.ScreenSaver'),
      title: '智慧屏保',
      description: '待机艺术，回忆名画轮播'
    },
    {
      icon: $r('app.media.Voice'),
      title: '语音交互',
      description: '一键语音，搜片调机动口不动手'
    },
    {
      icon: $r('app.media.Distributed'),
      title: '分布式',
      description: '白板图库相机，跨端协同无界'
    },
  ]

  build() {
    Column() {
      Text('功能目录')
        .fontSize('48lpx')
        .fontColor('rgba(255,255,255,0.9)')
        .fontWeight(700)

        .lineHeight('56lpx')
        .textAlign(TextAlign.Center)
        .margin({ top: '50lpx' })


      // 场景列表
      this.buildSceneList()

    }
    .width('100%')
    .height('100%')

  }

  @Builder
  buildSceneList() {
    Stack() {
      List({ space: '64lpx', scroller: this.scroller }) {
        ForEach(this.features, (scene: FeatureItem, index: number) => {
          ListItem() {
            Row() {
              Stack() {
                Image(scene.icon)
                  .width(this.focusIndex === index ? '396lpx' : '360lpx')
                  .height(this.focusIndex === index ? '624lpx' : '567lpx')
                  .objectFit(ImageFit.Cover)
                  .borderRadius(this.focusIndex === index ? '26.4lpx' : '24lpx')
                  .border({
                    width: this.focusIndex === index ? '3lpx' : 0,
                    color: this.focusIndex === index ? '#CCCCCC' : Color.Transparent
                  })
                  .shadow({
                    radius: this.focusIndex === index ? 5 : 0, // 阴影模糊半径，值越大越虚化
                    color: this.focusIndex === index ? '#fff' : Color.Transparent,
                  })
                  .blur(0.1, { grayscale: [0, 50] })
                // 遮罩层
                Column() {
                }
                .width(this.focusIndex === index ? '390lpx' : '360lpx')
                .height('30%')
                .borderRadius(this.focusIndex === index ? '26.4lpx' : '24lpx')
                .margin({ bottom: this.focusIndex === index ? '3lpx' : 0 })
                .linearGradient({
                  colors: [['rgba(0, 0, 0, 0)', 0.0], ['rgba(0, 0, 0, 0.1)', 0.3],
                    ['rgba(0, 0, 0, 0.3)', 0.5], ['rgba(0, 0, 0, 0.6)', 1]]
                })

                Text(scene.title)
                  .fontSize('33lpx')
                  .fontColor('rgba(255,255,255,0.86)')
                  // .fontColor(this.focusIndex === index ? '#0A59F7' : '#666666')
                  .margin({ bottom: '44lpx' })
                  .lineHeight('40lpx')
                  .textAlign(TextAlign.Center)
              }
              .alignContent(Alignment.Bottom)
              .onFocus(() => {

                animateTo({
                  duration: 0
                }, () => {
                  this.getUIContext().getFocusController().activate(true)
                  this.focusIndex = index;
                })
                this.isTab = false
              })

              .onHover((isOnHover) => {
                globalIdle.resetTimer()
                if (isOnHover) {
                  this.focusIndex = index
                  this.isTab = false
                }
              })
              .onClick(() => {
                globalIdle.resetTimer()
                router.pushUrl({
                  url: 'Component/FeatureComponent',
                  params: { index }
                }, router.RouterMode.Single)
              })
              .onBlur(() => {
                this.focusIndex = -1
              })
              .onKeyEvent((e) => {

                if (e.keyCode == KeyCode.KEYCODE_DPAD_DOWN && e.type == KeyType.Down) {
                  this.childrenOnBlur()
                }
              })
              .stateStyles({
                focused: {
                  .border({
                    color: Color.White
                  })
                }
              })
            }.height('650lpx')
            .width('400lpx')
            .alignItems(VerticalAlign.Center)
            .justifyContent(FlexAlign.Center)
          }

        })
      }
      .listDirection(Axis.Horizontal)
      .focusable(this.isOtherFocusable)
      .onScrollIndex((startIndex: number, endIndex: number, centerIndex: number) => {
        console.log('hsqcenterIndex', startIndex)
        this.startIndex = startIndex
        this.endIndex = endIndex
      })
      .onKeyEvent(() => {
        globalIdle.resetTimer()
      })
      // .width('100%')
      .height('650lpx')
      .margin({ left: '64lpx', right: '64lpx' })

      // 左右跳转图片
      Row() {
        Image($r('app.media.swiper_arrow_left'))
          .width(this.focusId == 1 ? '45lpx' : '40lpx')
          .onClick(() => {
            globalIdle.resetTimer()
            this.scroller.scrollToIndex(this.startIndex - 1)
          })
          .focusable(false)
          .onHover((isHover: boolean) => {
            if (isHover) {
              this.focusId = 1
              const currentTime = Date.now()
              if (currentTime - this.lastHoverTime > this.HOVER_DEBOUNCE_TIME) {
                this.lastHoverTime = currentTime
              }
            } else {
              this.focusId = -1
            }
          })
          .visibility(this.startIndex >= 1 ? Visibility.Visible : Visibility.None)

        Text('   ')
          .fontSize(16)
        Image($r('app.media.swiper_arrow_right'))
          .width(this.focusId == 2 ? '45lpx' : '40lpx')
          .onClick(() => {
            globalIdle.resetTimer()
            this.scroller.scrollToIndex(this.startIndex + 1)
          })
          .onHover((isHover: boolean) => {
            if (isHover) {
              const currentTime = Date.now()
              if (currentTime - this.lastHoverTime > this.HOVER_DEBOUNCE_TIME) {
                this.focusId = 2
                this.lastHoverTime = currentTime
              }
            } else {
              this.focusId = -1
            }
          })
          .focusable(false)
          .visibility(this.startIndex + 3 >= this.features.length ? Visibility.None : Visibility.Visible)
      }
      .zIndex(99)
      .width('100%')
      .padding('12lpx')
      .justifyContent(FlexAlign.SpaceBetween)
      .alignItems(VerticalAlign.Center)
      .height('70lpx')

      // .position({ top: '46%' })

    }
    .height('650lpx')
    .margin({ top: '100lpx' })
    .width('100%')
    .alignContent(Alignment.Center)

  }
}



