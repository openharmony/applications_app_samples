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

// [Start dialog_style_1]
@CustomDialog
struct CustomDialogExample {
  controller?: CustomDialogController;

  build() {
    Column() {
      //$r('app.string.i_am_content')资源文件中的value为'我是内容'
      Text($r('app.string.i_am_content')).fontSize(16).margin({ bottom: 10 })
    }
  }
}

@Entry
@Component
export struct DialogStyle1 {
  @State textValue: string = '';
  @State inputValue: string = 'click me';
  dialogController: CustomDialogController | null = new CustomDialogController({
    builder: CustomDialogExample(),
    autoCancel: true,
    alignment: DialogAlignment.Center,
    offset: { dx: 0, dy: -20 },
    gridCount: 4,
    customStyle: false,
    backgroundColor: 0xd9ffffff,
    cornerRadius: 20,
    width: '80%',
    height: '100px',
    borderWidth: 1,
    borderStyle: BorderStyle.Dashed, //使用borderStyle属性，需要和borderWidth属性一起使用
    borderColor: Color.Blue, //使用borderColor属性，需要和borderWidth属性一起使用
    shadow: ({
      radius: 20,
      color: Color.Grey,
      offsetX: 50,
      offsetY: 0
    }),
  });

  // 在自定义组件即将析构销毁时将dialogController置空
  aboutToDisappear() {
    this.dialogController = null; // 将dialogController置空
  }

  build() {
    NavDestination() {
      Column() {
        Button(this.inputValue)
          .onClick(() => {
            if (this.dialogController !== null) {
              this.dialogController.open();
            }
          }).backgroundColor(0x317aff)
      }.width('100%').margin({ top: 5 })
    }
  }
}
// [End dialog_style_1]