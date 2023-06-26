/*
 * Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

const TAG: string = '[SelectUserDialog]';

@CustomDialog
export struct SelectUserDialog {
  controller: CustomDialogController;
  private title: Resource = $r('app.string.user_select');
  @Link result: number; // 当前选择项的用户id
  @State selected: number = 1; // 最终返回的用户id

  build() {
    Column() {

      Text(this.title)
        .fontSize(20)
        .fontColor($r('app.color.COLOR_E6000000'))
        .fontFamily($r('app.string.font_family'))
        .width('90%')
        .textAlign(TextAlign.Start)
        .margin({ top: 14, bottom: 14 })

      Column() {
        Row() {
          Text($r('app.string.fengzi'))
            .fontSize(16)
            .fontColor($r('app.color.COLOR_000000'))
            .fontFamily($r('app.string.font_family_regular'))
            .textAlign(TextAlign.Center)
          Blank()
          Radio({ group: 'user', value: '' })
            .width(24)
            .height(24)
            .checked(this.selected == 1)
            .onChange(bool => {
              if (bool) {
                this.selected = 1;
              }
            })
        }
        .width('100%')
        .height(56)
        .alignItems(VerticalAlign.Center)
        .onClick(e => {
          this.selected = 1;
        })

        Divider()
          .vertical(false)
          .strokeWidth(1)
          .color($r('app.color.COLOR_33000000'))
          .margin({ top: 10 })

        Row() {
          Text($r('app.string.wenzi'))
            .fontSize(16)
            .fontColor($r('app.color.COLOR_000000'))
            .fontFamily($r('app.string.font_family_regular'))
            .textAlign(TextAlign.Center)
          Blank()
          Radio({ group: 'user', value: '' })
            .width(24)
            .height(24)
            .checked(this.selected == 2)
            .onChange(bool => {
              if (bool) {
                this.selected = 2;
              }
            })
        }
        .width('100%')
        .height(56)
        .alignItems(VerticalAlign.Center)
        .onClick(e => {
          this.selected = 2;
        })
      }
      .width('90%')

      Row() {
        Text($r('app.string.cancel'))
          .fontSize(16)
          .fontColor($r('app.color.COLOR_007DFF'))
          .fontWeight(FontWeight.Medium)
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.controller.close();
          })

        Divider()
          .vertical(true)
          .strokeWidth(1)
          .color($r('app.color.COLOR_33000000'))
          .height(20)

        Text($r('app.string.confirm'))
          .id('usersConfirm')
          .fontSize(16)
          .fontColor($r('app.color.COLOR_007DFF'))
          .layoutWeight(1)
          .textAlign(TextAlign.Center)
          .onClick(() => {
            this.result = this.selected;
            this.controller.close();
          })
      }
      .alignItems(VerticalAlign.Center)
      .height(40)
      .width('100%')
    }
    .alignItems(HorizontalAlign.Center)
    .width('90%')
    .borderRadius(24)
    .backgroundColor(Color.White)
  }
}