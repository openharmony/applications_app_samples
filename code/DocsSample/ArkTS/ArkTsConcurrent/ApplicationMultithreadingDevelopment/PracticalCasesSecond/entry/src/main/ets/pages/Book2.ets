/*
* Copyright (C) 2026 Huawei Device Co., Ltd.
* Licensed under the Apache License, Version 2.0 (the "License");
* you may not use this file except in compliance with the License.
* You may obtain a copy of the License at
*
* http://www.apache.org/licenses/LICENSE-2.0
*
* Unless required by applicable law or agreed to in writing, software
* distributed under the License is distributed on an "AS IS" BASIS,
* WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
* See the License for the specific language governing permissions and
* limitations under the License.
*/
// [Start define_book2]
// Book2.ets
@Entry
@Component
struct Index2 {
  @State message: string = 'Hello World!';

  build() {
    RelativeContainer() {
      Text('第二本书的内容')
        .id('second book')
        .fontSize(20)
        .padding(10)
        .fontWeight(FontWeight.Bold)
        .alignRules({
          center: { anchor: 'container', align: VerticalAlign.Center },
          middle: { anchor: 'container', align: HorizontalAlign.Center }
        })
      Button('返回')
        .fontSize(20)
        .padding(10)
        .fontWeight(FontWeight.Bold)
        .position({ x: '50%' })
        .onClick(() => {
          this.getUIContext().getRouter().pushUrl({ url: 'pages/GetRecentList' });
        })
    }
    .height('100%')
    .width('100%')
  }
}
// [End define_book2]