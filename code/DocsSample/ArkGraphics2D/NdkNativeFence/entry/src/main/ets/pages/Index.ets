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

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';
  build() {
    Column() {
      Row() {
        Button($r("app.string.Button_label1"))
          .fontSize('16fp')
          .fontWeight(500)
          .margin({ right: 82 })
          .onClick(() => {
              hilog.info(0x0000, 'testTag', 'Test sync fence wait: ', testNapi.syncFence_wait());
          })
          .width('33.6%')
          .height(40)
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)

        Button($r("app.string.Button_label2"))
          .fontSize('16fp')
          .fontWeight(500)
          .margin({ left: 12 })
          .onClick(() => {
              hilog.info(0x0000, 'testTag', 'Test sync fence waitForever: ', testNapi.syncFence_waitForever());
          })
          .width('43.6%')
          .height(40)
          .shadow(ShadowStyle.OUTER_DEFAULT_LG)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .shadow(ShadowStyle.OUTER_DEFAULT_SM)
      .alignItems(VerticalAlign.Center)
      .layoutWeight(1)
    }
  }
}