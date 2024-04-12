/*
 * Copyright (c) 2023-2024 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import CameraService from '../model/CameraService';
import Logger from '../model/Logger';

const TAG = 'MoonCaptureBoostComponent';
const ENABLE_STRING: string = '🌙 on';
const DISABLE_STRING: string = '🌙 off'

@Component
export struct MoonCaptureBoostComponent {
  @StorageLink('moonCaptureComponentEnable') isEnable: boolean = false;
  @StorageLink('moonCaptureComponentIsShow') isShow: boolean = false;

  build() {
    Row() {
      Button() {
        Text(this.isEnable ? ENABLE_STRING : DISABLE_STRING)
          .fontColor('#FFFFFF').fontSize(12)
      }
      .backgroundColor('rgba(255,255,255,0.20)')
      .width('45vp')
      .height('45vp')
      .borderRadius('50px')
      .onClick(() => {
        let enable = !this.isEnable;
        Logger.info(TAG, 'onClick moonCaptureBoostEnable: ' + enable);
        CameraService.setMoonCaptureBoostEnable(enable);
      })
    }
    .visibility(this.isShow ? Visibility.Visible : Visibility.None)
  }
}