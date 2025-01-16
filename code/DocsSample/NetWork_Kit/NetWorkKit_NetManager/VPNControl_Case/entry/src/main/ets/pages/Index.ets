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

import router from '@ohos.router';
import { BusinessError } from '@ohos.base';
import { ComponentId } from '../common/CommonConstant';
import Logger from '../common/Logger';
import { notificationUtil } from '../notification/NotificationUtil';

// 常量定义
const TITLE_FONT_SIZE = 35; // 标题字体大小
const BUTTON_FONT_SIZE = 45; // 按钮字体大小
const BUTTON_MARGIN = 16; // 按钮边距

@Entry
@Component
struct Index {
  @State message: string = 'VPN';
  @State flag: string = 'wait';


  aboutToAppear(): void {
    notificationUtil.enableNotification();
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(TITLE_FONT_SIZE)
          .fontWeight(FontWeight.Bold)
          .id(this.flag)
          .onClick(() => {
            Logger.info('developTag', '%{public}s', 'vpn Client');
          })

        // Start VPN 按钮
        Button('Start VPN')
          .onClick(() => {
            Logger.info('developTag', '%{public}s', 'Succeeded in clicking the button.');
            router.pushUrl({ url: 'pages/StartVpn' }).then(() => {
              Logger.info('developTag', '%{public}s', 'Succeeded in jumping to the second page.');
              this.flag = 'Pass';
            }).catch((err: BusinessError) => {
              Logger.error('developTag', 'Failed to jump to the second page: %{public}s',
                JSON.stringify(err) ?? '');
              this.flag = 'Error';
            });
          })
          .id(ComponentId.START_VPN_BUTTON)
          .width('70%')
          .fontSize(BUTTON_FONT_SIZE)
          .margin(BUTTON_MARGIN)

        // Stop VPN 按钮
        Button('Stop VPN')
          .onClick(() => {
            Logger.info('developTag', '%{public}s', 'Succeeded in clicking the button.');
            router.pushUrl({ url: 'pages/StopVpn' }).then(() => {
              Logger.info('developTag', '%{public}s', 'Succeeded in jumping to the second page.');
              this.flag = 'Pass';
            }).catch((err: BusinessError) => {
              Logger.error('developTag', 'Failed to jump to the second page: %{public}s',
                JSON.stringify(err) ?? '');
              this.flag = 'Error';
            });
          })
          .id(ComponentId.STOP_VPN_BUTTON)
          .width('70%')
          .fontSize(BUTTON_FONT_SIZE)
      }.width('100%')
    }.height('100%')
  }
}
