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
import { BusinessError } from '@kit.BasicServicesKit';
import { ScanData } from '../common/ScanData';
import { ToastReport } from '../common/ToastReport';

const TAG: string = 'BleScanManager';

const BLE_ADV_TYPE_FLAG = 0x01;
const BLE_ADV_TYPE_16_BIT_SERVICE_UUIDS_INCOMPLETE = 0x02;
const BLE_ADV_TYPE_16_BIT_SERVICE_UUIDS_COMPLETE = 0x03;
const BLE_ADV_TYPE_32_BIT_SERVICE_UUIDS_INCOMPLETE = 0x04;
const BLE_ADV_TYPE_32_BIT_SERVICE_UUIDS_COMPLETE = 0x05;
const BLE_ADV_TYPE_128_BIT_SERVICE_UUIDS_INCOMPLETE = 0x06;
const BLE_ADV_TYPE_128_BIT_SERVICE_UUIDS_COMPLETE = 0x07;
const BLE_ADV_TYPE_LOCAL_NAME_SHORT = 0x08;
const BLE_ADV_TYPE_LOCAL_NAME_COMPLETE = 0x09;
const BLE_ADV_TYPE_TX_POWER_LEVEL = 0x0A;
const BLE_ADV_TYPE_16_BIT_SERVICE_SOLICITATION_UUIDS = 0x14;
const BLE_ADV_TYPE_128_BIT_SERVICE_SOLICITATION_UUIDS = 0x15;
const BLE_ADV_TYPE_32_BIT_SERVICE_SOLICITATION_UUIDS = 0x1F;
const BLE_ADV_TYPE_16_BIT_SERVICE_DATA = 0x16;
const BLE_ADV_TYPE_32_BIT_SERVICE_DATA = 0x20;
const BLE_ADV_TYPE_128_BIT_SERVICE_DATA = 0x21;
const BLE_ADV_TYPE_MANUFACTURER_SPECIFIC_DATA = 0xFF;

const BLUETOOTH_UUID_16_BIT_LENGTH = 2;
const BLUETOOTH_UUID_32_BIT_LENGTH = 4;
const BLUETOOTH_UUID_128_BIT_LENGTH = 16;

const BLUETOOTH_MANUFACTURE_ID_LENGTH = 2;

export class BleScanManager {
  private interval: number = 0;
  private manufactureId: number = 4567;
  private deviceName: string | undefined = '';
  private deviceId: string | undefined = '';
  private scanDataList: ScanData[] = [];
  public toastReport: ToastReport = new ToastReport();

  public setScanParameter(interval?: string, manufactureId?: string, deviceName?: string | undefined,
    deviceId?: string | undefined) {
    if (interval != undefined) {
      this.interval = Number(interval);
      console.info(TAG, 'interval is' + interval);
    }
    if (manufactureId != undefined) {
      console.info(TAG, 'manufactureId is' + manufactureId);
      this.manufactureId = Number(manufactureId);
    }
    this.deviceName = deviceName;
    this.deviceId = deviceId;
  }

  public getScanData(): ScanData[] {
    return this.scanDataList;
  }

  // 1 订阅扫描结果
  public onScanResult() {
    ble.on('BLEDeviceFind', (data: Array<ble.ScanResult>) => {
      if (data.length > 0) {
        console.info(TAG, 'BLE scan result = ' + data[0].deviceId);
        this.parseScanResult(data[0].data);
        this.toastReport.showResult(data[0].deviceId);
        if (!this.scanDataList.some(item => item.getDeviceName() === data[0].deviceName)) {
          this.scanDataList.push(new ScanData(data[0].deviceId, data[0].deviceName, data[0].rssi, data[0].connectable,
            new Uint8Array(data[0].data)));
        }
      }
    });
  }

