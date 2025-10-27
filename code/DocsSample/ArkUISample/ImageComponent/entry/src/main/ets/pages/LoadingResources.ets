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
struct LoadingResources {
  build() {
    Column({ space: 10 }) {

      //  [Start local_Resource]
      //  'images/view.jpg' 需要替换为开发者所需的资源文件
      Image('images/view.jpg')
        .width(200)
      //  [End local_Resource]

      //  [Start net_Resource]
      //  $r('app.string.LoadingResources') 需要替换为开发者所需的资源文件
      Image($r('app.string.LoadingResources')) // 实际使用时请替换为真实地址
      //  [End net_Resource]

      //  [Start Resource_icon]
      //  $r('app.media.icon') 需要替换为开发者所需的资源文件
      Image($r('app.media.icon'))
      //  [End Resource_icon]

      //  [Start rawfile_Resource]
      //  $rawfile('example1.png') 需要替换为开发者所需的资源文件
      Image($rawfile('example1.png'))
      //  [End rawfile_Resource]

      //  [Start FileLibrary_Format]
      //  'file://media/Photos/5' 需要替换为开发者所需的资源文件
      Image('file://media/Photos/5')
        .width(200)
      //  [End FileLibrary_Format]
    }
    .height(150)
    .width('100%')
    .padding({ top: 20,right: 10 })
  };
}