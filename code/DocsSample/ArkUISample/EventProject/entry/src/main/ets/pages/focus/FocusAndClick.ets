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

import { KeyCode } from '@kit.InputKit';
import { ColorMetrics, LengthMetrics } from '@kit.ArkUI';

// [Start dynamic_focus_click_count]
@Entry
@Component
export struct FocusAndClick {
  @State count: number = 0;
  @State name: string = 'Button';

  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Column() {
          Button(this.name)
            .fontSize(30)
            .onClick(() => {
              this.count++;
              if (this.count <= 0) {
                this.name = 'count is negative number';
              } else if (this.count % 2 === 0) {
                this.name = 'count is even number';
              } else {
                this.name = 'count is odd number';
              }
            }).height(60)
        }.height('100%').width('100%').justifyContent(FlexAlign.Center)

      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Focus_FocusAndClick_title'))
  }
}
// [End dynamic_focus_click_count]