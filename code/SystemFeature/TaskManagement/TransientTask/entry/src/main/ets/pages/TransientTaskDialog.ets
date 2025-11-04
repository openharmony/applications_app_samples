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

import { backgroundTaskManager } from '@kit.BackgroundTasksKit'
import { BusinessError } from '@kit.BasicServicesKit'

@Component
export struct TransientTaskDialog {
  // [Start request_suspend_delay]
  @State requestId : number = 0;  // 申请短时任务ID
  @State delayTime : number = 0;  // 本次申请短时任务的剩余时间

  requestSuspendDelay() {
    let myReason = 'test requestSuspendDelay';   // 申请原因
    try {
      let delayInfo = backgroundTaskManager.requestSuspendDelay(myReason, () => {
        // 回调函数。应用申请的短时任务即将超时，通过此函数回调应用，执行一些清理和标注工作，并取消短时任务
        console.info('suspend delay task will timeout');
      })
      this.requestId = delayInfo.requestId;
      this.delayTime = delayInfo.actualDelayTime;
      console.info(`Succeeded in requestSuspendDelay. requestId is :${this.requestId}, delayTime is :${this.delayTime}`);
    } catch (error) {
      console.error(`Operation requestSuspendDelay failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }
  // [End request_suspend_delay]

  // [Start get_time]
  getRemainingDelayTime() {
    try {
      backgroundTaskManager.getRemainingDelayTime(this.requestId).then((res: number) => {
        console.info(`Succeeded in getting remaining delay time. delay time is :${res}`);
      }).catch((err: BusinessError) => {
        console.error(`Failed to get remaining delay time. Code: ${err.code}, message: ${err.message}`);
      })
    } catch (error) {
      console.error(`Operation getRemainingDelayTime failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }
  // [End get_time]

  // [Start cancel_suspend_delay]
  cancelSuspendDelay() {
    try {
      backgroundTaskManager.cancelSuspendDelay(this.requestId);
      console.info('Succeeded in cancelSuspendDelay');
    } catch (error) {
      console.error(`Operation cancelSuspendDelay failed. code is ${(error as BusinessError).code} message is ${(error as BusinessError).message}`);
    }
  }
  // [End cancel_suspend_delay]

  build() {
    Column() {
      Row(){
        Text($r('app.string.transient_task_id')).fontSize(20)
        Text(this.requestId.toString()).fontSize(20).id('transient_task_id')
      }
      Button($r('app.string.request_suspend_delay'))
        .id('request_suspend_delay')
        .fontSize(20)
        .margin({ top: 10, bottom: 10 })
        .type(ButtonType.Capsule)
        .backgroundColor($r('app.color.background'))
        .size({ width: '70%', height: '8%' })
        .onClick(() => {
          this.requestSuspendDelay()
        })
      Button($r('app.string.get_remaining_delay_time'))
        .id('get_remaining_delay_time')
        .fontSize(20)
        .margin({ top: 10, bottom: 10 })
        .type(ButtonType.Capsule)
        .backgroundColor($r('app.color.background'))
        .size({ width: '70%', height: '8%' })
        .onClick(() => {
          this.getRemainingDelayTime()
        })
      Button($r('app.string.cancel_suspend_delay'))
        .id('cancel_suspend_delay')
        .fontSize(20)
        .margin({ top: 10, bottom: 10 })
        .type(ButtonType.Capsule)
        .backgroundColor($r('app.color.background'))
        .size({ width: '70%', height: '8%' })
        .onClick(() => {
          this.cancelSuspendDelay()
        })
    }.width('100%')
    .margin({ top: 5 })
  }
}