/*
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

import { connection } from '@kit.NetworkKit';
import { BusinessError, emitter } from '@kit.BasicServicesKit';
import { radio } from '@kit.TelephonyKit';
import { wifiManager } from '@kit.ConnectivityKit';
import { logger } from './Logger';
import { NetworkEventData } from './EmitterData';
import { HashMap, JSON } from '@kit.ArkTS';

type NetworkData = boolean | connection.NetBlockStatusInfo | connection.NetBearType
  | connection.NetConnectionPropertyInfo | connection.NetCapabilityInfo;

// 网络监听emitter事件
export enum NetworkEventName {
  // 注册网络监听订阅事件
  NetObserverRegister,
  // 网络可用
  NetAvailable,
  // 网络阻塞
  NetBlock,
  // 网络丢失/断开
  NetLost,
  // 当网络能力变化时，如网络从无网络到有网络、从4G切换到5G
  NetCapabilitiesChange,
  // 网络不可用
  NetUnavailable,
  // WIFI状态改变
  WifiStateChange,
  // WIFI连接状态改变
  WifiConnectionChange,
  // 弱网
  WeakNet,
  // 订阅网络连接信息变化事件，当网络连接信息变化时，如从无网络到有网络、从Wi-Fi切换到蜂窝
  NetConnectionPropertiesChange
}

export class NetUtils {
  public static instance: NetUtils;
  private connectionMap: HashMap<connection.NetBearType, connection.NetConnection> = new HashMap();
  // 网络状态监听eventId
  private networkEventId: number = 10001;
  // 网络监听相关结果数据
  private emitterEvent: NetworkEventData;

  constructor() {
    this.emitterEvent = new NetworkEventData(this.networkEventId);
  }

  static getInstance(): NetUtils {
    if (!NetUtils.instance) {
      NetUtils.instance = new NetUtils();
    }
    return NetUtils.instance;
  }

  public getEmitterEvent(): NetworkEventData {
    return this.emitterEvent;
  }

  private setEventPriority(priority: emitter.EventPriority): void {
    this.emitterEvent.priority = priority;
  }

  /**
   * 通过emitter将结果传递给页面
   * @param eventName 事件名称
   * @param status    网络状态（可传递不同的监听结果数据类型）
   * @param netType   网络类型（WI-FI、蜂窝数据等）
   * @param priority  emitter事件权重
   */
  private postEvent(eventName: NetworkEventName, status: NetworkData, netType?: connection.NetBearType,
    priority?: emitter.EventPriority) {
    this.emitterEvent.priority = priority;
    emitter.emit(this.emitterEvent, {
      data: new NetEventData(eventName, status, netType)
    })
  }

  /**
   * 开启网络监听
   * @param netType 需要监听的网络类型
   */
  public startNetObserve(...netType: connection.NetBearType[]) {
    netType.forEach((type: connection.NetBearType) => {
      this.networkObserve(type);
      if (type === connection.NetBearType.BEARER_WIFI) {
        this.wifiStateObserve();
      }
    })
  }

  /**
   * 停止网络监听
   */
  public stopNetObserve(netType: connection.NetBearType) {
    this.connectionMap.get(netType).unregister(() => {
      logger.info('Success unregister：' + netType.toString());
    })
  }

  /**
   * 停止所有网络监听
   */
  public stopAllNetObserve() {
    emitter.off(this.getEmitterEvent().eventId);
    this.connectionMap.forEach((netConnection: connection.NetConnection, netType: connection.NetBearType) => {
      netConnection.unregister(() => {
        logger.info('Success unregister：' + netType.toString());
      });
    })
  }

  /**
   * 获取当前网络连接类型
   * 判断当前使用的网络是蜂窝或者Wi-Fi
   * BEARER_CELLULAR时（值为0），表示蜂窝网络
   * BEARER_WIFI时(值为1），表示Wi-Fi网络
   * BEARER_BLUETOOTH时（值为2），表示蓝牙网络
   * BEARER_ETHERNET时（值为3），表示以太网网络
   * BEARER_VPN时（值为4），表示VPN网络
   * @returns 当前可用网络类型的列表
   */
  getNetworkConnectionType(): Array<connection.NetBearType> {
    try {
      // 获取默认激活的数据网络
      let netHandle = connection.getDefaultNetSync();
      if (!netHandle || netHandle.netId === 0) {
        return [];
      }
      // 获取网络的类型、拥有的能力等信息
      let netCapability = connection.getNetCapabilitiesSync(netHandle);
      return netCapability.bearerTypes;
    } catch (e) {
      let err = e as BusinessError;
      logger.error('errCode: ' + (err as BusinessError).code + ', errMessage: ' + (err as BusinessError).message);
      return [];
    }
  }

  /**
   * 判断当前网络是否可用
   * 使用网络前，例如打开一个应用时，需要检查当前连接的网络是否可用。
   * 如果可用，则正常进行网络请求；如果不可用，则需要提示用户网络不可用。
   * @returns 当前网络是否可用
   */
  judgeHasNet(): boolean {
    try {
      let netHandle = connection.getDefaultNetSync();
      if (!netHandle || netHandle.netId === 0) {
        return false;
      }
      let netCapability = connection.getNetCapabilitiesSync(netHandle);
      let cap = netCapability.networkCap || [];
      if (cap.includes(connection.NetCap.NET_CAPABILITY_VALIDATED)) {
        //connection.NetCap.NET_CAPABILITY_VALIDATED，该值代表网络是通的，能够发起HTTP和HTTPS的请求。
        // 网络信息变化，网络可用
        return true;
      } else {
        // 网络信息变化，网络不可用
        return false;
      }
    } catch (e) {
      let err = e as BusinessError;
      logger.error('JudgeHasNet' + JSON.stringify(err));
    }
    return false;
  }

  /**
   * 获取网络状态，查询手机卡注册网络的运营商名称、是否处于漫游状态、设备的网络注册状态等信息
   */
  getNetworkStatus() {
    radio.getNetworkState((err: BusinessError, data: radio.NetworkState) => {
      if (err) {
        logger.error(`getNetworkState failed, callback: err->${JSON.stringify(err)}`);
      }
      // regState字段表示设备的网络注册状态
      // （REG_STATE_POWER_OFF，值为3）蜂窝无线电已关闭，modem下电，无法和网侧进行通信
      logger.info('Success getNetworkStatus：' + JSON.stringify(data));
    });
  }

  /**
   * 查询当前网络是3G/4G/5G
   * SignalInformation.signalType表示蜂窝网络的类型
   * 未知（值为0）
   * 2G：GSM（值为1）、CDMA（值为2）
   * 3G：WCDMA（值为3）、TDSCDMA（值为4）
   * 4G：LTE（值为5）
   * 5G：NR（值为6）
   * @returns 指定SIM卡槽对应的注册网络信号强度信息列表
   */
  async getSignalType(): Promise<radio.SignalInformation[]> {
    let slotId: number = await radio.getPrimarySlotId();
    let data: radio.SignalInformation[] = radio.getSignalInformationSync(slotId);
    // signalType代表网络类型NetworkType
    let signalType = data[0].signalType;
    logger.info('getSignalType：' + JSON.stringify(data));
    return data;
  }

  /**
   * 查询WLAN是否已使能，可以帮助用户快速了解自己是否可以使用Wi-Fi网络进行连接。
   * 当Wi-Fi跟蜂窝同时存在时，有助于实现网络连接的无缝切换。
   * @returns true:已使能， false:未使能
   */
  getWifiStatus(): boolean {
    try {
      let isWifiActive: boolean = wifiManager.isWifiActive();
      return isWifiActive;
    } catch (error) {
      logger.error('failed:' + JSON.stringify(error));
    }
    return false;
  }

  /**
   * 查询WLAN是否已连接是判断能否通过Wi-Fi 进行各种网络活动的直接方式。
   * @returns true，已连接。false，未连接
   */
  getWifiIsConnected(): boolean {
    try {
      let ret = wifiManager.isConnected();
      logger.info('isConnected:' + ret);
      return ret;
    } catch (error) {
      logger.error('failed:' + JSON.stringify(error));
    }
    return false;
  }

  /**
   * 获取当前连接Wi-Fi的信号强度
   * 通过获取信号强度，用户可以初步判断当前网络是否能够满足其对速度的需求。
   * 取值范围为[0, 4]，取值越大表示信号越强
   * @returns 信号强度，取值范围[0, 4]，-1表示报错
   */
  async getSignalLevel(): Promise<number> {
    try {
      let wifiLinkedInfo: wifiManager.WifiLinkedInfo = await wifiManager.getLinkedInfo();
      let rssi = wifiLinkedInfo.rssi;
      let band = wifiLinkedInfo.band;
      let level = wifiManager.getSignalLevel(rssi, band);
      logger.info('level:' + JSON.stringify(level));
      return level;
    } catch (error) {
      logger.error('failed:' + JSON.stringify(error));
    }
    return -1;
  }

  /**
   * 监听网络状态
   * @param netType  监听的网络类型（WI-FI、蜂窝数据等）
   */
  networkObserve(netType: connection.NetBearType) {
    // TODO:根据网络类型，设置不同的网络监听，用于WI-FI和蜂窝网络切换时判断各自网络状态的变化。
    let netConnection: connection.NetConnection = connection.createNetConnection({
      netCapabilities: {
        bearerTypes: [netType]
      }
    })
    // 注册网络监听，注册成功后才能监听到对应类型的网络状态变化
    netConnection.register((error: BusinessError) => {
      let result = true;
      if (error) {
        logger.info('NetUtils', 'NetType :' + netType + ', network register failed: ' + JSON.stringify(error));
        result = false;
      }
      logger.info('NetUtils', 'NetType :' + netType + ', network register succeed');
      this.postEvent(NetworkEventName.NetObserverRegister, result, netType);
    });
    // 网络能力改变监听，当网络能力变化时，如网络从无网络到有网络、从4G切换到5G时，会触发该事件。
    netConnection.on('netCapabilitiesChange', (data: connection.NetCapabilityInfo) => {
      logger.info('NetUtils', 'NetType :' + netType + ', network netCapabilitiesChange: ' + JSON.stringify(data));
      this.postEvent(NetworkEventName.NetCapabilitiesChange, data, netType);
    })
    // 网络可用监听，当网络可用时触发该事件。
    netConnection.on('netAvailable', (data: connection.NetHandle) => {
      logger.info('NetUtils',
        'NetType :' + netType + ', network succeeded to get netAvailable: ' + JSON.stringify(data));
      // 检查默认数据网络是否被激活，使用同步方式返回接口，如果被激活则返回true，否则返回false。
      this.postEvent(NetworkEventName.NetAvailable, connection.hasDefaultNetSync(), netType);
    });

    // 订阅网络阻塞状态事件，当网络阻塞时，如网络性能下降、数据传输出现延迟等情况时，会触发该事件
    netConnection.on('netBlockStatusChange', (data: connection.NetBlockStatusInfo) => {
      logger.info('NetUtils', 'NetType :' + netType + ', network netBlockStatusChange ' + JSON.stringify(data));
      this.postEvent(NetworkEventName.NetBlock, data, netType);
    });
    // 网络连接信息变化监听，当网络连接信息变化时，如从无网络到有网络、从Wi-Fi切换到蜂窝时，会触发该事件。
    netConnection.on('netConnectionPropertiesChange', (data: connection.NetConnectionPropertyInfo) => {
      logger.info('NetUtils',
        'NetType :' + netType + ', network netConnectionPropertiesChange ' + JSON.stringify(data));
      this.postEvent(NetworkEventName.NetConnectionPropertiesChange, data, netType);
    });

    // 订阅网络丢失事件，当网络严重中断或正常断开时触发该事件
    // 网络丢失是指网络严重中断或正常断开事件，当断开Wi-Fi时，是属于正常断开网络连接，会触发netLost事件
    netConnection.on('netLost', (data: connection.NetHandle) => {
      this.postEvent(NetworkEventName.NetLost, true, netType);
      logger.info('NetUtils', 'NetType :' + netType + ', Succeeded to get netLost: ' + JSON.stringify(data));
    });

    // 订阅网络不可用事件，当网络不可用时触发该事件
    // 网络不可用是指网络不可用事件，当连接的网络不能使用时，会触发netUnavailable事件。
    netConnection.on('netUnavailable', () => {
      logger.info('NetUtils', 'NetType :' + netType + ', Succeeded to get unavailable net event');
      this.postEvent(NetworkEventName.NetUnavailable, true, netType);
    });

    this.connectionMap.set(netType, netConnection);
  }

  /**
   * WI-FI状态监听
   */
  wifiStateObserve() {
    // 注册WLAN状态改变事件
    // 0，未激活；1，已激活；2，激活中；3：去激活中
    wifiManager.on('wifiStateChange', (result: number) => {
      logger.info('NetUtils', 'wifiStateChange: ' + result);
      this.postEvent(NetworkEventName.WifiStateChange, result);
    });
    // 注册WLAN连接状态改变事件
    // 0，已断开；1，已连接
    wifiManager.on('wifiConnectionChange', (result: number) => {
      logger.info('NetUtils', 'wifiConnectionChange: ' + result);
      this.postEvent(NetworkEventName.WifiConnectionChange, result);
    });
  }

  /**
   * 解析网络监听结果，用于打印日志
   * @param data  网络监听结果
   * @returns 解析后的结果数据
   */
  parseResult(data: emitter.EventData): string {
    if (data.data) {
      if (!data.data.eventName) {
        logger.info('parseResult data.data.eventName is undefined.');
        return '';
      }
    } else {
      logger.info('parseResult data.data is undefined.');
      return '';
    }
    let result = '';
    let name: number = (data.data)!.eventName ?? -1;
    switch (name) {
      case NetworkEventName.NetObserverRegister.valueOf():
        result = 'NetObserverRegister';
        break;
      case NetworkEventName.NetAvailable.valueOf():
        result = 'NetAvailable';
        break;
      case NetworkEventName.NetBlock.valueOf():
        result = 'NetBlock';
        break;
      case NetworkEventName.NetLost.valueOf():
        result = 'NetLost';
        break;
      case NetworkEventName.NetCapabilitiesChange.valueOf():
        result = 'NetCapabilitiesChange';
        break;
      case NetworkEventName.NetUnavailable.valueOf():
        result = 'NetUnavailable';
        break;
      case NetworkEventName.NetConnectionPropertiesChange.valueOf():
        result = 'NetConnectionPropertiesChange';
        break;
      case NetworkEventName.WifiStateChange.valueOf():
        result = 'WifiStateChange';
        break;
      case NetworkEventName.WifiConnectionChange.valueOf():
        result = 'WifiConnectionChange';
        break;
      case NetworkEventName.WeakNet.valueOf():
        result = 'WeakNet';
        break;
      default:
        result = name.toString();
        break;
    }

    let netTemp: string = '';
    let temp: number = data.data!.netType ?? -1;
    if (temp === 1) {
      netTemp = 'WIFI';
    }
    if (temp === 0) {
      netTemp = 'CELLULAR';
    }
    if (temp === -1) {
      netTemp = temp.toString();
    }

    result = result + '------' + (data.data!.status ?? -1) + '------' + netTemp;

    return result;
  }
}

export class NetEventData {
  public eventName: NetworkEventName;
  public status: NetworkData;
  public netType: connection.NetBearType;

  constructor(eventName: NetworkEventName, status: NetworkData, netType: connection.NetBearType) {
    this.eventName = eventName;
    this.status = status;
    this.netType = netType;
  }
}