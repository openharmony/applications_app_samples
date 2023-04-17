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
import prompt from '@ohos.promptAction'
import ContactStore from '../feature/ContactStore'
import { arrayToString, Contact, ContactInfo, logger, OPERATE_STATUS, TitleBar } from '@ohos/common'

const TAG: string = 'ContactEdit'

@Entry
@Component
struct ContactEdit {
  @StorageLink('isRefresh') isRefresh: boolean = false
  private contact: Contact = undefined
  private phone: string = ''
  @State name: string = ''
  @State email: string = ''
  @State address: string = ''
  @State remark: string = ''
  @State phones: string[] = ['']
  @State title: Resource = $r('app.string.create_contact')

  build() {
    Column() {
      TitleBar({ title: $title, handleOnClick: this.submit })
      Scroll() {
        ContactInfo({
          name: $name,
          phones: $phones,
          email: $email,
          address: $address,
          remark: $remark
        })
      }
      .layoutWeight(1)
      .padding({ left: $r('app.float.page_padding'), right: $r('app.float.page_padding') })
    }
    .backgroundColor($r('app.color.page_background'))
  }

  aboutToAppear() {
    if (router.getParams()) {
      if (router.getParams()['operate']) {
        let operate = router.getParams()['operate']
        if (operate === OPERATE_STATUS.UPDATE) {
          this.title = $r('app.string.edit_contact')
          this.contact = <Contact> router.getParams()['contact']
          this.name = this.contact.name
          this.phone = this.contact.phone
          this.email = this.contact.email
          this.address = this.contact.address
          this.remark = this.contact.remark
          this.phones = this.phone.split(',')
        }
      }
    }
  }

  submit = async () => {
    this.phone = arrayToString(this.phones)
    if (this.name.length === 0 || this.phone.length === 0) {
      prompt.showToast({ message: $r('app.string.empty_tips') })
      return
    }
    if (this.phone.length < 8) {
      prompt.showToast({ message: $r('app.string.phone_length_tips') })
      return
    }
    if (this.contact === undefined) {
      const valueBucket = {
        'name': this.name,
        'phone': this.phone,
        'email': this.email,
        'address': this.address,
        'remark': this.remark
      }
      let insertId = await ContactStore.insert(valueBucket)
      logger.info(TAG, `insert contact, insertId = ${insertId}`)
      AppStorage.SetOrCreate('isRefresh', true)
      router.back()
    } else {
      this.contact.name = this.name
      this.contact.phone = this.phone
      this.contact.email = this.email
      this.contact.address = this.address
      this.contact.remark = this.remark
      await ContactStore.update(this.contact.id, this.contact)
      AppStorage.SetOrCreate('isRefresh', true)
      logger.info(TAG, `update contact finish`)
      router.back({
        url: 'pages/ContactDetail',
        params: {
          contact: this.contact
        }
      })
    }
  }
}