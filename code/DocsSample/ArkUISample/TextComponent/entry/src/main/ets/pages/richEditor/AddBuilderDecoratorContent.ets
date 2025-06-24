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

import { ComponentCard } from '../../common/Card';
import resource from '../../common/resource';

@Entry
@Component
export struct AddBuilderDecoratorContent {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  private myBuilder: CustomBuilder = undefined

  @Builder
  TextBuilder() {
    Row() {
      Image($r('app.media.startIcon')).width(50).height(50).margin(16)
      Column() {
        Text($r('app.string.AddBuilderDecoratorContent_Text_1')).fontWeight(FontWeight.Bold).fontSize(16)
        Text($r('app.string.AddBuilderDecoratorContent_Text_2')).fontColor('#8a8a8a').fontSize(12)
      }.alignItems(HorizontalAlign.Start)
    }.backgroundColor('#f4f4f4')
    .borderRadius('20')
    .width(220)
  }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard() {
          Column({ space: 3 }) {
            RichEditor(this.options)
              .onReady(() => {
                this.controller.addTextSpan(
                  resource.resourceToString($r('app.string.AddBuilderDecoratorContent_Text_3')), {
                  style: {
                    fontColor: Color.Black,
                    fontSize: 15
                  }
                })
              })
            Button($r('app.string.AddBuilderDecoratorContent_Button_1'), {
              buttonStyle: ButtonStyleMode.NORMAL
            })
              .height(30)
              .fontSize(13)
              .onClick(() => {
                this.myBuilder = () => {
                  this.TextBuilder()
                }
                this.controller.addBuilderSpan(this.myBuilder)
              })
          }
        }
      }
      .width('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Add_Builder_DecoratorContent_title'))
  }
}