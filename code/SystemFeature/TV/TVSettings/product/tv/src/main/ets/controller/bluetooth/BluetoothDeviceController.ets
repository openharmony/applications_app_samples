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

import BaseSettingsController from '../../../../../../../common/component/src/main/ets/default/controller/BaseSettingsController';
import BluetoothModel, {
  BondState,
  ProfileConnectionState,
  DeviceProfileState,
  DeviceConnectResult,
  DeviceDisconnectResult,
  BondStateChangedData,
  PinRequiredData
} from '../../model/bluetoothImpl/BluetoothModel';
import BluetoothDevice from '../../model/bluetoothImpl/BluetoothDevice';
import Log from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogDecorator';
import ConfigData from '../../../../../../../common/utils/src/main/ets/default/baseUtil/ConfigData';
import type ISettingsController from '../../../../../../../common/component/src/main/ets/default/controller/ISettingsController';
import LogUtil from '../../../../../../../common/utils/src/main/ets/default/baseUtil/LogUtil';
import AboutDeviceModel from '../../model/aboutDeviceImpl/AboutDeviceModel';
import type{ BusinessError } from '@ohos.base';
import connection from '@ohos.bluetooth.connection';
import { common, Want } from '@kit.AbilityKit';

const DISCOVERY_DURING_TIME: number = 30000;    // 30'
const DISCOVERY_INTERVAL_TIME: number = 3000;   // 3'
const DISCOVERY_DEBOUNCE_TIME: number = 150;

export default class BluetoothDeviceController extends BaseSettingsController {
  private TAG = ConfigData.TAG + 'BluetoothDeviceController '
  //state
  private isOn: boolean = false;
  private enabled: boolean = false;

  // paired devices
  private pairedDevices: BluetoothDevice[] = [];

  // available devices
  private isDeviceDiscovering: boolean = false;
  private availableDevices: BluetoothDevice[] = [];
  private pairPinCode: string = '';

  private discoveryStartTimeoutId: number = 0;
  private discoveryStopTimeoutId: number = 0;
  private debounceTimer: number = 0;

  private cancelPairingTimerId: number = -1;
  private cancelPairingTime: number = 60000;

  initData(): ISettingsController {
    LogUtil.log(this.TAG + 'start to initData bluetooth');
    super.initData();
    let isOn = BluetoothModel.isStateOn();
    LogUtil.log(this.TAG + 'initData bluetooth state isOn ' + isOn + ', typeof isOn = ' + typeof(isOn))
    if (isOn) {
      setTimeout(()=>{
        this.startBluetoothDiscovery();
        this.refreshPairedDevices();
        this.startRcPairService();
      },500)
    }

    LogUtil.log(this.TAG + 'initData save value to app storage. ')
    this.isOn = new Boolean(isOn).valueOf()
    this.enabled = true

    AppStorage.setOrCreate('bluetoothIsOn', this.isOn);
    AppStorage.setOrCreate('bluetoothToggleEnabled', this.enabled);
    AppStorage.setOrCreate('bluetoothAvailableDevices', this.availableDevices);

    return this;
  }

  subscribe(): ISettingsController {
    LogUtil.log(this.TAG + 'subscribe bluetooth state isOn ' + this.isOn)
    this.subscribeStateChange();
    this.subscribeBluetoothDeviceFind();
    this.subscribeBondStateChange();
    this.subscribeDeviceConnectStateChange();
    BluetoothModel.subscribePinRequired((pinRequiredParam: PinRequiredData) => {
      LogUtil.log(this.TAG + 'bluetooth subscribePinRequired callback. pinRequiredParam = ' + pinRequiredParam.pinCode);
      let pairData = this.getAvailableDevice(pinRequiredParam.deviceId);
      this.pairPinCode = pinRequiredParam.pinCode;
      AppStorage.setOrCreate('pairData', pairData);
      AppStorage.setOrCreate('pinRequiredParam', pinRequiredParam);
    });
    return this;
  }

