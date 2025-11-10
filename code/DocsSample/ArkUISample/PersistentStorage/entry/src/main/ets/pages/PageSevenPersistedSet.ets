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
// [Start Persistent_page_seven]
PersistentStorage.persistProp('persistedSet', new Set<number>([]));

@Entry
@Component
struct PersistedSet {
  @StorageLink('persistedSet') persistedSet: Set<number> = new Set<number>([]);

  persistSet() {
    this.persistedSet = new Set<number>([33, 1, 3]);
  }

  clearSet() {
    this.persistedSet.clear();
  }

  build() {
    List() {
      ListItem() {
        Column() {
          Text(`Persisted Set is `)
            .margin(20)
          ForEach(Array.from(this.persistedSet.entries()), (item: [number, number]) => {
            Text(`${item[1]}`)
          })

          Button() {
            Text('Persist Set')
              .fontSize(25)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
          }
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('60%')
          .height('5%')
          .onClick(() => {
            this.persistSet();
          })

          Button() {
            Text('Persist Clear')
              .fontSize(25)
              .fontWeight(FontWeight.Bold)
              .fontColor(Color.White)
          }
          .type(ButtonType.Capsule)
          .margin({
            top: 20
          })
          .backgroundColor('#0D9FFB')
          .width('60%')
          .height('5%')
          .onClick(() => {
            this.clearSet();
          })

        }
        .width('100%')
      }
    }
  }
}

// [End Persistent_page_seven]