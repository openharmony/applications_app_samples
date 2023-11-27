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
export struct VisibilityView {
  @State isVisible: Visibility = Visibility.Visible;

  build() {
    Column() {
      Button($r('app.string.visible'))
        .onClick(() => {
          this.isVisible = Visibility.Visible;
        })
        .margin({ top: 10 })
      Button($r('app.string.hidden'))
        .onClick(() => {
          this.isVisible = Visibility.Hidden;
        })
        .margin({ top: 10 })
      Button($r('app.string.none'))
        .onClick(() => {
          this.isVisible = Visibility.None;
        })
        .margin({ top: 10 })
      Row().visibility(this.isVisible)
        .width(720)
        .height(300)
        .backgroundColor(Color.Pink)
    }.width('100%')
  }
}