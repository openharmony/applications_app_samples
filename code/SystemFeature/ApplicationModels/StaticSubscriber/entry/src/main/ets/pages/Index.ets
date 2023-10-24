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
import CommonEventManager from '@ohos.commonEventManager'
import Logger from '../model/Logger'
import promptAction from '@ohos.promptAction'
import Base from '@ohos.base'

@Entry
@Component
struct Index {
  @State isStaticSubscribeEnable: boolean = false

  @Styles toggleStyle(){
    .width(52)
    .height(26)
    .margin({ right: 12 })
  }

  build() {
    Row() {
      Column() {
        Button() {
          Text($r('app.string.static_subscribe_enable'))
            .fontSize(22)
            .fontColor($r('app.color.white'))
        }
        .type(ButtonType.Capsule)
        .margin({ top: 20 })
        .backgroundColor('#007DFF')
        .id('btnEnable')
        .width('80%')
        .height('5%')
        .onClick(() => {
          CommonEventManager.setStaticSubscriberState(true).then(() => {
            try {
              promptAction.showToast({
                message: $r('app.string.static_subscribe_enabled'),
                duration: 2000,
              });
            } catch (error) {
              Logger.error(`showToast args error code is ${(error as Base.BusinessError).code}, message is ${(error as Base.BusinessError).message}`);
            }
            Logger.info(`Set static subscriber state success, state is ${true}`);
          }).catch((err: Base.BusinessError) => {
            Logger.info(`Set static subscriber state failed, errCode: ${err.code}, errMes: ${err.message}`);
          })
        })

        Button() {
          Text($r('app.string.static_subscribe_disable'))
            .fontSize(22)
            .fontColor($r('app.color.white'))
        }
        .type(ButtonType.Capsule)
        .margin({ top: 20 })
        .backgroundColor('#007DFF')
        .id('btnDisable')
        .width('80%')
        .height('5%')
        .onClick(() => {
          CommonEventManager.setStaticSubscriberState(false).then(() => {
            try {
              promptAction.showToast({
                message: $r('app.string.static_subscribe_disabled'),
                duration: 2000,
              });
            } catch (error) {
              Logger.error(`showToast args error code is ${(error as Base.BusinessError).code}, message is ${(error as Base.BusinessError).message}`);
            }
            Logger.info(`Set static subscriber state success, state is ${true}`);
          }).catch((err: Base.BusinessError) => {
            Logger.info(`Set static subscriber state failed, errCode: ${err.code}, errMes: ${err.message}`);
          })
        })
      }
      .width('100%')
    }
    .height('100%')
    .backgroundColor($r('app.color.background_light_gray'))
  }
}