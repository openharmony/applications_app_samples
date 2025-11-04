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
// [Start ability_app_service_three]
import { AppServiceExtensionAbility, Want } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

const TAG: string = '[MyAppServiceExtAbility]';
const DOMAIN_NUMBER: number = 0xFF00;

// 开发者需要在这个类型里对接口进行实现
class Stub extends rpc.RemoteObject {
  onRemoteMessageRequest(code: number,
    data: rpc.MessageSequence,
    reply: rpc.MessageSequence,
    options: rpc.MessageOption): boolean | Promise<boolean> {
    hilog.info(DOMAIN_NUMBER, TAG, 'onRemoteMessageRequest');
    let sum = data.readInt() + data.readInt();
    reply.writeInt(sum);
    return true;
  }
}

// 服务端实现
export default class MyAppServiceExtAbility extends AppServiceExtensionAbility {
  onCreate(want: Want): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'MyAppServiceExtAbility onCreate');
  }

  onDestroy(): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'MyAppServiceExtAbility onDestroy');
  }

  onConnect(want: Want): rpc.RemoteObject {
    hilog.info(DOMAIN_NUMBER, TAG, 'MyAppServiceExtAbility onConnect');
    return new Stub('test');
  }

  onDisconnect(): void {
    hilog.info(DOMAIN_NUMBER, TAG, 'MyAppServiceExtAbility onDisconnect');
  }
}
// [End ability_app_service_three]