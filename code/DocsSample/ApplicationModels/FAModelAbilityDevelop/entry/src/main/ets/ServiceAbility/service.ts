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

import type Want from '@ohos.app.ability.Want';
import rpc from '@ohos.rpc';
import hilog from '@ohos.hilog';

const TAG: string = '[Sample_FAModelAbilityDevelop]';
const domain: number = 0xFF00;

class FirstServiceAbilityStub extends rpc.RemoteObject {
  constructor(des: Object) {
    if (typeof des === 'string') {
      super(des);
    } else {
      return;
    }
  }

  onRemoteRequest(code: number, data: rpc.MessageParcel, reply: rpc.MessageParcel, option: rpc.MessageOption): boolean {
    hilog.info(domain, TAG, 'ServiceAbility onRemoteRequest called');
    if (code === 1) {
      let string = data.readString();
      hilog.info(domain, TAG, `ServiceAbility string=${string}`);
      let result = Array.from(string).sort().join('');
      hilog.info(domain, TAG, `ServiceAbility result=${result}`);
      reply.writeString(result);
    } else {
      hilog.info(domain, TAG, 'ServiceAbility unknown request code');
    }
    return true;
  }
}

class ServiceAbility {
  onStart(): void {
    hilog.info(domain, TAG, 'ServiceAbility onStart');
  }

  onStop(): void {
    hilog.info(domain, TAG, 'ServiceAbility onStop');
  }

  onCommand(want: Want, startId: number): void {
    hilog.info(domain, TAG, 'ServiceAbility onCommand');
  }

  onConnect(want: Want): rpc.RemoteObject {
    hilog.info(domain, TAG, 'ServiceAbility onDisconnect' + want);
    return new FirstServiceAbilityStub('test');
  }

  onDisconnect(want: Want): void {
    hilog.info(domain, TAG, 'ServiceAbility onDisconnect' + want);
  }
}

export default new ServiceAbility();