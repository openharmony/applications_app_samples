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

import fileio from '@ohos.file.fs'
import router from '@ohos.router'
import contact from '@ohos.contact'
import common from '@ohos.app.ability.common'
import Logger from '../data/Logger'

const TAG: string = 'Setting'

@Entry
@Component
export struct Setting {
  @State contacts: contact.Contact[] = []

  build() {
    Column() {
      Row() {
        Image($r('app.media.back'))
          .width(32)
          .height(32)
          .margin({ left: 32, top: 32 })
          .objectFit(ImageFit.Contain)
          .key('back')
          .onClick(() => {
            router.back()
          })
      }
      .width('100%')

      Column() {
        Button($r('app.string.add_contact'))
          .margin(10)
          .width('48%')
          .height(48)
          .fontSize(20)
          .key('newAddContact')
          .onClick(() => {
            router.pushUrl({
              url: 'pages/AddContact'
            })
          })

        Button($r('app.string.import_file'))
          .margin(10)
          .width('48%')
          .height(48)
          .fontSize(20)
          .key('inputFile')

        Button($r('app.string.export_file'))
          .margin(10)
          .width('48%')
          .height(48)
          .fontSize(20)
          .key('exportFile')
      }
      .width('100%')
      .height('100%')
      .backgroundColor(Color.White)
    }
  }

  async aboutToAppear() {
    this.contacts = await contact.queryContacts()
    Logger.info(TAG, `this contacts is ${(JSON.stringify(this.contacts))}`)
  }

  async writeContact() {
    let ctx = getContext(this) as common.UIAbilityContext
    let path = ctx.filesDir
    let file = fileio.openSync(`${path}/Contact.json`, fileio.OpenMode.READ_WRITE | fileio.OpenMode.CREATE)
    for (let i = 0; i < this.contacts.length; i++) {
      fileio.writeSync(file.fd, `${this.contacts[i]}\n`)
    }
  }
}
