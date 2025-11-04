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

@Entry
@Component
struct DisplayVectorDiagram {
  build() {
    Column({ space: 10 }) {
      Row({ space: 50 }) {

        //  [Start svg_fillColor]
        //  $r('app.media.cloud')需要替换为开发者所需的资源文件
        Image($r('app.media.cloud'))
          .width(50)
          .fillColor(Color.Blue)
        //  [End svg_fillColor]

        //  [Start local_svg]
        //  'images/icon.svg' 需要替换为开发者所需的资源文件
        Image('images/icon.svg')
          .width(50)
          .height(50)
        //  [End local_svg]

      }
      //  [Start synchronous_imageloading]
      //  $r('app.media.icon')需要替换为开发者所需的资源文件
      Image($r('app.media.icon'))
        .syncLoad(true)
      //  [End synchronous_imageloading]
    }.height(150).width('100%').padding({ top: 20,right: 10 })
  }
}