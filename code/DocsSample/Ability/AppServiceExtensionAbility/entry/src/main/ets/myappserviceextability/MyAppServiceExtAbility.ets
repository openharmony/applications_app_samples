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

// [Start ability_app_service_one]
// [Start ability_app_service_two]
import { AppServiceExtensionAbility, Want } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';
// [StartExclude ability_app_service_one]
import { BusinessError } from '@kit.BasicServicesKit';
// [EndExclude  ability_app_service_one]
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[MyAppServiceExtAbility]';
// [StartExclude ability_app_service_two]
const DOMAIN_NUMBER: number = 0xFF00;
// [EndExclude  ability_app_service_two]

// [StartExclude ability_app_service_two]
class StubTest extends rpc.RemoteObject {
  constructor(des: string) {
    super(des);
  }

  onRemoteMessageRequest(code: number,
    data: rpc.MessageSequence,
    reply: rpc.MessageSequence,
    options: rpc.MessageOption): boolean | Promise<boolean> {
    // 处理客户端发送的消息
    return true;
  }
}
// [EndExclude  ability_app_service_two]

export default class MyAppServiceExtAbility extends AppServiceExtensionAbility {
  onCreate(want: Want): void {
    // [StartExclude ability_app_service_two]
    let appServiceExtensionContext = this.context;
    hilog.info(DOMAIN_NUMBER, TAG, `onCreate, want: ${want.abilityName}`);
    // [EndExclude  ability_app_service_two]
    // [StartExclude ability_app_service_one]
    // 执行业务逻辑
    this.context.terminateSelf().then(() => {
      hilog.info(0x0000, TAG, '----------- terminateSelf succeed -----------');
    }).catch((error: BusinessError) => {
      hilog.error(0x0000, TAG, `terminateSelf failed, error.code: ${error.code}, error.message: $   {error.message}`);
    });
    // [EndExclude ability_app_service_one]
  }

  // [StartExclude ability_app_service_two]
  onRequest(want: Want, startId: number): void {
    hilog.info(DOMAIN_NUMBER, TAG, `onRequest, want: ${want.abilityName}`);
  }

  onConnect(want: Want): rpc.RemoteObject {
    hilog.info(DOMAIN_NUMBER, TAG, `onConnect, want: ${want.abilityName}`);
    return new StubTest('test');
  }

  onDisconnect(want: Want): void {
    hilog.info(DOMAIN_NUMBER, TAG, `onDisconnect, want: ${want.abilityName}`);
  }

  onDestroy(): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'onDestroy');
  }
  // [EndExclude  ability_app_service_two]
};
// [End ability_app_service_two]
// [End ability_app_service_one]