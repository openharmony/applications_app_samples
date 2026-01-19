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
          Button('Button1')
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({ url: 'pages/Button1' })
            })
        }

        Row() {
          Button('Button2')
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({ url: 'pages/Button2' })
            })
        }

        Row() {
          Button('Button3')
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({ url: 'pages/Button3' })
            })
        }

        Row() {
          Button('Button4')
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({ url: 'pages/Button4' })
            })
        }

        Row() {
          Button('ButtonModifierFAQ')
            .onClick(() => {
              this.getUIContext().getRouter().pushUrl({ url: 'pages/ButtonModifierFAQ'})
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