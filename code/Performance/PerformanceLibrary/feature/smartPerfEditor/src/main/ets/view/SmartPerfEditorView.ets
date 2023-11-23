/*
 * Copyright (c) 2023 Huawei Device Co., Ltd.
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

@Component
export struct SmartPerfEditorView {
  @State isVisible: Visibility = Visibility.None;

  build() {
    Column() {
      Button($r('app.string.show_hide_image'))
        .id('showImageBtn')
        .onClick(() => {
          if (this.isVisible == Visibility.Visible) {
            this.isVisible = Visibility.None
          } else {
            this.isVisible = Visibility.Visible
          }
        })
      Stack() {
        Row().width('40%').height('40%').backgroundColor(Color.Pink)
        Text("Hello World").fontSize(40)
        Image($r('app.media.editor_image')).width('100%').height('100%')
      }.width('100%').height('100%').backgroundColor(Color.Green).visibility(this.isVisible)
    }.width('100%')
  }
}