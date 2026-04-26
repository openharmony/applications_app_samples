/**
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
import { access, ble, connection, constant, hid } from '@kit.ConnectivityKit';
import LogUtil from '../util/LogUtil';
import { BusinessError,systemParameterEnhance } from '@kit.BasicServicesKit';
import { withTimeout } from '../util/TimeoutPromise';
import { createError, PairErrorCode } from '../model/PairError';
import { preferences } from '@kit.ArkData';
import { serviceExtensionContext } from './PartsPairService';
import { PartsDeviceState } from '../model/DeviceState';
const TAG = '[PPL_model]'
const BLUETOOTH_SWITCH_TIMEOUT_DURATION = 2000
const BLUETOOTH_PAIR_TIMEOUT_DURATION = 10 * 1000
const BLUETOOTH_CONNECT_TIMEOUT_DURATION = 60 * 1000
const SCAN_MODE_BLE = true
let SUPPORT_DEVICE_NAMES: string[] = []

interface FileConfig {
  supportDeviceNames: string[]; // 字符串数组
}

// PartsPairModel 封装了 TV 配件（遥控器）蓝牙配对的全部底层操作。
// 配对流程拆分为"绑定（bond）"和"连接（connect）"两个独立阶段，
// 是因为 HID 设备需要先完成 BT 安全绑定后才能建立 HID Profile 连接，两步不可合并。
export class PartsPairModel {
  private hidProfile = hid.createHidHostProfile()
  private localConnectedDevices?: string[] = undefined

  constructor() {
    this.loadSupportRemoteCtrls()
  }

  observerBluetooth(callback: (switchOn: boolean) => void): void {
    let bluetoothState = access.getState()
    callback(bluetoothState === access.BluetoothState.STATE_ON)

    access.on('stateChange', (state: access.BluetoothState) => {
      LogUtil.info(TAG, `subscribeBluetoothSwitch state = ` + state);
      if (state === access.BluetoothState.STATE_ON) {
        callback(true)
      }
      if (state === access.BluetoothState.STATE_OFF) {
        callback(false)
      }
    })
  }

  getPairedDevices(): string[] {
    LogUtil.info(TAG, `getPairedDevices`);
    let pairedDevices: string[] = []
    try {
      pairedDevices = connection.getPairedDevices()
    } catch (e) {
      LogUtil.error(TAG, `getPairedDevices error ${JSON.stringify(e)}`)
      pairedDevices = []
    }
    return pairedDevices
  }

  // pairDevice 用 withTimeout 包装配对 Promise，是因为蓝牙配对依赖用户在遥控器侧确认，
  // 若用户无响应会永久挂起，超时后检查绑定状态兜底，避免配对流程卡死阻塞后续扫描。
  pairDevice(deviceId: string): Promise<boolean> {
    let promise = new Promise<boolean>((resolve, reject) => {
      if (connection.getPairedDevices().includes(deviceId) &&
      this.getLocalConnectDevices().includes(deviceId)) {
        LogUtil.info(TAG, `pairDevice paired  ${deviceId} `);
        resolve(true)
      } else {
        connection.on('bondStateChange', (boundState) => {
          LogUtil.info(TAG, `bondStateChange deviceId = ${deviceId} state change to = ${boundState.state}`);
          if (boundState.deviceId === deviceId && boundState.state === connection.BondState.BOND_STATE_BONDED) {
            if (boundState.state === connection.BondState.BOND_STATE_BONDED) {
              connection.off('bondStateChange')
              LogUtil.info(TAG,
                `----after bound deviceId = ${deviceId} paired state = ${connection.getPairState(deviceId)}`);
              resolve(true)
            } else if (boundState.state === connection.BondState.BOND_STATE_INVALID) {
              connection.off('bondStateChange')
              resolve(false)
            }
          }
        })

        connection.pairDevice(deviceId).then(() => {
          LogUtil.info(TAG, `do pairDevice deviceId = ${deviceId} `);
        }).catch((e: BusinessError) => {
          LogUtil.info(TAG, `do pairDevice deviceId = ${deviceId} error ${JSON.stringify(e)}`);
          connection.off('bondStateChange')
          reject(createError(PairErrorCode.PAIR_FAIL, JSON.stringify(e)))
        })
      }
    })

    return withTimeout<boolean>(promise, BLUETOOTH_PAIR_TIMEOUT_DURATION, 'pair device', () => {
      connection.off('bondStateChange')
      if (connection.getPairState(deviceId) === connection.BondState.BOND_STATE_BONDED) {
        LogUtil.info(TAG, `paired on timeout`);
        return true
      } else {
        return undefined
      }
    })
  }

  unPairDevice(deviceId: string) {
    connection.cancelPairedDevice(deviceId)
  }

  isDeviceConnected(deviceId: string) {
    return this.hidProfile.getConnectionState(deviceId) === constant.ProfileConnectionState.STATE_CONNECTED
  }

  connectDevice(deviceId: string): Promise<boolean> {
    LogUtil.info(TAG, `connectDevice deviceId = ${deviceId}`);
    let promise = new Promise<boolean>((resolve, reject) => {
      const isEnabled:access.BluetoothState = access.getState();
      if (isEnabled !== access.BluetoothState.STATE_ON) {
        resolve(false)
      }
      const connectState = this.hidProfile.getConnectionState(deviceId)
      if (connectState === constant.ProfileConnectionState.STATE_CONNECTED) {
        resolve(true)
      } else {
        this.hidProfile.on('connectionStateChange', (stateChange) => {
          LogUtil.info(TAG, `connectionStateChange state=${JSON.stringify(stateChange)}`)
          if (stateChange.deviceId === deviceId) {
            if (stateChange.state === constant.ProfileConnectionState.STATE_CONNECTED) {
              this.hidProfile.off('connectionStateChange')
              resolve(true)
            } else if (stateChange.state === constant.ProfileConnectionState.STATE_DISCONNECTED) {
              this.hidProfile.off('connectionStateChange')
              resolve(false)
            }
          }
        })
        try {
          this.hidProfile.connect(deviceId)
        } catch (e) {
          LogUtil.info(TAG, `do connectDevice deviceId = ${deviceId} error ${JSON.stringify(e as BusinessError)}`);
          this.hidProfile.off('connectionStateChange')
          reject(createError(PairErrorCode.CONNECT_FAIL, JSON.stringify(e as BusinessError)))
        }
      }
    })
    return withTimeout<boolean>(promise, BLUETOOTH_CONNECT_TIMEOUT_DURATION, 'connect device', () => {
      this.hidProfile.off('connectionStateChange')
      if (this.hidProfile.getConnectionState(deviceId) === constant.ProfileConnectionState.STATE_CONNECTED) {
        LogUtil.info(TAG, `connected on timeout`);
        return true
      } else {
        LogUtil.info(TAG, 'hid not connected before timeout');
        return undefined
      }
    })
  }


  startScan() {
    LogUtil.info(TAG, `startScan`);
    if (SCAN_MODE_BLE) {
      ble.startBLEScan(null)
    } else {
      try {
        connection.setBluetoothScanMode(connection.ScanMode.SCAN_MODE_CONNECTABLE_GENERAL_DISCOVERABLE, 0);
        connection.startBluetoothDiscovery()
        LogUtil.info(TAG, `startScan success`);
      } catch (e) {
        LogUtil.info(TAG, `startScan fail ${JSON.stringify(e as BusinessError)}`);
      }
    }
  }

  stopScan() {
    LogUtil.info(TAG, `stopScan`);
    if (SCAN_MODE_BLE) {
      ble.stopBLEScan()
    } else {
      connection.stopBluetoothDiscovery()
    }
  }

  subscribeBluetoothDeviceFind(callback: (deviceId: string, deviceName: string) => void) {
    LogUtil.info(TAG, `subscribeBluetoothDeviceFind`);
    if (SCAN_MODE_BLE) {
      ble.on('BLEDeviceFind', (scanResult) => {
        scanResult.forEach((device) => {
          callback(device.deviceId, device.deviceName)
        })
      })
    } else {
      connection.on('bluetoothDeviceFind', (devices: Array<string>) => {
        devices.forEach((id) => {
          callback(id, connection.getRemoteDeviceName(id))
        })
      })
    }
  }

  unSubscribeBluetoothDeviceFind() {
    LogUtil.info(TAG, `unSubscribeBluetoothDeviceFind`);
    if (SCAN_MODE_BLE) {
      ble.off('BLEDeviceFind')
    } else {
      connection.off('bluetoothDeviceFind')
    }
  }

  // 支持的遥控器型号从系统参数 const.product.btcontroller 读取而非硬编码，
  // 使不同 SKU 的 TV 产品只需修改系统参数即可适配各自支持的配件列表，无需重新编译 SystemUI。
  private loadSupportRemoteCtrls() {
    try {
      let devices = systemParameterEnhance.getSync('const.product.btcontroller');
      SUPPORT_DEVICE_NAMES = devices
        .split(',')
        .map(item => item.trim())
        .filter(item => item.length > 0);
      LogUtil.debug(TAG, `SUPPORT_DEVICE_NAMES = ${JSON.stringify(SUPPORT_DEVICE_NAMES)}`);
    } catch (e) {
      LogUtil.error(TAG, 'get system parameter failed:' + JSON.stringify(e))
    }
  }

  getDeviceState(deviceId: string, deviceName: string): PartsDeviceState {

    if (SUPPORT_DEVICE_NAMES.includes(deviceName)) {
      let type = PartsDeviceState.STATE_NEW
      if (connection.getPairedDevices().includes(deviceId)) {
        if (this.hidProfile.getConnectionState(deviceId) === constant.ProfileConnectionState.STATE_CONNECTED) {
          type = PartsDeviceState.STATE_CONNECTING
        } else if (this.getLocalConnectDevices().includes(deviceId)) {
          type = PartsDeviceState.STATE_CONNECTED
        }
      }
      return type
    } else {
      return PartsDeviceState.STATE_NOT_SUPPORT
    }

  }

  onConnectSuccess(deviceId: string) {
    const savedDevices = this.getLocalConnectDevices()
    if (!savedDevices.includes(deviceId)) {
      savedDevices.push(deviceId)
      this.saveLocalConnectDevices(savedDevices)
    }
  }

  onConnectFail(deviceId: string) {
    let savedDevices = this.getLocalConnectDevices()
    if (savedDevices.includes(deviceId)) {
      savedDevices = savedDevices.filter((id) => {
        return (id !== deviceId)
      })
      this.saveLocalConnectDevices(savedDevices)
    }
  }


  // 已连接设备列表持久化到 Preferences 而非内存，
  // 是因为服务可能因 LIVE_DURATION 超时被系统回收，重启后需从持久化存储恢复连接历史，
  // 避免用户每次开机都要重新配对已绑定的遥控器。
  saveLocalConnectDevices(newDevices: string[]) {
    this.localConnectedDevices = newDevices
    let preference = preferences.getPreferencesSync(serviceExtensionContext, { name: 'partsList' })
    preference.putSync('connectDevices', newDevices)
    preference.flush()
    LogUtil.info(TAG, 'save deviceIds = ' + JSON.stringify(newDevices))
  }

  getLocalConnectDevices(): string[] {
    if (!this.localConnectedDevices) {
      try {
        this.localConnectedDevices =
          preferences.getPreferencesSync(serviceExtensionContext, { name: 'partsList' })
            .getSync('connectDevices', []) as string[]
        LogUtil.info(TAG, 'get getPairedRcDevices from preference = ' + JSON.stringify(this.localConnectedDevices))
      } catch (e) {
        LogUtil.error(TAG, 'get getPairedRcDevices from preference fail= ' + JSON.stringify(e))
      }
    }
    return this.localConnectedDevices ?? []
  }
}
