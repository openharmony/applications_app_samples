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

import { common } from '@kit.AbilityKit';
import { PromptAction } from '@kit.ArkUI';
import { ClientIpc } from '../client/cnn/IPC_Client';

interface ObtainProxyResults {
  result: string;
}

export const obtainResult: ObtainProxyResults = {
  // 用Result存放代理结果
  result: '',
};

@Entry
@Component
struct Index {
  @State message: string = 'IPC-Client';
  @State inputParcelable: string = '';
  @State inputArrayBuffer: string = '';
  private uiContext: UIContext = this.getUIContext();
  private promptAction: PromptAction = this.uiContext.getPromptAction();

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        List({ space: 30 }) {
          ListItem() {
            Button($r('app.string.GetProxy')).onClick(() => {
              test00(() => {
                // 弹窗提示获取代理结果
                this.promptAction.showToast({
                  message: obtainResult.result,
                  duration: 3000
                });
              })
            })
              .id('IPCproxy')
              .width('100%')
          }

          ListItem() {
            Button($r('app.string.SendParcelable')).onClick(() => {
              test01(this.inputParcelable)
            })
              .id('SendParcelable')
              .width('100%')
          }

          ListItem() {
            TextInput({ placeholder: $r('app.string.Parcelable') })
              .type(InputType.Normal).onChange((text) => {
              this.inputParcelable = text;
            })
              .id('Parcelable')
              .width('80%')
          }

          ListItem() {
            Button($r('app.string.SendArrayBuffer')).onClick(() => {
              test02(this.inputArrayBuffer)
            })
              .id('SendArrayBuffer')
              .width('100%')
          }

          ListItem() {
            TextInput({ placeholder: $r('app.string.ArrayBuffer') })
              .type(InputType.Normal).onChange((text) => {
              this.inputArrayBuffer = text;
            })
              .id('ArrayBuffer')
              .width('80%')
          }

          ListItem() {
            Button($r('app.string.IPCDisconnects')).onClick(() => {
              test03()
            })
              .id('Disconnect')
              .width('100%')
          }
        }
        .listDirection(Axis.Vertical)
        .backgroundColor(0xDCDCDC).padding(20)
      }
      .width('100%')
    }
    .height('100%')
  }
}

function test00(callback: () => void) {
  let cxt = AppStorage.get('ipc_context') as common.UIAbilityContext;
  ClientIpc.bindAbi(cxt, callback);
}

function test01(str: string) {
  ClientIpc.sendParcelable(str);
}

function test02(str: string) {
  ClientIpc.sendArrayBuffer(str);
}

function test03() {
  let cxt = AppStorage.get('ipc_context') as common.UIAbilityContext;
  ClientIpc.unBindAbi(cxt);
}