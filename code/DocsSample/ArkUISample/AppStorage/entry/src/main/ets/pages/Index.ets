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

// [Start appstorage_Index]
AppStorage.setOrCreate('linkA', 47)
AppStorage.setOrCreate('propB', 48)

@Entry
@Component
struct Index {
  @StorageLink('linkA') linkA: number = 1; // 与AppStorage进行双向数据同步
  @StorageProp('propB') propB: number = 1; // 与AppStorage进行单向数据同步
  pageStack: NavPathStack = new NavPathStack();

  build() {
    Navigation(this.pageStack) {
      Row() {
        Column({ space: 5 }) {
          Text(`${this.linkA}`)
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
          Text(`${this.propB}`)
            .fontSize(50)
            .fontWeight(FontWeight.Bold)
          Button('Change linkA')
            .onClick(() => {
              // 刷新UI，修改将会被同步回AppStorage
              this.linkA++;
            })
          Button('Change propB')
            .onClick(() => {
              // 刷新UI，修改不会被同步回AppStorage
              this.propB++;
            })
          Button('To Page')
            .onClick(() => {
              this.pageStack.pushPathByName('Page', null);
            })
        }
        .width('100%')
      }
      .height('100%')
    }
  }
}

// [End appstorage_Index]