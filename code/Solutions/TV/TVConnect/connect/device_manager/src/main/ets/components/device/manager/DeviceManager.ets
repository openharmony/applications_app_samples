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
import common from '@ohos.app.ability.common';
import eventManager from '@ohos.commonEventManager';
import promptAction from '@ohos.promptAction';
import { AsyncCallback } from '@ohos.base';
import {
  DeviceStatus,
  EnvManager,
  InfAccessManagerBluetooth,
  InfAccessManagerWifi,
  InfConstants,
  InfDevice,
  InfDeviceInfo,
  InfDevicesBusiness,
  InfDevicesConnector,
  InfDevicesController,
  InfDevicesDiscover,
  InfDeviceState,
  InfIpInfo,
  Logger,
  ScanOptions
} from '@ohos/common';
import { ConnectType, SubProtocolType } from '@ohos/common/src/main/ets/inf/TypeEnum';
import DeviceManagerInterface, {
  ConnectChangeAction,
  ControlOption,
  DeviceManagerCode,
  MessageAction,
  QueryInfoOption,
  QueryOption
} from './DeviceManagerInterface';
import { IotDevicesConnector, IotHelper, NetCfgControl } from '@ohos/connect_iot';
import { WifiDevicesController } from '@ohos/connect_wifi';
import { BleDevicesController } from '@ohos/connect_ble';
import { ChannelInterface } from './ChannelInterface';
import HttpChannel from './HttpChannel';
import HiLinkChannel from './HiLinkChannel';
import { BusinessError } from '@kit.BasicServicesKit';
import { CloudDeviceModel, HttpApi, ServiceData } from '@ohos/connect_cloud';

const TAG = 'DeviceManager';

export default class DeviceManagerFactory {
  private static deviceManager: DeviceManager;

  static createDeviceManager(): void {
    let deviceManager: DeviceManager = new DeviceManager();
    deviceManager.createDeviceManager();
    DeviceManagerFactory.deviceManager = deviceManager;
  }

  static releaseDeviceManager(): void {
    DeviceManagerFactory.deviceManager?.releaseDeviceManager();
  }

  static getDeviceManager(): DeviceManagerInterface {
    if (DeviceManagerFactory.deviceManager == null) {
      throw new Error('DeviceManager not create');
    }
    return DeviceManagerFactory.deviceManager;
  }
};

enum DeviceConnectStatus {
  DEVICE_CONNECT_IDLE = 0,
  DEVICE_CONNECT_RUNNING = 1,
}

