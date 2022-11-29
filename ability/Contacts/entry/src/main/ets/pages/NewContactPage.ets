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
import Contact from '../Model/Contact'
import ContactsManager from '../Service/ContactsManager'
import Constants from '../Util/Constants'
import {ContactItem} from '../Util/Constants'
import router from '@ohos.router';

@Entry
@Component
struct NewContactPage {
  @State title: string = router.getParams()['title']
  @State contact: Contact = router.getParams()['contact']
  contactsManager: ContactsManager = ContactsManager.getInstance()

  build() {
    Column() {
      Row() {
        Button() {
          Stack() {
            Image($r('app.media.back'))
              .height(40)
              .width(40)
          }
        }
        .backgroundColor('#f1f3f5')
        .height(50)
        .height(50)
        .onClick(() => {
          router.back()
        })

        Blank().width('5%')
        Text(this.title)
          .fontSize('30fp')
          .fontWeight(FontWeight.Bold)
          .width('65%')
        Button() {
          Stack() {
            Image($r('app.media.tick'))
              .height(40)
              .width(40)
          }
        }
        .backgroundColor('#f1f3f5')
        .height(50)
        .height(50)
        .onClick(() => {
          let index = this.contactsManager.findContactIndex(this.contact.id)
          if (index >= 0) {
            this.contactsManager.updateContact(this.contact)
          } else {
            this.contactsManager.addContact(this.contact)
          }
          router.back()
        })
      }
      .height('10%')
      .width('100%')
      Stack() {
        Circle({ width: '90%', height: '90%'})
          .fill(this.contact?.color)
        Text(this.contact?.name?.slice(0, 1))
          .height('80%')
          .fontSize('38fp')
          .fontColor(Color.White)
      }
      .width('100%')
      .height('15%')
      List({ space: 10, initialIndex: 0}) {
        ForEach(Constants.CONTACTS_ITEMS, (item: ContactItem) => {
          ListItem() {
            ContactItemComp({itemName: item.name_zh, itemKey: item.name, contact: $contact})
              .width('100%')
              .height('10%')
          }
        })
      }
      .height('90%')
      .borderRadius(30)
    }
    .backgroundColor('#f1f3f5')
    .height('100%')
    .width('100%')
  }
}

@Component
struct ContactItemComp {
  itemName: string = ''
  itemKey: string = ''
  @Link contact: Contact
  build() {
    Row() {
      Circle({ width: '15%', height: '50%' })
        .fill(this.contact?.color)
      TextInput({ text: this.contact[this.itemKey], placeholder: this.itemName })
        .fontSize('22fp')
        .width('85%')
        .height('90%')
        .onChange((text: string) => {
          this.contact[this.itemKey] = text
          console.log(this.contact[this.itemKey])
        })
        .backgroundColor(Color.White)
    }
    .height('100%')
    .width('100%')
    .backgroundColor(Color.White)
    .borderRadius(10)
  }
}