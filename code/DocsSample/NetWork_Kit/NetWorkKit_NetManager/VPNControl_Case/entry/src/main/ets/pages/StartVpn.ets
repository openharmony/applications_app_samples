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

import vpn_client from 'libentry.so';
import common from '@ohos.app.ability.common';
import vpnext from '@ohos.net.vpnExtension';
import Want from '@ohos.app.ability.Want';
import { showToast } from '../common/ShowToast';
import { BusinessError } from '@kit.BasicServicesKit';
import { ComponentId } from '../common/CommonConstant'; // 引入枚举
import TitleBar from '../common/component';
import Logger from '../common/Logger';
import NotificationOperations from '../notification/NotificationOperations';

// 提取常量
const TITLE_FONT_SIZE = 35; // 标题字体大小
const LABEL_FONT_SIZE = 20; // 标签字体大小
const BUTTON_FONT_SIZE = 25; // 按钮字体大小
const INPUT_MARGIN = 2; // 输入框边距
const BUTTON_SUCCESS_MESSAGE = 4000; // Toast 显示时间
const BUTTON_MARGIN = 16;

let want: Want = {
  deviceId: '',
  bundleName: 'com.samples.vpncontrol_case',
  abilityName: 'MyVpnExtAbility',
};

let g_tunFd = -1;
let g_tunnelFd = -1;

@Entry
@Component
struct StartVpn {
  @State message: string = 'VPN';
  @State vpnServerIp: string = '192.168.xxx.xxx'; // 示例服务端地址，若有vpn服务器可填写实际服务器ip
  @State tunIp: string = '10.0.0.5';  // 示例地址，代表客户端设备在虚拟网络中的地址
  @State prefix: string = '24';
  @State blockedAppName: string = 'com.example.baidumyapplication'; // 示例
  @State flag: string = 'wait';
  private context = getContext(this) as common.VpnExtensionContext;
  private vpnConnection: vpnext.VpnConnection = vpnext.createVpnConnection(this.context);

  private notificationOperations: NotificationOperations = new NotificationOperations(getContext(this));

  CreateTunnel() {
    g_tunnelFd = vpn_client.udpConnect(this.vpnServerIp, 8888);
    if (g_tunnelFd) {
      showToast('CreateTunnel Success', BUTTON_SUCCESS_MESSAGE);
      Logger.info('developTag', '%{public}s', 'CreateTunnel Success');
      this.flag = 'Pass';
    } else {
      showToast('CreateTunnel Fail', BUTTON_SUCCESS_MESSAGE);
      Logger.error('developTag', 'CreateTunnel Fail %{public}s', 'CreateTunnel Fail');
      this.flag = 'Error';
    }
  }

  Protect() {
    Logger.info('developTag', '%{public}s', 'vpn Protect');
    this.vpnConnection.protect(g_tunnelFd).then(() => {
      showToast('vpn Protect Success', BUTTON_SUCCESS_MESSAGE);
      Logger.info('developTag', '%{public}s', 'vpn Protect Success');
      this.flag = 'Pass';
    }).catch((err: Error) => {
      showToast('vpn Protect Failed: ' + JSON.stringify(err), BUTTON_SUCCESS_MESSAGE);
      Logger.error('developTag', 'vpn Protect Failed %{public}s', JSON.stringify(err) ?? '');
      this.flag = 'Error';
    });
  }

