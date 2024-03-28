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

import backgroundTaskManager from '@ohos.resourceschedule.backgroundTaskManager';
import { BusinessError } from '@ohos.base';
import util from '@ohos.util';
import hiTraceMeter from '@ohos.hiTraceMeter';
import taskpool from '@ohos.taskpool';

const totalTimes: number = 50000000; // 循环次数
const calculateResult: string = 'Total time costed = %s ms.'; //  文本格式

@Component
export struct TransientTaskView {
  @State message: string = 'Click button to calculate.';
  private requestId: number = 0;

  // 申请短时任务
  requestSuspendDelay() {
    try {
      let delayInfo = backgroundTaskManager.requestSuspendDelay('compute', () => {
        console.info('Request suspension delay will time out.');
        // 任务即将超时，取消短时任务
        this.cancelSuspendDelay();
      })
      this.requestId = delayInfo.requestId;
    } catch (error) {
      console.error(`requestSuspendDelay failed. message is ${(error as BusinessError).message}`);
    }
  }

  // 取消短时任务
  cancelSuspendDelay() {
    backgroundTaskManager.cancelSuspendDelay(this.requestId);
    console.info('Request suspension delay cancel.');
  }

  // 点击回调
  clickCallback = () => {
    this.requestSuspendDelay();
    this.message = 'calculating';
    hiTraceMeter.startTrace('computerTask', 0);
    let task: taskpool.Task = new taskpool.Task(computeTask, totalTimes);
    taskpool.execute(task, taskpool.Priority.HIGH).then((res: Object) => {
      this.message = util.format(calculateResult, res.toString());
      hiTraceMeter.finishTrace('computerTask', 0);
      this.cancelSuspendDelay();
    })
  }

  build() {
    Column() {
      Row() {
        Text(this.message)
      }

      Row() {
        Button('开始计算')
          .onClick(this.clickCallback)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}

// 计算任务
@Concurrent
function computeTask(times: number): number {
  let start: number = new Date().getTime();
  let a: number = 1;
  let b: number = 1;
  let c: number = 1;

  for (let i: number = 0; i < times; i++) {
    a = a * Math.random() + b * Math.random() + c * Math.random();
    b = a * Math.random() + b * Math.random() + c * Math.random();
    c = a * Math.random() + b * Math.random() + c * Math.random();
  }
  let end: number = new Date().getTime();
  return end - start;
}