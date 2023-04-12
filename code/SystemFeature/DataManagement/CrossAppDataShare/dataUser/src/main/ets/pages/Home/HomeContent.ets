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
import ContactStore from '../../feature/ContactStore'
import { Contact, ContactDataSource, OPERATE_STATUS, logger } from '@ohos/common'
import { syncContact } from '../../feature/SyncContact'

const TAG: string = 'HomeContent'

@Component
export default struct HomeContent {
  @StorageLink('isRefresh') @Watch('refreshData') isRefresh: boolean = false
  @State isLoading: boolean = false
  private contactsData: ContactDataSource = new ContactDataSource()

  build() {
    Navigation() {
      Column() {
        Row() {
          Text($r('app.string.sync_contacts'))
            .fontColor(Color.Blue)
            .fontSize(20)
          if (this.isLoading) {
            LoadingProgress()
              .color(Color.Blue)
              .size({ width: 30, height: 30 })
          }
        }
        .onClick(() => {
          if (!this.isLoading) {
            this.syncContacts()
          }
        })
      }
      .width('100%')

      List() {
        LazyForEach(this.contactsData, (item, index) => {
          ListItem() {
            this.ContactItem(item, index)
          }
          .onClick(() => {
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
      .padding({ left: $r('app.float.page_space_24'), right: $r('app.float.page_space_24') })
      .listDirection(Axis.Vertical)
      .width('100%')
      .height('100%')
    }
    .backgroundColor($r('app.color.page_background'))
    .layoutWeight(1)
    .hideBackButton(true)
    .title(this.NavigationTitle)
  }

  @Builder
  ContactItem(contact: Contact, index: number) {
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
    .margin({ left: $r('app.float.page_space_12'), right: $r('app.float.page_space_12') })
    .alignItems(HorizontalAlign.Start)
  }

  @Builder
  NavigationTitle() {
    Stack({ alignContent: Alignment.End }) {
      Image($r('app.media.add'))
        .width(28)
        .height(28)
        .onClick(() => {
          router.pushUrl({
            url: 'pages/ContactEdit',
            params: {
              operate: OPERATE_STATUS.ADD
            }
          })
        })
    }
    .width('100%')
  }

  aboutToAppear() {
    this.refreshContacts()
  }

  refreshData() {
    if (this.isRefresh) {
      this.refreshContacts()
      this.isRefresh = false
    }
  }

  refreshContacts = async () => {
    await ContactStore.getRdbStore(getContext(this))
    let contacts = await ContactStore.queryAll()
    logger.info(TAG, `contacts size = ${contacts.length}`)
    this.contactsData['dataArray'] = contacts
    this.contactsData.notifyDataReload()
  }
  syncContacts = async () => {
    this.isLoading = true
    let contacts = await syncContact(getContext(this))
    logger.info(TAG, `contacts size = ${contacts.length}`)
    this.contactsData['dataArray'] = contacts
    this.contactsData.notifyDataReload()
    this.isLoading = false
  }
}