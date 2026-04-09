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

import BaseModel from '../../../../../../../common/utils/src/main/ets/default/model/BaseModel';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import Log from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogDecorator';
import connection from '@ohos.bluetooth.connection';
import access from '@ohos.bluetooth.access';
import a2dp from '@ohos.bluetooth.a2dp';
import constant from '@ohos.bluetooth.constant';
import type { BusinessError } from '@ohos.base';
import hid from '@ohos.bluetooth.hid';
import { Profile } from './BluetoothDevice';

export enum ProfileCode {
  CODE_BT_PROFILE_A2DP_SINK = 0,
  CODE_BT_PROFILE_A2DP_SOURCE,
  CODE_BT_PROFILE_AVRCP_CT,
  CODE_BT_PROFILE_AVRCP_TG,
  CODE_BT_PROFILE_HANDS_FREE_AUDIO_GATEWAY,
  CODE_BT_PROFILE_HANDS_FREE_UNIT,
  CODE_BT_PROFILE_HID_HOST,
  CODE_BT_PROFILE_PAN_NETWORK,
  CODE_BT_PROFILE_PBAP_CLIENT,
  CODE_BT_PROFILE_PBAP_SERVER,
}
;

export enum ProfileConnectionState {
  /** the current profile is disconnected */
  STATE_DISCONNECTED = 0,
  /** the current profile is being connected */
  STATE_CONNECTING = 1,
  /** the current profile is connected */
  STATE_CONNECTED = 2,
  /** the current profile is being disconnected */
  STATE_DISCONNECTING = 3
}

export enum BondState {
  /** Indicate the bond state is invalid */
  BOND_STATE_INVALID = 0,
  /** Indicate the bond state is bonding */
  BOND_STATE_BONDING = 1,
  /** Indicate the bond state is bonded*/
  BOND_STATE_BONDED = 2
}

export enum DeviceType {
  BLUETOOTH = '1',
  HEADPHONE = '2',
  PHONE = '3',
  COMPUTER = '4',
  WATCH = '5'
}

export enum BluetoothErrorCode {
  SUCCESS = -1,
  HOLD_PAIRING_MODE = 1,
  APP_PAIR = 2,
  PAIR_FAILED = 3,
  DEVICE_ILLEGAL = 4,
  CONNECT_FAILED = 5
}

enum BluetoothState {
  /** Indicates the local Bluetooth is off */
  STATE_OFF = 0,
  /** Indicates the local Bluetooth is turning on */
  STATE_TURNING_ON = 1,
  /** Indicates the local Bluetooth is on, and ready for use */
  STATE_ON = 2,
  /** Indicates the local Bluetooth is turning off */
  STATE_TURNING_OFF = 3,
  /** Indicates the local Bluetooth is turning LE mode on */
  STATE_BLE_TURNING_ON = 4,
  /** Indicates the local Bluetooth is in LE only mode */
  STATE_BLE_ON = 5,
  /** Indicates the local Bluetooth is turning off LE only mode */
  STATE_BLE_TURNING_OFF = 6
}

export class PinRequiredData {
  deviceId: string = '';
  pinCode: string = '';
}

export class BondStateChangedData {
  deviceId: string = '';
  bondState: number = BondState.BOND_STATE_INVALID;
}

export class DeviceProfileState extends Profile {
  constructor() {
    super();
    this.profileConnectionState = ProfileConnectionState.STATE_DISCONNECTED;
  }
}

export class DeviceConnectResult {
  profileId: number = -1;
  connectRet: boolean = false;
}

export class DeviceDisconnectResult {
  profileId: number = -1;
  disconnectRet: boolean = false;
}

/**
 * bluetooth service class
 */
export class BluetoothModel extends BaseModel {
  public canUse: boolean = false;
  private TAG = ConfigData.TAG + 'BluetoothModel ';
  private profiles: Array<a2dp.A2dpSourceProfile | hid.HidHostProfile | undefined> = new Array(10);

  /**
   * constructor
   */
  constructor() {
    super();
    try {
      LogUtil.info('bluetooth.getProfile start')
      let ProfileId = constant.ProfileId;
      let a2dpSrc = a2dp.createA2dpSrcProfile();
      this.profiles[ProfileId.PROFILE_A2DP_SOURCE]
        = a2dpSrc;

      let hidHostProfile = hid.createHidHostProfile();
      this.profiles[ProfileId.PROFILE_HID_HOST]
        = hidHostProfile;


      LogUtil.info('bluetooth.getProfile end')
      this.canUse = true;
    } catch (error) {
      LogUtil.info('bluetooth.getProfile error')
      this.canUse = false;
      LogUtil.info(`BluetoothModel error: ${JSON.stringify(error)}.`);
    }
  }


