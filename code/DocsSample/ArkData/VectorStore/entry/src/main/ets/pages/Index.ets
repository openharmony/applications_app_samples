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
import { getVectorStore } from './crud/vectorStoreCTUD';

const DOMAIN = 0x0000;

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column() {
      Button() {
        Text('getVectorStore_TS')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
      }
      .type(ButtonType.Capsule)
      .margin({ top: 50 })
      .width('50%')
      .height('8%')
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        getVectorStore();
      })

      Button() {
        Text('getVectorStore_NDK')
          .fontSize(18)
          .fontWeight(FontWeight.Bold)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
      }
      .type(ButtonType.Capsule)
      .margin({ top: 50 })
      .width('50%')
      .height('8%')
      .backgroundColor('#0D9FFB')
      .onClick(() => {
        testNapi.add(2, 3);
      })
    }
    .height('100%')
    .width('100%')
  }
}
