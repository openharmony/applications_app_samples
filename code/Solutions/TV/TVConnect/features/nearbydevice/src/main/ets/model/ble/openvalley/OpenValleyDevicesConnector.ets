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

import OpenValleyDevicesController from './OpenValleyDevicesController';
import { ble } from '@kit.ConnectivityKit';
import OpenValleyDevice from './OpenValleyDevice';
import { BusinessError, Callback } from '@kit.BasicServicesKit';
import { InfDevice, InfDevicesConnector, Logger } from '@ohos/common';
import { BleReceiveDataResult, IBleConnectorManager, platform } from 'library_communication/Index';
import OpenValleyConstants from './OpenValleyConstants';
import { Base64Utils, ConvertUtils, StringUtils } from 'library_communication';
import constant from '@ohos.bluetooth.constant';
import { AuthenticationRes, Cmd } from './model/res/AuthenticationRes';
import { GlobalStore } from './util/GlobalStore';
import { KeyInfo } from './entity/KeyInfo';
import { PayloadIdInfo } from './model/payload/PayloadIdInfo';
import { ControllerIdInfoQueryReq } from './model/req/ControllerIdInfoQueryReq';
import { ControllerIdInfoQueryRes } from './model/res/ControllerIdInfoQueryRes';
import { IdInfoConverter } from './entity/converter/IdInfoConverter';
import { ControllerTestReq } from './model/req/ControllerTestReq';
import { PayloadQueryDev } from './model/payload/PayloadQueryDev';
import { DevQueryReq } from './model/req/DevQueryReq';
import { PayloadDevInfo } from './model/payload/PayloadDevInfo';
import { ControllerDevInfoRes } from './model/res/ControllerDevInfoRes';

const TAG = 'OpenValleyDevicesConnector';

export default class OpenValleyDevicesConnector implements InfDevicesConnector, IBleConnectorManager {
  public controller: OpenValleyDevicesController;
  public connectedDevice: InfDevice | undefined;
  public connectedClient: ble.GattClientDevice | undefined;
  public onDataReceive: Callback<Uint8Array> | undefined;
  //连接回调
  public onConnectCallback: Callback<boolean> | undefined;
  public connectResolveFun: Function | undefined;
  public connectRejectFun: Function | undefined;
  public connectIntervalId: number = 0;
  private base64Utils: Base64Utils = new Base64Utils();
  //设备发现回调
  public onDevFindCallback: Callback<PayloadDevInfo> | undefined;

  constructor(controller: OpenValleyDevicesController) {
    this.controller = controller;
    platform.init(this);
    platform.getIBleInterface().registerBleReceiveDataListener(this.bleReceiveDataCallback);
  }

  getMac(): string {
    return this.connectedDevice ? this.connectedDevice.getUnionCode() : '';
  }

  write(data: Uint8Array): void {
    this.writeInternal(data);
  }

  registerBleReceiveDataListener(callback: Callback<Uint8Array>): void {
    this.onDataReceive = callback;
  }

  registerDevFindCallback(callback: Callback<PayloadDevInfo>) {
    this.onDevFindCallback = callback;
  }

  unregisterBleReceiveDataListener(callback: Callback<Uint8Array>): void {
    this.onDataReceive = undefined;
  }

  async connect(device: InfDevice): Promise<boolean> {
    const bleDevice: OpenValleyDevice = device as OpenValleyDevice;
    this.connectedDevice = bleDevice;
    return new Promise((resolve, reject) => {
      this.connectResolveFun = resolve;
      this.connectRejectFun = reject;
      try {
        this.connectedClient = ble.createGattClientDevice(bleDevice.mac);
        this.connectedClient.on('BLEConnectionStateChange', this.onConnectStateChanged);
        this.connectedClient.on('BLECharacteristicChange', this.onCharacteristicChange);
        this.connectedClient.connect();
        this.connectIntervalId = setTimeout(() => {
          Logger.debug(TAG, '连接超时');
          if (this.connectRejectFun) {
            this.connectRejectFun();
          }
        }, OpenValleyConstants.BLE_CONNECT_TIMEOUT);
      } catch (err) {
        Logger.error(TAG, 'OpenValleyDevicesConnector ,errCode: ' + (err as BusinessError).code + ', errMessage: ' +
        (err as BusinessError).message);
        reject();
      }
    });
  }

