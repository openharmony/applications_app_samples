/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import { TitleBar } from '../../../../common/TitleBar'

@Extend(Column)
function cardStyle() {
  .backgroundColor($r('app.color.white'))
  .borderRadius(24)
  .width('100%')
  .padding(15)
}

@Extend(Text)
function subTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
}

@Extend(Circle)
function colorPicker(color: Color | string, callback: ()=>void) {
  .fill(color)
  .height(20)
  .width(20)
  .onClick(() => {
    callback()
  })
}

@Styles
function pressedStyle() {
  .opacity(0.7)
  .borderWidth(1)
  .borderRadius(20)
}

@Extend(Text)
function leftTitleStyle() {
  .fontColor($r('app.color.sub_title_color'))
  .fontSize(14)
  .height(22)
  .alignSelf(ItemAlign.Start)
  .margin({left: 12, top: 12})
}

@Entry
@Component
struct Effects {
  @State mTabIndex: number = 0
  @State mBlur: number = 1
  @State mBackgroundBlur: number = 1
  @State mShadowRadius: number = 0
  @State mShadowColor: Color = Color.Red
  @State mShadowOffsetX: number = 0
  @State mShadowOffsetY: number = 0

  @State mGrayscale: number = 0
  @State mBrighthness: number = 1
  @State mSaturate: number = 1
  @State mConstrast: number = 1
  @State mInvert: number = 0
  @State mColorBlend: Color | string = '#00ffffff'
  @State mSepia: number = 0
  @State mHueRotate: number = 0

  @Builder tabbarTitle(name: Resource, index: number) {
    Stack() {
      Text(name)
        .fontSize(22)
        .fontColor(this.mTabIndex === index ? '#0A59F7' : '#000000')

      if (this.mTabIndex === index) {
        Row()
          .backgroundColor('#0A59F7')
          .width('100%')
          .height(2)
          .position({y: 48})
      }
    }.width(48)
    .height(56)
  }

