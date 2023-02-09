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
import { Contact, ContactDataSource, contactDataShareUtil, logger } from '@ohos/common'

const TAG: string = 'Contacts'

@Component
export default struct Contacts {
  private contactsData: ContactDataSource = new ContactDataSource()
  @Link contactsCount: number

  build() {
    List() {
      LazyForEach(this.contactsData, (item, index) => {
        ListItem() {
          this.ContactItem(item, index)
        }
        .onClick(() => {
          logger.info(TAG, `contact is clicked`)
          router.push({
            url: 'pages/ContactDetail',
            params: {
              contact: item
            }
          })
        })
      }, item => item.name)
    }
    .divider({ startMargin: 50, strokeWidth: 1 })
    .listDirection(Axis.Vertical)
    .layoutWeight(1)
  }

  @Builder ContactItem(contact: Contact, index: number) {
    Column() {
      if (index === 0) {
        Text(this.contactsData['dataArray'][index].name.substr(0, 1).toUpperCase())
          .fontSize($r('app.float.font_size_24'))
          .margin({ top: $r('app.float.page_space_24'), bottom: $r('app.float.page_space_24') })
      } else if (this.contactsData['dataArray'][index].name.substr(0, 1) !== this.contactsData['dataArray'][index-1].name.substr(0, 1)) {
        Text(this.contactsData['dataArray'][index].name.substr(0, 1).toUpperCase())
          .fontSize($r('app.float.font_size_24'))
          .margin({ top: $r('app.float.page_space_24'), bottom: $r('app.float.page_space_24') })
      }
      Row() {
        Image($r('app.media.head'))
          .size({ width: $r('app.float.head_size_small'), height: $r('app.float.head_size_small') })
        Text(contact.name)
          .fontSize($r('app.float.font_size_24'))
          .margin({ left: $r('app.float.page_space_12') })
      }
      .padding({ top: $r('app.float.page_space_12'), bottom: $r('app.float.page_space_12') })
    }
    .width('100%')
    .alignItems(HorizontalAlign.Start)
  }

  aboutToAppear() {
    this.queryAllContacts()
    contactDataShareUtil.onDataChange(getContext(this), this.queryAllContacts)
  }

  queryAllContacts = async () => {
    let contacts = await contactDataShareUtil.queryAllContacts(getContext(this))
    this.contactsCount = contacts.length
    this.contactsData['dataArray'] = contacts
    logger.info(TAG, `contacts= ${JSON.stringify(this.contactsData['dataArray'])}`)
    this.contactsData.notifyDataReload()
  }
}