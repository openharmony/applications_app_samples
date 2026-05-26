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
/**
 * 定义所有的通用设备业务操作，比如信息查询，服务调用等
 */
export declare interface InfDevicesBusiness {
  /**
   * 查询设备状态
   */
  queryDeviceState(sid: string[]): Promise<Array<InfDeviceState>>;

  /**
   * 查询设备所有服务
   */
  queryDeviceAllServices(): Promise<Array<InfDeviceState>>;

  /**
   * 查询设备信息
   */
  queryDeviceInfo(): Promise<InfDeviceInfo>;

  queryIpInfo(): Promise<InfIpInfo>;

  /**
   * 控制设备信息
   */
  controlDevice(control: InfControl): Promise<boolean>;
}

/**
 * 设备ID设备状态
 */
export interface DeviceStatus {
  devId?: string;
  unionCode?: string;
  gatewayId?: string;
  services: InfDeviceState[];
}

/**
 * 设备状态
 */
export interface InfDeviceState {
  data: Record<string, string | number>
  sid: string,
}

/**
 * 设备信息
 */
export interface InfDeviceInfo {
  devId: string,
  deviceInfo: Record<string, string>,
}

/**
 * Ip信息
 */
export interface InfIpInfo {
  devId: string,
  ipInfo: Record<string, string>,
}

/**
 * 控制信息
 */
export interface InfControl {
  //服务id
  getServiceId(): string;

  //控制信息
  getDataJson(): string;
}
