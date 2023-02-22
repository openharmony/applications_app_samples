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
import Contact from '../Model/Contact'
import {ContactComp} from './ContactComp'
import ContactsManager from '../Service/ContactsManager'

@CustomDialog
struct MyCustomDialog {
  controller: CustomDialogController
  onConfirm() {
    ContactsManager.getInstance().savePersistContacts()
  }

  build() {
    Column() {
      Text('保存联系人').fontSize(20).margin({ top: 10, bottom: 10 })
      Text('是否保存共' + ContactsManager.getInstance().getContactsCount() + '个联系人').fontSize(16).margin({ bottom: 10 })
      Flex({ justifyContent: FlexAlign.SpaceAround}) {
        Button('取消')
          .onClick(() => {
            this.controller.close()
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('确定')
          .onClick(() => {
            this.controller.close()
            this.onConfirm()
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }
  }
}

@Entry
@Component
struct Index {
  @State title: string = '联系人'
  @State selectContactId: string = ''
  @StorageLink('isUpdate') isUpdate: boolean = false
  dialogController: CustomDialogController = new CustomDialogController({
    builder: MyCustomDialog(),
    autoCancel: true
  })
  contactsManager: ContactsManager = ContactsManager.getInstance()

  build() {
    Row() {
      if (this.isUpdate || true) {}
      Column() {
        Row() {
          Blank()
            .width('5%')
          Column() {
            Text(this.title)
              .fontSize('30fp')
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
            Text(this.contactsManager.getContactsCount().toString() + '个联系人')
              .fontSize('15fp')
              .fontWeight(FontWeight.Bold)
              .textAlign(TextAlign.Start)
          }
          Blank()
            .width('20%')
          Button() {
            Stack() {
              Image($r("app.media.add"))
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
                contact: new Contact('', '', '', '', ''),
                title: '新建联系人'}
            })
          })
          Button() {
            Stack() {
              Image($r("app.media.save"))
                .height(40)
                .width((40))
            }
          }
          .backgroundColor(Color.White)
          .height(50)
          .height(50)
          .onClick(() => {
            this.dialogController.open()
          })
        }
        .height('10%')
        .width('100%')

        Column() {
          List({ space: 10, initialIndex: 0}) {
            ForEach(this.contactsManager.getContacts(false), (item: Contact) => {
              ListItem() {
                ContactComp({contact: item})
                  .width('100%')
                  .height('8%')
              }
            })
          }
          .height('70%')
          .backgroundColor(Color.White)
          .borderRadius(30)
        }
        .width('100%')
        .height('100%')
      }
      .width('100%')
    }
    .height('100%')
  }
}