/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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
struct MainPage {
  build() {
    Row() {
      Column() {
        Image($r('app.media.pic01xxxhdpi'))
          .width(258)
          .height(258)
          .margin({top: 166})
        Button($r('app.string.unlock_button'))
          .backgroundColor('#FF007DFF')
          .fontSize('16fp')
          .fontWeight(500)
          .fontColor('#FFFFFFFF')
          .borderRadius($r('sys.float.ohos_id_corner_radius_button'))
          .width('624px')
          .height('80px')
          .margin({
            top: 214
          })
          .onClick(() => {
            AppStorage.setOrCreate('isUnlock', true);
            router.back();
          })
      }
      .width('100%')
    }
    .backgroundColor($r('app.color.page_background'))
    .height('100%')
  }
}