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

import Logger from '../model/Logger';
import window from '@ohos.window';

@Component
export struct LockSwitch {
  private isLock: boolean = false
  @Link isComTime: boolean;
  private isKeepScreenOn: boolean = false;

  build() {
    Flex({ justifyContent: FlexAlign.SpaceBetween, alignItems: ItemAlign.Center }) {
      Text($r('app.string.screenLight')).fontSize(18)

      Toggle({ type: ToggleType.Switch, isOn: this.isLock })
        .id('screenLight')
        .onChange(() => {
          this.isLock = !(this.isLock)
          let windowClass: window.Window | undefined = AppStorage.Get('windowClass');
          if (this.isLock === true) {
            // 打开常亮
            this.isKeepScreenOn = true;
            try {
              let promise = windowClass.setWindowKeepScreenOn(this.isKeepScreenOn);
              promise.then(() => {
                Logger.info('Succeeded in setting the screen to be always on.');
              }).catch((err) => {
                Logger.info(`Failed to set the screen to be always on. Cause code: ${err.code}, message: ${err.message}`);
              });
            } catch (exception) {
              Logger.error(`Failed to set the screen to be always on. Cause code: ${exception.code}, message: ${exception.message}`);
            }
          } else {
            // 关闭常亮
            this.isKeepScreenOn = false;
            try {
              let promise = windowClass.setWindowKeepScreenOn(this.isKeepScreenOn);
              promise.then(() => {
                Logger.info('Succeeded in setting the screen to be always off.');
              }).catch((err) => {
                Logger.info(`Failed to set the screen to be always off. Cause code: ${err.code}, message: ${err.message}`);
              });
            } catch (exception) {
              Logger.error(`Failed to set the screen to be always off. Cause code: ${exception.code}, message: ${exception.message}`);
            }
          }
        })
    }
    .width('100%')
    .margin({ top: 10 })
  }
}