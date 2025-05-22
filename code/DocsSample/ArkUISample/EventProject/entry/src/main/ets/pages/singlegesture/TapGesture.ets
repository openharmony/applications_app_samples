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

// [Start catch_click_twice_event]
@Entry
@Component
export struct Tap {
  @State value: string = '';

  build() {
    NavDestination() {
      Column({ space: 12 }) {
        Column() {
          Text('Click twice').fontSize(28)
            .gesture(
              // 绑定count为2的TapGesture
              TapGesture({ count: 2 })
                .onAction((event: GestureEvent|undefined) => {
                  if(event){
                    this.value = JSON.stringify(event.fingerList[0]);
                  }
                }))
          Text(this.value)
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
    .title($r('app.string.singlegesture_TapGesture_title'))
  }
}
// [End catch_click_twice_event]