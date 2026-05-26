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

export class InfConstants {
  /**
   * sid 不支持
   */
  public static readonly SID_NOT_SUPPORT: number = -1;
  /**
   * 设备连接状态
   */
  public static readonly ON_CONNECT_STATE_CHANGED: string = 'onConnectStateChanged';
  /**
   * sid 事件上报
   */
  public static readonly ON_DEVICE_DATA_CHANGED: string = 'onDeviceDataChanged';
  /**
   * 网关绑定设备
   */
  public static readonly ON_BIND_DEVICE: string = 'onBindDevice';
  /**
   * 添加新设备
   */
  public static readonly ON_DEVICE_UPDATED: string = 'onDeviceUpdated';
  /**
   * 设备连接状态key
   */
  public static readonly ON_CONNECT_STATE_CHANGED_TYPE: string = 'newStatus';
  /**
   * 设备网络unionCode
   */
  public static readonly UNION_CODE_TYPE: string = 'unionCode';
  /**
   * deviceID
   */
  public static readonly DEVICE_ID_TYPE: string = 'deviceId';
  /**
   * 网关ID
   */
  public static readonly GATEWAY_ID_TYPE: string = 'gatewayId';
  /**
   * allservices
   */
  public static readonly SID_ALL_SERVICES: string = 'allservices';
  /**
   * customSecData
   */
  public static readonly CUSTOM_SEC_DATA: string = 'customSecData';
  /**
   * netCfg
   */
  public static readonly NET_CFG: string = 'netCfg';
  /**
   * authSetup
   */
  public static readonly AUTH_SETUP: string = 'authSetup';
  /**
   * deviceInfo
   */
  public static readonly DEVICE_INFO: string = 'deviceInfo';
  /**
   * sn
   */
  public static readonly SN_SERVICES: string = 'snw';
  /**
   * sn
   */
  public static readonly IP_SERVICES: string = 'getIp';
  /**
   * 账号重复登录
   */
  public static readonly ON_DUPLICATE_LOGIN: string = 'onDuplicateLogin';
  /**
   * 删除设备
   */
  public static readonly ON_DEVICE_DELETE: string = 'onDeviceDeleted';
  /**
   * 设备所有快照信息
   */
  public static readonly ON_DEVICE_ALL_SNAPSHOT: string = 'DeviceAllServicesChanged';
}