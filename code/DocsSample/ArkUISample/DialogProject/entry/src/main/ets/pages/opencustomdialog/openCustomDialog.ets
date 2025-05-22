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

// [Start open_close_component_content]
import { PromptActionClass } from '../../common/PromptActionClass';
import { ComponentContent } from '@kit.ArkUI';

class Params {
  private text: string = '';

  constructor(text: string) {
    this.text = text;
  }
}

@Builder
function buildText(params: Params) {
  Column() {
    Text($r('app.string.CustomDialog_dialog'))
      .padding({ top: 24, right: 24, left: 24 })
    Row({ space: 8 }) {
      Button() {
        Text($r('app.string.close_dialog'))
          .fontFamily('HarmonyHeiTi')
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_emphasize'))
          .lineHeight(21)
      }
      .onClick(() => {
        setTimeout(() => {
          PromptActionClass.updateDialog({
            alignment: DialogAlignment.Bottom,
            offset: { dx: 0, dy: -50 }
          })
        }, 1500);
         PromptActionClass.closeDialog();
      })
      .layoutWeight(1)
      .backgroundColor(Color.Transparent)
      .width(180)
      .height(40)

      Button() {
        Text($r('app.string.change_dialog'))
          .fontFamily('HarmonyHeiIi')
          .fontWeight(FontWeight.Medium)
          .fontSize($r('sys.float.Body_L'))
          .fontColor($r('sys.color.font_emphasize'))
      }
      .onClick(() => {
        setTimeout(() => {
          PromptActionClass.updateDialog({
            alignment: DialogAlignment.Bottom,
            offset: { dx: 0, dy: -50 }
          })
        }, 150);
      })
      .layoutWeight(1)
      .backgroundColor(Color.Transparent)
      .width(180)
      .height(40)
    }
    .padding({
      top: 8,
      bottom: 16,
      left: 16,
      right: 16
    })
  }
  .width(400)
  .backgroundColor('#FFF0F0F0')
  .borderRadius(32)
}

@Entry
@Component
export struct openCustomDialog {
  @State message: string = 'hello'
  private ctx: UIContext = this.getUIContext();
  // [Start create_component_content]
  private contentNode: ComponentContent<Object> =
    new ComponentContent(this.ctx, wrapBuilder(buildText), new Params(this.message));
  // [End create_component_content]

  aboutToAppear(): void {
    PromptActionClass.setContext(this.ctx);
    PromptActionClass.setContentNode(this.contentNode);
    PromptActionClass.setOptions({ alignment: DialogAlignment.Top, offset: { dx: 0, dy: 50 } });
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {

        Row() {
          Column() {
            Text($r('app.string.change_text'))
              .fontSize(14)
              .fontColor('#666')
            Button('open dialog and update options')
              .id('open')
              .margin({ top: 10, bottom: 50 })
              .onClick(() => {
                PromptActionClass.openDialog();
              })
          }
          .width('100%')
          .height('100%')
        }
        .height('100%')
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.open_customDialog'))
  }
}
// [End open_close_component_content]