  /**
   * Get Bluetooth status
   * @return value of bluetooth.BluetoothState type
   */
  getState(): number {
    let bluetoothState = access.getState();
    LogUtil.info(`${this.TAG} getState: bluetoothState = ${bluetoothState}`);
    return bluetoothState;
  }

  /**
   * Get Bluetooth switch status
   */
  isStateOn(): boolean {
    let result = false;
    let state = access.getState();
    LogUtil.info(`${this.TAG} isStateOn: state = ${state}`);
    switch (state) {
      case BluetoothState.STATE_ON:
        result = true
        break;
      default:
        break;
    }
    LogUtil.info(`${this.TAG} isStateOn: bluetoothState = ${result}`);
    return result;
  }

  /**
   * Subscribe Bluetooth switch status Change
   */
  subscribeStateChange(callback: (data: boolean) => void): void {
    LogUtil.info('bluetooth.subscribeStateChange start');
    access.on('stateChange', (data) => {
      LogUtil.info(`${this.TAG} subscribeStateChange->stateChange data:${data}`);
      if (callback) {
        switch (data) {
          case BluetoothState.STATE_ON:
            connection.setBluetoothScanMode(4, 0);
            LogUtil.info(`${this.TAG} subscribeStateChange->stateChange return: true`);
            callback(true)
            break;

          case BluetoothState.STATE_OFF:
            LogUtil.info(`${this.TAG} subscribeStateChange->stateChange return: false`);
            callback(false)
            break;

          case BluetoothState.STATE_BLE_TURNING_ON:
            callback(true)
            break;

          case BluetoothState.STATE_TURNING_ON:
            callback(true)
            break;

          case BluetoothState.STATE_TURNING_OFF:
            callback(false)
            break;

          case BluetoothState.STATE_BLE_TURNING_OFF:
            callback(false)
            break;

          default:
            break;
        }
      }
    })
  }

  /**
   * unsubscribe Bluetooth switch status Change
   */
  unsubscribeStateChange(callback?: (data: boolean) => void): void {
    LogUtil.info('bluetooth.unsubscribeStateChange start');
    access.off('stateChange', (data) => {
      LogUtil.info(`${this.TAG} unsubscribeStateChange->stateChange data:${data}`);
      if (callback) {
        let result = false;
        switch (data) {
          case BluetoothState.STATE_ON:
            LogUtil.info(`${this.TAG} unsubscribeStateChange->stateChange return : true`);
            callback(true)
            break;
          case BluetoothState.STATE_OFF:
            LogUtil.info(`${this.TAG} unsubscribeStateChange->stateChange return : false`);
            callback(false)
            break;
          default:
            break;
        }
      }
    })
  }

  /**
   * Turn on Bluetooth
   */
  @Log
  enableBluetooth(): boolean {
    try {
      access.enableBluetooth();
      return true;
    } catch (err) {
      LogUtil.info(`${this.TAG} enableBluetooth : false err = ` + JSON.stringify(err));
      return false;
    }

  }

  /**
   * Turn off Bluetooth
   */
  @Log
  disableBluetooth(): boolean {
    try {
      access.disableBluetooth()
      return true;
    }catch (err) {
      LogUtil.info(`${this.TAG} disableBluetooth : false err = ` + JSON.stringify(err));
      return false;
    }
  }

  /**
   * Get local name
   */
  getLocalName(): string {
    return connection.getLocalName();
  }

  /**
   * Set local name
   */
  setLocalName(name: string): void {
    connection.setLocalName(name);
  }

  /**
   * Get paired device ids
   */
  getPairedDeviceIds(): Array<string> {
    try {
      const pairedDevices = connection.getPairedDevices();
      return pairedDevices;
    } catch (err) {
      LogUtil.info(this.TAG + 'getPairedDevicesErrCode: ' + (err as BusinessError).code + ', errMessage: ' +
      (err as BusinessError).message);
      return [];
    }
  }

  /**
   * Start Bluetooth discovery
   */
  @Log
  startBluetoothDiscovery(): void {
    try {
      connection.startBluetoothDiscovery();
    } catch (err) {
      LogUtil.info(this.TAG + 'errCodestartBluetoothDiscovery: ' + (err as BusinessError).code + ', errMessage: ' +
      (err as BusinessError).message);
    }
  }

