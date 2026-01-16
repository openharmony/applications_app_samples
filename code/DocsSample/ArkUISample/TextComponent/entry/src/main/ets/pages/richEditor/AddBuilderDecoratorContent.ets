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
export struct AddBuilderDecoratorContent {
  // [Start richEditor_addBuilder]
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  private myBuilder: CustomBuilder = undefined;

  @Builder
  TextBuilder() {
    Row() {
      Image($r('app.media.startIcon')).width(50).height(50).margin(16)
      Column() {
        // 请将$r('app.string.AddBuilderDecoratorContent_Text_1')替换为实际资源文件，在本示例中该资源文件的value值为"文本文档.txt"        
        Text($r('app.string.AddBuilderDecoratorContent_Text_1')).fontWeight(FontWeight.Bold).fontSize(16)
        // 请将$r('app.string.AddBuilderDecoratorContent_Text_2')替换为实际资源文件，在本示例中该资源文件的value值为"123.45KB"
        Text($r('app.string.AddBuilderDecoratorContent_Text_2')).fontColor('#8a8a8a').fontSize(12)
      }.alignItems(HorizontalAlign.Start)
    }.backgroundColor('#f4f4f4')
    .borderRadius('20')
    .width(220)
  }
  build() {
    // [StartExclude richEditor_addBuilder]
    NavDestination() {
    // [EndExclude richEditor_addBuilder]
      Column({ space: 12 }) {
        RichEditor(this.options)
          .onReady(() => {
            this.controller.addTextSpan(
              /* 请将$r('app.string.AddBuilderDecoratorContent_Text_3')替换为实际资源文件，
               在本示例中该资源文件的value值为"点击按钮在此处添加builderspan。" */
              $r('app.string.AddBuilderDecoratorContent_Text_3'), {
              style: {
                fontColor: Color.Black,
                fontSize: 15
              }
            })
          })
        Row() {
          // 请将$r('app.string.AddBuilderDecoratorContent_Button_1')替换为实际资源文件，在本示例中该资源文件的value值为"addBuilderSpan"
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
        }.justifyContent(FlexAlign.Center).width('100%')
      }
    // [StartExclude richEditor_addBuilder]
      .alignItems(HorizontalAlign.Start)
      .backgroundColor('#fff')
      .borderRadius(12)
      .padding(12)
      .width('100%')
    }
    .padding({ left: 12, right: 12 })
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.Add_Builder_DecoratorContent_title')替换为实际资源文件，在本示例中该资源文件的value值为"添加@Builder装饰器修饰的内容"
    .title($r('app.string.Add_Builder_DecoratorContent_title'))
    // [EndExclude richEditor_addBuilder]
  }
  // [End richEditor_addBuilder]
}
