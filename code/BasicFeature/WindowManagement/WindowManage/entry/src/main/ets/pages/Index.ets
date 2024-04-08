/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import router from '@ohos.router';

@Entry
@Component
struct Index {
  @State isChangeWindow: boolean = false

  onPageShow() {
    this.isChangeWindow = false
  }

  build() {
    Column() {
      Button($r("app.string.pages_text"))
        .standardButton(20, '80%')
        .margin({ top: 80 })
        .onClick(() => {
          router.pushUrl({
            url: "pages/Video"
          })
          this.isChangeWindow = true
        })
      Button($r("app.string.get_properties_of_system_bar_page"))
        .standardButton(20, '80%')
        .onClick(() => {
          router.pushUrl({
            url: "system_bar/pages/GetPropertiesOfSystemBar"
          })
        })
      Button($r("app.string.set_touchable_area_of_window_page"))
        .standardButton(20, '80%')
        .onClick(() => {
          router.pushUrl({
            url: "touchable/pages/SetTouchableAreas"
          })
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(this.isChangeWindow ? FlexAlign.Start : FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .backgroundColor($r('app.color.light_gray'))
  }
}

@Extend(Button)
function standardButton(fontSize: number, value: Length) {
  .fontSize(fontSize)
  .fontColor($r('app.color.dark_gray'))
  .backgroundColor($r('app.color.white'))
  .padding(15)
  .margin({ top: 20 })
  .width(value)
}