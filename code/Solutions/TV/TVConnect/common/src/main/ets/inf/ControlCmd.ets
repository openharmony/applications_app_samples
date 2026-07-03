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
import { Logger } from '../utils/Logger';
import { InfControl, InfDeviceState } from './InfDevicesBusiness';

interface SidBody {
  sid: string;
}

interface QueryStateRequest {
  seq: number;
  data: SidBody[];
}

export interface ServicesResponse {
  seq: number,
  services: InfDeviceState[],
  vendor: InfDeviceState[],
}

function hasProperty(key: string, obj: Object) {
  let keys = Object.keys(obj);
  for (let i = 0; i < keys.length; i++) {
    if (key == keys[i]) {
      return true;
    }
  }
  return false;
}

export function analysisPayload(payloadStr: string) {
  let messageResponse = JSON.parse(payloadStr) as ServicesResponse;
  Logger.info('analysisPayload', `messageResponse: ${messageResponse}`);
  let isVendor = hasProperty('vendor', messageResponse);
  let responseArray = isVendor ? messageResponse?.vendor : messageResponse?.services;
  return responseArray;
}

/**
 *
 * @param seq 递增数字seq
 * @param sid 控制sid
 * @returns
 */
export function buildQueryStateRequest(seq: number, sids: string[]) {
  let dataArray = sids.map((sid) => {
    return { sid: sid } as SidBody;
  });
  let queryStateRequest: QueryStateRequest = { seq: seq, data: dataArray };
  return JSON.stringify(queryStateRequest);
}

/**
 * 关机命令
 */
class SwitchControl implements InfControl {
  private commend: number = 0;

  constructor(commend: number) {
    this.commend = commend;
  }

  getServiceId(): string {
    return 'switch';
  }

  getDataJson(): string {
    return `{\'sid\':\'switch\',\'st\':\'switch\',\'data\':{\'on\':${this.commend}}}`;
  }
}

class CoapSwitchControl implements InfControl {
  private commend: number = 0;

  constructor(commend: number) {
    this.commend = commend;
  }

  getServiceId(): string {
    return 'switch';
  }

  getDataJson(): string {
    return `{'st':'switch','data':{'on':${this.commend}}}`;
  }
}

/**
 * 重启命令
 */
class RestartControl implements InfControl {
  private commend: number = 0;

  constructor(commend: number) {
    this.commend = commend;
  }

  getServiceId(): string {
    return 'restart';
  }

  getDataJson(): string {
    return `{\'sid\':\'restart\',\'st\':\'restart\',\'data\':{\'restart\':${this.commend}}}`;
  }
}

/**
 * 切换
 */
class SwitchScreensControl implements InfControl {
  private commend: number = 0;

  constructor(commend: number) {
    this.commend = commend;
  }

  getServiceId(): string {
    return 'cust.switchScreens';
  }

  getDataJson(): string {
    return `{\'sid\':\'cust.switchScreens\',\'data\':{\'cust.switchScreens\':${this.commend}}}`;
  }
}

/**
 * 隧道控制指令
 */
class WaterDetectorControl implements InfControl {
  private commend: number = 0;

  constructor(commend: number) {
    this.commend = commend;
  }

  getServiceId(): string {
    return 'cust.waterDetector';
  }

  getDataJson(): string {
    return `{\'sid\':\'cust.waterDetector\',\'data\':{\'cust.waterDetector\':${this.commend}}}`;
  }
}

export {
  SwitchControl, SwitchScreensControl, WaterDetectorControl, RestartControl, CoapSwitchControl
};
