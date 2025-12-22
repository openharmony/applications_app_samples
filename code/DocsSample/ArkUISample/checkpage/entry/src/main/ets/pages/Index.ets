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
        // 请将$r('app.string.text1')替换为实际资源文件，在本示例中该资源文件的value值为"UIContext查询组件树和组件信息能力"
        Button($r('app.string.text1'))
          .onClick(()=>{
            const uiContext: UIContext = this.getUIContext();
            const router = uiContext.getRouter();
            router.pushUrl({
              url:'pages/ComponentPage'
            })
          })
        // 请将$r('app.string.text2')替换为实际资源文件，在本示例中该资源文件的value值为"布局回调的基本用法"
        Button($r('app.string.text2'))
          .onClick(()=>{
            const uiContext: UIContext = this.getUIContext();
            const router = uiContext.getRouter();
            router.pushUrl({
              url:'pages/ComponentPage1'
            })
          })
        // 请将$r('app.string.text3')替换为实际资源文件，在本示例中该资源文件的value值为"组件标识属性的扩展能力"
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