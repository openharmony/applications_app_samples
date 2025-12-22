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
export struct SetUserPresetTextStyles {
  // [Start richEditor_setTypingStyle]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  // [StartExclude richEditor_setTypingStyle]

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        ComponentCard() {
          Column({ space: 3 }) {
            // [EndExclude richEditor_setTypingStyle]
            RichEditor(this.options)
              .onReady(() => {
                // 请将$r('app.string.SetUserPresetTextStyles_Text_1')替换为实际资源文件，在本示例中该资源文件的value值为"点击按钮，改变预设文本样式。"
                this.controller.addTextSpan(resource.resourceToString($r('app.string.SetUserPresetTextStyles_Text_1')),
                  {
                    style: {
                      fontColor: Color.Black,
                      fontSize: 15
                    }
                  })
              })
              .width(300)
              .height(60)
            // 请将$r('app.string.SetUserPresetTextStyles_Button_1')替换为实际资源文件，在本示例中该资源文件的value值为"setTypingStyle"
            Button($r('app.string.SetUserPresetTextStyles_Button_1'), {
              buttonStyle: ButtonStyleMode.NORMAL
            })
              .height(30)
              .fontSize(13)
              .onClick(() => {
                this.controller.setTypingStyle({
                  fontWeight: 'medium',
                  fontColor: Color.Pink,
                  fontSize: 15,
                  fontStyle: FontStyle.Italic,
                  decoration: {
                    type: TextDecorationType.Underline,
                    color: Color.Gray
                  }
                })
              })
            // [End richEditor_setTypingStyle]
          }
        }
      }
      .width('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.Set_User_PresetText_Styles_title')替换为实际资源文件，在本示例中该资源文件的value值为"设置用户预设的文本样式"
    .title($r('app.string.Set_User_PresetText_Styles_title'))
  }
}