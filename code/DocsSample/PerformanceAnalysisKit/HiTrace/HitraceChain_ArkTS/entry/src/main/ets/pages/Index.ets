/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start TestHiTraceChain_Import]
import { hiTraceChain, hilog } from '@kit.PerformanceAnalysisKit';
// [End TestHiTraceChain_Import]

// [Start TestHiTraceChain_TestFunc]
function initTraceId() {
  let traceId = hiTraceChain.getId();
  if (!hiTraceChain.isValid(traceId)) {
    hilog.info(0x0000, 'testTag', 'HiTraceId is invalid, begin hiTraceChain');
    traceId = hiTraceChain.begin('testTag: hiTraceChain begin', hiTraceChain.HiTraceFlag.INCLUDE_ASYNC);
  } else if (!hiTraceChain.isFlagEnabled(traceId, hiTraceChain.HiTraceFlag.INCLUDE_ASYNC)) {
    hiTraceChain.enableFlag(traceId, hiTraceChain.HiTraceFlag.INCLUDE_ASYNC);
    hiTraceChain.setId(traceId);
  }
  return traceId;
}

async function test(index: number) {
  if (index > 0) {
    await test(index - 1)
    hilog.info(0x0000, 'testTag', `record with traceId at task ${index}`);
  }
}

function testHiTraceIdPassedAutomatically() {
  let traceId = initTraceId();
  hilog.info(0x0000, 'testTag', 'record with traceId at first task');
  test(10).then(()=>{
    hilog.info(0x0000, 'testTag', 'record with traceId at then function');
  })
  hiTraceChain.end(traceId);
  hilog.info(0x0000, 'testTag', 'hiTraceChain end in main thread');
}

function testHiTraceIdPassedManually() {
  let traceId = initTraceId();
  hilog.info(0x0000, 'testTag', 'start testHiTraceIdPassedManually async trace');
  setTimeout(() => {
    // 为异步定时任务设置HiTraceId
    hiTraceChain.setId(traceId);
    // 为异步定时任务生成分支标识spanId
    let traceIdTimeout = hiTraceChain.createSpan();
    // 为异步定时任务设置带spanId的HiTraceId
    hiTraceChain.setId(traceIdTimeout);
    hilog.info(0x0000, 'testTag', 'end testHiTraceIdPassedManually async trace');
  }, 100);
  hiTraceChain.end(traceId);
  hilog.info(0x0000, 'testTag', 'hiTraceChain end in main thread');
}
// [End TestHiTraceChain_TestFunc]

@Entry
@Component
struct Index {
  @State message: string = 'clickTime=0';
  @State clickTime: number = 0;

  build() {
    Row() {
      Column() {
        // [Start TestHiTraceChain_Button]
        Button("testHiTraceIdPassedAutomatically").backgroundColor('#FFFF00FF')
          .onClick(testHiTraceIdPassedAutomatically)

        Button("testHiTraceIdPassedManually").backgroundColor('#FFFF00FF')
          .onClick(testHiTraceIdPassedManually)
        // [End TestHiTraceChain_Button]
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End hitracechain_arkts_sample_code_a]