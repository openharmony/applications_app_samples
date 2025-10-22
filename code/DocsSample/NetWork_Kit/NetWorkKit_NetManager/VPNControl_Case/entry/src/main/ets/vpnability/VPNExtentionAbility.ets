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
// [Start vpn_control_case_extention_ability]
import { vpnExtension, VpnExtensionAbility } from '@kit.NetworkKit';
import { Want } from '@kit.AbilityKit';

// [StartExclude vpn_control_case_extention_ability]
// vpn_client是一个C语言便携的so，比如import vpn_client from 'libvpn_client.so';
import vpn_client from 'libentry.so';
// [EndExclude vpn_control_case_extention_ability]

const TAG: string = '[MyVpnExtAbility]';
let gTunFd = -1;
let gTunnelFd = -1;

export default class MyVpnExtAbility extends VpnExtensionAbility {
  private vpnConnection: vpnExtension.VpnConnection = vpnExtension.createVpnConnection(this.context);
  private vpnServerIp: string = '192.168.xxx.xxx';
  // 统一使用第二段代码中的IP地址，可按需调整
  private tunIp: string = '10.0.0.5'; // 示例地址，代表客户端设备在虚拟网络中的地址
  private blockedAppName: string = 'com.example.testvpn';

  onCreate(want: Want) {
    // [StartExclude vpn_control_case_extention_ability]
    console.info('onCreate called');
    super.onCreate(want);
    // 确保 context 有效
    if (this.context) {
      console.info('Context is valid, initializing VpnConnection');
      this.vpnConnection = vpnExtension.createVpnConnection(this.context);
    } else {
      console.error('Context is invalid, cannot create VpnConnection');
    }
    // [EndExclude vpn_control_case_extention_ability]
    console.info(`onCreate, want: ${want.abilityName}`);
    this.vpnConnection = vpnExtension.createVpnConnection(this.context);
    console.info('createVpnConnection success');
    this.CreateTunnel();
    this.Protect();
    console.info('step4');
  }

  onRequest(want: Want, startId: number) {
    console.info(`onRequest, want: ${want.abilityName}`);
  }

  onConnect(want: Want) {
    console.info(`onConnect, want: ${want.abilityName}`);
    // 返回ServiceExtImpl对象，客户端获取后便可以与ServiceExtensionAbility进行通信
    let abilityName = want.parameters?.abilityName.toString();
    let bundleName = want.parameters?.bundleName.toString();
    return null;
  }

  onDisconnect(want: Want) {
    console.info(`onDisconnect, want: ${want.abilityName}`);
  }

  onDestroy() {
    console.info(`onDestroy`);
    this.Destroy();
  }

  Destroy() {
    console.info('developTag', '%{public}s', 'vpn Destroy');
    // 关闭VPN
    this.vpnConnection.destroy().then(() => {
      console.info('developTag', '%{public}s', 'vpn Destroy Success');
    }).catch((err: Error) => {
      console.error('developTag', 'vpn Destroy Failed: %{public}s', JSON.stringify(err) ?? '');
    });
  }

  // 创建隧道的方法
  CreateTunnel() {
    console.info('step1');
    // 连接VPN服务器
    // [StartExclude vpn_control_case_extention_ability]
    gTunnelFd = vpn_client.udpConnect(this.vpnServerIp, 1194);
    if (gTunnelFd < 0) {
      console.error('Failed to create UDP tunnel');
      return;
    }
    console.info(`Tunnel created, FD: ${gTunnelFd}`);
    this.Protect();
    // [EndExclude vpn_control_case_extention_ability]
  }

  // 保护隧道的方法
  Protect() {
    console.info('step2');
    console.info('developTag', '%{public}s', 'vpn Protect');
    this.vpnConnection.protect(gTunnelFd).then(() => {
      console.info('developTag', '%{public}s', 'vpn Protect Success');
      this.SetupVpn();
    }).catch((err: Error) => {
      console.error('developTag', 'vpn Protect Failed %{public}s', JSON.stringify(err) ?? '');
    })
  }

  // 设置VPN网络配置的方法
  SetupVpn() {
    console.info('step3');
    console.info('developTag', '%{public}s', 'vpn SetupVpn');

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
      this.vpnConnection.create(config)
      // [StartExclude vpn_control_case_extention_ability]
        .then((data) => {
          gTunFd = data;
          console.error('developTag', 'tunfd: %{public}s', JSON.stringify(data) ?? '');
          vpn_client.startVpn(gTunFd, gTunnelFd);
        })
      // [EndExclude vpn_control_case_extention_ability]
    } catch (error) {
      console.error('developTag', 'vpn setUp fail: %{public}s', JSON.stringify(error) ?? '');
    }
  }
}
// [End vpn_control_case_extention_ability]