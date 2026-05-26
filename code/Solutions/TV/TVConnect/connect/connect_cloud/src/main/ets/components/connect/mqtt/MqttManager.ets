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
import { Logger, NetManager, NetObserver, PreferencesHelper, UserLibraryDao } from '@ohos/common';
import fs from '@ohos.file.fs';
import {
  MqttAsync,
  MqttClient,
  MqttClientOptions,
  MqttConnectOptions,
  MqttPublishOptions,
  MqttSubscribeOptions,
} from '@ohos/mqtt';
import CloudConstants from '../CloudConstants';
import MqttMessageDispatcher from './MqttMessageDispatcher';
import MqttAction from './MqttAction';

enum MqttLinkStatus {
  MQTT_LINK_IDLE = 0,
  MQTT_LINK_RUNNING = 1,
}

export default class MqttManager {
  private mqttClient: MqttClient | undefined = undefined;
  private static instance: MqttManager;
  private mqttLinkStatus = MqttLinkStatus.MQTT_LINK_IDLE;
  private startTime = 0;
  private messageDispatcher: MqttMessageDispatcher = new MqttMessageDispatcher();
  private netObserver: NetObserver = {
    onNetInvalid: (): void => {
      Logger.debug(CloudConstants.CLOUD_TAG, `onNetInvalid`);
    },
    onNetValidated: (): void => {
      Logger.debug(CloudConstants.CLOUD_TAG, `onNetValidated`);
    },
    onNetAvailable: (): void => {
      Logger.debug(CloudConstants.CLOUD_TAG, `onNetAvailable`);
      this.messageDispatcher?.dispatch(MqttAction.TOPIC_NET_CHANGED, '');
    },
    onNetLost: (): void => {
      Logger.debug(CloudConstants.CLOUD_TAG, `onNetLost`);
    }
  };

  private constructor() {
    this.initNetObserver();
  }

  static getInstance(): MqttManager {
    if (MqttManager.instance == null) {
      MqttManager.instance = new MqttManager();
    }
    return MqttManager.instance;
  }

  private initNetObserver() {
    NetManager.getInstance().registerNetObserver(this.netObserver);
  }

  private async initMqtt(): Promise<number> {
    if (this.mqttClient != undefined) {
      let isConnected = await this.isConnected();
      if (isConnected) {
        await this.mqttClient.disconnect();
      }
    }
    let url = UserLibraryDao.getUserMqttUrl();
    if (this.isStringEmpty(url)) {
      Logger.warn(CloudConstants.CLOUD_TAG, `mqtt url is empty`);
      return CloudConstants.COMMON_PARAMETER_INVALID;
    }
    let clientId = UserLibraryDao.getUserClientId();
    if (this.isStringEmpty(clientId)) {
      Logger.warn(CloudConstants.CLOUD_TAG, `mqtt clientId is empty`);
      return CloudConstants.COMMON_PARAMETER_INVALID;
    }
    let option: MqttClientOptions = {
      url: url,
      clientId: clientId,
      persistenceType: 1,
    };
    this.mqttClient = MqttAsync.createMqtt(option);
    if (this.mqttClient == undefined) {
      return CloudConstants.COMMON_FAILED;
    }
    this.messageArrived();
    this.connectLost();
    return CloudConstants.COMMON_SUCCESS;
  }

  private messageArrived() {
    this.mqttClient?.messageArrived((error, data) => {
      if (error != undefined) {
        Logger.error(CloudConstants.CLOUD_TAG, `messageArrived error ${JSON.stringify(error)}`);
      }
      Logger.debug(CloudConstants.CLOUD_TAG, `messageArrived data ${JSON.stringify(data)}`);
      this.messageDispatcher?.dispatch(MqttAction.TOPIC_DATA_RECEIVE, data.payload);
    });
  }

  private connectLost() {
    this.mqttClient?.connectLost((error, data) => {
      Logger.warn(CloudConstants.CLOUD_TAG, `connectLost data ${JSON.stringify(data)}`);
      this.messageDispatcher?.dispatch(MqttAction.TOPIC_LOGIN_CONNECT_LOST, '');
    });
  }

