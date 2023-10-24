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
import promptAction from '@ohos.promptAction'
import Logger from '../../../../../entry/src/main/ets/model/Logger'
import Base from '@ohos.base'

const SEND_DATA:string = 'usual.event.SEND_DATA'

@Entry
@Component
struct Index {
  build() {
    Row() {
      Column() {
        Button() {
          Text($r('app.string.publish'))
            .fontSize(22)
            .fontColor($r('app.color.white'))
        }
        .type(ButtonType.Capsule)
        .margin({ top: 20 })
        .backgroundColor('#007DFF')
        .width('80%')
        .height('5%')
        .onClick(() => {
          // 公共事件相关信息
          let options: CommonEventManager.CommonEventPublishData = {
            code: 0, // 公共事件的初始代码
            bundleName: '',
            data: getContext(this).resourceManager.getStringSync($r('app.string.publish_data')),
            isOrdered: true // 有序公共事件
          }

          // 发布公共事件回调
          let publishCallback = (err: Base.BusinessError) => {
            if (err) {
              Logger.error(`publish failed ${JSON.stringify(err)}`);
            } else {
              try {
                promptAction.showToast({
                  message: $r('app.string.publish_success'),
                  duration: 2000,
                });
              } catch (error) {
                Logger.error(`showToast args error code is ${(error as Base.BusinessError).code}, message is ${(error as Base.BusinessError).message}`);
              }
              Logger.info('publish success');
            }
          }

          // 发布公共事件
          try {
            CommonEventManager.publish(SEND_DATA, options, publishCallback);
          } catch (err) {
            Logger.error(`publish failed, catch error ${JSON.stringify(err)}`);
          }
        })
      }
      .width('100%')
    }
    .height('100%')
    .backgroundColor($r('app.color.background_light_gray'))
    .id('btnPublish')
  }
}