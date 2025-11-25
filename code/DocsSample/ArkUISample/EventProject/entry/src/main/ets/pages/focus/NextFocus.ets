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

// [Start dynamic_focus_next]
@Entry
@Component
export struct NextFocusExample {
  build() {
    NavDestination() {
      Column({ space: 30 }) {
        Row().height('30%')
        Row({ space: 10 }) {
          Button('A')
            .id('A')
            .nextFocus({ forward: 'F', backward: 'C', down: 'B' })
          Button('B')
            .id('B')
            .nextFocus({ down: 'C' })
          Button('C')
            .id('C')
        }

        Column({ space: 10 }) {
          Button('D')
            .id('D')
          Button('E')
            .id('E')
            .nextFocus({
              forward: 'A',
              backward: 'M',
              up: 'E',
              right: 'F'
            })
        }

        Row({ space: 10 }) {
          Button('F')
            .id('F')
            .nextFocus({ forward: 'B', down: 'A' })
        }
      }.width('100%')
    }
    // [StartExclude dynamic_focus_next]
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Focus_Index_NextFocus_title'))
    // [EndExclude dynamic_focus_next]
  }
}
// [End dynamic_focus_next]