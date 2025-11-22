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

import { BusinessError } from '@kit.BasicServicesKit';
import { Want, common } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';
import { hilog } from '@kit.PerformanceAnalysisKit';


let proxy: rpc.IRemoteObject | undefined;
let connectId: number | undefined;

let want: Want = {
  bundleName: 'com.example.ipc_stub',
  abilityName: 'ServiceAbility',
};

// 死亡通知
class MyDeathRecipient implements rpc.DeathRecipient{
  onRemoteDied() {
    hilog.info(0x0000, 'testTag', 'IPCClient: server is died');
  }
}
let deathRecipient = new MyDeathRecipient();


@Entry
@Component
struct ButtonCase1 {
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  pathStack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pathStack) {
      List({ space: 30 }) {

        ListItem() {
          Button('connectAbility').onClick(() => {
            connectAbility(this.context);
          })
            .width('100%')
        }

        ListItem() {
          Button('sendRequest_string').onClick(() => {
            sendString();
          })
            .width('100%')
        }

        ListItem() {
          Button('disconnectAbility').onClick(() => {
            disconnectAbility(this.context);
          })
            .width('100%')
        }
      }
      .listDirection(Axis.Vertical)
      .backgroundColor(0xDCDCDC).padding(20)
    }
    .mode(NavigationMode.Stack)
  }
}


// 连接服务
function connectAbility(context:common.UIAbilityContext) {
  hilog.info(0x00000, 'testTag', 'IPCClient: begin to connect Ability');

  let connect: common.ConnectOptions = {
    onConnect: (elementName, remoteProxy) => {
      hilog.info(0x00000, 'testTag', 'IPCClient: onConnect. elementName is :' + JSON.stringify(elementName));
      proxy = remoteProxy;
      // 客户端注册死亡监听
      try {
        proxy.registerDeathRecipient(deathRecipient, 0);
        hilog.info(0x00000, 'testTag', 'IPCClient: registerDeathRecipient success');
      }catch (err) {
        let code = (err as BusinessError).code;
        let message = (err as BusinessError).message;
        hilog.error(0x0000, 'testTag', 'IPCClient: registerDeathRecipient failed, code is ' + code + ', message is ' + message);
      }
    },
    onDisconnect: (elementName) => {
      hilog.info(0x0000, 'testTag', 'IPCClient: onDisconnect. elementName is ' + JSON.stringify(elementName));
      // 客户端移除死亡监听
      try {
        proxy?.unregisterDeathRecipient(deathRecipient, 0);
        hilog.info(0x00000, 'testTag', 'IPCClient: unregisterDeathRecipient success');
      }catch (err) {
        let code = (err as BusinessError).code;
        let message = (err as BusinessError).message;
        hilog.error(0x0000, 'testTag', 'IPCClient: unregisterDeathRecipient failed, code is ' + code + ', message is ' + message);
      }
      proxy = undefined;
    },
    onFailed: (code: number) => {
      hilog.info(0x0000, 'testTag', 'IPCClient: onFailed. code is ' + code);
    },
  }

  try {
    connectId = context.connectServiceExtensionAbility(want, connect);
  }catch (err) {
    let code = (err as BusinessError).code;
    let message = (err as BusinessError).message;
    hilog.error(0x0000, 'testTag', 'IPCClient: connectAbility failed, code is ' + code + ', message is ' + message);
  }
}

// 断开连接
function disconnectAbility(context: common.UIAbilityContext) {
  hilog.info(0x00000, 'testTag', 'IPCClient: begin to disconnect Ability');
  if (connectId != undefined) {
    try {
      context.disconnectServiceExtensionAbility(connectId);
    }catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      hilog.error(0x0000, 'testTag', 'IPCClient: disconnectAbility failed, code is ' + code + ', message is ' + message);
    }
  }
}

// 发送消息
function sendString() {
  hilog.info(0x00000, 'testTag', 'IPCClient: begin to send String');
  let option = new rpc.MessageOption();
  let data = rpc.MessageSequence.create();
  let reply = rpc.MessageSequence.create();
  // 在data里写入参数，以传递字符串为例
  data.writeString('hello world');
  if (proxy != undefined) {
    proxy.sendMessageRequest(1, data, reply, option)
      .then((result: rpc.RequestResult) => {
        if (result.errCode != 0) {
          hilog.error(0x0000, 'testTag', 'IPCClient: sendMessageRequest failed, errCode: ' + result.errCode);
          return;
        }
        // 从result.reply里读取结果
        let str = result.reply.readString();
        hilog.info(0x0000, 'testTag', 'IPCClient: sendMessageRequest receive str is  ' + str);
      })
      .catch((e: Error) => {
        hilog.error(0x0000, 'testTag', 'IPCClient: sendMessageRequest failed, error is ' + JSON.stringify(e));
      })
      .finally(() => {
        data.reclaim();
        reply.reclaim();
      })
  }
}


