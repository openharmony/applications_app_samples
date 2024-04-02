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

import type AbilityConstant from '@ohos.app.ability.AbilityConstant';
import UIAbility from '@ohos.app.ability.UIAbility';
import type Want from '@ohos.app.ability.Want';
import hilog from '@ohos.hilog';
import type rpc from '@ohos.rpc';
import type window from '@ohos.window';
import type { Caller } from '@ohos.app.ability.UIAbility';

const TAG: string = '[CalleeAbility]';
const MSG_SEND_METHOD: string = 'CallSendMsg';
const DOMAIN_NUMBER: number = 0xFF00;

class MyParcelable {
  num: number = 0;
  str: string = '';

  constructor(num: number, string: string) {
    this.num = num;
    this.str = string;
  };

  mySequenceable(num, string): void {
    this.num = num;
    this.str = string;
  };

  marshalling(messageSequence: rpc.MessageSequence): boolean {
    messageSequence.writeInt(this.num);
    messageSequence.writeString(this.str);
    return true;
  };

  unmarshalling(messageSequence: rpc.MessageSequence): boolean {
    this.num = messageSequence.readInt();
    this.str = messageSequence.readString();
    return true;
  };
};

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
};

export default class CalleeAbility extends UIAbility {
  caller: Caller | undefined;

  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      this.callee.on(MSG_SEND_METHOD, sendMsgCallback);
    } catch (error) {
      hilog.error(DOMAIN_NUMBER, TAG, '%{public}s', `Failed to register. Error is ${error}`);
    };
  };

  async onButtonCall(): Promise<void> {
    try {
      let msg: MyParcelable = new MyParcelable(1, 'origin_Msg');
      if (this.caller) {
        await this.caller.call(MSG_SEND_METHOD, msg);
      }
    } catch (error) {
      hilog.info(DOMAIN_NUMBER, TAG, `caller call failed with ${error}`);
    };
  };

  async onButtonCallWithResult(originMsg: string, backMsg: string): Promise<void> {
    try {
      let msg: MyParcelable = new MyParcelable(1, originMsg);
      if (this.caller) {
        const data = await this.caller.callWithResult(MSG_SEND_METHOD, msg);
        hilog.info(DOMAIN_NUMBER, TAG, 'caller callWithResult succeed');
        let result: MyParcelable = new MyParcelable(0, '');
        data.readParcelable(result);
        backMsg = result.str;
        hilog.info(DOMAIN_NUMBER, TAG, `caller result is [${result.num}, ${result.str}]`);
      }
    } catch (error) {
      hilog.info(DOMAIN_NUMBER, TAG, `caller callWithResult failed with ${error}`);
    };
  };

  releaseCall(): void {
    try {
      if (this.caller) {
        this.caller.release();
        this.caller = undefined;
      }
      hilog.info(DOMAIN_NUMBER, TAG, 'caller release succeed');
    } catch (error) {
      hilog.info(DOMAIN_NUMBER, TAG, `caller release failed with ${error}`);
    };
  };

  onWindowStageCreate(windowStage: window.WindowStage): void {
    // 设置UI加载
    windowStage.loadContent('pages/Page_CalleeAbility', (err, data) => {
    });
  };

  onDestroy(): void {
    try {
      this.callee.off(MSG_SEND_METHOD);
      hilog.info(DOMAIN_NUMBER, TAG, '%{public}s', 'Callee OnDestroy');
      this.releaseCall();
    } catch (error) {
      hilog.error(DOMAIN_NUMBER, TAG, '%{public}s', `Failed to register. Error is ${error}`);
    };
  };
};