  build() {
    Column({space: 10}) {
      TitleBar({ title: $r('app.string.components_effects') })
      Tabs() {
        TabContent() {
          Column() {
            Text($r('app.string.blur_effects'))
              .leftTitleStyle()
            Column({space: 5}) {
              Row() {
                Text("ABCDEFG abcdefg")
                  .fontSize(20)
                  .height(60)
                  .layoutWeight(1)
                  .backgroundColor(0xF9CF93)
                  .blur(this.mBlur)
              }.width('100%')
              Text($r('app.string.blur_radius_modify'))
                .margin({top: 12})
                .fontSize(15)
                .alignSelf(ItemAlign.Start)
              Row({space: 5}) {
                Text('0')
                Slider({value: this.mBlur, min: 0, max: 20})
                  .onChange((value) => {
                    this.mBlur = value
                  })
                  .width('90%')
                Text('20')
              }.width('100%')
            }.cardStyle()
            Text($r('app.string.background_blur'))
              .leftTitleStyle()
            Column() {
              Stack() {
                Text("ABCDEFG abcdefg")
                  .fontSize(20)
                  .fontColor(Color.Black)
              }.backgroundImage($r('app.media.icon'))
              .backgroundImageSize({width: '100%', height: '100%'})
              .backdropBlur(this.mBackgroundBlur)
              .width('80%')
              .height(200)
              Text($r('app.string.blur_radius_modify'))
                .margin({top: 12})
                .fontSize(15)
                .alignSelf(ItemAlign.Start)
              Row({space: 5}) {
                Text('0')
                Slider({value: this.mBackgroundBlur, min: 0, max: 20})
                  .onChange((value) => {
                    this.mBackgroundBlur = value
                  })
                  .width('90%')
                Text('20')
              }.width('100%')
            }.cardStyle()
            .width('100%')
          }
        }.tabBar(this.tabbarTitle($r('app.string.blur'), 0))

        TabContent() {
          Column() {
            Text($r('app.string.shadow_effects'))
              .leftTitleStyle()
            Column({space: 5}) {
              Stack() {
                Text($r('app.string.shadow_effects'))
                  .fontSize(20)
              }
              .width('100%')
              .height(60)
              .alignSelf(ItemAlign.Start)
              .shadow({
                radius: this.mShadowRadius,
                color: this.mShadowColor,
                offsetX: this.mShadowOffsetX,
                offsetY: this.mShadowOffsetY
              })
              .backgroundColor(0xF9CF93)
              Text($r('app.string.blur_radius_modify'))
                .margin({top: 12})
                .fontSize(15)
                .alignSelf(ItemAlign.Start)
              Row({space: 5}) {
                Text('0')
                Slider({value: this.mShadowRadius, min: 0, max: 20})
                  .onChange((value) => {
                    this.mShadowRadius = value
                  })
                  .width('90%')
                Text('20')
              }.width('100%')
              Text($r('app.string.x_offset'))
                .margin({top: 12})
                .fontSize(15)
                .alignSelf(ItemAlign.Start)
              Row({space: 5}) {
                Text('0')
                Slider({value: this.mShadowOffsetX, min: 0, max: 20})
                  .onChange((value) => {
                    this.mShadowOffsetX = value
                  })
                  .width('90%')
                Text('20')
              }.width('100%')
              Text($r('app.string.y_offset'))
                .margin({top: 12})
                .fontSize(15)
                .alignSelf(ItemAlign.Start)
              Row({space: 5}) {
                Text('0')
                Slider({value: this.mShadowOffsetY, min: 0, max: 20})
                  .onChange((value) => {
                    this.mShadowOffsetY = value
                  })
                  .width('90%')
                Text('20')
              }.width('100%')
            }.cardStyle()
            .width('100%')
          }
        }.tabBar(this.tabbarTitle($r('app.string.shadow'), 1))

        TabContent() {
          Column() {
            Column() {
              Stack() {
                Image($r('app.media.icon'))
                  .objectFit(ImageFit.Contain)
                  .width('100%')
                  .height('100%')
              }
              .width('100%')
              .height(120)
              .alignSelf(ItemAlign.Start)
              .grayscale(this.mGrayscale)
              .brightness(this.mBrighthness)
              .saturate(this.mSaturate)
              .contrast(this.mConstrast)
              .invert(this.mInvert)
              .colorBlend(this.mColorBlend)
              .sepia(this.mSepia)
              .hueRotate(this.mHueRotate)
            }.cardStyle()
            Text($r('app.string.effects_display'))
              .subTitleStyle()
              .margin({bottom: 20})
            Column({space: 10}) {
              Row({space: 5}) {
                Text($r('app.string.grayscale_change'))
                  .fontSize(15)
                Blank()
                Text('0')
                Slider({value: this.mGrayscale, min: 0, max: 1, step: 0.1})
                  .onChange((value) => {
                    this.mGrayscale = value
                  })
                  .showTips(true)
                  .width('60%')
                Text('1')
              }.width('100%')
              Row({space: 5}) {
                Text($r('app.string.brightness_change'))
                  .fontSize(15)
                Blank()
                Text('0')
                Slider({value: this.mBrighthness, min: 0, max: 2, step: 0.1})
                  .onChange((value) => {
                    this.mBrighthness = value
                  })
                  .showTips(true)
                  .width('60%')
                Text('2')
              }.width('100%')

              Row({space: 5}) {
                Text($r('app.string.saturate_change'))
                  .fontSize(15)
                Blank()
                Text('0')
                Slider({value: this.mSaturate, min: 0, max: 2, step: 0.1})
                  .onChange((value) => {
                    this.mSaturate = value
                  })
                  .showTips(true)
                  .width('60%')
                Text('2')
              }.width('100%')
              Row({space: 5}) {
                Text($r('app.string.constrast_change'))
                  .fontSize(15)
                Blank()
                Text('0')
                Slider({value: this.mConstrast, min: 0, max: 2, step: 0.1})
                  .onChange((value) => {
                    this.mConstrast = value
                  })
                  .showTips(true)
                  .width('60%')
                Text('2')
              }.width('100%')

              Row({space: 5}) {
                Text($r('app.string.invert_change'))
                  .fontSize(15)
                Blank()
                Text('0')
                Slider({value: this.mInvert, min: 0, max: 2, step: 0.1})
                  .onChange((value) => {
                    this.mInvert = value
                  })
                  .showTips(true)
                  .width('60%')
                Text('2')
              }.width('100%')

              Row({space: 5}) {
                Text($r('app.string.sepia_change'))
                  .fontSize(15)
                Blank()
                Text('0')
                Slider({value: this.mSepia, min: 0, max: 2, step: 0.1})
                  .onChange((value) => {
                    this.mSepia = value
                  })
                  .showTips(true)
                  .width('60%')
                Text('2')
              }.width('100%')

              Row({space: 5}) {
                Text($r('app.string.hueRotate_change'))
                  .fontSize(15)
                Blank()
                Text('-180')
                Slider({value: this.mHueRotate, min: -180, max: 180})
                  .onChange((value) => {
                    this.mHueRotate = value
                  })
                  .showTips(true)
                  .width('60%')
                Text('180')
              }.width('100%')
              .height(30)
              Row({space: 5}) {
                Text($r('app.string.color_blend_change'))
                  .fontSize(15)
                Blank()
                Row() {
                  Blank()
                  ForEach([Color.Transparent, Color.Red, Color.Yellow, Color.Pink, Color.Orange, Color.Green, Color.Blue], (item: Color) => {
                    Circle({width: 20, height: 20})
                      .colorPicker(item, () => {
                        this.mColorBlend = item
                      })
                      .stateStyles({
                        pressed: pressedStyle,
                        normal: {
                          .borderRadius(20)
                          .borderWidth(1)
                        }
                      })
                    Blank()
                  })
                }.width('70%')
                .height(30)
              }.width('100%')
            }.cardStyle()
            .width('100%')
          }
        }.tabBar(this.tabbarTitle($r('app.string.effects'), 2))
      }.onChange((index) => {
        this.mTabIndex = index
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor(0xefefef)
    .padding({left: 15, right: 15})
  }
}