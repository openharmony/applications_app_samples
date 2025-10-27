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

// [Start hitracechain_arkts_sample_code_b]
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog, hiTraceChain } from '@kit.PerformanceAnalysisKit';

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
            // 获取当前线程的HiTraceId
            let traceId = hiTraceChain.getId();
            // 如果traceId无效，为当前线程开启分布式跟踪
            if (!hiTraceChain.isValid(traceId)) {
              hilog.info(0x0000, 'testTag', 'HiTraceId is invalid, begin hiTraceChain');
              traceId = hiTraceChain.begin('testTag: hiTraceChain begin');
              // 使能traceId的INCLUDE_ASYNC，INCLUDE_ASYNC表示会在系统支持的异步机制里自动传递HiTraceId
              hiTraceChain.enableFlag(traceId, hiTraceChain.HiTraceFlag.INCLUDE_ASYNC);
              // 将使能INCLUDE_ASYNC的HiTraceId设置到当前线程
              hiTraceChain.setId(traceId);
              // 查询INCLUDE_ASYNC是否设置成功
              if (hiTraceChain.isFlagEnabled(hiTraceChain.getId(), hiTraceChain.HiTraceFlag.INCLUDE_ASYNC)) {
                hilog.info(0x0000, 'testTag', 'HiTraceFlag INCLUDE_ASYNC is enabled');
              }
            }

            const promise: Promise<number> = new Promise((resolve: Function, reject: Function) => {
              // 创建异步重复定时任务，每1s执行一次
              let intervalID = setInterval(() => {
                // 为当前异步重复定时任务设置HiTraceId
                hiTraceChain.setId(traceId);
                const randomNumber: number = Math.random();
                hilog.info(0x0000, 'testTag', 'Interval 1s: randomNumber is %{public}d', randomNumber);
                // 关闭当前异步重复定时任务的分布式跟踪
                hiTraceChain.end(traceId);
              }, 1000)

              // 创建异步定时任务，2.5s后执行，结束异步重复定时任务
              setTimeout(() => {
                // 为异步定时任务设置HiTraceId
                hiTraceChain.setId(traceId);
                // 为异步定时任务生成分支标识spanId
                let traceIdTimeout = hiTraceChain.createSpan();
                // 为异步定时任务设置带spanId的HiTraceId
                hiTraceChain.setId(traceIdTimeout);
                hilog.info(0x0000, 'testTag', 'setTimeout 2.5s');
                // 结束异步重复定时任务
                clearInterval(intervalID);
                const randomNumber: number = Math.random();
                if (randomNumber > 0.5) {
                  resolve(randomNumber);
                } else {
                  reject(new Error('Random number is too small'));
                }
                // 关闭异步定时任务的分布式跟踪
                hiTraceChain.end(traceId);
              }, 2500)
            })

            promise.then((result: number) => {
              // 成功时执行
              hilog.info(0x0000, 'testTag', 'Random number is %{public}d', result);
              // 回调函数处理结束，关闭异步处理分支的分布式跟踪
              hiTraceChain.end(traceId);
            }).catch((error: BusinessError) => {
              // 失败时执行
              hilog.error(0x0000, 'testTag', error.message);
              // 异常处理结束，关闭异步处理分支的分布式跟踪
              hiTraceChain.end(traceId);
            });

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
// [End hitracechain_arkts_sample_code_b]