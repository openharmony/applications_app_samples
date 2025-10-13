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

// [Start flow_management_case_module_import]
import { socket, statistics } from '@kit.NetworkKit';
import { BusinessError } from '@kit.BasicServicesKit';
// [End flow_management_case_module_import]

const LOG_FONT_SIZE = 15; // 日志文字大小
const LOG_MARGIN = 20; // 日志上边距
const BUTTON_HEIGHT = 50; // 按钮高度
const BUTTON_MARGIN_TOP = 8; // 按钮的上边距
const BUTTON_FONT_SIZE = 24; // 修改按钮文字大小
const TEXT_FONT_SIZE = 32; // 修改标题文字大小
const BUTTON_BORDER_RADIUS = 5; // 圆角大小

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

// [Start obtain_realtime_traffic_statistics_of_network_interface_cards/uid]
  // 获取各种实体的流量数据方法
  getIfaceRxBytes() {
    // [Start flow_management_getIfaceRxBytes_and_getIfaceTxBytes]
    // wlan0为主WiFi网卡名，获取主WiFi实时下行流量数据。
    statistics.getIfaceRxBytes('wlan0').then((stats: number) => {
      console.info(JSON.stringify(stats));
      // [StartExclude flow_management_getIfaceRxBytes_and_getIfaceTxBytes]
      this.logMessage = `Interface wlan0 downstream traffic: ${JSON.stringify(stats)}`;
      // [EndExclude flow_management_getIfaceRxBytes_and_getIfaceTxBytes]
    })
    // [StartExclude flow_management_getIfaceRxBytes_and_getIfaceTxBytes]
    .catch((err: BusinessError) => {
      this.logMessage = `Failed to get downstream traffic for interface wlan0: ${JSON.stringify(err)}`;
    });
  }

  getIfaceTxBytes() {
    // [EndExclude flow_management_getIfaceRxBytes_and_getIfaceTxBytes]
    // wlan0为主WiFi网卡名，获取主WiFi实时上行流量数据。
    statistics.getIfaceTxBytes('wlan0').then((stats: number) => {
      console.info(JSON.stringify(stats));
      // [StartExclude flow_management_getIfaceRxBytes_and_getIfaceTxBytes]
      this.logMessage = `Interface wlan0 upstream traffic: ${JSON.stringify(stats)}`;
      // [EndExclude flow_management_getIfaceRxBytes_and_getIfaceTxBytes]
    })
    // [StartExclude flow_management_getIfaceRxBytes_and_getIfaceTxBytes]
    .catch((err: BusinessError) => {
      this.logMessage = `Failed to get upstream traffic for interface wlan0: ${JSON.stringify(err)}`;
    });
  }
  // [EndExclude flow_management_getIfaceRxBytes_and_getIfaceTxBytes]
  // [End flow_management_getIfaceRxBytes_and_getIfaceTxBytes]

  getCellularRxBytes() {
    // [Start flow_management_getCellularRxBytes_and_getCellularTxBytes]
    // 获取蜂窝实时下行流量数据。
    statistics.getCellularRxBytes().then((stats: number) => {
      console.info(JSON.stringify(stats));
      // [StartExclude flow_management_getCellularRxBytes_and_getCellularTxBytes]
      this.logMessage = `Cellular downstream traffic: ${JSON.stringify(stats)}`;
      // [EndExclude flow_management_getCellularRxBytes_and_getCellularTxBytes]
    })
    // [StartExclude flow_management_getCellularRxBytes_and_getCellularTxBytes]
    .catch((err: BusinessError) => {
      this.logMessage = `Failed to get cellular downstream traffic: ${JSON.stringify(err)}`;
    });
  }

  getCellularTxBytes() {
    // [EndExclude flow_management_getCellularRxBytes_and_getCellularTxBytes]
    // 获取蜂窝实时上行流量数据。
    statistics.getCellularTxBytes().then((stats: number) => {
      console.info(JSON.stringify(stats));
      // [StartExclude flow_management_getCellularRxBytes_and_getCellularTxBytes]
      this.logMessage = `Cellular upstream traffic: ${JSON.stringify(stats)}`;
      // [EndExclude flow_management_getCellularRxBytes_and_getCellularTxBytes]
    })
    // [StartExclude flow_management_getCellularRxBytes_and_getCellularTxBytes]
    .catch((err: BusinessError) => {
      this.logMessage = `Failed to get cellular upstream traffic: ${JSON.stringify(err)}`;
    });
  }
  // [EndExclude flow_management_getCellularRxBytes_and_getCellularTxBytes]
  // [End flow_management_getCellularRxBytes_and_getCellularTxBytes]

  getAllRxBytes() {
    // [Start flow_management_getAllRxBytes_and_getAllTxBytes]
    // 获取所有网卡实时下行流量数据。
    statistics.getAllRxBytes().then((stats: number) => {
      console.info(JSON.stringify(stats));
      // [StartExclude flow_management_getAllRxBytes_and_getAllTxBytes]
      this.logMessage = `All interfaces downstream traffic: ${JSON.stringify(stats)}`;
      // [EndExclude flow_management_getAllRxBytes_and_getAllTxBytes]
    })
    // [StartExclude flow_management_getAllRxBytes_and_getAllTxBytes]
    .catch((err: BusinessError) => {
      this.logMessage = `Failed to get all interfaces downstream traffic: ${JSON.stringify(err)}`;
    });
  }

  getAllTxBytes() {
    // [EndExclude flow_management_getAllRxBytes_and_getAllTxBytes]
    // 获取所有网卡实时上行流量数据。
    statistics.getAllTxBytes().then((stats: number) => {
      console.info(JSON.stringify(stats));
      // [StartExclude flow_management_getAllRxBytes_and_getAllTxBytes]
      this.logMessage = `All interfaces upstream traffic: ${JSON.stringify(stats)}`;
      // [EndExclude flow_management_getAllRxBytes_and_getAllTxBytes]
    })
    // [StartExclude flow_management_getAllRxBytes_and_getAllTxBytes]
    .catch((err: BusinessError) => {
      this.logMessage = `Failed to get all interfaces upstream traffic: ${JSON.stringify(err)}`;
    });
  }
  // [EndExclude flow_management_getAllRxBytes_and_getAllTxBytes]
  // [End flow_management_getAllRxBytes_and_getAllTxBytes]


  
  getUidRxBytes() {
    // [Start flow_management_getUidRxBytes_and_getUidTxBytes]
    // 获取指定应用实时下行流量数据。
    let UID = getContext(this).applicationInfo.uid
    statistics.getUidRxBytes(UID).then((stats: number) => {
      console.info(JSON.stringify(stats));
      // [StartExclude flow_management_getUidRxBytes_and_getUidTxBytes]
      this.logMessage = `Application ${UID} downstream traffic: ${JSON.stringify(stats)}`;
      // [EndExclude flow_management_getUidRxBytes_and_getUidTxBytes]
    })
    // [StartExclude flow_management_getUidRxBytes_and_getUidTxBytes]
    .catch((err: BusinessError) => {
      this.logMessage = `Failed to get downstream traffic for app ${UID}: ${JSON.stringify(err)}`;
    });
  }

  getUidTxBytes() {
    // [EndExclude flow_management_getUidRxBytes_and_getUidTxBytes]
    // 获取指定应用实时上行流量数据。
    let UID = getContext(this).applicationInfo.uid
    statistics.getUidTxBytes(UID).then((stats: number) => {
      console.info(JSON.stringify(stats));
      // [StartExclude flow_management_getUidRxBytes_and_getUidTxBytes]
      this.logMessage = `Application ${UID} upstream traffic: ${JSON.stringify(stats)}`;
      // [EndExclude flow_management_getUidRxBytes_and_getUidTxBytes]
    })
    // [StartExclude flow_management_getUidRxBytes_and_getUidTxBytes]
    .catch((err: BusinessError) => {
      this.logMessage = `Failed to get upstream traffic for app ${UID}: ${JSON.stringify(err)}`;
    });
  }
  // [EndExclude flow_management_getUidRxBytes_and_getUidTxBytes]
  // [End flow_management_getUidRxBytes_and_getUidTxBytes]


  getSockfdRxBytes() {
    // [Start flow_management_getSockfdRxBytes_and_getSockfdTxBytes]
    // 获取指定socket实时下行流量数据。
    let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
    // bind或connect方法调用。
    // [StartExclude flow_management_getSockfdRxBytes_and_getSockfdTxBytes]
    let bindAddr: socket.NetAddress = {
      address: '0.0.0.0'
    }
    tcp.bind(bindAddr)
    let netAddress: socket.NetAddress = {
      address: '192.168.26.37',
      port: 8080
    }
    let tcpconnectoptions: socket.TCPConnectOptions = {
      address: netAddress,
      timeout: 6000
    }
    tcp.connect(tcpconnectoptions)
    // [EndExclude flow_management_getSockfdRxBytes_and_getSockfdTxBytes]
    // 获取TCPSocket的文件描述符。bind或connect方法调用成功后，才可调用此方法。
    tcp.getSocketFd().then((sockfd: number) => {
      statistics.getSockfdRxBytes(sockfd).then((stats: number) => {
        console.info(JSON.stringify(stats));
        // [StartExclude flow_management_getSockfdRxBytes_and_getSockfdTxBytes]
        this.logMessage = `Socket ${sockfd} downstream traffic: ${JSON.stringify(stats)}`;
        // [EndExclude flow_management_getSockfdRxBytes_and_getSockfdTxBytes]
      }).catch((err: BusinessError) => {
        console.error(JSON.stringify(err));
        // [StartExclude flow_management_getSockfdRxBytes_and_getSockfdTxBytes]
        this.logMessage = `Failed to get socket downstream traffic: ${JSON.stringify(err)}`;
        // [EndExclude flow_management_getSockfdRxBytes_and_getSockfdTxBytes]
      });
    })
    // [StartExclude flow_management_getSockfdRxBytes_and_getSockfdTxBytes]
    .catch((err: BusinessError) => {
      this.logMessage = `Failed to get socket file descriptor: ${JSON.stringify(err)}`;
    });
  }

  getSockfdTxBytes() {
    // 获取指定socket实时上行流量数据。
    let tcp: socket.TCPSocket = socket.constructTCPSocketInstance();
    // bind或connect方法调用。
    let bindAddr: socket.NetAddress = {
      address: '0.0.0.0'
    }
    tcp.bind(bindAddr)
    let netAddress: socket.NetAddress = {
      address: '192.168.26.37',
      port: 8080
    }
    let tcpconnectoptions: socket.TCPConnectOptions = {
      address: netAddress,
      timeout: 6000
    }
    tcp.connect(tcpconnectoptions)
    // [EndExclude flow_management_getSockfdRxBytes_and_getSockfdTxBytes]
    // 获取TCPSocket的文件描述符。bind或connect方法调用成功后，才可调用此方法。
    tcp.getSocketFd().then((sockfd: number) => {
      statistics.getSockfdTxBytes(sockfd).then((stats: number) => {
        console.info(JSON.stringify(stats));
        // [StartExclude flow_management_getSockfdRxBytes_and_getSockfdTxBytes]
        this.logMessage = `Socket ${sockfd} upstream traffic: ${JSON.stringify(stats)}`;
        // [EndExclude flow_management_getSockfdRxBytes_and_getSockfdTxBytes]
      }).catch((err: BusinessError) => {
        console.error(JSON.stringify(err));
        // [StartExclude flow_management_getSockfdRxBytes_and_getSockfdTxBytes]
        this.logMessage = `Failed to get socket upstream traffic: ${JSON.stringify(err)}`;
        // [EndExclude flow_management_getSockfdRxBytes_and_getSockfdTxBytes]
      });
    })
    // [StartExclude flow_management_getSockfdRxBytes_and_getSockfdTxBytes]
    .catch((err: BusinessError) => {
      this.logMessage = `Failed to get socket file descriptor: ${JSON.stringify(err)}`;
    });
  }
  // [EndExclude flow_management_getSockfdRxBytes_and_getSockfdTxBytes]
  // [End flow_management_getSockfdRxBytes_and_getSockfdTxBytes]


// [End obtain_realtime_traffic_statistics_of_network_interface_cards/uid]
}
