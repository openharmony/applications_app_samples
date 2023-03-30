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

@Component
export struct UserInformation {
  build() {
    Column() {
      Row() {
        Image($r('app.media.user_avatar'))
          .width(48)
          .height(48)
          .objectFit(ImageFit.Contain)
        Column() {
          Text($r('app.string.user_name'))
            .fontSize(16)
            .fontWeight(500)
            .fontColor($r('app.color.white'))
            .margin({ bottom: 12 })
          Row() {
            Row() {
              Text($r('app.string.sign_Info'))
                .fontSize(10)
                .fontColor($r('app.color.white'))
            }
            .padding(4)
            .borderRadius(10)
            .backgroundColor($r('app.color.point_selected'))

            Row() {
              Text($r('app.string.sign_info_address'))
                .fontSize(10)
                .fontColor($r('app.color.white'))
            }
            .padding(4)
            .borderRadius(10)
            .margin({ left: 4 })
            .backgroundColor($r('app.color.point_selected'))
          }
        }
        .padding({ left: 12 })
        .alignItems(HorizontalAlign.Start)
      }
      .width('100%')
      .padding({ left: 12, top: 12, bottom: 12 })
      .backgroundColor($r('app.color.transfer'))
    }
  }
}