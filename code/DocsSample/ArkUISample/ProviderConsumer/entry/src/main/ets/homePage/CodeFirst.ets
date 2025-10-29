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

// [Start Code_First]
@Entry
@ComponentV2
struct Parent {
  // 未定义aliasName, 使用属性名'str'作为aliasName
  @Provider() str: string = 'hello';

  // [StartExclude Code_First]
  build() {
    Column() {
      Button(this.str)
        .onClick(() => {
          this.str += '0';
        })
      CodeFirst()
    }
  }

  // [EndExclude Code_First]
}

@ComponentV2
export struct CodeFirst {
  // 定义aliasName为'str'，使用aliasName去寻找
  // 能够在Parent组件上找到, 使用@Provider的值'hello'
  @Consumer('str') str: string = 'world';

  // [StartExclude Code_First]
  build() {
    Column() {
      Button(this.str)
        .onClick(() => {
          this.str += '0';
        })
    }
  }

  // [EndExclude Code_First]
}

// [End Code_First]