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

// [Start Dns_GetAddress_Ascii_Import]
import { connection } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
// [End Dns_GetAddress_Ascii_Import]
import { ComponentId } from '../common/CommonConstant';

@Entry
@Component
struct Unicode {
  // [Start Dns_GetAddress_Ascii_Data]
  @State hostVal: string = '';     // 转码之后的主机名
  @State ipResult: string = '';    // 获取的IP地址结果
  private hostName: string = '';   // 初始主机名
  // [End Dns_GetAddress_Ascii_Data]

  // [Start Dns_GetSource]
  aboutToAppear() {
    this.hostName =
      (this.getUIContext().getHostContext() as Context).resourceManager.getStringSync($r('app.string.hostName').id);
  }
  // [End Dns_GetSource]

  // [Start Dns_GetAddress_Ascii_Fun]
  getAddressName(isChange: boolean) {
    this.ipResult = '';
    connection.getDefaultNet().then((netHandle: connection.NetHandle) => {
      if (netHandle.netId === 0) {
        // 当前没有已连接的网络时，netHandler的netId为0，属于异常场景。可根据实际情况添加处理机制。
        return;
      }
      if (isChange) {
        this.hostVal = connection.getDnsAscii(this.hostName);
      } else {
        this.hostVal = '';
      }
      netHandle.getAddressByName(isChange ? this.hostVal : this.hostName,
        (error: BusinessError, data: connection.NetAddress) => {
          if (error) {
            this.ipResult = `Failed to get address. Code:${error.code}, message:${error.message}`;
            hilog.error(0x0000, 'testTag', `Failed to get address. Code:${error.code}, message:${error.message}`);
            return;
          }
          this.ipResult = JSON.stringify(data);
          hilog.info(0x0000, 'testTag', `Succeeded to get data: ${JSON.stringify(data)}`);
        });
    });
  }

  // [End Dns_GetAddress_Ascii_Fun]

  build() {
    RelativeContainer() {
      Column({ space: 20 }) {
        Text('host:' + $r('app.string.hostName'))
          .fontSize(20)
          .alignRules({
            center: { anchor: '__container__', align: VerticalAlign.Center },
            middle: { anchor: '__container__', align: HorizontalAlign.Center }
          })
        Button($r('app.string.UnChangeBtn')).id(ComponentId.UN_CHANGE_GET_IPADDRESS).onClick((event: ClickEvent) => {
          // [Start UnChange_Handle]
          this.getAddressName(false);
          // [End UnChange_Handle]
        })
        Button($r('app.string.ChangeAsciiBtn')).id(ComponentId.GET_ASCII).onClick((event: ClickEvent) => {
          // [Start Change_Handle]
          this.getAddressName(true);
          // [End Change_Handle]
        })
        Text($r('app.string.HostResult'))
          .fontSize(20)
        Text(this.hostVal)
          .fontSize(20)
        Text($r('app.string.result'))
          .fontSize(20)
        Text(this.ipResult)
          .fontSize(20)
        // 将转换为Ascii的host转换回中文域名
        Button($r('app.string.ChangeUnicodeBtn')).id(ComponentId.GET_UNICODE).onClick((event: ClickEvent) => {
          // [Start Change_Unicode_Handle]
          this.hostVal = connection.getDnsUnicode(this.hostVal);
          // [End Change_Unicode_Handle]
        })
      }
      .width('100%')
      .height('100%')
      .justifyContent(FlexAlign.Center)
      .alignItems(HorizontalAlign.Center)

    }
    .height('100%')
    .width('100%')
  }
}
