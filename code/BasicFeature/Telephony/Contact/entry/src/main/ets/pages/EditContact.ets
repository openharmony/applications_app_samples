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

import router from '@ohos.router'
import prompt from '@ohos.promptAction'
import contact from '@ohos.contact'
import Logger from '../data/Logger'
import { UpdateContact } from '../component/UpdateContact'

const TAG: string = 'EditContact'

@Entry
@Component
struct EditContact {
  @State contactId: number = 0
  @State name: string = ''
  @State email: string = ''
  @State nickName: string = ''
  @State phoneNumber: string = ''
  @State postalAddress: string = ''
  @State contact: contact.Contact = <contact.Contact> router.getParams()['data']

  build() {
    Column() {
      Row() {
        Image($r('app.media.no'))
          .id('cancelEdit')
          .width(32)
          .height(32)
          .margin({ left: 32, right: 22 })
          .objectFit(ImageFit.Contain)
          .onClick(() => {
            router.back()
          })

        Text($r('app.string.editor_contact'))
          .fontSize(26)
          .fontWeight(400)
          .textAlign(TextAlign.End)
          .fontColor(Color.Black)

        Blank()

        Image($r('app.media.yes'))
          .id('confirmEdit')
          .width(32)
          .height(32)
          .margin({ right: 32 })
          .objectFit(ImageFit.Contain)
          .onClick(async () => {
            let test = /^(13[0-9]|14[01456879]|15[0-35-9]|16[2567]|17[0-8]|18[0-9]|19[0-35-9])\d{8}/
            Logger.info(TAG, `this number is ${this.phoneNumber} this test result ${test.test(this.phoneNumber)}`)
            if (test.test(this.phoneNumber) === true) {
              let contacts = {
                id: this.contactId,
                name: { fullName: this.name },
                nickName: { nickName: this.nickName },
                phoneNumbers: [{ phoneNumber: this.phoneNumber }],
                emails: [{ email: this.email }],
                postalAddresses: [{ postalAddress: this.postalAddress }]
              }
              await contact.updateContact(contacts)
              router.replaceUrl({
                url: 'pages/Index'
              })
              router.clear()
            } else {
              prompt.showToast({
                message: 'Please input phone number.',
                duration: 2000,
              })
            }
          })
      }
      .height('6%')
      .width('100%')
      .margin({ top: 32 })
      .constraintSize({ minHeight: 50 })

      UpdateContact({
        name: $name,
        phoneNumber: $phoneNumber,
        nickName: $nickName,
        email: $email,
        postalAddress: $postalAddress
      })
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.add_contact_bg'))
  }

  aboutToAppear() {
    this.contact.name.fullName === '' ? this.name = '' : this.name = this.contact.name.fullName
    try {
      this.contactId = this.contact.id
    } catch (err) {
      this.contactId = 0
    }
    try {
      this.nickName = this.contact.nickName.nickName
    } catch (err) {
      this.nickName = ''
    }
    if (this.contact.phoneNumbers !== undefined) {
      this.phoneNumber = this.contact.phoneNumbers[0].phoneNumber === '' ? '' : this.contact.phoneNumbers[0].phoneNumber
    }
    if (this.contact.emails !== undefined) {
      this.email = this.contact.emails[0].email === '' ? '' : this.contact.emails[0].email
    }
    if (this.contact.postalAddresses !== undefined) {
      this.postalAddress = this.contact.postalAddresses[0].postalAddress === '' ? '' : this.contact.postalAddresses[0].postalAddress
    }
  }
}