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
// [Start localtorage_page_four_state_variable_syn]
let count: Record<string, number> = { 'countStorage': 1 };
let storageFour: LocalStorage = new LocalStorage(count);

@Component
struct ChildFour {
  // 子组件实例的名字
  label: string = 'no name';
  // 和LocalStorage中“countStorage”的双向绑定数据
  @LocalStorageLink('countStorage') playCountLink: number = 0;

  build() {
    Row() {
      Text(this.label)
        .width(50)
        .height(60)
        .fontSize(12)
      Text(`playCountLink ${this.playCountLink}: inc by 1`)
        .onClick(() => {
          this.playCountLink += 1;
        })
        .width(200)
        .height(60)
        .fontSize(12)
    }
    .width(300)
    .height(60)
  }
}

@Entry(storageFour)
@Component
struct ParentFour {
  @LocalStorageLink('countStorage') playCount: number = 0;

  build() {
    Column() {
      Row() {
        Text('Parent')
          .width(50)
          .height(60)
          .fontSize(12)
        Text(`playCount ${this.playCount} dec by 1`)
          .onClick(() => {
            this.playCount -= 1;
          })
          .width(250)
          .height(60)
          .fontSize(12)
      }
      .width(300)
      .height(60)

      Row() {
        Text('LocalStorage')
          .width(50)
          .height(60)
          .fontSize(12)
        Text(`countStorage ${this.playCount} incr by 1`)
          .onClick(() => {
            storageFour.set<number | undefined>('countStorage', Number(storageFour.get<number>('countStorage')) + 1);
          })
          .width(250)
          .height(60)
          .fontSize(12)
      }
      .width(300)
      .height(60)

      ChildFour({ label: 'ChildA' })
      ChildFour({ label: 'ChildB' })

      Text(`playCount in LocalStorage for debug ${storageFour.get<number>('countStorage')}`)
        .width(300)
        .height(60)
        .fontSize(12)
    }
  }
}

// [End localtorage_page_four_state_variable_syn]