class DeviceManager implements DeviceManagerInterface {
  private mContext: common.UIAbilityContext | undefined;
  // 已或者正在连接的设备
  private currentConnectDevice: InfDevice | undefined;
  private controllerMap: Map<SubProtocolType, InfDevicesController> = new Map();
  private messageReceivers = new Map<string, Callback<MessageAction>>();
  private connectStateMap = new Map<string, Callback<ConnectChangeAction>>();
  private projectDevMap = new Map<string, Array<CloudDeviceModel>>();
  private channelMap = new Map<SubProtocolType, ChannelInterface>();
  private bindDeviceReceivers = new Map<string, Callback<string>>();
  private bindDeviceAllSnapshot = new Map<string, Callback<Record<string, ServiceData[] | string>>>();
  private deviceNameChangeReceivers = new Map<string, Callback<Record<string, string>>>();
  private deviceConnectStatus = DeviceConnectStatus.DEVICE_CONNECT_IDLE;
  private subscriber: eventManager.CommonEventSubscriber | undefined = undefined;
  private callEvent: AsyncCallback<eventManager.CommonEventData> = (error, eventData) => {
    // result
    let event = eventData?.event;
    let data = eventData?.data;
    Logger.debug(TAG, `===>EventManager event= ${event} data= ${data}`);
    if (!data) {
      return;
    }
    if (event == `KEY_${InfConstants.ON_CONNECT_STATE_CHANGED}`) {
      let record: Record<string, number | string> = JSON.parse(data);
      let newStatus = record && record[InfConstants.ON_CONNECT_STATE_CHANGED_TYPE];
      let unionCode = record && record[InfConstants.UNION_CODE_TYPE] || '';
      let deviceId = record && record[InfConstants.DEVICE_ID_TYPE] || '';
      Logger.debug(TAG, `EventManager newStatus= ${newStatus}`);
      this.dispatchConnectChangeAction({
        action: newStatus as ConnectType,
        unionCode: unionCode as string,
        deviceId: deviceId as string
      } as ConnectChangeAction);
    } else if (event == `KEY_${InfConstants.ON_DEVICE_DATA_CHANGED}`) {
      let deviceStatus: DeviceStatus = JSON.parse(data);
      Logger.debug(TAG, `===>EventManager deviceStatus= ${JSON.stringify(deviceStatus)}`);
      this.dispatchMessage({
        message: deviceStatus.services,
        unionCode: deviceStatus.unionCode || '',
        deviceId: deviceStatus.devId || ''
      } as MessageAction);
    } else if (event == `KEY_${InfConstants.ON_BIND_DEVICE}`) {
      Logger.info(TAG, `===>eventtype ON_BIND_DEVICE res =   ${JSON.stringify(data)}`);
      let msg: Record<string, number | string> = JSON.parse(data);
      let projectId: string = msg['projectId'] as string;
      if (projectId) {
        HttpApi.getInstance().getAllDevices(projectId).then(arr => {
          this.projectDevMap.set(projectId, arr.devices);
          this.dispatchBindDeviceChangeAction(projectId);
        }).catch((err: BusinessError) => {
          Logger.error(TAG, `getAllDevices error ${JSON.stringify(err)}`);
        });
      }
    } else if (event == `KEY_${InfConstants.ON_DEVICE_DELETE}`) {
      Logger.info(TAG, `eventtype ON_DEVICE_DELETE res =   ${JSON.stringify(data)}`);
      let msg: Record<string, number | string> = JSON.parse(data);
      let devId: string = msg['devId'] as string;
      if (devId) {
        this.projectDevMap.forEach((value: CloudDeviceModel[], key: string) => {
          let index = value.findIndex(item => item.deviceId == devId);
          if (index != -1) {
            value = value.filter(item => item.deviceId != devId);
            this.projectDevMap.set(key, value);
            this.dispatchBindDeviceChangeAction(key);
          }
        });
      }
    } else if (event == `KEY_${InfConstants.ON_DEVICE_ALL_SNAPSHOT}`) {
      Logger.info(TAG, `eventtype ON_DEVICE_ALL_SNAPSHOT res =   ${JSON.stringify(data)}`);
      let msg: Record<string, ServiceData[] | string> = JSON.parse(data);
      this.dispatchSnapshotChangeAction(msg);
    }
  };

  private getControllerByProtocolType(type?: SubProtocolType): InfDevicesController | undefined {
    if (!type) {
      return undefined;
    }
    return this.controllerMap.get(type);
  }

  private getDevicesConnector(device: InfDevice): InfDevicesConnector | undefined {
    Logger.debug(TAG,
      `getDevicesConnector device= ${JSON.stringify(device)}, device.getSubProtocolType() = ${device.getSubProtocolType()}`);
    const controller = this.getControllerByProtocolType(device.getSubProtocolType());
    return controller?.getConnector();
  }

  private getControllers(): Array<InfDevicesController> {
    let array: InfDevicesController[] = [];
    this.controllerMap.forEach((value: InfDevicesController, key) => {
      array.push(value);
    });
    return array;
  }

  /**
   * 注册消息通知，由DevicesManager负责分发
   * 在APP EntryAbility onCreate 生命周期注册
   */
  private subscribeEvent() {
    let info: eventManager.CommonEventSubscribeInfo = {
      events: [`KEY_${InfConstants.ON_CONNECT_STATE_CHANGED}`, `KEY_${InfConstants.ON_DEVICE_DATA_CHANGED}`,
        `KEY_${InfConstants.ON_DEVICE_DELETE}`, `KEY_${InfConstants.ON_BIND_DEVICE}`,
        `KEY_${InfConstants.ON_DEVICE_ALL_SNAPSHOT}`]
    };
    eventManager.createSubscriber(info).then((subscriber) => {
      this.subscriber = subscriber;
      eventManager.subscribe(this.subscriber, this.callEvent);
    });
  }

  private unSubscribeEvent() {
    if (this.subscriber != undefined) {
      eventManager.unsubscribe(this.subscriber);
      this.subscriber = undefined;
    }
  }

