/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
// [Start sendable_object]
import { ArkTSUtils, taskpool } from '@kit.ArkTS';

@Concurrent
function notifyAll(conditionVariable: ArkTSUtils.locks.ConditionVariable) {
  conditionVariable.notifyAll();
}

@Concurrent
function notifyOne(conditionVariable: ArkTSUtils.locks.ConditionVariable) {
  conditionVariable.notifyOne();
}

@Concurrent
async function wait(conditionVariable: ArkTSUtils.locks.ConditionVariable) {
  await conditionVariable.wait();
  console.info(`TaskPool Thread Wait: success`);
}

@Concurrent
async function waitFor(conditionVariable: ArkTSUtils.locks.ConditionVariable) {
  await conditionVariable.waitFor(3000);
  console.info(`TaskPool Thread WaitFor: success`);
}

@Entry
@Component
struct Index {
  @State message: string | ResourceStr = $r('app.string.AsyncButton');

  build() {
    Row() {
      Column() {
        Button(this.message)
          .fontSize(25)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            // 创建conditionVariable对象。
            const conditionVariable: ArkTSUtils.locks.ConditionVariable = new ArkTSUtils.locks.ConditionVariable();
            // 将实例conditionVariable传递给wait线程。
            taskpool.execute(wait, conditionVariable);
            // 将实例conditionVariable传递给notifyAll线程，唤醒wait线程，日志输出"TaskPool Thread Wait: success"。
            taskpool.execute(notifyAll, conditionVariable);
            // 将实例conditionVariable传递给waitFor线程。
            taskpool.execute(waitFor, conditionVariable);
            // 将实例conditionVariable传递给notifyOne线程，唤醒waitFor线程，日志输出"TaskPool Thread WaitFor: success"。
            taskpool.execute(notifyOne, conditionVariable);

            // 创建有name的conditionVariable对象。
            const conditionVariableRequest: ArkTSUtils.locks.ConditionVariable =
              ArkTSUtils.locks.ConditionVariable.request('Request1');
            // 将实例conditionVariableRequest传递给wait线程。
            taskpool.execute(wait, conditionVariableRequest);
            // 将实例conditionVariableRequest传递给notifyAll线程，唤醒wait线程，日志输出"TaskPool Thread Wait: success"。
            taskpool.execute(notifyAll, conditionVariableRequest);
            // 将实例conditionVariableRequest传递给waitFor线程。
            taskpool.execute(waitFor, conditionVariableRequest);
            // 将实例conditionVariableRequest传递给notifyOne线程，唤醒waitFor线程，日志输出"TaskPool Thread WaitFor: success"。
            taskpool.execute(notifyOne, conditionVariableRequest);
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End sendable_object]