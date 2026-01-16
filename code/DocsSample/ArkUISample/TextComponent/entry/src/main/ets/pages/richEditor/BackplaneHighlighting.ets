/*
 * Copyright (c) 2025-2026 Huawei Device Co., Ltd.
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


@Entry
@Component
export struct BackplaneHighlighting {
  // [Start richEditor_selection]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  build() {
    // [StartExclude richEditor_selection]
    NavDestination() {
    // [EndExclude richEditor_selection]
      Column({ space: 12 }) {
        RichEditor(this.options)
          .onReady(() => {
            // 请将$r('app.string.BackplaneHighlighting_Text_1')替换为实际资源文件，在本示例中该资源文件的value值为"点击按钮在此处选中0-2位置的文本。"
            this.controller.addTextSpan($r('app.string.BackplaneHighlighting_Text_1'), {
              style: {
                fontColor: Color.Black,
                fontSize: 15
              }
            })
          })
          .width(300)
          .height(60)
        Row() {
          // 请将$r('app.string.BackplaneHighlighting_Button_1')替换为实际资源文件，在本示例中该资源文件的value值为"setSelection(0,2)"
          Button($r('app.string.BackplaneHighlighting_Button_1'), {
            buttonStyle: ButtonStyleMode.NORMAL
          })
            .height(30)
            .fontSize(13)
            .onClick(() => {
              this.controller.setSelection(0, 2)
            })
        }.justifyContent(FlexAlign.Center).width('100%')
      }
    // [StartExclude richEditor_selection]
      .alignItems(HorizontalAlign.Start)
      .backgroundColor('#fff')
      .borderRadius(12)
      .padding(12)
      .width('100%')
    }
    .padding({ left: 12, right: 12 })
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.Backplane_Highlighting_title')替换为实际资源文件，在本示例中该资源文件的value值为"设置组件内的内容选中时部分背板高亮"
    .title($r('app.string.Backplane_Highlighting_title'))
    // [EndExclude richEditor_selection]
  }
  // [End richEditor_selection]
}