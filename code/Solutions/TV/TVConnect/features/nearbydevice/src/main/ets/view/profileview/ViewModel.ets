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
import { Logger } from '@ohos/common';
import { ControlOption, DeviceManagerFactory, QueryOption } from '@ohos/device_manager';
import { util } from '@kit.ArkTS';
import { BusinessError } from '@kit.BasicServicesKit';
import { Log } from 'library_communication';
import { ConnectType } from '@ohos/common/src/main/ets/inf/TypeEnum';
import { DevSnapshotMsg, HttpApi, ServiceData } from '@ohos/connect_cloud';
import { ProfileStore } from './ProfileStore';
import { ProfileBuilder, RecordObject } from './ProfileBuilder';

export enum CharacteristicPermissions {
  GET = 0b001,
  PUT = 0b010,
  REPORT = 0b100,
}

export enum CharacteristicMethod {
  READ = 0b01,
  WRITE = 0b010,
}

export enum CharacteristicType {
  ENUM = 'enum',
  BOOL = 'bool',
  STRING = 'string',
  INT = 'int',
  FLOAT = 'float',
}

export function isSupportPermissions(permissions: CharacteristicPermissions, target: CharacteristicPermissions) {
  return (target & permissions) == target;
}

export type ControlValue = string | number | boolean;

@Observed
export class ProfileModel {
  public prodId: string;
  public deviceModel: string;
  public deviceTypeId: string;
  public deviceTypeName: string;
  public deviceTypeNameEn: string;
  public deviceName: string;
  public manufacturerId: string;
  public manufacturerName: string;
  public typicalService: string;
  public description: string;
  public services: ProfileModelArray;

  constructor(prodId: string, deviceModel: string, deviceTypeId: string, deviceTypeName: string,
    deviceTypeNameEn: string, deviceName: string, manufacturerId: string, manufacturerName: string,
    typicalService: string, description: string, services: ProfileModelArray) {
    this.prodId = prodId;
    this.deviceModel = deviceModel;
    this.deviceTypeId = deviceTypeId;
    this.deviceTypeName = deviceTypeName;
    this.deviceTypeNameEn = deviceTypeNameEn;
    this.deviceName = deviceName;
    this.manufacturerId = manufacturerId;
    this.manufacturerName = manufacturerName;
    this.typicalService = typicalService;
    this.description = description;
    this.services = services;
  }
}

@Observed
export class ProfileModelArray extends Array<ProfileServices> {
}

@Observed
export class ProfileServices {
  public serviceId: string;
  public serviceType: string;
  public serviceName: string;
  public serviceNameEn: string;
  public description: string;
  public characteristics: CharacteristicsArray;

  constructor(serviceId: string,
    serviceType: string,
    serviceName: string,
    serviceNameEn: string,
    description: string,
    characteristics: CharacteristicsArray,
  ) {
    this.serviceId = serviceId;
    this.serviceType = serviceType;
    this.serviceName = serviceName;
    this.serviceNameEn = serviceNameEn;
    this.description = description;
    this.characteristics = characteristics;
  }
}


@Observed
export class CharacteristicsArray extends Array<Characteristics> {
}

@Observed
export class Characteristics {
  public characteristicName: string;
  public characteristicType: CharacteristicType;
  public description: string;
  public method: CharacteristicMethod;
  public permission: CharacteristicPermissions;
  public attrName: string;
  public attrNameEn: string;
  public ecaFlag: string;
  public maxLength: number | undefined;
  public enumList?: EnumList | undefined;
  public unitType?: UnitType | undefined;
  public value?: ControlValue;

  public setMaxLength(value: number | undefined) {
    this.maxLength = value;
  }

  public setEnumList(value: EnumList | undefined) {
    this.enumList = value;
  }

  public setUnitType(value: UnitType | undefined) {
    this.unitType = value;
  }

  public setControlValue(value: ControlValue | undefined) {
    this.value = value;
  }

