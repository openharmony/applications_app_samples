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
export struct TitleBar {
  @Link title: Resource
  private handleOnClick?: () => void

  build() {
    Row() {
      Image($r('app.media.no'))
        .width($r('app.float.image_size_32'))
        .height($r('app.float.image_size_32'))
        .margin({ right: 22 })
        .objectFit(ImageFit.Contain)
        .onClick(() => {
          router.back()
        })

      Text(this.title)
        .fontSize($r('app.float.font_size_title'))
        .fontWeight(400)
        .textAlign(TextAlign.End)
        .fontColor(Color.Black)

      Blank()

      Image($r('app.media.yes'))
        .width($r('app.float.image_size_32'))
        .height($r('app.float.image_size_32'))
        .objectFit(ImageFit.Contain)
        .onClick(this.handleOnClick)
    }
    .width('100%')
    .padding({ left: $r('app.float.title_bar_padding'), right: $r('app.float.title_bar_padding') })
    .height(70)
  }
}