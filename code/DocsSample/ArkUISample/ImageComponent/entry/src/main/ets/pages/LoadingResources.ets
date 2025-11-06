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

//  存档图类型数据源页面&媒体库获取的url格式
@Entry
@Component
struct LoadingResources {
  build() {
    Column({ space: 10 }) {

      //  [Start local_resource]
      //  'images/view.jpg' 需要替换为开发者所需的资源文件
      Image('images/view.jpg')
        .width(200)
      //  [End local_resource]

      //  [Start net_resource]
      //  $r('app.string.LoadingResources') 需要替换为开发者所需的资源文件
      Image($r('app.string.LoadingResources')) // 实际使用时请替换真实路径.
      //  [End net_resource]

      //  [Start resource_icon]
      //  $r('app.media.icon') 需要替换为开发者所需的资源文件
      Image($r('app.media.icon'))
      //  [End resource_icon]

      //  [Start rawfile_resource]
      //  $rawfile('example1.png') 需要替换为开发者所需的资源文件
      Image($rawfile('example1.png'))
      //  [End rawfile_resource]

      //  [Start fileLibrary_format]
      //  'file://media/Photos/5' 需要替换为开发者所需的资源文件
      Image('file://media/Photos/5') // 实际使用时请替换真实路径.
        .width(200)
      //  [End fileLibrary_format]
    }
    .height(150)
    .width('100%')
    .padding({ top: 20,right: 10 })
  }
}