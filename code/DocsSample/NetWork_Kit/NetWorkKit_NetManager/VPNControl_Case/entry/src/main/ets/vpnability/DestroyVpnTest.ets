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

// [Start destroy_vpn_ability]
import VpnExtensionAbility from '@ohos.app.ability.VpnExtensionAbility';
import { vpnExtension } from '@kit.NetworkKit';

export class VpnTest extends VpnExtensionAbility {
  public vpnId: string = 'test_vpn_id';
  public vpnConnection: vpnExtension.VpnConnection | undefined;

  destroy() {
    // [StartExclude destroy_vpn_ability]
    try {
      // [EndExclude destroy_vpn_ability]
      this.vpnConnection = vpnExtension.createVpnConnection(this.context);
      console.info('create success');
      this.vpnConnection?.destroy(this.vpnId);
      // [StartExclude destroy_vpn_ability]
      return true;
    } catch (e) {
      return false;
    }
    // [EndExclude destroy_vpn_ability]
  }
};

// [End destroy_vpn_ability]