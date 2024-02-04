/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import { IntroductionTitle } from '../../../../common/IntroductionTitle';
import ShowToast from '../../../../util/ShowToast';
import { TitleBar } from '../../../../common/TitleBar';

// 最小宽度
const MINWIDTH: number = 64;
// 最大宽度
const MAXWIDTH: number = 100;

@Extend(Row) function rowStyle() {
  .height(50)
  .padding(12)
  .width('100%')
  .borderRadius(24)
  .margin({ top: 12, bottom: 12 })
}

@Extend(Button) function commonButtonStyle() {
  .margin(8)
  .fontSize(16)
  .layoutWeight(1)
  .height(40)
  .padding({ left: 12, right: 12, top: 8, bottom: 8 })
}

@Extend(Text) function textStyle() {
  .fontSize(16)
  .fontFamily('HarmonyHeiTi')
  .fontColor('#182431')
  .fontWeight(400)
  .width('90%')
  .margin({ top: 13, bottom: 14 })
}

@Entry
@Component
struct MenuSample {
  @State menuWidth: number = MINWIDTH;
  @State realMenuWidth: number = 0;
  @State menuDirection: number = Placement.Bottom;
  @State vpText: string = 'vp';

  @Builder MenuBuilder() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text($r('app.string.text_picker_text_banana'))
        .fontSize(16)
        .width('90%')
      Divider().strokeWidth(1).margin(8).color(Color.Brown)
      Text($r('app.string.text_picker_text_orange'))
        .fontSize(16)
        .width('90%')
      Divider().strokeWidth(1).margin(8).color(Color.Brown)
      Text($r('app.string.text_picker_text_grape'))
        .fontSize(16)
        .width('90%')
        .margin({ bottom: 10 })
    }
    .width(200)
  }

  @Builder MenuBuilder2() {
    Flex({ direction: FlexDirection.Column, alignItems: ItemAlign.Center, justifyContent: FlexAlign.Center }) {
      Text($r('app.string.menu_option'))
        .textStyle()
      Text($r('app.string.menu_option'))
        .textStyle()
      Text($r('app.string.menu_option'))
        .textStyle()
      Text($r('app.string.menu_option'))
        .textStyle()
    }
    .width(this.menuWidth)
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.global_menu') })
      Scroll() {
        Column() {
          IntroductionTitle({ introduction: $r('app.string.global_menu_create_way') })
          Row({ space: 16 }) {
            Button($r('app.string.global_menu_click_right'))
              .commonButtonStyle()
              .bindContextMenu(this.MenuBuilder(), ResponseType.RightClick)
              .id('right_clickButton')

            Button($r('app.string.global_menu_long_press'))
              .commonButtonStyle()
              .bindContextMenu(this.MenuBuilder(), ResponseType.LongPress)
              .id('long_pressButton')
          }
          .justifyContent(FlexAlign.Center)
          .rowStyle()
          // 新增 菜单避让规则
          IntroductionTitle({ introduction: $r('app.string.global_menu_avoid_rule') })
          Column() {
            Row() {
              Image($r('app.media.ic_pic1'))
                .draggable(true)
                .id('menu_image1')
                .width(162)
                .height(162)
                .margin({ left: 12, top: 9.5, bottom: 12 })
                .bindContextMenu(this.MenuBuilder2(), ResponseType.LongPress,
                  {
                    placement: this.menuDirection,
                  })
              Blank()
            }
            .width('100%')

            Row() {
              Image($r('app.media.ic_pic2'))
                .draggable(true)
                .id('menu_image2')
                .width(162)
                .height(162)
                .margin({ left: 12, bottom: 12 })
                .bindContextMenu(this.MenuBuilder2(), ResponseType.LongPress,
                  {
                    placement: this.menuDirection,
                  })
              Blank()
            }
            .width('100%')
          }
          .width('100%')

          // 菜单布局
          IntroductionTitle({ introduction: $r('app.string.global_menu_layout') })
          Column() {
            Row() {
              Text($r('app.string.vertical_layout'))
                .margin({ left: 12, top: 17, bottom: 13 })
              Blank()
              // radio单选按钮
              Radio({ value: 'vertical', group: 'radioGroup' })
                .id('menu_vertical')
                .margin({ right: 12, top: 17, bottom: 13 })
                .onChange((isChecked: boolean) => {
                  if (isChecked) {
                    //设置纵向布局属性
                    this.menuDirection = Placement.Bottom;
                  }
                })

            }
            .width('100%')

            Divider()
              .strokeWidth(1)
              .margin(8)
              .color('#182431')
              .opacity(0.05)
            Row() {
              Text($r('app.string.horizontal_layout'))
                .margin({ left: 12, bottom: 17 })
              Blank()
              Radio({ value: 'horizontal', group: 'radioGroup' })
                .id('menu_horizontal')
                .margin({ right: 12, bottom: 17 })
                .onChange((isChecked: boolean) => {
                  if (isChecked) {
                    //设置横向布局属性
                    this.menuDirection = Placement.RightTop;
                  }
                })
            }
            .width('100%')
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(24)
          .margin({ top: 9.5, bottom: 19.5 })

          // 菜单宽度设置
          IntroductionTitle({ introduction: $r('app.string.global_menu_width') })
          Column() {
            Row() {
              Text($r('app.string.menu_width'))
                .margin({ left: 12, top: 18, bottom: 8.5 })
              Blank()
              Text(Math.trunc(this.menuWidth) + this.vpText)
                .margin({ right: 12, top: 18, bottom: 8.5 })
            }
            .width('100%')

            Slider({
              style: SliderStyle.OutSet,
              value: this.menuWidth,
              step: 1,
              min: 0,
              max: MAXWIDTH
            })
              .id('menu_setWidth')
              .showTips(true, this.realMenuWidth.toFixed())
              .margin({ left: 6, right: 6, bottom: 12 })
              .onChange(value => {
                this.realMenuWidth = value;
                if (value < MINWIDTH) {
                  this.menuWidth = MINWIDTH;
                } else {
                  this.menuWidth = value;
                }
              })
          }
          .width('100%')
          .backgroundColor('#FFFFFF')
          .borderRadius(24)
          .margin({ top: 9.5, bottom: 70 })
        }
        .constraintSize({ minHeight: '100%' })
        .padding({ left: 12, right: 12 })
      }
      .id('menu_scroll')
      .onClick(() => {
        // 点击时关闭菜单
        ShowToast.shortToast($r('app.string.global_menu_close'));
        ContextMenu.close();
      })
    }
    .width('100%')
    .backgroundColor($r('app.color.background_shallow_grey'))
  }
}