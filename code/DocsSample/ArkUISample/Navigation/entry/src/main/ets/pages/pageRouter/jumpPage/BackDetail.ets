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
struct BackDetail {
  @State message: string = 'Some ways to return to home page';

  build() {
    Row() {
      Column() {
        Text(this.message)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        Button('1.back to home', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            // [Start back_detail1]
            this.getUIContext().getRouter().back();
            // [End back_detail1]
          })

        Button('2.1.url to home', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            // [Start back_detail21]
            this.getUIContext().getRouter().back({
              url: 'pages/pageRouter/jumpPage/BackHome'
            });
            // [End back_detail21]
          })

        Button('2.2.route alias to home', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            // [Start back_detail22]
            this.getUIContext().getRouter().back({
              url: 'myPage' // myPage为返回的命名路由页面别名
            });
            // [End back_detail22]
          })

        Button('3.url & params to home', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            // [Start back_detail31]
            this.getUIContext().getRouter().back({
              url: 'pages/pageRouter/jumpPage/BackHome',
              params: {
                // 请将$r('app.string.pageRouter_jump_text7_fromHome')替换为实际资源文件，在本示例中该资源文件的value值为"来自Home页"
                info: $r('app.string.pageRouter_jump_text7_fromHome')
              }
            });
            // [End back_detail31]
          })

        Button('3.2.route alias & params to home', { stateEffect: true, type: ButtonType.Capsule })
          .width('80%')
          .height(40)
          .margin(20)
          .onClick(() => {
            // [Start back_detail32]
            this.getUIContext().getRouter().back({
              url: 'myPage', // myPage为返回的命名路由页面别名
              params: {
                // 请将$r('app.string.pageRouter_jump_text7_fromHome')替换为实际资源文件，在本示例中该资源文件的value值为"来自Home页"
                info: $r('app.string.pageRouter_jump_text7_fromHome')
              }
            });
            // [End back_detail32]
          })
      }
      .width('100%')
    }
    .height('100%')
  }
}