  private parseScanResult(data: ArrayBuffer) {
    let advData = new Uint8Array(data);
    if (advData.byteLength == 0) {
      console.warn(TAG, 'nothing, adv data length is 0');
      return;
    }
    console.info(TAG, 'advData: ' + JSON.stringify(advData));

    let advFlags: number = -1;
    let txPowerLevel: number = -1;
    let localName: string = '';
    let serviceUuids: string[] = [];
    let serviceSolicitationUuids: string[] = [];
    let serviceDatas: Record<string, Uint8Array> = {};
    let manufactureSpecificDatas: Record<number, Uint8Array> = {};

    let curPos = 0;
    while (curPos < advData.byteLength) {
      let length = advData[curPos++];
      if (length == 0) {
        break;
      }
      let advDataLength = length - 1;
      let advDataType = advData[curPos++];
      switch (advDataType) {
        case BLE_ADV_TYPE_FLAG:
          advFlags = advData[curPos];
          break;
        case BLE_ADV_TYPE_LOCAL_NAME_SHORT:
        case BLE_ADV_TYPE_LOCAL_NAME_COMPLETE:
          localName = advData.slice(curPos, curPos + advDataLength).toString();
          break;
        case BLE_ADV_TYPE_TX_POWER_LEVEL:
          txPowerLevel = advData[curPos];
          break;
        case BLE_ADV_TYPE_16_BIT_SERVICE_UUIDS_INCOMPLETE:
        case BLE_ADV_TYPE_16_BIT_SERVICE_UUIDS_COMPLETE:
          this.parseServiceUuid(BLUETOOTH_UUID_16_BIT_LENGTH, curPos, advDataLength, advData, serviceUuids);
          break;
        case BLE_ADV_TYPE_32_BIT_SERVICE_UUIDS_INCOMPLETE:
        case BLE_ADV_TYPE_32_BIT_SERVICE_UUIDS_COMPLETE:
          this.parseServiceUuid(BLUETOOTH_UUID_32_BIT_LENGTH, curPos, advDataLength, advData, serviceUuids);
          break;
        case BLE_ADV_TYPE_128_BIT_SERVICE_UUIDS_INCOMPLETE:
        case BLE_ADV_TYPE_128_BIT_SERVICE_UUIDS_COMPLETE:
          this.parseServiceUuid(BLUETOOTH_UUID_128_BIT_LENGTH, curPos, advDataLength, advData, serviceUuids);
          break;
        case BLE_ADV_TYPE_16_BIT_SERVICE_SOLICITATION_UUIDS:
          this.parseServiceSolicitationUuid(BLUETOOTH_UUID_16_BIT_LENGTH, curPos, advDataLength,
            advData, serviceSolicitationUuids);
          break;
        case BLE_ADV_TYPE_32_BIT_SERVICE_SOLICITATION_UUIDS:
          this.parseServiceSolicitationUuid(BLUETOOTH_UUID_32_BIT_LENGTH, curPos, advDataLength,
            advData, serviceSolicitationUuids);
          break;
        case BLE_ADV_TYPE_128_BIT_SERVICE_SOLICITATION_UUIDS:
          this.parseServiceSolicitationUuid(BLUETOOTH_UUID_128_BIT_LENGTH, curPos, advDataLength,
            advData, serviceSolicitationUuids);
          break;
        case BLE_ADV_TYPE_16_BIT_SERVICE_DATA:
          this.parseServiceData(BLUETOOTH_UUID_16_BIT_LENGTH, curPos, advDataLength, advData, serviceDatas);
          break;
        case BLE_ADV_TYPE_32_BIT_SERVICE_DATA:
          this.parseServiceData(BLUETOOTH_UUID_32_BIT_LENGTH, curPos, advDataLength, advData, serviceDatas);
          break;
        case BLE_ADV_TYPE_128_BIT_SERVICE_DATA:
          this.parseServiceData(BLUETOOTH_UUID_128_BIT_LENGTH, curPos, advDataLength, advData, serviceDatas);
          break;
        case BLE_ADV_TYPE_MANUFACTURER_SPECIFIC_DATA:
          this.parseManufactureData(curPos, advDataLength, advData, manufactureSpecificDatas);
          break;
        default:
          break;
      }
      curPos += advDataLength;
    }
  }

  private parseServiceUuid(uuidLength: number, curPos: number, advDataLength: number,
    advData: Uint8Array, serviceUuids: string[]) {
    while (advDataLength > 0) {
      let tmpData: Uint8Array = advData.slice(curPos, curPos + uuidLength);
      serviceUuids.push(this.getUuidFromUint8Array(uuidLength, tmpData));
      advDataLength -= uuidLength;
      curPos += uuidLength;
    }
  }

