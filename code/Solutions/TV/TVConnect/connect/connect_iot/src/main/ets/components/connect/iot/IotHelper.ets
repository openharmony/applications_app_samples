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
import {
  analysisPayload,
  DeviceLibraryAccess,
  DeviceStatus,
  InfConstants,
  InfControl,
  InfDeviceState,
  Logger,
  Device,
  InfDeviceInfo,
  InfIpInfo,
  ScanOptions,
  ScanProtocol
} from '@ohos/common';
import IotDevice from './IotDevice';
import { AsyncCallback, BusinessError } from '@ohos.base';
import { DeviceManager } from 'iotmanagementkit';
import Timers from './Timers';
import HeartbeatTask from './HeartbeatTask';
import IotConstants from './IotConstants';
import RetryTask from './RetryTask';
import commonEventManager from '@ohos.commonEventManager';
import { common } from '@kit.AbilityKit';
import { ConnectType } from '@ohos/common/src/main/ets/inf/TypeEnum';
import { NetCfgControl } from './ConfigureNetwork';
import { SessionSubscriber } from './SessionSubscriber';

export default class IotHelper {
  private static instance: IotHelper;
  private isInit = false;
  private connectSessionMap: Map<string, DeviceManager.ConnectSession> = new Map();
  private connectDeviceList: IotDevice[] = [];
  private deviceStateTimers: Map<string, Timers<InfDeviceState[]>> = new Map();
  private heartbeatTask: HeartbeatTask | undefined = undefined;
  private sessionSubscriber: SessionSubscriber | undefined = undefined;

  static getInstance(): IotHelper {
    if (IotHelper.instance == null) {
      IotHelper.instance = new IotHelper();
    }
    return IotHelper.instance;
  }

  private addConnectSession(udid: string, connectSession?: DeviceManager.ConnectSession) {
    if (connectSession != undefined) {
      this.connectSessionMap.set(udid, connectSession);
    }
  }

  private getConnectSession(udid?: string) {
    if (udid == undefined) {
      return undefined;
    }
    return this.connectSessionMap.get(udid);
  }

  private deleteConnectSession(udid?: string) {
    if (udid == undefined) {
      return;
    }
    this.connectSessionMap.delete(udid);
  }

  private addConnectDevice(iotDevice: IotDevice) {
    this.connectDeviceList.push(iotDevice);
  }

  private deleteConnectDevice(iotDevice?: IotDevice) {
    if (iotDevice == undefined) {
      return;
    }
    this.connectDeviceList =
      this.connectDeviceList.filter((device) => device.getUnionCode() != iotDevice.getUnionCode());
  }

  private dispatchSubscribeEventData(sidKeys: string, resultArray: InfDeviceState[]) {
    Logger.info(IotConstants.IOT_TAG, `===>dispatchSubscribeEventData sidKeys: ${sidKeys}`);
    let timers = this.deviceStateTimers.get(sidKeys);
    timers?.executeSuccess(resultArray);
    this.deviceStateTimers.delete(sidKeys);
  }

