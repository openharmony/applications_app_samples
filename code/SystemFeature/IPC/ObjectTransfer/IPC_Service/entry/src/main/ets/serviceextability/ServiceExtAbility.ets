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
import { ExtensionAbility as ServiceExtensionAbility, Want } from '@kit.AbilityKit';
import hilog from '@ohos.hilog';
import { StubServer } from './IPC_Service';

const TAG = 'ServerIpc_App2';
const DOMAIN = 0x0000;
let globalStubServer: StubServer | undefined;

function getInstance(): StubServer {
  if (globalStubServer == undefined) {
    globalStubServer = new StubServer('serverStub_app2');
  }
  return globalStubServer;
}

export default class ServiceExtension extends ServiceExtensionAbility {
  onCreate(want: Want) {
    hilog.info(DOMAIN, TAG, 'ServiceExtensionAbility onCreate,want param:' + JSON.stringify(want) ?? ' ');
  }

  onRequest(want: Want, startId: number) {
    hilog.info(DOMAIN, TAG,
      'ServiceExtensionAbility onRequest,want param:' + JSON.stringify(want) ?? '+,startId:' + JSON.stringify(startId));
  }

  onConnect(want: Want): rpc.RemoteObject | Promise<rpc.RemoteObject> {
    hilog.info(DOMAIN, TAG, 'ServiceExtensionAbility onConnect,want param:' + JSON.stringify(want) ?? '');
    return getInstance();
  }

  onDisconnect(want: Want) {
    hilog.info(DOMAIN, TAG, 'ServiceExtensionAbility onDisconnect,want param::' + JSON.stringify(want));
  }

  onDestroy() {
    hilog.info(DOMAIN, TAG, 'ServiceExtensionAbility onDestroy');
  }
}