  async pre(device: InfDevice): Promise<boolean> {
    /**
     * 完成密钥交换
     */
    this.authentication();
    return true;
  }

  getCurrentConnectedDevice(): InfDevice | undefined {
    return this.connectedDevice;
  }

  async stopConnect(device: InfDevice): Promise<boolean> {
    try {
      if (this.connectedClient) {
        this.connectedClient.disconnect();
        this.connectedClient.close();
        this.connectedDevice = undefined;
        this.connectedClient = undefined;
      }
      return true;
    } catch (err) {
      Logger.error(TAG, 'BleDevicesConnector ,errCode: ' + (err as BusinessError).code + ', errMessage: ' +
      (err as BusinessError).message);
      return false;
    }
  }

  private onConnectStateChanged = (state: ble.BLEConnectionChangeState) => {
    Logger.debug(TAG, 'onConnectStateChanged : ' + JSON.stringify(state));
    if (this.connectedClient) {
      if (state.state == constant.ProfileConnectionState.STATE_DISCONNECTED) {
        Logger.debug(TAG, 'onBleDisconnected ');
      } else if (state.state == constant.ProfileConnectionState.STATE_CONNECTED) { //连接成功
        //enableNotify
        this.enableNotify(this.connectedClient, true).then(() => {
          Logger.debug(TAG, `enableNotify success `);
          //setBLEMtuSize
          this.connectedClient!.on('BLEMtuChange', (mtu: number) => {
            Logger.debug(TAG, 'BLEMtuChange mtu:' + mtu);
            //回调
            Logger.debug(TAG, 'onBleConnected ');
            if (this.connectResolveFun) {
              this.connectResolveFun(true);
            }
            //取消定时器
            clearTimeout(this.connectIntervalId);
          });
          this.connectedClient!.setBLEMtuSize(OpenValleyConstants.DEFAULT_MTU);
        });
      }
    }
  };
  private onCharacteristicChange = (characteristicChangeReq: ble.BLECharacteristic) => {
    let serviceUuid: string = characteristicChangeReq.serviceUuid;
    let characteristicUuid: string = characteristicChangeReq.characteristicUuid;
    Logger.debug(TAG,
      'onCharacteristicChange serviceUuid: ' + serviceUuid + ' characteristicUuid: ' + characteristicUuid);

    if (serviceUuid === OpenValleyConstants.UUID_SERVICE &&
      characteristicUuid === OpenValleyConstants.UUID_CHARACTERISTIC_INDICATE) {
      let value: Uint8Array = new Uint8Array(characteristicChangeReq.characteristicValue);
      Logger.debug(TAG, ' onCharacteristicChange value: ' + ConvertUtils.uint8Array2HexString(value));
      if (this.onDataReceive) {
        this.onDataReceive(value);
      }
    }
  };

  private async enableNotify(gattClientDevice: ble.GattClientDevice, enable: boolean) {
    let services: ble.GattService[] = await gattClientDevice.getServices();
    let service = services.find(item => item.serviceUuid === OpenValleyConstants.UUID_SERVICE);
    Logger.debug(TAG, `enableNotify: service = ${JSON.stringify(service)}`);
    if (service) {
      let characteristics: ble.BLECharacteristic[] = service.characteristics;
      let characteristic =
        characteristics.find(item => item.characteristicUuid === OpenValleyConstants.UUID_CHARACTERISTIC_INDICATE);
      Logger.debug(TAG, `enableNotify: characteristic = ${JSON.stringify(characteristic)}`);
      if (characteristic) {
        await gattClientDevice.setCharacteristicChangeNotification(characteristic, enable);
        Logger.debug(TAG, `enableNotify: setCharacteristicChangeNotification `);
      }
    }
  }

