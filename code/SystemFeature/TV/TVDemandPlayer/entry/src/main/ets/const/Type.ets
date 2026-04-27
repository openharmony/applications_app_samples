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
import { DeviceType } from '@ohos/utilslibrary/src/main/ets/DistributedManager';
export interface UrlType {
  uri?:string;
  url?: string | Resource;
  type?: string;
  name?:string;
  displayName?: string | Resource;
  resolution?: string;
  resolutions?: Array<string>;
  licenseUri?:string;
  createTime?:string;
  deviceType?:number;
  intro?:string;
  img?: string | Resource;
  description?:string;
}
export interface DataType{
  result:UrlType[];
  responseCode:number;
}
export interface ImgType{
  src:string;
}

export class FoldListType {
  public id:string = 'f_1';
  public name:string ='本地视频';
  public num:number = 0;
  public videoList:UrlType[] =[];

  constructor(id?: string, name?: string) {
    if (id !== undefined) {
      this.id = id;
    }
    if (name !== undefined) {
      this.name = name;
    }
  }
}

export class ArrayType<T> extends Array<T> {
  constructor(args: T[]) {
    if (args instanceof Array) {
      super(...args);
    } else {
      super(args)
    }
  }
}

export interface UrlList {
  uri:string;
  url: string;
  type: string;
  displayName: string;
  defResolution: string;
  deviceType:number;
  resolutions: [];
}


export interface DeviceInfoType {
  deviceId: string;
  deviceName: string;
  deviceType:  DeviceType;
  networkId: string;
  range: number;
}

export interface AuthParam{
  authType: number, // 认证类型： 1 - 无账号PIN码认证
  extraInfo: Record<string,string>
}

export interface PlayerBtnsType{
  id:string;
  defaultImg: Resource;
  activeImg: Resource;
  onclick:Function
}
export interface ItemsType {
  id:string;
  name:string;
  val?:string| number;
  param?:number;
  disable?: boolean;
}

export interface VideoSettingBtnsType  {
  id:string;
  name: string;
  disable:boolean;
  items: ItemsType[];
}

export interface VideoSize {
  width: number;
  height: number;
}