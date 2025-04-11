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

import { ble } from '@kit.ConnectivityKit';
import { constant } from '@kit.ConnectivityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { ToastReport } from '../common/ToastReport'

const TAG: string = 'GattServerManager';

export class GattServerManager {
  public gattServer: ble.GattServer = ble.createGattServer();
  public connectState: ble.ProfileConnectionState = constant.ProfileConnectionState.STATE_DISCONNECTED;
  public myServiceUuid: string = '00001810-0000-1000-8000-00805F9B34FB';
  public myCharacteristicUuid: string = '00001820-0000-1000-8000-00805F9B34FB';
  public myFirstDescriptorUuid: string = '00002902-0000-1000-8000-00805F9B34FB'; // 2902一般用于notification或者indication
  public mySecondDescriptorUuid: string = '00002903-0000-1000-8000-00805F9B34FB';
  public toastReport: ToastReport = new ToastReport();

  // 构造BLEDescriptor
  private initDescriptor(des: string, value: ArrayBuffer): ble.BLEDescriptor {
    let descriptor: ble.BLEDescriptor = {
      serviceUuid: this.myServiceUuid,
      characteristicUuid: this.myCharacteristicUuid,
      descriptorUuid: des,
      descriptorValue: value
    };
    return descriptor;
  }

  // 构造BLECharacteristic
  private initCharacteristic(): ble.BLECharacteristic {
    let descriptors: ble.BLEDescriptor[] = [];
    let descBuffer = new ArrayBuffer(2);
    let descValue = new Uint8Array(descBuffer);
    descValue[0] = 31;
    descValue[1] = 32;
    descriptors[0] = this.initDescriptor(this.myFirstDescriptorUuid, new ArrayBuffer(2));
    descriptors[1] = this.initDescriptor(this.mySecondDescriptorUuid, descBuffer);
    let charBuffer = new ArrayBuffer(2);
    let charValue = new Uint8Array(charBuffer);
    charValue[0] = 21;
    charValue[1] = 22;
    let characteristic: ble.BLECharacteristic = {
      serviceUuid: this.myServiceUuid,
      characteristicUuid: this.myCharacteristicUuid,
      characteristicValue: charBuffer,
      descriptors: descriptors
    };
    return characteristic;
  }

