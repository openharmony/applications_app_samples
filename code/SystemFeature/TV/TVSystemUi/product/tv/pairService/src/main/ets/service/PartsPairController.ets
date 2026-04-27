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
import LogUtil from '../util/LogUtil';
import { JSON } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { PartsPairModel } from './PartsPairModel';
import { PairingState } from '../model/PairingState';
import { PartsDeviceState } from '../model/DeviceState';
import { ThreeModeRemoteModel } from './ThreeModeRemoteModel';

const TAG = '[PPL_control]'
const RESET_DELAY_TIME = 3000

const enum StateChangeTag {
  INIT = 'init',
  NEW_DEVICE_FOUND = 'new device found',
  CONNECT_DEVICE_FOUND = 'connected device found',
  PAIR_SUCCESS = 'pair success',
  PAIR_FAIL = 'pair fail',
  CONNECT_SUCCESS = 'connect success',
  CONNECT_FAIL = 'connect fail',
  OPERATE_ERROR = 'operate error',
  RESET = 'reset'
}

// PartsPairController 是配件配对的状态机核心，统一协调扫描、配对、连接三个阶段。
// 状态机设计（STATE_PREPARE -> STATE_PAIRING -> STATE_PAIRED -> STATE_CONNECT_SUCCESS）
// 防止在已有设备正在配对时重复触发另一个设备的配对流程，保证同一时刻只处理一台遥控器。
class PartsPairController {
  private pairModel: PartsPairModel | null = null
  private threeModeRemoteModel: ThreeModeRemoteModel | null = null
  private scanning = false
  private currentState: PairingState = PairingState.STATE_PREPARE
  private stateChangeListener?: (state: PairingState) => void

  constructor() {
  }

  private getPairModel(): PartsPairModel {
    if (!this.pairModel) {
      this.pairModel = new PartsPairModel()
    }
    return this.pairModel
  }

  private getThreeModeRemoteModel(): ThreeModeRemoteModel {
    if (!this.threeModeRemoteModel) {
      this.threeModeRemoteModel = new ThreeModeRemoteModel()
    }
    return this.threeModeRemoteModel
  }

  // start 通过观察蓝牙开关状态而非直接开始扫描，
  // 是因为 TV 开机顺序不固定，蓝牙服务可能比 SystemUI 晚就绪，
  // 监听开关回调可确保蓝牙就绪后自动触发扫描，无需硬等待或轮询。
  start() {
    LogUtil.info(TAG, `start`)
    this.getPairModel().observerBluetooth((switchOn) => {
      LogUtil.info(TAG, `openBluetooth ${switchOn}  ${this.scanning}`)
      if (switchOn) {
        if (!this.scanning) {
          this.scanning = true
          this.scanDevices();
        }
      } else {
        this.stop()
      }
    })
  }

  stop() {
    LogUtil.info(TAG, `stop scan scanning = ${this.scanning}`)
    this.stopScan()
  }

  stopScan() {
    if (this.scanning) {
      this.scanning = false
      try {
        this.getPairModel().stopScan()
        this.getPairModel().unSubscribeBluetoothDeviceFind()
      } catch (e) {
        LogUtil.error(TAG, `stop fail ` + JSON.stringify(e))
      }
      this.stateChangeListener = undefined
    }
  }

  public getState(): number {
    return this.currentState
  }

  public setStateChangeListener(l: (state: PairingState) => void) {
    this.stateChangeListener = l
  }

  public set3ModeRemoteToTV() {
    this.getThreeModeRemoteModel().setRCStateToTV()
  }

  public setTVFullScreenState(fullScreen: boolean) {
    this.getThreeModeRemoteModel().setTVFullScreenState(fullScreen)
  }

  public is3ModeRemoteConnected(): boolean {
    return this.getThreeModeRemoteModel().is3ModeRemoteConnected()
  }

