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

import data_rdb from '@ohos.data.relationalStore'
import router from '@ohos.router'
import promptAction from '@ohos.promptAction'
import common from '@ohos.app.ability.common'
import Contact from '../model/Contact'
import Logger from '../model/Logger'
import RdbModel from '../model/RdbModel'
import { TitleBar } from '../common/TitleBar'
import { TABLE_NAME, SQL_CREATE_TABLE, COLUMNS } from '../model/RdbConst'

const TAG = 'ContactEdit'
let rdbModel = new RdbModel(TABLE_NAME, SQL_CREATE_TABLE, COLUMNS, getContext(this) as common.UIAbilityContext)

@Entry
@Component
struct ContactEdit {
  private params: any = router.getParams()
  private isInsert: boolean = <boolean> this.params.isInsert
  @State contact: Contact = <Contact> this.params.contact

  @Builder InputText(icon, placeHolder, key, text, filter, maxLength, onChange) {
    Row() {
      Image(icon)
        .height(30).width(30)
        .objectFit(ImageFit.Contain)

      TextInput({ placeholder: placeHolder, text: text })
        .key('input' + (key))
        .layoutWeight(1)
        .fontSize(25)
        .placeholderFont({ size: 25 })
        .height(50)
        .inputFilter(filter)
        .maxLength(maxLength)
        .backgroundColor(Color.White)
        .onChange(onChange)
    }
    .width('95%')
    .padding(16)
    .margin({ top: 16 })
    .backgroundColor(Color.White)
    .borderRadius(16)
  }

  @Builder menuBuilder() {
    Column({ space: 2 }) {
      Text($r('app.string.male'))
        .fontSize(25)
        .width('100%')
        .padding(5)
        .onClick(() => {
          this.contact.gender = 0
        })

      Divider().color(Color.Black).height(1)

      Text($r('app.string.female'))
        .fontSize(25)
        .width('100%')
        .padding(5)
        .onClick(() => {
          this.contact.gender = 1
        })
    }
    .width(150)
    .padding(10)
    .backgroundColor(Color.White)
  }

  handleSubmit = async () => {
    if (this.contact.name === '') {
      promptAction.showToast({ message: $r('app.string.name_validate'), duration: 1000 })
      return
    }
    if (this.contact.phone === '') {
      promptAction.showToast({ message: $r('app.string.phone_validate'), duration: 1000 })
      return
    }
    try {
      if (this.isInsert) {
        let predicates = new data_rdb.RdbPredicates(TABLE_NAME)
        predicates.equalTo('name', this.contact.name)
        let alreadyExist = await rdbModel.query(predicates)
        if (alreadyExist.length > 0) {
          Logger.info(TAG, 'already exist, need update')
          this.contact.id = alreadyExist[0].id
          await rdbModel.updateData(this.contact)
        } else {
          await rdbModel.insertData(this.contact)
          Logger.info(TAG, 'insert success')
        }
      } else {
        await rdbModel.updateData(this.contact)
        Logger.info(TAG, 'update success')
      }
    } catch (err) {
      Logger.error(JSON.stringify(err))
    }
    router.back()
  }

  build() {
    Column() {
      TitleBar({ hasBackPress: true, rightBtn: $r('app.media.submit'), handleRightBtn: this.handleSubmit })

      Scroll() {
        Column() {
          Image($r('app.media.contact_photo'))
            .width('30%')
            .aspectRatio(1)
            .objectFit(ImageFit.Fill)

          Row() {
            Text($r('app.string.gender'))
              .fontSize(25)

            Text(this.contact.gender === 0 ? $r('app.string.male') : $r('app.string.female'))
              .fontSize(25)
              .border({ width: 1, color: Color.Black })
              .width('30%')
              .padding(5)
              .margin({ left: 5 })
              .textAlign(TextAlign.Center)
              .bindMenu(this.menuBuilder)
          }

          this.InputText($r('app.media.ic_contact'), $r('app.string.name'), 'Name', this.contact.name, '', 20, (value: string) => {
            this.contact.name = value
          })
          this.InputText($r('app.media.ic_telephone'), $r('app.string.phone'), 'Phone', this.contact.phone, '', 11, (value: string) => {
            this.contact.phone = value
          })
          this.InputText($r('app.media.ic_remark'), $r('app.string.remark'), 'Remark', this.contact.remark, '', 50, (value: string) => {
            this.contact.remark = value
          })
        }
      }
      .layoutWeight(1)
    }
    .height('100%')
    .width('100%')
    .backgroundColor('#F9F9F9')
  }
}