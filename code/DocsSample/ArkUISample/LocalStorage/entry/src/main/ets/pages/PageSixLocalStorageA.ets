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
// [Start localtorage_page_six_local_storageA]
let localStorageInstance: LocalStorage = new LocalStorage();
localStorageInstance.setOrCreate('propA', 'propA');

let localStorageChange: LocalStorage = new LocalStorage();
localStorageChange.setOrCreate('propB', 'propB');

@Entry(localStorageInstance)
@Component
struct Index {
  // 'PropA'，和localStorageInstance中'PropA'的双向同步
  @LocalStorageLink('PropA') propA: string = 'Hello World';
  @State count: number = 0;

  build() {
    Row() {
      Column() {
        Text(this.propA)
          .fontSize(50)
          .fontWeight(FontWeight.Bold)
        // 使用LocalStorage 实例localStorageChange
        ChildOne(localStorageChange)
      }
      .width('100%')
    }
    .height('100%')
  }
}

@Component
struct ChildOne {
  build() {
    Text('hello')
      .fontSize(50)
      .fontWeight(FontWeight.Bold)
  }
}

// [End localtorage_page_six_local_storageA]
const nestedObjectIndex = Index;

export default nestedObjectIndex;
