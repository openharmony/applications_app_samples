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

// [Start driver_ui_step2]
import { hilog } from '@kit.PerformanceAnalysisKit';
import { deviceManager } from '@kit.DriverDevelopmentKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { rpc } from '@kit.IPCKit';

const REQUEST_CODE: number = 99; // 自定义通信Code，此处仅供参考
const productId: number = 4258;  // 请声明连接的USB设备的productId
const vendorId: number = 4817;   // 请声明连接的USB设备的vendorId
const DOMAIN = 0x0000;
// [End driver_ui_step2]

@Entry
@Component
struct Index {
  // [Start driver_ui_step3]
  @State message: string = 'Hello';
  private remote: rpc.IRemoteObject | null = null;
  // [End driver_ui_step3]

  // [Start driver_ui_step4]
  private async queryTargetDeviceId(): Promise<number> {
    try {
      const devices: deviceManager.Device[] = deviceManager.queryDevices(deviceManager.BusType.USB);
      const index = devices.findIndex((item: deviceManager.Device) => {
        let usbDevice = item as deviceManager.USBDevice;
        // 如果不知道设备productId和vendorId，可以通过该日志查看连接的usb设备的相关信息
        hilog.info(DOMAIN, 'testTag', `usbDevice.productId = ${usbDevice.productId}, usbDevice.vendorId = ${usbDevice.vendorId}`);
        return usbDevice.productId === productId && usbDevice.vendorId === vendorId;
      });
      hilog.info(DOMAIN, 'testTag', `queryTargetDeviceId index = ${index}, deviceId = ${devices[index].deviceId}`);
      if (index < 0) {
        hilog.error(DOMAIN, 'testTag', 'can not find device');
        return -1;
      }
      return devices[index].deviceId;
    } catch (error) {
      hilog.error(DOMAIN, 'testTag', `queryDevice failed, err: ${JSON.stringify(error)}`);
    }
    return -1;
  }
  // [End driver_ui_step4]

  // [Start driver_ui_step5]
  private async getDriverRemote(deviceId: number): Promise<rpc.IRemoteObject | null> {
    try {
      let remoteDeviceDriver: deviceManager.RemoteDeviceDriver = await deviceManager.bindDeviceDriver(deviceId,
        (err: BusinessError, id: number) => {
          hilog.info(DOMAIN, 'testTag', `device[${id}] id disconnect, err: ${JSON.stringify(err)}`);
        });
      return remoteDeviceDriver.remote;
    } catch (error) {
      hilog.error(DOMAIN, 'testTag', `bindDriverWithDeviceId failed, err: ${JSON.stringify(error)}`);
    }
    return null;
  }
  // [End driver_ui_step5]

  // [Start driver_ui_step6]
  private async communicateWithRemote(): Promise<void> {
    const deviceId: number = await this.queryTargetDeviceId();
    hilog.info(DOMAIN, 'testTag', `queryTargetDeviceId, deviceId=${deviceId}`);
    if (deviceId < 0) {
      hilog.error(DOMAIN, 'testTag', 'can not find target device');
      return;
    }
    this.remote = await this.getDriverRemote(deviceId);
    if (this.remote === null) {
      hilog.error(DOMAIN, 'testTag', `getDriverRemote failed`);
      return;
    }

    let option = new rpc.MessageOption();
    let data = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();

    // 向驱动发送信息"Hello"
    hilog.info(DOMAIN, 'testTag', `communicateWithRemote, message=${this.message}`);
    data.writeString(this.message);

    try {
      await this.remote.sendMessageRequest(REQUEST_CODE, data, reply, option);
      // 获取驱动返回信息"Hello world"
      this.message = reply.readString();
      hilog.info(DOMAIN, 'testTag', `sendMessageRequest, message: ${this.message}`);
    } catch (error) {
      hilog.error(DOMAIN, 'testTag', `sendMessageRequest failed, err: ${JSON.stringify(error)}`);
    }
  }
  // [End driver_ui_step6]

  // [Start driver_ui_step7]
  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize($r('app.float.page_text_font_size'))
          .fontWeight(FontWeight.Bold)
          .onClick(() => {
            // 点击"Hello"，与远程对象通信，显示"Hello World"
            this.communicateWithRemote();
          })
      }
      .width('100%')
    }
    .height('100%')
  }
  // [End driver_ui_step7]
}
