/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
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
import GlobalContext from './GlobalContext';
import { BusinessError } from '@kit.BasicServicesKit';
import DevParams from '../utils/DevParams';
import { RequestCode } from '../utils/RequestCode';

const VENDOR_ID: number = 9390; // 24AE
const PRODUCT_ID_LIST = [9488,49271, 25479, 24601, 45331, 4, 2112, 21904,4660, 22136, 8224]; // 1871

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
  // 标志位
  private bindState: boolean = false;
  private remote: rpc.RemoteObject | null = null;
  private isQuerying : boolean = false;
  private isBinding : boolean = false;
  private indexUI? : Index;
  private connectStatusChanged = false;

  // 供外部访问,当前绑定的设备信息
  public devices: Array<deviceManager.Device> = [];
  public vendorId: number = 0;		// 厂商标识
  public productId: number = 0;	// 产品标识
  public description: string = '';
  public deviceId: number = -1;
  public codeOfLastCommand: number = -1;
  public senseData: string = '';
  public readData: string = '';

  public devParams: DevParams = new DevParams();

  // 其他
  private message: string = '';
  private static instance: RpcTool;

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
    } catch (error) {
      hilog.error(0, 'testTag ui', 'bindDevice fail. Code:' + error.code + ', message:' + error.message);
      this.bindState = true;
      this.isBinding = true;
    }
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
    this.isQuerying = true;
    try {
      this.devices = deviceManager.queryDevices(deviceManager.BusType.USB);
      for (let item of this.devices) {
        let device = item as deviceManager.USBDevice;
        hilog.info(0, 'testTag ui', 'querydevice id:' + device.deviceId + ',bustype:' + device +
          ',vid:' + device.vendorId + ',pid:' + device.productId + ', des:' + device.description +
          ', des:' + device.description);
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
      this.getDeviceInfo();
      hilog.info(0, 'testTag ui', 'create remote success');
    } catch (error) {
      hilog.error(0, 'testTag ui', 'bindDevice fail. Code:' + error.code + ', message:' + error.message);
      this.bindState = false;
      this.isBinding = false;
    }
  }

  init(indexUI: Index) {
    this.indexUI = indexUI;
    hilog.info(0, 'testTag ui', 'init');
  }

  async bindDevice() {
    if (this.isQuerying || this.isBinding) {
      hilog.info(0, 'testTag ui', 'querying or binding, then leave');
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
      await this.remote.sendMessageRequest(RequestCode.ConnectStatus, dataSend, reply, option);
      let stat = reply.readInt();
      this.connectStatusChanged = (stat == 0 ? true : false);
      hilog.info(0, 'testTag ui', `getConnectStatus ${stat}`);
    } catch (error) {
      this.connectStatusChanged = false;
      hilog.info(0, 'testTag ui', 'getConnectStatus failed');
    }
  }

  getDeviceInfo() {
    hilog.info(0, 'testTag ui', `[app] getDeviceInfo enter`);
    // 直接调用rpc的接口向服务端发送消息，客户端需自行对入参进行序列化，对返回值进行反序列化，操作繁琐
    let option = new rpc.MessageOption();
    let dataSend = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();

    if (this.remote == null) {
      hilog.error(0, 'testTag ui', `[app] the remote is null`);
      return;
    }
    this.remote.sendMessageRequest(RequestCode.GetDeviceInfo, dataSend, reply, option).then((ret) => {
      reply.readInt();
      this.devParams.devType = reply.readInt();
      this.devParams.vendorId = reply.readString();
      this.devParams.productId = reply.readString();
      this.devParams.revision = reply.readString();
      let status2 = reply.readInt();
      if (status2 >= 0) {
        this.devParams.blockNum = reply.readLong() + 1;
        this.devParams.blockVolume = reply.readInt();
      } else {
        this.devParams.blockNum = reply.readLong();
        this.devParams.blockVolume = reply.readInt();
      }

      this.indexUI?.updataDevParamsComponent(this.devParams);
      hilog.info(0, 'testTag ui', `[app] getDeviceInfo ret:${ret} devType:${this.devParams.devType} vendorId:${this.vendorId}
                productId:${this.productId} revision:${this.devParams.revision} blockNum:${this.devParams.blockNum}
                blockVolume:${this.devParams.blockVolume}`);
    }).catch(() => {
      hilog.info(0, 'testTag ui', '[app] getDeviceInfo failed');
    });
  }

  inquiry() {
    hilog.info(0, 'testTag ui', `[app] inquiry() enter`);
    // 直接调用rpc的接口向服务端发送消息，客户端需自行对入参进行序列化，对返回值进行反序列化，操作繁琐
    let option = new rpc.MessageOption();
    let dataSend = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();

    if (this.remote == null) {
      hilog.error(0, 'testTag ui', `[app] the remote is null`);
      return;
    }
    this.remote.sendMessageRequest(RequestCode.Inquiry, dataSend, reply, option).then((ret) => {
      let result = reply.readInt(); // 接收命令的执行结果
      let devType = reply.readInt();
      let idVendor = reply.readString();
      let idProduct = reply.readString();
      let revision = reply.readString();
      let originData = reply.readString();
      let respData = 'devType: ' + devType + ';\n' +
                     ': ' + idVendor.trim() + ';\n' +
                     'productId: ' + idProduct.trim() + ';\n' +
                     'revision: ' + revision.trim + ';\n' +
                      'originData: ' + originData.trim() + ';\n';
      this.indexUI?.updateSendCommandComponent(result, respData);
      hilog.info(0, 'testTag ui', `[app] inquiry() result:${result} respData:${respData}`);
    }).catch(() => {
      hilog.info(0, 'testTag ui', '[app] inquiry() failed');
    });
  }

  capacityTransferToSuitUnit(devVolume: number) {
    let capacity = '';
    let devVolumeFloat = 0;
    if (devVolume < 1024) { // 字节
      capacity = 'capacity: ' + devVolumeFloat + 'B';
    } else if (devVolume >= 1024 && devVolume < (1024 * 1024)) {  // KB
      devVolumeFloat = devVolume / 1024;
      devVolumeFloat = Math.floor(devVolumeFloat * 100) / 100;
      capacity = 'capacity: ' + devVolumeFloat + 'KB';
    } else if (devVolume >= (1024 * 1024) && devVolume < (1024 * 1024 * 1024)) { // M
      devVolumeFloat = devVolume / 1024 / 1024;
      devVolumeFloat = Math.floor(devVolumeFloat * 100) / 100;
      capacity = 'capacity: ' + devVolumeFloat + 'M';
    } else if (devVolume >= (1024 * 1024 * 1024) && devVolume < (1024 * 1024 * 1024 * 1024)) { // G
      devVolumeFloat = devVolume / 1024 / 1024 / 1024;
      devVolumeFloat = Math.floor(devVolumeFloat * 100) / 100;
      capacity = 'capacity: ' + devVolumeFloat + 'G';
    } else if (devVolume >= (1024 * 1024 * 1024 * 1024) && devVolume < (1024 * 1024 * 1024 * 1024 * 1024)) { // T
      devVolumeFloat = devVolume / 1024 / 1024 / 1024 / 1024;
      devVolumeFloat = Math.floor(devVolumeFloat * 100) / 100;
      capacity = 'capacity: ' + devVolumeFloat + 'T';
    }

    return capacity;
  }

  readCapacity(blockAddr: number) {
    hilog.info(0, 'testTag ui', `[app] readCapacity() enter`);
    // 直接调用rpc的接口向服务端发送消息，客户端需自行对入参进行序列化，对返回值进行反序列化，操作繁琐
    let option = new rpc.MessageOption();
    let dataSend = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();

    if (this.remote == null) {
      hilog.error(0, 'testTag ui', `[app] the remote is null`);
      return;
    }

    dataSend.writeLong(blockAddr);
    this.remote.sendMessageRequest(RequestCode.ReadCapacity, dataSend, reply, option).then((ret) => {
      // 接收数据
      let result = reply.readInt(); // 接收命令的执行结果
      let lbAddr = reply.readLong();
      let blockVolume = reply.readInt();

      // 组装数据
      let respData = 'last LBA: ' + lbAddr + ';\n' +
                     'number of logical blocks: ' + (lbAddr + 1) + ';\n' +
                     'logical block length: ' + blockVolume + 'byte;\n';
      if (result < 0) {
        respData = '';
      }

      // 更新数据并在页面展示
      this.indexUI?.updateSendCommandComponent(result, respData);
      hilog.info(0, 'testTag ui', `[app] readCapacity() result: ${result}, respData:${respData}`);
    }).catch(() => {
      hilog.info(0, 'testTag ui', '[app] readCapacity() failed');
    });
  }

  testUnitReady(blockStartAddr:number, blockEndAddr:number) {
    hilog.info(0, 'testTag ui', `[app] testUnitReady() enter`);
    // 直接调用rpc的接口向服务端发送消息，客户端需自行对入参进行序列化，对返回值进行反序列化，操作繁琐
    let option = new rpc.MessageOption();
    let dataSend = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();

    if (this.remote == null) {
      hilog.error(0, 'testTag ui', `[app] the remote is null`);
      return;
    }
    this.remote.sendMessageRequest(RequestCode.TestUnitReady, dataSend, reply, option).then((ret) => {
      // 有待进一步验证确定
      let result = reply.readInt(); // 接收命令的执行结果
      this.indexUI?.updateSendCommandComponent(result, '');
      hilog.info(0, 'testTag ui', `[app] testUnitReady() result:${result} `);
    }).catch(() => {
      hilog.info(0, 'testTag ui', '[app] testUnitReady() failed');
    });
  }

  readBlockData(blockStartAddr:number, blockNum:number) {
    hilog.info(0, 'testTag ui', `[app] readBlockData() enter`);
    // 直接调用rpc的接口向服务端发送消息，客户端需自行对入参进行序列化，对返回值进行反序列化，操作繁琐
    let option = new rpc.MessageOption();
    let dataSend = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();

    dataSend.writeInt(blockStartAddr);
    dataSend.writeInt(blockNum);
    if (this.remote == null) {
      hilog.error(0, 'testTag ui', `[app] the remote is null`);
      return;
    }
    this.remote.sendMessageRequest(RequestCode.ReadBlockData, dataSend, reply, option).then((ret) => {
      let result = reply.readInt();  // 接收读操作的执行结果
      let respData = 'data: ' + reply.readString();
      this.indexUI?.updateSendCommandComponent(result, respData);
      hilog.info(0, 'testTag ui', `[app] readBlockData() readData:${respData}`);
    }).catch(() => {
      hilog.info(0, 'testTag ui', '[app] readBlockData() failed');
    });
  }

  writeBlockData(blockStartAddr:number, blockNum:number, dataFromInput:string) {
    hilog.info(0, 'testTag ui', `[app] writeBlockData() enter`);
    // 直接调用rpc的接口向服务端发送消息，客户端需自行对入参进行序列化，对返回值进行反序列化，操作繁琐
    let option = new rpc.MessageOption();
    let dataSend = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();

    dataSend.writeInt(blockStartAddr);
    dataSend.writeInt(blockNum);
    dataSend.writeString(dataFromInput);
    if (this.remote == null) {
      hilog.error(0, 'testTag ui', `[app] the remote is null`);
      return;
    }
    this.remote.sendMessageRequest(RequestCode.WriteBlockData, dataSend, reply, option).then((ret) => {
      let result = reply.readInt(); // 接收写操作的执行结果
      this.indexUI?.updateSendCommandComponent(result, '');
      hilog.info(0, 'testTag ui', `[app] writeBlockData() result:${result} `);
    }).catch(() => {
      hilog.info(0, 'testTag ui', '[app] writeBlockData() failed');
    });

    return;
  }

  verify(blockStartAddr:number, blockNum:number) {
    hilog.info(0, 'testTag ui', `[app] verify() enter`);
    // 直接调用rpc的接口向服务端发送消息，客户端需自行对入参进行序列化，对返回值进行反序列化，操作繁琐
    let option = new rpc.MessageOption();
    let dataSend = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();

    dataSend.writeInt(blockStartAddr);
    dataSend.writeInt(blockNum);
    if (this.remote == null) {
      hilog.error(0, 'testTag ui', `[app] the remote is null`);
      return;
    }
    this.remote.sendMessageRequest(RequestCode.VerifyBlockData, dataSend, reply, option).then((ret) => {
      let result = reply.readInt(); // 接收e命令的执行结果
      this.indexUI?.updateSendCommandComponent(result, '');
      hilog.info(0, 'testTag ui', `[app] verify() result:${result}`);
    }).catch(() => {
      hilog.info(0, 'testTag ui', '[app] verify() failed');
    });

    return;
  }

  requestSense() {
    hilog.info(0, 'testTag ui', `[app] requestSense() enter`);
    // 直接调用rpc的接口向服务端发送消息，客户端需自行对入参进行序列化，对返回值进行反序列化，操作繁琐
    let option = new rpc.MessageOption();
    let dataSend = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();

    if (this.remote == null) {
      hilog.error(0, 'testTag ui', `[app] the remote is null`);
      return;
    }
    this.remote.sendMessageRequest(RequestCode.RequestSense, dataSend, reply, option).then((ret) => {
      // 接收数据
      let result = reply.readInt(); // 接收request sense命令的执行结果
      let senseData = reply.readString();
      let senseInfo = reply.readString();

      // 组装数据
     let respData = 'sense data: ' + senseData + ';\n' + senseInfo;

      // 更新数据并显示到页面
      this.indexUI?.updateSendCommandComponent(result, respData);
      hilog.info(0, 'testTag ui', `[app] requestSense()  respData:${respData}`);
    }).catch(() => {
      hilog.info(0, 'testTag ui', '[app] requestSense() failed');
    });

    return;
  }

  sendCommonCDBData(cdbData: number[], extraData: string, cdbLen: number, dir: number) {
    hilog.info(0, 'testTag ui', `[app] sendCommonCDBData() enter`);
    // 直接调用rpc的接口向服务端发送消息，客户端需自行对入参进行序列化，对返回值进行反序列化，操作繁琐
    let option = new rpc.MessageOption();
    let dataSend = new rpc.MessageSequence();
    let reply = new rpc.MessageSequence();
    hilog.info(0, 'testTag ui', `sendCommonCDBData cmdData:${cdbData}, extraData:${extraData}`);
    dataSend.writeByteArray(cdbData);
    dataSend.writeString(extraData);
    dataSend.writeInt(cdbLen);
    dataSend.writeInt(dir);
    if (this.remote == null) {
      hilog.error(0, 'testTag ui', `[app] the remote is null`);
      return;
    }

    this.remote.sendMessageRequest(RequestCode.SendCdbData, dataSend, reply, option).then((ret) => {
      let result = reply.readInt();  // 接收命令执行结果
      let respData = reply.readString();  // 接收响应数据

      // 更新数据并显示到页面
      this.indexUI?.updateComCommandComponent(result, respData);
      hilog.info(0, 'testTag ui', `[app] sendCommonCDBData() result:${result} readData:${respData}  readDataLen:${respData.length} `);
    }).catch(() => {
      hilog.info(0, 'testTag ui', '[app] sendCommonCDBData() failed');
    });

    return;
  }
}

