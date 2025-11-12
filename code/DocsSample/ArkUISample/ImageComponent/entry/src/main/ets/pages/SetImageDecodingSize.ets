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

// 图片解码尺寸页面
// [Start image_decodingsize]
@Entry
@Component
struct SetImageDecodingSize {
  build() {
    Column() {
      Row({ space: 50 }) {
        // $r('app.media.example')需要替换为开发者所需的资源文件
        Image($r('app.media.example'))
        // 使用sourceSize接口对图片设置解码尺寸，降低图片分辨率
          .sourceSize({
            width: 40,
            height: 40
          })
          .objectFit(ImageFit.ScaleDown)
          .aspectRatio(1)
          .width('25%')
          .border({ width: 1 })
          // overlay接口暂不支持深色模式
          .overlay('width:40 height:40', { align: Alignment.Bottom, offset: { x: 0, y: 40 } })
        // $r('app.media.example')需要替换为开发者所需的资源文件
        Image($r('app.media.example'))
        // 使用sourceSize接口对图片设置解码尺寸，降低图片分辨率
          .sourceSize({
            width: 90,
            height: 90
          })
          .objectFit(ImageFit.ScaleDown)
          .width(100)
          .height(100)
          .aspectRatio(1)
          .border({ width: 1 })
          // overlay接口暂不支持深色模式
          .overlay('width:90 height:90', { align: Alignment.Bottom, offset: { x: 0, y: 40 } })
      }.height(150).width('100%').padding(20)
    }
  }
}
// [End image_decodingsize]