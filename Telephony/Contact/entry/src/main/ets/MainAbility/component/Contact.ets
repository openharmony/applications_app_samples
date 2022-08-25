// @ts-nocheck
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
import prompt from '@ohos.prompt'
import contact from '@ohos.contact'
import resourceManager from '@ohos.resourceManager'
import { ItemContainer } from '../component/ItemContainer'

@Component
export struct Contact {
  @State result: string = ''
  @State position: string = ''
  @State contactNumber: number = 0
  @State contacts: contact.Contact[] = []
  private controller: TextInputController = new TextInputController()

  build() {
    Column() {
      Row() {
        Blank()
        Image($r('app.media.add'))
          .width(32)
          .height(32)
          .margin({ right: 32, top: 32 })
          .objectFit(ImageFit.Contain)
          .key('add')
          .onClick(() => {
            router.push({
              url: 'pages/AddContact'
            })
          })
        Image($r('app.media.setting'))
          .width(32)
          .height(32)
          .margin({ right: 32, top: 32 })
          .objectFit(ImageFit.Contain)
          .key('setting')
          .onClick(() => {
            router.push({
              url: 'pages/Setting'
            })
          })
      }
      .height('6%')
      .width('100%')
      .constraintSize({ minHeight: 50 })

      Row() {
        Text($r('app.string.contact'))
          .fontSize(40)
          .fontWeight(600)
          .margin({ left: 32, top: 22 })
      }
      .width('100%')

      Row() {
        Text(`${this.contactNumber}${this.position}`)
          .fontSize(20)
          .fontColor(Color.Gray)
          .margin({ left: 32, bottom: 22 })
      }
      .width('100%')

      Stack({ alignContent: Alignment.TopStart }) {
        TextInput({ placeholder: $r('app.string.search'), text: this.result, controller: this.controller })
          .fontSize(20)
          .height(52)
          .padding({ left: 46 })
          .fontColor(Color.Gray)
          .borderRadius(26)
          .placeholderFont({ size: 20 })
          .onChange(async (value: string) => {
            this.result = value
          })
          .onSubmit(async (enterKey: EnterKeyType) => {
            let phoneData = await contact.queryContactsByPhoneNumber(this.result)
            let emailData = await contact.queryContactsByEmail(this.result)
            if (phoneData[0] !== [] || emailData[0] !== []) {
              router.push({
                url: 'pages/NameCard',
                params: { data: await contact.queryContact(phoneData[0].key) }
              })
            } else {
              this.result = ''
              prompt.showToast({
                message: 'Error!',
                duration: 1500 // 提示弹窗持续时间，单位ms
              })
            }
          })
        Image($r('app.media.search'))
          .width(24)
          .height(24)
          .margin({ left: 12, top: 16 })
      }
      .margin({ left: 32, right: 32 })

      Row() {
        Image($r('app.media.heads'))
          .width(52)
          .height(52)
          .margin({ left: 32 })

        Text($r('app.string.group'))
          .fontSize(20)
          .margin({ left: 16 })
      }
      .margin({ top: 22, bottom: 22 })
      .width('100%')
      .borderRadius(15)

      Row() {
        Image($r('app.media.heads'))
          .width(52)
          .height(52)
          .margin({ left: 32 })

        Text($r('app.string.name_card'))
          .fontSize(20)
          .margin({ left: 16 })
      }
      .width('100%')
      .borderRadius(15)

      ItemContainer({ contacts: this.contacts })
    }
    .width('100%')
    .height('100%')
    .backgroundColor('#f1f3f5')
  }

  async aboutToAppear() {
    let resource = await resourceManager.getResourceManager()
    this.position = await resource.getString($r('app.string.contacts').id)
    this.contacts = await contact.queryContacts()
    this.contactNumber = this.contacts.length
    // 对获取到的联系人数组根据姓名首字母排序
    let sortContact = this.contacts.map(function (a, b) {
      return { index: b, value: a.name.fullName.substr(0, 1), key: a.key }
    })
    sortContact.sort(function (a, b) {
      return +(a.value > b.value) || +(a.value === b.value) - 1
    })
    for (let i = 0; i < sortContact.length; i++) {
      let contactInfo = await contact.queryContact(sortContact[i].key)
      this.contacts[i] = contactInfo
    }
  }
}