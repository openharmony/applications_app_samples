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
export struct GetGraphicInfoInComponent {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  controller1: RichEditorController = new RichEditorController();
  options1: RichEditorOptions = { controller: this.controller1 }

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard() {
          Column({ space: 3 }) {
            // 创建两个富文本组件
            RichEditor(this.options)
              .onReady(() => {
                this.controller.addTextSpan(
                  resource.resourceToString($r('app.string.GetGraphicInfoInComponent_Text_1')), {
                  style: {
                    fontColor: Color.Black,
                    fontSize: 15
                  }
                })
              })
              .width(300)
              .height(50)
            Text($r('app.string.GetGraphicInfoInComponent_Text_1')).fontSize(10).fontColor(Color.Gray).width(300)
            RichEditor(this.options1)
              .width(300)
              .height(50)
            Button($r('app.string.GetGraphicInfoInComponent_Button_1'), {
              buttonStyle: ButtonStyleMode.NORMAL
            })
              .height(30)
              .fontSize(13)
              .onClick(() => {
                this.controller1.addTextSpan(JSON.stringify(this.controller.getSpans()), {
                  style: {
                    fontColor: Color.Gray,
                    fontSize: 10
                  }
                })
              })
          }
        }
      }
      .width('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.Get_GraphicInfo_In_Component_title'))
  }
}