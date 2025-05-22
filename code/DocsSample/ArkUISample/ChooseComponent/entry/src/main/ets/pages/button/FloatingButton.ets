/*
 * Copyright (c) 2024 Huawei Device Co., Ltd.
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

// [Start floating_button]
@Entry
@Component
export struct FloatingButton {
  @State private arr: number[] = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];
  // [StartExclude floating_button]
  pathStack: NavPathStack = new NavPathStack();

  resourceToString(resource: Resource): string {
    return getContext(this).resourceManager.getStringSync(resource);
  }
  // [EndExclude floating_button]

  build() {
    // [StartExclude floating_button]
    NavDestination() {
      // [EndExclude floating_button]
      Stack() {
        List({ space: 12, initialIndex: 0 }) {
          ForEach(this.arr, (item: number) => {
            ListItem() {
              Text(`${item}`)
                .width('100%')
                .height(100)
                .fontSize(16)
                .textAlign(TextAlign.Center)
                .borderRadius(10)
                .backgroundColor(0xFFFFFF)
            }
          }, (item: number) => item.toString())
        }
        .id('List')
        .width('100%')
        .padding({
          left: 15,
          right: 15
        })

        // [Start custom_button_function]
        Button() {
          Image($r('sys.media.ohos_ic_public_add'))
            .fillColor(0xffffff)
            .width(24)
            .height(24)
        }
        .id('Button')
        .width(40)
        .height(40)
        .position({ x: '80%', y: 570 })
        .onClick(() => {
          // 需要执行的操作
          // [StartExclude custom_button_function]
          this.arr.push(this.arr.length);
          // [EndExclude custom_button_function]
        })
        // [End custom_button_function]
      }
      .width('100%')
      .height('100%')
      .backgroundColor(0xDCDCDC)
      .padding({ top: 6 })
    }
    // [End floating_button]
    .backgroundColor('#f1f2f3')
    .title(this.resourceToString($r('app.string.FloatingButton_title')))
  }
}