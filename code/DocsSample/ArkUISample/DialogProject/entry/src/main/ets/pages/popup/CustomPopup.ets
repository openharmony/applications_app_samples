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

// [Start custom_popup]
// 请将$r('app.media.xxx')替换为实际资源文件
@Entry
@Component
export struct CustomPopupExample {
  @State customPopup: boolean = false;

  // popup构造器定义弹框内容
  @Builder
  popupBuilder() {
    Row({ space: 2 }) {
      Image($r('app.media.app_icon')).width(24).height(24).margin({ left: 5 })
      Text('This is Custom Popup').fontSize(15)
    }.width(200).height(50).padding(5)
  }

  build() {
    NavDestination() {
      Column() {
        Button('CustomPopupOptions')
          .id('CustomPopupOptions')
          .margin({ top: 300 })
          .onClick(() => {
            this.customPopup = !this.customPopup;
          })
          .bindPopup(this.customPopup, {
            builder: this.popupBuilder, // 气泡的内容
            placement: Placement.Bottom, // 气泡的弹出位置
            popupColor: Color.Pink, // 气泡的背景色
            backgroundBlurStyle: BlurStyle.NONE,
            onStateChange: (e) => {
              if (!e.isVisible) {
                this.customPopup = false
              }
            }
          })
      }
      .height('100%')
    }
    // [StartExclude custom_popup]
    // 请将$r('app.string.custom_popup')替换为实际资源文件，在本示例中该资源文件的value值为"自定义气泡"
    .title($r('app.string.custom_popup'))

    // [EndExclude custom_popup]
  }
}

// [End custom_popup]