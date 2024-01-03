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

import autoFillManager from '@ohos.app.ability.autoFillManager';
import { UIContext } from '@ohos.arkui.UIContext';
import router from '@ohos.router';
import common from '@ohos.app.ability.common';
import Prompt from '@system.prompt';
import Logger from '../log/Logger';

let options: router.RouterOptions = {
  url: 'autofillpages/LoginSuccessPage'
}

@Entry
@Component
struct RegisterPage {
  @State registerBtnColor: Resource = $r('app.color.enableColor');
  @State codeNumber: string = "";
  @State isShowLoginBtn: Boolean = false;
  private registerSuccess: string = "";
  private context = getContext(this) as common.UIAbilityContext;

  aboutToAppear() {
    this.context.resourceManager.getStringValue($r('app.string.registerSuccess')).then((value) => {
      this.registerSuccess = value.toString();
    })
  }

  @Builder MyBuilderFunction() {
    Text($r('app.string.getCodeNumber'))
      .borderRadius(20)
      .fontColor($r('app.color.cancelBtnColor'))
      .fontWeight(500)
      .fontFamily('HarmonyHeiTi-Medium')
      .backgroundColor($r('app.color.cancelBackColor'))
      .width('33.3%')
      .height('80%')
      .lineHeight(25)
      .textAlign(TextAlign.Center)
      .fontSize(16)
      .margin({ left: '65%' })
      .onClick(() => {
        this.codeNumber = "565789"
      })
  }

  build() {
    Column() {
      Flex({ justifyContent: FlexAlign.Center, alignItems: ItemAlign.Center }) {
        Text($r('app.string.Welcome'))
          .fontSize(24)
          .fontWeight(500)
          .fontFamily('HarmonyHeiTi-Medium')
          .fontColor($r('app.color.user'))
      }.margin({ top: '32.3%' }).width('35%').height('4.1%')

      List() {
        ListItemGroup({ style: ListItemGroupStyle.CARD }) {
          ListItem({ style: ListItemStyle.CARD }) {
            TextInput({ placeholder: $r('app.string.phoneNumber') })
              .type(InputType.PhoneNumber)
              .fontFamily('HarmonyHeiTi')
              .fontColor($r('app.color.user'))
              .fontWeight(400)
              .fontSize(16)
              .height("100%")
              .backgroundColor($r('app.color.controlBackColor'))
              .onChange((value: string) => {
                if (value) {
                  this.registerBtnColor = $r('app.color.cancelBtnColor');
                } else {
                  this.registerBtnColor = $r('app.color.enableColor');
                }
              })
          }.padding(0)

          // password container
          ListItem({ style: ListItemStyle.CARD }) {
            TextInput({ placeholder: $r('app.string.codeNumber'), text: this.codeNumber })
              .fontFamily('HarmonyHeiTi')
              .fontColor($r('app.color.user'))
              .fontWeight(400)
              .height("100%")
              .fontSize(16)
              .backgroundColor($r('app.color.controlBackColor'))
              .onChange((value: string) => {
                this.codeNumber = value;
                if (value) {
                  this.registerBtnColor = $r('app.color.cancelBtnColor');
                } else {
                  this.registerBtnColor = $r('app.color.enableColor');
                }
              })
            this.MyBuilderFunction()
          }
          .margin({ top: 2 })
          .padding(0)

          // newPassword container
          ListItem({ style: ListItemStyle.CARD }) {
            TextInput({ placeholder: $r('app.string.create_password') })
              .type(InputType.NEW_PASSWORD)
              .backgroundColor($r('app.color.controlBackColor'))
              .fontFamily('HarmonyHeiTi')
              .fontColor($r('app.color.user'))
              .fontWeight(400)
              .fontSize(16)
              .height("100%")
              .enableAutoFill(true)
              .id("newPassWord")
              .onChange((value: string) => {
                if (value) {
                  this.registerBtnColor = $r('app.color.cancelBtnColor');
                } else {
                  this.registerBtnColor = $r('app.color.enableColor');
                }
              })
          }.padding(0).margin({ top: 2 })
        }.divider({ strokeWidth: 0.5, color: $r('app.color.pageBackColor'), startMargin: 15, endMargin: 15 })
      }
      .borderRadius(24)
      .width('93.3%')
      .height('22%')
      .margin({ top: '8.6%' })

      Flex({ justifyContent: FlexAlign.Center, alignContent: FlexAlign.SpaceBetween }) {
        if (this.isShowLoginBtn) {
          Button($r('app.string.login'))
            .width('86.7%')
            .height('5.1%')
            .fontSize(16)
            .fontFamily('HarmonyHeiTi-Medium')
            .fontColor($r('app.color.controlBackColor'))
            .fontWeight(500)
            .backgroundColor(this.registerBtnColor)
            .borderRadius(20)
            .id('login')
            .onClick(() => {
              router.pushUrl(options, (err, data) => {
                Logger.info('page jump to LoginSuccessPage page',
                  JSON.stringify(err), JSON.stringify(data));
              })
            })
        } else {
          Button($r('app.string.register_now'))
            .width('86.7%')
            .height('5.1%')
            .fontSize(16)
            .fontFamily('HarmonyHeiTi-Medium')
            .fontColor($r('app.color.controlBackColor'))
            .fontWeight(500)
            .backgroundColor(this.registerBtnColor)
            .borderRadius(20)
            .id('registerNowBtn')
            .onClick(() => {
              this.isShowLoginBtn = true;
              SaveFunc();
              Prompt.showToast({
                message: this.registerSuccess,
                duration: 2000,
              })
            })
        }
      }.margin({ top: '6.3%' })
    }.backgroundColor($r('app.color.pageBackColor')).height('100%')
  }
}

function SaveFunc() {
  Logger.info('send save request');
  let context = AppStorage.get<UIContext>('uiContext');
  Logger.info('UIContext: ', JSON.stringify(context));
  autoFillManager.requestAutoSave(context, {
    onSuccess: () => {
      Logger.info('save request on success');
    },
    onFailure: () => {
      Logger.info('save request on failure');
    }
  });
}