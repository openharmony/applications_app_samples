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
export struct AddSymbolSpanContent {
  // [Start richEditor_addSymbol]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  // [StartExclude richEditor_addSymbol]

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard() {
          Column({ space: 3 }) {
            // [EndExclude richEditor_addSymbol]
            // $r('app.string.xxx')需要替换为开发者所需的资源文件
            RichEditor(this.options)
              .onReady(() => {
                this.controller.addTextSpan(resource.resourceToString($r('app.string.AddSymbolSpanContent_Text_1')), {
                  style: {
                    fontColor: Color.Black,
                    fontSize: 15
                  }
                })
              })
              .width(300)
              .height(100)
            Button($r('app.string.AddSymbolSpanContent_Button_1'), {
              buttonStyle: ButtonStyleMode.NORMAL
            })
              .height(30)
              .fontSize(13)
              .onClick(() => {
                // $r('sys.symbol.basketball_fill')需要替换为开发者所需的资源文件
                this.controller.addSymbolSpan($r('sys.symbol.basketball_fill'), {
                  style: {
                    fontSize: 30
                  }
                })
              })
            // [End richEditor_addSymbol]
          }
        }
      }
      .width('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Add_SymbolSpanContent_title'))
  }
}