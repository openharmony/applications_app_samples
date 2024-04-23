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
import promptAction from '@ohos.promptAction';
import { BusinessError } from '@ohos.base';
import Logger from '../../../../util/Logger';

// 自定义半模态页面高度
const SIZE: number = 200;

@Extend(Text) function textStyle() {
  .fontFamily('HarmonyHeiTi-Medium')
  .fontSize(16)
  .fontColor('#182431')
  .textAlign(TextAlign.Start)
  .lineHeight(22)
  .fontWeight(500)
}

interface SheetSizes {
  medium: boolean;
  large: boolean;
  size200: boolean;
}

@Entry
@Component
struct BindSheetSample {
  @State isShow: boolean = false
  @State showDragBar: boolean = true;
  @State enableOutsideInteractive: boolean = true;
  @State popStyle: SheetType.CENTER | SheetType.POPUP = SheetType.CENTER;
  @State showClose: boolean = true;
  @State blurStyle: BlurStyle = BlurStyle.NONE;
  @State detentsArray: number[] = [];
  @State detents: [(SheetSize | Length), (SheetSize | Length)?, (SheetSize | Length)?] = [SheetSize.MEDIUM, SIZE];
  @State mediumSelected: boolean = true;
  @State largeSelected: boolean = false;
  @State size200Selected: boolean = true;
  @State mediumText: string = 'Medium';
  @State largeText: string = 'Large';
  @State size200Text: string = '200';
  private sheetSizes: SheetSizes = { medium: true, large: false, size200: true };

