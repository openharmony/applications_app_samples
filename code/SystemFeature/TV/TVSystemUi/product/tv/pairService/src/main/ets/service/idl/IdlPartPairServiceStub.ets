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

export default class IdlPartPairServiceStub extends rpc.RemoteObject implements IIdlPartPairService {
  constructor(des: string) {
    super(des);
  }

  async onRemoteMessageRequest(code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence,
    option: rpc.MessageOption): Promise<boolean> {
    let localDescriptor = this.getDescriptor();
    let remoteDescriptor = data.readInterfaceToken();
    if (localDescriptor != remoteDescriptor) {
      console.log('invalid interfaceToken');
      return false;
    }
    console.log('onRemoteMessageRequest called, code = ' + code);
    switch (code) {
      case IdlPartPairServiceStub.COMMAND_GET_PAIR_STATE: {
        let promise = new Promise<void>((resolve, reject) => {
          this.getPairState((errCode, returnValue) => {
            reply.writeInt(errCode);
            if (errCode == 0) {
              reply.writeInt(returnValue);
            }
            resolve();
          });
        });
        await promise;
        return true;
      }
      default: {
        console.log('invalid request code' + code);
        break;
      }
    }
    return false;
  }

  getPairState(callback: getPairStateCallback): void {
  }

  public static readonly COMMAND_GET_PAIR_STATE = 1;
}

