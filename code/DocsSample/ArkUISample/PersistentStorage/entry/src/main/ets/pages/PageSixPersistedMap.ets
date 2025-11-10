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
// [Start Persistent_page_six]
PersistentStorage.persistProp('persistedMapString', new Map<number, string>([]));

@Entry
@Component
struct PersistedMap {
  @StorageLink('persistedMapString') persistedMapString: Map<number, string> = new Map<number, string>([]);

  persistMapString() {
    this.persistedMapString = new Map<number, string>([[3, 'one'], [6, 'two'], [9, 'three']]);
  }

  build() {
    List() {
      ListItem() {
        Column() {
          Text(`Persisted Map String is `)
            .margin(20)
          ForEach(Array.from(this.persistedMapString.entries()), (item: [number, string]) => {
            Text(`${item[0]} ${item[1]}`)
          })

          Button() {
            Text('Persist Map String')
              .fontSize(20)
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
            this.persistMapString();
          })

        }.width('100%')
      }
    }
  }
}

// [End Persistent_page_six]