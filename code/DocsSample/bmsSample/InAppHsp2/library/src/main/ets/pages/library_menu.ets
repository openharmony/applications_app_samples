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

// [Start in_app_hsp_014]
@Builder
export function PageOneBuilder() {
  Library_Menu()
}

@Entry
@Component
export struct Library_Menu {
  @State message: string = 'Hello World';
  pathStack: NavPathStack = new NavPathStack();

  build() {
    NavDestination() {
      Row() {
        Column() {
          Text(this.message)
            .fontSize($r('app.float.page_text_font_size'))
            .fontWeight(FontWeight.Bold)
            .onClick(() => {
              this.message = 'Welcome';
            })
          Button('back_to_index').fontSize(50).onClick(() => {
            this.pathStack.pop();
          })
        }
        .width('100%')
      }
      .height('100%')
    }.title('Library_Menu')
    .onReady((context: NavDestinationContext) => {
      this.pathStack = context.pathStack;
    })
  }
}
// [End in_app_hsp_014]