  SetupVpn() {
    Logger.info('developTag', '%{public}s', 'vpn SetupVpn');

    // 定义 Address 类，表示 IP 地址和地址族
    class Address {
      address: string;  // 存储 IP 地址
      family: number;   // 地址族，1 表示 IPv4，2 表示 IPv6
      constructor(address: string, family: number) {
        this.address = address;
        this.family = family;
      }
    }

    // 定义 AddressWithPrefix 类，表示地址和网络前缀长度
    // 例如，"10.0.0.5" 地址与 "24" 前缀结合，表示 10.0.0.5/24 的网络
    class AddressWithPrefix {
      address: Address;      // 地址对象
      prefixLength: number;  // 网络前缀长度（例如，24 表示子网掩码为 255.255.255.0）
      constructor(address: Address, prefixLength: number) {
        this.address = address;
        this.prefixLength = prefixLength;
      }
    }

    // 定义目标地址的接口类型
    interface DestinationItem {
      address: Address;     // 目标地址
      prefixLength: number; // 目标地址的前缀长度（子网掩码）
      port: number;         // 目标端口
    }

    // 定义网关的接口类型
    interface GatewayItem {
      address: string;      // 网关地址
      family: number;       // 网关地址族，1 表示 IPv4，2 表示 IPv6
      port: number;         // 网关端口
    }

    // 定义路由配置的接口类型
    interface RouteConfig {
      interface: string;            // VPN 虚拟接口名称（如 vpn-tun）
      destination: DestinationItem; // 目标地址配置
      gateway: GatewayItem;        // 网关配置
      hasGateway: boolean;          // 是否存在网关
      isDefaultRoute: boolean;      // 是否为默认路由
    }

    // 配置 VPN 设置的类
    class Config {
      addresses: AddressWithPrefix[];  // VPN 虚拟网卡的 IP 地址
      mtu: number;                     // 最大传输单元，决定每个数据包的最大大小
      dnsAddresses: string[];          // DNS 服务器的 IP 地址
      trustedApplications: string[];   // 受信任的应用程序（可通过 VPN 使用）
      blockedApplications: string[];   // 不允许通过 VPN 使用的应用程序
      routes: RouteConfig[];           // 路由配置

      // 构造函数，初始化 VPN 配置
      constructor(tunIp: string, blockedAppName: string) {
        // 设置虚拟网卡的 IP 地址，这里使用一个 IPv4 地址和前缀长度 24（即 255.255.255.0）
        this.addresses = [
          new AddressWithPrefix(new Address(tunIp, 1), 24)  // 这里的 `1` 是 IPv4 的地址族
        ];
        this.mtu = 1400;  // 设置最大传输单元（MTU），通常用于 VPN 隧道数据包的大小限制
        this.dnsAddresses = ['114.114.114.114'];  // 设置 DNS 服务器地址
        this.trustedApplications = [];  // 初始化为空数组，受信任的应用程序
        this.blockedApplications = [blockedAppName];  // 被阻止的应用是传入的 `blockedAppName`

        // 配置路由：这里配置了一个默认路由和目标地址的路由
        this.routes = [
          {
            interface: 'vpn-tun',  // 虚拟接口名称（通过 VPN 隧道通信的接口）
            destination: {
              address: new Address('10.0.0.8', 1),  // 示例目标地址
              prefixLength: 24,  // 目标网络的子网掩码
              port: 8080  // 目标端口
            },
            gateway: {
              address: '10.0.0.5',  // 示例网关地址
              family: 1,  // 地址族（IPv4）
              port: 8080  // 网关端口
            },
            hasGateway: true,  // 该路由有网关
            isDefaultRoute: true  // 该路由是默认路由
          }
        ];
      }
    }

    // 使用上述配置创建 VPN 配置对象
    let config = new Config(this.tunIp, this.blockedAppName);

    // 创建 VPN 连接并应用配置
    this.vpnConnection.create(config).then((data) => {
      g_tunFd = data;  // 获取到的虚拟网络接口文件描述符
      Logger.info('developTag', 'tunfd: %{public}s', JSON.stringify(data) ?? '');

      // 启动 VPN 连接，传入隧道文件描述符和虚拟网络接口文件描述符
      vpn_client.startVpn(g_tunFd, g_tunnelFd);
      showToast('VPN started successfully', BUTTON_SUCCESS_MESSAGE);
      Logger.info('developTag', '%{public}s', 'vpn start Success');
      this.flag = 'Pass';  // 设置状态为成功

      this.notificationOperations.publishNotificationWithWantAgent();
    }).catch((err: BusinessError) => {
      // 如果 VPN 创建失败，捕获异常并处理
      showToast('VPN start failed: ' + JSON.stringify(err), BUTTON_SUCCESS_MESSAGE);
      Logger.error('developTag', 'vpn start Fail %{public}s', JSON.stringify(err) ?? '');
      this.flag = 'Error';  // 设置状态为失败
    });
  }


