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

import WifiDevicesConnector from './WifiDevicesConnector';
import WifiDevicesController from './WifiDevicesController';
import { CoapClient, CoapRequestMethod, CoapRequestType, CoapResponseCode, ContentFormat } from '@ohos/coap';
import wifiManager from '@ohos.wifiManager';
import WifiConstants from './constants/WifiConstants';
import {
  analysisPayload,
  buildQueryStateRequest,
  InfControl,
  InfDeviceInfo,
  InfDevicesBusiness,
  InfDeviceState
} from '@ohos/common/Index';
import { InfIpInfo, Logger } from '@ohos/common';

/**
 * wifi业务模块
 */
let BASE_REQ = 0;

function getRandomSeq() {
  if (BASE_REQ == 0) {
    BASE_REQ = Math.floor(Math.random() * Math.pow(2, 32));
  }
  BASE_REQ += 1;
  return BASE_REQ;
}

export default class WifiDeviceBusiness implements InfDevicesBusiness {
  public controller: WifiDevicesController;

  constructor(controller: WifiDevicesController) {
    this.controller = controller;
  }

  async queryDeviceState(sids: string[]): Promise<InfDeviceState[]> {
    let targetIp: string = this.getWifiDeviceIp();
    let coapStartUrl = 'coap://' + targetIp + ':5683/e2eCtrl';
    let plaintext: string = buildQueryStateRequest(getRandomSeq(), sids);
    Logger.info(`${WifiConstants.TAG} queryDeviceState plaintext= ${plaintext}`);
    let coapClient = new CoapClient();
    coapClient.setFormat(ContentFormat.JSON);
    coapClient.setPayload(plaintext);
    let data = await coapClient.request(coapStartUrl, CoapRequestMethod.GET, CoapRequestType.COAP_MESSAGE_CON);

    if (data.code == CoapResponseCode.SUCCESS) {
      let responsePayload: string[] = data.message;
      Logger.info(`${WifiConstants.TAG} queryDeviceState = ${responsePayload[0]}`);
      let result = analysisPayload(responsePayload[0]);
      return Promise.resolve(result);
    } else {
      Logger.error(`${WifiConstants.TAG} queryDeviceState error`);
      return Promise.reject();
    }
  }

  queryDeviceAllServices(): Promise<InfDeviceState[]> {
    throw new Error('Method not implemented.');
  }

  queryDeviceInfo(): Promise<InfDeviceInfo> {
    throw new Error('Method not implemented.');
  }

  queryIpInfo(): Promise<InfIpInfo> {
    throw new Error('Method not implemented.');
  }

  async controlDevice(control: InfControl): Promise<boolean> {
    let dataJson = control.getDataJson();
    let plaintext: string = `{\'seq\': ${getRandomSeq()},\'data\': [${dataJson}]}`;
    Logger.info(`${WifiConstants.TAG} controlDevice plaintext= ${plaintext}`);
    let targetIp: string = this.getWifiDeviceIp();
    let coapStartUrl = 'coap://' + targetIp + ':5683/e2eCtrl';
    let coapClient = new CoapClient();
    coapClient.setFormat(ContentFormat.JSON);
    coapClient.setPayload(plaintext);

    let data = await coapClient.request(coapStartUrl, CoapRequestMethod.POST, CoapRequestType.COAP_MESSAGE_CON);
    if (data.code == CoapResponseCode.SUCCESS) {
      let message = data.message;
      Logger.info(`${WifiConstants.TAG} controlDevice success= ${message[0]}`);
      return true;
    } else {
      Logger.info(`${WifiConstants.TAG} controlDevice error`);
      return false;
    }
  }

  private getWifiDeviceIp(): string {
    let ipInfo = wifiManager.getIpInfo();
    let wifiDeviceIp = ipInfo.gateway;
    return (wifiDeviceIp >>> 24) + '.' + (wifiDeviceIp >> 16 & 0xFF) + '.' + (wifiDeviceIp >> 8 & 0xFF) + '.' +
      (wifiDeviceIp & 0xFF);
  }
};
