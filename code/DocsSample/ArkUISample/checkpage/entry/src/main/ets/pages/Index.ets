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

import { UIContext } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    RelativeContainer() {
      Column(){
        // $r('app.media.text1')需要替换为开发者所需的文本资源文件
        Button($r('app.string.text1'))
          .onClick(()=>{
            const uiContext: UIContext = this.getUIContext();
            const router = uiContext.getRouter();
            router.pushUrl({
              url:'pages/ComponentPage'
            })
          })
        // $r('app.media.text2')需要替换为开发者所需的文本资源文件
        Button($r('app.string.text2'))
          .onClick(()=>{
            const uiContext: UIContext = this.getUIContext();
            const router = uiContext.getRouter();
            router.pushUrl({
              url:'pages/ComponentPage1'
            })
          })
        // $r('app.media.text3')需要替换为开发者所需的文本资源文件
        Button($r('app.string.text3'))
          .onClick(()=>{
            const uiContext: UIContext = this.getUIContext();
            const router = uiContext.getRouter();
            router.pushUrl({
              url:'pages/ImagePage'
            })
          })
      }
    }
    .height('100%')
    .width('100%')
  }
}