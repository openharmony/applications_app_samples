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

// [Start page_showAlert1]
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0xF811;
const TAG = '[Sample_ArkTSRouter]';
// [End page_showAlert1]

@Entry
@Component
struct ShowAlert {
  @State message: string = 'Examples of ShowAlert';
  // [Start page_showAlert2]
  // 定义一个返回按钮的点击事件处理函数
  onBackClick(): void {
    // 调用this.getUIContext().getRouter().showAlertBeforeBackPage方法，设置返回询问框的信息
    try {
      this.getUIContext().getRouter().showAlertBeforeBackPage({
        // 请在resources\base\element\string.json文件中配置name为'pageRouter_dialog_context' ，value为非空字符串的资源
        message: this.getUIContext().getHostContext()?.resourceManager.getStringByNameSync('pageRouter_dialog_context') as string, // 设置询问框的内容
      });
    } catch (err) {
      let message = (err as BusinessError).message;
      let code = (err as BusinessError).code;
      hilog.error(DOMAIN, TAG,`Invoke showAlertBeforeBackPage failed, code is ${code}, message is ${message}`);
    }

    // 调用this.getUIContext().getRouter().back()方法，返回上一个页面
    this.getUIContext().getRouter().back();
  }
  // [End page_showAlert2]

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('ShowAlert Dialog', { stateEffect: true, type: ButtonType.Capsule })
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