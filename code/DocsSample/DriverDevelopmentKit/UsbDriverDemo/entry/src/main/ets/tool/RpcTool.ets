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

import { rpc } from '@kit.IPCKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { deviceManager } from '@kit.DriverDevelopmentKit';
import {Index} from '../pages/Index';
import { BusinessError } from '@kit.BasicServicesKit';

const REQUEST_CODE_KEY_VALUE = 1;
const REQUEST_CODE_DIRECTION = 2;
const REQUEST_CODE_CONNECT_STATUS = 3;

const VENDOR_ID: number = 2903; // 0B57
const PRODUCT_ID_LIST = [41279, 41296, 41299]; // A13F A150 A153

export function sleep(ms: number): Promise<void> {
  return new Promise(res => setTimeout(res, ms));
}

class MyDeathRecipient {
  private rpcTool: RpcTool;

  constructor(rpc: RpcTool) {
    this.rpcTool = rpc;
  }

  onRemoteDied() {
    hilog.info(0, 'testTag ui', 'onRemoteDied');
    this.rpcTool?.resetStatus();
    this.rpcTool?.bindStateChanged();
  }
}

export default class RpcTool {
  private deviceId: number = -1;
  private vendorId: number = 0;
  private productId: number = 0;
  private description: string = '';
  private message: string = '';
  private bindState: boolean = false;
  private remote: rpc.RemoteObject | null = null;
  private isQuerying : boolean = false;
  private isBinding : boolean = false;
  private callBack: ((vendorId: string, productId: string, description: string) => void) | null = null;
  private connectStatusChanged = false;
  public static instance: RpcTool;

  public resetStatus(): void {
    this.remote = null;
    this.bindState = false;
    this.isBinding = false;
    this.bindState = false;
    this.callBack && this.callBack('', '', '');
  }

  public static getInstance(): RpcTool {
    if (!RpcTool.instance) {
      RpcTool.instance = new RpcTool();
    }
    return RpcTool.instance;
  }

  private query() {
    hilog.info(0, 'testTag ui', 'query enter');
    if (this.isBinding || this.bindState) {
      hilog.info(0, 'testTag ui', 'has bind. device id:' + this.deviceId);
      return;
    }
    if (this.deviceId != -1) {
      hilog.info(0, 'testTag ui', 'has query. device id:' + this.deviceId);
      return;
    }
    this.isQuerying = true
    try {
      let devices: deviceManager.Device[] = deviceManager.queryDevices(deviceManager.BusType.USB);
      for (let item of devices) {
        let device = item as deviceManager.USBDevice;
        hilog.info(0, 'testTag ui', 'querydevice id:' + device.deviceId + ',bustype:' + device.busType + ',vid:' +
          device.vendorId + ',pid:' + device.productId + ', des:' + device.description);
        let index = PRODUCT_ID_LIST.indexOf(device.productId);
        if (index >= 0) {
          this.deviceId = device.deviceId;
          this.vendorId = device.vendorId;
          this.productId = device.productId;
          this.description = device.description;
          break;
        }
      }
    } catch (error) {
      hilog.error(0, 'testTag ui', `Failed to query device. Code is ${error.code}, message is ${error.message}`);
    }
    this.message = this.deviceId.toString();
    this.isQuerying = false;
  }

  async bindStateChanged() {
    hilog.info(0, 'testTag ui', 'bindStateChanged enter');
    this.bindState == false;
    this.remote = null;
    this.deviceId = -1;
    this.vendorId = 0;
    this.productId = 0;
    this.description = '';
    this.callBack && this.callBack(this.getVendorId(), this.getProductId(), this.description);
    await sleep(1500);
    await this.bindDevice();
  }

  private async bind() {
    hilog.info(0, 'testTag ui', 'bind enter');
    if (this.deviceId == -1) {
      hilog.error(0, 'testTag ui', 'deviceId is invalid!');
      return;
    }
    if (this.remote != null) {
      hilog.info(0, 'testTag ui', 'has bind device. device id:' + this.deviceId);
      return;
    }

    if (this.isBinding) {
      hilog.info(0, 'testTag ui', 'is binding now');
      return;
    }
    this.isBinding = true;
    try {
      hilog.info(0, 'testTag ui', 'bindDevice id is:' + this.deviceId);
      let data: deviceManager.RemoteDeviceDriver = await deviceManager.bindDeviceDriver(this.deviceId,
        async (err: BusinessError, id: number) => {
          hilog.error(0, 'testTag ui', 'Device is disconnected:' + data);
          this.bindState = false;
          this.isBinding = false;
          this.bindStateChanged();
      });

      hilog.info(0, 'testTag ui', 'bindDevice success:' + data.deviceId);

      this.remote = data.remote as rpc.RemoteObject;
      if (this.remote === null) {
        hilog.error(0, 'testTag ui', 'create remote fail');
        this.bindState = false;
        this.isBinding = false;
        return;
      }

      this.bindState = true;
      this.isBinding = false;
      hilog.info(0, 'testTag ui', 'create remote success');
    } catch (error) {
      hilog.error(0, 'testTag ui', 'bindDevice fail. Code:' + error + ', message:' + error.message);
      this.bindState = false;
      this.isBinding = false;
    }
  }

