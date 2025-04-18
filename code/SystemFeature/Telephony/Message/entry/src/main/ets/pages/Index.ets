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
import Contact from '../model/Contact'
import Logger from '../model/Logger'
import { TitleBar } from '../common/TitleBar'
import { AddDialog } from '../common/AddDialog'
import { grantPermission } from '../model/PermissionUtils'
import { ContactSource } from '../model/DataSource'

const TAG: string = '[Index]'

@Extend(Text) function fancyText(width: string, textAlign: number) {
  .width(width)
  .fontSize(20)
  .textAlign(textAlign)
}

@Entry
@Component
struct Index {
  @State editable: boolean = false
  @State contacts: ContactSource = new ContactSource([])
  @State editContact: Contact = new Contact('', '')
  @State managerContact: Resource = $r('app.string.manager')
  private addDialogController: CustomDialogController = new CustomDialogController({
    builder: AddDialog({ editContact: this.editContact, action: this.onAccept.bind(this) }),
    autoCancel: true
  })

  judgeRepeat(contact: Contact) {
    Logger.info(`${TAG}, judgeRepeat start`)
    for (let i = 0; i < this.contacts['contactData'].length; i++) {
      if (this.contacts['contactData'][i].name === contact.name && this.contacts['contactData'][i].destinationHost === contact.destinationHost) {
        Logger.info(`${TAG}, judgeRepeat ${this.contacts['contactData'][i]}`)
        Logger.info(`${TAG}, judgeRepeat return true`)
        return true
      }
    }
    Logger.info(`${TAG}, judgeRepeat return false`)
    return false
  }

  onAccept(contact: Contact) {
    Logger.info(`${TAG}, onAccept contact = ${JSON.stringify(contact)}`)
    let result = this.judgeRepeat(contact)
    Logger.info(`${TAG}, onAccept result = ${JSON.stringify(result)}`)
    if (result === false) {
      let newContact = new Contact(contact.name, contact.destinationHost)
      this.contacts['contactData'].unshift(newContact)
      this.contacts.notifyDataAdd(0)
      Logger.info(`${TAG}, onAccept-save contacts = ${JSON.stringify(this.contacts['contactData'])}`)
    } else {
      Logger.info(`${TAG}, onAccept AlertDialog`)
      AlertDialog.show(
        {
          title: $r('app.string.repeat_contact'),
          message: $r('app.string.exist_contact'),
          confirm: {
            value: $r('app.string.determine'),
            action: () => {
              Logger.info(`${TAG}, judgeRepeat AlertDialog confirm`)
            }
          }
        }
      )
      Logger.info(`${TAG}, onAccept result ==== true`)
    }
  }

  aboutToAppear() {
    grantPermission()
  }

  build() {
    Column() {
      TitleBar()
      Column() {
        Row() {
          Button() {
            Text($r('app.string.new_contact'))
              .fancyText('40%', TextAlign.Center)
              .fontColor(Color.White)
          }
          .id('newContact')
          .height(40)
          .type(ButtonType.Capsule)
          .backgroundColor($r('app.color.main_background'))
          .margin({ top: 20, bottom: 20 })
          .onClick(() => {
            this.editContact = new Contact('', '')
            this.addDialogController.open()
          })

          Button() {
            Text(this.managerContact)
              .fancyText('40%', TextAlign.Center)
              .fontColor(Color.White)
          }
          .id('manage')
          .height(40)
          .type(ButtonType.Capsule)
          .backgroundColor($r('app.color.main_background'))
          .margin({ top: 10, bottom: 10, left: 10 })
          .onClick(() => {
            this.editable = !this.editable
            if (this.editable) {
              this.managerContact = $r('app.string.cancel')
            } else {
              this.managerContact = $r('app.string.manager')
            }
          })
        }

        Column() {
          List({ space: 20, initialIndex: 0 }) {
            LazyForEach(this.contacts, (item: Contact, index: number) => {
              ListItem() {
                Row() {
                  Column() {
                    Row() {
                      Text($r('app.string.show_name'))
                        .fancyText('20%', TextAlign.Center)

                      Text(item.name)
                        .fancyText('50%', TextAlign.Start)
                    }
                    .margin({ bottom: 5 })

                    Row() {
                      Text($r('app.string.show_telephone'))
                        .fancyText('20%', TextAlign.Center)

                      Text(item.destinationHost)
                        .fancyText('50%', TextAlign.Start)
                    }
                  }
                  .margin({ top: 10, bottom: 10 })

                  Image($r('app.media.sms'))
                    .width(50)
                    .height(50)
                    .margin(10)
                    .objectFit(ImageFit.Contain)
                    .onClick(() => {
                      Logger.info(`${TAG}, onClick-sms ${item.name} ${item.destinationHost}`)
                      router.pushUrl({
                        url: 'pages/SendMessage',
                        params: {
                          contact: item
                        }
                      })
                    })
                    .id(`${item.name}`)

                  Text('×')
                    .id(`delete_${item.name}`)
                    .fontSize(50)
                    .fontWeight(FontWeight.Bold)
                    .visibility(this.editable ? Visibility.Visible : Visibility.None)
                    .onClick(() => {
                      this.contacts['contactData'] = this.contacts['contactData'].filter(obj => obj.name !== item.name || obj.destinationHost !== item.destinationHost);
                      this.contacts.notifyDataReload()
                      Logger.info(`${TAG}, onItemDelete contacts = ${JSON.stringify(this.contacts['contactData'][index])}`)
                    })
                }
                .width('100%')
              }
            }, item => item.name)
          }
          .listDirection(Axis.Vertical)
          .chainAnimation(false) // 联动特效关闭
          .edgeEffect(EdgeEffect.None) // 滑动到边缘无效果
          .divider({ strokeWidth: 2, color: $r('app.color.start_window_background'), startMargin: 20, endMargin: 20 })
          .width('90%')
          .height('100%')
        }
        .width('100%')
        .height('80%')
      }
      .margin({ top: 20 })
    }
    .width('100%')
    .height('100%')
  }
}