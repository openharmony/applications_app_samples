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
import { Payload } from '../payload/Payload';
import { Channel, Func } from '../BaseModel';
import { ModelReq } from '../ModelReq';

export class ControllerDevReq extends ModelReq<ControllerDevPayload> {
  constructor(localId: string, remoteId: string, devArray: Array<DevControlInformation>) {
    super(localId, remoteId, Channel.DEV_INFO, Func.SET);
    const payload: ControllerDevPayload = new ControllerDevPayload(devArray);
    this.payload = payload;
  }
}


export class ControllerDevPayload extends Payload {
  public setType: string = 'control';
  public devSum: number;
  public devArray: Array<DevControlInformation>;

  constructor(devArray: Array<DevControlInformation>) {
    super();
    this.devArray = devArray;
    this.devSum = this.devArray.length;
  }
}

export class DevControlInformation {
  public sn: string;
  public information: ControllerInformation;

  constructor(sn: string, information: ControllerInformation) {
    this.sn = sn;
    this.information = information;
  }
}

/**
 * 控制指令
 */
export class ControllerInformation {
  public status: string;

  constructor(status: string) {
    this.status = status;
  }
}