  /**
   * 写入数据
   * @param data
   */
  private async writeInternal(data: Uint8Array) {
    if (this.connectedClient) {
      let services: ble.GattService[] = await this.connectedClient.getServices();
      let service = services.find(item => item.serviceUuid === OpenValleyConstants.UUID_SERVICE);
      Logger.debug(TAG, `writeInternal: service = ${JSON.stringify(service)}`);
      if (service) {
        let characteristics: ble.BLECharacteristic[] = service.characteristics;
        let characteristic =
          characteristics.find(item => item.characteristicUuid === OpenValleyConstants.UUID_CHARACTERISTIC_WRITE);
        Logger.debug(TAG, `writeInternal: characteristic = ${JSON.stringify(characteristic)}`);
        if (characteristic) {
          await this.writeData(this.connectedClient, characteristic, data);
        }
      }
    }
  }

  private async writeData(gattClientDevice: ble.GattClientDevice, characteristic: ble.BLECharacteristic,
    data: Uint8Array) {
    let index = 0;
    let length = data.length;
    let availableLength = length;

    while (index < length) {
      //一包数据的长度
      let onePackLength: number = (availableLength >= OpenValleyConstants.DEFAULT_WRITE_DATA_SPLIT_COUNT ?
      OpenValleyConstants.DEFAULT_WRITE_DATA_SPLIT_COUNT : availableLength);
      let onePackData = data.subarray(index, index + onePackLength);
      Logger.debug(TAG, 'onePackData： ' + ConvertUtils.uint8Array2HexString(onePackData));
      index += onePackLength;
      availableLength -= onePackLength;
      characteristic.characteristicValue = new ArrayBuffer(onePackData.length);
      let targetArray = new Uint8Array(characteristic.characteristicValue);
      targetArray.set(onePackData); // 复制数据
      await gattClientDevice.writeCharacteristicValue(characteristic, ble.GattWriteType.WRITE_NO_RESPONSE);
      Logger.debug(TAG, `writeData:  index:` + index + ' availableLength: ' + availableLength + ' length: ' + length);
    }
  }

