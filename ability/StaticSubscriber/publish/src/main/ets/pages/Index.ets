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
import Logger from '../../../../../entry/src/main/ets/model/Logger'

const SEND_DATA:string = 'usual.event.SEND_DATA'
@Entry
@Component
struct Index {
  build() {
    Row() {
      Column() {
        Button() {
          Text($r('app.string.publish'))
            .fontSize(30)
            .fontWeight(FontWeight.Bold)
        }
        .type(ButtonType.Capsule)
        .margin({ top: 20 })
        .backgroundColor('#0D9FFB')
        .width('40%')
        .height('5%')
        .onClick(() => {
          // 公共事件相关信息
          let options = {
            code: 0, // 公共事件的初始代码
            data: getContext(this).resourceManager.getStringSync($r('app.string.publish_data')),
            isOrdered: true // 有序公共事件
          }
          // 发布公共事件回调
          function publishCallback(err) {
            if (err) {
              Logger.error(`publish failed ${JSON.stringify(err)}`)
            } else {
              Logger.info('publish success')
            }
          }
          //发布公共事件
          try {
            CommonEventManager.publish(SEND_DATA, options, publishCallback)
          } catch (err) {
            Logger.error(`publish failed, catch error ${JSON.stringify(err)}`)
          }
        })
      }
      .width('100%')
    }
    .height('100%')
  }
}