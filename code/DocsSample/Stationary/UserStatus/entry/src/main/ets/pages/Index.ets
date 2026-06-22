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

@Entry
@Component
struct Index {
  @State message: string = 'userStatus';

  private subscribe() {
    // The framework is retained for future code integration into the library.
    this.message = 'userStatus subscribe';
  }

  private unsubscribe() {
    // The framework is retained for future code integration into the library.
    this.message = 'userStatus unsubscribe';
  }

  build() {
    Column() {
      Text(this.message)
        .fontSize(35)
        .fontWeight(FontWeight.Bold).margin({ bottom:10 })
        .height('20%')
        .id('show')
      Button('订阅')
        .margin(10)
        .id('button1')
        .width('30%')
        .onClick(() => this.subscribe())
      Button('取消订阅')
        .margin(10)
        .id('button2')
        .width('30%')
        .onClick(() => this.unsubscribe())
    }
    .height('100%')
    .width('100%')
  }
}