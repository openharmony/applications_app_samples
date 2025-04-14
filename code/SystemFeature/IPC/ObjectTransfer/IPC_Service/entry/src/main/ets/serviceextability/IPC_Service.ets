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

import { rpc } from '@kit.IPCKit';
import { util } from '@kit.ArkTS';
import hilog from '@ohos.hilog';

const TAG = 'ServerIpc_App2';
const DOMAIN = 0x0000;

// 状态管理,对嵌套类对象属性变化直接观测
@Observed
export class DataStatus {
  public getParcelable: string = '';
  public getArrayBuffer: string = '';

  public updataParcelable(v: string) {
    this.getParcelable = v;
  }

  public updataArrayBuffer(v: string) {
    this.getArrayBuffer = v;
  }
}

export const dataStatus = new DataStatus();

// 提供服务端能力
export class StubServer extends rpc.RemoteObject {
  public str: string | undefined;

  constructor(des: string) {
    super(des);
  }

  onRemoteMessageRequest(code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence,
    options: rpc.MessageOption): boolean | Promise<boolean> {
    hilog.info(DOMAIN, TAG, 'Client Send code:' + code);
    let descriptor = this.getDescriptor();
    // 进行校验
    if (descriptor != data.readInterfaceToken()) {
      hilog.info(DOMAIN, TAG, 'VERIFICATION FAILED');
      return false;
    }

    onHandleClientReq(code, data, reply);
    return true;
  }

  getLocalInterface(descriptor: string): rpc.IRemoteBroker {
    return super.getLocalInterface(descriptor);
  }
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

// 处理接收到的数据
function onHandleClientReq(code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence) {
  hilog.info(DOMAIN, TAG, 'onHandle Client,code:' + code);
  switch (code) {
    // 接收parcelable对象
    case 1001:
      let parcelable = new MyParcelable(0, '');
      data.readParcelable(parcelable);
      dataStatus.updataParcelable(parcelable.str);
      hilog.info(DOMAIN, TAG, 'read parcelable: ' + parcelable.str);
      break;
    // 接收arraybuffer
    case 1002:
      let result = data.readArrayBuffer(rpc.TypeCode.UINT8_ARRAY);
      let decoder = util.TextDecoder.create('utf-8');
      let stringData = decoder.decodeWithStream(new Uint8Array(result));
      dataStatus.updataArrayBuffer(stringData);
      hilog.info(DOMAIN, TAG, 'read arraybuffer: ' + stringData);
      break;
    default:
      hilog.info(DOMAIN, TAG, 'onHandleClient-default,code: ' + 1001);
      break;
  }
}

