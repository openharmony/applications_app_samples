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
export struct AddImageContent {
  // [Start richEditor_addImage]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  build() {
    // [StartExclude richEditor_addImage]
    NavDestination() {
    // [EndExclude richEditor_addImage]
      Column({ space: 12 }) {
        RichEditor(this.options)
          .onReady(() => {
            // 请将$r('app.string.AddImageContent_Text_1')替换为实际资源文件，在本示例中该资源文件的value值为"点击按钮在此处添加image"
            this.controller.addTextSpan($r('app.string.AddImageContent_Text_1'), {
              style: {
                fontColor: Color.Black,
                fontSize: 15
              }
            })
          })
          .width(300)
          .height(100)
        Row() {
          // 请将$r('app.string.AddImageContent_Button_1')替换为实际资源文件，在本示例中该资源文件的value值为"addImageSpan"
          Button($r('app.string.AddImageContent_Button_1'), {
            buttonStyle: ButtonStyleMode.NORMAL
          })
            .height(30)
            .fontSize(13)
            .onClick(() => {
              // 请将$r('app.media.xxx')替换为实际资源文件
              this.controller.addImageSpan($r('app.media.startIcon'), {
                imageStyle: {
                  size: ['57px', '57px']
                }
              })
            })
        }.justifyContent(FlexAlign.Center).width('100%')
      }
    // [StartExclude richEditor_addImage]
      .alignItems(HorizontalAlign.Start)
      .backgroundColor('#fff')
      .borderRadius(12)
      .padding(12)
      .width('100%')

    }
    .padding({ left: 12, right: 12 })
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.Add_ImageContent_title')替换为实际资源文件，在本示例中该资源文件的value值为"添加图片内容"
    .title($r('app.string.Add_ImageContent_title'))
    // [EndExclude richEditor_addImage]
  }
  // [End richEditor_addImage]
}
