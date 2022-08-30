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

@Component
export struct UpdateContact {
  @Link name: string
  @Link email: string
  @Link nickName: string
  @Link phoneNumber: string
  @Link postalAddress: string

  build() {
    Scroll() {
      Column() {
        Image($r('app.media.touxiang'))
          .width(76)
          .height(74)
          .margin({ top: 52 })
          .objectFit(ImageFit.Contain)

        Text($r('app.string.save'))
          .fontSize(22)
          .margin({ top: 22, bottom: 32 })

        Column() {
          this.updateContact($r('app.string.name'), this.name, $r('app.media.name'))
          this.updateContact($r('app.string.address'), this.postalAddress, $r('app.media.address'))
          this.updateContact($r('app.string.phone'), this.phoneNumber, $r('app.media.email'))
          this.updateContact($r('app.string.email'), this.email, $r('app.media.nickname'))
          this.updateContact($r('app.string.note'), this.nickName, $r('app.media.phone'))
        }
        .height('80%')
      }
      .width('100%')
    }
  }

  @Builder
  updateContact(editText: Resource, info: string, img: Resource) {
    Row() {
      Image(img)
        .width(32)
        .height(32)
        .margin({ left: 16, right: 18 })
        .objectFit(ImageFit.Contain)

      TextInput({ placeholder: editText, text: info })
        .width('80%')
        .fontSize(22)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(Color.White)
        .placeholderFont({ size: 22, weight: 450, family: 'cursive', style: FontStyle.Normal })
        .onChange((value: string) => {
          switch (JSON.stringify(editText)) {
            case JSON.stringify($r('app.string.name')):
              this.name = value
              break
            case JSON.stringify($r('app.string.note')):
              this.nickName = value
              break
            case JSON.stringify($r('app.string.phone')):
              this.phoneNumber = value
              break
            case JSON.stringify($r('app.string.email')):
              this.email = value
              break
            case JSON.stringify($r('app.string.address')):
              this.postalAddress = value
              break
            default:
              break
          }
        })
    }
    .margin({ bottom: 16 })
    .width('94%')
    .height(84)
    .borderRadius(32)
    .backgroundColor(Color.White)
  }
}