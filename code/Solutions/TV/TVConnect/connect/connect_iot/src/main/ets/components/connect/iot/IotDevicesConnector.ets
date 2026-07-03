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

import { InfDevice, InfDevicesConnector, Logger, ProtocolType, SubProtocolType } from '@ohos/common';
import IotConstants from './IotConstants';
import IotDevice from './IotDevice';
import IotHelper from './IotHelper';
import { BusinessError } from '@kit.BasicServicesKit';
import Timers from './Timers';

export default class IotDevicesConnector implements InfDevicesConnector {
  connect(device: InfDevice): Promise<boolean> {
    Logger.info(IotConstants.IOT_TAG, `iot connect ${device.getUnionCode()}`);
    if (device.getSubProtocolType() != SubProtocolType.iot_connect) {
      const error: BusinessError<void> = {
        name: IotConstants.IOT_NAME,
        message: IotConstants.IOT_TYPE_ERROR_MSG,
        code: IotConstants.IOT_TYPE_ERROR,
      };
      return Promise.reject(error);
    }
    let iotDevice = device as IotDevice;
    return IotHelper.getInstance().connectDevice(iotDevice);
  }

  getCurrentConnectedDevice(): InfDevice | undefined {
    return IotHelper.getInstance().getConnectDevice();
  }

  async stopConnect(device: InfDevice): Promise<boolean> {
    if (device.getSubProtocolType() != SubProtocolType.iot_connect) {
      const error: BusinessError<void> = {
        name: IotConstants.IOT_NAME,
        message: IotConstants.IOT_TYPE_ERROR_MSG,
        code: IotConstants.IOT_TYPE_ERROR,
      };
      return Promise.reject(error);
    }
    let iotDevice = device as IotDevice;
    IotHelper.getInstance().stopConnect(iotDevice);
    await Timers.delay(500);
    return Promise.resolve(true);
  }
};