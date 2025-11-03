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

// [Start dialog_focus]
@Entry
@Component
export struct Index {
  // [Start dialog_focus_text]
  // 'dialog_message'需要替换为开发者所需的资源文件
  private message: string =
    this.getUIContext().getHostContext()?.resourceManager.getStringByNameSync('dialog_message') as string;
  @State dialogIdIndex: number = 0;

  @Builder
  customDialogComponent() {
    Column({ space: 5 }) {
      Text(this.message + this.dialogIdIndex)
        .fontSize(30)
    }
    .height(200)
    .padding(5)
    .justifyContent(FlexAlign.SpaceBetween)
  }

  // [End dialog_focus_text]

  build() {
    NavDestination() {
      Column({ space: 5 }) {
        // [Start dialog_focus_text_input]
        TextInput()
          .onChange(() => {
            this.dialogIdIndex++;
            this.getUIContext().getPromptAction().openCustomDialog({
              builder: () => {
                this.customDialogComponent();
              },
              focusable: false
            }).then((dialogId: number) => {
              setTimeout(() => {
                this.getUIContext().getPromptAction().closeCustomDialog(dialogId);
              }, 3000);
            });
          })
        // [End dialog_focus_text_input]
      }.width('100%')
    }
  }
}

// [End dialog_focus]