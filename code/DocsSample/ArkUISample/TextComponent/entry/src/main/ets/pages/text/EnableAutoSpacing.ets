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
// [Start Enable_AutoSpacing]
@Entry
@Component
export struct EnableAutoSpacing {
  @State enableSpacing: boolean = false;

  build() {
    NavDestination() {
    Column() {
      Row({ space: 20 }) {
        // 请将$r('app.string.Enable_automatic_spacing')替换为实际资源文件，在本示例中该资源文件的value值为"开启自动间距"
        Button($r('app.string.Enable_automatic_spacing'))
          .onClick(() => this.enableSpacing = true)
          .backgroundColor(this.enableSpacing ? '#4CAF50' : '#E0E0E0')
          .fontColor(this.enableSpacing ? Color.White : Color.Black)

        // 请将$r('app.string.off_automatic_spacing')替换为实际资源文件，在本示例中该资源文件的value值为"关闭自动间距"
        Button($r('app.string.off_automatic_spacing'))
          .onClick(() => this.enableSpacing = false)
          .backgroundColor(!this.enableSpacing ? '#F44336' : '#E0E0E0')
          .fontColor(!this.enableSpacing ? Color.White : Color.Black)
      }
      .width('100%')
      .justifyContent(FlexAlign.Center)
      .margin({ top: 30, bottom: 20 })

      // 请将$r('app.string.Automatic_spacing_has_been_enabled')替换为实际资源文件，在本示例中该资源文件的value值为"当前状态:已开启自动间距"
      // 请将$r('app.string.Automatic_spacing_has_been_turned_off')替换为实际资源文件，在本示例中该资源文件的value值为"当前状态:已关闭自动间距"
      Text(this.enableSpacing ? $r('app.string.Automatic_spacing_has_been_enabled') : $r('app.string.Automatic_spacing_has_been_turned_off'))
        .fontSize(16)
        .fontColor(this.enableSpacing ? '#4CAF50' : '#F44336')
        .margin({ bottom: 20 })

      // 设置是否应用中西文自动间距
      // 请将$r('app.string.Chinese_and_Western_Auto_Spacing_automatic_spacing')替换为实际资源文件，
      // 在本示例中该资源文件的value值为"中西文Auto Spacing自动间距"
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
    }
    // [StartExclude Enable_AutoSpacing]
    .backgroundColor('#f1f 2f3')
    // 请将$r('app.string.Automatic_spacing')替换为实际资源文件，在本示例中该资源文件的value值为"中文西文自动间距"
    .title($r('app.string.Automatic_spacing'))
    // [EndExclude Enable_AutoSpacing]
  }
}
// [End Enable_AutoSpacing]