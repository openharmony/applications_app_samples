/*
* Copyright (c) 2023-2025 Hunan OpenValley Digital Industry Development Co., Ltd.
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

import util from '@ohos.util';
import promptAction from '@ohos.promptAction';
import BluetoothDevice from '../model/BluetoothDevice';
import ArrayBufferUtils from '../utils/ArrayBufferUtils';
import BleConstants from '../constants/BleConstants';
import Log from '../utils/Log';
import ble from '@ohos.bluetooth.ble';
import access from '@ohos.bluetooth.access';
import constant from '@ohos.bluetooth.constant';


const TAG = '[Sample_BluetoothManager]';

export class ConnectionState {
  static STATE_CONNECTING = 1;
  static STATE_CONNECTED = 2;
  static STATE_DISCONNECTING = 3;
  static STATE_DISCONNECTED = 4;
}

export class BluetoothViewModel {
  private mGattClientDevice: ble.GattClientDevice | null = null;
  private mConnectBluetoothDevice: BluetoothDevice = {};
  private mAvailableDevices: BluetoothDevice[] = [];
  private mTimeoutID: number = -1;

  isBluetoothEnabled(): boolean {
    Log.showInfo(TAG, `isBluetoothEnabled`);
    let state: access.BluetoothState = access.getState();
    Log.showInfo(TAG, `isBluetoothEnabled: state = ${state}`);
    if (state === access.BluetoothState.STATE_ON || state === access.BluetoothState.STATE_TURNING_ON) {
      return true;
    }
    return false;
  }

  enableBluetooth() {
    Log.showInfo(TAG, `enableBluetooth`);
    try {
      this.onBTStateChange();
      access.enableBluetooth();
    } catch (err) {
      Log.showError(TAG, `enableBluetooth: err = ${err}`);
    }
  }

  disableBluetooth() {
    Log.showInfo(TAG, `disableBluetooth`);
    try {
      this.offBTStateChange();
      access.disableBluetooth();
    } catch (err) {
      Log.showError(TAG, `disableBluetooth: err = ${err}`);
    }
  }

  startBLEScan(): boolean {
    Log.showInfo(TAG, `startBleScan`);

    if (!this.isBluetoothEnabled()) {
      Log.showInfo(TAG, `startBLEScan: bluetooth is disable.`);
      this.enableBluetooth();
      promptAction.showToast({
        message: $r('app.string.toast_enable_bluetooth'),
        duration: 2000
      });
      return false;
    }

    this.onBLEDeviceFind();
    let ret = this.startBLEScanInner();
    return ret;
  }

  stopBLEScan() {
    Log.showInfo(TAG, `stopBLEScan`);
    clearTimeout(this.mTimeoutID);
    this.offBLEDeviceFind();
    this.stopBLEScanInner();
  }

  connect(bluetoothDevice: BluetoothDevice): boolean {
    Log.showInfo(TAG, `connect: bluetoothDevice = ${JSON.stringify(bluetoothDevice)}`);

    if (this.mGattClientDevice && this.mConnectBluetoothDevice && this.mConnectBluetoothDevice.deviceId === bluetoothDevice.deviceId) {
      Log.showWarn(TAG, `Trying to use an existing ${JSON.stringify(bluetoothDevice.deviceId)} for connection.`);
      let ret: boolean = this.connectInner(this.mGattClientDevice);
      return ret;
    }

    this.close();

    this.mConnectBluetoothDevice = bluetoothDevice;
    AppStorage.SetOrCreate('connectBluetoothDevice', this.mConnectBluetoothDevice);

    this.mGattClientDevice = ble.createGattClientDevice(bluetoothDevice.deviceId);
    let ret: boolean = this.connectInner(this.mGattClientDevice);
    if (ret) {
      Log.showInfo(TAG, `Trying to create a new connection.`);
    } else {
      Log.showError(TAG, `Trying to create a new connection fail.`);
      this.close();
    }
    return ret;
  }

  disconnect() {
    Log.showInfo(TAG, `disconnect`);
    this.disconnectInner(this.mGattClientDevice!);
  }

  close() {
    Log.showInfo(TAG, `close`);
    this.closeInner(this.mGattClientDevice!);
  }

  getConnectionState(): number {
    Log.showInfo(TAG, `getConnectionState: mConnectBluetoothDevice.connectionState = ${JSON.stringify(this.mConnectBluetoothDevice.connectionState)}`);
    return this.mConnectBluetoothDevice.connectionState!;
  }

  private onBTStateChange() {
    Log.showInfo(TAG, `onBTStateChange`);
    try {
      access.on('stateChange', (data: access.BluetoothState) => {
        Log.showInfo(TAG, `onBTStateChange: data = ${data}`);
        if (data === access.BluetoothState.STATE_ON) {
          this.startBLEScan();
        } else if (data === access.BluetoothState.STATE_OFF) {
          this.mAvailableDevices = [];
          AppStorage.SetOrCreate('availableDevices', this.mAvailableDevices);
        }
      });
    } catch (err) {
      Log.showError(TAG, `onBTStateChange: err = ${err}`);
    }
  }

  private offBTStateChange() {
    Log.showInfo(TAG, `offBTStateChange`);
    try {
      access.off('stateChange');
    } catch (err) {
      Log.showError(TAG, `offBTStateChange: err = ${err}`);
    }
  }

  private onBLEDeviceFind() {
    try {
      ble.on('BLEDeviceFind', (arr: ble.ScanResult[]) => {
        Log.showInfo(TAG, `onBLEDeviceFind: BLEDeviceFind arr.length = ${arr.length}, arr = ${JSON.stringify(arr)}`);

        let deviceId: string = arr[0].deviceId;
        let device = this.mAvailableDevices.find(availableDevice => {
          return availableDevice.deviceId === deviceId;
        })
        if (!device) {
          let data: ArrayBuffer = arr[0].data;
          let deviceName: string = util.TextDecoder.create('utf-8', {
            ignoreBOM: true
          }).decodeWithStream(new Uint8Array(data), { stream: false });
          Log.showInfo(TAG, `onBLEDeviceFind: deviceId = ${deviceId}, deviceName = ${deviceName}`);

          // deviceName里存在一些未知数据导致显示乱码，暂时使用deviceId替代
          deviceName = deviceId;
          this.mAvailableDevices.push(this.getDevice(deviceId, deviceName));
          AppStorage.SetOrCreate('availableDevices', this.mAvailableDevices);
        }
      })
    } catch (err) {
      Log.showError(TAG, `onBLEDeviceFind: err = ${err}`);
    }
  }

  private offBLEDeviceFind() {
    try {
      ble.off('BLEDeviceFind');
    } catch (err) {
      Log.showError(TAG, `offBLEDeviceFind: err = ${err}`);
    }
  }

  private onBLEConnectionStateChange() {
    Log.showInfo(TAG, `onBLEConnectionStateChange`);
    if (!this.mGattClientDevice) {
      Log.showInfo(TAG, `onBLEConnectionStateChange: mGattClientDevice is null`);
      return;
    }

    try {
      this.mGattClientDevice.on('BLEConnectionStateChange', async (data: ble.BLEConnectionChangeState) => {
        Log.showInfo(TAG, `onBLEConnectionStateChange: data = ${JSON.stringify(data)}`);
        let deviceId: string = data.deviceId;
        let state: constant.ProfileConnectionState = data.state;
        if (data) {
          if (state === constant.ProfileConnectionState.STATE_CONNECTED) {
            Log.showInfo(TAG, `onBLEConnectionStateChange: Connected GATT server.`);
            this.mConnectBluetoothDevice.connectionState = ConnectionState.STATE_CONNECTED;
            AppStorage.SetOrCreate('connectBluetoothDevice', this.mConnectBluetoothDevice);

            try {
              // Starts discovering services.
              let services: ble.GattService[] = await this.mGattClientDevice!.getServices();
              Log.showInfo(TAG, `onBLEConnectionStateChange: services = ${JSON.stringify(services)}`);

              // Characteristic enable/disable indicate/notify
              let service: ble.GattService = services.find(item => item.serviceUuid === BleConstants.UUID_SERVICE_HEART_RATE)!;
              let characteristics: ble.BLECharacteristic[] = service.characteristics;
              let characteristic: ble.BLECharacteristic = characteristics.find(item => item.characteristicUuid === BleConstants.UUID_CHARACTERISTIC_HEART_RATE_MEASUREMENT)!;
              Log.showInfo(TAG, `onBLEConnectionStateChange: characteristic = ${JSON.stringify(characteristic)}`);
              this.mGattClientDevice!.setCharacteristicChangeNotification(characteristic, true);
              let descriptors: ble.BLEDescriptor[] = characteristic.descriptors;
              let descriptor: ble.BLEDescriptor = descriptors.find(item => item.descriptorUuid === BleConstants.UUID_DESCRIPTOR_HEART_RATE)!;
              Log.showInfo(TAG, `onBLEConnectionStateChange: descriptor = ${JSON.stringify(descriptor)}`);
              descriptor.descriptorValue = ArrayBufferUtils.byteArray2ArrayBuffer([0x01, 0x00]);
              this.mGattClientDevice!.writeDescriptorValue(descriptor);
            } catch (err) {
              Log.showError(TAG, `onBLEConnectionStateChange: err = ${err}`);
            }

          } else if (state === constant.ProfileConnectionState.STATE_DISCONNECTED) {
            Log.showInfo(TAG, `onBLEConnectionStateChange: Disonnected GATT server.`);
            if (this.getConnectionState() === ConnectionState.STATE_CONNECTING) {
              Log.showWarn(TAG, `onBLEConnectionStateChange: Connect GATT server fail.`);
              this.close();
            } else if (this.getConnectionState() === ConnectionState.STATE_CONNECTED || this.getConnectionState() === ConnectionState.STATE_DISCONNECTING) {
              Log.showWarn(TAG, `onBLEConnectionStateChange: Disconnected from GATT server.`);
              this.close();
            }
          }
        }
      })
    } catch (err) {
      Log.showError(TAG, `onBLEConnectionStateChange: err = ${err}`);
    }
  }

  private offBLEConnectionStateChange() {
    Log.showInfo(TAG, `offBLEConnectionStateChange`);
    if (!this.mGattClientDevice) {
      Log.showInfo(TAG, `offBLEConnectionStateChange: mGattClientDevice is null`);
      return;
    }

    try {
      this.mGattClientDevice.off('BLEConnectionStateChange');
    } catch (err) {
      Log.showError(TAG, `offBLEConnectionStateChange: err = ${err}`);
    }
  }

  private onBLECharacteristicChange() {
    Log.showInfo(TAG, `onBLECharacteristicChange`);
    if (!this.mGattClientDevice) {
      Log.showInfo(TAG, `onBLECharacteristicChange: mGattClientDevice is null`);
      return;
    }

    this.mGattClientDevice.on('BLECharacteristicChange', (data: ble.BLECharacteristic) => {
      Log.showInfo(TAG, `onBLECharacteristicChange: data = ${JSON.stringify(data)}`);
      let characteristicValue: ArrayBuffer = data.characteristicValue;
      Log.showInfo(TAG, `onBLECharacteristicChange: characteristicValue.length = ${characteristicValue.byteLength}, characteristicValue = ${JSON.stringify(new Uint8Array(characteristicValue))}`);
      let byteArr = ArrayBufferUtils.arrayBuffer2ByteArray(characteristicValue);
      Log.showInfo(TAG, `byteArr = ${byteArr}`);
      let heartRate = byteArr[1];
      AppStorage.SetOrCreate('heartRate', heartRate);
    })
  }

  private offBLECharacteristicChange() {
    Log.showInfo(TAG, `offBLECharacteristicChange`);
    if (!this.mGattClientDevice) {
      Log.showInfo(TAG, `offBLECharacteristicChange: mGattClientDevice is null`);
      return;
    }

    this.mGattClientDevice.off('BLECharacteristicChange');
  }

  private startBLEScanInner(): boolean {
    try {
      this.mAvailableDevices = [];
      if (this.mConnectBluetoothDevice.connectionState === ConnectionState.STATE_CONNECTED) {
        this.mAvailableDevices.push(this.mConnectBluetoothDevice);
      }
      AppStorage.SetOrCreate('availableDevices', this.mAvailableDevices);
      ble.startBLEScan([{ serviceUuid: BleConstants.UUID_SERVICE_HEART_RATE }]);
      Log.showInfo(TAG, `startBLEScanInner: scan ble start`);
      this.mTimeoutID = setTimeout(() => {
        Log.showInfo(TAG, `startBLEScanInner: scan ble finished`);
        this.stopBLEScan();
      }, 30000);
      return true;
    } catch (err) {
      Log.showError(TAG, `startBLEScanInner: err = ${err}`);
    }
    return false;
  }

  private stopBLEScanInner() {
    Log.showInfo(TAG, `stopBLEScanInner`);
    try {
      ble.stopBLEScan();
      Log.showInfo(TAG, `stopBLEScanInner: scan ble stop`);
    } catch (err) {
      Log.showError(TAG, `stopBLEScanInner: err = ${err}`);
    }
  }

  private connectInner(gattClientDevice: ble.GattClientDevice): boolean {
    Log.showInfo(TAG, `connectInner`);
    try {
      if (!gattClientDevice) {
        Log.showWarn(TAG, `connectInner: mGattClientDevice is null`);
        return false;
      }

      this.onBLEConnectionStateChange();
      this.onBLECharacteristicChange();
      gattClientDevice.connect();
      this.mConnectBluetoothDevice.connectionState = ConnectionState.STATE_CONNECTING;
      AppStorage.SetOrCreate('connectBluetoothDevice', this.mConnectBluetoothDevice);
      return true;
    } catch (err) {
      Log.showError(TAG, `connectInner: err = ${err}`);
    }
    return false;
  }

  private disconnectInner(gattClientDevice: ble.GattClientDevice) {
    Log.showInfo(TAG, `disconnectInner`);
    try {
      if (!gattClientDevice) {
        Log.showWarn(TAG, `disconnectInner: mGattClientDevice is null`);
        return;
      }

      this.offBLEConnectionStateChange();
      this.offBLECharacteristicChange();
      if (this.getConnectionState() === ConnectionState.STATE_CONNECTING) {
        Log.showWarn(TAG, `disconnectInner: mConnectionState is ConnectionState.STATE_CONNECTING`);
        this.close();
      } else if (this.getConnectionState() === ConnectionState.STATE_CONNECTED) {
        Log.showWarn(TAG, `disconnectInner: mConnectionState is ConnectionState.STATE_CONNECTED`);
        gattClientDevice.disconnect();
        this.mConnectBluetoothDevice.connectionState = ConnectionState.STATE_DISCONNECTING;
        AppStorage.SetOrCreate('connectBluetoothDevice', this.mConnectBluetoothDevice);
        this.close(); // @ohos.bluetooth不会调用BLEConnectionStateChange通知disconnected成功，但是@ohos.bluetoothManager没问题
      }
    } catch (err) {
      Log.showError(TAG, `disconnectInner: err = ${err}`);
    }
  }

  private closeInner(gattClientDevice: ble.GattClientDevice) {
    Log.showInfo(TAG, `closeInner`);
    try {
      if (!gattClientDevice) {
        Log.showWarn(TAG, `closeInner: mGattClientDevice is null`);
        return;
      }

      gattClientDevice.close();
      Log.showWarn(TAG, `closeInner: gatt close`);
      this.mConnectBluetoothDevice.connectionState = ConnectionState.STATE_DISCONNECTED;
      AppStorage.SetOrCreate('connectBluetoothDevice', this.mConnectBluetoothDevice);
      this.release();
    } catch (err) {
      Log.showError(TAG, `closeInner: err = ${err}`);
    }
  }

  private release() {
    Log.showWarn(TAG, `release`);
    this.mGattClientDevice = null;
    this.mTimeoutID = -1;
  }

  private getDevice(deviceId: string, deviceName: string): BluetoothDevice {
    Log.showInfo(TAG, `getDevice: deviceId = ${deviceId}, deviceName = ${deviceName}`);
    let device = new BluetoothDevice();
    device.deviceId = deviceId;
    device.deviceName = deviceName;
    Log.showInfo(TAG, `getDevice: device = ${JSON.stringify(device)}`);
    return device;
  }
}

let bluetoothViewModel = new BluetoothViewModel();

export default bluetoothViewModel as BluetoothViewModel;