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

import { hilog } from '@kit.PerformanceAnalysisKit';
// [Start get_all_registered_networks]
// 从@kit.NetworkKit中导入connection命名空间。
import { connection } from '@kit.NetworkKit';
// [StartExclude get_all_registered_networks]
const BUTTON_HEIGHT = 50; // 按钮的高度
const BUTTON_FONT_SIZE = 20; // 按钮的字体大小
const BUTTON_RADIUS = 5; // 按钮的圆角半径
const TEXT_MARGIN_TOP_L = 10; // 长文本的上边距

// 构造单例对象
export class GlobalContext {
  private static instance: GlobalContext;
  public netList: connection.NetHandle[] = [];
  public netHandle: connection.NetHandle | null = null;
  private _objects = new Map<string, Object>();

  private constructor() {
  }

  public static getContext(): GlobalContext {
    if (!GlobalContext.instance) {
      GlobalContext.instance = new GlobalContext();
    }
    return GlobalContext.instance;
  }

  getObject(value: string): Object | undefined {
    return this._objects.get(value);
  }

  setObject(key: string, objectClass: Object): void {
    this._objects.set(key, objectClass);
  }
}

@Component
export default struct AllNetworksBtn {
  @Link getAllNetsStatus: string;

  build() {
    Column() {
      Button($r('app.string.Network_connection_information'))
        .onClick(() => {
          this.getAllNetworks();
        })
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: TEXT_MARGIN_TOP_L })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_RADIUS)
        .id('Get_Connected_Network')
    }
  }

  // 获取所有注册的网络
  getAllNetworks() {
    // [EndExclude get_all_registered_networks]
    // 调用getAllNets,获取所有处于连接状态的网络列表(Array<NetHandle>)
    connection.getAllNets().then((data: connection.NetHandle[]) => {
      hilog.info(0x0000, 'testTag', 'getAllNets get data: ' + JSON.stringify(data));
      if (data) {
        // [StartExclude get_all_registered_networks]
        this.getAllNetsStatus = 'Retrieved successfully';
        // [EndExclude get_all_registered_networks]
        GlobalContext.getContext().netList = data;
        // [StartExclude get_all_registered_networks]
        let itemNumber: Set<connection.NetHandle> = new Set(data);
        let dataNumber = Array.from(itemNumber.values());
        for (let item of dataNumber) {
          // 循环获取网络列表每个netHandle对应网络的能力信息
          connection.getNetCapabilities(item).then((data: connection.NetCapabilities) => {
            hilog.info(0x0000, 'testTag', 'getNetCapabilities get data: ' + JSON.stringify(data));
          });

          // 循环获取网络列表每个netHandle对应的网络的连接信息
          connection.getConnectionProperties(item).then((data: connection.ConnectionProperties) => {
            hilog.info(0x0000, 'testTag', 'getConnectionProperties get data: ' + JSON.stringify(data));
          });
        }
        // [EndExclude get_all_registered_networks]
      }
    });
    // [End get_all_registered_networks]
  }
}
