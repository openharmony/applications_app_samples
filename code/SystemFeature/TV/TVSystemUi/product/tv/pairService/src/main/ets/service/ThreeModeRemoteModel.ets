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
 

﻿import { ble, constant } from '@kit.ConnectivityKit';
import LogUtil from '../util/LogUtil';
import { BusinessError, systemParameterEnhance } from '@kit.BasicServicesKit';
import { settings } from '@kit.BasicServicesKit';
import { serviceExtensionContext } from './PartsPairService';
import displaySetting from '@ohos.tvservice.displaySetting';

const TAG = '[PPL_3ModeRemote]'
const BLUETOOTH_CONNECT_TIMEOUT_DURATION = 10 * 1000
const THREE_MODE_REMOTE_SERVICE_UUID = '19EE51A4-9AD3-7E6F-E4E7-EBC33F46A000'
const SOURCE_STATE_UUID = '19EE51A4-9AD3-7E6F-E4E7-EBC33F46A071'
const TV_FULL_SCREEN_STATE_UUID = '19EE51A4-9AD3-7E6F-E4E7-EBC33F46A073'

const SOURCE_STATE_TV = 1
const SOURCE_STATE_STB = 2
const TV_FULL_SCREEN = 0
const TV_NOT_FULL_SCREEN = 1

const REMOTE_CONTROL_STATE_UNKNOWN = -1
const REMOTE_CONTROL_STATE_TV = 1
const REMOTE_CONTROL_STATE_STB = 2

// ThreeModeRemoteModel 管理三模遥控器（蓝牙/红外/RF）的 GATT 连接及信源控制。
// 通过 BLE GATT 特征值写入控制遥控器工作模式（控制电视 vs 控制机顶盒），
// 避免用户切换信源时需要手动切换遥控器模式，实现信源感知的自动模式跟随。
export class ThreeModeRemoteModel {
  private deviceId: string = ''
  private gattClient: ble.GattClientDevice | undefined = undefined
  private curSource: displaySetting.SourceType = displaySetting.SourceType.SOURCE_MEDIA
  private signalStatus: displaySetting.SignalStatus = displaySetting.SignalStatus.SIGNAL_NOSIGNAL
  private isTVFullScreen: boolean = true
  private remoteControlState: number = REMOTE_CONTROL_STATE_UNKNOWN
  private sourceStateChar: ble.BLECharacteristic | undefined = undefined;
  private tvFullScreenStateChar: ble.BLECharacteristic | undefined = undefined;
  private serviceFound: boolean = false

  constructor() {
  }

  connect(deviceId: string) {
    LogUtil.info(TAG, 'connect gatt')
    this.deviceId = deviceId
    try {
      this.gattClient = ble.createGattClientDevice(this.deviceId)
      this.gattClient.on('BLEConnectionStateChange', (stateChange) => {
        LogUtil.info(TAG, `on BLEConnectionStateChange state=${JSON.stringify(stateChange)}`)
        if (stateChange.state != constant.ProfileConnectionState.STATE_CONNECTED) {
          this.disconnect()
          return
        }
        if (this.gattClient === undefined) {
          return
        }

        this.gattClient.getServices((error: BusinessError, gattServices: Array<ble.GattService>) => {
          if (error) {
            LogUtil.error(TAG, `getServices error:  ${JSON.stringify(error)}`)
            return
          }

          for (const service of gattServices) {
            // 查找3模遥控 gatt 服务
            if (service.serviceUuid.toUpperCase() === THREE_MODE_REMOTE_SERVICE_UUID) {
              for (const characteristic of service.characteristics) {
                // 查找信源通道状态特征
                if (characteristic.characteristicUuid.toUpperCase() === SOURCE_STATE_UUID) {
                  this.sourceStateChar = characteristic
                }
                // 查找信源全屏状态特征
                if (characteristic.characteristicUuid.toUpperCase() === TV_FULL_SCREEN_STATE_UUID) {
                  this.tvFullScreenStateChar = characteristic
                }
              }
              if (this.sourceStateChar && this.tvFullScreenStateChar) {
                LogUtil.info(TAG, `3ModeRemote service =${JSON.stringify(service)}`)
                this.serviceFound = true
                this.on3ModeRemoteConnected()
                break
              }
            }
          }
        })
      })

      this.gattClient.connect()
    } catch (error) {
      LogUtil.info(TAG, `connect gatt error:  ${JSON.stringify(error)}`)
    }

    setTimeout(() => {
      if (!this.serviceFound) {
        LogUtil.info(TAG, `gatt not connected on timeout`);
      }
    }, BLUETOOTH_CONNECT_TIMEOUT_DURATION);

  }

  disconnect() {
    LogUtil.info(TAG, 'disconnect')
    displaySetting.off('signalStatusChange')
    try {
      this.gattClient?.disconnect()
      this.gattClient?.close()
    } catch (error) {
      LogUtil.info(TAG, `disconnect gatt error:  ${JSON.stringify(error)}`)
    }
  }

