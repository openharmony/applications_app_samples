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
import { InfDeviceInfo, InfDeviceState, Logger, InfIpInfo } from '@ohos/common';
import { ControlBody, HttpApi, ServiceData } from '@ohos/connect_cloud';
import { ChannelInterface } from './ChannelInterface';
import { ControlOption, QueryInfoOption, QueryOption } from './DeviceManagerInterface';

export default class HttpChannel implements ChannelInterface {
  queryDeviceInfo(option: QueryInfoOption): Promise<InfDeviceInfo> {
    throw new Error('Method not implemented.');
  }

  queryIpInfo(option: QueryInfoOption): Promise<InfIpInfo> {
    throw new Error('Method not implemented.');
  }

  queryDeviceAllServices(option: QueryOption): Promise<InfDeviceState[]> {
    throw new Error('Method not implemented.');
  }

  controlDevice(option: ControlOption): Promise<boolean> {
    Logger.debug('HttpChannel', '===>controlDevice ' + JSON.stringify(option));
    let serviceData: ServiceData = {
      sid: option.serviceId,
      st: option.serviceType,
      data: JSON.parse(option.controlJson)
    };
    let controlBody: ControlBody = {
      devId: option.deviceId || '',
      prodId: option.productId || '',
      services: [serviceData]
    };
    Logger.debug('HttpChannel', 'controlBody ' + JSON.stringify(controlBody));
    return new Promise(async (resolve, reject) => {
      try {
        await HttpApi.getInstance().controlDevice(controlBody);
        resolve(true);
      } catch (e) {
        reject(e);
      }
    });
  }

  queryDeviceState(option: QueryOption): Promise<InfDeviceState[]> {
    throw new Error('Method not implemented.');
  }
};