  @Builder myBuilder() {
    Column() {
    }
    .width('100%')
    .height('100%')
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.global_bindSheet_menu') })
        .backgroundColor('#F1F3F5')
      Scroll() {
        Column() {
          Row() {
            Column() {
              Text($r('app.string.global_bindSheet_text_allow_interaction'))
                .fontSize(16)
                .fontColor('#000000')
                .fontWeight(500)
                .fontFamily('HarmonyHeiTi-Medium')
                .textAlign(TextAlign.Start)
                .width('70%')
              Text($r('app.string.global_bindSheet_text_desc'))
                .fontSize(14)
                .fontColor('#000000')
                .fontWeight(400)
                .fontFamily('HarmonyHeiTi')
                .textAlign(TextAlign.Start)
                .width('70%')
            }
            .margin({ left: 12, top: 6, bottom: 6 })
            .align(Alignment.Start)

            Blank()

            Toggle({ type: ToggleType.Switch, isOn: this.enableOutsideInteractive })
              .id('enable_interactive')
              .margin({ right: 12, top: 8, bottom: 8 })
              .onChange((isOn: boolean) => {
                this.enableOutsideInteractive = isOn;
              })
          }
          .backgroundColor('#ffffff')
          .borderRadius(24)
          .width('100%')

          Text($r('app.string.pop_height'))
            .lineHeight(19)
            .fontWeight(500)
            .fontFamily('HarmonyHeiTi-Medium')
            .fontSize(14)
            .width('100%')
            .direction(Direction.Ltr)
            .margin({ left: 26, top: 19.5, bottom: 9.5 })
            .fontColor($r('app.color.font_color_shallow'))

          Column() {
            Row() {
              Text(this.mediumText)
                .textStyle()
                .margin({ left: 12, top: 8, bottom: 8 })
              Blank()
              Checkbox()
                .select(this.mediumSelected)
                .borderRadius(4)
                .margin({ right: 12, top: 8, bottom: 8 })
                .onChange((value: boolean) => {
                  if (value) {
                    this.sheetSizes.medium = true;
                  } else {
                    this.sheetSizes.medium = false;
                  }
                })
            }
            .width('100%')
            .margin({ top: 4 })

            Divider()
              .strokeWidth(1)
              .margin(8)
              .color('#182431')
              .opacity(0.05)

            Row() {
              Text(this.largeText)
                .textStyle()
                .margin({ left: 12, top: 8, bottom: 8 })
              Blank()
              Checkbox()
                .select(this.largeSelected)
                .borderRadius(4)
                .margin({ right: 12, top: 8, bottom: 8 })
                .onChange((value: boolean) => {
                  if (value) {
                    this.sheetSizes.large = true;
                  } else {
                    this.sheetSizes.large = false;
                  }
                })
            }
            .width('100%')
            .margin({ top: 4 })

            Divider()
              .strokeWidth(1)
              .margin(8)
              .color('#182431')
              .opacity(0.05)

            Row() {
              Text(this.size200Text)
                .textStyle()
                .margin({ left: 12, top: 8, bottom: 8 })
              Blank()
              Checkbox()
                .select(this.size200Selected)
                .borderRadius(4)
                .margin({ right: 12, top: 8, bottom: 8 })
                .onChange((value: boolean) => {
                  if (value) {
                    this.sheetSizes.size200 = true;
                  } else {
                    this.sheetSizes.size200 = false;
                  }
                })
            }
            .width('100%')
            .margin({ top: 4, bottom: 4 })
          }
          .backgroundColor('#ffffff')
          .borderRadius(24)
          .margin({ top: 12 })
          .width('100%')

          Row() {
            Text($r('app.string.bindSheet_popup_style'))
              .textStyle()
              .margin({ left: 12, top: 8, bottom: 8 })
            Blank()
            Select([{ value: $r('app.string.bindSheet_default_popup') },
              { value: $r('app.string.bindSheet_centered_popup') },
              { value: $r('app.string.bindSheet_popup_appears') }])
              .id('popup_style')
              .selected(0)
              .value($r('app.string.bindSheet_default_popup'))
              .margin({ right: 12, top: 8, bottom: 8 })
              .fontColor('#182431')
              .onSelect((index: number) => {
                if (index === 0) {
                  this.popStyle = SheetType.CENTER;
                } else if (index === 1) {
                  this.popStyle = SheetType.CENTER;
                } else {
                  this.popStyle = SheetType.POPUP;
                }
              })
          }
          .backgroundColor('#ffffff')
          .borderRadius(24)
          .margin({ top: 20 })
          .width('100%')

          Row() {
            Text($r('app.string.bindSheet_icon'))
              .textStyle()
              .margin({ left: 12, top: 17, bottom: 17 })
            Blank()
            Toggle({ type: ToggleType.Switch, isOn: this.showClose })
              .margin({ right: 12, top: 17, bottom: 17 })
              .onChange((isOn: boolean) => {
                if (isOn) {
                  this.showClose = true;
                } else {
                  this.showClose = false;
                }
              })
          }
          .backgroundColor('#ffffff')
          .borderRadius(24)
          .margin({ top: 20 })
          .width('100%')

          Row() {
            Text($r('app.string.bindSheet_blurred_background_texture'))
              .textStyle()
              .margin({ left: 12, top: 17, bottom: 17 })
            Blank()
            Toggle({ type: ToggleType.Switch, isOn: false })
              .id('bindSheet_blur')
              .margin({ right: 12, top: 17, bottom: 17 })
              .onChange((isOn: boolean) => {
                if (isOn) {
                  this.blurStyle = BlurStyle.Thick;
                } else {
                  this.blurStyle = BlurStyle.NONE;
                }
              })
          }
          .backgroundColor('#ffffff')
          .borderRadius(24)
          .margin({ top: 20 })
          .width('100%')

          Blank()
          Button($r('app.string.bindSheet_popup_modal_interface'),
            { type: ButtonType.Normal, stateEffect: true })
            .id('bindSheet_button')
            .borderRadius(24)
            .width('86.7%')
            .height('5.1%')
            .margin({ left: 24, right: 24, bottom: 72 })
            .bindSheet($$this.isShow, this.myBuilder(),
              {
                enableOutsideInteractive: this.enableOutsideInteractive,
                dragBar: this.showDragBar,
                backgroundColor: Color.Gray,
                detents: this.detents,
                blurStyle: this.blurStyle,
                showClose: this.showClose,
                title: { title: "Title" },
                preferType: this.popStyle,
                shouldDismiss: ((sheetDismiss: SheetDismiss) => {
                  // 弹出弹窗
                  try {
                    promptAction.showDialog({
                      message: $r('app.string.bindSheet_close_modal'),
                      buttons: [
                        {
                          text: $r('app.string.bindSheet_close_cancel'),
                          color: '#0A59F7'
                        },
                        {
                          text: $r('app.string.bindSheet_close_confirm'),
                          color: '#0A59F7'
                        }
                      ]
                    }, (err, data) => {
                      if (err) {
                        Logger.error('showDialog err: ' + err);
                        return;
                      }
                      if (data.index === 1) {
                        this.detentsArray.length = 0;
                        this.detents = [SheetSize.MEDIUM, SIZE];
                        sheetDismiss.dismiss();
                      }
                    });
                  } catch (error) {
                    let message = (error as BusinessError).message;
                    let code = (error as BusinessError).code;
                    Logger.error('showDialog args error code is' + code, 'message is' + message);
                  };
                })
              })
            .onClick(() => {
              this.isShow = true
              if (this.sheetSizes.medium) {
                this.detentsArray.push(SheetSize.MEDIUM);
              }
              if (this.sheetSizes.large) {
                this.detentsArray.push(SheetSize.LARGE);
              }
              if (this.sheetSizes.size200) {
                this.detentsArray.push(SIZE);
              }
              for (let i = 0; i < this.detentsArray.length; i++) {
                this.detents[i] = this.detentsArray[i];
              }
            })
        }
        .backgroundColor('#f1f3f5')
        .constraintSize({ minHeight: '100%' }) // Let the minHeight of the component cover screen at least
        .height('100%')
      }
      .backgroundColor('#f1f3f5')
      .height('100%')
      .padding({ left: 12, right: 12, bottom: 12, top: 12 })
    }
  }
}