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

// [Start prompt_action_class_new]
// PromptActionClassNew.ets
import { BusinessError } from '@kit.BasicServicesKit';
import { ComponentContent, promptAction, UIContext } from '@kit.ArkUI';

export class PromptActionClassNew {
  static ctx: UIContext;
  static contentNode: ComponentContent<Object>;
  static options: promptAction.BaseDialogOptions;

  static setContext(context: UIContext) {
    PromptActionClassNew.ctx = context;
  }

  static setContentNode(node: ComponentContent<Object>) {
    PromptActionClassNew.contentNode = node;
  }

  static setOptions(options: promptAction.BaseDialogOptions) {
    PromptActionClassNew.options = options;
  }

  static openDialog() {
    if (PromptActionClassNew.contentNode !== null) {
      // [Start prompt_action_class_open_custom_dialog]
      PromptActionClassNew.ctx.getPromptAction().openCustomDialog(PromptActionClassNew.contentNode, PromptActionClassNew.options)
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
    if (PromptActionClassNew.contentNode !== null) {
      PromptActionClassNew.ctx.getPromptAction().closeCustomDialog(PromptActionClassNew.contentNode)
        .then(() => {
          console.info('CloseCustomDialog complete.');
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          console.error(`CloseCustomDialog args error code is ${code}, message is ${message}`);
        })
    }
  }

  // [StartExclude prompt_action_class_new]
  static closeDialogAndDispose() {
     // [Start prompt_action_class_close_custom_dialog]
     PromptActionClassNew.ctx.getPromptAction().closeCustomDialog(PromptActionClassNew.contentNode)
     .then(() => {
       console.info('CloseCustomDialog complete.');
       if (this.contentNode !== null) {
            this.contentNode.dispose();   // 释放contentNode
        }
     })
     .catch((error: BusinessError) => {
       let message = (error as BusinessError).message;
       let code = (error as BusinessError).code;
       console.error(`CloseCustomDialog args error code is ${code}, message is ${message}`);
     })
     // [End prompt_action_class_close_custom_dialog]
  }
  // [EndExclude prompt_action_class_new]

  static updateDialog(options: promptAction.BaseDialogOptions) {
    if (PromptActionClassNew.contentNode !== null) {
      // [Start prompt_action_class_update_options]
      PromptActionClassNew.ctx.getPromptAction().updateCustomDialog(PromptActionClassNew.contentNode, options)
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
// [End prompt_action_class_new]