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

// [Start get_vpn_id_ability]
import VpnExtensionAbility from '@ohos.app.ability.VpnExtensionAbility';
import { vpnExtension } from '@kit.NetworkKit';

export class VpnTest extends VpnExtensionAbility {
  public vpnId: string = '';

  getVpnId() {
    // [StartExclude get_vpn_id_ability]
    try {
    // [EndExclude get_vpn_id_ability]
      let vpnConnection = vpnExtension.createVpnConnection(this.context);
      vpnConnection?.generateVpnId().then((data) => {
        if (data) {
          this.vpnId = data;
        }
      });
    // [StartExclude get_vpn_id_ability]
      return this.vpnId;
    } catch (e) {
      return this.vpnId;
    }
    // [EndExclude get_vpn_id_ability]
  }
};
// [End get_vpn_id_ability]
