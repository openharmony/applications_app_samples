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

// [Start rpc_front-end_dependencies]
import { BusinessError } from '@kit.BasicServicesKit';
import rpc from '@ohos.rpc';
import hilog from '@ohos.hilog';
import { distributedDeviceManager } from '@kit.DistributedServiceKit';
import { abilityAccessCtrl, PermissionRequestResult, common, Want} from '@kit.AbilityKit';
import { JSON } from '@kit.ArkTS';

let proxy: rpc.IRemoteObject | undefined
let connectId: number | undefined
let dmInstance: distributedDeviceManager.DeviceManager
let deviceList: Array<distributedDeviceManager.DeviceBasicInfo> | undefined;
let deviceId: string| undefined;

// 死亡通知
class MyDeathRecipient implements rpc.DeathRecipient{
  onRemoteDied() {
    hilog.info(0x0000, 'testTag', 'server is died');
  }
};
let deathRecipient = new MyDeathRecipient();
// [End rpc_front-end_dependencies]

@Entry
@Component
struct ButtonCase1 {
  // [Start rpc_define_context]
  private context = this.getUIContext().getHostContext() as common.UIAbilityContext;
  pathStack: NavPathStack = new NavPathStack();
  // [End rpc_define_context]

  build() {

    Navigation(this.pathStack) {
      List({ space: 20 }) {

        ListItem() {
          Button('getPermission').onClick(() => {
            getPermission(this.context);
          })
            .width('100%')
        }

        ListItem() {
          Button('getDeviceId').onClick(() => {
            getDeviceId();
          })
            .width('100%')
        }

        ListItem() {
          Button('connectAbility').onClick(() => {
            connectAbility(this.context);
          })
            .width('100%')
        }

        ListItem() {
          Button('sendRequest_String').onClick(() => {
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

// [Start rpc_funcation_implement]
// [Start rpc_connect]
// 获取权限
function getPermission(context:common.UIAbilityContext) {
  hilog.info(0x00000, 'testTag', 'RpcClient: begin to requestPermissions');
  try {
    let atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
    atManager.requestPermissionsFromUser(context, ['ohos.permission.DISTRIBUTED_DATASYNC'],
      (err: BusinessError, data: PermissionRequestResult) => {
      if (err) {
        hilog.error(0x0000, 'testTag', 'RpcClient: requestPermissions failed, code is ' +
          err.code + ', message is ' + err.message);
      } else {
        hilog.info(0x0000, 'testTag','RpcClient: requestPermissions success, result is ' + JSON.stringify(data));
        hilog.info(0x0000, 'testTag','RpcClient: data permissions is ' + data.permissions);
        hilog.info(0x0000, 'testTag','RpcClient: data authResults is ' + data.authResults);
        hilog.info(0x0000, 'testTag','RpcClient: data dialogShownResults is ' + data.dialogShownResults);
      }
    });
  }catch (err) {
    let code = (err as BusinessError).code;
    let message = (err as BusinessError).message;
    hilog.error(0x0000, 'testTag', 'RpcClient: getPermission failed, code is  ' + code + ', message is ' + message);
  }
}

// 获取对端设备信息
function getDeviceId(){
  hilog.info(0x00000, 'testTag', 'RpcClient: begin to getDeviceId');
  try {
    dmInstance = distributedDeviceManager.createDeviceManager('com.example.rpc_client');
    hilog.info(0x0000, 'testTag', 'RpcClient: createDeviceManager success');
    deviceList = dmInstance.getAvailableDeviceListSync();
    hilog.info(0x0000, 'testTag', 'RpcClient: deviceList is' + JSON.stringify(deviceList));
    if (deviceList.length !== 0) {
      deviceId = deviceList[0].networkId;
      hilog.info(0x0000, 'testTag', 'RpcClient: networkId is ' + deviceId);
    }
  }catch (err) {
    let code = (err as BusinessError).code;
    let message = (err as BusinessError).message;
    hilog.error(0x0000, 'testTag', 'RpcClient: getDeviceId failed, code is  ' + code + ', message is ' + message);
  }
}

// 连接服务
function connectAbility(context:common.UIAbilityContext) {
  hilog.info(0x00000, 'testTag', 'RpcClient: begin to connect Ability');
  let want: Want = {
    bundleName: 'com.example.rpc_stub',
    abilityName: 'ServiceAbility',
    deviceId: deviceId,
  }

  let connect: common.ConnectOptions = {
    onConnect: (elementName, remoteProxy) => {
      hilog.info(0x00000, 'testTag', 'RpcClient: onConnect. elementName is :' +  JSON.stringify(elementName));
      proxy = remoteProxy;
      // 客户端注册死亡监听
      try {
        proxy.registerDeathRecipient(deathRecipient, 0);
        hilog.info(0x00000, 'testTag', 'RpcClient: registerDeathRecipient success');
      }catch (err) {
        let code = (err as BusinessError).code;
        let message = (err as BusinessError).message;
        hilog.error(0x0000, 'testTag', 'RpcClient: register failed, code is ' + code + ', message is ' + message);
      }
    },
    onDisconnect: (elementName) => {
      hilog.info(0x0000, 'testTag', 'RpcClient: onDisconnect. elementName is ' + JSON.stringify(elementName));
      // 客户端移除死亡监听
      try {
        proxy?.unregisterDeathRecipient(deathRecipient, 0);
        hilog.info(0x00000, 'testTag', 'RpcClient: unregisterDeathRecipient success');
      }catch (err) {
        let code = (err as BusinessError).code;
        let message = (err as BusinessError).message;
        hilog.error(0x0000, 'testTag', 'RpcClient: unregister failed, code is ' + code + ', message is ' + message);
      }
      proxy = undefined;
    },
    onFailed: (code: number) => {
      hilog.info(0x0000, 'testTag', 'RpcClient: onFailed. code is :' + code);
    },
  }

  try {
    connectId = context.connectServiceExtensionAbility(want, connect);
  }catch (err) {
    let code = (err as BusinessError).code;
    let message = (err as BusinessError).message;
    hilog.error(0x0000, 'testTag', 'RpcClient: connectService failed, code is ' + code + ', message is ' + message);
  }
}
// [End rpc_connect]

// 断开连接
function disconnectAbility(context: common.UIAbilityContext) {
  hilog.info(0x00000, 'testTag', 'RpcClient: begin to disconnect Ability');
  if (connectId != undefined) {
    try {
      context.disconnectServiceExtensionAbility(connectId);
    }catch (err) {
      let code = (err as BusinessError).code;
      let message = (err as BusinessError).message;
      hilog.error(0x0000, 'testTag', 'pcClient: disconnectService failed, code is ' + code + ', message is ' + message);
    }
  }
}

// 发送消息
function sendString() {
  hilog.info(0x00000, 'testTag', 'RpcClient: begin to send string');
  let option = new rpc.MessageOption();
  let data = rpc.MessageSequence.create();
  let reply = rpc.MessageSequence.create();
  // 在data里写入参数，以传递字符串为例
  data.writeString('hello world');

  if (proxy != undefined) {
    proxy.sendMessageRequest(1, data, reply, option)
      .then((result: rpc.RequestResult) => {
        if (result.errCode != 0) {
          hilog.error(0x0000, 'testTag', 'RpcClient: sendMessageRequest failed, errCode: ' + result.errCode);
          return;
        }
        // 从result.reply里读取结果
        let str = result.reply.readString();
        hilog.info(0x0000, 'testTag', 'RpcClient: sendMessageRequest receiver, str: ' + str);
      })
      .catch((e: Error) => {
        hilog.error(0x0000, 'testTag', 'pcClient: sendMessageRequest failed, error is ' + JSON.stringify(e));
      })
      .finally(() => {
        data.reclaim();
        reply.reclaim();
      })
  }
}
// [End rpc_funcation_implement]