  private subscribeEvent(udid: string, connectSession?: DeviceManager.ConnectSession) {
    Logger.info(IotConstants.IOT_TAG, `===>subscribeEvent udid: ${udid}`);
    this.sessionSubscriber = new SessionSubscriber((eventName: string, eventData: object) => {
      Logger.info(IotConstants.IOT_TAG, `subscribeEvent name: ${eventName}`);
      Logger.info(IotConstants.IOT_TAG, `subscribeEvent data: ${eventData['data']}`);
      if (eventName == InfConstants.ON_DEVICE_DATA_CHANGED) {
        let resultArray = analysisPayload(eventData['data'] as string);
        Logger.info(IotConstants.IOT_TAG, `===>subscribeEvent resultArray: ${JSON.stringify(resultArray)}`);
        if (resultArray != undefined && resultArray.length > 0 && resultArray[0].sid == InfConstants.SN_SERVICES) {
          this.dispatchSubscribeEventData(InfConstants.SN_SERVICES, resultArray);
          return;
        }
        if (this.deviceStateTimers.has(InfConstants.SID_ALL_SERVICES)) {
          this.dispatchSubscribeEventData(InfConstants.SID_ALL_SERVICES, resultArray);
        } else {
          let sidKeys = resultArray.map((item) => item.sid).join('-');
          this.dispatchSubscribeEventData(sidKeys, resultArray);
        }
        let deviceStatus: DeviceStatus = {
          unionCode: this.getConnectDevice()?.getUnionCode(),
          services: resultArray
        };
        let option: commonEventManager.CommonEventPublishData = {
          data: JSON.stringify(deviceStatus)
        };
        commonEventManager.publish(`KEY_${InfConstants.ON_DEVICE_DATA_CHANGED}`, option, () => {
          Logger.info(IotConstants.IOT_TAG,
            `commonEventManager.publish: KEY_${InfConstants.ON_DEVICE_DATA_CHANGED}: success`);
        });
      } else if (eventName == InfConstants.ON_CONNECT_STATE_CHANGED) {
        let status: Record<string, number | string> = JSON.parse(eventData['data']);
        let newStatus =
          status && status[InfConstants.ON_CONNECT_STATE_CHANGED_TYPE];
        Logger.info(IotConstants.IOT_TAG, `subscribeEvent newStatus: ${newStatus}`);
        status[InfConstants.UNION_CODE_TYPE] = this.getConnectDevice()?.getUnionCode() || '';
        if (newStatus == ConnectType.OFFLINE) {
          this.stopConnect(this.getConnectDevice());
        }
        let option: commonEventManager.CommonEventPublishData = {
          data: JSON.stringify(status)
        };
        commonEventManager.publish(`KEY_${InfConstants.ON_CONNECT_STATE_CHANGED}`, option, () => {
          Logger.info(IotConstants.IOT_TAG,
            `commonEventManager.publish: KEY_${InfConstants.ON_CONNECT_STATE_CHANGED}: success`);
        });
      }
    });
    connectSession?.subscribeEvent(this.sessionSubscriber);
  }

  private unSubscribeEvent(connectSession?: DeviceManager.ConnectSession) {
    connectSession?.unsubscribeEvent(this.sessionSubscriber);
    this.sessionSubscriber = undefined;
  }

  public init(connect: common.UIAbilityContext) {
    DeviceManager.initDevice(connect);
    this.isInit = true;
  }

  public async deviceDiscovery(options: ScanOptions | null, callBack: AsyncCallback<IotDevice, string>) {
    Logger.debug(IotConstants.IOT_TAG, `===>IotHelper deviceDiscovery call: ${this.isInit}`);
    if (!this.isInit) {
      callBack(this.getInitError(), null);
      return;
    }
    let duration = IotConstants.SCAN_DURATION;
    let request: DeviceManager.ScanRequest = new DeviceManager.ScanRequest();
    request.duration = duration;
    let scanType: number;
    if (options?.filterOption?.length) {
      scanType = options.filterOption.reduce((acc, item) => acc | item, 0);
    } else {
      scanType = DeviceManager.ScanProtocol.WIFI | DeviceManager.ScanProtocol.BLE;
    }
    request.scanType = scanType;
    Logger.debug(IotConstants.IOT_TAG, `===>request.scanType: ${request.scanType}`);
    DeviceManager.startScanDevice(request, (error, data) => {
      Logger.debug(IotConstants.IOT_TAG, 'deviceDiscovery has result');
      if (error != undefined) {
        Logger.error(IotConstants.IOT_TAG, `deviceDiscovery code= ${error.code} message= ${error.message}`);
        return;
      }
      let scanResponse = data as DeviceManager.ScanResponse;
      scanResponse.scanResult.forEach(async (info) => {
        Logger.info(IotConstants.IOT_TAG, `===>info ${JSON.stringify(info)}`);
        Logger.debug(IotConstants.IOT_TAG, `device prodId= ${info.prodId} protocol=${info.scannedProtocol}`);
        let iotDevice: IotDevice = new IotDevice(info, new Device());
        callBack(undefined, iotDevice);
      });
    });
  }

  public connectDevice(iotDevice: IotDevice): Promise<boolean> {
    Logger.debug(IotConstants.IOT_TAG, `===>IotHelper connectDevice call udid =${iotDevice.getUnionCode()}`);
    if (!this.isInit) {
      return Promise.reject(this.getInitError());
    }
    let retryTask = new RetryTask<boolean>();
    return retryTask.execute(() => this.executeDeviceConnect(iotDevice));
  }

