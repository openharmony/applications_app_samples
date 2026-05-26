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
import { EnumEntryDto, ServiceDto } from '../view/profileview/ThingModelDto';
import {
  Characteristics,
  CharacteristicsArray,
  EnumEntry,
  EnumList,
  ProfileServices
} from '../view/profileview/ViewModel';

export function parseProfileServices(rawServices: ServiceDto []): ProfileServices[] {
  return rawServices.map(service => {
    const characteristics = new CharacteristicsArray();
    if (Array.isArray(service.characteristics)) {
      service.characteristics.forEach(char => {
        const enumList = new EnumList();
        if (Array.isArray(char.enumList)) {
          char.enumList.forEach(e => {
            enumList.push(new EnumEntry(e.descCh, e.descEn, e.enumVal));
          });
        }

        const characteristic = new Characteristics(
          char.characteristicName,
          char.characteristicType,
          char.description,
          char.method,
          char.permission,
          char.attrName,
          char.attrNameEn,
          char.ecaFlag
        );
        characteristic.setEnumList(enumList.length > 0 ? enumList : undefined);
        // 其他字段如 maxLength、unitType 可选设置
        characteristics.push(characteristic);
      });
    }

    return new ProfileServices(
      service.serviceId,
      service.serviceType,
      service.serviceName,
      service.serviceNameEn,
      service.description,
      characteristics
    );
  });
}