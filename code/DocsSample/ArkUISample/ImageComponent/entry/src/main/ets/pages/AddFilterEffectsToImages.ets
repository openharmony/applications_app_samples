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

//  图片添加滤镜效果页面
//  [Start image_filtereffect]
@Entry
@Component
struct AddFilterEffectsToImages {
  build() {
    Column() {
      Row() {
        //  $r('app.media.example')需要替换为开发者所需的资源文件
        Image($r('app.media.example'))
          .width('40%')
          .margin(10)
        //  $r('app.media.example')需要替换为开发者所需的资源文件
        Image($r('app.media.example'))
          .width('40%')
          // 该页面重点使用colorFilter接口验证对图片添加滤镜后的效果
          .colorFilter(
             [1, 1, 0, 0, 0,
              0, 1, 0, 0, 0,
              0, 0, 1, 0, 0,
              0, 0, 0, 1, 0])
          .margin(10)
      }.width('100%')
      .justifyContent(FlexAlign.Center)
    }
  }
}
//  [End image_filtereffect]