  private parseServiceSolicitationUuid(uuidLength: number, curPos: number, advDataLength: number,
    advData: Uint8Array, serviceSolicitationUuids: string[]) {
    while (advDataLength > 0) {
      let tmpData: Uint8Array = advData.slice(curPos, curPos + uuidLength);
      serviceSolicitationUuids.push(this.getUuidFromUint8Array(uuidLength, tmpData));
      advDataLength -= uuidLength;
      curPos += uuidLength;
    }
  }

  private getUuidFromUint8Array(uuidLength: number, uuidData: Uint8Array): string {
    let uuid = '';
    let temp: string = '';
    for (let i = uuidLength - 1; i > -1; i--) {
      temp += uuidData[i].toString(16).padStart(2, '0');
    }
    switch (uuidLength) {
      case BLUETOOTH_UUID_16_BIT_LENGTH:
        uuid = `0000${temp}-0000-1000-8000-00805F9B34FB`;
        break;
      case BLUETOOTH_UUID_32_BIT_LENGTH:
        uuid = `${temp}-0000-1000-8000-00805F9B34FB`;
        break;
      case BLUETOOTH_UUID_128_BIT_LENGTH:
        uuid = `${temp.substring(0, 8)}-${temp.substring(8, 12)}-${temp.substring(12, 16)}-${temp.substring(16,
          20)}-${temp.substring(20, 32)}`;
        break;
      default:
        break;
    }
    return uuid;
  }

  private parseServiceData(uuidLength: number, curPos: number, advDataLength: number,
    advData: Uint8Array, serviceDatas: Record<string, Uint8Array>) {
    let tmpUuid: Uint8Array = advData.slice(curPos, curPos + uuidLength);
    let tmpValue: Uint8Array = advData.slice(curPos + uuidLength, curPos + advDataLength);
    serviceDatas[tmpUuid.toString()] = tmpValue;
  }

  private parseManufactureData(curPos: number, advDataLength: number,
    advData: Uint8Array, manufactureSpecificDatas: Record<number, Uint8Array>) {
    let manufactureId: number = (advData[curPos + 1] << 8) + advData[curPos];
    let tmpValue: Uint8Array = advData.slice(curPos + BLUETOOTH_MANUFACTURE_ID_LENGTH, curPos + advDataLength);
    manufactureSpecificDatas[manufactureId] = tmpValue;
  }

  // 2 开启扫描
  public startScan() {
    console.info(TAG, 'startBleScan success 1');
    // 2.1 构造扫描过滤器，需要能够匹配预期的广播包内容
    let manufactureId = this.manufactureId;
    let manufactureDataMask: Uint8Array = new Uint8Array([0xFF, 0xFF, 0xFF, 0xFF]);
    let scanFilter: ble.ScanFilter = {
      // 根据业务实际情况定义过滤器
      manufactureId: manufactureId,
      // manufactureData: manufactureData.buffer,
      manufactureDataMask: manufactureDataMask.buffer,
    };
    if (this.deviceName) {
      console.info('===lyk=== deviceName is not null ' + this.deviceName)
      scanFilter.name = this.deviceName;
    }
    if (this.deviceId) {
      scanFilter.deviceId = this.deviceId;
    }
    // 2.2 构造扫描参数
    let scanOptions: ble.ScanOptions = {
      interval: this.interval,
      dutyMode: ble.ScanDuty.SCAN_MODE_LOW_POWER,
      matchMode: ble.MatchMode.MATCH_MODE_AGGRESSIVE,
    }
    try {
      this.scanDataList = [];
      this.onScanResult(); // 订阅扫描结果
      ble.startBLEScan([scanFilter], scanOptions);
      this.toastReport.showResult('startBleScan success');
      console.info(TAG, 'startBleScan success');
    } catch (err) {
      this.toastReport.showResult('startBleScan fail');
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  // 3 关闭扫描
  public stopScan() {
    try {
      ble.off('BLEDeviceFind', (data: Array<ble.ScanResult>) => { // 取消订阅扫描结果
        console.info(TAG, 'off success');
      });
      ble.stopBLEScan();
      this.toastReport.showResult('stopBleScan success');
      console.info(TAG, 'stopBleScan success');
    } catch (err) {
      this.toastReport.showResult('stopBleScan fail');
      console.error(TAG, 'errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }
}

let bleScanManager = new BleScanManager();

export default bleScanManager as BleScanManager;