  private bleReceiveDataCallback: Callback<BleReceiveDataResult> = (result: BleReceiveDataResult) => {
    if (result && !StringUtils.isEmpty(result.res)) {

      Logger.debug(TAG, 'bleReceiveDataCallback: result.res ' + JSON.stringify(result.res));

      let authenticationRes: AuthenticationRes = new AuthenticationRes(result.res);
      if (authenticationRes && authenticationRes.isSelf()) {
        switch (authenticationRes.cmd) {
          case Cmd.AUTH_SUCCESS:
            let keyInfoStr = authenticationRes.keyinfo;
            let ketInfoBytes = this.base64Utils.decodeSync(keyInfoStr);

            Logger.debug(TAG, 'ketInfoBytes : ' + keyInfoStr);
            let prikey = platform.getISecretInterface().getRSASecret().getPrivateKeyStr();
            Logger.debug(TAG, 'prikey : ' + prikey);

            platform.getISecretInterface().getRSASecret().decrypt(ketInfoBytes).then((plainData) => {
              let json = ConvertUtils.uint8Array2String(plainData);
              let keyInfo = JSON.parse(json) as KeyInfo;
              Logger.debug(TAG, 'keyInfo: ' + JSON.stringify(keyInfo));
              platform.getISecretInterface()
                .getSM4Secret()
                .setSecretKey(ConvertUtils.string2Uint8Array(keyInfo.key));

              //完成密钥交换后，请求idList
              this.queryIdList();
            });
            break;
          case Cmd.AUTH_FAIL:
            Logger.debug(TAG, 'Cmd.AUTH_FAIL ');
            break;
          case Cmd.DEV_UNACTIVATED:
            Logger.debug(TAG, 'Cmd.DEV_UNACTIVATED ');
            break;
          case Cmd.CONNECTION_NOT_AUTHENTICATED:
            Logger.debug(TAG, 'Cmd.CONNECTION_NOT_AUTHENTICATED ');
            break;
          case Cmd.KEY_NOT_EXCHANGED:
            Logger.debug(TAG, 'Cmd.KEY_NOT_EXCHANGED ');
            break;
          case Cmd.UNENCRYPTED_DATA_REJECTED:
            Logger.debug(TAG, 'Cmd.UNENCRYPTED_DATA_REJECTED ');
            break;
        }
        if (authenticationRes.cmd != Cmd.AUTH_SUCCESS) {
          Logger.debug(TAG, 'authenticationRes.cmd != Cmd.AUTH_SUCCESS ');
        }
        return;
      }

      let controllerIdInfoQueryRes: ControllerIdInfoQueryRes = new ControllerIdInfoQueryRes(result.res);
      if (controllerIdInfoQueryRes && controllerIdInfoQueryRes.isSelf()) {
        if (controllerIdInfoQueryRes.isSuc()) {
          let payloadIdInfo = controllerIdInfoQueryRes.payload;
          if (payloadIdInfo) {
            Logger.debug(TAG, 'convert2CurrentControllerItem: payloadIdInfo ' + JSON.stringify(payloadIdInfo));
            let localId: string = controllerIdInfoQueryRes.localId;
            let localControllerItem = IdInfoConverter.getInstance()
              .convert2CurrentControllerItem(localId, payloadIdInfo);
            Logger.debug(TAG,
              'convert2CurrentControllerItem: localControllerItem ' + JSON.stringify(localControllerItem));
            if (localControllerItem) {
              Logger.debug(TAG, 'saveLocalControllerItem: localControllerItem ' + JSON.stringify(localControllerItem));
              GlobalStore.getInstance().saveLocalControllerItem(localControllerItem);

              //查询设备列表
              this.queryDevInfo(localControllerItem.id);
            }
          }
        }
        return;
      }

      let controllerDevInfoRes: ControllerDevInfoRes = new ControllerDevInfoRes(result.res);
      if (controllerDevInfoRes && controllerDevInfoRes.isSelf()) {
        if (controllerDevInfoRes.isSuc()) {
          let payloadIdInfo: PayloadQueryDev = controllerDevInfoRes.payload as PayloadQueryDev;
          if (payloadIdInfo) {
            const arr: PayloadDevInfo[] = payloadIdInfo.devArray!;
            if (this.onDevFindCallback) {
              for (let i = 0; i < arr.length; i++) {
                this.onDevFindCallback(arr[i]);
              }
            }
          }
        }
        return;
      }
    }
  };

  private authentication() {
    let secretKeyAndSign = GlobalStore.getInstance().getSecretKeyAndSign();
    if (secretKeyAndSign) {
      let signConfig = secretKeyAndSign.signConfig;
      if (signConfig) {
        platform.getIBleInterface().writeAuthentication(JSON.stringify(signConfig));
      }
    }
  }

  private queryIdList() {
    let payload: PayloadIdInfo = new PayloadIdInfo();
    payload.pageIndex = 1;
    let req: ControllerIdInfoQueryReq = new ControllerIdInfoQueryReq();
    req.payload = payload;
    let msg: string = JSON.stringify(req);
    Logger.debug(TAG, 'queryIdList: msg ' + msg);
    platform.getIBleInterface().write(msg);
  }

  private queryDevInfo(localId: string) {
    let payload: PayloadQueryDev = new PayloadQueryDev();
    payload.queryType = 'config';
    payload.pageIndex = 1;
    let req: DevQueryReq = new DevQueryReq(localId);
    req.payload = payload;
    let msg: string = JSON.stringify(req);
    Logger.debug(TAG, 'queryDevInfo: msg ' + msg);
    platform.getIBleInterface().write(msg);
  }

  public invokeCmd(req: ControllerTestReq) {
    platform.getIBleInterface().write(JSON.stringify(req));
  }

  public invokeMsg(json: string) {
    platform.getIBleInterface().write(json);
  }
};