  private initChannelMap() {
    this.channelMap.set(SubProtocolType.iot_connect, new HiLinkChannel());
    this.channelMap.set(SubProtocolType.cloud, new HttpChannel());
  }

  private findChannelInterface(option: QueryOption | ControlOption | QueryInfoOption): ChannelInterface {
    Logger.info(TAG,
      `===>findChannelInterface option: ${JSON.stringify(option)},option.protocolType: ${option.protocolType}`);
    let protocolType = option.protocolType;
    if (protocolType == undefined) {
      // 自动寻管道逻辑
      if (this.currentConnectDevice != undefined &&
        this.currentConnectDevice.getUnionCode() == option.unionCode) {
        protocolType = this.currentConnectDevice.getSubProtocolType();
        Logger.info(TAG,
          `===>findChannelInterface, protocolType: ${protocolType}, getDeviceName: ${this.currentConnectDevice.getDeviceName()}， getProductID：${this.currentConnectDevice.getProductID()}`);
      }
    }
    if (protocolType == undefined) {
      Logger.warn(TAG, `===>protocolType == undefined --> protocolType = SubProtocolType.cloud`);
      protocolType = SubProtocolType.cloud;
    }
    let channel = this.channelMap.get(protocolType);
    if (channel == undefined) {
      throw new Error('channel is undefined');
    }
    return channel;
  }

  createDeviceManager(): void {
    EnvManager.getInstance().registerAccessManager(new InfAccessManagerBluetooth());
    EnvManager.getInstance().registerAccessManager(new InfAccessManagerWifi());
    let iot = true;
    Logger.warn(TAG, `===>createDeviceManager, iot=${iot}`);
    if (iot) {
      this.registerController(new IotDevicesConnector());
    } else {
      this.registerController(new WifiDevicesController());
      this.registerController(new BleDevicesController());
    }
    this.subscribeEvent();
    // 初始化管道
    this.initChannelMap();
  }

  bindLifeSvc(context: common.UIAbilityContext): void {
    IotHelper.getInstance().init(context);
  }

  releaseDeviceManager(): void {
    this.unSubscribeEvent();
  }

  startDeviceDiscover(options: ScanOptions | null = null, callback?: AsyncCallback<InfDevice, void>): void {
    let array: InfDevicesController[] = this.getControllers();
    Logger.debug(TAG, `startDeviceDiscover, ${array.length}`);
    for (let i = 0; i < array.length; i++) {
      let controller: InfDevicesController = array[i];
      const discover: InfDevicesDiscover = controller.getDiscover();
      if (discover.isScanEnable()) {
        controller.getDiscover().startScan(options, (device: InfDevice) => {
          if (callback) {
            Logger.debug(TAG, `startDeviceDiscover callback`);
            callback(undefined, device);
          }
        });
      }
    }
    setTimeout(() => {
      this.stopDeviceDiscovery(options);
    }, 20 * 1000);
  }

  stopDeviceDiscovery(options: ScanOptions | null = null): void {
    let array: InfDevicesController[] = this.getControllers();
    for (let i = 0; i < array.length; i++) {
      let controller: InfDevicesController = array[i];
      if (options != null && options.filterOption.includes(controller.getSubProtocolType())) {
        continue;
      }
      controller.getDiscover().stopScan();
    }
  }

