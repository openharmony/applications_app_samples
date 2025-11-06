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

// [Start main_page]
// entry/src/main/ets/components/MainPage.ets
import { BusinessError } from '@kit.BasicServicesKit';
import { ComponentContent, TargetInfo, PromptAction } from '@kit.ArkUI';
import { hilog } from '@kit.PerformanceAnalysisKit';

const DOMAIN = 0x0000;

export class PromptActionClass {
  private promptAction: PromptAction | null = null;
  private contentNode: ComponentContent<Object> | null = null;
  private options: PopupCommonOptions | null = null;
  private target: TargetInfo | null = null;
  private isPartialUpdate: boolean = false;

  public setPromptAction(promptAction: PromptAction) {
    this.promptAction = promptAction;
  }

  public setContentNode(node: ComponentContent<Object>) {
    this.contentNode = node;
  }

  public setTarget(target: TargetInfo) {
    this.target = target;
  }

  public setOptions(options: PopupCommonOptions) {
    this.options = options;
  }

  public setIsPartialUpdate(isPartialUpdate: boolean) {
    this.isPartialUpdate = isPartialUpdate;
  }

  public openPopup() {
    if (this.promptAction != null) {
      this.promptAction.openPopup(this.contentNode, this.target, this.options)
        .then(() => {
          hilog.info(DOMAIN, 'popupMainPage', 'openPopup success');
        })
        .catch((err: BusinessError) => {
          hilog.error(DOMAIN, 'popupMainPage', 'openPopup error: ' + err.code + ' ' + err.message);
        });
    }
  }

  public closePopup() {
    if (this.promptAction != null) {
      this.promptAction.closePopup(this.contentNode)
        .then(() => {
          hilog.info(DOMAIN, 'popupMainPage', 'closePopup success');
        })
        .catch((err: BusinessError) => {
          hilog.error(DOMAIN, 'popupMainPage', 'closePopup error: ' + err.code + ' ' + err.message);
        });
    }
  }

  public updatePopup(options: PopupCommonOptions) {
    if (this.promptAction != null) {
      this.promptAction.updatePopup(this.contentNode, options, this.isPartialUpdate)
        .then(() => {
          hilog.info(DOMAIN, 'popupMainPage', 'updatePopup success');
        })
        .catch((err: BusinessError) => {
          hilog.error(DOMAIN, 'popupMainPage', 'updatePopup error: ' + err.code + ' ' + err.message);
        });
    }
  }
}

// [End main_page]

