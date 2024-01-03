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

import router from '@ohos.router';
import Logger from '../log/Logger';

let options: router.RouterOptions = {
  url: 'autofillpages/LoginSuccessPage'
}
let registerOptions: router.RouterOptions = {
  url: 'autofillpages/RegisterPage'
}

@Entry
@Component
struct Index {
  @State loginBtnColor: Resource = $r('app.color.enableColor');

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text($r('app.string.Welcome'))
          .fontSize(24)
          .fontWeight(500)
          .fontFamily('HarmonyHeiTi-Medium')
          .fontColor($r('app.color.user'))
      }.margin({ top: '32.3%' }).width('35%').height('4.1%')

      // username container
      List() {
        ListItemGroup({ style: ListItemGroupStyle.CARD }) {
          ListItem({ style: ListItemStyle.CARD }) {
            TextInput({ placeholder: $r('app.string.account_number') })
              .type(InputType.USER_NAME)
              .fontFamily('HarmonyHeiTi')
              .fontColor($r('app.color.user'))
              .fontWeight(400)
              .fontSize(16)
              .height("100%")
              .id('userName')
              .backgroundColor($r('app.color.controlBackColor'))
              .onChange((value: string) => {
                if (value) {
                  this.loginBtnColor = $r('app.color.cancelBtnColor');
                } else {
                  this.loginBtnColor = $r('app.color.enableColor');
                }
              })
              .enableAutoFill(true)
          }.padding(0)

          // password container
          ListItem({ style: ListItemStyle.CARD }) {
            TextInput({ placeholder: $r('app.string.password_number') })
              .type(InputType.Password)
              .fontFamily('HarmonyHeiTi')
              .fontColor($r('app.color.user'))
              .fontWeight(400)
              .fontSize(16)
              .height("100%")
              .backgroundColor($r('app.color.controlBackColor'))
              .id('passWord')
              .onChange((value: string) => {
                if (value) {
                  this.loginBtnColor = $r('app.color.cancelBtnColor');
                } else {
                  this.loginBtnColor = $r('app.color.enableColor');
                }
              })
              .enableAutoFill(true)
          }.padding(0)
        }
        .backgroundColor($r('app.color.controlBackColor'))
        .divider({ strokeWidth: 0.5, color: $r('app.color.pageBackColor'), startMargin: 15, endMargin: 15 })
      }
      .borderRadius(24)
      .width('93.3%')
      .height('16%')
      .margin({ top: '8.6%' })

      Flex({ justifyContent: FlexAlign.Start, alignContent: FlexAlign.Start }) {
        Text($r('app.string.no_account'))
          .fontColor($r('app.color.NoAccountColor'))
          .fontWeight(400)
          .fontSize(14)
          .fontFamily('HarmonyHeiTi')
          .lineHeight(16)
        Text($r('app.string.register'))
          .fontFamily('HarmonyHeiTi-Medium')
          .fontSize(14)
          .fontColor($r('app.color.cancelBtnColor'))
          .lineHeight(16)
          .fontWeight(500)
          .id('register')
          .onClick(() => {
            router.pushUrl(registerOptions, (err, data) => {
              Logger.info('page jump to registerPage',
                JSON.stringify(err), JSON.stringify(data));
            })
          })
      }.margin({ left: '6.7%' })

      Flex({ justifyContent: FlexAlign.Center, alignContent: FlexAlign.SpaceBetween }) {
        Button($r('app.string.login'))
          .fontSize(16)
          .fontFamily('HarmonyHeiTi-Medium')
          .fontColor($r('app.color.controlBackColor'))
          .fontWeight(500)
          .backgroundColor(this.loginBtnColor)
          .borderRadius(20)
          .height('5.1%')
          .width('86.7%')
          .onClick(() => {
            router.pushUrl(options, (err, data) => {
              Logger.info('page jump to LoginSuccessPage page',
                JSON.stringify(err), JSON.stringify(data));
            })
          })
      }.margin({ top: '8.1%' })
    }.backgroundColor($r('app.color.pageBackColor')).height('100%')
  }
}

