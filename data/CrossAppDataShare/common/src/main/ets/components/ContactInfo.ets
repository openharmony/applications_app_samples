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

import { ContactDataSource } from '../data/BasicDataSource'
import { logger } from '../utils/Logger'

const TAG: string = 'ContactInfo'

@Component
export struct ContactInfo {
  @Link name: string
  @Link phones: string[]
  @Link email: string
  @Link address: string
  @Link remark: string
  private phoneData: ContactDataSource = new ContactDataSource()

  build() {
    Column() {
      Image($r('app.media.touxiang'))
        .width($r('app.float.head_size_mid'))
        .aspectRatio(1)
        .margin({ top: 52 })
        .objectFit(ImageFit.Contain)

      Text($r('app.string.save_to_phone'))
        .fontSize($r('app.float.font_size_22'))
        .margin({ top: 22, bottom: 32 })

      this.newContact($r('app.string.contact_name'), $r('app.media.name'), '', this.name, 12)
      LazyForEach(this.phoneData, (item, index) => {
        this.phoneView(item, index)
      }, (item, index) => index.toString())
      this.newContact($r('app.string.contact_email'), $r('app.media.email'), '', this.email, 20)
      this.newContact($r('app.string.contact_address'), $r('app.media.address'), '', this.address, 20)
      this.newContact($r('app.string.contact_remark'), $r('app.media.remark'), '', this.remark, 50)
    }
    .width('100%')
  }

  @Builder
  phoneView(item: string, index: number) {
    Row() {
      Image($r('app.media.phone'))
        .width($r('app.float.image_size_32'))
        .height($r('app.float.image_size_32'))
        .margin({ left: $r('app.float.page_space_16'), right: $r('app.float.page_space_12') })
        .objectFit(ImageFit.Contain)

      TextInput({ text: item, placeholder: $r('app.string.contact_phone') })
        .layoutWeight(1)
        .type(InputType.PhoneNumber)
        .fontSize($r('app.float.font_size_22'))
        .maxLength(11)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(Color.White)
        .placeholderFont({ size: 24, weight: 450, family: 'cursive', style: FontStyle.Normal })
        .onChange((value: string) => {
          this.phones[index] = value
          logger.info(TAG, `this.phone is ${JSON.stringify(this.phones)}`)
        })
      if (index > 0) {
        Image($r('app.media.no'))
          .size({ width: $r('app.float.image_size_32'), height: $r('app.float.image_size_32') })
          .objectFit(ImageFit.Contain)
          .margin({ left: $r('app.float.page_space_16'), right: $r('app.float.page_space_12') })
          .onClick(() => {
            this.phones.splice(index, 1)
            this.phoneData['dataArray'].splice(index, 1)
            this.phoneData.notifyDataReload()
          })
      }
    }
    .margin({ bottom: $r('app.float.page_space_16') })
    .padding({ top: $r('app.float.page_space_12'), bottom: $r('app.float.page_space_12') })
    .width('100%')
    .borderRadius(32)
    .backgroundColor(Color.White)
  }

  @Builder
  newContact(editText: Resource, img: Resource, filter: string, itemValue: string, maxLength: number) {
    Row() {
      Image(img)
        .width($r('app.float.image_size_32'))
        .height($r('app.float.image_size_32'))
        .margin({ left: $r('app.float.page_space_16'), right: $r('app.float.page_space_12') })
        .objectFit(ImageFit.Contain)

      TextInput({ text: itemValue, placeholder: editText })
        .layoutWeight(1)
        .fontSize($r('app.float.font_size_22'))
        .maxLength(maxLength)
        .inputFilter(filter)
        .fontWeight(FontWeight.Bold)
        .backgroundColor(Color.White)
        .placeholderFont({ size: 24, weight: 450, family: 'cursive', style: FontStyle.Normal })
        .onChange((value: string) => {
          switch (JSON.stringify(editText)) {
            case JSON.stringify($r('app.string.contact_name')):
              this.name = value
              break
            case JSON.stringify($r('app.string.contact_email')):
              this.email = value
              break
            case JSON.stringify($r('app.string.contact_address')):
              this.address = value
              break
            case JSON.stringify($r('app.string.contact_remark')):
              this.remark = value
              break
            default:
              break
          }
          logger.info(TAG, `this name is ${this.name}`)
        })
    }
    .margin({ bottom: $r('app.float.page_space_16') })
    .padding({ top: $r('app.float.page_space_12'), bottom: $r('app.float.page_space_12') })
    .width('100%')
    .borderRadius(32)
    .backgroundColor(Color.White)
  }

  aboutToAppear() {
    this.phoneData['dataArray'] = this.phones.copyWithin(this.phones.length, 0)
  }
}