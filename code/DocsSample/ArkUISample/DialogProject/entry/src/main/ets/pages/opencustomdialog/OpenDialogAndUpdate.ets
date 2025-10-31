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

// [Start open_dialog_and_update]
// Index.ets
import { ComponentContent } from '@kit.ArkUI';
import { PromptActionClass1 } from '../../common/PromptActionClass1';

class Params {
  public text: string = '';

  constructor(text: string) {
    this.text = text;
  }
}

@Builder
function buildText(params: Params) {
  Column() {
    Text(params.text)
      .fontSize(50)
      .fontWeight(FontWeight.Bold)
      .margin({ bottom: 36 })
    Button('Close')
      .onClick(() => {
        PromptActionClass1.closeDialog();
      })
  }.backgroundColor('#FFF0F0F0')
}

@Entry
@Component
export struct OpenDialogAndUpdate {
  @State message: string = 'hello';
  private ctx: UIContext = this.getUIContext();
  // [Start open_dialog_and_update_create_componentContent]
  private contentNode: ComponentContent<Object> =
    new ComponentContent(this.ctx, wrapBuilder(buildText), new Params(this.message));
  // [End open_dialog_and_update_create_componentContent]
  aboutToAppear(): void {
    PromptActionClass1.setContext(this.ctx);
    PromptActionClass1.setContentNode(this.contentNode);
    PromptActionClass1.setOptions({ alignment: DialogAlignment.Top, offset: { dx: 0, dy: 50 } });
  }

  build() {
    NavDestination() {
      Row() {
        Column() {
          Button('open dialog and update options')
            .margin({ top: 50 })
            .onClick(() => {
              PromptActionClass1.openDialog();

              setTimeout(() => {
                PromptActionClass1.updateDialog({
                  alignment: DialogAlignment.Bottom,
                  offset: { dx: 0, dy: -50 }
                });
              }, 1500)
            })
          Button('open dialog and update content')
            .margin({ top: 50 })
            .onClick(() => {
              PromptActionClass1.openDialog();

              setTimeout(() => {
                // [Start open_dialog_and_update_content]
                this.contentNode.update(new Params('update'));
                // [End open_dialog_and_update_content]
              }, 1500)
            })
        }
        .width('100%')
        .height('100%')
      }
      .height('100%')
    }
  }
}
// [End open_dialog_and_update]