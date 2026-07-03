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

import WifiDevicesConnector from './WifiDevicesConnector';
import WifiDevicesDiscover from './WifiDevicesDiscover';
import WifiDeviceBusiness from './WifiDevicesBusiness';
import WifiDevicesParser from './WifiDevicesParser';
import {
  InfDevicesBusiness,
  InfDevicesConnector,
  InfDevicesController,
  InfDevicesDiscover,
  InfDevicesParser,
  ProtocolType,
  SubProtocolType
} from '@ohos/common/Index';

export default class WifiDevicesController implements InfDevicesController {
  public parser: InfDevicesParser = new WifiDevicesParser(this);
  public connector: InfDevicesConnector = new WifiDevicesConnector(this);
  public discover: InfDevicesDiscover = new WifiDevicesDiscover(this);
  public business: InfDevicesBusiness = new WifiDeviceBusiness(this);

  getSubProtocolType(): SubProtocolType {
    return SubProtocolType.wifi_open;
  }

  getDevicesBusiness(): InfDevicesBusiness {
    return this.business;
  }

  getProtocolType(): ProtocolType {
    return ProtocolType.WIFI;
  }

  getDiscover(): InfDevicesDiscover {
    return this.discover;
  }

  getConnector(): InfDevicesConnector {
    return this.connector;
  }

  getParser(): InfDevicesParser {
    return this.parser;
  }

  getName(): string {
    return 'WifiDevicesController';
  }
};