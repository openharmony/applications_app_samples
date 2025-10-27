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

// [Start life_page]
// Page.ets
@Entry
@Component
struct Page {
  @State textColor: Color = Color.Black;
  @State num: number = 0;

  // 只有被@Entry装饰的组件才可以调用页面的生命周期
  onPageShow() {
    console.info('Page onPageShow');
    this.num = 5;
  }

  // 只有被@Entry装饰的组件才可以调用页面的生命周期
  onPageHide() {
    console.info('Page onPageHide');
  }

  // 只有被@Entry装饰的组件才可以调用页面的生命周期
  onBackPress() { // 不设置返回值按照false处理
    console.info('Page onBackPress');
    this.textColor = Color.Grey;
    this.num = 0;
  }

  build() {
    Column() {
      Text(`num is：${this.num}`)
        .fontSize(30)
        .fontWeight(FontWeight.Bold)
        .fontColor(this.textColor)
        .margin(20)
        .onClick(() => {
          this.num += 5;
        })
      Button('pop to previous page')
        .onClick(() => {
          this.getUIContext().getRouter().back();
        })
    }
    .width('100%')
  }
}
// [End life_page]