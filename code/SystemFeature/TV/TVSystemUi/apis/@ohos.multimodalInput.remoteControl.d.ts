/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

/**
 * @file
 * @kit InputKit
 */
import type { Callback, AsyncCallback } from './@ohos.base';

/**
 * To obtain basic information module of input device remote control.
 *
 * @namespace remoteControl
 * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
 */
declare namespace remoteControl {
  /**
   * Types of remote control status changes
   * @typedef { 'UwbStatusChange' | 'BatteryValueChange' | 'ChargeStatusChange' | 'ConnectStatusChange' | 'ReceiverStatusChange' }
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  type ChangedType = 'UwbStatusChange' | 'BatteryValueChange' | 'ChargeStatusChange' | 'ConnectStatusChange' | 'ReceiverStatusChange';
  /**
   * @enum { number }
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  enum SensitivityType {
    LOW_SENSITIVITY = 0,
    MEDIUM_SENSITIVITY = 1,
    HIGH_SENSITIVITY = 2,
  }

  enum ReceiverBtSwitchStatus {
    RECEIVER_BT_OFF = 0,
    RECEIVER_BT_ON = 1,
  }

  enum PairingStatus {
    NOT_PAIRING = 0,
    PAIRING_CONNECT = 1,
    PAIRING_DISCONNECT = 2,
  }

  enum ChargeStatus {
    NOT_CHARGE = 0,
    CHARGEING = 1,
  }

  enum UwbStatus {
    UWB_OFF = 0,
    UWB_ON = 1,
  }

  enum ReceiverHotSwapStatus {
    RECEIVER_PLUG_OUT = 0,
    RECEIVER_PLUG_IN = 1,
  }

  /**
   * Defines the listener for remote control events.
   *
   * @interface DeviceListener
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  interface RemoteControlListener {
    /**
     * Types of remote control status changes
     *
     * @type { ChangedType }
     * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
     */
    type: ChangedType;

    /**
     * The status value changed by the remote control
     *
     * @type { number }
     * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
     */
    changeVal: number;
  }

  /**
   * Defines the information about remote control.
   *
   * @interface RemoteCtrlBaseInfo
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  interface RemoteCtrlBaseInfo {
    /**
     * Type of the version.
     *
     * @type { string }
     * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
     */
    version: string;
    /**
     * Type of the sensitivity.
     *
     * @type { SensitivityType }
     * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
     */
    sensitivity: SensitivityType;
    /**
     * Type of the battery.
     *
     * @type { number }
     * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
     */
    battery: number;
    /**
     * Type of the chargeStatus.
     *
     * @type { number }
     * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
     */
    chargeStatus: number;
    /**
     * Type of the uwbStatus.
     *
     * @type { number }
     * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
     */
    uwbStatus: number;
    /**
     * Type of the connStatus.
     *
     * @type { number }
     * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
     */
    connStatus: number;
    /**
     * Type of the receiverBtSwitchStatus.
     *
     * @type { number }
     * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
     */
    receiverBtSwitchStatus: number;
    /**
     * Type of the mac.
     *
     * @type { string }
     * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
     */
    mac: string;
  }

  /**
   * Set Remote control sensitivity.
   *
   * @param { SensitivityType } sensitivity - Remote control sensitivity
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  function setRemoteControlSensitivitySync(sensitivity: SensitivityType): void;

  /**
   * Get Remote control sensitivity.
   *
   * @returns { SensitivityType } - Returns -1 on failure
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  function getRemoteControlSensitivitySync(): SensitivityType;

  /**
   * Get Remote control ChargeStatus.
   *
   * @returns { ChargeStatus } - Returns -1 on failure
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  function getRemoteControlChargeStatusSync(): ChargeStatus;

  /**
   * Get Remote control BatteryValue.
   *
   * @returns { number } - Returns -1 on failure
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  function getRemoteControlBatteryValueSync(): number;

  /**
   * Get Remote control UwbStatus.
   *
   * @returns { UwbStatus } - Returns -1 on failure
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  function getRemoteControlUwbStatusSync(): UwbStatus;

  /**
   * Get Remote control ConnectStatus.
   *
   * @returns { PairingStatus }
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  function getRemoteControlConnectStatusSync(): PairingStatus;

  /**
   * Get Remote control Version.
   *
   * @returns { string } - Returns null on failure
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  function getRemoteControlVersionSync(): string;

  /**
   * Get Remote control ReceiverBtSwitchStatus.
   *
   * @returns { ReceiverBtSwitchStatus }
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  function getRemoteControlReceiverBtSwitchStatusSync(): ReceiverBtSwitchStatus;

  /**
   * Set Remote control ReceiverBtSwitchStatus.
   *
   * @param { ReceiverBtSwitchStatus }
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  function setRemoteControlReceiverBtSwitchStatusSync(status: ReceiverBtSwitchStatus): void;

  /**
   * Get Remote control Mac.
   *
   * @returns { string } - Returns null on failure
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  function getRemoteControlMacSync(): string;

  /**
   * Delete Remote control Pair.
   *
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  function deleteRemoteControlPairSync(): number;

  /**
   * Delete Remote Base Info.
   *
   * @returns { RemoteCtrlBaseInfo }
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  function getRemoteControlBaseInfoSync(): RemoteCtrlBaseInfo;

  /**
   * Get Remote Control Base Info
   *
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  function getRemoteControlBaseInfo(): Promise<RemoteCtrlBaseInfo>;

  /**
   * Get Remote Control Base Info
   *
   * @param { AsyncCallback<RemoteCtrlBaseInfo> }
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  function getRemoteControlBaseInfo(callback: AsyncCallback<RemoteCtrlBaseInfo>): void;

  /**
   * Starts listening for an Remote Control event.
   *
   * @param { 'RemoteControlChange' } type - Type of the Remote Control event
   * @param { Callback<RemoteControlListener> } listener - Callback for the Remote Control event.
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  function on(type: 'RemoteControlChange', listener: Callback<RemoteControlListener>): void;

  /**
   * Stops listening for an Remote Control event.
   *
   * @param { 'RemoteControlChange' } type - Type of the Remote Control event
   * @param { Callback<RemoteControlListener> } listener - Callback for the Remote Control event.
   * @syscap SystemCapability.MultimodalInput.Input.RemoteControl
   */
  function off(type: 'RemoteControlChange', listener?: Callback<RemoteControlListener>): void;
}
export default remoteControl;
