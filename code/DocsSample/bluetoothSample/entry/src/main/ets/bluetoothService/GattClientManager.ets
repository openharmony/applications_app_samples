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

// [Start generic_attribute]
import { ble } from '@kit.ConnectivityKit';
import { constant } from '@kit.ConnectivityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { ToastReport } from '../common/ToastReport';
import util from '@ohos.util';

const TAG: string = 'GattClientManager';
// [StartExclude generic_attribute]
let encoder = new util.TextEncoder();
// [EndExclude generic_attribute]

export class GattData {
  public serviceUuid: string = '00001810-0000-1000-8000-00805F9B34FB';
  public characteristicUuid: string = '00001820-0000-1000-8000-00805F9B34FB';
  public descriptorUuid: string = '00002902-0000-1000-8000-00805F9B34FB';
  public characteristicValue: string = '';
  public descriptorValue: string = '';
}

export class GattClientManager {
  public device: string | undefined = undefined;
  public gattClient: ble.GattClientDevice | undefined = undefined;
  public connectState: ble.ProfileConnectionState = constant.ProfileConnectionState.STATE_DISCONNECTED;
  public myServiceUuid: string = '00001810-0000-1000-8000-00805F9B34FB';
  public myCharacteristicUuid: string = '00001820-0000-1000-8000-00805F9B34FB';
  public myDescriptorUuid: string = '00002902-0000-1000-8000-00805F9B34FB'; // 2902一般用于notification或者indication
  public myCharacteristicValue: string = ''
  public myDescriptorValue: string = ''
  public serviceResult: string = '';
  public found: boolean = false;
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
    let desLength = this.myDescriptorValue.length;
    let descBuffer = new ArrayBuffer(desLength);
    let descValue = new Uint8Array(descBuffer);
    encoder.encodeIntoUint8Array(this.myCharacteristicValue, descValue);
    descriptors[0] = this.initDescriptor(this.myDescriptorUuid, descBuffer);
    let length = this.myCharacteristicValue.length;
    let charBuffer = new ArrayBuffer(length);
    let charValue = new Uint8Array(charBuffer);
    encoder.encodeIntoUint8Array(this.myCharacteristicValue, charValue);
    let characteristic: ble.BLECharacteristic = {
      serviceUuid: this.myServiceUuid,
      characteristicUuid: this.myCharacteristicUuid,
      characteristicValue: charBuffer,
      descriptors: descriptors
    };
    return characteristic;
  }

  private logCharacteristic(char: ble.BLECharacteristic) {
    let message = 'logCharacteristic uuid:' + char.characteristicUuid + '\n';
    let value = new Uint8Array(char.characteristicValue);
    message += 'logCharacteristic value: ';
    for (let i = 0; i < char.characteristicValue.byteLength; i++) {
      message += value[i] + ' ';
    }
    console.info(TAG, message);
    // [StartExclude generic_attribute]
    this.toastReport.showResult(message);
    // [EndExclude generic_attribute]
  }

  private logDescriptor(des: ble.BLEDescriptor) {
    let message = 'logDescriptor uuid:' + des.descriptorUuid + '\n';
    let value = new Uint8Array(des.descriptorValue);
    message += 'logDescriptor value: ';
    for (let i = 0; i < des.descriptorValue.byteLength; i++) {
      message += value[i] + ' ';
    }
    console.info(TAG, message);
    // [StartExclude generic_attribute]
    this.toastReport.showResult(message);
    // [EndExclude generic_attribute]
  }

  private checkService(services: Array<ble.GattService>): boolean {
    for (let i = 0; i < services.length; i++) {
      if (services[i].serviceUuid != this.myServiceUuid) {
        continue;
      }
      for (let j = 0; j < services[i].characteristics.length; j++) {
        if (services[i].characteristics[j].characteristicUuid != this.myCharacteristicUuid) {
          continue;
        }
        for (let k = 0; k < services[i].characteristics[j].descriptors.length; k++) {
          if (services[i].characteristics[j].descriptors[k].descriptorUuid == this.myDescriptorUuid) {
            console.info(TAG, 'find expected service from server');
            return true;
          }
        }
      }
    }
    console.error(TAG, 'no expected service from server');
    return false;
  }

  public getResult(): string {
    return this.serviceResult;
  }

  public setGattData(data: GattData) {
    this.myServiceUuid = data.serviceUuid;
    this.myCharacteristicUuid = data.characteristicUuid;
    this.myDescriptorUuid = data.descriptorUuid;
    this.myCharacteristicValue = data.characteristicValue;
    this.myDescriptorValue = data.descriptorValue;
  }

  // 1. 订阅连接状态变化事件
  public onGattClientStateChange() {
    if (!this.gattClient) {
      console.error(TAG, 'no gattClient');
      return;
    }
    try {
      this.gattClient.on('BLEConnectionStateChange', (stateInfo: ble.BLEConnectionChangeState) => {
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
        console.info(TAG, 'onGattClientStateChange: device=' + stateInfo.deviceId + ', state=' + state);
        if (stateInfo.deviceId == this.device) {
          this.connectState = stateInfo.state;
        }
      });
    } catch (err) {
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  // 2. client端主动连接时调用
  public startConnect(peerDevice: string | undefined) { // 对端设备一般通过ble scan获取到
    if (this.connectState != constant.ProfileConnectionState.STATE_DISCONNECTED || peerDevice == undefined) {
      console.error(TAG, 'startConnect failed');
      return;
    }
    console.info(TAG, 'startConnect ' + peerDevice);
    this.device = peerDevice;
    // 2.1 使用device构造gattClient，后续的交互都需要使用该实例
    this.gattClient = ble.createGattClientDevice(peerDevice);
    try {
      this.onGattClientStateChange(); // 2.2 订阅连接状态
      this.gattClient.connect(); // 2.3 发起连接
      // [StartExclude generic_attribute]
      this.toastReport.showResult('startConnect success');
      console.info(TAG, 'startConnect success');
      // [EndExclude generic_attribute]
    } catch (err) {
      // [StartExclude generic_attribute]
      this.toastReport.showResult('startConnect fail');
      // [EndExclude generic_attribute]
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  // 3. client端连接成功后，需要进行服务发现
  public async discoverServices() {
    if (!this.gattClient) {
      console.info(TAG, 'no gattClient');
      return;
    }
    console.info(TAG, 'discoverServices');
    try {
      await this.gattClient.getServices().then((result: Array<ble.GattService>) => {
        console.info(TAG, 'getServices success: ' + JSON.stringify(result));
        // [StartExclude generic_attribute]
        this.serviceResult = JSON.stringify(result);
        this.toastReport.showResult('getServices success: ' + JSON.stringify(result));
        // [EndExclude generic_attribute]
        this.found = this.checkService(result); // 要确保server端的服务内容有业务所需要的服务
      });
    } catch (err) {
      // [StartExclude generic_attribute]
      this.toastReport.showResult('getServices fail');
      // [EndExclude generic_attribute]
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  // 4. 在确保拿到了server端的服务结果后，he
  public readCharacteristicValue() {
    if (!this.gattClient || this.connectState != constant.ProfileConnectionState.STATE_CONNECTED) {
      console.error(TAG, 'no gattClient or not connected');
      // [StartExclude generic_attribute]
      this.toastReport.showResult('no gattClient or not connected');
      // [EndExclude generic_attribute]
      return;
    }
    if (!this.found) { // 要确保server端有对应的characteristic
      console.error(TAG, 'no characteristic from server');
      // [StartExclude generic_attribute]
      this.toastReport.showResult('no characteristic from server');
      // [EndExclude generic_attribute]
      return;
    }

    let characteristic = this.initCharacteristic();
    console.info(TAG, 'readCharacteristicValue');
    try {
      this.gattClient.readCharacteristicValue(characteristic).then((outData: ble.BLECharacteristic) => {
        this.logCharacteristic(outData);
      })
      // [StartExclude generic_attribute]
      this.toastReport.showResult('readCharacteristicValue success');
      // [EndExclude generic_attribute]
    } catch (err) {
      // [StartExclude generic_attribute]
      this.toastReport.showResult('readCharacteristicValue fail');
      // [EndExclude generic_attribute]
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  // 5. 在确保拿到了server端的服务结果后，写入server端特定服务的特征值时调用
  public writeCharacteristicValue() {
    if (!this.gattClient || this.connectState != constant.ProfileConnectionState.STATE_CONNECTED) {
      console.error(TAG, 'no gattClient or not connected');
      // [StartExclude generic_attribute]
      this.toastReport.showResult('no gattClient or not connected');
      // [EndExclude generic_attribute]
      return;
    }
    if (!this.found) { // 要确保server端有对应的characteristic
      console.error(TAG, 'no characteristic from server');
      // [StartExclude generic_attribute]
      this.toastReport.showResult('no characteristic from server');
      // [EndExclude generic_attribute]
      return;
    }

    let characteristic = this.initCharacteristic();
    console.info(TAG, 'writeCharacteristicValue');
    try {
      this.gattClient.writeCharacteristicValue(characteristic, ble.GattWriteType.WRITE, (err) => {
        if (err) {
          console.error(TAG,
            'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
          return;
        }
        // [StartExclude generic_attribute]
        this.toastReport.showResult('writeCharacteristicValue success');
        // [EndExclude generic_attribute]
        console.info(TAG, 'writeCharacteristicValue success');
      });
    } catch (err) {
      // [StartExclude generic_attribute]
      console.info(TAG, 'writeCharacteristicValue fail');
      this.toastReport.showResult('writeCharacteristicValue fail');
      // [EndExclude generic_attribute]
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  // 6. 在确保拿到了server端的服务结果后，读取server端特定服务的描述符时调用
  public readDescriptorValue() {
    if (!this.gattClient || this.connectState != constant.ProfileConnectionState.STATE_CONNECTED) {
      console.error(TAG, 'no gattClient or not connected');
      // [StartExclude generic_attribute]
      this.toastReport.showResult('no gattClient or not connected');
      // [EndExclude generic_attribute]
      return;
    }
    if (!this.found) { // 要确保server端有对应的descriptor
      console.error(TAG, 'no descriptor from server');
      // [StartExclude generic_attribute]
      this.toastReport.showResult('no descriptor from server');
      // [EndExclude generic_attribute]
      return;
    }

    let descBuffer = new ArrayBuffer(0);
    let descriptor = this.initDescriptor(this.myDescriptorUuid, descBuffer);
    console.info(TAG, 'readDescriptorValue');
    try {
      this.gattClient.readDescriptorValue(descriptor).then((outData: ble.BLEDescriptor) => {
        this.logDescriptor(outData);
      });
      // [StartExclude generic_attribute]
      this.toastReport.showResult('readDescriptorValue success');
      // [EndExclude generic_attribute]
    } catch (err) {
      // [StartExclude generic_attribute]
      this.toastReport.showResult('readDescriptorValue fail');
      // [EndExclude generic_attribute]
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  // 7. 在确保拿到了server端的服务结果后，写入server端特定服务的描述符时调用
  public writeDescriptorValue() {
    if (!this.gattClient || this.connectState != constant.ProfileConnectionState.STATE_CONNECTED) {
      console.error(TAG, 'no gattClient or not connected');
      // [StartExclude generic_attribute]
      this.toastReport.showResult('no gattClient or not connected');
      // [EndExclude generic_attribute]
      return;
    }
    if (!this.found) { // 要确保server端有对应的descriptor
      console.error(TAG, 'no descriptor from server');
      // [StartExclude generic_attribute]
      this.toastReport.showResult('no descriptor from server');
      // [EndExclude generic_attribute]
      return;
    }

    let length = this.myDescriptorValue.length;
    let descBuffer = new ArrayBuffer(length);
    let descValue = new Uint8Array(descBuffer);
    encoder.encodeIntoUint8Array(this.myDescriptorValue, descValue);
    let descriptor = this.initDescriptor(this.myDescriptorUuid, descBuffer);
    console.info(TAG, 'writeDescriptorValue');
    try {
      this.gattClient.writeDescriptorValue(descriptor, (err) => {
        if (err) {
          console.error(TAG,
            'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
          return;
        }
        console.info(TAG, 'writeDescriptorValue success');
        // [StartExclude generic_attribute]
        this.toastReport.showResult('writeDescriptorValue success');
        // [EndExclude generic_attribute]
      });
    } catch (err) {
      // [StartExclude generic_attribute]
      this.toastReport.showResult('writeDescriptorValue fail');
      // [EndExclude generic_attribute]
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  // 8.client端主动断开时调用
  public stopConnect() {
    if (!this.gattClient || this.connectState != constant.ProfileConnectionState.STATE_CONNECTED) {
      console.error(TAG, 'no gattClient or not connected');
      return;
    }

    console.info(TAG, 'stopConnect ' + this.device);
    try {
      this.gattClient.disconnect(); // 8.1 断开连接
      this.gattClient.off('BLEConnectionStateChange', (stateInfo: ble.BLEConnectionChangeState) => {
      });
      this.gattClient.close() // 8.2 如果不再使用此gattClient，则需要close
      // [StartExclude generic_attribute]
      this.toastReport.showResult('stopConnect success');
      // [EndExclude generic_attribute]
    } catch (err) {
      // [StartExclude generic_attribute]
      this.toastReport.showResult('stopConnect fail');
      // [EndExclude generic_attribute]
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }
}

let gattClientManager = new GattClientManager();

export default gattClientManager as GattClientManager;
// [End generic_attribute]