  private executeDeviceConnect(iotDevice: IotDevice): Promise<boolean> {
    Logger.debug(IotConstants.IOT_TAG, `===>IotHelper executeDeviceConnect call udid =${iotDevice.getUnionCode()}`);
    Logger.debug(IotConstants.IOT_TAG,
      `===>IotHelper executeDeviceConnect call iotDevice =${JSON.stringify(iotDevice)}`);
    return new Promise(async (resolve, reject) => {
      try {
        let protocol = iotDevice.getScannedProtocol();
        let authInfo: Record<string, string> = {};
        if (protocol == 4) {
          authInfo['devId'] = iotDevice.getUnionCode();
          authInfo['authCodeId'] = iotDevice.getLocalControlDeviceInfo().authCodeId;
          authInfo['authCode'] = iotDevice.getLocalControlDeviceInfo().authCode;
        }
        Logger.debug(IotConstants.IOT_TAG,
          `===>IotHelper executeDeviceConnect call authInfo =${JSON.stringify(authInfo)}`);
        let connectParam: Record<string, boolean> = { 'isNeedBound': false, 'isNeedUnbind': false };
        let request: DeviceManager.ConnectRequest =
          new DeviceManager.ConnectRequest(iotDevice.getUnionCode(), protocol, protocol == 4 ? '' : '01234567',
            authInfo, connectParam);
        let response: DeviceManager.ConnectResponse = await DeviceManager.connectDevice(request);
        Logger.debug(IotConstants.IOT_TAG,
          `===>IotHelper executeDeviceConnect after DeviceManager.connectDevice response ${JSON.stringify(response)}`);
        let connectSession = response.connectSession;
        // 配网需要修改逻辑

        this.addConnectSession(iotDevice.getUnionCode(), connectSession);
        this.subscribeEvent(iotDevice.getUnionCode(), connectSession);
        this.addConnectDevice(iotDevice);


        if (protocol == DeviceManager.ScanProtocol.WIFI) {
          this.heartbeat();
        }
        Logger.debug(IotConstants.IOT_TAG, `IotHelper connectDevice complete`);
        resolve(true);
      } catch (error) {
        Logger.error(IotConstants.IOT_TAG, `connect error code= ${error.code} message= ${error.data}`);
        reject(error);
      }
    });
  }

  private heartbeat() {
    if (this.heartbeatTask != undefined) {
      this.heartbeatTask.stop();
      this.heartbeatTask = undefined;
    }
    this.heartbeatTask = new HeartbeatTask();
    this.heartbeatTask.execute(() => this.executeHeartBeat(), (error, count) => {
      if (error != undefined) {
        Logger.error(IotConstants.IOT_TAG, `heartbeat retry exceed limit, stop retr`);
        this.stopConnect(this.getConnectDevice());
        let status: Record<string, number | string> = {};
        status[InfConstants.ON_CONNECT_STATE_CHANGED_TYPE] = ConnectType.OFFLINE;
        status[InfConstants.UNION_CODE_TYPE] = this.getConnectDevice()?.getUnionCode() || '';
        let option: commonEventManager.CommonEventPublishData = {
          data: JSON.stringify(status)
        };
        commonEventManager.publish(`KEY_${InfConstants.ON_CONNECT_STATE_CHANGED}`, option, (error, data) => {

        });
      }
    });
  }

  private async executeHeartBeat(): Promise<boolean> {
    let iotDevice = this.getConnectDevice();
    if (iotDevice == undefined) {
      return false;
    }
    let connectSession = this.getConnectSession(iotDevice.getUnionCode());
    if (connectSession == undefined) {
      return false;
    }
    let body = '[{"sid":"switch"}]';
    try {
      await connectSession.sendCommand(InfConstants.CUSTOM_SEC_DATA, body);
      Logger.debug(IotConstants.IOT_TAG, 'heartbeat sendCommand success');
      return true;
    } catch (error) {
      Logger.error(IotConstants.IOT_TAG, `heartbeat sendCommand error ${error.code}`);
      if (error.code == InfConstants.SID_NOT_SUPPORT) {
        return true;
      }
      return false;
    }
  }

  public stopConnect(iotDevice?: IotDevice) {
    let udid = iotDevice?.getUnionCode();
    Logger.debug(IotConstants.IOT_TAG, `stopConnect call udid =${udid}`);
    let connectSession = this.getConnectSession(udid);
    this.unSubscribeEvent(connectSession);
    connectSession?.release();
    this.deleteConnectSession(udid);
    this.deleteConnectDevice(iotDevice);
    if (this.heartbeatTask != undefined) {
      this.heartbeatTask.stop();
      this.heartbeatTask = undefined;
    }
  }