  private async connectMqtt(): Promise<number> {
    if (this.mqttClient == undefined) {
      Logger.error(CloudConstants.CLOUD_TAG, `connectMqtt mqttClient is undefined`);
      return CloudConstants.COMMON_FAILED;
    }
    let mqttUserName = UserLibraryDao.getMqttUserName();
    if (this.isStringEmpty(mqttUserName)) {
      Logger.warn(CloudConstants.CLOUD_TAG, `mqtt mqtt userName is empty`);
      return CloudConstants.COMMON_PARAMETER_INVALID;
    }
    let mqttPassword = UserLibraryDao.getMqttPassword();
    if (this.isStringEmpty(mqttPassword)) {
      Logger.warn(CloudConstants.CLOUD_TAG, `mqtt mqtt password is empty`);
      return CloudConstants.COMMON_PARAMETER_INVALID;
    }
    let option: MqttConnectOptions = {
      userName: mqttUserName,
      password: mqttPassword,
    };
    try {
      let mqttResponse = await this.mqttClient.connect(option);
      Logger.debug(CloudConstants.CLOUD_TAG, `connectMqtt result ${JSON.stringify(mqttResponse)}`);
      if (mqttResponse.code == CloudConstants.COMMON_SUCCESS) {
        let topic = this.formatTopic();
        this.subscribeTopic(topic);
        this.messageDispatcher?.dispatch(MqttAction.TOPIC_LOGIN_CONNECT, '');
        return CloudConstants.COMMON_SUCCESS;
      } else {
        this.messageDispatcher?.dispatch(MqttAction.TOPIC_LOGIN_CONNECT_FAILED, '');
        return CloudConstants.COMMON_FAILED;
      }
    } catch (e) {
      Logger.error(CloudConstants.CLOUD_TAG, `connectMqtt error message= ${e?.message} code= ${e?.code}`);
      return CloudConstants.COMMON_FAILED;
    }
  }

  private async copyCert() {
    let hsaStore = await PreferencesHelper.get(CloudConstants.MQTT_CER_PATH, false);
    if (hsaStore) {
      return;
    }
    let file: fs.File | undefined = undefined;
    try {
      let unit = await getContext().resourceManager.getRawFileContent(CloudConstants.MQTT_CER_PATH);
      let storePath = `${getContext().filesDir}/${CloudConstants.MQTT_CER_PATH}`;
      file = fs.openSync(storePath, fs.OpenMode.READ_WRITE | fs.OpenMode.CREATE);
      Logger.info(CloudConstants.CLOUD_TAG, `cropCert fd: ${file.fd}`);
      let len = fs.writeSync(file.fd, unit.buffer);
      Logger.info(CloudConstants.CLOUD_TAG, `cropCert buffer len: ${len}`);
      await PreferencesHelper.put(CloudConstants.MQTT_CER_PATH, true);
    } finally {
      if (file != undefined) {
        fs.close(file.fd);
      }
    }
  }

  private formatTopic() {
    let userAccount = UserLibraryDao.getUserAccount();
    let topic = `/user/${userAccount}/signaltrans/${CloudConstants.MQTT_CLOUD_VERSION}/categories/data`;
    return topic;
  }

