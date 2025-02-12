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

@Entry
@Component
export struct FocusPrioritySample {

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        Column({ space: 8 }) {
          Row() {
            Button('Button1')
              .defaultFocus(true)
            Button('Button2')
              .focusScopePriority('RowScope', FocusPriority.PREVIOUS)
          }.focusScopeId('RowScope')
        }
        .alignItems(HorizontalAlign.Start)
        .backgroundColor('#fff')
        .borderRadius(12)
        .padding(12)
        .width('100%')
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Focus_FocusPriority_title'))
  }
}