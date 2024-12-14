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

import { hilog } from '@kit.PerformanceAnalysisKit';
import testNapi from 'libentry.so';
import process from '@ohos.process';

@Entry
@Component
struct Index {
  @State result: string = '';

  build() {
    Column() {
      Text('Result: ' + this.result)
        .fontSize(25)
        .fontWeight(FontWeight.Bold)
        .margin({ bottom: 3 })
      List({ space: '10vp' }) {
        ListItem() {
          Text('1.customAsync')
            .fontSize(16)
            .width('100%')
            .height(60)
            .textAlign(TextAlign.Center)
            .fontWeight(FontWeight.Bold)
            .borderRadius(30)
            .backgroundColor(Color.White)
            .onClick(() => {
              try {
                hilog.info(0x0000, 'testTag', 'Test Node-API asynchronousWork: %{public}d',
                  testNapi.asynchronousWork({}, process.ProcessManager, (num: number) => {
                    return num;
                  }, 123));
                this.result = 'customAsyncSuccess';
              } catch (error) {
                hilog.error(0x0000, 'testTag', 'Test Node-API asynchronousWork error: %{public}s', error.message);
                this.result = 'customAsyncFail';
              }
            })
        }
      }.scrollBar(BarState.Off)
      .width('90%')
    }.width('100%')
    .height('100%')
    .backgroundColor(0xDCDCDC)
    .padding({ top: 5 })
  }
}