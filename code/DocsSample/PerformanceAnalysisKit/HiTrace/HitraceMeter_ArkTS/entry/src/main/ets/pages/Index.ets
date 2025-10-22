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

// [Start hitracemeter_arkts_code]
import { hiTraceMeter, hilog } from '@kit.PerformanceAnalysisKit';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.message = (this.message == 'Hello HiTrace') ? 'Hello World' : 'Hello HiTrace';
            const COMMERCIAL = hiTraceMeter.HiTraceOutputLevel.COMMERCIAL;

            let traceCount = 0;
            // 第一个异步跟踪任务开始
            hiTraceMeter.startAsyncTrace(COMMERCIAL, 'myTestAsyncTrace', 1001, 'categoryTest', 'key=value');
            // 开始计数任务
            traceCount++;
            hiTraceMeter.traceByValue(COMMERCIAL, 'myTestCountTrace', traceCount);
            // 业务流程
            hilog.info(0x0000, 'testTrace', 'myTraceTest running, taskId: 1001');

            // 第二个异步跟踪任务开始，同时第一个跟踪的同名任务还没结束，出现了并行执行，对应接口的taskId需要不同
            hiTraceMeter.startAsyncTrace(COMMERCIAL, 'myTestAsyncTrace', 1002, 'categoryTest', 'key=value');
            // 开始计数任务
            traceCount++;
            hiTraceMeter.traceByValue(COMMERCIAL, 'myTestCountTrace', traceCount);
            // 业务流程
            hilog.info(0x0000, 'testTrace', 'myTraceTest running, taskId: 1002');

            // 结束taskId为1001的异步跟踪任务
            hiTraceMeter.finishAsyncTrace(COMMERCIAL, 'myTestAsyncTrace', 1001);
            // 结束taskId为1002的异步跟踪任务
            hiTraceMeter.finishAsyncTrace(COMMERCIAL, 'myTestAsyncTrace', 1002);

            // 开始同步跟踪任务
            hiTraceMeter.startSyncTrace(COMMERCIAL, 'myTestSyncTrace', 'key=value');
            // 业务流程
            hilog.info(0x0000, 'testTrace', 'myTraceTest running, synchronizing trace');
            // 结束同步跟踪任务
            hiTraceMeter.finishSyncTrace(COMMERCIAL);

            // 若通过HiTraceMeter性能打点接口传递的参数的生成过程比较复杂，此时可以通过isTraceEnabled判断当前是否开启应用trace捕获，
            // 在未开启应用trace捕获时，避免该部分性能损耗
            if (hiTraceMeter.isTraceEnabled()) {
              let customArgs = 'key0=value0';
              for (let index = 1; index < 10; index++) {
                customArgs += `,key${index}=value${index}`
              }
              hiTraceMeter.startAsyncTrace(COMMERCIAL, 'myTestAsyncTrace', 1003, 'categoryTest', customArgs);
              hilog.info(0x0000, 'testTrace', 'myTraceTest running, taskId: 1003');
              hiTraceMeter.finishAsyncTrace(COMMERCIAL, 'myTestAsyncTrace', 1003);
            } else {
              hilog.info(0x0000, 'testTrace', 'myTraceTest running, trace is not enabled');
            }
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End hitracemeter_arkts_code]