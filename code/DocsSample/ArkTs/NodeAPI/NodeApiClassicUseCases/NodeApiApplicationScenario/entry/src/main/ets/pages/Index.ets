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

import testNapi from 'libentry.so';
import nativeModule from 'libentry1.so';

@Entry
@Component
struct Index {
  @State message: string = 'NodeAPI';

  build() {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
      Button($r('app.string.createArkRuntime'))
        .width('70%')
        .onClick(() => {
          testNapi.createArkRuntime();
          this.message = 'ArkRuntime success';
        })
      Button($r('app.string.runEventLoop'))
        .width('70%')
        .onClick(() => {
          testNapi.runEventLoop(true);
          this.message = 'EventLoop success';
        })
      Button($r('app.string.CallThreadSafeWithPriority'))
        .width('70%')
        .onClick(() => {
          let callback = (a: number, b: number): number => {
            console.info('result is ' + (a + b))
            return a + b;
          }
          testNapi.callThreadSafeWithPriority(callback);
          this.message = 'ThreadSafeWithPriority success';
        })
      Button($r('app.string.startThread'))
        .width('70%')
        .onClick(() => {
          let callback = (): Promise<string> => {
            return new Promise((resolve) => {
              setTimeout(() => {
                resolve('string from promise');
              }, 5000);
            });
          }
          nativeModule.startThread(callback);
          this.message = 'StartThread success';
        })
    }
    .width('100%')
    .height('100%')
  }
}
