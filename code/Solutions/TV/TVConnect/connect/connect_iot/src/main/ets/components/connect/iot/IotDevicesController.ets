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

import {
  InfDevicesBusiness,
  InfDevicesConnector,
  InfDevicesController,
  InfDevicesDiscover,
  InfDevicesParser,
  ProtocolType,
  SubProtocolType
} from '@ohos/common';
import IotDeviceBusiness from './IotDeviceBusiness';
import IotDevicesConnector from './IotDevicesConnector';
import IotDevicesDiscover from './IotDevicesDiscover';
import IotDevicesParser from './IotDevicesParser';

export default class IotDevicesController implements InfDevicesController {
  public parser: InfDevicesParser = new IotDevicesParser();
  public connector: InfDevicesConnector = new IotDevicesConnector();
  public discover: InfDevicesDiscover = new IotDevicesDiscover();
  public business: InfDevicesBusiness = new IotDeviceBusiness(this);

  getDiscover(): InfDevicesDiscover {
    return this.discover;
  }

  getConnector(): InfDevicesConnector {
    return this.connector;
  }

  getDevicesBusiness(): InfDevicesBusiness {
    return this.business;
  }

  getParser(): InfDevicesParser {
    return this.parser;
  }

  getProtocolType(): ProtocolType {
    let protocolType = ProtocolType.WIFI | ProtocolType.BLE;
    return protocolType;
  }

  getSubProtocolType(): SubProtocolType {
    return SubProtocolType.iot_connect;
  }
};