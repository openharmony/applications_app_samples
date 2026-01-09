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

import { ComponentContent, PromptAction, promptAction, UIContext } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

@Builder
export function buildText() {
  Menu() {
    MenuItem({ startIcon: $r('app.media.app_icon') }).width(32).height(32).borderRadius(10)
    MenuItem({ content: 'This is a Popup title 1' })
    MenuItem({ content: 'This is a Popup title 2' })
    MenuItem({ content: 'confirm' }).onClick(() => {
      hilog.error(0x0000, 'openMenuWithTargetIdString', 'confirm button click');
    })
    MenuItem({ content: 'cancel' }).onClick(() => {
      hilog.info(0x0000, 'openMenuWithTargetIdString', 'cancel button click');
    })
  }
}

@Entry
@Component
export struct OpenMenuWithTargetIdString {
  private uiContext: UIContext = this.getUIContext();
  private promptAction: PromptAction = this.uiContext.getPromptAction();
  private contentNode: ComponentContent<Object> =
    new ComponentContent(this.getUIContext(), wrapBuilder(buildText));
  private options: MenuOptions = { enableArrow: true, placement: Placement.Bottom };
  private targetIdString: string = 'button';
  private componentId: number = 0;

  // [Start openMenuWithTargetIdString]
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

        Button('openMenu')
          .onClick(() => {
            let frameNode: FrameNode | null = this.uiContext.getFrameNodeByUniqueId(this.getUniqueId());
            let componentId = frameNode?.getChild(1)?.getChild(0)?.getChild(1)?.getUniqueId();
            if (componentId == undefined) {
              this.componentId = 0;
            } else {
              this.componentId = componentId;
            }
            this.promptAction.openMenu(this.contentNode, { id: this.targetIdString, componentId: this.componentId }, {
              enableArrow: true
            })
              .then(() => {
                hilog.info(0x0000, 'openMenuWithTargetIdString', 'openMenu success');
              })
              .catch((err: BusinessError) => {
                hilog.error(0x0000, 'openMenuWithTargetIdString', 'openMenu error: ' + err.code + ' ' + err.message);
              });
          })
      }
    }
  }
  // [End openMenuWithTargetIdString]
}