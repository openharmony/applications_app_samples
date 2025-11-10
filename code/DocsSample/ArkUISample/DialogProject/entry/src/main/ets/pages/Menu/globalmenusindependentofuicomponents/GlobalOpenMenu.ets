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

import {
  ComponentContent,
  Popup,
  PopupButtonOptions,
  PopupIconOptions,
  PopupTextOptions,
  PromptAction,
  UIContext
} from '@kit.ArkUI';
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
  Popup({
    // 类型设置图标内容
    icon: {
      // $r('app.media.app_icon')需要替换为开发者所需的图像资源文件。
      image: $r('app.media.app_icon'),
      width: 32,
      height: 32,
      fillColor: Color.White,
      borderRadius: 10
    } as PopupIconOptions,
    // 设置文字内容
    title: {
      text: `This is a Popup title 1`,
      fontSize: 20,
      fontColor: Color.Black,
      fontWeight: FontWeight.Normal
    } as PopupTextOptions,
    // 设置文字内容
    message: {
      text: `This is a Popup message 1`,
      fontSize: 15,
      fontColor: Color.Black
    } as PopupTextOptions,
    // 设置按钮内容
    buttons: [{
      text: 'confirm',
      action: () => {
        hilog.info(0xFF00, 'globalOpenMenu', 'confirm button click');
      },
      fontSize: 15,
      fontColor: Color.Black,
    },
      {
        text: 'cancel',
        action: () => {
          hilog.info(0xFF00, 'globalOpenMenu', 'cancel button click');
        },
        fontSize: 15,
        fontColor: Color.Black
      },] as [PopupButtonOptions?, PopupButtonOptions?]
  })
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
    this.getUIContext().getPromptAction()
      .openMenu(this.contentNode, { id: targetId }, {
        enableArrow: true
      })
      .then(() => {
        hilog.info(0xFF00, 'globalOpenMenu', 'openMenu success');
      })
      .catch((err: BusinessError) => {
        hilog.error(0xFF00, 'globalOpenMenu', 'openMenu error: ' + err.code + ' ' + err.message);
      });
    // [End open_menu]
  }

  updateMenu() {
    // [Start update_menu]
    this.getUIContext().getPromptAction()
      .updateMenu(this.contentNode, {
        enableArrow: false
      }, true)
      .then(() => {
        hilog.info(0xFF00, 'globalOpenMenu', 'updateMenu success');
      })
      .catch((err: BusinessError) => {
        hilog.error(0xFF00, 'globalOpenMenu', 'updateMenu error: ' + err.code + ' ' + err.message);
      });
    // [End update_menu]
  }

  closeMenu() {
    // [Start close_menu]
    this.getUIContext().getPromptAction()
      .closeMenu(this.contentNode)
      .then(() => {
        hilog.info(0xFF00, 'globalOpenMenu', 'closeMenu success');
      })
      .catch((err: BusinessError) => {
        hilog.error(0xFF00, 'globalOpenMenu', 'closeMenu error: ' + err.code + ' ' + err.message);
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
            let frameNode: FrameNode | null = this.getUIContext().getFrameNodeByUniqueId(this.getUniqueId());
            let targetId = frameNode?.getChild(0)?.getUniqueId();
            // [End frame_node]
            this.openMenu();
          })
      }
    }
  }
}

