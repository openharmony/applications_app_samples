/*
* Copyright (c) 2023 Huawei Device Co., Ltd.
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

import hilog from '@ohos.hilog';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';
import Want from '@ohos.app.ability.Want';

@Entry
@Component
struct Index {
  @State message: string = 'Toy VPN';

  // 拉起vpn_foundation指定页面
  startVPNFoundation(pagePath: string) {
    let context: common.UIAbilityContext | undefined = AppStorage.get('context');
    let want: Want = {
      bundleName: "com.samples.vpn_foundation",
      abilityName: "EntryAbility",
      parameters: {
        page: pagePath
      }
    };
    context && context.startAbility(want, (err: BusinessError) => {
        if (err.code) {
          hilog.error(0x0000, '[Sample_VPN]', '%{public}s', `Failed to startAbility. Code: ${err.code}, message: ${err.message}`);
        }
      }
    );
  }

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(35)
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            hilog.info(0x0000, 'developTag', '%{public}s', 'vpn Client');
          })
        Button('Start VPN').onClick(() => {
          hilog.info(0x0000, 'developTag', '%{public}s', 'Succeeded in clicking the button.');
          this.startVPNFoundation('pages/StartVpn');
        }).width('70%').fontSize(45).margin(16)
        Button('Stop VPN').onClick(() => {
          hilog.info(0x0000, 'developTag', '%{public}s', 'Succeeded in clicking the button.');
          this.startVPNFoundation('pages/StopVpn');
        }).width('70%').fontSize(45)
      }.width('100%')
    }.height('100%')
  }
}