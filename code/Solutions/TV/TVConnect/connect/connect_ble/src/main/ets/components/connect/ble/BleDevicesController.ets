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
import BleDevicesParser from './BleDevicesParser';
import BleDevicesConnector from './BleDevicesConnector';
import BleDevicesDiscover from './BleDevicesDiscover';

import BleDeviceBusiness from './BleDevicesBusiness';
import {
  InfDevicesBusiness,
  InfDevicesConnector,
  InfDevicesController,
  InfDevicesDiscover,
  InfDevicesParser,
  ProtocolType,
  SubProtocolType
} from '@ohos/common/index';

export default class BleDevicesController implements InfDevicesController {
  getSubProtocolType(): SubProtocolType {
    return SubProtocolType.ble_open;
  }

  public parser: InfDevicesParser = new BleDevicesParser(this);
  public connector: InfDevicesConnector = new BleDevicesConnector(this);
  public discover: InfDevicesDiscover = new BleDevicesDiscover(this);
  public business: InfDevicesBusiness = new BleDeviceBusiness(this);

  getName(): string {
    return 'ble';
  }

  getParser(): InfDevicesParser {
    return this.parser;
  }

  getConnector(): InfDevicesConnector {
    return this.connector;
  }

  getDiscover(): InfDevicesDiscover {
    return this.discover;
  }

  getDevicesBusiness(): InfDevicesBusiness {
    return this.business;
  }

  getProtocolType(): ProtocolType {
    return ProtocolType.BLE;
  }
};