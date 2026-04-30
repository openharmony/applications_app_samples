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

import { DeviceType } from '../model/RemoteDeviceModel';

export interface DeviceInfoType {
  deviceId: string;
  deviceName: string;
  deviceType:  DeviceType;
  networkId: string;
  range: number;
}

export interface AuthParam {
  authType: number; // 认证类型： 1 - 无账号PIN码认证
  extraInfo: Record<string, string>;
}
