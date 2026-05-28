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

// [Start TestHiTraceMeter_Import]
import { hiTraceMeter, hilog} from '@kit.PerformanceAnalysisKit';
// [End TestHiTraceMeter_Import]

// [Start TestHiTraceMeter_FUNC]
function testHiTraceMeterASync() {
  const COMMERCIAL = hiTraceMeter.HiTraceOutputLevel.COMMERCIAL;
  hiTraceMeter.startAsyncTrace(COMMERCIAL, 'myTestAsyncTrace', 1001, 'categoryTest', 'key=value');
  hiTraceMeter.startAsyncTrace(COMMERCIAL, 'myTestAsyncTrace', 1002, 'categoryTest', 'key=value');

  setTimeout(() => {
    // 结束taskId为1001的异步跟踪任务
    hiTraceMeter.finishAsyncTrace(COMMERCIAL, 'myTestAsyncTrace', 1001);
  }, 2000);

  setTimeout(() => {
    // 结束taskId为1002的异步跟踪任务
    hiTraceMeter.finishAsyncTrace(COMMERCIAL, 'myTestAsyncTrace', 1002);
  }, 1000);
}

function testHiTraceMeterSync() {
  const COMMERCIAL = hiTraceMeter.HiTraceOutputLevel.COMMERCIAL;
  // 开始同步跟踪任务
  hiTraceMeter.startSyncTrace(COMMERCIAL, 'myTestSyncTrace', 'key=value');
  // 业务流程
  hilog.info(0x0000, 'testTrace', 'myTraceTest running, synchronizing trace');
  // 结束同步跟踪任务
  hiTraceMeter.finishSyncTrace(COMMERCIAL);
}

function testHiTraceMeterValue() {
  const COMMERCIAL = hiTraceMeter.HiTraceOutputLevel.COMMERCIAL;
  let traceCount = 0;
  // trace计数初始值
  hiTraceMeter.traceByValue(COMMERCIAL, 'myTestCountTrace', traceCount);
  traceCount++;
  // trace打点变化后的值
  hiTraceMeter.traceByValue(COMMERCIAL, 'myTestCountTrace', traceCount);
}

function testHiTraceMeter() {
  // 在未开启应用trace捕获时，避免该部分性能损耗
  if (hiTraceMeter.isTraceEnabled()) {
    testHiTraceMeterASync();
    testHiTraceMeterSync();
    testHiTraceMeterValue();
  } else {
    hilog.info(0x0000, 'testTrace', 'myTraceTest running, trace is not enabled');
  }
}
// [End TestHiTraceMeter_FUNC]

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Row() {
      Column() {
        // [Start TestHiTraceMeter_BUTTON]
        Button("testHiTraceMeter").backgroundColor('#FFFF00FF')
          .onClick(testHiTraceMeter)
        // [End TestHiTraceMeter_BUTTON]
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End hitracemeter_arkts_code]