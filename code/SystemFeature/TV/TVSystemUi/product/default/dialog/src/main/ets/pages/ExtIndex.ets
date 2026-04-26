/*
 * Copyright (c) 2021-2023 Huawei Device Co., Ltd.
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

import { rpc } from '@kit.IPCKit';
import Log from '../../../../../../../common/src/main/ets/default/Log';
import type { IDialogParameters } from '../controller/Controller';
import { getDialogServiceController } from '../controller/Controller';
import { BusinessError } from '@kit.BasicServicesKit';
import { inputEventClient, KeyCode } from '@kit.InputKit';
import { Want } from '@kit.AbilityKit';
import { window } from '@kit.ArkUI';

const TAG = 'Dialog-Index';

const storage = LocalStorage.getShared()

@Entry(storage)
@Component
struct Index {
  @LocalStorageProp('connectId') connectId: string = '';
  @LocalStorageProp('windowName') windowName: string = '';
  @LocalStorageProp('parameters') parameters: IDialogParameters = {
    bundleName: '',
    abilityName: ''
  };

  aboutToAppear() {
    Log.showInfo(TAG, `aboutToAppear r ${this.connectId} ${this.windowName} ${JSON.stringify(this.parameters)}`)
  }

  aboutToDisappear() {
    Log.showInfo(TAG, `aboutToDisappear ${this.connectId} ${this.windowName} ${JSON.stringify(this.parameters)}`)
  }

  toExtensionWant(): Want {
    const want: Want = {
      bundleName: this.parameters.bundleName ?? '',
      abilityName: this.parameters.abilityName ?? ''
    };
    if (this.parameters.parameters !== undefined) {
      want.parameters = this.parameters.parameters;
    }
    return want;
  }

  onOk() {
    Log.showDebug(TAG, `onOk start`);

    const controller = getDialogServiceController();
    if (controller === null) {
      Log.showError(TAG, 'onOk: no dialog controller');
      return;
    }
    const remoteObject = controller.getData().get(this.connectId)?.remoteObject;
    if (remoteObject) {
      Log.showDebug(TAG, `onOk ${remoteObject}`);
      let data = rpc.MessageSequence.create();
      let reply = rpc.MessageSequence.create();
      let option = new rpc.MessageOption();
      remoteObject.sendMessageRequest(1, data, reply, option)
        .then(
          (result) => {
            Log.showDebug(TAG, `onOk success ${JSON.stringify(result)}`)
          },
          (error: BusinessError) => {
            Log.showDebug(TAG, `onOk error ${JSON.stringify(error)}`);
            this.onClose();
          }
        ).finally(() => {
        data.reclaim();
        reply.reclaim();
      });
    }
    Log.showInfo(TAG, 'onOk end');
  }

  onClose() {
    Log.showDebug(TAG, `onClose start`);
    const controller = getDialogServiceController();
    controller?.destroyWindow(this.connectId);
    Log.showInfo(TAG, `onClose end`);
  }

  tabStartClick() {
    let keyDown: inputEventClient.KeyEvent = {
      isPressed: true,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };
    let keyUp: inputEventClient.KeyEvent = {
      isPressed: false,
      keyCode: KeyCode.KEYCODE_TAB,
      keyDownDuration: 0,
      isIntercepted: false
    };

    try {
      // 触发tab点击，使默认焦点组件多态样式生效
      inputEventClient.injectEvent({ KeyEvent: keyDown });
      inputEventClient.injectEvent({ KeyEvent: keyUp });
    } catch (e) {
      console.log('tab key event click false')
    }
  }
  build() {
    Row() {
      UIExtensionComponent(this.toExtensionWant())
        .width('100%')
        .height('100%')
        .backgroundColor('#00000000')
        .onReceive((data)=>{
          if (data.isReady == '1') {
            this.tabStartClick()
          }
        })
        .onBlur(()=>{
          try {
            let win = AppStorage.get<window.Window>('win')
             win?.destroyWindow()
          } catch (exception) {
            console.error(`hsqFailed to check whether the window is focused. Cause code: ${exception.code}, message: ${exception.message}`);
          }
        })
        .onTerminated((info: TerminationInfo) => {
          Log.showDebug(TAG, `onTerminated${info.code} start`);
          this.onClose();
          Log.showDebug(TAG, `onTerminated${info.code} end`);
        })
        .onError((info) => {
          Log.showDebug(TAG, `onError${JSON.stringify(info.code)} start`);
          this.onClose();
          Log.showDebug(TAG, `onError${JSON.stringify(info.code)} end`);
        })
    }
    .width('100%')
    .height('100%')
  }
}
