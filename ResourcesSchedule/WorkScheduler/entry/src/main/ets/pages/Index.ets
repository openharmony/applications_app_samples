/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import notification from '@ohos.notification'
import { DelayWork } from '@ohos/library'
import { Logger } from '@ohos/notification'

const TAG: string = 'index'

@Entry
@Component
struct Index {
  private work = new DelayWork()

  build() {
    Row() {
      Column() {
        Button($r('app.string.upgrade'))
          .width('60%')
          .height(40)
          .fontSize(30)
          .onClick(() => {
            this.work.startWork('ohos.samples.workscheduler', 'WorkTest')
          })
      }
      .width('100%')
    }
    .height('100%')
  }

  aboutToAppear() {
    Logger.info(TAG, `aboutToAppear start`)
    notification.requestEnableNotification((err) => {
      if (err) {
        Logger.error(TAG, `notification requestEnableNotification err ${JSON.stringify(err)}`)
      }
      Logger.info(TAG, 'requestEnableNotification success')
    })
  }

  aboutToDisappear() {
    this.work.stopWork('ohos.samples.workscheduler', 'WorkTest')
  }
}