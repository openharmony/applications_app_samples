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

import { CoapServer, CoapResource, CoapExchange, CoapResourceCode, CoapClient } from '@ohos/coap';
import connection from '@ohos.net.connection';
import WifiConstants from './constants/WifiConstants';
import { BusinessError, Callback } from '@ohos.base';
import { analysisPayload, InfDeviceState } from '@ohos/common/Index';
import { Logger } from '@ohos/common';

const COAP_SUCCESS = 1;
const COAP_FAILED = 0;
const COAP_SERVER_URL = 'e2eCtrlData';
const COAP_SERVER_PORT = '5683';

export default class CoapServerManager {
  private static instance: CoapServerManager;
  private coapServer: CoapServer | null = null;
  private coapResource: CoapResource | null = null;
  private messageReceivers = new Map<string, Callback<InfDeviceState[]>>();
  private isInit = false;

  static getInstance(): CoapServerManager {
    if (CoapServerManager.instance == null) {
      CoapServerManager.instance = new CoapServerManager();
    }
    return CoapServerManager.instance;
  }

  private async getIp() {
    let ip = '';
    let netHandle = await connection.getDefaultNet();
    let properties = await connection.getConnectionProperties(netHandle);
    if (properties && properties.linkAddresses && properties.linkAddresses.length) {
      let linkAddress = properties.linkAddresses[0];
      ip = linkAddress.address.address;
    }
    Logger.info(`${WifiConstants.TAG} wifi ip == === ${ip}`);
    return ip;
  }

  private init() {
    if (!this.isInit) {
      this.coapServer = new CoapServer();
      this.coapResource = new CoapResource();
      this.isInit = true;
    }
  }

  private dispatchMessage(quesText: string) {
    let result = analysisPayload(quesText);
    if (!result || !result.length) {
      return;
    }
    this.messageReceivers.forEach((callBack) => {
      callBack(result);
    });
  }

  registerMessageReceiver(name: string, callBack: Callback<InfDeviceState[]>) {
    this.messageReceivers.set(name, callBack);
  }

  unRegisterMessageReceiver(name: string) {
    this.messageReceivers.delete(name);
  }

  async startServer(callBack?: Callback<number>) {
    Logger.info(`${WifiConstants.TAG} startServer`);
    if (this.isInit) {
      callBack && callBack(COAP_SUCCESS);
      Logger.warn(`${WifiConstants.TAG} coap server is running`);
      return;
    }
    CoapClient.setNativeLogOpen(true);
    let ip = await this.getIp();
    if (!ip) {
      callBack && callBack(COAP_FAILED);
      Logger.info(`${WifiConstants.TAG} start coap server error, ip is empty`);
      return;
    }
    this.init();
    let exchange = new CoapExchange();
    //服务器本地IP，端口号目前固定
    this.coapServer?.setAddr(ip, COAP_SERVER_PORT);
    let resourceId = this.coapResource?.createResource(COAP_SERVER_URL);
    this.coapResource?.registerPostHandler(resourceId, (responseId: string) => {
      let quesText = exchange.getRequestText(responseId);
      Logger.info(`${WifiConstants.TAG} server coap post question text ${quesText}`);
      exchange.response(responseId, CoapResourceCode.COAP_RESPONSE_CODE_CONTENT, '{\'errcode\':0}');
      this.dispatchMessage(quesText);
    });

    this.coapServer?.addResource(resourceId);
    this.coapServer?.start().then((coapResponse) => {
      Logger.info(`${WifiConstants.TAG} start coap server code == ${coapResponse.code}`);
    }).catch((error: BusinessError) => {
      Logger.error(`${WifiConstants.TAG} start coap server error == ${error.message}`);
    });
    setTimeout(() => {
      // coapServer.start 方法的Promise 暂不回调
      let status = this.coapServer?.getStatus();
      Logger.info(`${WifiConstants.TAG} start coap server status == ${status}`);
      callBack && callBack(status == 1 ? COAP_SUCCESS : COAP_FAILED);
    }, 1000);
  }

  stopServer() {
    this.coapResource?.destroy();
    this.coapServer?.stop();
    this.coapResource = null;
    this.coapServer = null;
    this.isInit = false;
    this.messageReceivers.clear();
  }
};