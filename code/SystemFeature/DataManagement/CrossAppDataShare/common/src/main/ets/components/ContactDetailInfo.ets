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

import { Contact } from '../model/Contact'

@Component
export struct ContactDetailInfo {
  @Link contact: Contact

  build() {
    Column() {
      Text(this.contact.name.substring(0, 1)
        .toUpperCase())
        .width($r('app.float.head_size_big'))
        .height($r('app.float.head_size_big'))
        .fontSize($r('app.float.font_size_35'))
        .fontColor('#ffffff')
        .borderRadius(100)
        .margin({ top: 62, bottom: 22 })
        .textAlign(TextAlign.Center)
        .backgroundColor('#B6C5D1')

      Text(this.contact.name)
        .fontSize($r('app.float.font_size_32'))
        .margin({ bottom: $r('app.float.page_space_16') })

      Column() {
        ForEach(this.contact.phone.split(','), item => {
          Column() {
            Row() {
              Text(item)
                .fontSize($r('app.float.font_size_22'))
                .margin({ left: $r('app.float.page_space_16') })

              Blank()

              Image($r('app.media.phone2'))
                .width($r('app.float.image_size_32'))
                .height($r('app.float.image_size_32'))
                .margin({ right: $r('app.float.page_space_24') })
                .objectFit(ImageFit.Contain)

              Image($r('app.media.note'))
                .width($r('app.float.image_size_32'))
                .height($r('app.float.image_size_32'))
                .margin({ right: $r('app.float.page_space_24') })
                .objectFit(ImageFit.Contain)
            }
            .width('100%')
            .height(45)
            .padding($r('app.float.page_space_12'))

            Divider()
              .width('100%')
              .strokeWidth(1)
              .color('#ffefefef')
              .margin({ left: $r('app.float.page_space_16'), right: $r('app.float.page_space_16') })
          }
        })

        Row() {
          Column() {
            Text($r('app.string.default'))
              .fontSize($r('app.float.font_size_22'))
              .margin({ left: $r('app.float.page_space_16') })
            Text($r('app.string.phone_ring'))
              .fontSize($r('app.float.font_size_22'))
              .fontColor(Color.Gray)
              .margin({ left: $r('app.float.page_space_16') })
          }
          .alignItems(HorizontalAlign.Start)

          Blank()

          Image($r('app.media.right'))
            .height(32)
            .width(12)
            .objectFit(ImageFit.Contain)
            .margin({ right: $r('app.float.page_space_24') })
        }
        .width('100%')
        .padding($r('app.float.page_space_12'))
        .height(50)
      }
      .width('100%')
      .borderRadius(30)
      .backgroundColor(Color.White)
    }
    .width('100%')
    .height('100%')
    .padding({ left: $r('app.float.page_space_24'), right: $r('app.float.page_space_24') })
  }
}