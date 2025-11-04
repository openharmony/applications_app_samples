/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import Logger from '../util/Logger'
import { backgroundTaskManager } from '@kit.BackgroundTasksKit'
import { BusinessError } from '@kit.BasicServicesKit'

const TAG: string = 'TransientTaskDialog'

@Component
export struct TransientTaskDialog {
  @State requestId : number = 0;
  @State delayTime : number = 0;
  @State time : number = 0;

  requestSuspendDelay() {
    let myReason = 'test requestSuspendDelay';   // 申请原因
    try {
      let delayInfo = backgroundTaskManager.requestSuspendDelay(myReason, () => {
        // 回调函数。应用申请的短时任务即将超时，通过此函数回调应用，执行一些清理和标注工作，并取消短时任务
        Logger.info(TAG, 'suspend delay task will timeout');
      })
      this.requestId = delayInfo.requestId;
      this.delayTime = delayInfo.actualDelayTime;
      Logger.info(TAG, `Succeeded in requestSuspendDelay. requestId is :${this.requestId}, delayTime is :${this.delayTime}`);
    } catch (error) {
      Logger.error(TAG, `Operation requestSuspendDelay failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }

  getRemainingDelayTime() {
    try {
      backgroundTaskManager.getRemainingDelayTime(this.requestId).then((res: number) => {
        Logger.info(TAG, `Succeeded in getting remaining delay time. delay time is :${res}`);
      }).catch((err: BusinessError) => {
        Logger.error(TAG, `Failed to get remaining delay time. Code: ${err.code}, message: ${err.message}`);
      })
    } catch (error) {
      Logger.error(TAG, `Operation getRemainingDelayTime failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }

  cancelSuspendDelay() {
    try {
      backgroundTaskManager.cancelSuspendDelay(this.requestId);
      Logger.info(TAG, 'Succeeded in cancelSuspendDelay');
    } catch (error) {
      Logger.error(TAG, `Operation cancelSuspendDelay failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }

  build() {
    Column() {
      Row(){
        Text($r('app.string.transient_task_id')).fontSize(20)
        Text(""+this.requestId).fontSize(20).id('transient_task_id')
      }
      Button($r('app.string.request_suspend_delay'))
        .id('request_suspend_delay')
        .fontSize(20)
        .margin({ top: 10, bottom: 10 })
        .type(ButtonType.Capsule)
        .backgroundColor($r('app.color.background'))
        .size({ width: '50%', height: '5%' })
        .onClick(() => {
          this.requestSuspendDelay()
        })
      Button($r('app.string.get_remaining_delay_time'))
        .id('get_remaining_delay_time')
        .fontSize(20)
        .margin({ top: 10, bottom: 10 })
        .type(ButtonType.Capsule)
        .backgroundColor($r('app.color.background'))
        .size({ width: '50%', height: '5%' })
        .onClick(() => {
          this.getRemainingDelayTime()
        })
      Button($r('app.string.cancel_suspend_delay'))
        .id('cancel_suspend_delay')
        .fontSize(20)
        .margin({ top: 10, bottom: 10 })
        .type(ButtonType.Capsule)
        .backgroundColor($r('app.color.background'))
        .size({ width: '50%', height: '5%' })
        .onClick(() => {
          this.cancelSuspendDelay()
        })
    }.width('100%')
    .margin({ top: 5 })
  }
}