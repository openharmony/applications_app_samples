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

// Page title bar
@Component
export struct TitleBar {
  private title!: Resource;

  build() {
    Column() {
      Row() {
        Image($r('app.media.ic_back'))
          .width(40)
          .height(40)
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back()
          })
          .id('backBtn')
        Text(this.title)
          .fontSize(20)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('app.color.font_color_black'))
          .margin({ left: 8, right: 8 })
      }
      .height(56)
      .width('100%')
      .padding({ left: 16, right: 16 })
    }
  }
}