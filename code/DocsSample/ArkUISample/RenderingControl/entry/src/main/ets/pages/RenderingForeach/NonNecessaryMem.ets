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

// [Start non_necessary_mem]
class MemoryData {
  public longStr: string;
  public key: string;

  constructor(longStr: string, key: string) {
    this.longStr = longStr;
    this.key = key;
  }
}

@Entry
@Component
struct NonNecessaryMemory {
  @State simpleList: Array<MemoryData> = [];

  aboutToAppear(): void {
    let longStr = '';
    for (let i = 0; i < 2000; i++) {
      longStr += i.toString();
    }
    for (let index = 0; index < 3000; index++) {
      let data: MemoryData = new MemoryData(longStr, 'a' + index.toString());
      this.simpleList.push(data);
    }
  }

  build() {
    List() {
      ForEach(this.simpleList, (item: MemoryData) => {
        ListItem() {
          Text(item.key)
        }
      }
        // 如果不定义下面的keyGenerator函数，则ArkUI框架会使用默认的键值生成函数
        , (item: MemoryData) => {
          return item.key;
        }
      )
    }.height('100%')
    .width('100%')
  }
}
// [End non_necessary_mem]