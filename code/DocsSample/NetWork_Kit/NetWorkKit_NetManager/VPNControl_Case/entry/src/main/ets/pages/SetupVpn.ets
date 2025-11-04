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

// [Start vpn_config_import]
import { vpnExtension } from '@kit.NetworkKit';
import { common } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [End vpn_config_import]
import { ComponentId } from '../common/CommonConstant'; // 引入枚举
import { BusinessError } from '@kit.BasicServicesKit';
import { showToast } from '../common/ShowToast';
import vpn_client from 'libentry.so';
import NotificationOperations from '../notification/NotificationOperations';

const buttonFontSize = 25; // 按钮的字体大小
const buttonMargin = 16;
let gTunFd = -1;
let gTunnelFd = -1;
let notificationOperations: NotificationOperations = new NotificationOperations(getContext(this));

let tunIp: string = '10.0.0.5';  // 示例地址，代表客户端设备在虚拟网络中的地址
let blockedAppName: string = 'com.example.baidumyapplication'; // 示例
// [Start vpn_config_parameters]
let context = getContext(this) as common.VpnExtensionContext;
let vpnConnection: vpnExtension.VpnConnection = vpnExtension.createVpnConnection(context);

// [StartExclude vpn_config_parameters]
@Component
export default struct allNetworksBtn {
  @Link flag: string;

  build() {
    Column() {
      Button($r('app.string.SetupVpn'))
        .onClick(() => {
          this.SetupVpn();
        })
        .width('70%')
        .id(ComponentId.SETUP_VPN_BUTTON)
        .fontSize(buttonFontSize)
        .margin(buttonMargin);
    }
  }

  SetupVpn() {
    hilog.info(0x0000, 'testTag', 'developTag', '%{public}s', 'vpn SetupVpn');

    // 定义 Address 类，表示 IP 地址和地址族
    class Address {
      public address: string;  // 存储 IP 地址
      public family: number;   // 地址族，1 表示 IPv4，2 表示 IPv6
      constructor(address: string, family: number) {
        this.address = address;
        this.family = family;
      }
    }

    // 定义 AddressWithPrefix 类，表示地址和网络前缀长度
    // 例如，'10.0.0.5' 地址与 '24' 前缀结合，表示 10.0.0.5/24 的网络
    class AddressWithPrefix {
      public address: Address;      // 地址对象
      public prefixLength: number;  // 网络前缀长度（例如，24 表示子网掩码为 255.255.255.0）
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
      public addresses: AddressWithPrefix[];  // VPN 虚拟网卡的 IP 地址
      public mtu: number;                     // 最大传输单元，决定每个数据包的最大大小
      public dnsAddresses: string[];          // DNS 服务器的 IP 地址
      public trustedApplications: string[];   // 受信任的应用程序（可通过 VPN 使用）
      public blockedApplications: string[];   // 不允许通过 VPN 使用的应用程序
      public routes: RouteConfig[];           // 路由配置

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
    let vpnConfig = new Config(tunIp, blockedAppName);
    // [EndExclude vpn_config_parameters]
    // 创建 VPN 连接并应用配置
    vpnConnection.create(vpnConfig).then((data) => {
      hilog.info(0x0000, 'testTag', 'vpn create ' + JSON.stringify(data));
      // [StartExclude vpn_config_parameters]
      gTunFd = data;  // 获取到的虚拟网络接口文件描述符
      hilog.info(0x0000, 'testTag', 'developTag', 'tunfd: %{public}s', JSON.stringify(data) ?? '');

      // 启动 VPN 连接，传入隧道文件描述符和虚拟网络接口文件描述符
      vpn_client.startVpn(gTunFd, gTunnelFd);
      showToast('VPN started successfully', 4000);
      hilog.info(0x0000, 'testTag', 'developTag', '%{public}s', 'vpn start Success');
      this.flag = 'Pass';  // 设置状态为成功

      notificationOperations.publishNotificationWithWantAgent();
      // [EndExclude vpn_config_parameters]
    })
    // [StartExclude vpn_config_parameters]
      .catch((err: BusinessError) => {
      // 如果 VPN 创建失败，捕获异常并处理
      showToast('VPN start failed: ' + JSON.stringify(err), 4000);
      hilog.error(0x0000, 'testTag', 'developTag', 'vpn start Fail %{public}s', JSON.stringify(err) ?? '');
      this.flag = 'Error';  // 设置状态为失败
    });
    // [EndExclude vpn_config_parameters]
  }
  // [End vpn_config_parameters]
}
