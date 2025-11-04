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

// [Start dialog_example_controller]
import { ComponentContent, promptAction } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

// [Start dialog_params]
class Params {
  public text: string = '';
  public dialogController: promptAction.CommonController = new promptAction.DialogController();

  constructor(text: string, dialogController: promptAction.CommonController) {
    this.text = text;
    this.dialogController = dialogController;
  }
}

// [End dialog_params]

// [Start dialog_my_component]
@Component
struct MyComponent {
  build() {
    Column({ space: 5 }) {
      // $r('app.string.closeDialog_by_custom')需要替换为开发者所需的字符串资源文件
      Button($r('app.string.closeDialog_by_custom'))
        .onClick(() => {
          let dialogController: promptAction.DialogController = this.getDialogController();
          if (dialogController !== undefined) {
            dialogController.close();
          }
        })
    }
  }
}

// [End dialog_my_component]

// [Start build_text]
@Builder
function buildText(params: Params) {
  Column({ space: 5 }) {
    Text(params.text)
      .fontSize(30)
    if (params.dialogController !== undefined) {
      // $r('app.string.closeDialog_by_controller')需要替换为开发者所需的字符串资源文件
      Button($r('app.string.closeDialog_by_controller'))
        .onClick(() => {
          params.dialogController.close();
        })
    }
    MyComponent()
  }
  .width(300)
  .height(200)
  .backgroundColor('#FFF0F0F0')
}

// [End build_text]

// [Start custom_dialog_example]
@CustomDialog
@Component
struct CustomDialogExample {
  controller?: CustomDialogController;

  build() {
    Column({ space: 5 }) {
      // $r('app.string.my_content')需要替换为开发者所需的字符串资源文件
      Text($r('app.string.my_content'))
        .fontSize(30)
      // $r('app.string.closeDialog_by_dialog')需要替换为开发者所需的字符串资源文件
      Button($r('app.string.closeDialog_by_dialog'))
        .onClick(() => {
          let dialogController: PromptActionDialogController = this.getDialogController();
          if (dialogController !== undefined) {
            dialogController.close();
          }
        })
    }
    .height(200)
    .backgroundColor('#FFF0F0F0')
  }
}

// [End custom_dialog_example]

@Entry
@Component
export struct DialogController {
  private message = 'dialog';
  private baseDialogOptions: promptAction.BaseDialogOptions = {
    isModal: false,
    autoCancel: false
  };
  private dialogOptions: promptAction.DialogOptions = {
    isModal: false,
    autoCancel: false
  };

  // [Start dialog_component]
  @Builder
  customDialogComponent(dialogController: promptAction.DialogController) {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(30)
      if (dialogController !== undefined) {
        // $r('app.string.closeDialog_by_outside')需要替换为开发者所需的字符串资源文件
        Button($r('app.string.closeDialog_by_outside'))
          .onClick(() => {
            dialogController.close();
          })
      }
    }
    .height(200)
    .padding(5)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor('#FFF0F0F0')
  }

  // [End dialog_component]

  // [Start dialog_component_id]
  @Builder
  customDialogComponentWithId(dialogId: number, dialogController: promptAction.DialogController) {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(30)
      if (dialogId !== undefined) {
        // $r('app.string.closeDialog_by_id')需要替换为开发者所需的字符串资源文件
        Button($r('app.string.closeDialog_by_id'))
          .onClick(() => {
            this.getUIContext().getPromptAction().closeCustomDialog(dialogId);
          })
      }
      if (dialogController !== undefined) {
        // $r('app.string.closeDialog_by_dialog_controller')需要替换为开发者所需的字符串资源文件
        Button($r('app.string.closeDialog_by_dialog_controller'))
          .onClick(() => {
            dialogController.close();
          })
      }
    }
  }

  // [End dialog_component_id]

  // [Start dialog_component_get_state]
  @Builder
  customDialogComponentGetState(dialogController: promptAction.DialogController) {
    Column({ space: 5 }) {
      Text(this.message)
        .fontSize(30)
      if (dialogController !== undefined) {
        Button($r('app.string.click_check_status'))
          .onClick(() => {
            hilog.info(0x0000, 'dialogController', 'state:' + dialogController.getState());
          })
      }
    }
    .height(200)
    .padding(5)
    .justifyContent(FlexAlign.SpaceBetween)
    .backgroundColor('#FFF0F0F0')
  }

  // [End dialog_component_get_state]

  build() {
    NavDestination() {
      Column({ space: 5 }) {
        Button($r('app.string.open_custom_dialog_with_controller'))
          .onClick(() => {
            // [Start content_node]
            let dialogController: promptAction.CommonController = new promptAction.DialogController();
            let contentNode: ComponentContent<Object> =
              new ComponentContent(this.getUIContext(), wrapBuilder(buildText),
                new Params(this.message, dialogController));
            this.getUIContext().getPromptAction().openCustomDialogWithController(
              contentNode, dialogController, this.baseDialogOptions).catch((err: BusinessError) => {
              hilog.error(0x0000, 'dialogController',
                'openCustomDialogWithController error: ' + err.code + ' ' + err.message);
            });
            // [End content_node]
          })
        Button($r('app.string.present_custom_dialog'))
          .onClick(() => {
            // [Start dialog_controller_component]
            let dialogController: promptAction.CommonController = new promptAction.DialogController();
            this.getUIContext().getPromptAction().presentCustomDialog(() => {
              this.customDialogComponent(dialogController);
            }, dialogController, this.dialogOptions).catch((err: BusinessError) => {
              hilog.error(0x0000, 'dialogController', 'presentCustomDialog error: ' + err.code + ' ' + err.message);
            });
            // [End dialog_controller_component]
          })
        Button($r('app.string.custom_builder_with_id'))
          .onClick(() => {
            // [Start dialog_controller_id]
            let dialogController: promptAction.CommonController = new promptAction.DialogController();
            this.getUIContext().getPromptAction().presentCustomDialog((dialogId: number) => {
              this.customDialogComponentWithId(dialogId, dialogController);
            }, dialogController, this.dialogOptions).catch((err: BusinessError) => {
              hilog.error(0x0000, 'dialogController', 'presentCustomDialog error: ' + err.code + ' ' + err.message);
            });
            // [End dialog_controller_id]
          })
        Button($r('app.string.custom_dialog_controller_dialog'))
          .onClick(() => {
            // [Start custom_dialog_example_click]
            let customDialogController: CustomDialogController = new CustomDialogController({
              builder: CustomDialogExample(),
            });
            customDialogController.open();
            // [End custom_dialog_example_click]
          })
      }.width('100%')
    }
  }
}

// [End dialog_example_controller]
