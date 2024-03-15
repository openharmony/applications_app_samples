/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *  http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import router from '@ohos.router';

@Component
export struct TitleBar {
  private title: string | Resource = '';

  build() {
    Row() {
      Image($r('app.media.ic_back'))
        .width(24)
        .aspectRatio(1)
        .margin({ right: 18 })
        .fillColor($r('sys.color.ohos_id_color_primary'))
        .onClick(() => {
          router.back()
        })
      Text(this.title)
        .fontSize(20)
        .fontWeight(FontWeight.Bold)
        .fontColor($r('sys.color.ohos_id_color_text_primary'))
        .margin({ left: $r('sys.float.ohos_id_elements_margin_horizontal_l') })
    }
    .width('100%')
  }
}