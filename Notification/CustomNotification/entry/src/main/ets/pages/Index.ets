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
import NotificationOperations from '../feature/NotificationOperations'
import { notificationUtil } from '@ohos/notification'

@Entry
@Component
struct Index {
  private notificationOperations: NotificationOperations = new NotificationOperations(getContext(this))

  @Builder TitleBar() {
    Row() {
      Image($r('app.media.ic_back'))
        .size({ width: 30, height: 30 })
        .margin({ left: 12 })
        .onClick(() => {
          router.back()
        })
      Text($r('app.string.MainAbility_label'))
        .fontSize(24)
        .margin({ left: 12 })
    }
    .width('100%')
    .height(70)
    .backgroundColor('#F1F3F5')
  }

  @Styles buttonStyle(){
    .width(230)
    .height(50)
    .margin(10)
  }

  build() {
    Column() {
      this.TitleBar()
      Scroll() {
        Flex({ wrap: FlexWrap.Wrap, justifyContent: FlexAlign.Center }) {
          Button($r('app.string.basic_notification'))
            .buttonStyle()
            .onClick(this.notificationOperations.publishBasicNotification)
          Button($r('app.string.long_text_notification'))
            .buttonStyle()
            .onClick(this.notificationOperations.publishLongTextNotification)
          Button($r('app.string.multiline_notification'))
            .buttonStyle()
            .onClick(this.notificationOperations.publishMultiLineNotification)
          Button($r('app.string.picture_notification'))
            .buttonStyle()
            .onClick(this.notificationOperations.publishPictureNotification)
          Button($r('app.string.notification_with_buttons'))
            .buttonStyle()
            .onClick(this.notificationOperations.publishNotificationWithButtons)
          Button($r('app.string.clickable_notification'))
            .buttonStyle()
            .onClick(this.notificationOperations.publishNotificationWithWantAgent)
          Button($r('app.string.cancel_all_notifications'))
            .buttonStyle()
            .onClick(()=>{
              notificationUtil.cancelAllNotifications()
            })
        }
        .width('100%')
        .padding(12)
      }
      .layoutWeight(1)
    }
    .width('100%')
    .height('100%')
  }

  aboutToAppear() {
    notificationUtil.enableNotification()
  }
}