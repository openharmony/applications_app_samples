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

import { hilog, hiTraceMeter, hiTraceChain, hidebug, hiAppEvent } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
import testNapi from 'libentry.so';

function testHidebug(event?: ClickEvent) {
  try {
    hilog.info(0x0000, 'testTag', `getSystemCpuUsage ${hidebug.getSystemCpuUsage()}`);
  } catch (err) {
    hilog.error(0x0000, 'testTag', `error message is ${(err as BusinessError).message}`);
  }
}

@Entry
@Component
struct Index {
  build() {
    Row() {
      Column() {
        Button($r('app.string.HiTraceMeterArkTS_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('60%')
          .height('5%')
          .onClick(() => {
            let traceCount = 0;
            // 第一个跟踪任务开始
            hiTraceMeter.startTrace("myTraceTest", 1001);
            // 开始计数任务
            traceCount++;
            hiTraceMeter.traceByValue("myTestCount", traceCount);
            // 业务流程
            console.log(`myTraceTest running, taskid: 1001`);
            // 第二个跟踪任务开始，同时第一个跟踪的同名任务还没结束，出现了并行执行，对应接口的taskId需要不同。
            hiTraceMeter.startTrace("myTraceTest", 1002);
            // 开始计数任务
            traceCount++;
            hiTraceMeter.traceByValue("myTestCount", traceCount);
            // 业务流程
            console.log(`myTraceTest running, taskid: 1002`);
            // 结束taskId为1001的跟踪任务
            hiTraceMeter.finishTrace("myTraceTest", 1001);
            // 结束taskId为1002的跟踪任务
            hiTraceMeter.finishTrace("myTraceTest", 1002);
          })

        Button($r('app.string.HiTraceChainArkTS_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('60%')
          .height('5%')
          .onClick(() => {
            try {
              // 业务开始前，开启分布式跟踪。
              let traceId = hiTraceChain.begin("Write a new app event", hiTraceChain.HiTraceFlag.INCLUDE_ASYNC);
              // 在按钮点击函数中进行事件打点，以记录按钮点击事件
              let eventParams: Record<string, number> = { 'click_time': 100 };
              let eventInfo: hiAppEvent.AppEventInfo = {
                // 事件领域定义
                domain: "button",
                // 事件名称定义
                name: "click",
                // 事件类型定义
                eventType: hiAppEvent.EventType.BEHAVIOR,
                // 事件参数定义
                params: eventParams,
              };
              hiAppEvent.write(eventInfo).then(() => {
                hilog.info(0x0000, 'testTag', `Succeed to write an app event`);
                // 业务结束，关闭分布式跟踪。
                hiTraceChain.end(traceId);
              }).catch((err: BusinessError) => {
                hilog.error(0x0000, 'testTag', `HiAppEvent err.code: ${err.code}, err.message: ${err.message}`);
              })
            } catch (err) {
              console.error(`error message is ${(err as BusinessError).message}`);
            }
          })

        Button($r('app.string.HiDebugArkTS_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('60%')
          .height('5%')
          // 添加点击事件
          .onClick(testHidebug);

        Button($r('app.string.HiCheckerArkTS_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('60%')
          .height('5%')
      }
      .width('50%')

      Column() {
        Button($r('app.string.HiTraceMeterCPP_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('60%')
          .height('5%')
          .onClick(() => {
            hilog.info(0x0000, 'testTag', 'HiTraceMeter C++', testNapi.testHiTraceMeterNDK());
          })

        Button($r('app.string.HiTraceChainCPP_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('60%')
          .height('5%')
          .onClick(() => {
            hilog.info(0x0000, 'testTag', 'HiTraceChain C++', testNapi.testHiTraceChainNDK());
          })

        Button($r('app.string.HiDebugCPP_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('60%')
          .height('5%')
          // 添加点击事件，触发testHidebugNdk方法。
          .onClick(testNapi.testHidebugNdk);

        Button($r('app.string.TestHiCollieJankNdk_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('60%')
          .height('5%')
          // 添加点击事件，触发testHiCollieJankNdk方法
          .onClick(testNapi.testHiCollieJankNdk);

        Button($r('app.string.TestHiCollieStuckNdk_Button'))
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('60%')
          .height('5%')
          // 添加点击事件，触发testHiCollieStuckNdk方法
          .onClick(testNapi.testHiCollieStuckNdk);
      }
      .width('50%')
    }
    .height('100%')
  }
}
