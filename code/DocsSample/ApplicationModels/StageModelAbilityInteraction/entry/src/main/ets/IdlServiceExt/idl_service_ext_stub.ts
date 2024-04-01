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
import rpc from '@ohos.rpc';
import hilog from '@ohos.hilog';

const TAG: string = '[IdlServiceExtStub]';
const DOMAIN_NUMBER: number = 0xFF00;

export default class IdlServiceExtStub extends rpc.RemoteObject implements IIdlServiceExt {
  constructor(des: string) {
    super(des);
  };

  async onRemoteMessageRequest(code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence, option: rpc.MessageOption): Promise<boolean> {
    hilog.info(DOMAIN_NUMBER, TAG, 'onRemoteMessageRequest called, code = ' + code);
    switch (code) {
      case IdlServiceExtStub.COMMAND_PROCESS_DATA: {
        let dataVar = data.readInt();
        let promise = new Promise<void>((resolve, reject) => {
          this.processData(dataVar, (errCode, returnValue) => {
            reply.writeInt(errCode);
            if (errCode === 0) {
              reply.writeInt(returnValue);
            }
            resolve();
          });
        });
        await promise;
        return true;
      };
      case IdlServiceExtStub.COMMAND_INSERT_DATA_TO_MAP: {
        let keyVar = data.readString();
        let valVar = data.readInt();
        let promise = new Promise<void>((resolve, reject) => {
          this.insertDataToMap(keyVar, valVar, (errCode) => {
            reply.writeInt(errCode);
            resolve();
          });
        });
        await promise;
        return true;
      };
      default: {
        hilog.info(DOMAIN_NUMBER, TAG, 'invalid request code' + code);
        break;
      }
    }
    return false;
  }

  processData(data: number, callback: ProcessDataCallback): void {
  };

  insertDataToMap(key: string, val: number, callback: InsertDataToMapCallback): void {
  };

  static readonly COMMAND_PROCESS_DATA = 1;
  static readonly COMMAND_INSERT_DATA_TO_MAP = 2;
};