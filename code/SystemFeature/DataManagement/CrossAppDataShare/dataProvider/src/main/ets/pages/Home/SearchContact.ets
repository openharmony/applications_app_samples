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

import { Contact, ContactDataSource, contactDataShareUtil } from '@ohos/common'


@Component
export default struct SearchContact {
  private contactsData: ContactDataSource = new ContactDataSource()
  private searchHolder: string = ''
  private searchBegin: string = ''
  private searchEnd: string = ''
  @State searchValue: string = ''
  @State searchCount: number = 0
  @Link showSearchView: boolean

  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .width(30)
          .objectFit(ImageFit.Contain)
          .margin({ left: 24 })
          .onClick(() => {
            this.showSearchView = false
          })
        Search({ value: this.searchValue, placeholder: this.searchHolder, icon: '/common/images/search.png' })
          .placeholderFont({ size: 16 })
          .placeholderColor('#88000000')
          .layoutWeight(1)
          .margin({ left: 12, right: 24 })
          .defaultFocus(true)
          .onChange((value: string) => {
            this.searchValue = value
            this.searchContacts()
          })
      }
      .backgroundColor(Color.White)
      .height($r('app.float.search_bar_height'))

      if (this.searchValue !== '') {
        Column() {
          if (this.searchCount === 0) {
            Text($r('app.string.search_empty'))
              .fontSize(25)
              .width('100%')
              .margin({ top: 50 })
              .textAlign(TextAlign.Center)
              .fontColor($r('app.color.text_gray'))
          } else {
            Text(`${this.searchBegin}${this.searchCount}${this.searchEnd}`)
              .fontSize(22)
              .width('100%')
              .fontColor($r('app.color.text_gray'))
              .padding({ top: 12, bottom: 12 })
          }
          List() {
            LazyForEach(this.contactsData, (item, index) => {
              ListItem() {
                this.ContactItem(item, index)
              }
            }, item => item.id.toString())
          }
          .divider({ startMargin: 50, strokeWidth: 1 })
          .listDirection(Axis.Vertical)
          .margin({ left: 24, right: 24, bottom: 56 })
        }
        .layoutWeight(1)
        .backgroundColor(Color.White)
        .padding({ left: 24, right: 24 })
        .justifyContent(FlexAlign.Start)
      }
    }
    .height('100%')
    .backgroundColor($r('app.color.light_black'))
  }

  @Builder ContactItem(contact: Contact, index: number) {
    Column() {
      if (index === 0) {
        Text(this.contactsData['dataArray'][index].name.substr(0, 1).toUpperCase())
          .fontSize(24)
          .margin({ top: 24, bottom: 24 })
      } else if (this.contactsData['dataArray'][index].name.substr(0, 1) !== this.contactsData['dataArray'][index-1].name.substr(0, 1)) {
        Text(this.contactsData['dataArray'][index].name.substr(0, 1).toUpperCase())
          .fontSize(24)
          .margin({ top: 24, bottom: 24 })
      }
      Row() {
        Image($r('app.media.head'))
          .size({ width: 45, height: 45 })
        Text(contact.name)
          .fontSize(24)
          .margin({ left: 12 })
      }
      .padding({ top: 12, bottom: 12 })
    }
    .alignItems(HorizontalAlign.Start)
  }

  aboutToAppear() {
    this.searchHolder = getContext(this).resourceManager.getStringSync($r('app.string.search_placeholder'))
    this.searchBegin = getContext(this).resourceManager.getStringSync($r('app.string.search_find'))
    this.searchEnd = getContext(this).resourceManager.getStringSync($r('app.string.search_contacts'))
  }

  searchContacts = async () => {
    let contacts = await contactDataShareUtil.searchContactsFromName(getContext(this), this.searchValue)
    this.contactsData['dataArray'] = contacts
    this.searchCount = this.contactsData['dataArray'].length
    this.contactsData.notifyDataReload()
  }
}