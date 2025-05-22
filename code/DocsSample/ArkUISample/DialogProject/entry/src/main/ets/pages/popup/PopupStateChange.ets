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

// [Start state_popup]
@Entry
@Component
export struct StatePopupExample {
  @State handlePopup: boolean = false;

  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Column() {
          Button('PopupOptions')
            .margin({ top: 300 })
            .onClick(() => {
              this.handlePopup = !this.handlePopup;
            })
            .bindPopup(this.handlePopup, {
              message: 'This is a popup with PopupOptions',
              onStateChange: (e)=> { // 返回当前的气泡状态
                if (!e.isVisible) {
                  this.handlePopup = false;
                }
              }
            })
        }.width('100%').padding({ top: 5 })

      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.onStateChange_title'))
  }
}
// [End state_popup]