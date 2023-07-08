/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import notification from '@ohos.notificationManager';
import { notificationManagement } from '@ohos/notification';
import { logger } from '@ohos/notification';
import { TitleBar } from './/TitleBar';

@Component
export struct NotificationList {
  @State groupNotifications: Array<Array<notification.NotificationRequest>> = undefined;
  @State countsByType: Array<number> = null;

  aboutToAppear() {
    notificationManagement.getAllNotifications().then((data) => {
      this.groupNotifications = data.groupNotifications;
      this.countsByType = data.countsByType;
      logger.info("getAllNotifications data: " + JSON.stringify(data));
    })
  }

  build() {
    Column() {
      TitleBar({ title: $r('app.string.messages_list_title') })
      List({ space: 15 }) {
        ForEach(this.countsByType, (num: number, index: number) => {
          if (this.groupNotifications[index].length) {
            ListItem() {
              NotificationItem({
                notifications: this.groupNotifications[index],
                notificationNum: this.countsByType[index],
              })
                .onClick(() => {
                  if (this.countsByType[index]) {
                    notificationManagement.cancelNotificationType(this.groupNotifications[index][0].content.contentType);
                    let currentBadgeNum = notificationManagement.getBadgeNumber();
                    currentBadgeNum -= this.countsByType[index];
                    this.countsByType[index] = 0;
                    notificationManagement.setBadgeNumber(currentBadgeNum);
                  }
                })
            }
          }
        })
      }.width('100%')
    }.width('100%')

  }
}


@Component
export struct NotificationItem {
  @State notificationNum: number = 0;
  @State notifications: notification.NotificationRequest[] = undefined;
  private title: Resource;
  private content: string;

  aboutToAppear() {
    switch (this.notifications[0].content.contentType) {
      case notification.ContentType.NOTIFICATION_CONTENT_BASIC_TEXT: {
        this.title = $r('app.string.basic_notification');
        this.content = this.notifications[0].content.normal.text;
        break;
      }
      case notification.ContentType.NOTIFICATION_CONTENT_LONG_TEXT: {
        this.title = $r('app.string.long_text_notification');
        this.content = this.notifications[0].content.longText.text;
        break;
      }
      case notification.ContentType.NOTIFICATION_CONTENT_PICTURE: {
        this.title = $r('app.string.picture_notification');
        this.content = this.notifications[0].content.picture.text;
        break;
      }
      case notification.ContentType.NOTIFICATION_CONTENT_MULTILINE: {
        this.title = $r('app.string.multiline_notification');
        this.content = this.notifications[0].content.multiLine.text;
        break;
      }
    }
  }

  build() {
    Row() {
      Badge({
        count: this.notificationNum,
        position: BadgePosition.Right,
        style: { badgeSize: 25, badgeColor: $r('app.color.badge_color'), fontSize: 20 }
      }) {
        Column() {
          Text(this.title)
            .alignSelf(ItemAlign.Start)
            .fontWeight(500)
            .fontSize(20)
            .lineHeight(22)
          Text(this.content)
            .alignSelf(ItemAlign.Start)
            .margin({ top: 10 })
            .fontSize(16)
            .opacity(0.6)
        }.width('100%')
      }.width('95%')
      .margin({ left: 10, right: 15 })
    }.backgroundColor(Color.White)
    .borderRadius(24)
    .margin({ left: 10, right: 10 })
    .padding(16)
  }
}