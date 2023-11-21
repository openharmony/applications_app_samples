/*
 * Copyright (c) 2022-2023 Huawei Device Co., Ltd.
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

import type AbilityConstant from '@ohos.app.ability.AbilityConstant';
import type Base from '@ohos.base';
import hilog from '@ohos.hilog';
import promptAction from '@ohos.promptAction';
import type rpc from '@ohos.rpc';
import UIAbility from '@ohos.app.ability.UIAbility';
import type Want from '@ohos.app.ability.Want';

const TAG: string = 'WidgetEventCallEntryAbility';
const DOMAIN_NUMBER: number = 0xFF00;
const CONST_NUMBER_1: number = 1;
const CONST_NUMBER_2: number = 2;

class MyParcelable implements rpc.Parcelable {
  num: number;
  str: string;

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

export default class WidgetEventCallEntryAbility extends UIAbility {
  // 如果UIAbility第一次启动，在收到call事件后会触发onCreate生命周期回调
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      // 监听call事件所需的方法
      this.callee.on('funA', (data: rpc.MessageSequence) => {
        // 获取call事件中传递的所有参数
        hilog.info(DOMAIN_NUMBER, TAG, `FunACall param:  ${JSON.stringify(data.readString())}`);
        promptAction.showToast({
          message: 'FunACall param:' + JSON.stringify(data.readString())
        });
        return new MyParcelable(CONST_NUMBER_1, 'aaa');
      });
      this.callee.on('funB', (data: rpc.MessageSequence) => {
        // 获取call事件中传递的所有参数
        hilog.info(DOMAIN_NUMBER, TAG, `FunBCall param:  ${JSON.stringify(data.readString())}`);
        promptAction.showToast({
          message: 'FunBCall param:' + JSON.stringify(data.readString())
        });
        return new MyParcelable(CONST_NUMBER_2, 'bbb');
      });
    } catch (err) {
      hilog.error(DOMAIN_NUMBER, TAG, `Failed to register callee on. Cause: ${JSON.stringify(err as Base.BusinessError)}`);
    };
  }

  // 进程退出时，解除监听
  onDestroy(): void | Promise<void> {
    try {
      this.callee.off('funA');
      this.callee.off('funB');
    } catch (err) {
      hilog.error(DOMAIN_NUMBER, TAG, `Failed to register callee off. Cause: ${JSON.stringify(err as Base.BusinessError)}`);
    };
  }
}