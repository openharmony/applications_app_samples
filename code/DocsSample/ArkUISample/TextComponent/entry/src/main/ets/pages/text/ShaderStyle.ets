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
// [Start Shader_Style]
@Entry
@Component
export struct ShaderStyle {
  @State message: string = 'Hello World';
  @State linearGradientOptions: LinearGradientOptions =
    {
      direction: GradientDirection.LeftTop,
      colors: [[Color.Red, 0.0], [Color.Blue, 0.3], [Color.Green, 0.5]],
      repeating: true,
    };

  build() {
    NavDestination() {
      Column({ space: 5 }) {
        // 请将$r('app.string.direction_LeftTop')替换为实际资源文件，在本示例中该资源文件的value值为"direction为LeftTop的线性渐变"
        Text($r('app.string.direction_LeftTop')).fontSize(18).width('90%').fontColor(0xCCCCCC)
          .margin({ top: 40, left: 40 })
        Text(this.message)
          .fontSize(50)
          .width('80%')
          .height(50)
          .shaderStyle(this.linearGradientOptions)
      }
      .height('100%')
      .width('100%')
    }
    // [StartExclude Shader_Style]
    .backgroundColor('#f1f 2f3')
    // 请将$r('app.string.Shader_Style')替换为实际资源文件，在本示例中该资源文件的value值为"设置渐变色"
    .title($r('app.string.Shader_Style'))
    // [EndExclude Shader_Style]
  }
}

// [End Shader_Style]