  async connectDevice(device: InfDevice, callBack: AsyncCallback<ConnectType>) {
    if (this.deviceConnectStatus == DeviceConnectStatus.DEVICE_CONNECT_RUNNING) {
      Logger.warn(TAG, `other devices are currently connecting`);
      promptAction.showToast({
        message: $r('app.string.other_devices_connecting'),
        duration: 2000
      });
      let error: BusinessError = {
        name: 'BusinessError',
        code: DeviceManagerCode.DEVICE_CONNECT_RUNNING,
        message: 'other devices are currently connecting'
      };
      callBack(error, undefined);
      return;
    }
    const connector = this.getDevicesConnector(device);
    if (connector == undefined) {
      let error: BusinessError = {
        name: 'BusinessError',
        code: DeviceManagerCode.DEVICE_CONNECT_FAILED,
        message: 'device connector is undefined'
      };
      callBack(error, undefined);
      return;
    }
    this.deviceConnectStatus = DeviceConnectStatus.DEVICE_CONNECT_RUNNING; // 0
    if (this.currentConnectDevice != undefined) {
      const currentConnector = this.getDevicesConnector(this.currentConnectDevice);
      await currentConnector?.stopConnect(this.currentConnectDevice);
      // 分发主动断连的消息
      let action: ConnectChangeAction = {
        action: ConnectType.DISCONNECT,
        unionCode: this.currentConnectDevice.getUnionCode(),
        deviceId: ''
      };
      this.dispatchConnectChangeAction(action);
      this.currentConnectDevice = undefined;
      Logger.debug(TAG, `device= ${device.getUnionCode()} disconnect`);
    }
    this.currentConnectDevice = device;
    let isSuccess = false;
    try {
      callBack(undefined, ConnectType.CONNECTING);
      const result = await connector.connect(device);
      Logger.debug(TAG, `device= ${device.getUnionCode()} connect result: ${result}`);
      isSuccess = result;
      if (result) {
        callBack(undefined, ConnectType.ONLINE);
      } else {
        let error: BusinessError = {
          name: 'BusinessError',
          code: DeviceManagerCode.DEVICE_CONNECT_FAILED,
          message: 'connect device failed'
        };
        callBack(error, undefined);
      }
    } catch (err) {
      Logger.error(TAG, `connectDevice error ${err.message}`);
      let error: BusinessError = {
        name: 'BusinessError',
        code: DeviceManagerCode.DEVICE_CONNECT_FAILED,
        message: 'connect device failed'
      };
      callBack(error, undefined);
    } finally {
      if (!isSuccess) {
        this.currentConnectDevice = undefined;
        promptAction.showToast({
          message: $r('app.string.connect_failed_tip'),
          duration: 2000
        });
      }
      this.deviceConnectStatus = DeviceConnectStatus.DEVICE_CONNECT_IDLE;
    }
  }

  getCloudDevice(projectId: string): Promise<CloudDeviceModel[]> {
    Logger.debug(TAG, `getCloudDevice projectId= ${projectId}`);
    return new Promise((resolve, reject) => {
      HttpApi.getInstance().getAllDevices(projectId).then(arr => {
        this.projectDevMap.set(projectId, arr.devices);
        resolve(arr.devices);
      }).catch((err: BusinessError) => {
        reject(err);
      });
    });
  }

  configureNetwork(netCfgRecord: Record<string, string>): Promise<boolean> {
    Logger.debug(TAG, `===>configureNetwork netCfgRecord ${JSON.stringify(netCfgRecord)}`);
    if (this.currentConnectDevice == undefined) {
      return Promise.reject('new connect device');
    }
    let subProtocolType = this.currentConnectDevice.getSubProtocolType();
    Logger.debug(TAG, `===>configureNetwork getSubProtocolType ${subProtocolType}`);
    if (subProtocolType != SubProtocolType.iot_connect) {
      return Promise.reject('device protocol not match');
    }
    let devicesBusiness = this.getDevicesBusiness(subProtocolType);
    if (devicesBusiness == undefined) {
      return Promise.reject('device business is undefined');
    }
    let netCfgControl = new NetCfgControl(netCfgRecord);
    return devicesBusiness.controlDevice(netCfgControl);
  }

  // 开关 控制设备
  controlDevice(option: ControlOption): Promise<boolean> {
    Logger.debug(TAG, `===>controlDevice option ${JSON.stringify(option)}`);
    let channel = this.findChannelInterface(option);
    if (channel == undefined) {
      return Promise.reject('ChannelInterface is undefined');
    }
    return channel.controlDevice(option);
  }

  queryDeviceInfo(option: QueryInfoOption): Promise<InfDeviceInfo> {
    let channel = this.findChannelInterface(option);
    if (channel == undefined) {
      return Promise.reject('ChannelInterface is undefined');
    }
    return channel.queryDeviceInfo(option);
  }

  queryIpInfo(option: QueryInfoOption): Promise<InfIpInfo> {
    let channel = this.findChannelInterface(option);
    if (channel == undefined) {
      return Promise.reject('ChannelInterface is undefined');
    }
    return channel.queryIpInfo(option);
  }

  queryDeviceState(option: QueryOption): Promise<InfDeviceState[]> {
    Logger.debug(TAG, `===>queryDeviceState option ${JSON.stringify(option)}`);
    let channel = this.findChannelInterface(option);
    if (channel == undefined) {
      return Promise.reject('ChannelInterface is undefined');
    }
    return channel.queryDeviceState(option);
  }

