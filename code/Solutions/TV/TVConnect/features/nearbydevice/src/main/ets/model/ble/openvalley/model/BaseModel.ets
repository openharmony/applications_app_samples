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
import { TimerUtils } from 'library_communication';

export enum Channel {
  ID_INFO = 'idInfo',
  VERSION = 'version',
  RESET = 'reset',
  BASE_INFO = 'baseInfo',
  SUB_INFO = 'subInfo',
  RUN_INFO = 'runInfo',
  CFG_INFO = 'cfgInfo',
  BLE_INFO = 'bleInfo',
  DEV_INFO = 'devInfo',
  SCENE = 'scene',
  MSG = 'msg',
}

export enum Func {
  SET = 'set',
  SET_ACK = 'setAck',
  QUERY = 'query',
  QUERY_ACK = 'queryAck',
  ADD = 'add',
  ADD_ACK = 'addAck',
  UPDATE = 'update',
  UPDATE_ACK = 'updateAck',
  DELETE = 'del',
  DELETE_ACK = 'delAck',
  EXEC = 'exec',
  EXEC_ACK = 'execAck',
  APP2DEV = 'app2dev',
}

export class BaseModel<T> {
  public localId: string;
  public remoteId: string;
  public time: string;
  public channel: Channel;
  public function: Func;
  public payload?: T;

  constructor(localId: string, remoteId: string, channel: Channel, func: Func) {
    this.time = TimerUtils.getCurrentDateTimeFormatted();
    this.localId = localId;
    this.remoteId = remoteId;
    this.channel = channel;
    this.function = func;
  }
}