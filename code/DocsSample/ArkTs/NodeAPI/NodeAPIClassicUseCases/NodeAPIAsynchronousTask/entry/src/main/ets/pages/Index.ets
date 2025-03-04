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
import nativeModule from 'libentry1.so';

let num1: number = 123;
let num2: number = 456;

@Entry
@Component
struct Index {
  @State message: string = 'AsyncWork';

  build() {
      Column({space: 5}) {
        Text(this.message)
          .fontSize(30)
          .fontWeight(FontWeight.Bold)
        Button($r('app.string.AsyncWorkPromise'))
          .margin(3)
          .onClick(() => {
            testNapi.asyncWork(1024).then((result) => {
              hilog.info(0x0000, 'XXX', 'result is %{public}d', result);
              this.message = 'result is ' + result.toString();
            });
          })
        Button($r('app.string.AsyncWorkCallback'))
          .margin(3)
          .onClick(() => {
            nativeModule.asyncWork(num1, num2, (result) => {
              hilog.info(0x0000, 'XXX', 'result is %{public}d', result);
              this.message = 'result is ' + result.toString();
            });
          })
      }
      .width('100%')
    .height('100%')
  }
}
