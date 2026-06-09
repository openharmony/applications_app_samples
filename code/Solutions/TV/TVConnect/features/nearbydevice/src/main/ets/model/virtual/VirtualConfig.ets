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
import { BusinessError } from '@kit.BasicServicesKit';
import { util } from '@kit.ArkTS';
import { Logger } from '@ohos/common';


class SimulateDev {
  public enableSimDevice: boolean = true;
  public devices: Device[] = [];
}

class Device {
  public productID: string = '';
  public sid: string[] = [];
}

export default class VirtualConfig {
  public static instance: VirtualConfig;

  public static getInstance(): VirtualConfig {
    if (VirtualConfig.instance == null) {
      VirtualConfig.instance = new VirtualConfig();
    }
    return VirtualConfig.instance;
  }

  public simulateDev: SimulateDev = new SimulateDev();

  private constructor() {
    this.GetConfig();
  }

  GetConfig() {
    let context = getContext();
    try {
      let value = context.resourceManager.getRawFileContentSync('simulate_device.json');
      let textDecoder = util.TextDecoder.create('utf-8', { ignoreBOM: true });
      let retStr = textDecoder.decodeWithStream(value, { stream: false });
      Logger.info('lxlx' + JSON.stringify(retStr));
      this.simulateDev = JSON.parse(retStr as string) as SimulateDev;
      Logger.info('lxlx' + JSON.stringify(this.simulateDev));
    } catch (error) {
      let code = (error as BusinessError).code;
      let message = (error as BusinessError).message;
      Logger.error(`getRawFileContentSync failed, error code: ${code}, message: ${message}.`);
    }
  }
};