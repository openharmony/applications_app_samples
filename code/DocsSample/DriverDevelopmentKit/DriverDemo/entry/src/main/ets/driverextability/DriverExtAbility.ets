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

// [Start driver_service_step4]
import { DriverExtensionAbility } from '@kit.DriverDevelopmentKit';
import { Want } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';

const REQUEST_CODE = 99; // 与扩展外设客户端约定请求码。
// [End driver_service_step4]

// [Start driver_service_step5]
class StubTest extends rpc.RemoteObject {
  // 接收应用传递过来的消息处理，以及将处理的结果返回给客户端。
  onRemoteMessageRequest(code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence,
    option: rpc.MessageOption) {
    if (code === REQUEST_CODE) {
      // 接收应用传递过来的数据。
      // 应用使用多次调用data.writeString()写入多个数据时，驱动可以通过多次调用data.readString()方法接收对应的数据。
      let optFir: string = data.readString();
      // 驱动将数据的处理结果返回给应用。
      // 示例中为接收了"Hello"，并将"Hello World"返回给应用。
      reply.writeString(optFir + ` World`);
    }
    return true;
  }
}
// [End driver_service_step5]

// [Start driver_service_step6]
export default class DriverExtAbility extends DriverExtensionAbility {
  onInit(want: Want) {
    console.info('testTag', `onInit, want: ${want.abilityName}`);
  }

  onRelease() {
    console.info('testTag', `onRelease`);
  }

  onConnect(want: Want) {
    console.info('testTag', `onConnect, want: ${want.abilityName}`);
    return new StubTest('test');
  }

  onDisconnect(want: Want) {
    console.info('testTag', `onDisconnect, want: ${want.abilityName}`);
  }

  onDump(params: Array<string>) {
    console.info('testTag', `onDump, params:` + JSON.stringify(params));
    return ['params'];
  }
}
// [End driver_service_step6]