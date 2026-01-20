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

// [Start richEditor_create_span]
// [Start richEditor_create]
@Entry
@Component
export struct CreateRichEditor {
  // [StartExclude richEditor_create]
  controllerNoStyledString: RichEditorController = new RichEditorController();
  optionsNoStyledString: RichEditorOptions = { controller: this.controllerNoStyledString };
  // [EndExclude richEditor_create]
  // [StartExclude richEditor_create_span]
  fontStyle: TextStyle = new TextStyle({
    fontColor: Color.Pink
  })
  // 定义字体样式对象
  mutableStyledString: MutableStyledString =
    // 请将$r('app.string.CreateRichEditor_Text_1')替换为实际资源文件，在本示例中该资源文件的value值为"创建使用属性字符串构建的RichEditor组件。"
    new MutableStyledString(this.getUIContext().getHostContext()!.resourceManager.getStringSync($r('app.string.CreateRichEditor_Text_1').id),
    [{
      start: 0,
      length: 5,
      styledKey: StyledStringKey.FONT,
      styledValue: this.fontStyle
    }])
  // 创建属性字符串

  controller: RichEditorStyledStringController = new RichEditorStyledStringController();
  options: RichEditorStyledStringOptions = { controller: this.controller };
  // [EndExclude richEditor_create_span]
  build() {
    NavDestination() {
      Column({ space: 12 }) {
        // [StartExclude richEditor_create_span]
        Column({ space: 3 }) {
          // [StartExclude richEditor_create]
          /**
           * 请将$r('app.string.Create_RichEditor_Component_title_1')替换为实际资源文件，在本示例中该资源文件的
           * value值为"创建使用属性字符串构建的RichEditor组件"
           */
          Text($r('app.string.Create_RichEditor_Component_title_1')).fontSize(14)
            .fontColor('#666')
          // [EndExclude richEditor_create]
          RichEditor(this.options)
            .onReady(() => {
              this.controller.setStyledString(this.mutableStyledString);
            })
        }
        // [StartExclude richEditor_create]
        .alignItems(HorizontalAlign.Start)
        .backgroundColor('#fff')
        .borderRadius(12)
        .padding(12)
        .width('100%')
        // [EndExclude richEditor_create_span]
        Column({ space: 3 }) {
          // [StartExclude richEditor_create_span]
          /**
           * 请将$r('app.string.Create_RichEditor_Component_title_2')替换为实际资源文件，
           * 在本示例中该资源文件的value值为"创建不使用属性字符串构建的RichEditor组件"
           */
          Text($r('app.string.Create_RichEditor_Component_title_2')).fontSize(14)
            .fontColor('#666')
          // [EndExclude richEditor_create_span]
          RichEditor(this.optionsNoStyledString)
            .onReady(() => {
              this.controllerNoStyledString.addTextSpan(
                /**
                 * 请将$r('app.string.CreateRichEditor_Text_2')替换为实际资源文件，
                 * 在本示例中该资源文件的value值为"创建不使用属性字符串构建的RichEditor组件。"
                 */
                $r('app.string.CreateRichEditor_Text_2'), {
                style: {
                  fontColor: Color.Black,
                  fontSize: 15
                }
              })
            })
        }
        // [StartExclude richEditor_create_span]
        .alignItems(HorizontalAlign.Start)
        .backgroundColor('#fff')
        .borderRadius(12)
        .padding(12)
        .width('100%')
        // [EndExclude richEditor_create_span]
        // [EndExclude richEditor_create]
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    // 请将$r('app.string.Create_RichEditor_Component_title')替换为实际资源文件，在本示例中该资源文件的value值为"创建RichEditor组件"
    .title($r('app.string.Create_RichEditor_Component_title'))
  }
}
// [End richEditor_create]
// [End richEditor_create_span]