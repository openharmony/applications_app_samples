/*
* Copyright (c) 2024 Huawei Device Co., Ltd.
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

import Want from '@ohos.app.ability.Want';
import VpnExtensionAbility from '@ohos.app.ability.VpnExtensionAbility';
import vpn_client from 'libvpn_client.so';
import vpnExt from '@ohos.net.vpnExtension';
import hilog from '@ohos.hilog';

const TAG: string = "[MyVpnExtAbility]";
let g_tunFd = -1;
let g_tunnelFd = -1;

export default class MyVpnExtAbility extends VpnExtensionAbility {
  private VpnConnection: vpnExt.VpnConnection;
  private vpnServerIp: string = '192.168.31.13';
  private tunIp: string = '10.0.0.5';
  private blockedAppName: string = 'com.example.myvpndemo';

  onCreate(want: Want) {
    console.info(TAG, `onCreate, want: ${want.abilityName}`);
    this.VpnConnection = vpnExt.createVpnConnection(this.context);
    console.info("createVpnConnection success");
    this.CreateTunnel();
    this.Protect();
    this.SetupVpn();
  }

  onRequest(want: Want, startId: number) {
    console.info(TAG, `onRequest, want: ${want.abilityName}`);
  }

  onConnect(want: Want) {
    console.info(TAG, `onConnect, want: ${want.abilityName}`);
    let abilityName: string = want.parameters.abilityName.toString();
    let bundleName: string = want.parameters.bundleName.toString();
    return null;
  }

  onDisconnect(want: Want) {
    console.info(TAG, `onDisconnect, want: ${want.abilityName}`);
  }

  onDestroy() {
    this.Destroy();
    console.info(TAG, `onDestroy`);
  }

  CreateTunnel() {
    console.info("CreateTunnel");
    g_tunnelFd = vpn_client.tcpConnect(this.vpnServerIp, 8888);
  }

  Protect() {
    hilog.info(0x0000, 'developTag', '%{public}s', 'vpn Protect');
    this.VpnConnection.protect(g_tunnelFd).then(() => {
      hilog.info(0x0000, 'developTag', '%{public}s', 'vpn Protect Success');
    }).catch((err: Error) => {
      hilog.error(0x0000, 'developTag', 'vpn Protect Failed %{public}s', JSON.stringify(err) ?? '');
    })
  }

  SetupVpn() {
    hilog.info(0x0000, 'developTag', '%{public}s', 'vpn SetupVpn');

    class Address {
      address: string;
      family: number;

      constructor(address: string, family: number) {
        this.address = address;
        this.family = family;
      }
    }

    class AddressWithPrefix {
      address: Address;
      prefixLength: number;

      constructor(address: Address, prefixLength: number) {
        this.address = address;
        this.prefixLength = prefixLength;
      }
    }

    class Config {
      addresses: AddressWithPrefix[];
      mtu: number;
      dnsAddresses: string[];
      trustedApplications: string[];
      blockedApplications: string[];

      constructor(
        tunIp: string,
        blockedAppName: string
      ) {
        this.addresses = [
          new AddressWithPrefix(new Address(tunIp, 1), 24)
        ];
        this.mtu = 1400;
        this.dnsAddresses = ["114.114.114.114"];
        this.trustedApplications = [];
        this.blockedApplications = [blockedAppName];
      }
    }

    let config = new Config(this.tunIp, this.blockedAppName);

    try {
      this.VpnConnection.create(config).then((data) => {
        g_tunFd = data;
        hilog.error(0x0000, 'developTag', 'tunfd: %{public}s', JSON.stringify(data) ?? '');
        vpn_client.startVpn(g_tunFd, g_tunnelFd);
      })
    } catch (error) {
      hilog.error(0x0000, 'developTag', 'vpn setUp fail: %{public}s', JSON.stringify(error) ?? '');
    }
  }

  Destroy() {
    hilog.info(0x0000, 'developTag', '%{public}s', 'vpn Destroy');
    vpn_client.stopVpn(g_tunnelFd);
    this.VpnConnection.destroy().then(() => {
      hilog.info(0x0000, 'developTag', '%{public}s', 'vpn Destroy Success');
    }).catch((err : Error) => {
      hilog.error(0x0000, 'developTag', 'vpn Destroy Failed: %{public}s', JSON.stringify(err) ?? '');
    })
  }
}