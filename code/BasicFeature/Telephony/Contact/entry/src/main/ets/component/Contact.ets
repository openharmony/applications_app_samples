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
import { ItemContainer } from '../component/ItemContainer'
import Logger from '../data/Logger'

const TAG: string = 'Contact'

@Component
export struct Contact {
  // 监听权限
  @StorageLink('hasPermission') @Watch('queryContact') hasPermission: boolean = false
  @State result: string = ''
  @State selected: number = 0
  @State myPosition: string = ''
  @State contactNumber: number = 0
  @State contacts: contact.Contact[] = []
  private scroller: Scroller = new Scroller()
  private controller: TextInputController = new TextInputController()
  private alphabetical: string[] =
    [
      'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M',
      'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z'
    ]

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
            router.pushUrl({
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
            router.pushUrl({
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
        Text(`${this.contactNumber}${this.myPosition}`)
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
            Logger.info(TAG, `this phoneData is ${JSON.stringify(phoneData)}`)
            let emailData = await contact.queryContactsByEmail(this.result)
            Logger.info(TAG, `this emailData is ${JSON.stringify(emailData)}`)
            if (JSON.stringify(phoneData) !== '[]' || JSON.stringify(emailData) !== '[]') {
              let result: contact.Contact = undefined
              result = (JSON.stringify(phoneData) !== '[]' ? await contact.queryContact(phoneData[0].key) : await contact.queryContact(emailData[0].key))
              Logger.info(TAG, `this phoneDat query result is ${JSON.stringify(result)}`)
              router.pushUrl({
                url: 'pages/NameCard',
                params: { data: result }
              })
            } else {
              Logger.info(TAG, `333`)
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

      Column() {
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
      }

      Row() {
        Column() {
          if (this.contacts.length > 0) {
            ItemContainer({ contacts: this.contacts, selected: $selected })
          }
        }
        .width('90%')

        Column() {
          AlphabetIndexer({ arrayValue: this.alphabetical, selected: this.selected })
            .itemSize(14)
            .font({ size: 12 })
            .borderRadius(25)
            .usingPopup(false)
            .selectedColor($r('app.color.table_selected'))
            .margin({ left: 2, right: 4, top: 4 })
            .alignStyle(IndexerAlign.Right)
            .selectedFont({ size: 14, weight: FontWeight.Bolder })
            .onSelect((selected: number) => {
              // 跳转到指定索引位置
              this.scroller.scrollToIndex(selected)
            })
        }
        .width('10%')
        .height('100%')
        .margin({ top: 20 })
      }
      .width('100%')
    }
    .width('100%')
    .height('100%')
    .backgroundColor($r('app.color.index_bg'))
  }

  async queryContact() {
    this.myPosition = await getContext(this).resourceManager.getStringValue($r('app.string.contacts').id)
    this.contacts = await contact.queryContacts()
    Logger.info(TAG, `this contact is ${JSON.stringify(this.contacts)}`)
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

  async aboutToAppear() {
    await this.queryContact()
  }
}