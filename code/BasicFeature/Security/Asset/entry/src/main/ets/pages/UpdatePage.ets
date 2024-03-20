/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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
import { updateAssetPromise } from '../model/AssetModel';

function isUpdateClickable(reservePassword: string): boolean {
  return reservePassword !== '';
}

@Entry
@Component
struct UpdatePage {
  @State params: Record<string, string> = router.getParams() as Record<string, string>;
  @State user: string = this.params.name as string;
  @State pwd: string = this.params.pwd as string;
  @State label: string = this.params.label as string;
  @State reservePassword: string = this.pwd;
  @State reserveLabel: string = this.label;
  @State eventType: string = ''

  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .height(18)
          .width(20)
          .onClick(() => {
            // 返回到上一页面，相当于pop操作
            router.back();
          })
        Text($r('app.string.update'))
          .fontFamily("HarmonyHeiTi")
          .fontSize(20)
          .fontColor(0x182431)
          .lineHeight(28)
          .fontWeight(700)
          .margin({ left: '5%' })
          .textAlign(TextAlign.Center)
      }.width('86.7%').height(56)

      Column() {
        /* 账号 */
        Row() {
          Text($r('app.string.account'))
            .fontFamily("HarmonyHeiTi")
            .fontSize(16)
            .fontColor(0x182431)
            .lineHeight(22)
            .fontWeight(500)
            .textAlign(TextAlign.Start)
            .padding({ top: '2.3%', bottom: '1.1%' })
        }
        .width('86.7%').height('6.7%')

        /* 用户名输入 */
        Row() {
          Text(this.user)
            .fontFamily("HarmonyHeiTi")
            .fontSize(16)
            .opacity(0.6)
            .fontColor(0x182431)
            .lineHeight(22)
            .fontWeight(400)
            .textAlign(TextAlign.Start)
            .padding({ top: '2.3%', bottom: '1.1%' })
        }
        .width('86.7%').height('6.7%')

        Line()
          .width('86.7%')
          .height('0.5vp')
          .margin({
            left: '12vp',
            right: '12vp'
          })
          .backgroundColor('#0D182431')

        /* 密码 */
        Row() {
          Text("*").fontColor(0xFFE84026)
          Text($r('app.string.secret_or_card_num'))
            .fontFamily("HarmonyHeiTi")
            .fontSize(16)
            .fontColor(0x182431)
            .lineHeight(22)
            .fontWeight(500)
            .padding({ top: '2.3%', bottom: '1.1%' })
        }
        .width('86.7%').height('6.7%')

        /* 密码输入 */
        Row() {
          TextInput({ text: this.pwd })
            .type(InputType.Password)
            .defaultFocus(false)
            .fontColor(0x182431)
            .padding({ top: '1.70%', right: '48.00px', bottom: '1.70%', left: '0' })
            .backgroundColor(Color.Transparent)
            .placeholderFont({ size: 16, weight: 400, family: 'HarmonyHeiTi', style: FontStyle.Normal })
            .onChange((value: string) => {
              this.reservePassword = value;
            })
            .onTouch((event: TouchEvent) => {
              if (event.type === TouchType.Down) {
                this.eventType = 'Down9';
              }
            })
            .margin({ right: -12 })
        }
        .width('86.7%').height('6.7%')

        if (this.eventType === 'Down9') {
          Line()
            .width('86.7%')
            .height('0.5vp')
            .margin({
              left: '12vp',
              right: '12vp'
            })
            .backgroundColor(0x182431)
        } else {
          Line()
            .width('86.7%')
            .height('0.5vp')
            .margin({
              left: '12vp',
              right: '12vp'
            })
            .backgroundColor('#0D182431')
        }

        /* 标签 */
        Row() {
          Text($r('app.string.label'))
            .fontFamily("HarmonyHeiTi")
            .fontSize(16)
            .fontColor(0x182431)
            .lineHeight(22)
            .fontWeight(500)
            .baselineOffset(0)
            .textAlign(TextAlign.Start)
            .padding({ top: '2.3%', bottom: '1.1%' })
        }
        .width('86.7%').height('6.7%')

        /* 标签输入 */
        Row() {
          TextInput({ text: this.label })
            .defaultFocus(false)
            .fontColor(0x182431)
            .padding({ top: '1.70%', right: '48.00px', bottom: '1.70%', left: '0' })
            .backgroundColor(Color.Transparent)
            .id('label_input')
            .placeholderFont({ size: 16, weight: 400, family: 'HarmonyHeiTi', style: FontStyle.Normal })
            .onChange((value: string) => {
              this.reserveLabel = value;
            })
            .onTouch((event: TouchEvent) => {
              if (event.type === TouchType.Down) {
                this.eventType = 'Down10';
              }
            })
        }
        .width('86.7%').height('6.7%')

        if (this.eventType === 'Down10') {
          Line()
            .width('86.7%')
            .height('0.5vp')
            .margin({
              left: '12vp',
              right: '12vp'
            })
            .backgroundColor(0x182431).margin({ bottom: 4 })
        } else {
          Line()
            .width('86.7%')
            .height('0.5vp')
            .margin({
              left: '12vp',
              right: '12vp'
            })
            .backgroundColor('#0D182431').margin({ bottom: 4 })
        }
      }
      .backgroundColor(0xFFFFFF).borderRadius(16)

      Blank()
      Row() {
        /* 底部按钮 */
        Button($r('app.string.update'), { type: ButtonType.Capsule, stateEffect: false })
          .backgroundColor(0x007DFF).fontColor('white')
          .borderRadius(20)
          .width('86.7%')
          .height(40)
          .id('update_button')
          .enabled(isUpdateClickable(this.reservePassword))
          .onClick(() => {
            updateAssetPromise(this.user, this.reservePassword, this.reserveLabel)
          })
      }
      .margin({ bottom: '8.1%' })
    }
    // .margin({ right: 12, left: 12 })
    .width("100%").height('100%').backgroundColor(0xf1f3f5)
  }
}