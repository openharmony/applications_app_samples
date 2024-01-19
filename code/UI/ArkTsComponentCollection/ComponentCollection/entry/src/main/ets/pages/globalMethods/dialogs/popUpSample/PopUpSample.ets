/*
* Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
import { TitleBar } from '../../../../common/TitleBar'
import { IntroductionTitle } from '../../../../common/IntroductionTitle'

// Popup宽度
const POPUPWIDTH: number = 50;
// slider滑块最大值
const MAXWIDTH: number = 200;
// Popup border-radius值
const POPUPRADIUS: number = 20;

@Extend(Button) function myButtonStyle() {
  .fontFamily('HarmonyHeiTi-Medium')
  .fontColor('#FFFFFF')
  .fontSize(16)
  .fontWeight(500)
  .height('5.1%')
  .backgroundColor('#007DFF')
  .borderRadius(20)
}

@Extend(Text) function textStyle() {
  .fontFamily('HarmonyHeiTi-Medium')
  .fontColor('#182431')
  .fontWeight(500)
  .borderRadius(24)
}

@Entry
@Component
struct PopUpSample {
  @State popupWidth: number = POPUPWIDTH;
  @State handlePopup: boolean = false;
  @State customPopup: boolean = false;
  @State customPopupTop: boolean = false;
  @State customPopupBottom: boolean = false;
  @State customPopupRight: boolean = false;
  @State customPopupLeft: boolean = false;
  @State customPopupTopRight: boolean = false;
  @State customPopupTopLeft: boolean = false;
  @State customPopupBottomRight: boolean = false;
  @State customPopupBottomLeft: boolean = false;
  @State customPopupRightTop: boolean = false;
  @State customPopupLeftTop: boolean = false;
  @State customPopupRightBottom: boolean = false;
  @State customPopupLeftBottom: boolean = false;
  @State popUpText: string = 'AAAAAAAAAAAAAAAA';
  @State vpText: string = 'vp';
  @State topText: string = 'Top';
  @State bottomText: string = 'Bottom';
  @State rightText: string = 'Right';
  @State leftText: string = 'Left';
  @State topRightText: string = 'TopRight';
  @State topLeftText: string = 'TopLeft';
  @State bottomRightText: string = 'BottomRight';
  @State bottomLeftText: string = 'BottomLeft';
  @State rightTopText: string = 'RightTop';
  @State leftTopText: string = 'LeftTop';
  @State rightBottomText: string = 'RightBottom';
  @State leftBottomText: string = 'LeftBottom';

  // popup构造器定义弹框内容
  @Builder popupBuilder() {
    Text(this.popUpText)
      .fontFamily('HarmonyHeiTi')
      .fontSize(14)
      .fontColor('#FFFFFF')
      .textAlign(TextAlign.Start)
      .lineHeight(19)
      .fontWeight(400)
      .margin({left:16, right: 16, top: 12.5, bottom: 12.5})
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.global_popUp_menu') })
        .backgroundColor('#F1F3F5')
      Scroll() {
        Column() {
          Column() {
            Row() {
              Text($r('app.string.popUp_width'))
                .textStyle()
                .textAlign(TextAlign.Start)
                .margin({ left: 12, top: 12 })
                .fontSize(16)
                .lineHeight(22)

              Blank()

              Text(Math.trunc(this.popupWidth) + this.vpText)
                .textStyle()
                .textAlign(TextAlign.End)
                .margin({ right: 12, top: 12 })
                .fontSize(14)
                .lineHeight(19)

            }
            .width('100%')

            Slider({
              style: SliderStyle.OutSet,
              value: this.popupWidth,
              step: 1,
              min: 0,
              max: MAXWIDTH
            })
              .id('popup_slider')
              .margin({ left: 6, right: 6 })
              .onChange(value => {
                this.popupWidth = value;
              })
          }
          .backgroundColor('#ffffff')
          .borderRadius(24)
          .width('100%')

          IntroductionTitle({ introduction: $r('app.string.placement') })

          Column() {
            Row() {
              Button(this.topText)
                .id('popup_top')
                .width('41.7%')
                .myButtonStyle()
                .margin({ left: 12 })
                .bindPopup(this.customPopupTop, {
                  builder: this.popupBuilder,
                  popupColor: '#4D4D4D',
                  radius: POPUPRADIUS,
                  placement: Placement.Top,
                  width: this.popupWidth,
                  onStateChange: (e) => {
                    if (!e.isVisible) {
                      this.customPopupTop = false;
                    }
                  }
                })
                .onClick(() => {
                  this.customPopupTop = !this.customPopupTop;
                })
              Blank()
              Button(this.bottomText)
                .id('popup_bottom')
                .width('41.7%')
                .myButtonStyle()
                .margin({ right: 12 })
                .bindPopup(this.customPopupBottom, {
                  builder: this.popupBuilder,
                  popupColor: '#4D4D4D',
                  radius: POPUPRADIUS,
                  enableArrow: true,
                  shadow: ShadowStyle.OUTER_DEFAULT_XS,
                  placement: Placement.Bottom,
                  width: this.popupWidth,
                  onStateChange: (e) => {
                    if (!e.isVisible) {
                      this.customPopupBottom = false;
                    }
                  }
                })
                .onClick(() => {
                  this.customPopupBottom = !this.customPopupBottom;
                })
            }
            .width('100%')
            .margin({ left: 12, right: 12, top: 16, bottom: 12 })

            Row() {
              Button(this.rightText)
                .id('popup_right')
                .width('41.7%')
                .myButtonStyle()
                .margin({ left: 12 })
                .bindPopup(this.customPopupRight, {
                  builder: this.popupBuilder,
                  popupColor: '#4D4D4D',
                  radius: POPUPRADIUS,
                  enableArrow: true,
                  shadow: ShadowStyle.OUTER_DEFAULT_XS,
                  placement: Placement.Right,
                  width: this.popupWidth,
                  onStateChange: (e) => {
                    if (!e.isVisible) {
                      this.customPopupRight = false;
                    }
                  }
                })
                .onClick(() => {
                  this.customPopupRight = !this.customPopupRight;
                })
              Blank()
              Button(this.leftText)
                .id('popup_left')
                .width('41.7%')
                .myButtonStyle()
                .margin({ right: 12 })
                .bindPopup(this.customPopupLeft, {
                  builder: this.popupBuilder,
                  popupColor: '#4D4D4D',
                  radius: POPUPRADIUS,
                  enableArrow: true,
                  shadow: ShadowStyle.OUTER_DEFAULT_XS,
                  placement: Placement.Left,
                  width: this.popupWidth,
                  onStateChange: (e) => {
                    if (!e.isVisible) {
                      this.customPopupLeft = false;
                    }
                  }
                })
                .onClick(() => {
                  this.customPopupLeft = !this.customPopupLeft;
                })
            }
            .width('100%')
            .margin({ left: 12, right: 12, bottom: 12 })

            Row() {
              Button(this.topRightText)
                .id('popup_topRight')
                .width('41.7%')
                .myButtonStyle()
                .margin({ left: 12 })
                .bindPopup(this.customPopupTopRight, {
                  builder: this.popupBuilder,
                  popupColor: '#4D4D4D',
                  radius: POPUPRADIUS,
                  enableArrow: true,
                  shadow: ShadowStyle.OUTER_DEFAULT_XS,
                  placement: Placement.TopRight,
                  width: this.popupWidth,
                  onStateChange: (e) => {
                    if (!e.isVisible) {
                      this.customPopupTopRight = false;
                    }
                  }
                })
                .onClick(() => {
                  this.customPopupTopRight = !this.customPopupTopRight;
                })
              Blank()
              Button(this.topLeftText)
                .id('popup_topLeft')
                .width('41.7%')
                .myButtonStyle()
                .margin({ right: 12 })
                .bindPopup(this.customPopupTopLeft, {
                  builder: this.popupBuilder,
                  popupColor: '#4D4D4D',
                  radius: POPUPRADIUS,
                  enableArrow: true,
                  shadow: ShadowStyle.OUTER_DEFAULT_XS,
                  placement: Placement.TopLeft,
                  width: this.popupWidth,
                  onStateChange: (e) => {
                    if (!e.isVisible) {
                      this.customPopupTopLeft = false;
                    }
                  }
                })
                .onClick(() => {
                  this.customPopupTopLeft = !this.customPopupTopLeft;
                })
            }
            .width('100%')
            .margin({ left: 12, right: 12, bottom: 12 })

            Row() {
              Button(this.bottomRightText)
                .id('popup_bottomRight')
                .width('41.7%')
                .myButtonStyle()
                .margin({ left: 12 })
                .bindPopup(this.customPopupBottomRight, {
                  builder: this.popupBuilder,
                  popupColor: '#4D4D4D',
                  radius: POPUPRADIUS,
                  enableArrow: true,
                  shadow: ShadowStyle.OUTER_DEFAULT_XS,
                  placement: Placement.BottomRight,
                  width: this.popupWidth,
                  onStateChange: (e) => {
                    if (!e.isVisible) {
                      this.customPopupBottomRight = false;
                    }
                  }
                })
                .onClick(() => {
                  this.customPopupBottomRight = !this.customPopupBottomRight;
                })
              Blank()
              Button(this.bottomLeftText)
                .id('popup_bottomLeft')
                .width('41.7%')
                .myButtonStyle()
                .margin({ right: 12 })
                .bindPopup(this.customPopupBottomLeft, {
                  builder: this.popupBuilder,
                  popupColor: '#4D4D4D',
                  radius: POPUPRADIUS,
                  enableArrow: true,
                  shadow: ShadowStyle.OUTER_DEFAULT_XS,
                  placement: Placement.BottomLeft,
                  width: this.popupWidth,
                  onStateChange: (e) => {
                    if (!e.isVisible) {
                      this.customPopupBottomLeft = false;
                    }
                  }
                })
                .onClick(() => {
                  this.customPopupBottomLeft = !this.customPopupBottomLeft;
                })
            }
            .width('100%')
            .margin({ left: 12, right: 12, bottom: 12 })

            Row() {
              Button(this.rightTopText)
                .id('popup_rightTop')
                .width('41.7%')
                .myButtonStyle()
                .margin({ left: 12 })
                .bindPopup(this.customPopupRightTop, {
                  builder: this.popupBuilder,
                  popupColor: '#4D4D4D',
                  radius: POPUPRADIUS,
                  enableArrow: true,
                  shadow: ShadowStyle.OUTER_DEFAULT_XS,
                  placement: Placement.RightTop,
                  width: this.popupWidth,
                  onStateChange: (e) => {
                    if (!e.isVisible) {
                      this.customPopupRightTop = false;
                    }
                  }
                })
                .onClick(() => {
                  this.customPopupRightTop = !this.customPopupRightTop;
                })

              Blank()
              Button(this.leftTopText)
                .id('popup_leftTop')
                .width('41.7%')
                .myButtonStyle()
                .margin({ right: 12 })
                .bindPopup(this.customPopupLeftTop, {
                  builder: this.popupBuilder,
                  popupColor: '#4D4D4D',
                  radius: POPUPRADIUS,
                  enableArrow: true,
                  shadow: ShadowStyle.OUTER_DEFAULT_XS,
                  placement: Placement.LeftTop,
                  width: this.popupWidth,
                  onStateChange: (e) => {
                    if (!e.isVisible) {
                      this.customPopupLeftTop = false;
                    }
                  }
                })
                .onClick(() => {
                  this.customPopupLeftTop = !this.customPopupLeftTop;
                })
            }
            .width('100%')
            .margin({ left: 12, right: 12, bottom: 12 })

            Row() {
              Button(this.rightBottomText)
                .id('popup_rightBottom')
                .width('41.7%')
                .myButtonStyle()
                .margin({ left: 12 })
                .bindPopup(this.customPopupRightBottom, {
                  builder: this.popupBuilder,
                  popupColor: '#4D4D4D',
                  radius: POPUPRADIUS,
                  enableArrow: true,
                  shadow: ShadowStyle.OUTER_DEFAULT_XS,
                  placement: Placement.RightBottom,
                  width: this.popupWidth,
                  onStateChange: (e) => {
                    if (!e.isVisible) {
                      this.customPopupRightBottom = false;
                    }
                  }
                })
                .onClick(() => {
                  this.customPopupRightBottom = !this.customPopupRightBottom;
                })
              Blank()
              Button(this.leftBottomText)
                .id('popup_leftBottom')
                .width('41.7%')
                .myButtonStyle()
                .margin({ right: 12 })
                .bindPopup(this.customPopupLeftBottom, {
                  builder: this.popupBuilder,
                  popupColor: '#4D4D4D',
                  radius: POPUPRADIUS,
                  enableArrow: true,
                  shadow: ShadowStyle.OUTER_DEFAULT_XS,
                  placement: Placement.LeftBottom,
                  width: this.popupWidth,
                  onStateChange: (e) => {
                    if (!e.isVisible) {
                      this.customPopupLeftBottom = false;
                    }
                  }
                })
                .onClick(() => {
                  this.customPopupLeftBottom = !this.customPopupLeftBottom;
                })
            }
            .width('100%')
            .margin({ left: 12, right: 12, bottom: 16 })

          }
          .backgroundColor('#FFFFFF')
          .borderRadius(24)

          Blank()

          Button($r('app.string.popUp_advanced_component'))
            .id('popup_advanced')
            .myButtonStyle()
            .width('86.7%')
            .margin({ left: 24, right: 24, bottom: 96 })
            .bindPopup(this.customPopup, {
              builder: this.popupBuilder,
              popupColor: '#4D4D4D',
              radius: POPUPRADIUS,
              enableArrow: true,
              shadow: ShadowStyle.OUTER_DEFAULT_XS,
              onStateChange: (e) => {
                if (!e.isVisible) {
                  this.customPopup = false;
                }
              }
            })
            .onClick(async () => {
              this.customPopup = !this.customPopup;
            })
        }
        .backgroundColor('#f1f3f5')
        .constraintSize({ minHeight: '100%' }) // Let the minHeight of the component cover screen at least
        .width('100%')
        .height('100%')
      }
      .backgroundColor('#f1f3f5')
      .height('100%')
      .padding({ left: 12, right: 12, bottom: 12, top: 12 })
    }
    .width('100%')
  }
}