  // 扫描时仅在 STATE_PREPARE 状态下处理新发现的设备，
  // 防止前一台设备配对过程中再次响应扫描结果，造成配对状态机混乱。
  // STATE_CONNECTED 设备走自动重连流程，避免重新弹出配对确认 UI 打扰用户。
  private scanDevices() {
    LogUtil.info(TAG, `connectRcDevices`)
    this.notifyStateChange(PairingState.STATE_PREPARE, StateChangeTag.INIT, false)
    this.getPairModel().subscribeBluetoothDeviceFind((deviceId, deviceName) => {
      deviceName = deviceName.trim()
      if (this.currentState !== PairingState.STATE_PREPARE) {
        return
      }
      const deviceType = this.getPairModel().getDeviceState(deviceId, deviceName)
      if (deviceType === PartsDeviceState.STATE_NEW) {
        LogUtil.info(TAG, 'find new device ' + deviceName)
        this.notifyStateChange(PairingState.STATE_PAIRING, StateChangeTag.NEW_DEVICE_FOUND, false)
        this.pairDevice(deviceId)
      } else if (deviceType == PartsDeviceState.STATE_CONNECTED) {
        LogUtil.info(TAG, 'find connected device ' + deviceName)
        this.notifyStateChange(PairingState.STATE_PAIRING, StateChangeTag.CONNECT_DEVICE_FOUND, false)
        this.pairDevice(deviceId, true)
      } else if (deviceType === PartsDeviceState.STATE_CONNECTING) {
        LogUtil.info(TAG, 'find connecting device ' + deviceName)
      }
    })
    this.getPairModel().startScan()
  }

  // silent 参数用于区分"自动重连已知设备"和"配对全新设备"两种场景：
  // 自动重连不通知上层状态监听器，避免触发配对 UI 弹窗打断用户当前操作。
  private pairDevice(deviceId: string, silent: boolean = false) {
    this.getPairModel().pairDevice(deviceId)
      .then((pairSuccess) => {
        LogUtil.info(TAG, `pairDevice ${deviceId} ${pairSuccess}`)
        if (pairSuccess) {
          this.notifyStateChange(PairingState.STATE_PAIRED, StateChangeTag.PAIR_SUCCESS, silent)
          return this.getPairModel().connectDevice(deviceId)
        } else {
          this.notifyStateChange(PairingState.STATE_PREPARE, StateChangeTag.PAIR_FAIL, silent)
          return false
        }
      })
      .then((connectResult) => {
        LogUtil.info(TAG, `connectDevice ${deviceId} ${connectResult}`)
        if (connectResult) {
          this.notifyStateChange(PairingState.STATE_CONNECT_SUCCESS, StateChangeTag.CONNECT_SUCCESS, silent)
          this.getPairModel().onConnectSuccess(deviceId)
          this.getThreeModeRemoteModel().connect(deviceId)
        } else {
          this.getPairModel().unPairDevice(deviceId)
          this.notifyStateChange(PairingState.STATE_CONNECT_FAIL, StateChangeTag.CONNECT_FAIL, silent)
          this.getPairModel().onConnectFail(deviceId)
        }
      })
      .catch((err: BusinessError) => {
        LogUtil.info(TAG, `pairDevice ${deviceId} error ${JSON.stringify(err)}`)
        this.getPairModel().unPairDevice(deviceId)
        this.notifyStateChange(PairingState.STATE_UNKNOWN_ERROR, StateChangeTag.OPERATE_ERROR, silent)
        this.getPairModel().onConnectFail(deviceId)
      })
  }

  // 连接成功/失败后延迟 RESET_DELAY_TIME 自动回到 STATE_PREPARE，
  // 使控制器可以继续扫描下一台配件，无需外部重新触发 start()，
  // 适配 TV 开机后多配件依次自动重连的业务场景。
  private notifyStateChange(newState: PairingState, tag: StateChangeTag, silent: boolean) {
    LogUtil.info(TAG,
      'notifyStateChange from = ' + this.currentState + ' to = ' + newState + ' tag: ' + tag)
    if (this.currentState !== newState) {
      this.currentState = newState
      if (!silent) {
        this.stateChangeListener && this.stateChangeListener(this.currentState)
      }
      if (this.currentState >= PairingState.STATE_CONNECT_SUCCESS) {
        setTimeout(() => {
          this.notifyStateChange(PairingState.STATE_PREPARE, StateChangeTag.RESET, silent)
        }, RESET_DELAY_TIME)
      }
    }
  }
}

let partsPairController = new PartsPairController()

export default partsPairController
