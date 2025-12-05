/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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

// [Start service_impl]
import { ServiceExtensionAbility, Want } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

// 定义服务端
class Stub extends rpc.RemoteObject {
  constructor(descriptor: string) {
    super(descriptor);
  }
  onRemoteMessageRequest(code: number, data: rpc.MessageSequence, reply: rpc.MessageSequence,
    option: rpc.MessageOption): boolean | Promise<boolean> {
    // 服务端Stub根据不同的请求code分别执行对应的处理流程
    if (code == 1) {
      let str = data.readString();
      hilog.info(0x0000, 'testTag', 'IPCStub: stub receive str : ' + str);
      // 服务端使用reply回传请求处理的结果给客户端
      reply.writeString('hello rpc');
      return true;
    } else {
      hilog.info(0x0000, 'testTag', 'IPCStub: stub unknown code: ' + code);
      return false;
    }
  }
}

// 定义后台服务
export default class ServiceAbility extends ServiceExtensionAbility {
  onCreate(want: Want): void {
    hilog.info(0x0000, 'testTag', 'IPCStub: onCreate');
  }

  onRequest(want: Want, startId: number): void {
    hilog.info(0x0000, 'testTag', 'IPCStub: onRequest');
  }

  onConnect(want: Want): rpc.RemoteObject {
    hilog.info(0x0000, 'testTag', 'IPCStub: onConnect');
    // 返回Stub对象，客户端获取后便可以与ServiceExtensionAbility进行通信
    return new Stub('IPCStubTest');
  }

  onDisconnect(want: Want): void {
    hilog.info(0x0000, 'testTag', 'IPCStub: onDisconnect');
  }

  onDestroy(): void {
    hilog.info(0x0000, 'testTag', 'IPCStub: onDestroy');
  }
}
// [End service_impl]