  /**
   * Stop Bluetooth discovery
   */
  @Log
  stopBluetoothDiscovery(): void {
    try {
      connection.stopBluetoothDiscovery();
    } catch (err) {
      LogUtil.info(this.TAG + 'errCodestopBluetoothDiscovery: ' + (err as BusinessError).code + ', errMessage: ' +
      (err as BusinessError).message);
    }
  }

  /**
   * Subscribe Bluetooth status Change
   */
  subscribeBluetoothDeviceFind(callback: (data: Array<connection.DiscoveryResult>) => void): void {
    LogUtil.info('bluetooth.subscribeBluetoothDeviceFind start');
    let onReceiveEvent: (data: Array<connection.DiscoveryResult>) => void =
      (data: Array<connection.DiscoveryResult>) => {
        // data为蓝牙设备扫描结果集合
        LogUtil.debug('bluetoothdiscoveryResult device find = ' + JSON.stringify(data));
        if (callback) {
          callback(data)
        }
      }
    try {
      connection.on('discoveryResult', onReceiveEvent);
    } catch (err) {
      console.error('errCode3: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  /**
   * unsubscribe Bluetooth status Change
   */
  unsubscribeBluetoothDeviceFind(): void {
    LogUtil.info('bluetooth.unsubscribeBluetoothDeviceFind start');
    try {
      connection.off('discoveryResult')
    } catch (err) {
      LogUtil.error(`${this.TAG} unsubscribeBluetoothDeviceFind err: ${JSON.stringify(err)}`)
    }
  }

  /**
   * Pair device
   */
  pairDevice(deviceId: string): void {
    connection.pairDevice(deviceId);
  }

  /**
   * Subscribe PinRequired 订阅远端蓝牙设备的配对请求事件
   */
  subscribePinRequired(callback: (data: PinRequiredData) => void): void {
    LogUtil.info('bluetooth.subscribePinRequired start');
    connection.on('pinRequired', (data: PinRequiredData) => {
      LogUtil.info(`${this.TAG} subscribePinRequired->pinRequired return: ${data.pinCode}`);
      if (callback) {
        let result = new PinRequiredData();
        result.deviceId = data.deviceId;
        result.pinCode = data.pinCode;
        callback(result)
      }
    })
  }

  /**
   * Unsubscribe PinRequired
   */
  unsubscribePinRequired(callback?: (data: PinRequiredData) => void): void {
    LogUtil.info('bluetooth.unsubscribePinRequired start');
    connection.off('pinRequired', (data: PinRequiredData) => {
      if (data == undefined || !data) {
        LogUtil.error(`${this.TAG} unsubscribePinRequired->pinRequired error`);
        return;
      }
      LogUtil.info(`${this.TAG} unsubscribePinRequired->pinRequired return: ${data.pinCode}`);
      if (callback) {
        let result = new PinRequiredData();
        result.deviceId = data.deviceId;
        result.pinCode = data.pinCode;
        callback(result)
      }
    })
  }

  /**
   * Set device PairingConfirmation设置设备配对请求确认
   */
  setDevicePairingConfirmation(deviceId: string, accept: boolean): void {
    LogUtil.info('bluetooth.setDevicePairingConfirmation start, accept:' + accept);
    try {
      // 尝试执行配对确认操作
      connection.setDevicePairingConfirmation(deviceId, accept);
      LogUtil.info(`bluetooth.setDevicePairingConfirmation success for device: ${deviceId}`);
    } catch (err) {
      LogUtil.info(this.TAG + 'setDevicePairingConfirmationErrCode: ' + (err as BusinessError).code + ', errMessage: ' +
      (err as BusinessError).message);
    }
  }

  /**
   * Subscribe bondStateChange  订阅蓝牙配对状态改变事件
   */
  subscribeBondStateChange(callback: (data: BondStateChangedData) => void): void {
    LogUtil.info('bluetooth.subscribeBondStateChange start');
    connection.on('bondStateChange', (data: connection.BondStateParam) => {
      LogUtil.info(`${this.TAG} subscribeBondStateChange->bondStateChange data.state:${JSON.stringify(data.state)}`);
      if (callback) {
        let result = new BondStateChangedData();
        result.deviceId = data.deviceId;
        result.bondState = data.state;
        LogUtil.info(`${this.TAG} subscribeBondStateChange->bondStateChange return:${JSON.stringify(result.bondState)}`);
        callback(result);
      }
    })
  }

  /**
   * Unsubscribe bondStateChange
   */
  unsubscribeBondStateChange(callback?: (data: BondStateChangedData) => void): void {
    connection.off('bondStateChange', (data: connection.BondStateParam) => {
      LogUtil.info(`${this.TAG} unsubscribeBondStateChange->bondStateChange start`);
      if (callback) {
        let result = new BondStateChangedData();
        result.deviceId = data.deviceId;
        result.bondState = data.state;
        LogUtil.info(`${this.TAG} unsubscribeBondStateChange->bondStateChange return:${JSON.stringify(result.bondState)}`);
        callback(result);
      }
    })
  }

  /**
   * Get device name
   */
  getDeviceName(deviceId: string): string {
    try {
      return connection.getRemoteDeviceName(deviceId);
    } catch (err) {
      LogUtil.debug(this.TAG + 'getRemoteDeviceNameErrCode: ' + (err as BusinessError).code + ', errMessage: ' +
      (err as BusinessError).message);
      return ""
    }
  }

  /**
   * Get device type
   */
  getDeviceType(deviceId: string): string {
    let deviceType = DeviceType.BLUETOOTH;
    let deviceClass = connection.getRemoteDeviceClass(deviceId);
    switch (deviceClass.majorClass) {
      case 0x0100:
        deviceType = DeviceType.COMPUTER;
        break;
      case 0x0400:
        if (deviceClass.majorMinorClass === 0x0418 || deviceClass.majorMinorClass === 0x0404) {
          deviceType = DeviceType.HEADPHONE;
        }
        break;
      case 0x0700:
        if (deviceClass.majorMinorClass === 0x0704) {
          deviceType = DeviceType.WATCH;
        }
        break;
      case 0x0200:
        deviceType = DeviceType.PHONE;
        break;
      default:
        deviceType = DeviceType.BLUETOOTH;
        break;
    }
    LogUtil.info('bluetooth.getDeviceType end, return:' + deviceType);
    return deviceType;
  }

  getDeviceTypeByResult(deviceResult: connection.DiscoveryResult): string {
    let deviceType = DeviceType.BLUETOOTH;
    let deviceClass = deviceResult.deviceClass;
    switch (deviceClass.majorClass) {
      case 0x0100:
        deviceType = DeviceType.COMPUTER;
        break;
      case 0x0400:
        if (deviceClass.majorMinorClass === 0x0418 || deviceClass.majorMinorClass === 0x0404) {
          deviceType = DeviceType.HEADPHONE;
        }
        break;
      case 0x0700:
        if (deviceClass.majorMinorClass === 0x0704) {
          deviceType = DeviceType.WATCH;
        }
        break;
      case 0x0200:
        deviceType = DeviceType.PHONE;
        break;
      default:
        deviceType = DeviceType.BLUETOOTH;
        break;
    }
    LogUtil.info('bluetooth.getDeviceType end, return:' + deviceType);
    return deviceType;
  }
  /**
   * 获取设备各profile的连接状态
   * @param deviceId 设备ID
   * @returns 包含各profile连接状态的数组
   * @throws 当输入参数无效时抛出错误
   */
  getDeviceState(deviceId: string): Profile[] {
    // 1. 参数校验
    if (!deviceId || typeof deviceId !== 'string' || deviceId.trim().length === 0) {
      console.error('Invalid deviceId parameter');
      throw new Error('Device ID cannot be empty');
    }
    // 2. 初始化结果数组
    const result: Profile[] = [];
    // 3. 安全遍历profiles数组
    if (!this.profiles || !Array.isArray(this.profiles)) {
      console.warn('Profiles array is not initialized or invalid');
      return result;
    }
    for (let profileId = 0; profileId < this.profiles.length; profileId++) {
      try {
        // 4. 检查当前profile是否存在
        const currentProfile = this.profiles[profileId];
        if (!currentProfile || typeof currentProfile.getConnectionState !== 'function') {
          console.warn(`Profile ${profileId} is invalid or missing getConnectionState method`);
          continue;
        }
        // 5. 安全获取连接状态
        const connectionState = currentProfile.getConnectionState(deviceId);
        // 6. 验证返回的状态值
        if (typeof connectionState !== 'number') {
          console.warn(`Invalid connection state returned for profile ${profileId}`);
          continue;
        }
        let profileState = new Profile();
        profileState.profileId = profileId;
        profileState.deviceId = deviceId;
        profileState.profileConnectionState = connectionState;
        result.push(profileState);
      } catch (error) {
        console.error(`Error checking profile ${profileId} state:`, error);
        let profileState = new Profile();
        profileState.profileId = profileId;
        profileState.deviceId = deviceId;
        profileState.profileConnectionState = -1;
        result.push(profileState);
      }
    }

    return result;
  }
  /**
   * Unpair device
   */
  unpairDevice(deviceId: string) {
    connection.cancelPairedDevice(deviceId);
  }

  /**
   * cancel pairing device
   */
  cancelPairingDevice(deviceId: string, callback?: () => void) {
    connection.cancelPairingDevice(deviceId, () => {
      if(callback){
        callback()
      }
    });
  }

  /**
   * Connect device
   */
  connectDevice(deviceId: string): DeviceConnectResult[] {
    LogUtil.info('bluetooth.connectDevice start');
    let result: DeviceConnectResult[] = [];
    for (let i = 0; i < this.profiles.length; i++) {
      const profile = this.profiles[i];
      if (!profile) {
        continue;
      }
      LogUtil.info('bluetooth.connectDevice end, return:' + profile);
      let connectRet = true;
      try {
        profile.connect(deviceId)
      } catch (error) {
        connectRet = false
        LogUtil.info(this.TAG + (error as BusinessError).message)
      }
      let connectResult = new DeviceConnectResult();
      connectResult.profileId = i;
      connectResult.connectRet = connectRet;
      result.push(connectResult);
    }
    LogUtil.info('bluetooth.connectDevice end, return:' + result);
    return result;
  }

  /**
   * Disconnect device
   */
  disconnectDevice(deviceId: string): DeviceDisconnectResult[] {
    LogUtil.info('bluetooth.disconnectDevice start');
    let result: DeviceDisconnectResult[] = [];
    for (let i = 0; i < this.profiles.length; i++) {
      const profile = this.profiles[i];
      if (!profile) {
        continue;
      }
      let profileConnectionState = profile.getConnectionState(deviceId);
      let disconnectRet = true;
      LogUtil.info(`${this.TAG} disconnectDevice , connectionState = ${profileConnectionState}`);
      if (profileConnectionState === 2) {
        try {
          profile.disconnect(deviceId);
        } catch (BusinessError) {
          LogUtil.info(`${this.TAG} disconnect failed. BusinessError is  ` + JSON.stringify(BusinessError));
          disconnectRet = false;
        }

      }
      let disconnectResult = new DeviceDisconnectResult();
      disconnectResult.profileId = i;
      disconnectResult.disconnectRet = disconnectRet;
      result.push(disconnectResult);
    }
    LogUtil.info('bluetooth.connectDevice end, return:' + result);
    return result;
  }

  /**
   * Subscribe device connection state Change
   */
  subscribeDeviceStateChange(callback: (data: DeviceProfileState) => void): void {
    for (let i = 0; i < this.profiles.length; i++) {
      const profile = this.profiles[i];
      if (!profile) {
        continue;
      }
      profile.on('connectionStateChange', (data) => {
        if (callback) {
          let result = new DeviceProfileState();
          result.profileId = i;
          result.deviceId = data.deviceId;
          result.profileConnectionState = data.state;
          LogUtil.info(`${this.TAG} subscribeDeviceStateChange->connectionStateChange,
              return:${result.profileId} - ${result.profileConnectionState}`);
          callback(result);
        }
      })
    }
  }

  /**
   * unsubscribe device connection state Change
   */
  unsubscribeDeviceStateChange(callback?: (data: DeviceProfileState) => void): void {
    for (let i = 0; i < this.profiles.length; i++) {
      const profile = this.profiles[i];
      if (!profile) {
        continue;
      }
      profile.off('connectionStateChange', (data) => {
        if (data == undefined || !data) {
          LogUtil.error(`${this.TAG} unsubscribeDeviceStateChange->connectionStateChange error`);
          return;
        }
        if (callback) {
          let result = new DeviceProfileState();
          result.profileId = i;
          result.deviceId = data.deviceId;
          result.profileConnectionState = data.state;
          LogUtil.info(`${this.TAG} unsubscribeDeviceStateChange->connectionStateChange,
              return:${result.profileId} - ${result.profileConnectionState}`);
          callback(result);
        }
      })
    }
  }
}

let bluetoothModel = new BluetoothModel();

export default bluetoothModel as BluetoothModel;