  public async connect(): Promise<number> {
    Logger.info(CloudConstants.CLOUD_TAG, `connect mqtt call`);
    if (this.mqttLinkStatus == MqttLinkStatus.MQTT_LINK_RUNNING) {
      Logger.error(CloudConstants.CLOUD_TAG, `connectMqtt is running`);
      return CloudConstants.COMMON_FAILED;
    }
    this.startTime = new Date().getTime();
    this.mqttLinkStatus = MqttLinkStatus.MQTT_LINK_RUNNING;
    let isLogin = UserLibraryDao.getIsLogin();
    if (!isLogin) {
      Logger.warn(CloudConstants.CLOUD_TAG, `app is not login`);
      this.mqttLinkStatus = MqttLinkStatus.MQTT_LINK_IDLE;
      this.startTime = 0;
      return CloudConstants.COMMON_PARAMETER_INVALID;
    }
    let hasConnection = NetManager.hasNetConnection();
    if (!hasConnection) {
      Logger.error(CloudConstants.CLOUD_TAG, `network is not connected`);
      this.mqttLinkStatus = MqttLinkStatus.MQTT_LINK_IDLE;
      this.startTime = 0;
      return CloudConstants.COMMON_FAILED;
    }
    let resultCode = await this.initMqtt();
    if (resultCode != CloudConstants.COMMON_SUCCESS) {
      Logger.error(CloudConstants.CLOUD_TAG, `mqtt init failed`);
      this.mqttLinkStatus = MqttLinkStatus.MQTT_LINK_IDLE;
      this.startTime = 0;
      return resultCode;
    }
    let connectResult = await this.connectMqtt();
    Logger.info(CloudConstants.CLOUD_TAG, `connect mqtt result: ${connectResult}`);
    let time = new Date().getTime() - this.startTime;
    Logger.info(CloudConstants.CLOUD_TAG, `connect mqtt time: ${time}ms`);
    this.startTime = 0;
    if (connectResult == CloudConstants.COMMON_SUCCESS) {
      this.mqttLinkStatus = MqttLinkStatus.MQTT_LINK_IDLE;
      return CloudConstants.COMMON_SUCCESS;
    }
    this.mqttLinkStatus = MqttLinkStatus.MQTT_LINK_IDLE;
    return connectResult;
  }

  public async isConnected(): Promise<boolean> {
    if (this.mqttClient == undefined) {
      return false;
    }
    return this.mqttClient.isConnected();
  }

  public async disconnect() {
    try {
      let topic = this.formatTopic();
      await this.unsubscribeTopic(topic);

      let res = await this.mqttClient?.disconnect();
      Logger.debug(CloudConstants.CLOUD_TAG, `disconnectMqtt result ${JSON.stringify(res)}`);
      await this.mqttClient?.destroy();
      this.mqttClient = undefined;
      this.messageDispatcher?.dispatch(MqttAction.TOPIC_LOGIN_DISCONNECT, '');
    } catch (e) {
      Logger.error(CloudConstants.CLOUD_TAG, `disconnectMqtt error ${e.message}`);
    }
  }

  public async publishTopic(topic: string, payload?: string) {
    try {
      // qos 消息质量，0表示最多一次传递，1表示至少一次传递，2表示只有一次传递
      let option: MqttPublishOptions = {
        topic: topic,
        qos: CloudConstants.MQTT_QOS,
        payload: payload,
      };
      let res = await this.mqttClient?.publish(option);
      Logger.debug(CloudConstants.CLOUD_TAG, `publishTopic result ${JSON.stringify(res)}`);
    } catch (e) {
      Logger.error(CloudConstants.CLOUD_TAG, `publishTopic error ${e.message}`);
    }
  }

  private async subscribeTopic(topic: string) {
    try {
      // qos 消息质量，0表示最多一次传递，1表示至少一次传递，2表示只有一次传递
      let option: MqttSubscribeOptions = {
        topic: topic,
        qos: CloudConstants.MQTT_QOS,
      };
      let res = await this.mqttClient?.subscribe(option);
      Logger.debug(CloudConstants.CLOUD_TAG, `subscribeTopic result ${JSON.stringify(res)}`);
    } catch (e) {
      Logger.error(CloudConstants.CLOUD_TAG, `subscribeTopic error ${e.message}`);
    }
  }

  private async unsubscribeTopic(topic: string) {
    try {
      let option: MqttSubscribeOptions = {
        topic: topic,
        qos: CloudConstants.MQTT_QOS,
      };
      let res = await this.mqttClient?.unsubscribe(option);
      Logger.debug(CloudConstants.CLOUD_TAG, `unsubscribeTopic result ${JSON.stringify(res)}`);
    } catch (e) {
      Logger.error(CloudConstants.CLOUD_TAG, `unsubscribeTopic error ${e.message}`);
    }
  }

  private isStringEmpty(str?: string): boolean {
    return str == undefined || str.length == 0;
  }
};