  getConnectDevice(): IotDevice | undefined {
    if (this.connectDeviceList == undefined || this.connectDeviceList.length == 0) {
      return undefined;
    }
    return this.connectDeviceList[0];
  }


  queryIpInfo(): Promise<InfIpInfo> {
    Logger.debug(IotConstants.IOT_TAG, 'queryIpInfo call');
    let iotDevice = this.getConnectDevice();
    let connectSession = this.getConnectSession(iotDevice?.getUnionCode());
    if (connectSession == undefined) {
      return Promise.reject(this.getNotConnectError());
    }
    return new Promise(async (resolve, reject) => {
      let bodyStrings = `[{'sid':'${InfConstants.IP_SERVICES}','st':'${InfConstants.IP_SERVICES}'}]`;
      let sidKeys = InfConstants.IP_SERVICES;
      try {
        let infIpState = await this.executeDeviceQuery(bodyStrings, sidKeys);
        Logger.debug(IotConstants.IOT_TAG, `executeDeviceQuery success, infDeviceState.length: ${infIpState.length}`);
        if (infIpState.length == 0) {
          reject(new Error('get ip is empty'));
          return;
        }
        Logger.debug(IotConstants.IOT_TAG,
          `executeDeviceQuery success, infDeviceState[0].data: ${JSON.stringify(infIpState[0].data)}`);
        let ipInfo: InfIpInfo = {
          devId: '',
          ipInfo: {
            'getIp': infIpState[0].data[InfConstants.IP_SERVICES] as string
          }
        };
        resolve(ipInfo);
      } catch (e) {
        reject(e);
      }
    });
  }

  queryDeviceInfo(): Promise<InfDeviceInfo> {
    Logger.debug(IotConstants.IOT_TAG, 'queryDeviceInfo call');
    let iotDevice = this.getConnectDevice();
    let connectSession = this.getConnectSession(iotDevice?.getUnionCode());
    if (connectSession == undefined) {
      return Promise.reject(this.getNotConnectError());
    }
    // hilink svc 没实现deviceInfo 查询指令，暂时使用兼容方案
    return new Promise(async (resolve, reject) => {
      let bodyStrings = `[{'sid':'${InfConstants.SN_SERVICES}','st':'${InfConstants.SN_SERVICES}'}]`;
      let sidKeys = InfConstants.SN_SERVICES;
      try {
        let infDeviceState = await this.executeDeviceQuery(bodyStrings, sidKeys);
        Logger.debug(IotConstants.IOT_TAG,
          `executeDeviceQuery success, infDeviceState.length: ${infDeviceState.length}`);
        if (infDeviceState.length == 0) {
          reject(new Error('get sn is empty'));
          return;
        }
        Logger.debug(IotConstants.IOT_TAG,
          `executeDeviceQuery success, infDeviceState[0].data: ${JSON.stringify(infDeviceState[0].data)}`);
        let deviceInfo: InfDeviceInfo = {
          devId: '',
          deviceInfo: {
            'sn': infDeviceState[0].data[InfConstants.SN_SERVICES] as string
          }
        };
        resolve(deviceInfo);
      } catch (e) {
        reject(e);
      }
    });
  }

  queryDeviceState(sid: string[]): Promise<InfDeviceState[]> {
    Logger.debug(IotConstants.IOT_TAG, `===>queryDeviceState call sid: ${sid}`);
    if (sid.length == 0) {
      return Promise.reject(this.getParameterVerificationError());
    }
    let sidArray = sid.map((sid) => {
      let res: Record<string, string> = {};
      res['sid'] = sid;
      return res;
    });
    let bodyStrings = JSON.stringify(sidArray);
    let sidKeys = sid.join('-');
    Logger.debug(IotConstants.IOT_TAG, `===>queryDeviceState bodyStrings: ${bodyStrings}, sidKeys: ${sidKeys}`);
    return this.executeDeviceQuery(bodyStrings, sidKeys);
  }

