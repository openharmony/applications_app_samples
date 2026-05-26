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
import { CharacteristicMethod, CharacteristicPermissions, CharacteristicType } from './ViewModel';

export interface EnumEntryDto {
  descCh: string;
  descEn: string;
  enumVal: number | string; // 根据 ControlValue 类型调整
}

export interface CharacteristicsDto {
  characteristicName: string;
  characteristicType: CharacteristicType;
  description: string;
  method: CharacteristicMethod;
  permission: CharacteristicPermissions;
  attrName: string;
  attrNameEn: string;
  ecaFlag: string;
  maxLength?: number;
  enumList?: EnumEntryDto[];
  unitType?: UnitTypeDto;
}

export interface ServiceDto {
  serviceId: string;
  serviceType: string;
  serviceName: string;
  serviceNameEn: string;
  description: string;
  characteristics: CharacteristicsDto[];
}

export interface DeviceModelDto {
  prodId: number;
  deviceModel: string;
  deviceTypeId: number;
  deviceTypeName: string;
  deviceTypeNameEn: string;
  deviceName: string;
  manufacturerId: number;
  manufacturerName: string;
  typicalService: string;
  description: string;
  services: ServiceDto[];
}

export interface UnitTypeDto {
  min: number;
  max: number;
  step: number;
  unit: string;
  unitEn: string;
}

export interface ThingModelDto {
  prodId: number;
  deviceModel: string;
  deviceTypeId: number;
  deviceTypeName: string;
  deviceTypeNameEn: string;
  deviceName: string;
  manufacturerId: number;
  manufacturerName: string;
  typicalService: string;
  description: string;
  services: ServiceDto[];
}