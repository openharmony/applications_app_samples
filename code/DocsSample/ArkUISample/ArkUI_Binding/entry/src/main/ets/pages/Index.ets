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
import { router } from '@kit.ArkUI';

@Entry
@Component
struct Index {
  @State message: string = 'Hello World';

  build() {
    Column() {
      // 请将$r('app.string.button1')替换为实际资源文件，在本示例中该资源文件的value值为"自定义组件使用!!双向绑定"
      Button($r('app.string.button1'))
        .width('50%')
        .margin(30)
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({url:'pages/Binding_Star'})
        })
      // 请将$r('app.string.button2')替换为实际资源文件，在本示例中该资源文件的value值为"自定义组件使用@Param与@Event双向绑定"
      Button($r('app.string.button2'))
        .width('50%')
        .margin(30)
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({url:'pages/Binding_Star_Param_Event'})
        })
      // 请将$r('app.string.button3')替换为实际资源文件，在本示例中该资源文件的value值为"系统组件参数双向绑定"
      Button($r('app.string.button3'))
        .width('50%')
        .margin(30)
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({url:'pages/Sys_Binding'})
        })
    }
    .height('100%')
    .width('100%')
  }
}