  constructor(characteristicName: string, characteristicType: CharacteristicType, description: string,
    method: CharacteristicMethod, permission: CharacteristicPermissions, attrName: string, attrNameEn: string,
    ecaFlag: string) {
    this.characteristicName = characteristicName;
    this.characteristicType = characteristicType;
    this.description = description;
    this.method = method;
    this.permission = permission;
    this.attrName = attrName;
    this.attrNameEn = attrNameEn;
    this.ecaFlag = ecaFlag;
  }
}

@Observed
export class EnumList extends Array<EnumEntry> {
}

@Observed
export class EnumEntry {
  public descCh: string;
  public descEn: string;
  public enumVal: ControlValue;

  constructor(descCh: string, descEn: string, enumVal: ControlValue) {
    this.descCh = descCh;
    this.descEn = descEn;
    this.enumVal = enumVal;
  }
}

@Observed
export class UnitType {
  public min: number;
  public max: number;
  public step: number;
  public unit: string;
  public unitEn: string;

  constructor(min: number, max: number, step: number, unit: string, unitEn: string) {
    this.min = min;
    this.max = max;
    this.step = step;
    this.unit = unit;
    this.unitEn = unitEn;
  }
}


const PROFILE_TAG = 'ProfileManager';

@Observed
export class ProfileManager {
  private profileModelList: ProfileModelArray = [];
  private powerOn = false;
  private online = false;
  private deviceId: string = '';
  private projectId: string = '';
  private productId: string = '';
  private gatewayId: string = '';

  async initProfileModel(projectId: string, deviceId: string, productId: string, gatewayId: string) {
    Logger.debug(`initProfileModel projectId = ${projectId}, deviceId = ${deviceId}, productId = ${productId}, gatewayId = ${gatewayId}`);
    this.deviceId = deviceId;
    this.projectId = projectId;
    this.productId = productId;
    this.gatewayId = gatewayId;
    let devSnapshotMsg: DevSnapshotMsg | undefined = undefined;
    DeviceManagerFactory.getDeviceManager()
      .registerDeviceAllSnapshot(PROFILE_TAG, (snapshotMsg: Record<string, ServiceData[] | string>) => {
        let deviceId: string = snapshotMsg['devId'] as string;
        if (deviceId != this.deviceId) {
          return;
        }
        let snapshotData: ServiceData[] = snapshotMsg['services'] as ServiceData[];
        Logger.debug(`registerDeviceAllSnapshot res = ${JSON.stringify(snapshotData)}`);
        this.refreshProfileModel(snapshotData);
      });
    DeviceManagerFactory.getDeviceManager().registerConnectStateChanged(PROFILE_TAG, devInfo => {
      if (devInfo.deviceId != this.deviceId) {
        return;
      }
      this.powerOn = devInfo.action == ConnectType.ONLINE;
      this.online = devInfo.action == ConnectType.ONLINE;
    });
    try {
      Logger.debug(PROFILE_TAG, `===>before getDevSnapshotMsg deviceId： ${deviceId}, projectId： ${projectId}`);
      devSnapshotMsg = await HttpApi.getInstance().getDevSnapshotMsg(deviceId, projectId);
      Logger.debug(PROFILE_TAG, '===>getDevSnapshotMsg', `res0： ${devSnapshotMsg}`);
      Logger.debug(PROFILE_TAG, '===>getDevSnapshotMsg', `res1： ${JSON.stringify(devSnapshotMsg)}`);
    } catch (error) {
      Logger.error('initProfileModel getDevSnapshotMsg', error?.message);
    }
    this.refreshProfileModel(devSnapshotMsg?.services);
  }

