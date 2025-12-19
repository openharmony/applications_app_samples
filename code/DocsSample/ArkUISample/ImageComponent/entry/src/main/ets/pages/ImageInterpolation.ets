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
// 图片插值页面
// [Start image_interpolation]
@Entry
@Component
struct ImageInterpolationType {
  build() {
    Column() {
      Row() {
        // $r('app.media.grass')需要替换为开发者所需的图像资源文件。
        Image($r('app.media.grass'))
          .width('40%')
          // 使用interpolation接口对图片进行插值，显著提升清晰度
          .interpolation(ImageInterpolation.None)
          .borderWidth(1)
          // overlay接口暂不支持深色模式
          .overlay('Interpolation.None', { align: Alignment.Bottom, offset: { x: 0, y: 20 } })
          .margin(10)
        // $r('app.media.grass')需要替换为开发者所需的图像资源文件。
        Image($r('app.media.grass'))
          .width('40%')
          // 使用interpolation接口对图片进行插值，显著提升清晰度
          .interpolation(ImageInterpolation.Low)
          .borderWidth(1)
          // overlay接口暂不支持深色模式
          .overlay('Interpolation.Low', { align: Alignment.Bottom, offset: { x: 0, y: 20 } })
          .margin(10)
      }.width('100%')
      .justifyContent(FlexAlign.Center)

      Row() {
        // $r('app.media.grass')需要替换为开发者所需的图像资源文件。
        Image($r('app.media.grass'))
          .width('40%')
          // 使用interpolation接口对图片进行插值，显著提升清晰度
          .interpolation(ImageInterpolation.Medium)
          .borderWidth(1)
          // overlay接口暂不支持深色模式
          .overlay('Interpolation.Medium', { align: Alignment.Bottom, offset: { x: 0, y: 20 } })
          .margin(10)
        // $r('app.media.grass')需要替换为开发者所需的图像资源文件。
        Image($r('app.media.grass'))
          .width('40%')
          // 使用interpolation接口对图片进行插值，显著提升清晰度
          .interpolation(ImageInterpolation.High)
          .borderWidth(1)
          // overlay接口暂不支持深色模式
          .overlay('Interpolation.High', { align: Alignment.Bottom, offset: { x: 0, y: 20 } })
          .margin(10)
      }.width('100%')
      .justifyContent(FlexAlign.Center)
    }
    .height('100%')
  }
}
// [End image_interpolation]