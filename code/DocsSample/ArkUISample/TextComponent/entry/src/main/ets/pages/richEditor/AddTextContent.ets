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
export struct AddTextContent {
  // [Start richEditor_addText]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };

  build() {
    // [StartExclude richEditor_addText]
    NavDestination() {
    // [EndExclude richEditor_addText]
      Column({ space: 3 }) {
        RichEditor(this.options)
          .onReady(() => {
            // 请将$r('app.string.AddTextContent_Text_1')替换为实际资源文件，在本示例中该资源文件的value值为"点击按钮在此处添加text"
            this.controller.addTextSpan($r('app.string.AddTextContent_Text_1'), {
              style: {
                fontColor: Color.Black,
                fontSize: 15
              }
            })
          })
          .border({ width: 1, color: Color.Gray })
          .constraintSize({
            maxHeight: 100
          })
          .width(300)
          .margin(10)
        Row() {
          // 请将$r('app.string.AddTextContent_Button_1')替换为实际资源文件，在本示例中该资源文件的value值为"addTextSpan"
          Button($r('app.string.AddTextContent_Button_1'), {
            buttonStyle: ButtonStyleMode.NORMAL
          })
          .height(30)
          .fontSize(13)
          .onClick(() => {
            // 请将$r('app.string.AddTextContent_Text_2')替换为实际资源文件，在本示例中该资源文件的value值为"新添加一段文字。"
            this.controller.addTextSpan($r('app.string.AddTextContent_Text_2'))
          })
        }.justifyContent(FlexAlign.Center).width('100%')
      }
    // [StartExclude richEditor_addText]
      .alignItems(HorizontalAlign.Start)
      .backgroundColor('#fff')
      .borderRadius(12)
      .padding(12)
      .width('100%')
    }
    .padding({ left: 12, right: 12 })
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.Add_TextContent_title')替换为实际资源文件，在本示例中该资源文件的value值为"添加文本内容"
    .title($r('app.string.Add_TextContent_title'))
    // [EndExclude richEditor_addText]
  }
  // [End richEditor_addText]
}