  queryDeviceAllServices(option: QueryOption): Promise<InfDeviceState[]> {
    let channel = this.findChannelInterface(option);
    if (channel == undefined) {
      return Promise.reject('ChannelInterface is undefined');
    }
    return channel.queryDeviceAllServices(option);
  }

  isConnecting(): boolean {
    return this.deviceConnectStatus == DeviceConnectStatus.DEVICE_CONNECT_RUNNING;
  }

  getDevicesBusiness(protocolType?: SubProtocolType): InfDevicesBusiness | undefined {
    Logger.debug(TAG, `getDevicesBusiness getDevicesBusiness protocolType ${protocolType}`);
    return this.getControllerByProtocolType(protocolType)?.getDevicesBusiness();
  }

  disconnect(): void {
    if (this.currentConnectDevice == undefined) {
      return;
    }
    const connector = this.getDevicesConnector(this.currentConnectDevice);
    if (connector == undefined) {
      return;
    }
    connector.stopConnect(this.currentConnectDevice);
    this.currentConnectDevice = undefined;
  }

  private dispatchConnectChangeAction(action: ConnectChangeAction) {
    this.connectStateMap.forEach((func) => func(action));
  }

  private dispatchMessage(action: MessageAction) {
    this.messageReceivers.forEach((func) => func(action));
  }

  registerConnectStateChanged(name: string, callBack: Callback<ConnectChangeAction>): void {
    Logger.warn(TAG, `===>registerConnectStateChanged, type name=${name}`);
    if (name.length > 0) {
      this.connectStateMap.set(name, callBack);
    }
  }

  unRegisterConnectStateChanged(name: string): void {
    this.connectStateMap.delete(name);
  }

  registerMessageReceivers(name: string, callBack: Callback<MessageAction>): void { //DeviceDetailDialog中有调用
    Logger.warn(TAG, `===>registerMessageReceivers, type name=${name}`);
    if (name.length > 0) {
      this.messageReceivers.set(name, callBack);
    }
  }

  unRegisterMessageReceivers(name: string): void {
    this.messageReceivers.delete(name);
  }

  registerController(controller: InfDevicesController) {
    Logger.warn(TAG, `===>registerController, controller.getSubProtocolType=${controller.getSubProtocolType()}`);
    this.controllerMap.set(controller.getSubProtocolType(), controller);
  }

  registerDeviceBindChanged(name: string, callBack: Callback<string>): void {
    if (name.length > 0) {
      this.bindDeviceReceivers.set(name, callBack);
    }
  }

  unregisterDeviceBindChanged(name: string) {
    this.bindDeviceReceivers.delete(name);
  }

  private dispatchBindDeviceChangeAction(projectId: string) {
    this.bindDeviceReceivers.forEach((func) => func(projectId));
  }

  registerDeviceAllSnapshot(name: string, callBack: Callback<Record<string, ServiceData[] | string>>): void {
    if (name.length > 0) {
      this.bindDeviceAllSnapshot.set(name, callBack);
    }
  }

  private dispatchSnapshotChangeAction(data: Record<string, ServiceData[] | string>) {
    this.bindDeviceAllSnapshot.forEach((func) => func(data));
  }

  unregisterDeviceAllSnapshotChanged(name: string) {
    this.bindDeviceAllSnapshot.delete(name);
  }

  modifyDeviceName(proId: string, devId: string, name: string) {
    let res = this.projectDevMap.get(proId);
    if (!res) {
      return;
    }
    let devInfo: Record<string, string> = {};
    devInfo['projectId'] = proId;
    devInfo['deviceId'] = devId;
    devInfo['name'] = name;
    res.find(item => (item.deviceId == devId) && (item.name = name) && this.dispatchNameChangeAction(devInfo));
  }

  registerDeviceInfoChange(name: string, callBack: Callback<Record<string, string>>): void {
    if (name.length > 0) {
      this.deviceNameChangeReceivers.set(name, callBack);
    }
  }

  private dispatchNameChangeAction(data: Record<string, string>) {
    this.deviceNameChangeReceivers.forEach((func) => func(data));
  }

  unregisterDeviceInfoChange(name: string) {
    this.deviceNameChangeReceivers.delete(name);
  }
}