/*
 * Copyright (c) 2022 Huawei Device Co., Ltd.
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

import router from '@ohos.router'

@Component
export struct PublicTitleBar {
  private textName: string | Resource

  build() {
    Row() {
      Image($r('app.media.back'))
        .width(32)
        .height(32)
        .onClick(() => {
          router.back()
        })

      Text(this.textName)
        .fontSize(24)
        .margin({ left: 80 })
    }
    .height('8%')
    .width('100%')
    .padding({ left: 15, right: 15 })
  }
}
