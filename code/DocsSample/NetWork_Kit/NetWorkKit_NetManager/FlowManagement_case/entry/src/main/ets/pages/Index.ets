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

import { socket, statistics } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';

const LOG_FONT_SIZE = 15; // 日志文字大小
const LOG_MARGIN = 20; // 日志上边距
const BUTTON_HEIGHT = 50; // 按钮高度
const BUTTON_MARGIN_TOP = 8; // 按钮的上边距
const BUTTON_FONT_SIZE = 24; // 修改按钮文字大小
const TEXT_FONT_SIZE = 32; // 修改标题文字大小
const BUTTON_BORDER_RADIUS = 5; // 圆角大小
const IFACE = 'wlan0'; // 网络接口名
let UID = getContext(this).applicationInfo.uid; // 示例 UID

@Entry
@Component
struct NetworkStatisticsDemo {
  @State logMessage: string = ''; // 用于显示日志的变量

  build() {
    Column() {
      Text($r('app.string.TitleName'))
        .fontSize(TEXT_FONT_SIZE)
        .fontColor(Color.Black)
        .id('title')

      // 显示日志的文本
      Text(this.logMessage)
        .fontSize(LOG_FONT_SIZE)
        .fontColor(Color.Black)
        .margin({ bottom: LOG_MARGIN })
        .textAlign(TextAlign.Center)
        .id('logger-output')

      Button($r('app.string.Get_Designated_Network_Card_Downstream_Traffic'))
        .onClick(() => {
          this.getIfaceRxBytes();
        })
        .id('Button_GetIfaceRxBytes')
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: BUTTON_MARGIN_TOP })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_BORDER_RADIUS)

      Button($r('app.string.Get_Designated_Network_Card_Upstream_Traffic'))
        .onClick(() => {
          this.getIfaceTxBytes();
        })
        .id('Button_GetIfaceTxBytes')
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: BUTTON_MARGIN_TOP })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_BORDER_RADIUS)

      Button($r('app.string.Get_Cellular_Downstream_Traffic'))
        .onClick(() => {
          this.getCellularRxBytes();
        })
        .id('Button_GetCellularRxBytes')
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: BUTTON_MARGIN_TOP })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_BORDER_RADIUS)

      Button($r('app.string.Get_Cellular_Upstream_Traffic'))
        .onClick(() => {
          this.getCellularTxBytes();
        })
        .id('Button_GetCellularTxBytes')
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: BUTTON_MARGIN_TOP })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_BORDER_RADIUS)

      Button($r('app.string.Get_All_Network_Card_Downstream_Traffic'))
        .onClick(() => {
          this.getAllRxBytes();
        })
        .id('Button_GetAllRxBytes')
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: BUTTON_MARGIN_TOP })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_BORDER_RADIUS)

      Button($r('app.string.Get_All_Network_Card_Upstream_Traffic'))
        .onClick(() => {
          this.getAllTxBytes();
        })
        .id('Button_GetAllTxBytes')
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: BUTTON_MARGIN_TOP })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_BORDER_RADIUS)

      Button($r('app.string.Get_Designated_App_Downstream_Traffic'))
        .onClick(() => {
          this.getUidRxBytes();
        })
        .id('Button_GetUidRxBytes')
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: BUTTON_MARGIN_TOP })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_BORDER_RADIUS)

      Button($r('app.string.Get_Designated_App_Upstream_Traffic'))
        .onClick(() => {
          this.getUidTxBytes();
        })
        .id('Button_GetUidTxBytes')
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: BUTTON_MARGIN_TOP })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_BORDER_RADIUS)

      Button($r('app.string.Get_Designated_Socket_Downstream_Traffic'))
        .onClick(() => {
          this.getSockfdRxBytes();
        })
        .id('Button_GetSockfdRxBytes')
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: BUTTON_MARGIN_TOP })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_BORDER_RADIUS)

      Button($r('app.string.Get_Designated_Socket_Upstream_Traffic'))
        .onClick(() => {
          this.getSockfdTxBytes();
        })
        .id('Button_GetSockfdTxBytes')
        .width('80%')
        .height(BUTTON_HEIGHT)
        .margin({ top: BUTTON_MARGIN_TOP })
        .fontColor(Color.White)
        .fontSize(BUTTON_FONT_SIZE)
        .borderRadius(BUTTON_BORDER_RADIUS)
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center);
  }

  // 获取各种实体的流量数据方法
  getIfaceRxBytes() {
    statistics.getIfaceRxBytes(IFACE).then((stats: number) => {
      this.logMessage = `Interface ${IFACE} downstream traffic: ${JSON.stringify(stats)}`;
    }).catch((err: BusinessError) => {
      this.logMessage = `Failed to get downstream traffic for interface ${IFACE}: ${JSON.stringify(err)}`;
    });
  }

  getIfaceTxBytes() {
    statistics.getIfaceTxBytes(IFACE).then((stats: number) => {
      this.logMessage = `Interface ${IFACE} upstream traffic: ${JSON.stringify(stats)}`;
    }).catch((err: BusinessError) => {
      this.logMessage = `Failed to get upstream traffic for interface ${IFACE}: ${JSON.stringify(err)}`;
    });
  }

  getCellularRxBytes() {
    statistics.getCellularRxBytes().then((stats: number) => {
      this.logMessage = `Cellular downstream traffic: ${JSON.stringify(stats)}`;
    }).catch((err: BusinessError) => {
      this.logMessage = `Failed to get cellular downstream traffic: ${JSON.stringify(err)}`;
    });
  }

  getCellularTxBytes() {
    statistics.getCellularTxBytes().then((stats: number) => {
      this.logMessage = `Cellular upstream traffic: ${JSON.stringify(stats)}`;
    }).catch((err: BusinessError) => {
      this.logMessage = `Failed to get cellular upstream traffic: ${JSON.stringify(err)}`;
    });
  }

  getAllRxBytes() {
    statistics.getAllRxBytes().then((stats: number) => {
      this.logMessage = `All interfaces downstream traffic: ${JSON.stringify(stats)}`;
    }).catch((err: BusinessError) => {
      this.logMessage = `Failed to get all interfaces downstream traffic: ${JSON.stringify(err)}`;
    });
  }

  getAllTxBytes() {
    statistics.getAllTxBytes().then((stats: number) => {
      this.logMessage = `All interfaces upstream traffic: ${JSON.stringify(stats)}`;
    }).catch((err: BusinessError) => {
      this.logMessage = `Failed to get all interfaces upstream traffic: ${JSON.stringify(err)}`;
    });
  }

  getUidRxBytes() {
    UID = getContext(this).applicationInfo.uid
    statistics.getUidRxBytes(UID).then((stats: number) => {
      this.logMessage = `Application ${UID} downstream traffic: ${JSON.stringify(stats)}`;
    }).catch((err: BusinessError) => {
      this.logMessage = `Failed to get downstream traffic for app ${UID}: ${JSON.stringify(err)}`;
    });
  }

  getUidTxBytes() {
    statistics.getUidTxBytes(UID).then((stats: number) => {
      this.logMessage = `Application ${UID} upstream traffic: ${JSON.stringify(stats)}`;
    }).catch((err: BusinessError) => {
      this.logMessage = `Failed to get upstream traffic for app ${UID}: ${JSON.stringify(err)}`;
    });
  }

  getSockfdRxBytes() {
    let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
    tcp.getSocketFd().then((sockfd: number) => {
      statistics.getSockfdRxBytes(sockfd).then((stats: number) => {
        this.logMessage = `Socket ${sockfd} downstream traffic: ${JSON.stringify(stats)}`;
      }).catch((err: BusinessError) => {
        this.logMessage = `Failed to get socket downstream traffic: ${JSON.stringify(err)}`;
      });
    }).catch((err: BusinessError) => {
      this.logMessage = `Failed to get socket file descriptor: ${JSON.stringify(err)}`;
    });
  }

  getSockfdTxBytes() {
    let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
    tcp.getSocketFd().then((sockfd: number) => {
      statistics.getSockfdTxBytes(sockfd).then((stats: number) => {
        this.logMessage = `Socket ${sockfd} upstream traffic: ${JSON.stringify(stats)}`;
      }).catch((err: BusinessError) => {
        this.logMessage = `Failed to get socket upstream traffic: ${JSON.stringify(err)}`;
      });
    }).catch((err: BusinessError) => {
      this.logMessage = `Failed to get socket file descriptor: ${JSON.stringify(err)}`;
    });
  }
}
