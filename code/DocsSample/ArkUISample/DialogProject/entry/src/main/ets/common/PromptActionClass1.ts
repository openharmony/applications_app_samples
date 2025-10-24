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

// [Start prompt_action_class1]
// PromptActionClass1.ets
import { BusinessError } from '@kit.BasicServicesKit';
import { ComponentContent, promptAction, UIContext } from '@kit.ArkUI';

export class PromptActionClass1 {
  static ctx: UIContext;
  static contentNode: ComponentContent<Object>;
  static options: promptAction.BaseDialogOptions;

  static setContext(context: UIContext) {
    PromptActionClass1.ctx = context;
  }

  static setContentNode(node: ComponentContent<Object>) {
    PromptActionClass1.contentNode = node;
  }

  static setOptions(options: promptAction.BaseDialogOptions) {
    PromptActionClass1.options = options;
  }

  static openDialog() {
    if (PromptActionClass1.contentNode !== null) {
      // [Start prompt_action_class_open_custom_dialog]
      PromptActionClass1.ctx.getPromptAction().openCustomDialog(PromptActionClass1.contentNode, PromptActionClass1.options)
        .then(() => {
          console.info('OpenCustomDialog complete.');
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          console.error(`OpenCustomDialog args error code is ${code}, message is ${message}`);
        })
      // [End prompt_action_class_open_custom_dialog]
    }
  }

  static closeDialog() {
    if (PromptActionClass1.contentNode !== null) {
      // [Start prompt_action_class_close_custom_dialog]
      PromptActionClass1.ctx.getPromptAction().closeCustomDialog(PromptActionClass1.contentNode)
        .then(() => {
          console.info('CloseCustomDialog complete.');
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          console.error(`CloseCustomDialog args error code is ${code}, message is ${message}`);
        })
      // [End prompt_action_class_close_custom_dialog]
    }
  }

  static updateDialog(options: promptAction.BaseDialogOptions) {
    if (PromptActionClass1.contentNode !== null) {
      // [Start prompt_action_class_update_options]
      PromptActionClass1.ctx.getPromptAction().updateCustomDialog(PromptActionClass1.contentNode, options)
        .then(() => {
          console.info('UpdateCustomDialog complete.');
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          console.error(`UpdateCustomDialog args error code is ${code}, message is ${message}`);
        })
      // [End prompt_action_class_update_options]
    }
  }
}
// [End prompt_action_class1]