  unsubscribe(): ISettingsController {
    LogUtil.log(this.TAG + 'start to unsubscribe bluetooth');
    this.stopBluetoothDiscovery();

    if (this.discoveryStartTimeoutId) {
      clearTimeout(this.discoveryStartTimeoutId);
    }

    if (this.discoveryStopTimeoutId) {
      clearTimeout(this.discoveryStopTimeoutId);
    }

    BluetoothModel.unsubscribeBluetoothDeviceFind();
    BluetoothModel.unsubscribeBondStateChange();
    BluetoothModel.unsubscribeDeviceStateChange();
    BluetoothModel.unsubscribePinRequired();
    AppStorage.delete('BluetoothFailedDialogFlag');
    return this;
  }

  /**
   * Set toggle value
   */
  toggleValue(isOn: boolean,callback?: (data: boolean) => void) : void{
    if(this.discoveryStartTimeoutId) {
      clearTimeout(this.discoveryStartTimeoutId);
      this.discoveryStartTimeoutId = 0;
    }
    if(this.discoveryStopTimeoutId) {
      clearTimeout(this.discoveryStopTimeoutId);
      this.discoveryStopTimeoutId = 0;
    }

    if(this.debounceTimer) {
      clearTimeout(this.debounceTimer);
      this.debounceTimer = 0;
    }

    this.debounceTimer=setTimeout(()=>{
      let curState = BluetoothModel.getState();
      if ((curState === 2) === isOn) {
        clearTimeout(this.debounceTimer);
        this.debounceTimer = 0;
        return;
      }
      this.enabled = false
      AppStorage.setOrCreate('bluetoothToggleEnabled', this.enabled);
      LogUtil.log(this.TAG + 'afterCurrentValueChanged bluetooth state isOn = ' + this.isOn)
      if (isOn) {
        let ret = BluetoothModel.enableBluetooth();
        callback?.(ret)
      } else {
        let ret = BluetoothModel.disableBluetooth();
        callback?.(ret)
        clearTimeout(this.debounceTimer);
        this.debounceTimer = 0;
        // remove all elements from availableDevices array
        this.availableDevices.splice(0, this.availableDevices.length)
      }
    },DISCOVERY_DEBOUNCE_TIME);

  }

  /**
   * Get Local Name
   */
  getLocalName() : void{
    AppStorage.setOrCreate('bluetoothLocalName', AboutDeviceModel.getDeviceName());
  }