  async refreshProfileModel(serviceData: ServiceData[] = []) {
    Logger.debug(PROFILE_TAG, '===>refreshProfileModel', `serviceData： ${JSON.stringify(serviceData)}`);
    try {
      let profileObj = await ProfileStore.getProfile(getContext(this), this.productId); // 'NOXV2'
      let profileBuilder: ProfileBuilder = ProfileBuilder.profileBuilder(profileObj);
      let services = profileBuilder.buildProfileModel().services;
      Logger.debug(PROFILE_TAG, `===>services: ${JSON.stringify(services)}`);
      profileBuilder.initValue(services, serviceData || []);
      this.profileModelList = services;
      let res = this.profileModelList.find(item => (item.serviceId == 'switch'));
      if (res?.characteristics && res?.characteristics?.length > 0) {
        this.powerOn = res?.characteristics[0].value == 1;
        this.online = res?.characteristics[0].value == 1;
      }
    } catch (error) {
      Logger.error('initProfileModel buildProfileModel', error?.message);
    }
  }

  unregisterListener() {
    DeviceManagerFactory.getDeviceManager().unregisterDeviceAllSnapshotChanged(PROFILE_TAG);
    DeviceManagerFactory.getDeviceManager().unRegisterConnectStateChanged(PROFILE_TAG);
  }

  private async getRecordObject() {
    let uint8Array: Uint8Array = await getContext(this).resourceManager.getRawFileContent('profile_0123A.json');
    let textDecoder = new util.TextDecoder('utf-8', { ignoreBOM: true });
    let string = textDecoder.decodeWithStream(uint8Array);
    return JSON.parse(string) as RecordObject;
  }

  getProfileModelList(): ProfileModelArray {
    Logger.info(PROFILE_TAG, `getProfileModelList`, `this.profileModelList: ${JSON.stringify(this.profileModelList)}`);
    let result = this.profileModelList.filter(item => item.serviceName !== '位置信息')
    // 2. 映射生成全新对象，彻底脱离原数组引用
      .map(item => {
        // 深拷贝对象，防止修改原数据
        const newItem = item;
        // 只修改拷贝后的新对象
        if (newItem.serviceName === '开关') {
          newItem.characteristics[0].attrName = '熄屏';
          newItem!.characteristics![0]!.enumList![0]!.descCh = '熄屏';
          newItem!.characteristics![0]!.enumList![1]!.descCh = '亮屏';
        }
        return newItem;
      });
    Logger.info(PROFILE_TAG, `getProfileModelList`, `this.profileModelList123: ${JSON.stringify(result)}`);
    return result;
  }

  isPowerOn(): boolean {
    return this.powerOn;
  }

  isOnline(): boolean {
    return this.online;
  }

  async switchPower() {
    Logger.info(PROFILE_TAG, `===>switchPower this.powerOn: ${this.powerOn}`);
    try {
      await this.controlDeviceByServiceId('switch', 'switch', 'on', this.powerOn ? 0 : 1);
      this.powerOn = !this.powerOn;
      this.online = !this.online;
    } catch (e) {
      Logger.error(PROFILE_TAG, `switchPower error`);
    }
  }

  controlDeviceByServiceId(serviceId: string, serviceType: string, key: string, value: ControlValue): Promise<boolean> {
    Logger.info(PROFILE_TAG,
      `===>controlDeviceByServiceId serviceId: ${serviceId}, serviceType: ${serviceType}, key: ${key}, value: ${value}`);
    let recordData: Record<string, ControlValue> = {};
    recordData[key] = value;
    let option: ControlOption = {
      deviceId: this.deviceId,
      productId: this.productId,
      serviceType: serviceType,
      serviceId: serviceId,
      controlJson: JSON.stringify(recordData),
    };
    return DeviceManagerFactory.getDeviceManager().controlDevice(option);
  }


  controlDevice(serviceId: string, serviceType: string, characteristics: Characteristics, value: ControlValue) {
    if (!isSupportPermissions(characteristics.permission, CharacteristicPermissions.PUT)) {
      Logger.warn(PROFILE_TAG, `serviceName=${serviceId} not support PUT or REPORT`);
      return;
    }
    this.controlDeviceByServiceId(serviceId, serviceType, characteristics.characteristicName,
      value).then((result) => {
      characteristics.value = value;
    });
  }
}

