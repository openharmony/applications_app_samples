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

import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0x0000;
// [Start dialog_interaction_3]
@CustomDialog
struct CustomDialogExample {
  @Link textValue: string;
  controller?: CustomDialogController;
  cancel: () => void = () => {
  }
  confirm: () => void = () => {
  }

  build() {
    Column({ space: 20 }) {
      if (this.textValue !== '') {
        //$r('app.string.the_second_page_is')资源文件中的value为'第二个页面的内容为'
        Text($r('app.string.the_second_page_is')+`：${this.textValue}`)
          .fontSize(20)
      } else {
        //$r('app.wether_to_get_the_second_page.the_second_page_is')资源文件中的value为'是否获取第二个页面的内容'
        Text($r('app.string.wether_to_get_the_second_page'))
          .fontSize(20)
      }
      Flex({ justifyContent: FlexAlign.SpaceAround }) {
        Button('cancel')
          .onClick(() => {
            if (this.controller !== undefined) {
              this.controller.close();
              this.cancel();
            }
          }).backgroundColor(0xffffff).fontColor(Color.Black)
        Button('confirm')
          .onClick(() => {
            if (this.controller !== undefined && this.textValue !== '') {
              this.controller.close();
            } else if (this.controller !== undefined) {
              this.getUIContext().getRouter().pushUrl({
                url: 'pages/Index2'
              });
              this.controller.close();
            }
          }).backgroundColor(0xffffff).fontColor(Color.Red)
      }.margin({ bottom: 10 })
    }.borderRadius(10).padding({ top: 20 })
  }
}

@Entry
@Component
export struct DialogInteractionUseButton {
  @State textValue: string = '';
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogExample({
      cancel: () => {
        this.onCancel()
      },
      confirm: () => {
        this.onAccept()
      },
      textValue: this.textValue
    })
  });

  // 在自定义组件即将析构销毁时将dialogController置空
  aboutToDisappear() {
    this.dialogController = null; // 将dialogController置空
  }

  onPageShow() {
    const params = this.getUIContext().getRouter().getParams() as Record<string, string>; // 获取传递过来的参数对象
    if (params) {
      this.dialogController?.open();
      this.textValue = params.info as string; // 获取info属性的值
    }
  }

  onCancel() {
    hilog.info(DOMAIN, 'testTag', 'testTag', 'Callback when the first button is clicked');
  }

  onAccept() {
    hilog.info(DOMAIN, 'testTag', 'testTag', 'Callback when the second button is clicked');
  }

  exitApp() {
    hilog.info(DOMAIN, 'testTag', 'testTag', 'Click the callback in the blank area');
  }

  build() {
    Column() {
      NavDestination() {
        Button('click me')
          .onClick(() => {
            if (this.dialogController !== null) {
              this.dialogController.open();
            }
          }).backgroundColor(0x317aff)
      }.width('100%').margin({ top: 5 })
    }
  }
}
// [End dialog_interaction_3]