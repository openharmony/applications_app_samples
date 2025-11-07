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
// [Start localtorage_page_local_storage_link]
@Component
struct LocalStorageLinkComponent {
  @LocalStorageLink('LinkA') linkA: number | null = null;
  @LocalStorageLink('LinkB') linkB: number | undefined = undefined;

  build() {
    Column() {
      Text('@LocalStorageLink接口初始化，@LocalStorageLink取值')
      Text(`${this.linkA}`)
        .fontSize(20)
        .onClick(() => {
          this.linkA ? this.linkA = null : this.linkA = 1;
        })
      Text(`${this.linkB}`)
        .fontSize(20)
        .onClick(() => {
          this.linkB ? this.linkB = undefined : this.linkB = 1;
        })
    }
    .borderWidth(3).borderColor(Color.Green)
  }
}

@Component
struct LocalStoragePropComponent {
  @LocalStorageProp('PropA') propA: number | null = null;
  @LocalStorageProp('PropB') propB: number | undefined = undefined;

  build() {
    Column() {
      Text('@LocalStorageProp接口初始化，@LocalStorageProp取值')
      Text(`${this.propA}`)
        .fontSize(20)
        .onClick(() => {
          this.propA ? this.propA = null : this.propA = 1;
        })
      Text(`${this.propB}`)
        .fontSize(20)
        .onClick(() => {
          this.propB ? this.propB = undefined : this.propB = 1;
        })
    }
    .borderWidth(3)
    .borderColor(Color.Yellow)
  }
}

let storageLink: LocalStorage = new LocalStorage();

@Entry(storageLink)
@Component
struct LinkIndex {
  build() {
    Row() {
      Column() {
        LocalStorageLinkComponent()
        LocalStoragePropComponent()
      }
      .width('100%')
    }
    .height('100%')
  }
}
// [End localtorage_page_local_storage_link]