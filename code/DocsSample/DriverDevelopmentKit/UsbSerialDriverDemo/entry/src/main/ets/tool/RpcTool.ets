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
import { Index } from '../pages/Index';
import { SerialPortComponent } from '../components/SerialPortComponent';
import GlobalContext from './GlobalContext'
import { BusinessError } from '@kit.BasicServicesKit';

const REQUEST_CODE_KEY_VALUE = 1; //与扩展外设驱动端约定请求码,配置串口
const REQUEST_CODE_DIRECTION = 2;
const REQUEST_CODE_CONNECT_STATUS = 3;
const REQUEST_CODE_CLOSE_CONNECTION = 4; //与扩展外设驱动端约定请求码，关闭串口
const REQUEST_CODE_READ_DATA = 5; //与扩展外设驱动端约定请求码，读取数据
const REQUEST_CODE_SETTIMEOUT_DATA = 6; // 与扩展外设客户端约定请求码，设置超时时间

const VENDOR_ID: number = 9390 // 24AE
const PRODUCT_ID_LIST = [29987] // 1871

export async function sleep(ms: number) {
  return new Promise<number>(res => setTimeout(res, ms));
}

class MyDeathRecipient {
  private rpcTool: RpcTool;

  constructor(rpc: RpcTool) {
    hilog.info(0, 'testTag ui', "MyDeathRecipient constructor");
    this.rpcTool = rpc;
  }

  onRemoteDied() {
    hilog.info(0, 'testTag ui', "MyDeathRecipient onRemoteDied");
    this.rpcTool.resetStatus()
    this.rpcTool.bindStateChanged()
  }
}

export default class RpcTool {
  private deviceId: number = -1;
  private vendorId: number = 0;
  private productId: number = 0;
  private description: string = "";
  private message: string = "";
  private bindState: boolean = false;
  private remote: rpc.RemoteObject | null = null;
  private isQuerying: boolean = false;
  private isBinding: boolean = false;
  private indexUI?: Index;
  private connectStatusChanged = false;
  static instance: RpcTool;
  private msg: number = 0;
  private serialPortComponent?: SerialPortComponent;

  public resetStatus(): void {
    this.remote = null;
    this.bindState = false;
    this.isBinding = false;
  }

  public static getInstance(): RpcTool {
    if (!GlobalContext.getContext().hasObject("prcToolInstance")) {
      GlobalContext.getContext().setObject("prcToolInstance", new RpcTool());
    }
    return GlobalContext.getContext().getObject("prcToolInstance") as RpcTool;
  }

