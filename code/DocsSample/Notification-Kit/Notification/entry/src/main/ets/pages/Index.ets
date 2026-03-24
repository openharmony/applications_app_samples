/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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

import { AddWantAgent } from '../filemanager/AddWantAgent';
import { CancelNotification } from '../filemanager/CancelNotification';
import { ClearDuplicateNotifications } from '../filemanager/ClearDuplicateNotifications';
import { ManageNotificationBadges } from '../filemanager/ManageNotificationBadges';
import { ManageNotificationWays } from '../filemanager/ManageNotificationWays';
import { PublishNotification } from '../filemanager/PublishNotification';
import { RequestEnableNotification } from '../filemanager/RequestEnableNotification';
import { SpecifiedCustomizedRingtone } from '../filemanager/SpecifiedCustomizedRingtone';
import { UpdateNotification } from '../filemanager/UpdateNotification';

const MARGIN_TOP: number = 5;
const MARGIN_BOTTOM: number = 5;
const BUTTON_WIDTH: string = "75%";
@Entry
@Component
struct Index {
  @State message: string = 'Notification';
  @Provide('pageInfos') pageInfos: NavPathStack = new NavPathStack();

  build() {
    RelativeContainer() {
      Navigation(this.pageInfos) {
        Button($r('app.string.request_notify_auth'))
          .margin({ top: MARGIN_TOP, bottom: MARGIN_BOTTOM })
          .onClick(() => {
            this.pageInfos.pushPath({
              name: 'RequestEnableNotification'
            });
          })
          .width(BUTTON_WIDTH)
        Button($r('app.string.specified_customized_ringtone'))
          .margin({ top: MARGIN_TOP, bottom: MARGIN_BOTTOM })
          .onClick(() => {
            this.pageInfos.pushPath({
              name: 'SpecifiedCustomizedRingtone'
            });
          })
          .width(BUTTON_WIDTH)
        Button($r('app.string.manage_notify_badge'))
          .margin({ top: MARGIN_TOP, bottom: MARGIN_BOTTOM })
          .onClick(() => {
            this.pageInfos.pushPath({
              name: 'ManageNotificationBadges'
            });
          })
          .width(BUTTON_WIDTH)
        Button($r('app.string.manage_notify_channel'))
          .margin({ top: MARGIN_TOP, bottom: MARGIN_BOTTOM })
          .onClick(() => {
            this.pageInfos.pushPath({
              name: 'ManageNotificationWays'
            });
          })
          .width(BUTTON_WIDTH)
        Button($r('app.string.publish_notify'))
          .margin({ top: MARGIN_TOP, bottom: MARGIN_BOTTOM })
          .onClick(() => {
            this.pageInfos.pushPath({
              name: 'PublishNotification'
            });
          })
          .width(BUTTON_WIDTH)
        Button($r('app.string.add_notify_action'))
          .margin({ top: MARGIN_TOP, bottom: MARGIN_BOTTOM })
          .onClick(() => {
            this.pageInfos.pushPath({
              name: 'AddWantAgent'
            });
          })
          .width(BUTTON_WIDTH)
        Button($r('app.string.update_notify'))
          .margin({ top: MARGIN_TOP, bottom: MARGIN_BOTTOM })
          .onClick(() => {
            this.pageInfos.pushPath({
              name: 'UpdateNotification'
            });
          })
          .width(BUTTON_WIDTH)
        Button($r('app.string.cancel_notify'))
          .margin({ top: MARGIN_TOP, bottom: MARGIN_BOTTOM })
          .onClick(() => {
            this.pageInfos.pushPath({
              name: 'CancelNotification'
            });
          })
          .width(BUTTON_WIDTH)
        Button($r('app.string.cross_device_clear_dup_notify'))
          .margin({ top: MARGIN_TOP, bottom: MARGIN_BOTTOM })
          .onClick(() => {
            this.pageInfos.pushPath({
              name: 'ClearDuplicateNotifications'
            });
          })
          .width(BUTTON_WIDTH)
      }
      .navDestination(this.pageMap)
    }
    .height('100%')
    .width('100%')

  }

  @Builder
  pageMap(name: string) {
    if (name === 'RequestEnableNotification') {
      RequestEnableNotification();
    } else if (name === 'SpecifiedCustomizedRingtone') {
      SpecifiedCustomizedRingtone();
    } else if (name === 'ManageNotificationBadges') {
      ManageNotificationBadges();
    } else if (name === 'ManageNotificationWays') {
      ManageNotificationWays();
    } else if (name === 'PublishNotification') {
      PublishNotification();
    } else if (name === 'AddWantAgent') {
      AddWantAgent();
    } else if (name === 'UpdateNotification') {
      UpdateNotification();
    } else if (name === 'CancelNotification') {
      CancelNotification();
    } else if (name === 'ClearDuplicateNotifications') {
      ClearDuplicateNotifications();
    }
  }
}