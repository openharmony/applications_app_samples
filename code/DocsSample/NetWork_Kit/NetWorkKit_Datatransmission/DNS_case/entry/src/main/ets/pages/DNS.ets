/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start Get_Ip_Address_Import]
import { connection } from '@kit.NetworkKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [End Get_Ip_Address_Import]
import { ComponentId } from '../common/CommonConstant';

@Entry
@Component
struct DNS {
  // [Start Dns_Data]
  @State hostName: string = 'www.example.com';
  // [End Dns_Data]

  build() {
    Column({ space: 20 }) {
      Button($r('app.string.getAddressesByName'))
        .id(ComponentId.GET_ADDRESS_BY_NAME)
        .onClick(() => {
          // [Start Get_All_Ip_Address]
          connection.getAddressesByName(this.hostName).then((data: connection.NetAddress[]) => {
            hilog.info(0x0000, 'testTag', `Succeeded to get data: ${JSON.stringify(data)}`);
          })
          // [End Get_All_Ip_Address]
        })

      Button($r('app.string.getAddressesByNameWithOptions'))
        .id(ComponentId.GET_ADDRESS_BY_NAME_WITH_OPTIONS)
        .onClick(() => {
          // [Start Get_Ip_Address_With_Options]
          let options: connection.QueryOptions = {
            family: connection.FamilyType.FAMILY_TYPE_IPV4
          };
          connection.getAddressesByNameWithOptions(this.hostName, options).then((data: connection.NetAddress[]) => {
            hilog.info(0x0000, 'testTag', `Succeeded to get data: ${JSON.stringify(data)}`);
          });
          // [End Get_Ip_Address_With_Options]
        })

      Button($r('app.string.NetHandleBtn'))
        .id(ComponentId.NET_HANDLE)
        .onClick(() => {
          // [Start Get_NetHandle_Ip]
          let netSpecifier: connection.NetSpecifier = {
            netCapabilities: {
              // 假设当前默认网络是WiFi，需要创建蜂窝网络连接，可指定网络类型为蜂窝网。
              bearerTypes: [connection.NetBearType.BEARER_CELLULAR],
              // 指定网络能力为Internet。
              networkCap: [connection.NetCap.NET_CAPABILITY_INTERNET]
            },
          };

          // 指定超时时间为10s(默认值为0)。
          let timeout = 10 * 1000;

          // 创建NetConnection对象。
          let conn = connection.createNetConnection(netSpecifier, timeout);
          // 订阅事件，如果当前指定网络可用，通过on_netAvailable通知用户。
          conn.on('netAvailable', ((handle: connection.NetHandle) => {
            let options: connection.QueryOptions = {
              family: connection.FamilyType.FAMILY_TYPE_IPV4
            }
            // 当指定网络可用时，使用该网络连接解析主机名，并仅获取IPv4类型的地址
            handle.getAddressesByNameWithOptions(this.hostName, options).then((data: connection.NetAddress[]) => {
              hilog.info(0x0000, 'testTag', `Succeeded to get data: ${JSON.stringify(data)}`);
            })
          }));
          // 订阅事件，如果当前指定网络不可用，通过on_netUnavailable通知用户。
          conn.on('netUnavailable', ((data: void) => {
            hilog.info(0x0000, 'testTag', `net is unavailable, data is ${JSON.stringify(data)}`);
          }));
          // [End Get_NetHandle_Ip]
        })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
  }
}

