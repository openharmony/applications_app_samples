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
import { AsyncCallback } from '@ohos.base';
import {
  InfDevice,
  InfDeviceInfo,
  InfDevicesBusiness,
  InfDevicesController,
  InfDeviceState,
  InfIpInfo,
  ScanOptions
} from '@ohos/common';
import { ConnectType, SubProtocolType } from '@ohos/common/src/main/ets/inf/TypeEnum';
import { CloudDeviceModel, ServiceData } from '@ohos/connect_cloud';

export default interface DeviceManagerInterface {
  /**
   * 构建DeviceManager对象
   */
  createDeviceManager(): void;

  /**
   * 绑定ailifesvc 服务
   * @param context
   */
  bindLifeSvc(context: common.UIAbilityContext): void;

  /**
   * 销毁
   */
  releaseDeviceManager(): void;

  /**
   * 设备发现接口
   * @param option 发现参数
   * @param callback 发现结果回调
   */
  startDeviceDiscover(option: ScanOptions | null, callback?: AsyncCallback<InfDevice>): void;

  /**
   * 停止发现
   */
  stopDeviceDiscovery(): void;

  /**
   * 获取云设备
   * @returns
   */
  getCloudDevice(projectId: string): Promise<CloudDeviceModel[]>;

  /**
   * 连接设备
   * @param device
   * @returns
   */
  connectDevice(device: InfDevice, callBack: AsyncCallback<ConnectType>): void;

  /**
   * 蓝牙，wifi 辅助配网接口
   * @param netCfgRecord: ssid,password,cloudUrl
   *
   * @returns
   */
  configureNetwork(netCfgRecord: Record<string, string>): Promise<boolean>;

  /**
   * 控制设备
   * @param option
   * @returns
   */
  controlDevice(option: ControlOption): Promise<boolean>;

  /**
   * 查询设备详情
   * @param option
   * @param sids 需要查询的sid 数组
   * @returns
   */
  queryDeviceInfo(option: QueryInfoOption): Promise<InfDeviceInfo>;

  queryIpInfo(option: QueryInfoOption): Promise<InfIpInfo>;

  /**
   * 查询设备服务状态
   * @param option
   * @param sids 需要查询的sid 数组
   * @returns
   */
  queryDeviceState(option: QueryOption): Promise<InfDeviceState[]>;

  /**
   * 查询所有服务状态
   * @param option
   * @returns
   */
  queryDeviceAllServices(option: QueryOption): Promise<InfDeviceState[]>;

  /**
   * 连接中
   * @returns
   */
  isConnecting(): boolean;

  /**
   * 根据连接设备的类型获取连接设备的InfDevicesBusiness
   * @returns
   */
  getDevicesBusiness(protocolType?: SubProtocolType): InfDevicesBusiness | undefined;

  /**
   * 断开连接
   */
  disconnect(): void;

  /**
   * 注册设备上下线状态
   * @param name
   * @param callBack
   */
  registerConnectStateChanged(name: string, callBack: Callback<ConnectChangeAction>): void;

  /**
   *
   * @param name
   */
  unRegisterConnectStateChanged(name: string): void;

  /**
   * 注册设备控制状态
   * @param name
   * @param callBack
   */
  registerMessageReceivers(name: string, callBack: Callback<MessageAction>): void;

  /**
   *
   * @param name
   */
  unRegisterMessageReceivers(name: string): void;

  /**
   * 注册设备控制器
   * @param controller
   */
  registerController(controller: InfDevicesController): void;

  /**
   * 注册设备激活状态通知
   * @param name
   */
  registerDeviceBindChanged(name: string, callBack: Callback<string>): void;

  /**
   *
   * @param name
   */
  unregisterDeviceBindChanged(name: string): void;

  // 注册快照信息发生变化监听
  registerDeviceAllSnapshot(name: string, callBack: Callback<Record<string, ServiceData[] | string>>): void;

  unregisterDeviceAllSnapshotChanged(name: string): void;

  // 设备名称改变
  modifyDeviceName(proId: string, devId: string, name: string): void;

  unregisterDeviceInfoChange(name: string): void;

  registerDeviceInfoChange(name: string, callBack: Callback<Record<string, string>>): void;
}

interface DeviceOption {
  unionCode: string;
  deviceId: string;
}

export interface ConnectChangeAction extends DeviceOption {
  action: ConnectType;
}

export interface MessageAction extends DeviceOption {
  message: InfDeviceState[];
}

interface BaseOption {
  /**
   * hilink-svc 连接唯一标识
   */
  unionCode?: string;

  /**
   * 云测分配的deviceId
   */
  deviceId?: string;

  /**
   * 产品ID
   */
  productId?: string;

  /**
   * 连接的协议类型
   */
  protocolType?: SubProtocolType;
}

export interface QueryInfoOption extends BaseOption {}

export interface ControlOption extends BaseOption {
  serviceId: string;
  serviceType?: string;
  controlJson: string;
}

export interface QueryOption extends BaseOption {
  sids: string[];
}

export class DeviceManagerCode {
  public static readonly DEVICE_CONNECT_RUNNING: number = 10000;
  public static readonly DEVICE_CONNECT_FAILED: number = 10001;
}
