/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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

import { PromptActionClass } from './PopupMainPage';
import { ComponentContent, PromptAction } from '@kit.ArkUI';

class Params {
  public text: string = '';
  public promptActionClass: PromptActionClass = new PromptActionClass();

  constructor(text: string, promptActionClass: PromptActionClass) {
    this.text = text;
    this.promptActionClass = promptActionClass;
  }
}

@Builder
function buildText(params: Params) {
  Column() {
    Text(params.text)
      .fontSize(20)
      .margin({ top: 10 })
    Button('Update')
      .margin({ top: 10 })
      .width(100)
      .onClick(() => {
        params.promptActionClass.updatePopup({
          enableArrow: false,
        });
      })
    Button('Close')
      .margin({ top: 10 })
      .width(100)
      .onClick(() => {
        params.promptActionClass.closePopup();
      })
  }.width(130).height(150)
}

@Entry
@Component
export struct OpenPopupWithTargetIdString {
  @State message: string = 'hello';
  private uiContext: UIContext = this.getUIContext();
  private promptAction: PromptAction = this.uiContext.getPromptAction();
  private promptActionClass: PromptActionClass = new PromptActionClass();
  private contentNode: ComponentContent<Object> =
    new ComponentContent(this.uiContext, wrapBuilder(buildText), new Params(this.message, this.promptActionClass));
  private options: PopupCommonOptions = { enableArrow: true };
  private targetIdString: string = 'button';
  private componentId: number = 0;

  // [Start openPopupWithTargetIdString]
  build() {
    NavDestination() {
      Column() {
        Row() {
          Button('button1')
            .id(this.targetIdString)
        }

        Row() {
          Button('button2')
            .id(this.targetIdString)
        }

        Button('openPopup')
          .onClick(() => {
            let frameNode: FrameNode | null = this.uiContext.getFrameNodeByUniqueId(this.getUniqueId());
            let componentId = frameNode?.getChild(1)?.getChild(0)?.getChild(1)?.getUniqueId();
            if (componentId == undefined) {
              this.componentId = 0;
            } else {
              this.componentId = componentId;
            }
            this.promptActionClass.setPromptAction(this.promptAction);
            this.promptActionClass.setContentNode(this.contentNode);
            this.promptActionClass.setOptions(this.options);
            this.promptActionClass.setIsPartialUpdate(false);
            this.promptActionClass.setTarget({ id: this.targetIdString, componentId: this.componentId });
            this.promptActionClass.openPopup();
          })
      }
    }
  }
  // [End openPopupWithTargetIdString]
}