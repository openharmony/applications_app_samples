/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the 'License');
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

import type { ProcessDataCallback } from './i_idl_service_ext';
import type { InsertDataToMapCallback } from './i_idl_service_ext';
import type IIdlServiceExt from './i_idl_service_ext';
import hilog from '@ohos.hilog';
import rpc from '@ohos.rpc';

const TAG: string = '[IdlServiceExtProxy]';
const DOMAIN_NUMBER: number = 0xFF00;

export default class IdlServiceExtProxy implements IIdlServiceExt {
  static readonly COMMAND_PROCESS_DATA = 1;
  static readonly COMMAND_INSERT_DATA_TO_MAP = 2;
  private proxy;

  constructor(proxy) {
    this.proxy = proxy;
  };

  processData(data: number, callback: ProcessDataCallback): void {
    let option = new rpc.MessageOption();
    let dataSequence = rpc.MessageSequence.create();
    let replySequence = rpc.MessageSequence.create();
    try {
      dataSequence.writeInt(data);
      this.proxy.sendMessageRequest(IdlServiceExtProxy.COMMAND_PROCESS_DATA, dataSequence, replySequence, option).then(function (result) {
        if (result.errCode === 0) {
          let errCodeVar = result.reply.readInt();
          if (errCodeVar !== 0) {
            let returnValueVar = undefined;
            callback(errCodeVar, returnValueVar);
            return;
          }
          let returnValueVar = result.reply.readInt();
          callback(errCodeVar, returnValueVar);
        } else {
          hilog.info(DOMAIN_NUMBER, TAG, 'sendMessageRequest failed, errCode: ' + result.errCode);
        }
      });
    } finally {
      dataSequence.reclaim();
      replySequence.reclaim();
    };
  };

  insertDataToMap(key: string, val: number, callback: InsertDataToMapCallback): void {
    let option = new rpc.MessageOption();
    let dataSequence = rpc.MessageSequence.create();
    let replySequence = rpc.MessageSequence.create();
    try {
      dataSequence.writeString(key);
      dataSequence.writeInt(val);
      this.proxy.sendMessageRequest(IdlServiceExtProxy.COMMAND_INSERT_DATA_TO_MAP, dataSequence, replySequence, option).then(function (result) {
        if (result.errCode === 0) {
          let errCodeVar = result.reply.readInt();
          callback(errCodeVar);
        } else {
          hilog.info(DOMAIN_NUMBER, TAG, 'sendMessageRequest failed, errCode: ' + result.errCode);
        }
      });
    } finally {
      dataSequence.reclaim();
      replySequence.reclaim();
    };
  };
};

