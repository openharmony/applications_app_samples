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

// [Start samp_ling]
import hilog from '@ohos.hilog';

const TAG = '[Sample_Sampling]';
const DOMAIN = 0xF811;
const BUNDLE = 'MyApp_Sampling';

@Entry
@ComponentV2
struct Sampling {
  build() {
    RelativeContainer() {
      Column()
        .backgroundColor(Color.Green)
        .height('100%')
        .width('100%')
        .onTouch((event: TouchEvent) => {
          // 从event中获取历史点
          let allHistoricalPoints = event.getHistoricalPoints();
          if (allHistoricalPoints.length !== 0) {
            for (const point of allHistoricalPoints) {
              hilog.info(DOMAIN, TAG, BUNDLE + 'historical point: [' + point.touchObject.windowX +
                ', ' + point.touchObject.windowY + ']')
            }
          }
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [End samp_ling]