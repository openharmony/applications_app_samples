'use static'
/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

// [Start entry_ability]
// src/main/ets/entryability/EntryAbility.ts
import UIAbility from '@ohos.app.ability.UIAbility';
import AbilityConstant from '@ohos.app.ability.AbilityConstant';
import Want from '@ohos.app.ability.Want';
import window from '@ohos.window';
import rpc from '@ohos.rpc';
import { BusinessError } from '@ohos.base'
import hilog from '@ohos.hilog'

const TAG: string = 'EntryAbility';
const DOMAIN_NUMBER: int = 0x0000;
const MSG_SEND_METHOD: string = 'funA';
const CONST_NUMBER_1: int = 1;
const CONST_NUMBER_2: int = 2;

// ipc通信返回类型的实现，用于数据序列化和反序列化
class MyParcelable implements rpc.Parcelable {
  private num: int;
  private str: string;

  constructor(num: int, str: string) {
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

class EntryAbility extends UIAbility {
  onCreate(want: Want, launchParam: AbilityConstant.LaunchParam): void {
    try {
      // 监听call事件所需的方法并调用
      this.callee.on('funA', (indata: rpc.MessageSequence) => {
        // 获取call事件中传递的所有参数
        hilog.info(DOMAIN_NUMBER, TAG, `FunACall param:  ${indata.readString()}`);
        return new MyParcelable(CONST_NUMBER_1, 'aaa');
      });
      this.callee.on('funB', (data: rpc.MessageSequence) => {
        // 获取call事件中传递的所有参数
        hilog.info(DOMAIN_NUMBER, TAG, `FunBCall param:  ${data.readString()}`);
        return new MyParcelable(CONST_NUMBER_2, 'bbb');
      });
    } catch (error) {
      hilog.info(DOMAIN_NUMBER, TAG,
        `Failed to register callee on. error code: ${error.code}, error message: ${error.message}`);
    }
  }

  onWindowStageCreate(windowStage: window.WindowStage): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'EntryAbility onWindowStageCreate');
    try {
      windowStage.loadContent('pages/Index', (err: BusinessError<void> | null): void => {
        hilog.info(DOMAIN_NUMBER, TAG, 'loadContent entering');
        if (err && err.code) {
          hilog.error(DOMAIN_NUMBER, TAG, 'loadContent error');
          return;
        }
        hilog.info(DOMAIN_NUMBER, TAG, 'loadContent ok');
      });
    } catch (e) {
      hilog.info(DOMAIN_NUMBER, TAG, `loadContent catch error, code: ${e.code}, message: ${e.message}`);
    }
  }
}

// [End entry_ability]