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

// [Start link_union_type]
@Component
struct UnionChild {
  @Link name: string | undefined;

  build() {
    Column() {

      Button('Child change name to Bob')
        .onClick(() => {
          this.name = 'Bob';
        })

      Button('Child change name to undefined')
        .onClick(() => {
          this.name = undefined;
        })

    }.width('100%')
  }
}

@Entry
@Component
struct UnionTypes {
  @State name: string | undefined = 'mary';

  build() {
    Column() {
      Text(`The name is  ${this.name}`).fontSize(30)

      UnionChild({ name: this.name })

      Button('Parents change name to Peter')
        .onClick(() => {
          this.name = 'Peter';
        })

      Button('Parents change name to undefined')
        .onClick(() => {
          this.name = undefined;
        })
    }
  }
}
// [End link_union_type]