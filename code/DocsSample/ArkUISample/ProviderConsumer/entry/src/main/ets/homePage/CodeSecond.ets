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

// [Start Code_Second]
@Entry
@ComponentV2
struct Parent {
  // 定义aliasName为'alias'
  @Provider('alias') str: string = 'hello';

  // [StartExclude Code_Second]
  build() {
    Column() {
      Button(this.str)
        .onClick(() => {
          this.str += '0';
        })
      CodeSecond()
    }
  }

  // [EndExclude Code_Second]
}

@ComponentV2
export struct CodeSecond {
  // 定义aliasName为 'alias'，找到@Provider并获得值'hello'
  @Consumer('alias') str: string = 'world';

  // [StartExclude Code_Second]
  build() {
    Column() {
      Button(this.str)
        .onClick(() => {
          this.str += '0';
        })
    }
  }

  // [EndExclude Code_Second]
}

// [End Code_Second]