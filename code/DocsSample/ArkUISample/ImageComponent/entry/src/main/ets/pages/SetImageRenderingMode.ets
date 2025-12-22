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

// 图片渲染模式页面
// [Start image_renderingmode]
@Entry
@Component
struct SetImageRenderingMode {
  build() {
    Column({ space: 10 }) {
      Row({ space: 50 }) {
        // $r('app.media.example')需要替换为开发者所需的图像资源文件。
        Image($r('app.media.example'))
          // 通过renderMode属性设置图片的渲染模式为原色或黑白
          .renderMode(ImageRenderMode.Original)
          .width(100)
          .height(100)
          .border({ width: 1 })
          // overlay接口暂不支持深色模式
          .overlay('Original', { align: Alignment.Bottom, offset: { x: 0, y: 20 } })
        // $r('app.media.example')需要替换为开发者所需的图像资源文件。
        Image($r('app.media.example'))
          // 通过renderMode属性设置图片的渲染模式为原色或黑白
          .renderMode(ImageRenderMode.Template)
          .width(100)
          .height(100)
          .border({ width: 1 })
          // overlay接口暂不支持深色模式
          .overlay('Template', { align: Alignment.Bottom, offset: { x: 0, y: 20 } })
      }
    }.height(150).width('100%').padding({ top: 20,right: 10 })
  }
}
// [End image_renderingmode]