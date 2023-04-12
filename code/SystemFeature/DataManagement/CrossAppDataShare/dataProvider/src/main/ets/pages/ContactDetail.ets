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
import { Contact, contactDataShareUtil, ContactDetailInfo, dialogUtil, OPERATE_STATUS } from '@ohos/common'

@Entry
@Component
struct ContactDetail {
  @State contact: Contact = undefined

  build() {
    Navigation() {
      if (this.contact) {
        ContactDetailInfo({ contact: $contact })
      }
    }
    .backgroundColor($r('app.color.page_background'))
    .toolBar(this.ToolBars)
    .hideToolBar(false)
  }

  @Builder ToolBars() {
    Row() {
      this.ToolBar($r('app.media.edit'), $r('app.string.edit'), () => {
        // edit the contact info
        router.push({
          url: 'pages/ContactEdit',
          params: {
            operate: OPERATE_STATUS.UPDATE,
            contact: this.contact
          }
        })
      })
      this.ToolBar($r('app.media.delete'), $r('app.string.delete'), async () => {
        // show delete dailog
        dialogUtil.showAlertDialog($r('app.string.delete_alert_message'),
        $r('app.string.delete'), async () => {
            await contactDataShareUtil.delete(getContext(this), this.contact.id)
            router.back()
          }, $r('app.string.cancel'), () => {
          })
      })
    }
    .width('100%')
    .height($r('app.float.tool_bar_height'))
  }

  @Builder ToolBar(image: Resource, text: ResourceStr, handleOnClick: () => void) {
    Column() {
      Image(image)
        .size({ width: $r('app.float.image_size_30'), height: $r('app.float.image_size_30') })
        .objectFit(ImageFit.Contain)
      Text(text)
        .fontColor($r('app.color.black'))
        .fontSize($r('app.float.font_size_18'))
    }
    .layoutWeight(1)
    .onClick(handleOnClick)
  }

  onPageShow() {
    if (router.getParams()) {
      if (router.getParams()['contact']) {
        this.contact = <Contact> router.getParams()['contact']
      }
    }
  }
}