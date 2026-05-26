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
export class IpBean {
  public ip: string;

  constructor(ip: string) {
    this.ip = ip;
  }
}

export class IpDeviceInfo {
  public ip: string;
  public udid: string;
  public creatTime: number;
  public status: string = ''; // 设备状态

  constructor(ip: string, uuid: string) {
    this.ip = ip;
    this.udid = uuid;
    this.creatTime = Date.now();
  }
}
