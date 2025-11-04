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
// xxx.ets
// [End Enable_AutoSpacing]
@Entry
@Component
export struct EnableAutoSpacing {
  @State enableSpacing: boolean = false;

  build() {
    NavDestination() {
    Column() {
      Row({ space: 20 }) {
        Button($r('app.string.Enable_automatic_spacing'))
          .onClick(() => this.enableSpacing = true)
          .backgroundColor(this.enableSpacing ? '#4CAF50' : '#E0E0E0')
          .fontColor(this.enableSpacing ? Color.White : Color.Black)

        Button($r('app.string.off_automatic_spacing'))
          .onClick(() => this.enableSpacing = false)
          .backgroundColor(!this.enableSpacing ? '#F44336' : '#E0E0E0')
          .fontColor(!this.enableSpacing ? Color.White : Color.Black)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 30, bottom: 20 })

      Text(this.enableSpacing ? $r('app.string.Automatic_spacing_has_been_enabled') : $r('app.string.Automatic_spacing_has_been_turned_off'))
        .fontSize(16)
        .fontColor(this.enableSpacing ? '#4CAF50' : '#F44336')
        .margin({ bottom: 20 })

      // 设置是否应用中西文自动间距
      Text($r('app.string.Chinese_and_Western_Auto_Spacing_automatic_spacing'))
        .fontSize(24)
        .padding(15)
        .backgroundColor('#F5F5F5')
        .width('90%')
        .enableAutoSpacing(this.enableSpacing)
    }
    .width('100%')
    .height('100%')
    .padding(20)
    }.backgroundColor('#f1f 2f3')
    .title($r('app.string.Automatic_spacing'))
  }
}
// [End Enable_AutoSpacing]