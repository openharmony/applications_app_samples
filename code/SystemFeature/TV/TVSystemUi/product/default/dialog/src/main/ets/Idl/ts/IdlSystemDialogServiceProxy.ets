/*
 * Copyright (c) 2021-2023 Huawei Device Co., Ltd.
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

import { startDialogCallback } from './IIdlSystemDialogService';
import { sendRemoteObjectCallback } from './IIdlSystemDialogService';
import IIdlSystemDialogService from './IIdlSystemDialogService';
import { rpc } from '@kit.IPCKit';

export default class IdlSystemDialogServiceProxy implements IIdlSystemDialogService {
  constructor(proxy) {
    this.proxy = proxy;
  }

  startDialog(data: Map<string, string>, callback: startDialogCallback): void {
    let _option = new rpc.MessageOption();
    let _data = new rpc.MessageSequence();
    let _reply = new rpc.MessageSequence();
    _data.writeInt(data.size);
    for (let [key, value] of data) {
      _data.writeString(key);
      _data.writeString(value);
    }
    this.proxy.sendRequest(
      IdlSystemDialogServiceProxy.COMMAND_START_DIALOG, _data, _reply, _option
    ).then(function (result) {
      if (result.errCode === 0) {
        let _errCode = result.reply.readInt();
        callback(_errCode);
      } else {
        console.log('sendRequest failed, errCode: ' + result.errCode);
      }
    })
  }

  sendRemoteObject(callback: sendRemoteObjectCallback): void {
    let _option = new rpc.MessageOption();
    let _data = new rpc.MessageSequence();
    let _reply = new rpc.MessageSequence();
    this.proxy.sendRequest(
      IdlSystemDialogServiceProxy.COMMAND_SEND_REMOTE_OBJECT, _data, _reply, _option
    ).then(function (result) {
      if (result.errCode === 0) {
        let _errCode = result.reply.readInt();
        callback(_errCode);
      } else {
        console.log('sendRequest failed, errCode: ' + result.errCode);
      }
    })
  }

  public static readonly COMMAND_START_DIALOG = 1;
  public static readonly COMMAND_SEND_REMOTE_OBJECT = 2;
  private proxy
}