  init(callback: (vendorId: string, productId: string, description: string) => void) {
    this.callBack = callback;
  }

  async bindDevice() {
    if (this.isQuerying || this.isBinding) {
      return;
    }
    hilog.info(0, 'testTag ui', 'bindDevice enter');
    while (this.remote == null) {
      this.query();
      await this.bind();
      await sleep(1500);
      hilog.info(0, 'testTag ui', 'timeOut');
    }
    this.callBack && this.callBack(this.getVendorId(), this.getProductId(), this.description);
    let deathRecipient = new MyDeathRecipient(this);
    this.remote.registerDeathRecipient(deathRecipient, 0);
    hilog.info(0, 'testTag ui', `vendorId:${this.vendorId} productId:${this.productId} descprtion:${this.description}`);
  }

  getVendorId() {
    if(this.vendorId == 0) {
      return '';
    } else {
      return `0x${this.vendorId.toString(16).toUpperCase()}`;
    }
  }
  getProductId() {
    if(this.productId == 0) {
      return '';
    } else {
      return `0x${this.productId.toString(16).toUpperCase()}`;
    }
  }

  setKeyValue(keyIndex: number, keyValue: number) {
    hilog.info(0, 'testTag ui', `setKeyValue enter keyIndex:${keyIndex}, keyValue:${keyValue}`);
    // 直接调用rpc的接口向服务端发送消息，客户端需自行对入参进行序列化，对返回值进行反序列化，操作繁琐
    let option = new rpc.MessageOption();
    let dataSend = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();
    dataSend.writeInt(keyIndex);
    dataSend.writeInt(keyValue);
    hilog.info(0, 'testTag ui', `send key value to remote keyIndex:${keyIndex} keyValue:${keyValue}`);
    if (this.remote == null) {
      hilog.error(0, 'testTag ui', `the remote is null`);
      return;
    }
    this.remote.sendMessageRequest(REQUEST_CODE_KEY_VALUE, dataSend, reply, option).then((ret) => {
      let msg = reply.readInt();
      hilog.info(0, 'testTag ui', `setKeyValue ret:${ret} msg:${msg}`);
    }).catch(() => {
      hilog.info(0, 'testTag ui', 'setKeyValue failed');
    });
  }

  setDirection(direction: number) {
    let option = new rpc.MessageOption();
    let dataSend = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();
    dataSend.writeInt(direction);
    hilog.info(0, 'testTag ui', `send key value to remote direction:${direction}`);
    if (this.remote == null) {
      hilog.error(0, 'testTag ui', `the remote is null`);
      return;
    }
    this.remote.sendMessageRequest(REQUEST_CODE_DIRECTION, dataSend, reply, option).then((ret) => {
      let msg = reply.readInt();
      hilog.info(0, 'testTag ui', `setDirection ret:${ret} msg:${msg}`);
    }).catch(() => {
      hilog.info(0, 'testTag ui', 'setDirection failed');
    });
  }

  async queryConnectStatus() {
    hilog.info(0, 'testTag ui', 'queryConnectStatus enter');
    while(this.remote != null) {
      await this.getConnectStatus();
      if(this.connectStatusChanged) {
        this.connectStatusChanged = false;
        this.bindStateChanged();
        break;
      }
      await sleep(3000);
    }
  }

  async getConnectStatus() {
    let option = new rpc.MessageOption();
    let dataSend = rpc.MessageSequence.create();
    let reply = rpc.MessageSequence.create();
    hilog.info(0, 'testTag ui', `getConnectStatus`);
    if (this.remote == null) {
      hilog.error(0, 'testTag ui', `the remote is null`);
      return;
    }
    try {
      await this.remote.sendMessageRequest(REQUEST_CODE_CONNECT_STATUS, dataSend, reply, option);
      let stat = reply.readInt();
      this.connectStatusChanged = (stat == 0 ? true : false);
      hilog.info(0, 'testTag ui', `getConnectStatus ${stat}`);
    } catch (error) {
      this.connectStatusChanged = false;
      hilog.info(0, 'testTag ui', 'getConnectStatus failed');
    }

  }
}

