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

/*
 * 设备库文件接口
 * */
export class LibraryDevice {
  public industryId: string[] = [];
  public industryName: string[] = [];
  public manufacturerId: string = '';
  public manufacturerName: string = '';
  public manufacturerFullName: string = '';
  public deviceTypeId: string = '';
  public deviceTypeName: string = '';
  public productID: string = '';
  public deviceName: string = '';
  public osTypeName: string = '';
  public osVersion: string = '';
  public typicalService: string = '';
  public deviceIcons: string[] = [];
  public deviceModel: string = '';
  public deviceProfile: string = '';
  public industryNameEn: string[] = [];
  public manufacturerNameEn: string = '';
  public manufacturerFullNameEn: string = '';
  public deviceTypeNameEn: string = '';
  public deviceNameEn: string = '';
  public osTypeNameEn: string = '';
  public typicalServiceEn: string = '';
  public pinType: number = 0;
  public ohConnectCertified: boolean = false;
}

/*
 * 设备类
 * */
export class Device {
  public industry: Industry[] = [];
  public manufacturer: Manufacturer = new Manufacturer();
  public deviceType: DeviceType = new DeviceType();
  public productId: string = '';
  public deviceName: string = '';
  public osTypeName: string = '';
  public osVersion: string = '';
  public typicalService: string = '';
  public deviceIcons: string[] = [];
  public deviceModel: string = '';
  public deviceProfile: string = '';
  public pinType: number = 0;
  public oHConnectCertified: boolean = false;
}

/*
 * 厂商类
 * */
export class Manufacturer {
  public manufacturerId: string = '';
  public manufacturerName: string = '';
  public manufacturerFullName: string = '';
}

/*
 * 设备类型
 * */
export class DeviceType {
  public deviceTypeId: string = '';
  public deviceTypeName: string = '';
}

/*
 * 行业类
 * */
export class Industry {
  public industryId: string = '';
  public industryName: string = '';
}

