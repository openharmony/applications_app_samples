/**
 * Copyright (c) 2024 Shenzhen Kaihong Digital Industry Development Co., Ltd.
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

import { TitleBar } from '../../../../common/TitleBar';

@Extend(Text) function textStyle(widthValue: number) {
  .height(78)
  .width(widthValue)
}

@Extend(Text) function fontTextStyle() {
  .width(96)
  .height(22)
  .fontFamily('HarmonyHeiTi-Medium')
  .fontSize(16)
  .textAlign(TextAlign.Center)
  .lineHeight(22)
  .fontWeight(500)
}

@Extend(Text) function buttonTextStyle() {
  .height(18)
  .width(56)
  .textAlign(TextAlign.Center)
  .align(Alignment.Center)
  .fontFamily('HarmonyHeiTi-Medium')
  .fontSize(14)
  .fontWeight(500)
  .fontColor($r('app.color.font_blue'))
  .margin({ top : 9 , bottom : 9 , left : 8 , right : 8 })
}

@Extend(TextInput) function textInputStyle() {
  .fontFamily('HarmonyHeiTi')
  .fontSize(16)
  .fontColor($r('app.color.font_color_shallow'))
  .fontWeight(400)
  .margin({ top : 8 , bottom : 8 })
  .height(40)
  .width(432)
  .borderRadius(20)
  .backgroundColor($r('app.color.background_shallow_grey'))
  .type(InputType.Password)
}

@Extend(Column) function columnStyle(marginLeftValue: number , marginRightValue: number) {
  .height(36)
  .width(98)
  .borderRadius(18)
  .backgroundColor($r('app.color.background_shallow_grey'))
  .margin({ top : 24 , left : marginLeftValue , right : marginRightValue , bottom : 24 })
}

@Entry
@Component
struct OutLineSample {
  private textInputController: TextInputController = new TextInputController();
  @State isFocus1: boolean = false;
  @State isFocus2: boolean = false;
  @State mTextIsHover1: boolean = false;
  @State mTextIsHover2: boolean = false;
  @State mTextIsHover3: boolean = false;

  build() {
    Column() {
      TitleBar({ title : $r('app.string.prop_outline') })
      Scroll() {
        Column() {
          Column() {
            Row() {
              Text() {
              }
              .textStyle(78)
              .backgroundColor($r('app.color.column_blue'))
              .border({
                width : 4 ,
                radius : { bottomLeft : 20 , topRight : 20 , bottomRight : 10 , topLeft : 10 } ,
                color : $r('app.color.border_color') ,
                style : BorderStyle.Solid
              })
              .outline({
                width : 4 ,
                radius : 20 ,
                color : $r('app.color.outline_color') ,
                style : OutlineStyle.DASHED
              })

              Text() {
              }
              .textStyle(78)
              .backgroundColor($r('app.color.column_blue'))
              .border({
                width : 4 ,
                radius : 20 ,
                color : $r('app.color.border_color') ,
                style : BorderStyle.Solid
              })
              .outline({
                width : 4 ,
                radius : 20 ,
                color : $r('app.color.outline_color') ,
                style : OutlineStyle.SOLID
              })
            }
            .margin({ top : 30 })
            .width('100%')
            .justifyContent(FlexAlign.SpaceAround)

            Row() {
              Text($r('app.string.outline_text'))
                .fontTextStyle()
                .fontColor($r('app.color.font_color_black'))
              Text($r('app.string.outline_effect'))
                .fontTextStyle()
                .fontColor($r('app.color.font_color_black'))
            }
            .margin({ top : 10 , bottom : 10 })
            .width('100%')
            .justifyContent(FlexAlign.SpaceAround)

            Row() {
              Text() {
              }
              .textStyle(78)
              .backgroundColor($r('app.color.column_blue'))
              .border({
                width : 4 ,
                radius : 20 ,
                color : $r('app.color.border_color') ,
                style : BorderStyle.Solid
              })
              .outline({
                width : 4 ,
                radius : 40 ,
                color : $r('app.color.outline_color') ,
                style : OutlineStyle.SOLID
              })

              Text() {
              }
              .textStyle(78)
              .backgroundColor($r('app.color.column_blue'))
              .border({
                width : 4 ,
                radius : 39 ,
                color : $r('app.color.border_color') ,
                style : BorderStyle.Solid
              })
              .outline({
                width : 4 ,
                radius : 39 ,
                color : $r('app.color.outline_color') ,
                style : OutlineStyle.SOLID
              })
            }
            .margin({ top : 30 })
            .width('100%')
            .justifyContent(FlexAlign.SpaceAround)

            Row() {
              Text($r('app.string.outline_effect'))
                .fontTextStyle()
                .fontColor($r('app.color.font_color_black'))
              Text($r('app.string.outline_effect'))
                .fontTextStyle()
                .fontColor($r('app.color.font_color_black'))
            }
            .margin({ top : 10 , bottom : 10 })
            .width('100%')
            .justifyContent(FlexAlign.SpaceAround)

            Row() {
              Text() {
              }
              .textStyle(130)
              .backgroundColor($r('app.color.column_blue'))
              .border({
                width : 4 ,
                radius : 20 ,
                color : $r('app.color.border_color') ,
                style : BorderStyle.Solid
              })
              .outline({
                width : 4 ,
                radius : 0 ,
                color : $r('app.color.outline_color') ,
                style : OutlineStyle.SOLID
              })

              Text() {
              }
              .textStyle(130)
              .backgroundColor(Color.White)
            }
            .margin({ top : 30 })
            .width('100%')
            .justifyContent(FlexAlign.SpaceAround)

            Row() {
              Text($r('app.string.outline_effect'))
                .fontTextStyle()
                .fontColor($r('app.color.font_color_black'))
              Text($r('app.string.outline_effect'))
                .fontTextStyle()
                .fontColor(Color.White)
            }
            .margin({ top : 10 })
            .width('100%')
            .justifyContent(FlexAlign.SpaceAround)
          }
          .height(456)
          .width(456)
          .borderRadius(24)
          .backgroundColor(Color.White)
          .margin({ top : 12 , left : 12 , right : 12 , bottom : 4 })

          Column() {
            Column() {
              TextInput({ placeholder : 'Hint' , controller : this.textInputController })
                .textInputStyle()
                .outline(this.isFocus1 ?
                  {
                    width : 3 ,
                    radius : 20 ,
                    color : $r('app.color.border_color') ,
                    style : OutlineStyle.SOLID
                  } :
                  {
                    width : 0 ,
                    radius : 20
                  })
                .onFocus(() => {
                  this.isFocus1 = true;
                })
                .onBlur(() => {
                  this.isFocus1 = false;
                })
                .id('testInput1')
            }
            .height(56)
            .width(432)
            .margin({ top : 4 })

            Column() {
              TextInput({ placeholder : 'Hint' , controller : this.textInputController })
                .textInputStyle()
                .outline(this.isFocus2 ?
                  {
                    width : 3 ,
                    radius : 20 ,
                    color : $r('app.color.border_color') ,
                    style : OutlineStyle.SOLID
                  } :
                  {
                    width : 0 ,
                    radius : 20
                  })
                .onFocus(() => {
                  this.isFocus2 = true;
                })
                .onBlur(() => {
                  this.isFocus2 = false;
                })
                .id('testInput2')
            }
            .height(56)
            .width(432)
            .margin({ bottom : 4 })
          }
          .height(120)
          .width(456)
          .borderRadius(24)
          .backgroundColor(Color.White)
          .margin({ top : 4 , left : 12 , right : 12 , bottom : 4 })

          Row() {
            Column() {
              Text($r('app.string.outline_button'))
                .buttonTextStyle()
            }
            .columnStyle(48,16)
            .outline(this.mTextIsHover1 ?
              {
                width : 4 ,
                radius : 25 ,
                color : $r('app.color.border_color') ,
                style : OutlineStyle.SOLID
              } :
              {
                width : 0 ,
                radius : 25
              })
            .onHover((isHover) => {
              this.mTextIsHover1 = isHover;
            })
            .id('column1')

            Column() {
              Text($r('app.string.outline_button'))
                .buttonTextStyle()
            }
            .columnStyle(16,16)
            .outline(this.mTextIsHover2 ?
              {
                width : 4 ,
                radius : 25 ,
                color : $r('app.color.border_color') ,
                style : OutlineStyle.SOLID
              } :
              {
                width : 0 ,
                radius : 25
              })
            .onHover((isHover) => {
              this.mTextIsHover2 = isHover;
            })
            .id('column2')

            Column() {
              Text($r('app.string.outline_button'))
                .buttonTextStyle()
            }
            .columnStyle(16,48)
            .outline(this.mTextIsHover3 ?
              {
                width : 4 ,
                radius : 25 ,
                color : $r('app.color.border_color') ,
                style : OutlineStyle.SOLID
              } :
              {
                width : 0 ,
                radius : 25
              })
            .onHover((isHover) => {
              this.mTextIsHover3 = isHover;
            })
            .id('column3')
          }
          .height(76)
          .width(456)
          .borderRadius(24)
          .backgroundColor(Color.White)
          .margin({ top : 4 , left : 12 , right : 12 })
        }
        .constraintSize({ minHeight : '100%' }) // Let the minHeight of the component cover screen at least
      }
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}