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

// [Start catch_long_press_event]
@Entry
@Component
export struct LongPress {
  @State count: number = 0;

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        Column() {
          Text('LongPress OnAction:' + this.count).fontSize(28)
            .gesture(
              // 绑定可以重复触发的LongPressGesture
              LongPressGesture({ repeat: true })
                .onAction((event: GestureEvent | undefined) => {
                  if (event) {
                    if (event.repeat) {
                      this.count++;
                    }
                  }
                })
                .onActionEnd(() => {
                  this.count = 0;
                })
            )
        }
        .height(200)
        .width(250)
        .padding(20)
        .border({ width: 3 })
        .margin(30)
      }
      .width('100%')
      .height('100%')
      .padding({ left: 12, right: 12 })
    }
    .backgroundColor('#f1f2f3')
    .title($r('app.string.singlegesture_LongPressGesture_title'))
  }
}
// [End catch_long_press_event]