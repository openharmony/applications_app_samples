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
import { InfDevicesBusiness } from './InfDevicesBusiness';
import { InfDevicesConnector } from './InfDevicesConnector';
import { InfDevicesDiscover } from './InfDevicesDiscover';
import { InfDevicesParser } from './InfDevicesParser';

import { ProtocolType, SubProtocolType } from './TypeEnum';


export declare interface InfDevicesController {
  getDiscover(): InfDevicesDiscover;

  getConnector(): InfDevicesConnector;

  getDevicesBusiness(): InfDevicesBusiness;

  getParser(): InfDevicesParser;

  /**
   * 获取协议类型
   * @returns
   */
  getProtocolType(): ProtocolType;

  /**
   * 获取子协议类型
   * @returns
   */
  getSubProtocolType(): SubProtocolType;
}