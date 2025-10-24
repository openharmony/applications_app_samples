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

import { ComponentContent, PromptAction, promptAction, UIContext } from '@kit.ArkUI';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

class Params {
  public message: string = '';

  constructor(message: string) {
    this.message = message;
  }
}

let message = new Params('hello');
let uiContext = AppStorage.get('UIContext') as UIContext;

// [Start build_text]
@Builder
export function buildText(params: Params) {
  Menu() {
    MenuItem({ startIcon: $r('app.media.app_icon') }).width(32).height(32).borderRadius(10)
    MenuItem({ content: 'This is a Popup title 1' })
    MenuItem({ content: 'This is a Popup title 2' })
    MenuItem({ content: 'confirm' }).onClick(() => {
      hilog.error(0x0000, 'globalOpenMenu', 'confirm button click');
    })
    MenuItem({ content: 'cancel' }).onClick(() => {
      hilog.info(0x0000, 'globalOpenMenu', 'cancel button click');
    })
  }
}

let contentNode: ComponentContent<Object> =
  new ComponentContent(uiContext, wrapBuilder(buildText), message, { nestingBuilderSupported: true });

// [End build_text]

@Entry
@Component
export struct OpenPopup {
  message = new Params('hello');
  private uiContext: UIContext = this.getUIContext();
  public promptAction: PromptAction = this.uiContext.getPromptAction();
  // [Start content_node]
  private contentNode: ComponentContent<Object> =
    new ComponentContent(this.getUIContext(), wrapBuilder(buildText), this.message);
  // [End content_node]
  // [Start menu_options]
  private options: MenuOptions = { enableArrow: true, placement: Placement.Bottom };

  // [End menu_options]

  openMenu() {
    let frameNode: FrameNode | null = this.uiContext.getFrameNodeByUniqueId(this.getUniqueId());
    let targetId = frameNode?.getChild(0)?.getUniqueId();
    // [Start open_menu]
    this.promptAction.openMenu(this.contentNode, { id: targetId }, {
      enableArrow: true
    })
      .then(() => {
        hilog.info(0x0000, 'globalOpenMenu', 'openMenu success');
      })
      .catch((err: BusinessError) => {
        hilog.error(0x0000, 'globalOpenMenu', 'openMenu error: ' + err.code + ' ' + err.message);
      });
    // [End open_menu]
  }

  updateMenu() {
    // [Start update_menu]
    this.promptAction.updateMenu(this.contentNode, {
      enableArrow: false
    }, true)
      .then(() => {
        hilog.info(0x0000, 'globalOpenMenu', 'updateMenu success');
      })
      .catch((err: BusinessError) => {
        hilog.error(0x0000, 'globalOpenMenu', 'updateMenu error: ' + err.code + ' ' + err.message);
      });
    // [End update_menu]
  }

  closeMenu() {
    // [Start close_menu]
    this.promptAction.closeMenu(this.contentNode)
      .then(() => {
        hilog.info(0x0000, 'globalOpenMenu', 'closeMenu success');
      })
      .catch((err: BusinessError) => {
        hilog.error(0x0000, 'globalOpenMenu', 'closeMenu error: ' + err.code + ' ' + err.message);
      });
    // [End close_menu]
  }

  build() {
    NavDestination() {
      Column() {
        Button('openMenu')
          .margin({ top: 50, left: 100 })
          .onClick(() => {
            // [Start frame_node]
            let frameNode: FrameNode | null = this.uiContext.getFrameNodeByUniqueId(this.getUniqueId());
            let targetId = frameNode?.getChild(0)?.getUniqueId();
            // [End frame_node]
            this.openMenu();
          })
      }
    }
  }
}

