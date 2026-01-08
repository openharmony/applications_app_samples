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

// [Start front-end_dependencies]
import { BusinessError } from '@kit.BasicServicesKit';
import { Want, common } from '@kit.AbilityKit';
import { rpc } from '@kit.IPCKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
import { PromptAction  } from '@kit.ArkUI';
import { JSON } from '@kit.ArkTS';

let proxy: rpc.IRemoteObject | undefined;
let connectId : number | undefined;

// 定义返回值，决定弹窗的呈现
let isDisconnect = false;

// 死亡通知
class MyDeathRecipient implements rpc.DeathRecipient {
  onRemoteDied() {
    hilog.info(0x0000, 'testTag', 'IPCClient: server is died');
  }
}
let deathRecipient = new MyDeathRecipient();
// [End front-end_dependencies]

// 定义睡眠时间
async function sleep(ms: number) : Promise<void> {
  return new Promise(resolve => setTimeout(resolve, ms));
}

@Entry
@Component
struct ButtonCase1 {

  // [Start define_context]
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  promptAction: PromptAction = this.getUIContext().getPromptAction();
  // [End define_context]
  pathStack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pathStack) {
      List({ space: 30 }) {
        ListItem() {
          Button('connectAbility').onClick(() => {
            connectAbility(this.context, this.promptAction);
          })
            .width('100%')
        }

        ListItem() {
          Button('sendRequest_string').onClick(() => {
            sendString(this.promptAction);
          })
            .width('100%')
        }

        ListItem() {
          Button('disconnectAbility').onClick(async () => {
            disconnectAbility(this.context);
            await sleep(3000)
            hilog.error(0x0000, 'testTag', 'showToast  isConnectId is ' + isDisconnect );
            if (!isDisconnect) {
              try {
                this.promptAction.showToast({
                  message: 'disConnect failed. Please connect to the service first.',
                  duration: 2000
                });
              } catch (error) {
                let message = (error as BusinessError).message;
                let code = (error as BusinessError).code;
                hilog.error(0x0000, 'testTag', 'showToast failed, code is ' + code + ', message is ' + message);
              };
            }
            // 恢复默认值false
            isDisconnect = false;
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

// [Start funcation_implement]
// [Start connect_ability]
// 连接服务
function connectAbility(context:common.UIAbilityContext, promptAction: PromptAction) {
  hilog.info(0x00000, 'testTag', 'IPCClient: begin to connect Ability');
  let want: Want = {
    bundleName: 'com.example.ipc_stub',
    abilityName: 'ServiceAbility',
  };
  let connect: common.ConnectOptions = {
    onConnect: (elementName, remoteProxy) => {
      hilog.info(0x00000, 'testTag', 'IPCClient: onConnect. elementName is :' + JSON.stringify(elementName));
      proxy = remoteProxy;
      // 客户端注册死亡监听
      try {
        proxy.registerDeathRecipient(deathRecipient, 0);
        hilog.info(0x00000, 'testTag', 'IPCClient: registerDeathRecipient success');
      } catch (err) {
        let code = (err as BusinessError).code;
        let message = (err as BusinessError).message;
        hilog.error(0x0000, 'testTag', 'IPCClient: register failed, code is ' + code + ', message is ' + message);
      }
      // [StartExclude toast]
      // 弹窗显示成功连接服务
      try {
        promptAction.showToast({
          message: 'connectAbility success',
          duration: 2000
        });
      } catch (error) {
        let message = (error as BusinessError).message;
        let code = (error as BusinessError).code;
        hilog.error(0x0000, 'testTag', 'showToast failed, code is ' + code + ', message is ' + message);
      };
      // [EndExclude toast]
    },

    onDisconnect: (elementName) => {
      hilog.info(0x0000, 'testTag', 'IPCClient: onDisconnect. elementName is ' + JSON.stringify(elementName));
      // 客户端移除死亡监听
      try {
        proxy?.unregisterDeathRecipient(deathRecipient, 0);
        hilog.info(0x00000, 'testTag', 'IPCClient: unregisterDeathRecipient success');
      } catch (err) {
        let code = (err as BusinessError).code;
        let message = (err as BusinessError).message;
        hilog.error(0x0000, 'testTag', 'IPCClient: unregister failed, code is ' + code + ', message is ' + message);
      }
      proxy = undefined;
      // [StartExclude toast]
      isDisconnect = true;
      // 弹窗显示与服务端断开连接成功
      try {
        promptAction.showToast({
          message: 'disconnectAbility success',
          duration: 2000
        });
      } catch (error) {
        let message = (error as BusinessError).message;
        let code = (error as BusinessError).code;
        hilog.error(0x0000, 'testTag', 'showToast failed, code is ' + code + ', message is ' + message);
      };
      // [EndExclude toast]
    },

    onFailed: (code: number) => {
      hilog.info(0x0000, 'testTag', 'IPCClient: onFailed. code is ' + code);
      // [StartExclude toast]
      // 弹窗显示连接服务失败
      try {
        promptAction.showToast({
          message: 'Connect failed. Please ensure that the service is running in the background.',
          duration: 2000
        });
      } catch (error) {
        let message = (error as BusinessError).message;
        let code = (error as BusinessError).code;
        hilog.error(0x0000, 'testTag', 'showToast failed, code is ' + code + ', message is ' + message);
      };
      // [EndExclude toast]
    },
  }

  try {
    connectId = context.connectServiceExtensionAbility(want, connect);
    hilog.info(0x00000, 'testTag', 'IPCClient: begin to connect Ability end');
  } catch (err) {
    let code = (err as BusinessError).code;
    let message = (err as BusinessError).message;
    hilog.error(0x0000, 'testTag', 'IPCClient: connectAbility failed, code is ' + code + ', message is ' + message);
  }
}
// [End connect_ability]

// 发送消息
async function sendString(promptAction: PromptAction) : Promise <void> {
  hilog.info(0x00000, 'testTag', 'IPCClient: begin to send String');
  let option = new rpc.MessageOption();
  let data = rpc.MessageSequence.create();
  let reply = rpc.MessageSequence.create();
  // 在data里写入参数，以传递字符串为例
  data.writeString('hello world');
  if (proxy != undefined) {
    await proxy.sendMessageRequest(1, data, reply, option)
      .then((result: rpc.RequestResult) => {
        if (result.errCode != 0) {
          hilog.error(0x0000, 'testTag', 'IPCClient: sendMessageRequest failed, errCode: ' + result.errCode);
        }
        // 从result.reply里读取结果
        let str = result.reply.readString();
        hilog.info(0x0000, 'testTag', 'IPCClient: sendMessageRequest receive str is  ' + str);
        // [StartExclude toast]
        try {
          promptAction.showToast({
            message: 'sendRequest success',
            duration: 2000
          });
        } catch (error) {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          hilog.error(0x0000, 'testTag', 'showToast failed, code is ' + code + ', message is ' + message);
        };
        // [EndExclude toast]
      })
      .catch((e: Error) => {
        hilog.error(0x0000, 'testTag', 'IPCClient: sendMessageRequest failed, error is ' + JSON.stringify(e));
        // [StartExclude toast]
        try {
          promptAction.showToast({
            message: 'sendRequest failed, please connect to the server first',
            duration: 2000
          });
        } catch (error) {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          hilog.error(0x0000, 'testTag', 'showToast failed, code is ' + code + ', message is ' + message);
        };
        // [EndExclude toast]
      })
      .finally(() => {
        data.reclaim();
        reply.reclaim();
      })
  } else {
    hilog.error(0x0000, 'testTag', 'IPCClient: proxy is invalid');
    // [StartExclude toast]
    try {
      promptAction.showToast({
        message: 'sendRequest failed, please connect to the server first',
        duration: 2000
      });
    } catch (error) {
      let message = (error as BusinessError).message;
      let code = (error as BusinessError).code;
      hilog.error(0x0000, 'testTag', 'showToast failed, code is ' + code + ', message is ' + message);
    };
    // [EndExclude toast]
  }
  hilog.info(0x0000, 'testTag', 'IPCClient: sendString end');
}

// 断开连接
function disconnectAbility(context: common.UIAbilityContext) {
  hilog.info(0x00000, 'testTag', 'IPCClient: begin to disconnect Ability. connectId is ' + connectId);
  if (connectId != undefined) {
    try {
      context.disconnectServiceExtensionAbility(connectId);
      hilog.info(0x00000, 'testTag', 'IPCClient: begin to disconnect Ability end');
    } catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      hilog.error(0x0000, 'testTag', 'IPCClient: disconnect failed, code is ' + code + ', message is ' + message);
    }
  }
}
// [End funcation_implement]




