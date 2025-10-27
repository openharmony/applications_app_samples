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

// [Start hitracechain_arkts_sample_code_a]
import { BusinessError } from '@kit.BasicServicesKit';
import { hiAppEvent, hilog, hiTraceChain, hiTraceMeter } from '@kit.PerformanceAnalysisKit';

async function test3() {
  hilog.info(0x0000, 'testTag', 'test3');
}

async function test2() {
  hilog.info(0x0000, 'testTag', 'test2');
}

async function test1() {
  hilog.info(0x0000, 'testTag', 'test1_1');
  await test2();
  hilog.info(0x0000, 'testTag', 'test1_2');
  await test3();
  hilog.info(0x0000, 'testTag', 'test1_3');
}

@Entry
@Component
struct Index {
  @State message: string = 'clickTime=0';
  @State clickTime: number = 0;

  build() {
    Row() {
      Column() {
        Button(this.message)
          .fontSize(20)
          .margin(5)
          .width(350)
          .height(60)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            this.clickTime++;
            this.message = 'clickTime=' + this.clickTime;
            // 业务开始前，开启分布式跟踪
            // INCLUDE_ASYNC表示会在系统支持的异步机制里自动传递HiTraceId
            let traceId = hiTraceChain.begin('testTag: hiTraceChain begin', hiTraceChain.HiTraceFlag.INCLUDE_ASYNC);
            // 开始HiTraceMeter同步打点，该接口API version 19开始支持
            hiTraceMeter.startSyncTrace(hiTraceMeter.HiTraceOutputLevel.COMMERCIAL, 'onClick', this.message);

            // 在按钮点击函数中进行事件打点，以记录按钮点击事件
            let eventParams: Record<string, number> = { 'click_time': 100 };
            let eventInfo: hiAppEvent.AppEventInfo = {
              // 事件领域定义
              domain: 'button',
              // 事件名称定义
              name: 'click',
              // 事件类型定义
              eventType: hiAppEvent.EventType.BEHAVIOR,
              // 事件参数定义
              params: eventParams
            };
            hiAppEvent.write(eventInfo).then(() => {
              hilog.info(0x0000, 'testTag', 'Succeeded in writing an app event');
              // 按钮点击事件处理结束，关闭异步处理分支的分布式跟踪
              hiTraceChain.end(traceId);
              hilog.info(0x0000, 'testTag', 'hiTraceChain end in hiAppEvent');
            }).catch((err: BusinessError) => {
              hilog.error(0x0000, 'testTag', `HiAppEvent err.code: ${err.code}, err.message: ${err.message}`);
              // 异常处理结束，关闭异步处理分支的分布式跟踪
              hiTraceChain.end(traceId);
              hilog.info(0x0000, 'testTag', 'hiTraceChain end in hiAppEvent');
            });

            // 创建Promise对象执行随机数生成任务，若随机数大于0.5，则正常返回结果，反之则返回异常信息
            const promise: Promise<number> = new Promise((resolve: Function, reject: Function) => {
              hilog.info(0x0000, 'testTag', 'promise task');
              const randomNumber: number = Math.random();
              if (randomNumber > 0.5) {
                resolve(randomNumber);
              } else {
                reject(new Error('Random number is too small'));
              }
            });

            // then方法的回调函数处理Promise对象的执行结果
            promise.then((result: number) => {
              // 成功时执行
              hilog.info(0x0000, 'testTag', 'Random number is %{public}d', result);
              // 回调函数处理结束，关闭异步处理分支的分布式跟踪
              hiTraceChain.end(traceId);
              hilog.info(0x0000, 'testTag', 'hiTraceChain end in promise/then');
            }).catch((error: BusinessError) => {
              // 失败时执行
              hilog.error(0x0000, 'testTag', error.message);
              // 异常处理结束，关闭异步处理分支的分布式跟踪
              hiTraceChain.end(traceId);
              hilog.info(0x0000, 'testTag', 'hiTraceChain end in promise/then');
            });

            // 执行async/await异步任务
            let res = test1();
            // then方法的回调函数处理异步任务的执行结果
            res.then(() => {
              hilog.info(0x0000, 'testTag', 'then task');
              // 功能同hiTraceChain.end，关闭异步处理分支的分布式跟踪
              hiTraceChain.clearId();
              hilog.info(0x0000, 'testTag', 'hiTraceChain end in async/await');
            });

            // 结束HiTraceMeter同步打点，该接口API version 19开始支持
            hiTraceMeter.finishSyncTrace(hiTraceMeter.HiTraceOutputLevel.COMMERCIAL);
            // 业务结束后，关闭分布式跟踪
            hiTraceChain.end(traceId);
            hilog.info(0x0000, 'testTag', 'hiTraceChain end in main thread');
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End hitracechain_arkts_sample_code_a]