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

export class Project {
  public id?: string;
  public name: string;
  public description: string;
  public locationName: string;
  public longitude: string;
  public latitude: string;
  public role?: string;
  public confirmStatus?: string;

  constructor() {
    this.name = '';
    this.description = '';
    this.locationName = '';
    this.longitude = '';
    this.latitude = '';
  }
}

export interface DevicesRes {
  devices: Array<CloudDeviceModel>;
}

export class CloudDeviceModel {
  public projectId: string = '';
  public deviceId: string = '';
  public name: string = '';
  public gatewayId: string = ''; // 网关id，如果设备直连云则为空
  public noteType: string = ''; // 网关类型
  public status: string = ''; // 设备状态
  public sn: string = '';
  public model: string = '';
  public deviceType: string = '';
  public manu: string = '';
  public productId: string = '';
  public mac: string = '';
  public hiv: string = '';
  public fwv: string = '';
  public hwv: string = '';
  public swv: string = '';
  public protocolType: string = '';
  public role: string = '';
}

class DeviceInfo {
  public sn: string = '';
  public model: string = '';
  public deviceType: string = '';
  public manu: string = '';
  public productId: string = '';
  public mac: string = '';
  public hiv: string = '';
  public fwv: string = '';
  public hwv: string = '';
  public swv: string = '';
  public protocolType: string = '';
}

export interface ProjectId {
  id: string;
}

export interface AddDeviceToProjectBody {
  projectId: string;
  deviceIdList: Array<string>;
}

export interface DevVerifyCode {
  projectId?: string;
  registryType?: string; // 注册类型
  sn?: string;
  productId?: string;
  uniqueDeviceId?: boolean;
}

export interface VerifyCode {
  verifyCode: string;
  deviceId: string;
  cloudAddress: string;
  psk: string;
  activated: boolean;
  activeTime: number;
}

export interface ControlBody {
  cmdType?: number;
  mode?: string;
  requestId?: string;
  timestamp?: string;
  devId: string;
  prodId: string;
  operation?: string;
  services: ServiceData[];
}

export interface RequestBody {
  cmdType: number;
  mode?: string;
  requestId: string;
  timestamp: string;
  devId: string;
  prodId: string;
  operation?: string;
  services: ServiceData[];
}

type ControlValue = string | number | boolean;

export interface ServiceData {
  sid: string;
  st?: string;
  data: Record<string, ControlValue>;
}

export interface ControlResult {
  devId: string
  verifyCode: string,
  cloudAddress: string
  activated: boolean
  activeTime: number
}

interface CharacteristicName {
  characteristicName1: string;
  characteristicName2: string;
}

export interface DevSnapshotMsg {
  devId: string;
  gatewayId: string;
  noteType: string;
  devInfo: DeviceInfo;
  services: Array<ServiceData>;
}

export interface ProductProfile {}