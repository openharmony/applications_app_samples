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
import { hilog } from '@kit.PerformanceAnalysisKit';
const DOMAIN = 0x0000;

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
          hilog.info(DOMAIN, 'testTag', 'testTag', 'OpenCustomDialog complete.');
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          hilog.error(DOMAIN, 'testTag', 'testTag', 'OpenCustomDialog args error code is ${code}, message is ${message}');
        })
      // [End prompt_action_class_open_custom_dialog]
    }
  }

  static closeDialog() {
    if (PromptActionClassNew.contentNode !== null) {
      PromptActionClassNew.ctx.getPromptAction().closeCustomDialog(PromptActionClassNew.contentNode)
        .then(() => {
          hilog.info(DOMAIN, 'testTag', 'testTag', 'CloseCustomDialog complete.');
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          hilog.error(DOMAIN, 'testTag', 'testTag', 'CloseCustomDialog args error code is ${code}, message is ${message}');
        })
    }
  }

  // [StartExclude prompt_action_class_new]
  static closeDialogAndDispose() {
    // [Start prompt_action_class_close_custom_dialog]
    PromptActionClassNew.ctx.getPromptAction().closeCustomDialog(PromptActionClassNew.contentNode)
      .then(() => {
        hilog.info(DOMAIN, 'testTag', 'testTag', 'CloseCustomDialog complete.g complete.');
        if (this.contentNode !== null) {
          this.contentNode.dispose();   // 释放contentNode
        }
      })
      .catch((error: BusinessError) => {
        let message = (error as BusinessError).message;
        let code = (error as BusinessError).code;
        hilog.error(DOMAIN, 'testTag', 'testTag', 'CloseCustomDialog args error code is ${code}, message is ${message}');
      })
    // [End prompt_action_class_close_custom_dialog]
  }
  // [EndExclude prompt_action_class_new]

  static updateDialog(options: promptAction.BaseDialogOptions) {
    if (PromptActionClassNew.contentNode !== null) {
      // [Start prompt_action_class_update_options]
      PromptActionClassNew.ctx.getPromptAction().updateCustomDialog(PromptActionClassNew.contentNode, options)
        .then(() => {
          hilog.info(DOMAIN, 'testTag', 'testTag', 'UpdateCustomDialog complete.');
        })
        .catch((error: BusinessError) => {
          let message = (error as BusinessError).message;
          let code = (error as BusinessError).code;
          hilog.error(DOMAIN, 'testTag', 'testTag', 'UpdateCustomDialog args error code is ${code}, message is ${message}');
        })
      // [End prompt_action_class_update_options]
    }
  }
}
// [End prompt_action_class_new]