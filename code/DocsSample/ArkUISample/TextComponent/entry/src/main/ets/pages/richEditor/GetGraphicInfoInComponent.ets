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
// [Start richEditor_getSpans]
@Entry
@Component
export struct GetGraphicInfoInComponent {
  controller: RichEditorController = new RichEditorController();
  options: RichEditorOptions = { controller: this.controller };
  infoShowController: RichEditorController = new RichEditorController();
  infoShowOptions: RichEditorOptions = { controller: this.infoShowController };
  // 创建两个富文本组件
  build() {
    // [StartExclude richEditor_getSpans]
    NavDestination() {
    // [EndExclude richEditor_getSpans]
      Column({ space: 3 }) {
        RichEditor(this.options)
          .onReady(() => {
            this.controller.addTextSpan(
              // 请将$r('app.string.GetGraphicInfoInComponent_Text_1')替换为实际资源文件，在本示例中该资源文件的value值为"点击按钮获取此处span信息。"
              $r('app.string.GetGraphicInfoInComponent_Text_1'), {
              style: {
                fontColor: Color.Black,
                fontSize: 15
              }
            })
          })
          .width(300)
          .height(50)
        // 请将$r('app.string.GetGraphicInfoInComponent_Text_1')替换为实际资源文件，在本示例中该资源文件的value值为"点击按钮获取此处span信息。"
        Text($r('app.string.GetGraphicInfoInComponent_Text_1')).fontSize(10).fontColor(Color.Gray).width(300);
        RichEditor(this.infoShowOptions)
          .width(300)
          .height(50)
        Row() {
          // 请将$r('app.string.GetGraphicInfoInComponent_Button_1')替换为实际资源文件，在本示例中该资源文件的value值为"getSpans"
          Button($r('app.string.GetGraphicInfoInComponent_Button_1'), {
            buttonStyle: ButtonStyleMode.NORMAL
          })
            .height(30)
            .fontSize(13)
            .onClick(() => {
              this.infoShowController.addTextSpan(JSON.stringify(this.controller.getSpans()), {
                style: {
                  fontColor: Color.Gray,
                  fontSize: 10
                }
              })
            })
        }.justifyContent(FlexAlign.Center).width('100%')
      }
      // [StartExclude richEditor_getSpans]
      .alignItems(HorizontalAlign.Start)
      .backgroundColor('#fff')
      .borderRadius(12)
      .padding(12)
      .width('100%')
    }
    .padding({ left: 12, right: 12 })
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.Get_GraphicInfo_In_Component_title')替换为实际资源文件，在本示例中该资源文件的value值为"获取组件内图文信息"
    .title($r('app.string.Get_GraphicInfo_In_Component_title'));
    // [EndExclude richEditor_getSpans]
  }
}
// [End richEditor_getSpans]