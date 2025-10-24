/*
 * Copyright (c) 2025 Huawei Device Co., Ltd.
 * Licensed under the Apache License, Version 2.0 (the "License")
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
let localStorage1: LocalStorage = new LocalStorage();
localStorage1.setOrCreate('propA', 'propA');

let localStorage2A: LocalStorage = new LocalStorage();
localStorage2A.setOrCreate('propB', 'propB');

@Entry(localStorage1)
@Component
struct TestIndex {
  // 'PropA'，和localStorage1中'PropA'的双向同步
  @LocalStorageLink('PropA') propA: string = 'Hello World';
  @State count: number = 0;

  build() {
    Row() {
      Column() {
        Text(this.propA)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        // 使用LocalStorage 实例localStorage2
        Child6({ count: this.count }, localStorage2A)
      }
      .width('100%')
    }
    .height('100%')
  }
}


@Component
struct Child6 {
  @Link count: number;
  //  'Hello World'和localStorage2中'PropB'的双向同步，如果localStorage2中没有'PropB'，则使用默认值'Hello World'
  @LocalStorageLink('PropB') propB: string = 'Hello World';

  build() {
    Text(this.propB)
      .fontSize(50)
      .fontWeight(FontWeight.Bold)
  }
}