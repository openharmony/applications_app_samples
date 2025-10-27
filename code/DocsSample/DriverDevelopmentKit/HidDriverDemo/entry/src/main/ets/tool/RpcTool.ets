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
import GlobalContext from './GlobalContext'
import { BusinessError } from '@kit.BasicServicesKit';
import { InputParams, OutputParams } from '../utils/Params';
import { RequestCode, InputType, OutputType } from '../utils/RequestCode';

const VENDOR_ID: number = 9390; // 24AE
const PRODUCT_ID_LIST = [0xC31C,0x9EF4]; // 这里只配了罗技K120和狼蛛F2088的pid

export async function sleep(ms: number) {
  return new Promise<number>(res => setTimeout(res, ms));
}

class MyDeathRecipient {
  private rpcTool: RpcTool;

  constructor(rpc: RpcTool) {
    this.rpcTool = rpc;
  }

  onRemoteDied() {
    hilog.info(0, 'testTag ui', 'onRemoteDied');
    this.rpcTool.resetStatus();
    this.rpcTool.bindStateChanged();
  }
}


export default class RpcTool {
  public deviceId: number = -1;
  private vendorId: number = 0;
  private productId: number = 0;
  private description: string = '';
  private message: string = '';
  private bindState: boolean = false;
  private remote: rpc.RemoteObject | null = null;
  private isQuerying: boolean = false;
  private isBinding: boolean = false;
  private indexUI?: Index;
  private connectStatusChanged = false;
  public static instance: RpcTool;

  public static getInstance(): RpcTool {
    if (!GlobalContext.getContext().hasObject('prcToolInstance')) {
      GlobalContext.getContext().setObject('prcToolInstance', new RpcTool());
    }
    return GlobalContext.getContext().getObject('prcToolInstance') as RpcTool;
  }

  public resetStatus(): void {
    this.remote = null;
    this.bindState = false;
    this.isBinding = false;
  }