  //查询方法
  private query() {
    hilog.info(0, 'testTag ui', 'query enter');
    if (this.isBinding || this.bindState) {
      hilog.info(0, 'testTag ui', 'has bind. device id:' + this.deviceId)
      return
    }
    if (this.deviceId != -1) {
      hilog.info(0, 'testTag ui', 'has query. device id:' + this.deviceId)
      return;
    }
    this.isQuerying = true
    try {
      let devices: Array<deviceManager.Device> = deviceManager.queryDevices(deviceManager.BusType.USB);
      for (let item of devices) {
        let device = item as deviceManager.USBDevice;
        hilog.info(0, 'testTag ui', 'querydevice id:' + device.deviceId + ',bustype:' + device.busType
          + ',vid:' + device.vendorId + ',pid:' + device.productId + ', des:' + device.description);
        let index = PRODUCT_ID_LIST.indexOf(device.productId)
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
    this.isQuerying = false
  }

  async bindStateChanged() {
    hilog.info(0, 'testTag ui', 'bindStateChanged enter');
    this.bindState == false
    this.remote = null
    this.deviceId = -1
    this.vendorId = 0
    this.productId = 0
    this.description = ""
    this.indexUI?.bindCallback(this.getVendorId(), this.getProductId(), this.description)
    this.serialPortComponent?.bindStatusChange(this.getVendorId(), this.getProductId())
    await sleep(1500)
    await this.bindDevice()
  }

  //绑定方法
  private async bind() {
    hilog.info(0, 'testTag ui', 'bind enter');
    if (this.deviceId == -1) {
      hilog.error(0, 'testTag ui', 'deviceId is invalid!');
      return;
    }
    if (this.remote != null) {
      hilog.info(0, 'testTag ui', 'has bind device. device id:' + this.deviceId)
      return;
    }

    if (this.isBinding) {
      hilog.info(0, 'testTag ui', 'is binding now')
      return;
    }
    this.isBinding = true;
    try {
      hilog.info(0, 'testTag ui', 'bindDevice id is:' + this.deviceId);
      let data: deviceManager.RemoteDeviceDriver = await deviceManager.bindDeviceDriver(this.deviceId,
        async (err: BusinessError, id: number) => {
          hilog.error(0, 'testTag ui', 'Device is disconnected:' + data);
          this.bindState = false; //若设备在绑定过程中，设备断连，需要重新绑定
          this.isBinding = false;
          this.bindStateChanged()
        });

      hilog.info(0, 'testTag ui', 'bindDevice success:' + data.deviceId);

      this.remote = data.remote as rpc.RemoteObject;
      if (this.remote === null) {
        hilog.error(0, 'testTag ui', 'create remote fail');
        this.bindState = false;
        this.isBinding = false;
        return;
      }
      let deathRecipient = new MyDeathRecipient(this);
      this.remote.registerDeathRecipient(deathRecipient, 0);
      this.bindState = true;
      // this.isQuerying = false;
      this.isBinding = false;
      hilog.info(0, 'testTag ui', 'create remote success');
    } catch (error) {
      hilog.error(0, 'testTag ui', 'bindDevice fail. Code:' + error + ', message:' + error.message);
      this.bindState = false;
      this.isBinding = false;
    }
  }

  //初始化
  init(indexUI: Index) {
    this.indexUI = indexUI
  }

  initSerialPortComponent(serialPortComponent: SerialPortComponent) {
    this.serialPortComponent = serialPortComponent
  }

  //绑定设备(包含了query和bind)
  async bindDevice() {
    //初始都为false，避免重复绑定
    if (this.isQuerying || this.isBinding) {
      return;
    }
    hilog.info(0, 'testTag ui', 'bindDevice enter');
    while (this.remote == null) {
      this.query();
      await this.bind();
      await sleep(1500)
      hilog.info(0, 'testTag ui', 'timeOut');
    }
    this.indexUI?.bindCallback(this.getVendorId(), this.getProductId(), this.description)
    this.serialPortComponent?.bindStatusChange(this.getVendorId(), this.getProductId())
    // await this.queryConnectStatus()
    hilog.info(0, 'testTag ui', `vendorId:${this.vendorId} productId:${this.productId} descprtion:${this.description}`)
  }

  getVendorId() {
    if (this.vendorId == 0) {
      return ""
    } else {
      return `0x${this.vendorId.toString(16).toUpperCase()}`
    }
  }

  getProductId() {
    if (this.productId == 0) {
      return ""
    } else {
      return `0x${this.productId.toString(16).toUpperCase()}`
    }
  }

  async unbindDevice() {
    hilog.info(0, 'testTag ui', 'unbind enter');
    if (this.deviceId == -1) {
      hilog.error(0, 'testTag ui', 'deviceId is invalid!');
      return;
    }

    try {
      hilog.info(0, 'testTag ui', 'unbindDevice id is:' + this.deviceId);
      await deviceManager.unbindDevice(this.deviceId, async (err: BusinessError) => {
        if (err) {
          hilog.error(0, 'testTag ui', 'Failed to unbind device: ' + err.message);
        } else {
          this.isBinding = false;
          this.bindState = false;
          hilog.info(0, 'testTag ui', 'Device is disconnected');
        }
      });
      // await deviceManager.unbindDevice(this.deviceId)
    } catch (error) {
      hilog.error(0, 'testTag ui', 'bindDevice fail. Code:' + error + ', message:' + error.message);
      this.bindState = true;
      this.isBinding = true;
    }
  }

  //设置串口参数
  setKeyValue(keyValuePairs: Map<number, string>) {
    hilog.info(0, 'testTag ui', 'enter setKetValue');
    let option = new rpc.MessageOption();
    let dataSend = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();
    keyValuePairs.forEach((keyValue, keyIndex) => {
      dataSend.writeInt(keyIndex);
      dataSend.writeString(keyValue);
    });
    if (this.remote == null) {
      hilog.error(0, 'testTag ui', 'the remote is null');
      return;
    }
    this.remote.sendMessageRequest(REQUEST_CODE_KEY_VALUE, dataSend, reply, option).then((ret) => {
      hilog.info(0, 'testTag ui', 'sendMessageRequest success');
      this.msg = reply.readInt();
      // this.indexUI?.msgCallback(this.msg);
      hilog.info(0, 'testTag ui', `setKeyValue ret:${ret}`);
    }).catch(() => {
      hilog.info(0, 'testTag ui', `setKeyValue sendMessageRequest failed`);
    });
  }

  async queryConnectStatus() {
    hilog.info(0, 'testTag ui', 'queryConnectStatus enter');
    while (this.remote != null) {
      await this.getConnectStatus();
      if (this.connectStatusChanged) {
        this.connectStatusChanged = false;
        this.bindStateChanged();
        break;
      }
      await sleep(3000)
    }
  }

  async getConnectStatus() {
    let option = new rpc.MessageOption();
    let dataSend = rpc.MessageSequence.create();
    let reply = rpc.MessageSequence.create();
    hilog.info(0, 'testTag ui', `getConnectStatus`);
    if (this.remote == null) {
      hilog.error(0, 'testTag ui', `the remote is null`)
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

  //关闭连接
  async closeConnection() {
    let option = new rpc.MessageOption();
    let dataSend = rpc.MessageSequence.create();
    let reply = rpc.MessageSequence.create();
    hilog.info(0, 'testTag ui', `closeConnection`);
    if (this.remote == null) {
      hilog.error(0, 'testTag ui', 'the remote is null')
      return;
    }
    try {
      await this.remote.sendMessageRequest(REQUEST_CODE_CLOSE_CONNECTION, dataSend, reply, option);
      let result = reply.readInt();
      if (result == 31600000) {
        hilog.info(0, 'testTag ui', `Connectioned closed successfully`);
      } else {
        hilog.info(0, 'testTag ui', `Failed to close connection,result code`, result);
      }
    } catch (error) {
      hilog.info(0, 'testTag ui', `Failed to close the connection. Code is ${error.code}, message is ${error.message}`);
    }
  }

  //温度显示
  async showTemperature(): Promise<string | undefined> {
    let option = new rpc.MessageOption();
    let dataSend = rpc.MessageSequence.create();
    let reply = rpc.MessageSequence.create();
    hilog.info(0, 'testTag ui', `enter showTemperature`);
    if (this.remote == null) {
      hilog.error(0, 'testTag ui', 'the remote is null')
      return undefined;
    }
    try {
      await this.remote.sendMessageRequest(REQUEST_CODE_READ_DATA, dataSend, reply, option);
      hilog.info(0, 'testTag ui', `Temperature display successfully`);
      let result = reply.readDouble();
      hilog.info(0, 'testTag ui', `Temperature data:${result}`);
      this.indexUI?.temperatureCallback(result.toString())
      return result.toString();
    } catch (error) {
      hilog.info(0, 'testTag ui', `Temperature display failed. Code is ${error.code}, message is ${error.message}`);
      return undefined;
    }
  }

  //超时时间
  async setTimeOut(timeOut: number) {
    let option = new rpc.MessageOption();
    let dataSend = rpc.MessageSequence.create();
    let reply = rpc.MessageSequence.create();
    hilog.info(0, 'testTag ui', `enter setTimeOut`);
    dataSend.writeInt(timeOut);
    if (this.remote == null) {
      hilog.error(0, 'testTag ui', 'the remote is null')
      return;
    }
    try {
      await this.remote.sendMessageRequest(REQUEST_CODE_SETTIMEOUT_DATA, dataSend, reply, option);
      hilog.info(0, 'testTag ui', `setTimeOut successfully`);
      let result = reply.readInt();
      hilog.info(0, 'testTag ui', `setTimeOut data:${result}`);
      this.indexUI?.timeoutCallback(result);
    } catch (error) {
      hilog.info(0, 'testTag ui', `setTimeOut failed. Code is ${error.code}, message is ${error.message}`);
    }
  }
}

