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

//[Start quick_start]
//[Start callback_start]
import { hilog } from '@kit.PerformanceAnalysisKit';
import { notificationExtensionSubscription, NotificationSubscriberExtensionAbility } from '@kit.NotificationKit';
//[StartExclude callback_start]
import { BusinessError } from '@kit.BasicServicesKit';
import { socket } from '@kit.ConnectivityKit'
import util from '@kit.ArkTS'; 
//[EndExclude callback_start]

const DOMAIN = 0x0000;
//[StartExclude callback_start]
class TransferInfo {
  public type: string = ''
  public info: notificationExtensionSubscription.NotificationInfo | undefined
  public cancelHashCodes: Array<string> | undefined
}

class SppClientManager {
  private clientNumber: number = -1;
  private peerDevice: string = '';

  constructor(peerDevice: string) {
    this.peerDevice = peerDevice
  }

  public isConnect(): boolean {
    return this.clientNumber !== -1;
  }

  public async startConnect(): Promise<boolean> {
    let option: socket.SppOptions = {
      uuid: '00009999-0000-1000-8000-00805F9B34FB',
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
      hilog.error(DOMAIN, 'testTag', 'json is empty');
      return;
    }
    hilog.info(DOMAIN, 'testTag', `prepare sending data to client ${this.clientNumber}`);
    const textEncoder = new util.TextEncoder();
    const uint8Array = textEncoder.encodeInto(jsonStr);
    const arrayBuffer = uint8Array.buffer;

    socket.sppWrite(this.clientNumber, arrayBuffer);
    hilog.info(DOMAIN, 'testTag', `sending success size：${arrayBuffer.byteLength} bytes, data: ${jsonStr}`);
  }

  public sendNotificationData(notificationInfo: notificationExtensionSubscription.NotificationInfo) {
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

    let jsonStr = JSON.stringify(info);
    this.sendData(jsonStr);
  }

  public read = (dataBuffer: ArrayBuffer) => {
    let data = new Uint8Array(dataBuffer);
    hilog.info(DOMAIN, 'testTag', `client data: ${JSON.stringify(data)}`);
  };

  public stopConnect() {
    hilog.info(DOMAIN, 'testTag', `closeSppClient ${this.clientNumber}`);
    try {
      socket.off('sppRead', this.clientNumber, this.read);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', `off sppRead errCode: ${err.code}, errMessage: ${err.message}`);
    }
    try {
      socket.sppCloseClientSocket(this.clientNumber);
      this.clientNumber = -1;
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', `stopConnect errCode: ${err.code}, errMessage: ${err.message}`);
    }
  }
}

// export SppClientManager;
//[EndExclude callback_start]
export class NotificationSubscriberExtAbility extends NotificationSubscriberExtensionAbility {
  //[StartExclude callback_start]
  private sppClientManager: SppClientManager | undefined;
  //[EndExclude callback_start]
  onDestroy(): void {
    hilog.info(DOMAIN, 'testTag', 'onDestroy');
    //[StartExclude callback_start]
    this.sppClientManager!.stopConnect();
    //[EndExclude callback_start]
  }
  //[StartExclude callback_start]
  // Called back when a notification is published.
  //[EndExclude callback_start]
  onReceiveMessage(notificationInfo: notificationExtensionSubscription.NotificationInfo): void {
    hilog.info(DOMAIN, 'testTag', `on receive message ${JSON.stringify(notificationInfo)}`)
    //[StartExclude callback_start]
    notificationExtensionSubscription.getSubscribeInfo()
      .then(info => {
        if (this.sppClientManager == undefined) {
          this.sppClientManager = new SppClientManager(info[0].addr);
        }
        if (this.sppClientManager.isConnect()) {
          this.sendPublishWithRetry(notificationInfo);
        } else {
          this.sppClientManager.startConnect()
          setTimeout(() => {
            this.sendPublishWithRetry(notificationInfo);
          }, 3000)
        }
      }).catch((err: BusinessError) => {
      hilog.error(DOMAIN, 'testTag',
        `notificationExtensionSubscription failed, errCode ${err.code}, errorMessage ${err.message}`);
    });
    //[EndExclude callback_start]
  }
  //[StartExclude callback_start]
  // Sends a publish notification and retries once upon failure.
  private sendPublishWithRetry(notificationInfo: notificationExtensionSubscription.NotificationInfo) {
    try {
      this.sppClientManager!.sendNotificationData(notificationInfo);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', `send failed, errCode ${err.code}, errorMessage ${err.message}, and retry one times`);
      this.sppClientManager!.startConnect();
      setTimeout(() => {
        this.sppClientManager!.sendNotificationData(notificationInfo);
      }, 3000);
    }
  }

  // Called back when notifications is cancelled.
  //[EndExclude callback_start]
  onCancelMessages(hashCodes: Array<string>): void {
    hilog.info(DOMAIN, 'testTag', `on cancel message ${JSON.stringify(hashCodes)}`)
    //[StartExclude callback_start]
    notificationExtensionSubscription.getSubscribeInfo()
      .then(info => {
        if (this.sppClientManager == undefined) {
          this.sppClientManager = new SppClientManager(info[0].addr);
        }
        if (this.sppClientManager.isConnect()) {
          this.sendCancelWithRetry(hashCodes);
        } else {
          this.sppClientManager.startConnect()
          setTimeout(() => {
            this.sendCancelWithRetry(hashCodes);
          }, 3000)
        }
      }).catch((err: BusinessError) => {
      hilog.error(DOMAIN, 'testTag', `notificationExtensionSubscription failed, errCode ${err.code}, errorMessage ${err.message}`);
    });
    //[EndExclude callback_start]
  }
  //[StartExclude callback_start]
  // Retries a cancel operation if it fails.
  private sendCancelWithRetry(hashCodes: string[]) {
    try {
      this.sppClientManager!.sendCancelNotificationData(hashCodes);
    } catch (err) {
      hilog.error(DOMAIN, 'testTag', `send failed, errCode ${err.code}, errorMessage ${err.message}, and retry one times`);
      this.sppClientManager!.startConnect();
      setTimeout(() => {
        this.sppClientManager!.sendCancelNotificationData(hashCodes);
      }, 3000);
    }
  }
  //[EndExclude callback_start]
}
//[End callback_start]
//[End quick_start]