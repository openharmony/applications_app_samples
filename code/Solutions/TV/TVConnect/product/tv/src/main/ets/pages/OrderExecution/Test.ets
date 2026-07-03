/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
import ble from '@ohos.bluetooth.ble';
import { BusinessError } from '@ohos.base';
import common from '@ohos.app.ability.common';
import abilityAccessCtrl from '@ohos.abilityAccessCtrl';
import { prompt, promptAction, router } from '@kit.ArkUI';
import dataPreferences from '@ohos.data.preferences';
import emitter from '@ohos.events.emitter';
import { Logger } from '@ohos/common';

let preferences: dataPreferences.Preferences | null = null;
let context = getContext();
dataPreferences.getPreferences(context, 'myStore', (err: BusinessError, val: dataPreferences.Preferences) => {
  if (err) {
    Logger.error('Failed to get preferences. code =' + err.code + ', message =' + err.message);
    return;
  }
  preferences = val;
  Logger.info('Succeeded in getting preferences.');
});

let manufactureValueBuffer = new Uint8Array(2);
manufactureValueBuffer[0] = 1;
manufactureValueBuffer[1] = 2;
let manufactureValueBuffer1 = new Uint8Array(2);
manufactureValueBuffer1[0] = 0;
manufactureValueBuffer1[1] = 2;
let serviceValueBuffer = new Uint8Array(4);
serviceValueBuffer[0] = 4;
serviceValueBuffer[1] = 6;
serviceValueBuffer[2] = 7;
serviceValueBuffer[3] = 8;
let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
let open = false;
let open1 = false;
let tmprssi = -999;
let dat = '';
let calibration = false;
let scanResult: number[] = [];
let scanResult1: number[] = [];
let scanResult3: number[] = [];

let openadvstatus = false;
let closeadvstatus = false;
let average1 = -65;
let average2 = -75;
let avtimes05 = 0;
let setInterval1 = 0;
let setInterval2 = 0;
let setInterval3 = 0;
let count = 0;

function onReceiveEvent(data: Array<ble.ScanResult>) {
  if (data[0].deviceName.startsWith('Oh-YHBSScreen-100022')) {
    if (calibration) {
      let arr = new Uint8Array(data[0].data);
      Logger.info('' + JSON.stringify(arr));
      dat = dat + '  ' + arr[11].toString();
      calibration = false;
    }
    scanResult3.push(data[0].rssi);
    if (open1) {
      scanResult1.push(data[0].rssi);
    }
    if (open) {
      scanResult.push(data[0].rssi);
    }
    tmprssi = data[0].rssi;
    if (data[0].deviceName == 'Oh-YHBSScreen-1000221001' && count == 0) {
      let eventData: emitter.EventData = {
        data: {}
      };
      let innerEvent: emitter.InnerEvent = {
        eventId: 10086,
        priority: emitter.EventPriority.HIGH
      };

      emitter.emit(innerEvent, eventData);
      count++;
    }
    if (data[0].deviceName == 'Oh-YHBSScreen-1000220001') {
      count = 0;
    }
  }

}