  private on3ModeRemoteConnected() {
    // 监听信源状态变化, 已经包括了信源变化,和信号变化了, 不需要再另外监听信源变化
    displaySetting.on('signalStatusChange', (sourceSignal: displaySetting.SourceSignal) => {
      this.signalStatus = sourceSignal.status
      this.curSource = sourceSignal.source
      LogUtil.info(TAG, `signalStatusChange, ${JSON.stringify(sourceSignal)}`)
      this.updateRemoteControlState()
    })

    // 遥控器连接上后, 查询当前信源及信号状态, 如果是设置的直播源,且有信号则通知遥控器切换到机顶盒模式
    displaySetting.getCurSource((err: BusinessError, source: displaySetting.SourceType) => {
      if (err) {
        LogUtil.error(TAG, `getCurSource error:  ${JSON.stringify(err)}`)
        return
      }
      this.curSource = source
      LogUtil.info(TAG, `curSource=${this.curSource}`)
      displaySetting.getSignalStatus((err: BusinessError, signalStatus: displaySetting.SignalStatus) => {
        if (err) {
          LogUtil.error(TAG, `getSignalStatus error:  ${JSON.stringify(err)}`)
          return
        }
        this.signalStatus = signalStatus
        LogUtil.info(TAG, `signalStatus=${this.signalStatus}`)
        this.updateRemoteControlState()
      })
    })
  }

  setTVFullScreenState(fullScreen: boolean) {
    LogUtil.info(TAG, `fullScreen change to ${fullScreen}`)
    this.isTVFullScreen = fullScreen
    this.updateRemoteControlState()
  }

  private sendGattMessage(ch: ble.BLECharacteristic | undefined, value: number) {
    if (!ch) {
      LogUtil.error(TAG, 'BLECharacteristic is null');
      return;
    }

    ch.characteristicValue = new ArrayBuffer(1);
    let cccV = new Uint8Array(ch.characteristicValue);
    cccV[0] = value;

    this.gattClient?.writeCharacteristicValue(
      ch,
      ble.GattWriteType.WRITE_NO_RESPONSE,
      (e) => e && LogUtil.error(TAG, `writeCharacteristicValue fail: ${JSON.stringify(e)}`));
  }

  // 只有同时满足"当前信源为看电视键绑定的直播源 + 有信号 + 全屏"三个条件才切换到机顶盒控制模式，
  // 任意条件不满足时回退到电视控制模式，防止非直播场景下遥控器误切模式导致用户操控异常。
  private updateRemoteControlState() {
    let rcState: number = REMOTE_CONTROL_STATE_TV
    let watchTvSource = this.getWatchTvSource()
    LogUtil.debug(TAG, `watchTvSource = ${watchTvSource}`)
    // 当前信源为直播源且有信号且是全屏状态, 则为控制机顶盒模式
    if (this.curSource === watchTvSource &&
      this.signalStatus === displaySetting.SignalStatus.SIGNAL_SUPPORT &&
    this.isTVFullScreen) {
      rcState = REMOTE_CONTROL_STATE_STB
    }

    if (this.remoteControlState != rcState) {
      LogUtil.info(TAG, `remoteControlState changed from ${this.remoteControlState} to ${rcState}`)
      this.remoteControlState = rcState
      this.sendRemoteControlState()
    }
  }

  setRCStateToTV() {
    LogUtil.info(TAG, 'setRCStateToTV')
    this.sendGattMessage(this.sourceStateChar, SOURCE_STATE_TV)
    this.sendGattMessage(this.tvFullScreenStateChar, TV_NOT_FULL_SCREEN)
  }

  setRCStateToSTB() {
    LogUtil.info(TAG, 'setRCStateToSTB')
    this.sendGattMessage(this.sourceStateChar, SOURCE_STATE_STB)
    this.sendGattMessage(this.tvFullScreenStateChar, TV_FULL_SCREEN)
  }

  is3ModeRemoteConnected(): boolean {
    return this.serviceFound
  }

  private sendRemoteControlState() {
    if (this.remoteControlState === REMOTE_CONTROL_STATE_STB) {
      this.setRCStateToSTB()
    } else {
      this.setRCStateToTV()
    }
  }

  // 获取看电视键设置的信源, 在 "设置 -> 通用 -> 看电视键设置" 页面设置
  // 看电视键绑定的信源从 DEVICE_SHARED 域读取用户在设置页面的选择，
  // 未设置时默认 HDMI1，因为大多数 TV 用户习惯将机顶盒接在 HDMI1 口。
  private getWatchTvSource(): displaySetting.SourceType {
    if (serviceExtensionContext === undefined) {
      return displaySetting.SourceType.SOURCE_HDMI1
    }

    try {
      let stringIndex: string = settings.getValueSync(serviceExtensionContext, 'watchTvSource', '-1', settings.domainName.DEVICE_SHARED);
      let source: number = Number.parseInt(stringIndex);
      if (source >= displaySetting.SourceType.SOURCE_HDMI1 && source <= displaySetting.SourceType.SOURCE_HDMI4) {
        return source;
      }
    } catch (error) {
      LogUtil.log(TAG, 'getWatchTvSource error:' + JSON.stringify(error));
    }
    // 如果未设置过看电视键绑定的信源, 则默认为 hdmi 1
    return displaySetting.SourceType.SOURCE_HDMI1
  }
}