  //查询方法
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
    this.isQuerying = true;
    try {
      let devices: deviceManager.Device[] = deviceManager.queryDevices(deviceManager.BusType.USB);
      for (let item of devices) {
        let device = item as deviceManager.USBDevice;
        hilog.info(0, 'testTag ui', 'querydevice id:' + device.deviceId + ',bustype:' + device.busType +
          ',vid:' + device.vendorId + ',pid:' + device.productId + ', des:' + device.description);
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
    this.indexUI?.bindCallback(this.getVendorId(), this.getProductId(), this.description);
    await sleep(1500);
    await this.bindDevice();
  }

  //绑定方法
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

      let deathRecipient = new MyDeathRecipient(this);
      this.remote.registerDeathRecipient(deathRecipient, 0);
      this.bindState = true;
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
    this.indexUI = indexUI;
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
      await sleep(1500);
      hilog.info(0, 'testTag ui', 'timeOut');
    }
    this.indexUI?.bindCallback(this.getVendorId(), this.getProductId(), this.description);
    hilog.info(0, 'testTag ui', `vendorId:${this.vendorId} productId:${this.productId} descprtion:${this.description}`);
  }

  getVendorId() {
    if (this.vendorId == 0) {
      return '';
    } else {
      return `0x${this.vendorId.toString(16).toUpperCase()}`;
    }
  }

  getProductId() {
    if (this.productId == 0) {
      return '';
    } else {
      return `0x${this.productId.toString(16).toUpperCase()}`;
    }
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
      await this.remote.sendMessageRequest(RequestCode.ConnectStatus, dataSend, reply, option);
      let stat = reply.readInt();
      this.connectStatusChanged = (stat == 0 ? true : false);
      hilog.info(0, 'testTag ui', `getConnectStatus ${stat}`);
    } catch (error) {
      this.connectStatusChanged = false;
      hilog.info(0, 'testTag ui', 'getConnectStatus failed');
    }
  }

  async unbind() {
    if (this.deviceId != -1) {
      hilog.info(0, 'testTag ui', `[app] unbind`);
      await deviceManager.unbindDevice(this.deviceId);
    }
  }

  async getInput(deviceId: number, inputType: InputType) {
    hilog.info(0, 'testTag ui', `[app] getInput enter`);
    if (this.remote == null) {
      hilog.error(0, 'testTag ui', `[app] the remote is null`);
      return;
    }

    let option = new rpc.MessageOption();
    let dataSend = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();
    let inputParams = new InputParams();

    dataSend.writeInt(inputType);

    this.remote.sendMessageRequest(RequestCode.GetInput, dataSend, reply, option).then((ret) => {
      inputParams.stateOfE0 = reply.readBoolean();
      inputParams.stateOfE1 = reply.readBoolean();
      inputParams.stateOfE2 = reply.readBoolean();
      inputParams.stateOfE3 = reply.readBoolean();
      inputParams.stateOfE7 = reply.readBoolean();
      inputParams.stateOfE4 = reply.readBoolean();
      inputParams.stateOfE5 = reply.readBoolean();
      inputParams.stateOfE6 = reply.readBoolean();
      inputParams.data = reply.readString();
      inputParams.freshUI = true;

      this.indexUI?.updateInputPage(inputParams);
      hilog.info(0, 'testTag ui', `[app] getInput ret:${ret} E0:${inputParams.stateOfE0} E1:${inputParams.stateOfE1}
                E2:${inputParams.stateOfE2} E3:${inputParams.stateOfE3} E4:${inputParams.stateOfE4} E5:${inputParams.stateOfE5}
                E6:${inputParams.stateOfE6} E7:${inputParams.stateOfE7} data:${inputParams.data}`);
    }).catch(() => {
      inputParams.data = '未输入有效数据';
      inputParams.freshUI = true;
      this.indexUI?.updateInputPage(inputParams);
      hilog.info(0, 'testTag ui', '[app] getInput failed');
    });

    return inputParams;
  }

  setOutput(outputType: OutputType, outputParams: OutputParams) {
    hilog.info(0, 'testTag ui', `[app] setOutput enter`);
    if (this.remote == null) {
      hilog.error(0, 'testTag ui', `[app] the remote is null`);
      return;
    }

    let option = new rpc.MessageOption();
    let dataSend = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();

    dataSend.writeInt(outputType);
    dataSend.writeBoolean(outputParams.numLock);
    dataSend.writeBoolean(outputParams.capsLock);
    dataSend.writeBoolean(outputParams.scrollLock);
    dataSend.writeBoolean(outputParams.compose);

    this.remote.sendMessageRequest(RequestCode.SetOutput, dataSend, reply, option).then((ret) => {
      hilog.info(0, 'testTag ui', `[app] setOutput success ret:${ret} `);
    }).catch(() => {
      hilog.info(0, 'testTag ui', '[app] setOutput failed');
    });
    return;
  }

  testGetInferface(deviceId: number, requestType: RequestCode) {
    hilog.info(0, 'testTag ui', `[app] testGetInferface enter`);
    if (this.remote == null) {
      hilog.error(0, 'testTag ui', `[app] the remote is null`);
      return '';
    }

    let option = new rpc.MessageOption();
    let dataSend = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();
    dataSend.writeInt(deviceId);
    let data = '';
    this.remote.sendMessageRequest(requestType, dataSend, reply, option).then((ret) => {
      data = reply.readString();
      this.indexUI?.updateAttributePage(requestType, data);
      hilog.info(0, 'testTag ui', `[app] testGetInferface success ret:${ret}, rawName/phyaddr/uniqueId: ${data}`);
    }).catch(() => {
      hilog.info(0, 'testTag ui', '[app] testGetInferface failed');
    });
    return data;
  }

  getFeature() {
    hilog.info(0, 'testTag ui', `[app] getFeature enter`);
    if (this.remote == null) {
      hilog.error(0, 'testTag ui', `[app] the remote is null`);
      return;
    }

    let option = new rpc.MessageOption();
    let dataSend = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();

    let data = '';
    this.remote.sendMessageRequest(RequestCode.GetFeature, dataSend, reply, option).then((ret) => {
      data = reply.readString();
      this.indexUI?.updateFeaturePage(data);
      hilog.info(0, 'testTag ui', `[app] getFeature success ret:${ret}, feature: ${data}`);
    }).catch(() => {
      hilog.info(0, 'testTag ui', '[app] getFeature failed');
    });
    return;
  }

  setFeature(data: string) {
    hilog.info(0, 'testTag ui', `[app] setFeature enter`);
    if (this.remote == null) {
      hilog.error(0, 'testTag ui', `[app] the remote is null`);
      return;
    }

    let option = new rpc.MessageOption();
    let dataSend = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();

    dataSend.writeString(data);
    this.remote.sendMessageRequest(RequestCode.SetFeature, dataSend, reply, option).then((ret) => {
      hilog.info(0, 'testTag ui', `[app] setFeature success ret:${ret}, feature: ${data}`);
    }).catch(() => {
      hilog.info(0, 'testTag ui', '[app] setFeature failed');
    });
    return;
  }
}

