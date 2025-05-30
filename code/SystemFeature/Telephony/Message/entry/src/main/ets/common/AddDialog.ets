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

import Logger from '../model/Logger'
import Contact from '../model/Contact'

const TAG: string = '[AddDialog]'

@CustomDialog
export struct AddDialog {
  private editContact: Contact = null
  private controller: CustomDialogController
  private action: (contact: Contact) => void

  build() {
    Column() {
      Text($r('app.string.contact'))
        .fontSize(20)
        .fontColor(Color.Black)
        .fontWeight(FontWeight.Bold)

      Row() {
        Text($r('app.string.full_name'))
          .width(65)
          .fontSize(20)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)

        TextInput({ placeholder: 'input name', text: this.editContact.name })
          .layoutWeight(1)
          .type(InputType.Normal)
          .placeholderColor(Color.Gray)
          .fontSize(19)
          .margin({ left: 10 })
          .onChange((value: string) => {
            this.editContact.name = value
          })
          .id('nameInput')
      }
      .margin({ top: 10 })

      Row() {
        Text($r('app.string.telephone'))
          .fontSize(20)
          .width(65)
          .fontColor(Color.Black)
          .fontWeight(FontWeight.Medium)

        TextInput({ placeholder: 'input phone', text: this.editContact.destinationHost })
          .layoutWeight(1)
          .maxLength(11)
          .type(InputType.Number)
          .placeholderColor(Color.Gray)
          .fontSize(19)
          .margin({ left: 10 })
          .onChange((value: string) => {
            this.editContact.destinationHost = value
          })
          .id('telInput')
      }
      .margin({ top: 10 })

      Row() {
        Button() {
          Text($r('app.string.cancel'))
            .fontColor(Color.Red)
            .fontSize(17)
        }
        .id('cancel')
        .layoutWeight(7)
        .backgroundColor(Color.White)
        .margin(5)
        .onClick(() => {
          this.controller.close()
        })

        Text()
          .width(1).height(35)
          .backgroundColor('#8F8F8F')

        Button() {
          Text($r('app.string.determine'))
            .fontColor(Color.Blue)
            .fontSize(17)
        }
        .id('confirm')
        .layoutWeight(7)
        .backgroundColor(Color.White)
        .margin(5)
        .onClick(() => {
          Logger.info(`${TAG}, editContact = ${JSON.stringify(this.editContact)}`)
          if (this.editContact.name == '' || this.editContact.destinationHost == '') {
            AlertDialog.show(
              {
                title: $r('app.string.title_dialog'),
                message: $r('app.string.message_dialog'),
                confirm: {
                  value: $r('app.string.determine'),
                  action: () => {
                    Logger.info(`${TAG}, AlertDialog confirm`)
                  }
                },
                cancel: () => {
                  Logger.info(`${TAG}, AlertDialog cancel`)
                }
              }
            )
          } else {
            this.action(this.editContact)
          }
          this.controller.close()
        })
      }
      .width('100%')
      .margin({ top: 10 })
    }
    .padding(10)
  }
}