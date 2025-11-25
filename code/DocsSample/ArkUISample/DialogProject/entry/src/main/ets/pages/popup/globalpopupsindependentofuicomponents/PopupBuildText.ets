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

import { ComponentContent, Popup, PopupButtonOptions, PopupIconOptions, PopupTextOptions } from '@kit.ArkUI';
import { PromptActionClass } from './PopupMainPage';
import { BusinessError } from '@kit.BasicServicesKit';
import { hilog } from '@kit.PerformanceAnalysisKit';

class Params {
  private text: string = '';

  constructor(text: string) {
    this.text = text;
  }
}

let message = new Params('hello');
let uiContext = AppStorage.get('UIContext') as UIContext;

// [Start build_text]
@Builder
export function buildText(params: Params) {
  Popup({
    // 类型设置图标内容。
    icon: {
      // $r('app.media.app_icon')需要替换为开发者所需的图像资源文件。
      image: $r('app.media.app_icon'),
      width: 32,
      height: 32,
      fillColor: Color.White,
      borderRadius: 10
    } as PopupIconOptions,
    // 设置文字内容。
    title: {
      text: `This is a Popup title 1`,
      fontSize: 20,
      fontColor: Color.Black,
      fontWeight: FontWeight.Normal
    } as PopupTextOptions,
    // 设置文字内容。
    message: {
      text: `This is a Popup message 1`,
      fontSize: 15,
      fontColor: Color.Black
    } as PopupTextOptions,
    // 设置按钮内容。
    buttons: [{
      text: 'confirm',
      action: () => {
        hilog.info(0xFF00, 'popupBuildText', 'confirm button click');
      },
      fontSize: 15,
      fontColor: Color.Black,
    },
      {
        text: 'cancel',
        action: () => {
          hilog.info(0xFF00, 'popupBuildText', 'cancel button click');
        },
        fontSize: 15,
        fontColor: Color.Black
      },] as [PopupButtonOptions?, PopupButtonOptions?]
  });
}

let contentNode: ComponentContent<Object> =
  new ComponentContent(uiContext, wrapBuilder(buildText), message, { nestingBuilderSupported: true });

// [End build_text]

@Entry
@Component
struct BuildTextExample {
  promptAction = this.getUIContext().getPromptAction();
  private contentNode: ComponentContent<Object> | null = null;
  private uiContext: UIContext = this.getUIContext();

  public openPopup() {
    let frameNode: FrameNode | null = this.uiContext.getFrameNodeByUniqueId(this.getUniqueId());
    let targetId = frameNode?.getChild(0)?.getUniqueId();
    // [Start open_popup]
    this.promptAction.openPopup(this.contentNode, { id: targetId }, {
      enableArrow: true
    })
      .then(() => {
        hilog.info(0xFF00, 'popupBuildText', 'openPopup success');
      })
      .catch((err: BusinessError) => {
        hilog.error(0xFF00, 'popupBuildText', 'openPopup error: ' + err.code + ' ' + err.message);
      });
    // [End open_popup]
  }

  public updatePopup() {
    // [Start update_popup]
    this.promptAction.updatePopup(this.contentNode, {
      enableArrow: false
    }, true)
      .then(() => {
        hilog.info(0xFF00, 'popupBuildText', 'updatePopup success');
      })
      .catch((err: BusinessError) => {
        hilog.error(0xFF00, 'popupBuildText', 'updatePopup error: ' + err.code + ' ' + err.message);
      });
    // [End update_popup]
  }

  public closePopup() {
    // [Start close_popup]
    this.promptAction.closePopup(this.contentNode)
      .then(() => {
        hilog.info(0xFF00, 'popupBuildText', 'closePopup success');
      })
      .catch((err: BusinessError) => {
        hilog.error(0xFF00, 'popupBuildText', 'closePopup error: ' + err.code + ' ' + err.message);
      });
    // [End close_popup]
  }

  build() {
    NavDestination() {
    }
    .backgroundColor('#f1f3f5')
    .title('', {
      backgroundBlurStyle: BlurStyle.COMPONENT_THICK,
      barStyle: BarStyle.STACK
    })
    .title($r('app.string.popup'))
  }
}