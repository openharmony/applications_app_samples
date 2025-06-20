/**
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
import router from '@system.router';
import promptAction from '@ohos.promptAction';

@Entry
@Component
struct WearList {
  @State message: string = 'Hello World';
  private arr: number[] = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15]

  build() {
    Column() {
      List({space: 20, initialIndex: 0}) {
        ForEach(this.arr, (item: number) => {
          ListItem() {
            Button('' + item)
              .height(100)
              .width('100%')
              .fontSize(16)
              .onClick(() => {})
          }
        }, (item: string) => item)
      }
      .focusable(true)
      .defaultFocus(true)
      .focusOnTouch(true)
      .width('90%')
      .height('100%')
    }
    .height('100%')
    .width('100%')
    .padding({top: 5})
  }
}