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
import router from '@ohos.router'

@Entry
@Component
struct ContactInfoPage {
  @StorageLink('isUpdate') isUpdate: boolean = false
  contactId: string = router.getParams()['contactId']
  build () {
    Column() {
      if (this.isUpdate || true) {}
      Row() {
        Button() {
          Stack() {
            Image($r('app.media.back'))
              .height(40)
              .width(40)
          }
        }
        .backgroundColor(Color.White)
        .height(50)
        .width(50)
        .onClick(() => {
          router.back()
        })
        Blank().width('5%')
        Button() {
          Stack() {
            Image($r('app.media.add'))
              .height(40)
              .width(40)
          }
        }
        .backgroundColor(Color.White)
        .height(50)
        .width(50)
        .onClick(() => {
          router.push({
            url: 'pages/NewContactPage',
            params: {
              contact: ContactsManager.getInstance().getContact(this.contactId),
              title: '编辑联系人'
            }
          })
        })
      }
      .height('10%')
      .width('100%')

      Stack() {
        Circle({ width: '90%', height: '90%'})
          .fill(ContactsManager.getInstance().getContact(this.contactId)?.color)
        Text(ContactsManager.getInstance().getContact(this.contactId)?.name?.slice(0, 1))
          .height('80%')
          .fontSize('38fp')
          .fontColor(Color.White)
      }
      .width('100%')
      .height('15%')
      Text(ContactsManager.getInstance().getContact(this.contactId)?.name)
        .fontSize('30fp')
        .height('10%')
        .width('100%')
        .textAlign(TextAlign.Center)
      Text(ContactsManager.getInstance().getContact(this.contactId)?.phoneNum)
        .fontSize('30fp')
        .height('10%')
        .width('100%')
        .textAlign(TextAlign.Center)
      Text(ContactsManager.getInstance().getContact(this.contactId)?.email)
        .fontSize('30fp')
        .height('10%')
        .width('100%')
        .textAlign(TextAlign.Center)
      Text(ContactsManager.getInstance().getContact(this.contactId)?.address)
        .fontSize('30fp')
        .height('10%')
        .width('100%')
        .textAlign(TextAlign.Center)
      Text(ContactsManager.getInstance().getContact(this.contactId)?.remark)
        .fontSize('30fp')
        .height('10%')
        .width('100%')
        .textAlign(TextAlign.Center)
    }
    .width('100%')
    .height('100%')
  }
}