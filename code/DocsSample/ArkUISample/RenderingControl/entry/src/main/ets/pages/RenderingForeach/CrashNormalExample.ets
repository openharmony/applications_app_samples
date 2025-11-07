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

// [Start crash_normal_example]
class KeyData {
  public content: bigint;

  constructor(content: bigint) {
    this.content = content;
  }
}

@Entry
@Component
struct GenerationKeyExample {
  @State simpleList: Array<KeyData> = [new KeyData(1234567890123456789n), new KeyData(2345678910987654321n)];

  build() {
    Row() {
      Column() {
        ForEach(this.simpleList, (item: KeyData) => {
          GenerationKeyChildItem({ item: item.content.toString() })
        }
          // 如果不定义下面的keyGenerator函数，则ArkUI框架会使用默认的键值生成函数
          // KeyData中的content: bigint在JSON序列化时失败
          , (item: KeyData) => item.content.toString()
        )
      }
      .width('100%')
      .height('100%')
    }
    .height('100%')
    .backgroundColor(0xF1F3F5)
  }
}

@Component
struct GenerationKeyChildItem {
  @Prop item: string;

  build() {
    Text(this.item)
      .fontSize(50)
  }
}
// [End crash_normal_example]