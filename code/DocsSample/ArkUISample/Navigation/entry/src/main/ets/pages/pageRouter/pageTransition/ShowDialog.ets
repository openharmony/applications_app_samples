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

// [Start page_showDialog1]
import { promptAction} from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0xF811;
const TAG = '[Sample_ArkTSRouter]';
// [End page_showDialog1]

@Entry
@Component
struct ShowAlert {
  @State message: string = 'Examples of ShowDialog';
  // [Start page_showDialog2]
  onBackClick() {
    // 弹出自定义的询问框
    this.getUIContext().getPromptAction().showDialog({
      // 您还没有完成支付，确定要返回吗？
      message: this.getUIContext().getHostContext()?.resourceManager.getStringByNameSync('pageRouter_dialog_context') as string,
      buttons: [
        {
          text: this.getUIContext().getHostContext()?.resourceManager.getStringByNameSync('pageRouter_dialog_canceled') as string,
          color: '#FF0000'
        },
        {
          text: this.getUIContext().getHostContext()?.resourceManager.getStringByNameSync('pageRouter_dialog_confirmed') as string,
          color: '#0099FF'
        }
      ]
    }).then((result: promptAction.ShowDialogSuccessResponse) => {
      if (result.index === 0) {
        // 用户点击了“取消”按钮
        hilog.info(DOMAIN, TAG, 'User canceled the operation.');
      } else if (result.index === 1) {
        // 用户点击了“确认”按钮
        hilog.info(DOMAIN, TAG, 'User confirmed the operation.');
        // 调用this.getUIContext().getRouter().back()方法，返回上一个页面
        this.getUIContext().getRouter().back();
      }
    }).catch((err: Error) => {
      let message = (err as BusinessError).message;
      let code = (err as BusinessError).code;
      hilog.error(DOMAIN, TAG, `Invoke showDialog failed, code is ${code}, message is ${message}`);
    })
  }
  // [End page_showDialog2]

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button(this.message, { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            this.onBackClick();
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}