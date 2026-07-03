/*
 * Copyright (c) 2026 Huawei Device Co., Ltd.
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
@Component
export default struct SearchBar {
  placeholder: string = '';
  onSearchEvent?: Function;
  onClearEvent?: Function;
  @State searchText: string = '';

  build() {
    Row() {
      Image($r('app.media.ic_public_search_filled'))
        .width(22)
        .height(22);

      TextInput({ placeholder: this.placeholder, text: this.searchText })
        .layoutWeight(1)
        .fontSize(16)
        .backgroundColor(Color.Transparent)
        .padding({ left: 8, right: 8 })
        .onChange((value: string) => {
          this.searchText = value;
        });


      if (this.searchText.length > 0) {
        Image($r('app.media.ic_public_search_clear'))
          .width(16)
          .height(16)
          .onClick(() => {
            this.searchText = '';
            this.onClearEvent!();
          });
      }

      Divider()
        .vertical(true)
        .width(1)
        .height(20)
        .margin({ left: 8 });

      Button('搜索')
        .fontColor('#333333')
        .fontSize(16)
        .backgroundColor(Color.Transparent)
        .onClick(() => {
          this.onSearchEvent!(this.searchText);
        })
        .padding(6);
    }
    .padding({ left: 10, right: 10 })
    .borderRadius(26)
    .backgroundColor('#f5f5f5');
  }
}