  // 1. 订阅连接状态变化事件
  public onGattServerStateChange() {
    if (!this.gattServer) {
      console.error(TAG, 'no gattServer');
      return;
    }
    try {
      this.gattServer.on('connectionStateChange', (stateInfo: ble.BLEConnectionChangeState) => {
        let state = '';
        switch (stateInfo.state) {
          case 0:
            state = 'DISCONNECTED';
            break;
          case 1:
            state = 'CONNECTING';
            break;
          case 2:
            state = 'CONNECTED';
            break;
          case 3:
            state = 'DISCONNECTING';
            break;
          default:
            state = 'undefined';
            break;
        }
        console.info(TAG, 'onGattServerStateChange: device=' + stateInfo.deviceId + ', state=' + state);
      });
    } catch (err) {
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  // 2. server端注册服务时调用
  public registerServer() {
    let characteristics: ble.BLECharacteristic[] = [];
    let characteristic = this.initCharacteristic();
    characteristics.push(characteristic);
    let gattService: ble.GattService = {
      serviceUuid: this.myServiceUuid,
      isPrimary: true,
      characteristics: characteristics
    };

    console.info(TAG, 'registerServer ' + this.myServiceUuid);
    try {
      // this.gattServer = ble.createGattServer(); 初始化时已经构造，去除报错// 2.1 构造gattServer，后续的交互都需要使用该实例
      this.onGattServerStateChange(); // 2.2 订阅连接状态
      this.gattServer.addService(gattService);
      this.toastReport.showResult('registerServer success');
    } catch (err) {
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
      this.toastReport.showResult('registerServer failed');
    }
  }

  // 3. 订阅来自gattClient的读取特征值请求时调用
  public onCharacteristicRead() {
    if (!this.gattServer) {
      console.error(TAG, 'no gattServer');
      return;
    }

    console.info(TAG, 'onCharacteristicRead');
    try {
      this.gattServer.on('characteristicRead', (charReq: ble.CharacteristicReadRequest) => {
        let deviceId: string = charReq.deviceId;
        let transId: number = charReq.transId;
        let offset: number = charReq.offset;
        console.info(TAG, 'receive characteristicRead');
        let rspBuffer = new ArrayBuffer(2);
        let rspValue = new Uint8Array(rspBuffer);
        rspValue[0] = 21;
        rspValue[1] = 22;
        let serverResponse: ble.ServerResponse = {
          deviceId: deviceId,
          transId: transId,
          status: 0, // 0表示成功
          offset: offset,
          value: rspBuffer
        };

        try {
          this.gattServer.sendResponse(serverResponse);
        } catch (err) {
          console.error(TAG,
            'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
        }
      });
    } catch (err) {
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  // 4. 订阅来自gattClient的写入特征值请求时调用
  public onCharacteristicWrite() {
    if (!this.gattServer) {
      console.error(TAG, 'no gattServer');
      return;
    }

    console.info(TAG, 'onCharacteristicWrite');
    try {
      this.gattServer.on('characteristicWrite', (charReq: ble.CharacteristicWriteRequest) => {
        let deviceId: string = charReq.deviceId;
        let transId: number = charReq.transId;
        let offset: number = charReq.offset;
        console.info(TAG, 'receive characteristicWrite: needRsp=' + charReq.needRsp);
        if (!charReq.needRsp) {
          return;
        }
        let rspBuffer = new ArrayBuffer(0);
        let serverResponse: ble.ServerResponse = {
          deviceId: deviceId,
          transId: transId,
          status: 0, // 0表示成功
          offset: offset,
          value: rspBuffer
        };

        try {
          this.gattServer.sendResponse(serverResponse);
        } catch (err) {
          console.error(TAG,
            'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
        }
      });
    } catch (err) {
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  // 5. 订阅来自gattClient的读取描述符请求时调用
  public onDescriptorRead() {
    if (!this.gattServer) {
      console.error(TAG, 'no gattServer');
      return;
    }

    console.info(TAG, 'onDescriptorRead');
    try {
      this.gattServer.on('descriptorRead', (desReq: ble.DescriptorReadRequest) => {
        let deviceId: string = desReq.deviceId;
        let transId: number = desReq.transId;
        let offset: number = desReq.offset;
        console.info(TAG, 'receive descriptorRead');
        let rspBuffer = new ArrayBuffer(2);
        let rspValue = new Uint8Array(rspBuffer);
        rspValue[0] = 31;
        rspValue[1] = 32;
        let serverResponse: ble.ServerResponse = {
          deviceId: deviceId,
          transId: transId,
          status: 0, // 0表示成功
          offset: offset,
          value: rspBuffer
        };

        try {
          this.gattServer.sendResponse(serverResponse);
        } catch (err) {
          console.error(TAG,
            'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
        }
      });
    } catch (err) {
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  // 6. 订阅来自gattClient的写入描述符请求时调用
  public onDescriptorWrite() {
    if (!this.gattServer) {
      console.error(TAG, 'no gattServer');
      return;
    }

    console.info(TAG, 'onDescriptorWrite');
    try {
      this.gattServer.on('descriptorWrite', (desReq: ble.DescriptorWriteRequest) => {
        let deviceId: string = desReq.deviceId;
        let transId: number = desReq.transId;
        let offset: number = desReq.offset;
        console.info(TAG, 'receive descriptorWrite: needRsp=' + desReq.needRsp);
        if (!desReq.needRsp) {
          return;
        }
        let rspBuffer = new ArrayBuffer(0);
        let serverResponse: ble.ServerResponse = {
          deviceId: deviceId,
          transId: transId,
          status: 0, // 0表示成功
          offset: offset,
          value: rspBuffer
        };

        try {
          this.gattServer.sendResponse(serverResponse);
        } catch (err) {
          console.error(TAG,
            'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
        }
      });
    } catch (err) {
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  // 7. server端删除服务，不再使用时调用
  public unRegisterServer() {
    if (!this.gattServer) {
      console.error(TAG, 'no gattServer');
      return;
    }

    console.info(TAG, 'unRegisterServer ' + this.myServiceUuid);
    try {
      this.gattServer.removeService(this.myServiceUuid); // 7.1 删除服务
      this.gattServer.off('connectionStateChange', (stateInfo: ble.BLEConnectionChangeState) => { // 7.2 取消订阅连接状态
      });
      this.gattServer.close() // 7.3 如果不再使用此gattServer，则需要close
      this.toastReport.showResult('unRegisterServer');
    } catch (err) {
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }
}

let gattServerManager = new GattServerManager();

export default gattServerManager as GattServerManager;