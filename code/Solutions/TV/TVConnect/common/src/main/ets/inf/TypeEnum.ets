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
 * 通讯协议类型
 */
export enum ProtocolType {
  VIRTUAL = 0b00000000,
  WIFI = 0b00000001,
  BLE = 0b00000010,
  SLE = 0b00000100,
  ETHERNET = 0b00001000,
  UNKNOWN = 0b11111111,
}

export function getProtocolCode(type: ProtocolType.WIFI | ProtocolType.BLE): string {
  switch (type) {
    case ProtocolType.WIFI:
      return 'wifi';
    case ProtocolType.BLE:
      return 'ble';
    default:
      return 'unknown';
  }
}

/**
 * 通讯协议具体实现
 */
export enum SubProtocolType {
  // 基于开源协议的自实现
  ble_open,
  // 开鸿智谷的蓝牙协议
  ble_open_valley,
  // 基于开源协议的实现
  wifi_open,
  // 虚拟子协议
  virtual_sub,
  // 基于iot_connect_sdk 开源协议的自实现,该 sdk 包含wifi,ble...
  iot_connect,
  // 云
  cloud,
}

export enum ScanProtocol {
  WIFI = 1,

  BLE = 2,

  COAP = 4,

  ALL = 255
}

export enum ServerType {
  netCfgVer, //查询蓝牙辅助配网协议版本
  deviceInfo, //查询设备配网注册信息
  createSession, //创建会话
  authSetup, //发送authCode至设备
  customSecData, //设备操作数据
  authdelete, //代理删除设备
  clearDevRegInfo, //恢复出厂设置
  speke, //SPEKE协商
}

export enum EncryType {
  NOT_ENCODE, //不加密
  ODN_SPEKE, //配网speke
  CONTROLLER_SPEKE, //控制speke
  SESSION_KEY, //session key
  AUTH_CODE, //authCode
}

export enum ConnectType {
  DISCONNECT = 0, // 断连
  CONNECTING = 1, // 连接中
  ONLINE = 2, // 在线
  OFFLINE = 3, // 离线
}