  build() {
    Row() {
      Column() {
        TitleBar({ hasBackPress: true, title: 'BACK' })
        Text(this.message)
          .fontSize(TITLE_FONT_SIZE)
          .fontWeight(FontWeight.Bold)
          .id(this.flag)
          .onClick(() => {
            Logger.info('developTag', '%{public}s', 'vpn Client');
          })

        Row() {
          Text('server ip')
            .fontSize(LABEL_FONT_SIZE)
            .width('40%')
            .textAlign(TextAlign.Center)
            .backgroundColor(0xAFEEEE);
          TextInput({ text: '192.168.xxx.xxx' })
            .onChange((value) => {
              this.vpnServerIp = value;
            })
            .width('60%')
            .margin(INPUT_MARGIN)
        }.width('90%');

        Row() {
          Text('tun ip')
            .fontSize(LABEL_FONT_SIZE)
            .width('40%')
            .textAlign(TextAlign.Center)
            .backgroundColor(0xAFEEEE);
          TextInput({ text: '10.0.0.5' })
            .onChange((value) => {
              this.tunIp = value;
            })
            .width('60%')
            .margin(INPUT_MARGIN)
        }.width('90%')

        Row() {
          Text('blockedApp')
            .fontSize(LABEL_FONT_SIZE)
            .width('40%')
            .textAlign(TextAlign.Center)
            .backgroundColor(0xAFEEEE)
          TextInput({ text: 'com.example.baidumyapplication' })
            .onChange((value) => {
              this.blockedAppName = value;
            })
            .width('60%')
            .margin(INPUT_MARGIN)
        }.width('90%')

        Button($r('app.string.CreateTunnel'))
          .onClick(() => {
            this.CreateTunnel();
          })
          .width('70%')
          .id(ComponentId.CREATE_TUNNEL_BUTTON)
          .fontSize(BUTTON_FONT_SIZE)
          .margin(BUTTON_MARGIN);
        Button($r('app.string.Protect'))
          .onClick(() => {
            this.Protect();
          })
          .width('70%')
          .id(ComponentId.PROTECT_BUTTON)
          .fontSize(BUTTON_FONT_SIZE)
          .margin(BUTTON_MARGIN);
        // [Start start_vpn_extension_ability]
        Button($r('app.string.start_vpnExt'))
          .onClick(() => {
            try {
              vpnext.startVpnExtensionAbility(want).then(() => {
                showToast('start vpnExt Success', BUTTON_SUCCESS_MESSAGE);
                Logger.info('developTag', '%{public}s', 'start vpnExt Success');
                this.flag = 'Pass';
              })
            } catch (err) {
              showToast('start vpnExt Fail: ' + JSON.stringify(err), BUTTON_SUCCESS_MESSAGE);
              Logger.error('developTag', 'start vpnExt Fail %{public}s', JSON.stringify(err) ?? '');
              this.flag = 'Error';
            }
          })
          .width('70%')
          .id(ComponentId.START_VPN_EXT_BUTTON)
          .fontSize(BUTTON_FONT_SIZE)
          .margin(BUTTON_MARGIN)
        // [End start_vpn_extension_ability]
        Button($r('app.string.SetupVpn'))
          .onClick(() => {
            this.SetupVpn();
          })
          .width('70%')
          .id(ComponentId.SETUP_VPN_BUTTON)
          .fontSize(BUTTON_FONT_SIZE)
          .margin(BUTTON_MARGIN);
      }.width('100%');
    }.height('100%');

  }
}
