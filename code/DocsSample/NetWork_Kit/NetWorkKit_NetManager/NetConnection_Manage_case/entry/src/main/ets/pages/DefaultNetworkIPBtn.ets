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

// [Start resolve_the_domain_name_and_get_all_ips]
// 从@kit.NetworkKit中导入connection命名空间。
import { connection } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [StartExclude resolve_the_domain_name_and_get_all_ips]

const BUTTON_HEIGHT = 50; // 按钮的高度
const BUTTON_FONT_SIZE = 20; // 按钮的字体大小
const BUTTON_RADIUS = 5; // 按钮的圆角半径
const TEXT_MARGIN_TOP_L = 10; // 长文本的上边距

@Component
export default struct defaultNetworkIPBtn {
  @Link defaultNetworkIPStatus: string;

  build() {
    Column() {
      Button($r('app.string.Get_Default_Network_IP'))
        .onClick(() => {
          this.getDefaultNetworkIP();
        })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: TEXT_MARGIN_TOP_L })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_RADIUS)
        .id('Get_Default_Network_IP')
    }
  }

  getDefaultNetworkIP() {
    this.defaultNetworkIPStatus = 'Retrieving...';
    connection.getDefaultNet().then((data: connection.NetHandle) => {
      if (data.netId === 0) {
        this.defaultNetworkIPStatus = 'No default network';
        console.error('No default network available');
        return;
      }
      // [EndExclude resolve_the_domain_name_and_get_all_ips]
      // 使用默认网络解析主机名以获取所有IP地址
      connection.getAddressesByName('xxxx').then((data: connection.NetAddress[]) => {
        console.info('Successfully retrieved default network IP address: ' + JSON.stringify(data));
        // [StartExclude resolve_the_domain_name_and_get_all_ips]
        this.defaultNetworkIPStatus = 'Retrieved successfully';
        // [EndExclude resolve_the_domain_name_and_get_all_ips]
      })
      // [End resolve_the_domain_name_and_get_all_ips]
        .catch((err: BusinessError) => {
          this.defaultNetworkIPStatus = 'Retrieval failed';
          console.error('Failed to retrieve default network IP address:', JSON.stringify(err));
        });
    }).catch((err: BusinessError) => {
      this.defaultNetworkIPStatus = 'Retrieval failed';
      console.error('Failed to retrieve default network:', JSON.stringify(err));
    });
  }
}
