/*
* Copyright (c) 2023 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import bluetoothManager from '@ohos.bluetooth';
import promptAction from '@ohos.promptAction';
import BleConstants from '../constants/BleConstants';
import Log from '../utils/Log';
import ArrayBufferUtils from '../utils/ArrayBufferUtils';

const TAG = '[Sample_AdvertiserBluetoothViewModel]';

export class AdvertiserBluetoothViewModel {
  private mGattServer: bluetoothManager.GattServer;

  isBluetoothEnabled(): boolean {
    Log.showInfo(TAG, `isBluetoothEnabled`);
    let state: bluetoothManager.BluetoothState = bluetoothManager.getState();
    Log.showInfo(TAG, `isBluetoothEnabled: state = ${state}`);
    if (state === bluetoothManager.BluetoothState.STATE_ON || state === bluetoothManager.BluetoothState.STATE_TURNING_ON) {
      return true;
    }
    return false;
  }

  enableBluetooth() {
    Log.showInfo(TAG, `enableBluetooth`);
    try {
      this.onBTStateChange();
      bluetoothManager.enableBluetooth();
    } catch (err) {
      Log.showError(TAG, `enableBluetooth: err = ${err}`);
    }
  }

  disableBluetooth() {
    Log.showInfo(TAG, `disableBluetooth`);
    try {
      this.offBTStateChange();
      bluetoothManager.disableBluetooth();
    } catch (err) {
      Log.showError(TAG, `disableBluetooth: err = ${err}`);
    }
  }

  getLocalName(): string {
    let localName = '';
    try {
      localName = bluetoothManager.getLocalName();
      Log.showInfo(TAG, `getLocalName: localName = ${localName}`);
    } catch (err) {
      Log.showError(TAG, `getLocalName: err = ${err}`);
    }
    return localName;
  }

  startAdvertiser(): boolean {
    Log.showInfo(TAG, `startAdvertiser`);

    if (!this.isBluetoothEnabled()) {
      Log.showInfo(TAG, `startBLEScan: bluetooth is disable.`);
      this.enableBluetooth();
      promptAction.showToast({
        message: $r('app.string.toast_enable_bluetooth'),
        duration: 2000
      });
      return false;
    }

    this.mGattServer = bluetoothManager.BLE.createGattServer();

    let descriptors: Array<bluetoothManager.BLEDescriptor> = [];
    let arrayBuffer = ArrayBufferUtils.byteArray2ArrayBuffer([11]);
    let descriptor: bluetoothManager.BLEDescriptor = {
      serviceUuid: BleConstants.UUID_SERVICE_HEART_RATE,
      characteristicUuid: BleConstants.UUID_CHARACTERISTIC_HEART_RATE_MEASUREMENT,
      descriptorUuid: BleConstants.UUID_DESCRIPTOR_HEART_RATE,
      descriptorValue: arrayBuffer
    };
    descriptors[0] = descriptor;

    let characteristics: Array<bluetoothManager.BLECharacteristic> = [];
    let arrayBufferC = ArrayBufferUtils.byteArray2ArrayBuffer([1]);
    let characteristic: bluetoothManager.BLECharacteristic = {
      serviceUuid: BleConstants.UUID_SERVICE_HEART_RATE,
      characteristicUuid: BleConstants.UUID_CHARACTERISTIC_HEART_RATE_MEASUREMENT,
      characteristicValue: arrayBufferC,
      descriptors: descriptors
    };
    characteristics[0] = characteristic;

    let service: bluetoothManager.GattService = {
      serviceUuid: BleConstants.UUID_SERVICE_HEART_RATE,
      isPrimary: true,
      characteristics: characteristics,
      includeServices: []
    };

    try {
      this.mGattServer.addService(service);
      Log.showInfo(TAG, `startAdvertiser: addService suc`);
    } catch (err) {
      Log.showError(TAG, `startAdvertiser: addService err = ${err}`);
    }

    try {
      this.onConnectStateChange();
      this.mGattServer.startAdvertising({
        interval: 160,
        txPower: 1,
        connectable: true,
      }, {
        serviceUuids: [BleConstants.UUID_SERVICE_HEART_RATE],
        manufactureData: [],
        serviceData: [],
      }, {
        serviceUuids: [BleConstants.UUID_SERVICE_HEART_RATE],
        manufactureData: [],
        serviceData: [],
      });
      Log.showInfo(TAG, `startAdvertiser: startAdvertising suc`);
      return true;
    } catch (err) {
      Log.showError(TAG, `startAdvertiser: startAdvertising err = ${err}`);
    }
    return false;
  }

  stopAdvertiser() {
    Log.showInfo(TAG, `stopAdvertiser`);
    if (this.mGattServer) {
      try {
        this.offConnectStateChange();
        this.mGattServer.stopAdvertising();
      } catch (err) {
        Log.showError(TAG, `stopAdvertiser: startAdvertising err = ${err}`);
      }
    } else {
      Log.showWarn(TAG, `stopAdvertiser: mGattServer is null`);
    }
  }

  notifyCharacteristicChanged(deviceId: string, heartRate: number) {
    Log.showInfo(TAG, `notifyCharacteristicChanged: deviceId = ${deviceId}, heartRate = ${heartRate}`);

    if (!deviceId) {
      Log.showWarn(TAG, `deviceId is null`);
      return;
    }

    if (this.mGattServer) {
      try {
        let descriptors = [];
        let arrayBuffer = ArrayBufferUtils.byteArray2ArrayBuffer([11]);
        let descriptor = {
          serviceUuid: BleConstants.UUID_SERVICE_HEART_RATE,
          characteristicUuid: BleConstants.UUID_CHARACTERISTIC_HEART_RATE_MEASUREMENT,
          descriptorUuid: BleConstants.UUID_DESCRIPTOR_HEART_RATE,
          descriptorValue: arrayBuffer
        };
        descriptors[0] = descriptor;
        let arrayBufferC = ArrayBufferUtils.byteArray2ArrayBuffer([0x00, heartRate]);
        let characteristic = {
          serviceUuid: BleConstants.UUID_SERVICE_HEART_RATE,
          characteristicUuid: BleConstants.UUID_CHARACTERISTIC_HEART_RATE_MEASUREMENT,
          characteristicValue: arrayBufferC,
          descriptors: descriptors
        };
        let notifyCharacteristic = {
          serviceUuid: BleConstants.UUID_SERVICE_HEART_RATE,
          characteristicUuid: BleConstants.UUID_CHARACTERISTIC_HEART_RATE_MEASUREMENT,
          characteristicValue: characteristic.characteristicValue,
          confirm: false
        };
        this.mGattServer.notifyCharacteristicChanged(deviceId, notifyCharacteristic);
      } catch (err) {
        Log.showError(TAG, `notifyCharacteristicChanged: notifyCharacteristicChanged err = ${err}`);
      }
    } else {
      Log.showWarn(TAG, `notifyCharacteristicChanged: mGattServer is null`);
    }
  }

  private onBTStateChange() {
    Log.showInfo(TAG, `onBTStateChange`);
    try {
      bluetoothManager.on('stateChange', (data: bluetoothManager.BluetoothState) => {
        Log.showInfo(TAG, `onBTStateChange: data = ${data}`);
        if (data === bluetoothManager.BluetoothState.STATE_ON) {
          AppStorage.SetOrCreate('bluetoothEnable', true);
          this.startAdvertiser();
        }
        if (data === bluetoothManager.BluetoothState.STATE_OFF) {
          AppStorage.SetOrCreate('bluetoothEnable', false);
        }
      });
    } catch (err) {
      Log.showError(TAG, `onBTStateChange: err = ${err}`);
    }
  }

  private offBTStateChange() {
    Log.showInfo(TAG, `offBTStateChange`);
    try {
      bluetoothManager.off('stateChange');
    } catch (err) {
      Log.showError(TAG, `offBTStateChange: err = ${err}`);
    }
  }

  private onConnectStateChange() {
    Log.showInfo(TAG, `onConnectStateChange`);
    if (!this.mGattServer) {
      Log.showInfo(TAG, `onConnectStateChange: mGattServer is null`);
      return;
    }

    try {
      this.mGattServer.on('connectStateChange', async (data: bluetoothManager.BLEConnectChangedState) => {
        Log.showInfo(TAG, `onConnectStateChange: data = ${JSON.stringify(data)}`);
        if (data) {
          if (data.state === bluetoothManager.ProfileConnectionState.STATE_CONNECTED) {
            Log.showInfo(TAG, `onConnectStateChange: Connected GATT Device.`);
            let deviceId = data.deviceId;
            AppStorage.SetOrCreate('deviceId', deviceId);
            Log.showInfo(TAG, `onConnectStateChange: Connected GATT Device. deviceId = ${deviceId}`);
          } else if (data.state === bluetoothManager.ProfileConnectionState.STATE_DISCONNECTED) {
            Log.showInfo(TAG, `onConnectStateChange: Disonnected GATT Device.`);
            AppStorage.SetOrCreate('deviceId', '');
          }
        }
      });
    } catch (err) {
      Log.showError(TAG, `onConnectStateChange: err = ${err}`);
    }
  }

  private offConnectStateChange() {
    Log.showInfo(TAG, `offConnectStateChange`);
    if (!this.mGattServer) {
      Log.showInfo(TAG, `offConnectStateChange: mGattServer is null`);
      return;
    }

    try {
      this.mGattServer.off('connectStateChange');
    } catch (err) {
      Log.showError(TAG, `offConnectStateChange: err = ${err}`);
    }
  }
}

let advertiserBluetoothViewModel = new AdvertiserBluetoothViewModel();

export default advertiserBluetoothViewModel as AdvertiserBluetoothViewModel;