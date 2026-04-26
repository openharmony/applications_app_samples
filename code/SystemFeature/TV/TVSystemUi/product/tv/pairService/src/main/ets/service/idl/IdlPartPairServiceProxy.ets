/**
 * Copyright (c) 2025 Huawei Device Co., Ltd.
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
import { getPairStateCallback } from './IIdlPartPairService';
import IIdlPartPairService from './IIdlPartPairService';
import { rpc } from '@kit.IPCKit';

export default class IdlPartPairServiceProxy implements IIdlPartPairService {
  constructor(proxy) {
    this.proxy = proxy;
  }

  getPairState(callback: getPairStateCallback): void {
    let option = new rpc.MessageOption();
    let dataSequence = rpc.MessageSequence.create();
    let replySequence = rpc.MessageSequence.create();
    dataSequence.writeInterfaceToken(this.proxy.getDescriptor());
    this.proxy.sendMessageRequest(
      IdlPartPairServiceProxy.COMMAND_GET_PAIR_STATE, dataSequence, replySequence, option
    )
      .then((result: rpc.RequestResult) => {
        if (result.errCode === 0) {
          let errCodeVar = result.reply.readInt();
          if (errCodeVar != 0) {
            let returnValueVar = undefined;
            callback(errCodeVar, returnValueVar);
            return;
          }
          let returnValueVar = result.reply.readInt();
          callback(errCodeVar, returnValueVar);
        } else {
          console.log('sendMessageRequest failed, errCode: ' + result.errCode);
        }
      })
      .catch((e: Error) => {
        console.log('sendMessageRequest failed, message: ' + e.message);
      })
      .finally(() => {
        dataSequence.reclaim();
        replySequence.reclaim();
      });
  }

  public static readonly COMMAND_GET_PAIR_STATE = 1;
  private proxy
}

