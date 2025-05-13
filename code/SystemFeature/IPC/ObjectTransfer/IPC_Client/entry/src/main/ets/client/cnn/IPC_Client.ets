/*
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

import rpc from '@ohos.rpc';
import Want from '@ohos.app.ability.Want';
import common from '@ohos.app.ability.common';
import hilog from '@ohos.hilog';
import { BusinessError } from '@kit.BasicServicesKit';
import { obtainResult } from '../../pages/Index';
import { util } from '@kit.ArkTS';

const TAG = 'ClientIpc_App1';
const DOMAIN = 0x0000;

let proxy: rpc.IRemoteObject | undefined;
let connectid: number | undefined;
let want: Want = {
  bundleName: 'com.samples.ipc_service',
  abilityName: 'IpcServiceExtAbility',
}

// Parcelable对象
class MyParcelable implements rpc.Parcelable {
  public num: number = 0;
  public str: string = '';

  constructor(num: number, str: string) {
    this.num = num;
    this.str = str;
  }

  marshalling(messageSequence: rpc.MessageSequence): boolean {
    messageSequence.writeInt(this.num);
    messageSequence.writeString(this.str);
    return true;
  }

  unmarshalling(messageSequence: rpc.MessageSequence): boolean {
    this.num = messageSequence.readInt();
    this.str = messageSequence.readString();
    return true;
  }
}

export class ClientIpc {
  static bindAbi(context:
    common.UIAbilityContext, callback: () => void) {
    connectIpc(context, callback);
  }

  static unBindAbi(context: common.UIAbilityContext) {
    disConnectIpc(context);
  }

  // 处理Parcelable数据，调用sendData发送至服务端
  static sendParcelable(str: string) {
    if (proxy == undefined) {
      hilog.info(DOMAIN, TAG, 'undefined proxy');
      return;
    }
    let option = new rpc.MessageOption();
    let data = rpc.MessageSequence.create();
    let reply = rpc.MessageSequence.create();

    // 取决于MyParcelable类如何定义，或需要序列化时准备传递什么数据类型，本示例中MyParcelable是以number和string为例，且服务端接收string
    let parcelable = new MyParcelable(1, str);
    try {
      // 进行校验
      data.writeInterfaceToken(proxy.getDescriptor());
      // 写入Parcelable
      data.writeParcelable(parcelable);
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      hilog.error(DOMAIN, TAG, 'ipc write parcelable fail, errorCode ' + e.code + 'errorMessage:' + e.message);
    }

    sendData(proxy, 1001, data, reply, option);
  }

  // 处理arraybuffer数据，调用sendData发送至服务端
  static sendArrayBuffer(str: string) {
    if (proxy == undefined) {
      hilog.info(DOMAIN, TAG, 'undefined proxy');
      return;
    }
    let option = new rpc.MessageOption();
    let data = rpc.MessageSequence.create();
    let reply = rpc.MessageSequence.create();

    // 将str转为ArrayBuffer
    const encoder = new util.TextEncoder('utf-8');

    // 使用TextEncoder将字符串编码为Uint8Array
    const uint8Array = encoder.encodeInto(str);

    // 将Uint8Array转换为ArrayBuffer
    const arrayBuffer = uint8Array.buffer;
    try {
      // 进行校验
      data.writeInterfaceToken(proxy.getDescriptor());
      // 写入ArrayBuffer
      hilog.error(DOMAIN, TAG, 'arraybuffer:' + uint8Array.toString());
      data.writeArrayBuffer(arrayBuffer, rpc.TypeCode.UINT8_ARRAY);
    } catch (error) {
      let e: BusinessError = error as BusinessError;
      hilog.error(DOMAIN, TAG, 'ipc write parcelable fail, errorCode ' + e.code + 'errorMessage:' + e.message);
    }

    sendData(proxy, 1002, data, reply, option);
  }
}

// 连接服务端
function connectIpc(context: common.UIAbilityContext, callback: () => void) {
  let connect: common.ConnectOptions = {
    onConnect: (elementName, remoteProxy) => {
      hilog.info(DOMAIN, TAG, 'IpcClient:onConnect.callend(server),elementName:' +
      JSON.stringify(elementName));
      proxy = remoteProxy;
      obtainResult.result = 'success';
      callback();
    },
    onDisconnect: (elementName) => {
      hilog.info(DOMAIN, TAG, 'IpcClient onDisconnect:' + elementName);
    },
    onFailed: (code: number) => {
      obtainResult.result = 'error ' + code;
      hilog.info(DOMAIN, TAG, 'IpcClient onFailed,code:' + code);
      callback();
    },
  }

  connectid = context.connectServiceExtensionAbility(want, connect);
  hilog.info(DOMAIN, TAG, 'IpcClient connectid:' + connectid);
}

function disConnectIpc(context: common.UIAbilityContext) {
  if (connectid != undefined) {
    context.disconnectServiceExtensionAbility(connectid);
    proxy = undefined;
  }
}

// 发送信息，arraybuffer和parcelable均调用此处发送至服务端
function sendData(proxy: rpc.IRemoteObject, code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence,
  options: rpc.MessageOption) {
  if (proxy == undefined) {
    hilog.info(DOMAIN, TAG, 'undefined proxy');
    return;
  }
  // 用连接服务成功后返回的对象proxy，进行消息发送
  proxy.sendMessageRequest(code, data, reply, options)
    .then((result: rpc.RequestResult) => {
      if (result.errCode === 0) {
        hilog.info(DOMAIN, TAG, 'sendMessageRequest got result');
        try {
          let rsp = result.reply.readString();
          hilog.info(DOMAIN, TAG, 'IpcClient result.' + rsp);
        } catch (error) {
          let e: BusinessError = error as BusinessError;
          hilog.error(DOMAIN, TAG, 'rpc read exception fail, error is ' + e);
        }
      } else {
        hilog.error(DOMAIN, TAG, 'RPCTest: sendMessageRequest failed, errCode: ' + result.errCode);
      }
    }).catch((e: Error) => {
    hilog.error(DOMAIN, TAG, 'RPCTest: sendMessageRequest got exception: ' + e);
  }).finally(() => {
    hilog.info(DOMAIN, TAG, 'RPCTest: sendMessageRequest ends, reclaim parcel');
    data.reclaim();
    reply.reclaim();
  });
}