  /**
   * Pair device.
   *
   * @param deviceId device id
   * @param success success callback
   * @param error error callback
   */
  pair(deviceId: string, success?: (pinCode: string) => void, error?: () => void) : void{
    const device = this.getAvailableDevice(deviceId);
    if (device && device.connectionState === BondState.BOND_STATE_BONDING) {
      LogUtil.log(this.TAG + `bluetooth no Aavailable device or device is already pairing.`)
      return;
    }

    // start listening pinCode
    // BluetoothModel.subscribePinRequired((pinRequiredParam: {
    //   deviceId: string;
    //   pinCode: string;
    // }) => {
    //   LogUtil.log(this.TAG + 'bluetooth subscribePinRequired callback. pinRequiredParam = ' + pinRequiredParam.pinCode);
    //   this.pairPinCode = pinRequiredParam.pinCode;
    //
    //   BluetoothModel.unsubscribePinRequired(() => LogUtil.log(this.TAG + 'available pinRequired unsubscribed.'));
    //   if (success) {
    //     success(this.pairPinCode);
    //   }
    // })

    // start pairing
    LogUtil.log(this.TAG + 'bluetooth pairDevice result1  pairDevice= '+deviceId);
    try {
      BluetoothModel.pairDevice(deviceId);
    }catch (err){
      LogUtil.info(this.TAG +'bluetooth pairDevice result1 errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
    }
  }

  /**
   * Confirm pairing.
   *
   * @param deviceId device id
   * @param accept accept or not
   * @param success success callback
   * @param error error callback
   */
  confirmPairing(deviceId: string, accept: boolean): void {
    if (accept) {
      const device = this.getAvailableDevice(deviceId);
      try {
        if (device) {
          device.connectionState = BondState.BOND_STATE_BONDING;
        }
      } catch (err) {
        LogUtil.error(this.TAG + 'confirmPairing =' + JSON.stringify(err));
      }

      this.forceRefresh(this.availableDevices);
      AppStorage.setOrCreate('bluetoothAvailableDevices', this.availableDevices);

    }
    // set paring confirmation
    BluetoothModel.setDevicePairingConfirmation(deviceId, accept);
  }

  /**
   * Connect device.
   * @param deviceId device id
   */
  connect(deviceId: string): DeviceConnectResult[] {
    return BluetoothModel.connectDevice(deviceId);
  }

  /**
   * disconnect device.
   * @param deviceId device id
   */
  disconnect(deviceId: string): DeviceDisconnectResult[] {
    return BluetoothModel.disconnectDevice(deviceId);
  }

  /**
   * Unpair device.
   * @param deviceId device id
   */
   unpair(deviceId: string) {
    AppStorage.setOrCreate('BluetoothFailedDialogFlag', false);
    BluetoothModel.unpairDevice(deviceId);
    LogUtil.log(this.TAG + 'bluetooth paired device unpair. ')
    this.refreshPairedDevices()
  }

  /**
   * Refresh paired devices.
   */
  refreshPairedDevices(): void {
    const deviceIds: string[] = BluetoothModel.getPairedDeviceIds();
    let list: BluetoothDevice[] = [];
    // 处理空数组情况
    if (deviceIds.length === 0) {
      LogUtil.log(this.TAG + 'no paired bluetooth devices found');
    } else {
      // 只有当有设备ID时才进行遍历处理
      deviceIds.forEach(deviceId => {
        list.push(this.getDevice(deviceId));
      });
      LogUtil.log(this.TAG + `processing ${deviceIds.length} paired device IDs`);
    }
    this.pairedDevices = list;
    // 只有当列表非空时才排序（空数组排序无意义）
    if (list.length > 0) {
      this.sortPairedDevices();
    }
    // 无论是否为空都更新存储，保证数据一致性
    AppStorage.setOrCreate('bluetoothPairedDevices', this.pairedDevices);
    LogUtil.log(this.TAG + `bluetooth paired devices. list length = ${list.length}`);
  }

  /**
   * Paired device should be shown on top of the list.
   */
  private sortPairedDevices() : void{
    LogUtil.log(this.TAG + 'sortPairedDevices in.')
    this.pairedDevices.sort((a: BluetoothDevice, b: BluetoothDevice) => {
      if (a.connectionState == ProfileConnectionState.STATE_DISCONNECTED && b.connectionState == ProfileConnectionState.STATE_DISCONNECTED) {
        return 0
      } else if (b.connectionState == ProfileConnectionState.STATE_DISCONNECTED) {
        return -1
      } else if (a.connectionState == ProfileConnectionState.STATE_DISCONNECTED) {
        return 1
      } else {
        return 0
      }
    })
    LogUtil.log(this.TAG + 'sortPairedDevices out.')
  }

  //---------------------- subscribe ----------------------
  /**
   * Subscribe bluetooth state change
   */
  private subscribeStateChange() : void{
    BluetoothModel.subscribeStateChange((isOn: boolean) => {
      LogUtil.log(this.TAG + 'bluetooth state changed. isOn = ' + isOn)
      this.isOn = new Boolean(isOn).valueOf();
      this.enabled = true;

      LogUtil.log(this.TAG + 'bluetooth state changed. save value.')
      this.getLocalName()
      AppStorage.setOrCreate('bluetoothIsOn', this.isOn);
      AppStorage.setOrCreate('bluetoothToggleEnabled', this.enabled);

      if (isOn) {
        LogUtil.log(this.TAG + 'bluetooth state changed. unsubscribe')
        this.startBluetoothDiscovery();
        this.refreshPairedDevices();
      } else {
        LogUtil.log(this.TAG + 'bluetooth state changed. subscribe')
        this.mStopBluetoothDiscovery();
      }
    });
  }

  /**
   * Subscribe device find
   */
  private subscribeBluetoothDeviceFind(): void {
    BluetoothModel.subscribeBluetoothDeviceFind((deviceResults: Array<connection.DiscoveryResult>) => {
      LogUtil.log(ConfigData.TAG + 'available bluetooth devices changed.');

      deviceResults?.forEach(deviceResult => {
        let device = this.availableDevices.find((availableDevice) => {
          return availableDevice.deviceId === deviceResult.deviceId
        })
        LogUtil.log(this.TAG + 'available bluetooth find');
        let tempDevice = new BluetoothDevice();
        tempDevice.deviceId = deviceResult.deviceId;
        tempDevice.deviceName = deviceResult.deviceName;
        tempDevice.deviceType = BluetoothModel.getDeviceTypeByResult(deviceResult);
        if (tempDevice.deviceName !== "") {
          if (!device) {
            let pairedDevice = this.pairedDevices.find((pairedDevice) => {
              return pairedDevice.deviceId === deviceResult.deviceId
            })
            if (pairedDevice) {
              LogUtil.log(this.TAG + `available bluetooth is paried.`);
              let indexDeviceID = 0;
              for (let i = 0; i < this.pairedDevices.length; i++) {
                if (this.pairedDevices[i].deviceId === deviceResult.deviceId) {
                  indexDeviceID = i;
                  break;
                }
              }
              if (tempDevice.deviceName !== this.pairedDevices[indexDeviceID].deviceName) {
                this.pairedDevices.splice(indexDeviceID, 1, tempDevice);
                AppStorage.setOrCreate('bluetoothPairedDevices', this.pairedDevices);
              }
            } else {
              LogUtil.log(this.TAG + 'available bluetooth new device found. availableDevices length = ' +
              this.availableDevices.length);
              if (tempDevice.deviceName != '') {
                this.availableDevices.push(tempDevice);
              }
              LogUtil.log(this.TAG + 'available bluetooth new device pushed. availableDevices length = ' +
              this.availableDevices.length);
            }
          } else {
            LogUtil.log(this.TAG + 'bluetooth already exist!');
            let indexDeviceID = 0;
            for (let i = 0; i < this.availableDevices.length; i++) {
              if (this.availableDevices[i].deviceId === deviceResult.deviceId) {
                indexDeviceID = i;
                break;
              }
            }
            if (tempDevice.deviceName !== this.availableDevices[indexDeviceID].deviceName) {
              this.availableDevices.splice(indexDeviceID, 1, tempDevice);
            }
          }
        }
      })
      AppStorage.setOrCreate('bluetoothAvailableDevices', this.availableDevices);
    });
  }

  /**
   * Subscribe bond state change
   */
  private subscribeBondStateChange() : void{
    BluetoothModel.subscribeBondStateChange((data: BondStateChangedData) => {
      LogUtil.info(this.TAG + "data.bondState123ppp" + JSON.stringify(data.bondState))
      //paired devices
      if (data.bondState !== BondState.BOND_STATE_BONDING) {
        LogUtil.info(this.TAG +"data.bondState !== BondState.BOND_STATE_BONDING进入123ppp")
        if (this.cancelPairingTimerId != -1) {
          LogUtil.info(this.TAG +"data.bondState !== BondState.BOND_STATE_BONDING清除定时器123ppp"+this.cancelPairingTimerId)
          clearTimeout(this.cancelPairingTimerId)
          this.cancelPairingTimerId = -1
        }
        AppStorage.setOrCreate("controlPairing", true)
        this.refreshPairedDevices();
      }

      //available devices
      if (data.bondState == BondState.BOND_STATE_BONDING) {
        LogUtil.info(this.TAG +"data.bondState == BondState.BOND_STATE_BONDING进入123ppp"+this.cancelPairingTimerId)
        if (this.cancelPairingTimerId != -1) return;
        LogUtil.info(this.TAG +"data.bondState == BondState.BOND_STATE_BONDING进入123ppp延时60s"+this.cancelPairingTimerId)
        this.cancelPairingTimerId = setTimeout(() => {
          try {
            BluetoothModel.cancelPairingDevice(data.deviceId, () => {
              LogUtil.info(this.TAG +"data.bondState == BondState.BOND_STATE_BONDING进入123ppp延时60sBluetoothModel.cancelPairingDevice=="+JSON.stringify(data.deviceId))
              LogUtil.info(this.TAG +"data.bondState == BondState.BOND_STATE_BONDING进入123ppp延时60sthis.cancelPairingTimerId=="+JSON.stringify(this.cancelPairingTimerId))
              clearTimeout(this.cancelPairingTimerId)
              this.cancelPairingTimerId = -1
            });
          } catch (cancelError) {
            LogUtil.error(`${this.TAG} cancelPairingDevice进入123ppp error ==> ${JSON.stringify(cancelError)}`);
          }
        }, this.cancelPairingTime);

        AppStorage.setOrCreate("controlPairing", false)
        // case bonding
        // do nothing and still listening
        LogUtil.log(this.TAG + 'bluetooth continue listening bondStateChange.');
        const availableDevice = this.getAvailableDevice(data.deviceId);
        if (availableDevice) {
          availableDevice.connectionState = ProfileConnectionState.STATE_CONNECTING;
        }
        this.forceRefresh(this.availableDevices);
        AppStorage.setOrCreate('bluetoothAvailableDevices', this.availableDevices);

      } else if (data.bondState == BondState.BOND_STATE_INVALID) {
        AppStorage.setOrCreate("controlPairing", true)
        // case failed
        const availableDevice = this.getAvailableDevice(data.deviceId);
        if (availableDevice) {
          availableDevice.connectionState = ProfileConnectionState.STATE_DISCONNECTED;
        }
        this.forceRefresh(this.availableDevices);
        AppStorage.setOrCreate('bluetoothAvailableDevices', this.availableDevices);
        let showFlag = AppStorage.get('BluetoothFailedDialogFlag') as boolean | undefined;
        if (showFlag == false) {
          AppStorage.setOrCreate('BluetoothFailedDialogFlag', true);
          return;
        }
        let cancelPairFlag = AppStorage.get("cancelPairFlag") as boolean | undefined;
        if (cancelPairFlag) {
          AppStorage.setOrCreate('cancelPairFlag', false);
        } else {
          AppStorage.setOrCreate('cancelPairFlag', true);
        }
      } else if (data.bondState == BondState.BOND_STATE_BONDED) {
        // case success
        LogUtil.log(this.TAG + 'bluetooth bonded : remove device.');
        this.removeAvailableDevice(data.deviceId);
        BluetoothModel.connectDevice(data.deviceId);
      }

    });
  }

  /**
   * Subscribe device connect state change
   */
  private subscribeDeviceConnectStateChange() : void{
    BluetoothModel.subscribeDeviceStateChange((data: DeviceProfileState) => {
      LogUtil.log(this.TAG + 'device connection state changed. profileId:' + JSON.stringify(data.profileId)
      +' profileConnectionState: ' + JSON.stringify(data.profileConnectionState));
      for (let device of this.pairedDevices) {
        if (device.deviceId === data.deviceId) {
          device.setProfile(data);
          this.forceRefresh(this.pairedDevices);
          this.sortPairedDevices();
          AppStorage.setOrCreate('bluetoothPairedDevices', this.pairedDevices);
          break;
        }
      };
      LogUtil.log(this.TAG + 'device connection state changed. pairedDevices length = '
      + JSON.stringify(this.pairedDevices.length))
      LogUtil.log(this.TAG + 'device connection state changed. availableDevices length = '
      + JSON.stringify(this.availableDevices.length))
      this.removeAvailableDevice(data.deviceId);
    });
  }

  //---------------------- private ----------------------
  /**
   * Get device by device id.
   * @param deviceId device id
   */
  protected getDevice(deviceId: string): BluetoothDevice {
    let device = new BluetoothDevice();
    device.deviceId = deviceId;
    device.deviceName = BluetoothModel.getDeviceName(deviceId);
    device.deviceType = BluetoothModel.getDeviceType(deviceId);
    device.setProfiles(BluetoothModel.getDeviceState(deviceId));
    return device;
  }

  /**
     * Force refresh array.
     * Note: the purpose of this function is just trying to fix page (ets) level's bug below,
     *   and should be useless if fixed by the future sdk.
     * Bug Details:
     *   @State is not supported well for Array<CustomClass> type.
     *   In the case that the array item's field value changed, while not its length,
     *   the build method on page will not be triggered!
     */
  protected forceRefresh(arr: BluetoothDevice[]): void {
    arr.push(new BluetoothDevice())
    arr.pop();
  }

  /**
   * Start bluetooth discovery.
   */
  @Log
  public startBluetoothDiscovery(): void {
    this.isDeviceDiscovering = true;
    BluetoothModel.startBluetoothDiscovery();
    if(this.discoveryStopTimeoutId) {
      clearTimeout(this.discoveryStopTimeoutId);
      this.discoveryStopTimeoutId = 0;
    }

    this.discoveryStopTimeoutId = setTimeout(() => {
      this.stopBluetoothDiscovery();
      clearTimeout(this.discoveryStopTimeoutId);
      this.discoveryStopTimeoutId = 0;
    }, DISCOVERY_DURING_TIME);
  }

  /**
   * Stop bluetooth discovery.
   */
  @Log
  private stopBluetoothDiscovery() : void{
    this.isDeviceDiscovering = false;
    BluetoothModel.stopBluetoothDiscovery();

    if(this.discoveryStartTimeoutId) {
      clearTimeout(this.discoveryStartTimeoutId);
      this.discoveryStartTimeoutId = 0;
    }

    this.discoveryStartTimeoutId = setTimeout(() => {
      this.startBluetoothDiscovery();
      clearTimeout(this.discoveryStartTimeoutId);
      this.discoveryStartTimeoutId = 0;
    }, DISCOVERY_INTERVAL_TIME);
  }

  /**
  * Stop bluetooth discovery.
  */
  private mStopBluetoothDiscovery() : void{
    this.isDeviceDiscovering = false;
    BluetoothModel.stopBluetoothDiscovery();
    if (this.discoveryStartTimeoutId) {
      clearTimeout(this.discoveryStartTimeoutId);
    }

    if (this.discoveryStopTimeoutId) {
      clearTimeout(this.discoveryStopTimeoutId);
    }
  }

  /**
   * Start bluetooth Rc Pair-Service.
   * (BtRc Pair-Service will finish itself automatically, restart it when enter bluetooth page to ensure BtRc pair with full ability)
   */
  @Log
  public startRcPairService(): void {
    const want: Want = { bundleName: 'com.ohos.systemui',
      abilityName: 'com.ohos.systemui.pairservice.ServiceExtAbility',
      parameters:{command: 'doPairing'} };
    if(globalThis.bluetoothPairDialogContext != undefined) {
      (globalThis.bluetoothPairDialogContext as common.UIExtensionContext).startServiceExtensionAbility(want)
    } else {
      globalThis.settingsAbilityContext.startServiceExtensionAbility(want);
    }
  }


  /**
   * Get available device.
   *
   * @param deviceId device id
   */
  private getAvailableDevice(deviceIds: string): BluetoothDevice | null {
    LogUtil.log(this.TAG + 'getAvailableDevice  length = ' + this.availableDevices.length);
    let temp =  this.availableDevices;
    for(let i = 0; i < temp.length; i++){
      if (temp[i].deviceId === deviceIds) {
        return temp[i];
      }
    }
    return null;
  }

  /**
   * Remove available device.
   *
   * @param deviceId device id
   */
  private removeAvailableDevice(deviceId: string): void {
    LogUtil.log(this.TAG + 'removeAvailableDevice : before : availableDevices length = ' + this.availableDevices.length);
    this.availableDevices = this.availableDevices.filter((device) => device.deviceId !== deviceId)
    AppStorage.setOrCreate('bluetoothAvailableDevices', this.availableDevices);
    LogUtil.log(this.TAG + 'removeAvailableDevice : after : availableDevices length = ' + this.availableDevices.length);
  }

}