export function startbluscan() {
  try {
    ble.on('BLEDeviceFind', onReceiveEvent);
    let scanOptions: ble.ScanOptions = {
      interval: 0,
      dutyMode: ble.ScanDuty.SCAN_MODE_LOW_LATENCY,
      matchMode: ble.MatchMode.MATCH_MODE_AGGRESSIVE,
    };
    try {
      ble.startBLEScan(null, scanOptions);
      Logger.info(' succes');
    } catch (err) {
      Logger.error(' errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  } catch (err) {
    Logger.error(' errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
  }
}

function openadv() {
  try {
    let setting: ble.AdvertiseSetting = {
      interval: 32,
      txPower: -10,
      connectable: true,
    };
    let manufactureDataUnit: ble.ManufactureData = {
      manufactureId: 4567,
      manufactureValue: manufactureValueBuffer.buffer
    };
    let serviceDataUnit: ble.ServiceData = {
      serviceUuid: '00001888-0000-1000-8000-00805f9b34fb',
      serviceValue: serviceValueBuffer.buffer
    };
    let advData: ble.AdvertiseData = {
      serviceUuids: ['00001888-0000-1000-8000-00805f9b34fb'],
      manufactureData: [manufactureDataUnit],
      serviceData: [serviceDataUnit],
      includeDeviceName: true,
    };
    let advResponse: ble.AdvertiseData = {
      serviceUuids: ['00001888-0000-1000-8000-00805f9b34fb'],
      manufactureData: [manufactureDataUnit],
      serviceData: [serviceDataUnit],
      includeDeviceName: true,
    };
    ble.startAdvertising(setting, advData, advResponse);

    Logger.info(' sucess openadv');
  } catch (err) {
    Logger.error('errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
  }
}

function closeadv() {
  try {
    let setting: ble.AdvertiseSetting = {
      interval: 32,
      txPower: -10,
      connectable: true,
    };
    let manufactureDataUnit: ble.ManufactureData = {
      manufactureId: 4567,
      manufactureValue: manufactureValueBuffer1.buffer
    };
    let serviceDataUnit: ble.ServiceData = {
      serviceUuid: '00001888-0000-1000-8000-00805f9b34fb',
      serviceValue: serviceValueBuffer.buffer
    };
    let advData: ble.AdvertiseData = {
      serviceUuids: ['00001888-0000-1000-8000-00805f9b34fb'],
      manufactureData: [manufactureDataUnit],
      serviceData: [serviceDataUnit],
      includeDeviceName: true,
    };
    let advResponse: ble.AdvertiseData = {
      serviceUuids: ['00001888-0000-1000-8000-00805f9b34fb'],
      manufactureData: [manufactureDataUnit],
      serviceData: [serviceDataUnit],
      includeDeviceName: true,
    };
    ble.startAdvertising(setting, advData, advResponse);

    Logger.info(' sucess closeadv');
  } catch (err) {
    Logger.error('errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
  }
}

function average(arr: Array<number>) {
  const sum = arr.reduce((acc, val) => acc + val, 0);
  return sum / arr.length;
}

export function start() {
  setInterval1 = setInterval(() => {
    avtimes05 = average(scanResult3);
    scanResult3 = [];
  }, 500);
  if (preferences != null) {
    preferences.get('average1', 'default', (err: BusinessError, val: dataPreferences.ValueType) => {
      if (err) {
        Logger.error('Failed to get value of "startup". code =' + err.code + ', message =' + err.message);
        return;
      }
      if (val != 'default') {
        average1 = Number(val);
      }
      Logger.info('Succeeded in getting value of "startup". val： ' + val);
    });
    preferences.get('average2', 'default', (err: BusinessError, val: dataPreferences.ValueType) => {
      if (err) {
        Logger.error('Failed to get value of "startup". code =' + err.code + ', message =' + err.message);
        return;
      }
      if (val != 'default') {
        average2 = Number(val);
      }
      Logger.info('Succeeded in getting value of "startup". val： ' + val);
    });
  }
  setInterval2 = setInterval(() => {
    if (avtimes05 > average1 && openadvstatus == false) {
      promptAction.showToast({
        message: $r('app.string.closeToPatient'),
        duration: 1000
      });
      openadv();
      try {
        ble.stopAdvertising();
      } catch (err) {
        Logger.error('errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
      }
      setTimeout(() => {
        openadv();
      }, 300);
      openadvstatus = true;
      closeadvstatus = false;
    } else if (closeadvstatus == false && avtimes05 < average2) {
      promptAction.showToast({
        message: $r('app.string.StayAwayFromPatient'),
        duration: 1000
      });
      closeadv();
      try {
        ble.stopAdvertising();
      } catch (err) {
        Logger.error('errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
      }
      setTimeout(() => {
        closeadv();
      }, 300);
      closeadvstatus = true;
      openadvstatus = false;
    }
  }, 1000);
}

@Entry
@Component
struct Index {
  @State value: string = '';
  @State i: string = '';

  aboutToAppear(): void {
    startbluscan();
    setInterval3 = setInterval(() => {
      this.i = tmprssi.toString();
    }, 100);
    const context: common.UIAbilityContext = getContext(this) as common.UIAbilityContext;
    try {
      atManager.requestPermissionsFromUser(context, ['ohos.permission.ACCESS_BLUETOOTH']).then((data) => {
        startbluscan();
        Logger.info('data: ' + JSON.stringify(data));
      }).catch((err: object) => {
        Logger.info('err: ' + JSON.stringify(err));
      });
    } catch (err) {
      Logger.info('catch err->' + JSON.stringify(err));
    }
  }

  build() {
    Row() {
      Column() {
        Text('RSSI: ' + this.i)
          .fontSize(50);
        Button('Reset')
          .margin(20)
          .onClick(() => {
            if (preferences != null) {
              preferences.put('average1', average1, (err: BusinessError) => {
                if (err) {
                  Logger.error('Failed to put value of "startup". code =' + err.code + ', message =' + err.message);
                  return;
                }
                Logger.info('Succeeded in putting value of "startup".');
              });
              preferences.put('average2', average2, (err: BusinessError) => {
                if (err) {
                  Logger.error('Failed to put value of "startup". code =' + err.code + ', message =' + err.message);
                  return;
                }
                Logger.info('Succeeded in putting value of "startup".');
              });
              preferences.flush((err: BusinessError) => {
                if (err) {
                  Logger.error('Failed to flush. code =' + err.code + ', message =' + err.message);
                  return;
                }
                Logger.info('Succeeded in flushing.');
              });
            }
            start();
            router.back();
          });
        Button($r('app.string.Record_data','3m'))
          .margin(20)
          .onClick(() => {
            open = true;
            setTimeout(() => {
              promptAction.showToast({
                message: $r('app.string.Calculation_started'),
                duration: 2000
              });
              open = false;
              average1 = average(scanResult);
              Logger.info('average1：' + average1);
              promptAction.showToast({
                message: 'average：' + average1,
                duration: 1000
              });
            }, 10000);
          });
        Button($r('app.string.Record_data','8m'))
          .margin(20)
          .onClick(() => {
            open1 = true;
            setTimeout(() => {
              promptAction.showToast({
                message: $r('app.string.Calculation_started'),
                duration: 2000
              });
              open1 = false;
              average2 = average(scanResult1);
              Logger.info('average2：' + average2);
              prompt.showToast({
                message: 'average：' + average2,
                duration: 1000
              });
            }, 10000);
          });
      }
      .width('100%');
    }
    .height('100%');
  }
}