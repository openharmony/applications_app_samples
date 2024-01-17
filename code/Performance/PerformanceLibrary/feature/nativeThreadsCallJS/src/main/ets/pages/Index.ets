/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

import entry from 'libentry.so';
import logger from '../utils/Logger';

@Component
export struct NativeThreadsCallJSDemo {
  @State value: number = 0;
  build() {
    Row() {
      Column() {
        Text(this.value.toString())
          .id('textNativeValue')
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
          .margin(20)

        Button("threadSafeTest")
          .width('40%')
          .fontSize(20)
          .onClick(()=> {
            // native使用线程安全函数实现跨线程调用
            entry.ThreadSafeTest((values: number) => {
              values += 10;
              logger.info('ThreadSafeTest js callback value = ', values.toString());
              this.value = values;
              return values;
            }
            )
          }).margin(20)

        Button("libuvTest")
          .width('40%')
          .fontSize(20)
          .onClick(()=> {
            // native使用libuv实现跨线程调用
            entry.UvWorkTest((values: number) => {
              values += 10;
              logger.info('UvWorkTest js callback value = ', values.toString());
              this.value = values;
              return values;
            }
            )
          }).margin(10)
      }
      .width('100%')
    }
    .height('100%')
  }
}