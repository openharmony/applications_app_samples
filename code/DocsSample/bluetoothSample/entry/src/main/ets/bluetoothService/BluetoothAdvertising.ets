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

// [Start open_close_advertising]
import { ble } from '@kit.ConnectivityKit';
import { BusinessError } from '@kit.BasicServicesKit';
import { ToastReport } from '../common/ToastReport';

const TAG: string = 'BleAdvertisingManager';

export class BleAdvertisingManager {
  private advHandle: number = 0xFF; // default invalid value
  private manufactureValueBuffer: Uint8Array = new Uint8Array();
  private serviceUuids: string = '00001888-0000-1000-8000-00805f9b34fb';
  private serviceBuffer = new Uint8Array();
  private manufactureId: number = 0;
  private includeDeviceName: boolean = false;
  public toastReport: ToastReport = new ToastReport();

  public setAdvertisingParameter(manufactureId?: number, manufactureValueBuffer?: Uint8Array,
    serviceUuids?: string, serviceBuffer?: Uint8Array, includeDeviceName?: boolean) {
    if (manufactureId != undefined) {
      this.manufactureId = Number(manufactureId);
      console.info(TAG, 'manufactureId is ' + manufactureId);
    }
    if (manufactureValueBuffer != undefined) {
      console.info(TAG, 'manufactureValueBuffer is ' + manufactureValueBuffer);
      this.manufactureValueBuffer = manufactureValueBuffer;
    } else {

    }
    if (serviceUuids) {
      this.serviceUuids = serviceUuids;
    }
    if (serviceBuffer) {
      this.serviceBuffer = serviceBuffer;
    }
    this.includeDeviceName = includeDeviceName ? true : false;
  }

  // 1 订阅广播状态
  public onAdvertisingStateChange() {
    try {
      ble.on('advertisingStateChange', (data: ble.AdvertisingStateChangeInfo) => {
        console.info(TAG, 'bluetooth advertising state = ' + JSON.stringify(data));
        AppStorage.setOrCreate('advertiserState', data.state);
      });
    } catch (err) {
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  // 2 首次启动广播
  public async startAdvertising() {
    // 2.1 设置广播发送的参数
    console.info('startAdvertising 2.1')
    let setting: ble.AdvertiseSetting = {
      interval: 160,
      txPower: 0,
      connectable: true
    };
    // 2.2 构造广播数据
    console.info('startAdvertising 2.2')
    let manufactureValueBuffer = new Uint8Array(4);
    manufactureValueBuffer[0] = 1;
    manufactureValueBuffer[1] = 2;
    manufactureValueBuffer[2] = 3;
    manufactureValueBuffer[3] = 4;
    let serviceValueBuffer = new Uint8Array(4);
    serviceValueBuffer[0] = 5;
    serviceValueBuffer[1] = 6;
    serviceValueBuffer[2] = 7;
    serviceValueBuffer[3] = 8;
    let manufactureDataUnit: ble.ManufactureData = {
      manufactureId: this.manufactureId,
      manufactureValue: this.manufactureValueBuffer.buffer
    };
    let serviceDataUnit: ble.ServiceData = {
      serviceUuid: this.serviceUuids,
      serviceValue: this.serviceBuffer.buffer
    };
    let advData: ble.AdvertiseData = {
      serviceUuids: [this.serviceUuids],
      manufactureData: [manufactureDataUnit],
      serviceData: [serviceDataUnit],
      includeDeviceName: this.includeDeviceName // 表示是否携带设备名，可选参数。注意带上设备名时广播包长度不能超出31个字节。
    };
    let advResponse: ble.AdvertiseData = {
      serviceUuids: [this.serviceUuids],
      manufactureData: [manufactureDataUnit],
      serviceData: [serviceDataUnit]
    };
    // 2.3 构造广播启动完整参数AdvertisingParams
    console.info('startAdvertising 2.3')
    let advertisingParams: ble.AdvertisingParams = {
      advertisingSettings: setting,
      advertisingData: advData,
      advertisingResponse: advResponse,
      duration: 0 // 可选参数，若大于0，则广播发送一段时间后，则会临时停止，可重新启动发送
    }

    // 2.4 首次启动广播，且获取所启动广播的标识ID
    console.info('startAdvertising 2.4')
    try {
      this.onAdvertisingStateChange();
      this.advHandle = await ble.startAdvertising(advertisingParams);
      this.toastReport.showResult('bluetooth startAdvertising start success');
      console.info('startAdvertising succeed');
    } catch (err) {
      this.toastReport.showResult('bluetooth startAdvertising start fail');
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  // 4 临时停止广播，该广播资源仍然存在
  public async disableAdvertising() {
    // 4.1 构造临时停止广播参数
    console.info('disableAdvertising 4.1')
    let advertisingDisableParams: ble.AdvertisingDisableParams = {
      advertisingId: this.advHandle // 使用首次启动广播时获取到的广播标识ID
    }
    // 4.2 临时停止
    console.info('disableAdvertising 4.2')
    try {
      await ble.disableAdvertising(advertisingDisableParams);
      this.toastReport.showResult('bluetooth disableAdvertising');
      console.info('bluetooth disableAdvertising success');
    } catch (err) {
      this.toastReport.showResult('bluetooth disableAdvertising fail');
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  // 5 再次启动广播
  public async enableAdvertising(enableDuration: number) {
    // 5.1 构造临时启动广播参数
    console.info('enableAdvertising 5.1')
    let advertisingEnableParams: ble.AdvertisingEnableParams = {
      advertisingId: this.advHandle, // 使用首次启动广播时获取到的广播标识ID
      duration: enableDuration
    }
    // 5.2 再次启动
    console.info('enableAdvertising 5.2')
    try {
      this.toastReport.showResult('bluetooth enableAdvertising continue');
      await ble.enableAdvertising(advertisingEnableParams);
    } catch (err) {
      this.toastReport.showResult('bluetooth enableAdvertising fail');
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  // 6 完全关闭广播，释放广播资源
  public async stopAdvertising() {
    try {
      this.toastReport.showResult('bluetooth advertising stop success');
      await ble.stopAdvertising(this.advHandle);
      ble.off('advertisingStateChange', (data: ble.AdvertisingStateChangeInfo) => {
        console.info(TAG, 'bluetooth advertising state = ' + JSON.stringify(data));
        this.toastReport.showResult('bluetooth advertising stop');
      });
    } catch (err) {
      this.toastReport.showResult('bluetooth advertising stop fail');
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }
}

let bleAdvertisingManager = new BleAdvertisingManager();

export default bleAdvertisingManager as BleAdvertisingManager;
// [End open_close_advertising]