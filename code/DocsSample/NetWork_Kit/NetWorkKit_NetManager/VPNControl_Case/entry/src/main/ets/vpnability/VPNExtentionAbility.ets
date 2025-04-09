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

import Want from '@ohos.app.ability.Want';
import vpnExt from '@ohos.net.vpnExtension';
import VpnExtensionAbility from '@ohos.app.ability.VpnExtensionAbility';
import vpn_client from 'libentry.so';
import Logger from '../common/Logger';

const tag: string = '[MyVpnExtAbility]';
let gTunFd = -1;
let gTunnelFd = -1;

export default class MyVpnExtAbility extends VpnExtensionAbility {
  private vpnConnection: vpnExt.VpnConnection = vpnExt.createVpnConnection(this.context);
  private vpnServerIp: string = '192.168.xxx.xxx';
  // 统一使用第二段代码中的IP地址，可按需调整
  private tunIp: string = '10.0.0.5'; // 示例地址，代表客户端设备在虚拟网络中的地址
  private blockedAppName: string = 'com.example.testvpn';

  onCreate(want: Want) {
    super.onCreate(want);
    Logger.info(tag, 'onCreate called');
    // 确保 context 有效
    if (this.context) {
      Logger.info('Context is valid, initializing VpnConnection');
      this.vpnConnection = vpnExt.createVpnConnection(this.context);
    } else {
      Logger.error('Context is invalid, cannot create VpnConnection');
    }
    Logger.info(tag, `xdw onCreate, want: ${want.abilityName}`);
    this.vpnConnection = vpnExt.createVpnConnection(this.context);
    Logger.info('wmw createVpnConnection success');
    this.CreateTunnel();
    this.Protect();
    Logger.info('xdw step4');
  }

  onRequest(want: Want, startId: number) {
    Logger.info(tag, `xdw onRequest, want: ${want.abilityName}`);
  }

  onConnect(want: Want) {
    Logger.info(tag, `xdw onConnect, want: ${want.abilityName}`);
    // 返回ServiceExtImpl对象，客户端获取后便可以与ServiceExtensionAbility进行通信
    let abilityName = want.parameters?.abilityName.toString();
    let bundleName = want.parameters?.bundleName.toString();
    return null;
  }

  onDisconnect(want: Want) {
    Logger.info(tag, `xdw onDisconnect, want: ${want.abilityName}`);
  }

  onDestroy() {
    Logger.info(tag, `xdw onDestroy`);
    this.Destroy();
  }

  Destroy() {
    Logger.info('developTag', '%{public}s', 'vpn Destroy');
    // 关闭VPN
    this.vpnConnection.destroy().then(() => {
      Logger.info('developTag', '%{public}s', 'vpn Destroy Success');
    }).catch((err: Error) => {
      Logger.error('developTag', 'vpn Destroy Failed: %{public}s', JSON.stringify(err) ?? '');
    });
  }

  // 创建隧道的方法
  CreateTunnel() {
    Logger.info('xdw step1');
    gTunnelFd = vpn_client.udpConnect(this.vpnServerIp, 1194);
    if (gTunnelFd < 0) {
      Logger.error(tag, 'Failed to create UDP tunnel');
      return;
    }
    Logger.info(tag, `Tunnel created, FD: ${gTunnelFd}`);
    this.Protect();
  }

  // 保护隧道的方法
  Protect() {
    console.info('xdw step2');
    Logger.info('developTag', '%{public}s', 'vpn Protect');
    this.vpnConnection.protect(gTunnelFd).then(() => {
      Logger.info('developTag', '%{public}s', 'vpn Protect Success');
      this.SetupVpn();
    }).catch((err: Error) => {
      Logger.error('developTag', 'vpn Protect Failed %{public}s', JSON.stringify(err) ?? '');
    })
  }

  // 设置VPN网络配置的方法
  SetupVpn() {
    console.info('xdw step3');
    Logger.info('developTag', '%{public}s', 'vpn SetupVpn');

    class Address {
      public address: string;
      public family: number;
      constructor(address: string, family: number) {
        this.address = address;
        this.family = family;
      }
    }

    class AddressWithPrefix {
      public address: Address;
      public prefixLength: number;
      constructor(address: Address, prefixLength: number) {
        this.address = address;
        this.prefixLength = prefixLength;
      }
    }

    class Config {
      public addresses: AddressWithPrefix[];
      public dnsAddresses: string[];
      public trustedApplications: string[];
      public blockedApplications: string[];
      constructor(
        tunIp: string,
        blockedAppName: string
      ) {
        this.addresses = [
          new AddressWithPrefix(new Address(tunIp, 1), 24)
        ];
        this.dnsAddresses = ['114.114.114.114']; // 通用DNS地址
        this.trustedApplications = [];
        this.blockedApplications = [];
      }
    }

    let config = new Config(this.tunIp, this.blockedAppName);

    try {
      this.vpnConnection.create(config).then((data) => {
        gTunFd = data;
        Logger.error('developTag', 'tunfd: %{public}s', JSON.stringify(data) ?? '');
        vpn_client.startVpn(gTunFd, gTunnelFd);
      })
    } catch (error) {
      Logger.error('developTag', 'vpn setUp fail: %{public}s', JSON.stringify(error) ?? '');
    }
  }
}