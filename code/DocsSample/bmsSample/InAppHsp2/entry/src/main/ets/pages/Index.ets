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

// [Start in_app_hsp_012]
@Entry
@Component
struct Index {
  @State message: string = '';
  pathStack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pathStack) {
      Column() {
        List() {
          ListItem() {
            Text($r('app.string.click_to_menu'))
              .fontSize(18)
              .textAlign(TextAlign.Start)
              .width('100%')
              .fontWeight(500)
              .height('100%')
          }
          .id('clickToMenu')
          .borderRadius(24)
          .width('685px')
          .height('84px')
          .backgroundColor($r('sys.color.ohos_id_color_foreground_contrary'))
          .margin({ top: 10, bottom: 10 })
          .padding({
            left: 12,
            right: 12,
            top: 4,
            bottom: 4
          })
          .onClick(() => {
            this.pathStack.pushPathByName('library_menu', null)
          })
        }
        .alignListItem(ListItemAlign.Center)
      }
      .width('100%')
      .backgroundColor($r('app.color.page_background'))
      .height('100%')
    }.title("Navigation_Index")
    .mode(NavigationMode.Stack)
  }
}
// [End in_app_hsp_012]