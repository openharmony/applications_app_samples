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

import { AbilityConstant, UIAbility, Want, Caller } from '@kit.AbilityKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { rpc } from '@kit.IPCKit';

const MSG_SEND_METHOD: string = 'CallSendMsg';
const DOMAIN_NUMBER: number = 0xFF00;
const TAG: string = '[CalleeAbility]';

class MyParcelable {
  public num: number = 0;
  public str: string = '';

  constructor(num: number, string: string) {
    this.num = num;
    this.str = string;
  }

  mySequenceable(num: number, string: string): void {
    this.num = num;
    this.str = string;
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

function sendMsgCallback(data: rpc.MessageSequence): rpc.Parcelable {
  hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'CalleeSortFunc called');

  // 获取Caller发送的序列化数据
  let receivedData: MyParcelable = new MyParcelable(0, '');
  data.readParcelable(receivedData);
  hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', `receiveData[${receivedData.num}, ${receivedData.str}]`);
  let num: number = receivedData.num;

  // 作相应处理
  // 返回序列化数据result给Caller
  return new MyParcelable(num + 1, `send ${receivedData.str} succeed`) as rpc.Parcelable;
}

export default class CalleeAbility extends UIAbility {
  private caller: Caller | undefined;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.callee.on(MSG_SEND_METHOD, sendMsgCallback);
    } catch (error) {
      hilog.error(DOMAIN_NUMBER, TAG, '%{public}s', `Failed to register. Error is ${error}`);
    }
  }

  releaseCall(): void {
    try {
      if (this.caller) {
        this.caller.release();
        this.caller = undefined;
      }
      hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'caller release succeed');
    } catch (error) {
      hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', `caller release failed with ${error}`);
    }
  }

  onDestroy(): void {
    try {
      this.callee.off(MSG_SEND_METHOD);
      hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Callee OnDestroy');
      this.releaseCall();
    } catch (error) {
      hilog.error(DOMAIN_NUMBER, TAG, '%{public}s', `Failed to register. Error is ${error}`);
    }
  }
}