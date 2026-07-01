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

import { hilog } from '@kit.PerformanceAnalysisKit';
import { Router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  aboutToAppear() {
    try {
      let router1 = this.getUIContext().getRouter();
      AppStorage.setOrCreate<Router>('router', router1);
    } catch (e) {
      hilog.info(0xF811, 'testTag', '%{public}s', 'e' + e);
    }
  }

  build() {
    RelativeContainer() {
      Column({ space: 12 }) {

        Row() {
          Button('SliderTrackThickness')
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({ url: 'pages/SliderTrackThickness'})
            })
        }

      }.width('100%')
      .alignItems(HorizontalAlign.Center)
      .justifyContent(FlexAlign.Center)

    }
    .height('100%')
    .width('100%')
  }
}