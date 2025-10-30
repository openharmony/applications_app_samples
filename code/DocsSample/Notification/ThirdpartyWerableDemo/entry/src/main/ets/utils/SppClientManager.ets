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

import { socket } from '@kit.ConnectivityKit'
import { hilog } from '@kit.PerformanceAnalysisKit';
import { BusinessError } from '@kit.BasicServicesKit';
import extensionSubscription from '@ohos.notificationExtensionSubscription';
import util from '@ohos.util'; // 导入OpenHarmony的util模块

const DOMAIN = 0x0000;

class TransferInfo {
  public type: string = ''
  public info: extensionSubscription.NotificationInfo | undefined
  public cancelHashCodes: Array<string>| undefined
}

class SppClientManager {
  // 定义客户端的socket id
  private clientNumber: number = -1;
  private peerDevice: string = '';

  constructor(peerDevice: string) {
    this.peerDevice = peerDevice
  }

  public isConnect() : boolean {
    return this.clientNumber !== -1;
  }

  // 发起连接
  public async startConnect(): Promise<boolean> {
    // 配置连接参数
    let option: socket.SppOptions = {
      uuid: '00009999-0000-1000-8000-00805F9B34FB', // 需要连接的服务端UUID服务，确保服务端支持
      secure: false,
      type: socket.SppType.SPP_RFCOMM
    };
    socket.sppConnect(this.peerDevice, option, (err: BusinessError, num: number) => {
      if (err) {
        hilog.error(DOMAIN, 'testTag', `cpp connect failed, errCode: ${err.code}, errMessage: ${err.message}`);
      } else {
        hilog.info(DOMAIN, 'testTag', `spp connect success clientNumber: ${num}`);
        this.clientNumber = num;
      }
    });
    return true
  }

  private sendData(jsonStr: string) {
    if (!this.isConnect()) {
      hilog.error(DOMAIN, 'testTag', `server is not connected`);
      return;
    }
    if (!jsonStr) {
      hilog.error(DOMAIN, 'testTag',  'json is empty');
      return;
    }
    hilog.info(DOMAIN, 'testTag', `prepare sending data to client ${this.clientNumber}`);
    const textEncoder = new util.TextEncoder();
    const uint8Array = textEncoder.encode(jsonStr);
    const arrayBuffer = uint8Array.buffer; // 最终要传输的ArrayBuffer

    // 步骤3：通过sppWrite发送数据
    socket.sppWrite(this.clientNumber, arrayBuffer);
    hilog.info(DOMAIN, 'testTag', `sending success size：${arrayBuffer.byteLength} bytes, data: ${jsonStr}`);
  }

  // 发送数据
  public sendNotificationData(notificationInfo: extensionSubscription.NotificationInfo) {
      let info: TransferInfo = {
        type: 'publish',
        info: notificationInfo,
        cancelHashCodes: undefined
      };

      let jsonStr = JSON.stringify(info);
      this.sendData(jsonStr);
  }

  public sendCancelNotificationData(cancelHashCodes: Array<string>) {
      let info: TransferInfo = {
        type: 'cancel',
        cancelHashCodes: cancelHashCodes,
        info: undefined
      };

      // 步骤1：将NotificationInfo序列化为JSON字符串
      let jsonStr = JSON.stringify(info);
      this.sendData(jsonStr);
  }

  public read = (dataBuffer: ArrayBuffer) => {
    let data = new Uint8Array(dataBuffer);
    hilog.info(DOMAIN, 'testTag', `client data: ${JSON.stringify(data)}`);
  };

  // 断开连接
  public stopConnect() {
    hilog.info(DOMAIN, 'testTag', `closeSppClient ${this.clientNumber}`);
    try {
      // 取消接收数据订阅
      socket.off('sppRead', this.clientNumber, this.read);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', `off sppRead errCode: ${err.code}, errMessage: ${err.message}`);
    }
    try {
      // 从client端断开连接
      socket.sppCloseClientSocket(this.clientNumber);
      this.clientNumber = -1;
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', `stopConnect errCode: ${err.code}, errMessage: ${err.message}`);
    }
  }
}

export default SppClientManager;