  queryDeviceAllServices(): Promise<InfDeviceState[]> {
    Logger.debug(IotConstants.IOT_TAG, 'queryDeviceAllServices call');
    let iotDevice = this.getConnectDevice();
    if (iotDevice == undefined) {
      return Promise.reject(this.getNotConnectError());
    }
    let connectSession = this.getConnectSession(iotDevice.getUnionCode());
    if (connectSession == undefined) {
      return Promise.reject(this.getNotConnectError());
    }
    let bodyStrings = `[{'sid':'${InfConstants.SID_ALL_SERVICES}'}]`;
    if (iotDevice?.getScannedProtocol() == DeviceManager.ScanProtocol.WIFI) {
      bodyStrings = '';
    }
    let sidKeys = InfConstants.SID_ALL_SERVICES;
    return this.executeDeviceQuery(bodyStrings, sidKeys);
  }

  private executeDeviceQuery(bodyStrings: string, timersKey: string): Promise<InfDeviceState[]> {
    Logger.debug(IotConstants.IOT_TAG, `===>executeDeviceQuery bodyStrings ${bodyStrings}, timersKey ${timersKey}`);
    let iotDevice = this.getConnectDevice();
    let connectSession = this.getConnectSession(iotDevice?.getUnionCode());
    if (connectSession == undefined) {
      return Promise.reject(this.getNotConnectError());
    }
    return new Promise((resolve, reject) => {
      if (this.deviceStateTimers.has(timersKey)) {
        let oldTimers = this.deviceStateTimers.get(timersKey);
        oldTimers?.clearTimers();
        this.deviceStateTimers.delete(timersKey);
      }

      let timers = new Timers<InfDeviceState[]>((data) => {
        Logger.debug(IotConstants.IOT_TAG, `===>executeDeviceQuery new Timers data ${JSON.stringify(data)}`);
        resolve(data);
      }, (error) => {
        reject(error);
      });
      this.deviceStateTimers.set(timersKey, timers);
      timers.start();
      connectSession?.sendCommand(InfConstants.CUSTOM_SEC_DATA, bodyStrings).then(() => {
        Logger.info(IotConstants.IOT_TAG, 'executeDeviceQuery success');
      }).catch((error: BusinessError) => {
        Logger.error(IotConstants.IOT_TAG, `executeDeviceQuery error code = ${error.code}, message = ${error.message}`);
        let oldTimers = this.deviceStateTimers.get(timersKey);
        oldTimers?.executeFailed(error);
        this.deviceStateTimers.delete(timersKey);
      });
    });
  }

  //控制设备
  controlDevice(control: InfControl): Promise<boolean> { //HilinkChannel.ets中 controlDevice
    Logger.debug(IotConstants.IOT_TAG,
      `===> controlDevice call control: ${JSON.stringify(control)},getDataJson: ${control.getDataJson()}`);
    let iotDevice = this.getConnectDevice();
    let connectSession = this.getConnectSession(iotDevice?.getUnionCode());
    if (connectSession == undefined) {
      return Promise.reject(this.getNotConnectError());
    }
    return new Promise((resolve, reject) => {
      let bodyStrings = ``;
      let serviceName = InfConstants.CUSTOM_SEC_DATA;
      if (control instanceof NetCfgControl) {
        serviceName = control.getServiceName();
        bodyStrings = control.getDataJson();
      } else {
        bodyStrings = `[${control.getDataJson()}]`;
      }
      Logger.debug(IotConstants.IOT_TAG, `===>controlDevice = ${bodyStrings}`);
      connectSession?.sendCommand(serviceName, bodyStrings).then(() => { //成功后就走到了subscribeEvent
        Logger.info(IotConstants.IOT_TAG, '===>controlDevice sendCommand success');
        resolve(true);
      }).catch((error: BusinessError) => {
        Logger.error(IotConstants.IOT_TAG, `controlDevice error code = ${error.code}`);
        reject(error);
      });
    });
  }

  private getInitError() {
    const error: BusinessError<string> = {
      name: 'iot_error',
      message: IotConstants.IOT_NOT_INIT_MSG,
      code: IotConstants.IOT_NOT_INIT,
    };
    return error;
  }

  private getNotConnectError() {
    const error: BusinessError<string> = {
      name: 'iot_error',
      message: IotConstants.IOT_NOT_CONNECT_MSG,
      code: IotConstants.IOT_NOT_CONNECT,
    };
    return error;
  }

  private getParameterVerificationError() {
    const error: BusinessError<string> = {
      name: 'iot_error',
      message: IotConstants.IOT_PARAMS_ERROR_MSG,
      code: IotConstants.IOT_PARAMS_ERROR,
    };
    return error;
  }
};