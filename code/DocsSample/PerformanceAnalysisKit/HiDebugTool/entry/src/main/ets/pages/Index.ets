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

// [Start TestHidebugArk_Import]
import { BusinessError } from '@kit.BasicServicesKit';
import { hidebug, hilog } from '@kit.PerformanceAnalysisKit';
// [End TestHidebugArk_Import]

// [Start TestHidebugNdk_Import]
import testNapi from 'libentry.so';
// [End TestHidebugNdk_Import]

// [Start TestHidebugArk_Function]
function testHiDebugArk() {  // 按照需要调用的接口实现
  try {
    hilog.info(0x0000, 'testTag', `getSystemCpuUsage: ${hidebug.getSystemCpuUsage()}`);
  } catch (error) {
    hilog.info(0x0000, 'testTag', `error code: ${(error as BusinessError).code},
      error msg: ${(error as BusinessError).message}`);
  }
}
// [End TestHidebugArk_Function]

// [Start TestHidebugNdk_Function]
function testBackTraceJsFrame(i : number) : void {
  if (i > 0) {
    return testBackTraceJsFrame(i-1);
  }
  return testNapi.testBackTrace();
}

function testBackTrace() : void {
  testBackTraceJsFrame(3);
}

function testGetThreadCpuUsage() : void {
  testNapi.testGetThreadCpuUsage();
}
// [End TestHidebugNdk_Function]

@Entry
@Component
struct Index {
  build() {
    Row() {
      Column() {
        // [Start TestHidebugArk_Button]
        Button('testHiDebugArk')
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('60%')
          .height('5%')
          // 添加点击事件
          .onClick(testHiDebugArk);
        // [End TestHidebugArk_Button]

        // [Start TestHidebugNdk_Buttons]
        Button('testGetThreadCpuUsage')
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('60%')
          .height('5%')
          // 添加点击事件
          .onClick(testGetThreadCpuUsage);

        Button('testHiDebugBackTrace')
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('60%')
          .height('5%')
          // 添加点击事件
          .onClick(testBackTrace);
        // [End TestHidebugNdk_Buttons]
      }
      .width('100%')
    }
    .height('100%')
  }
}