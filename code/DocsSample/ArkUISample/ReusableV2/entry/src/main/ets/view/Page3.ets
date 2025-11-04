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
//[Start The_lifecycle_of_recycling_and_reuse]
@Entry
@ComponentV2
struct Page3 {
  @Local arr: number[] = [1, 2, 3, 4, 5];
  build() {
    Column(){
      List(){
        Repeat(this.arr)
          .each(() => {})
          .virtualScroll()
          .templateId(() => 'a')
          .template('a', (ri) => {
            ListItem() {
              Column() {
                ReusableV2Component1({ val: ri.item}) // 暂不支持，编译期报错
                ReusableV2Builder(ri.item) // 暂不支持，运行时报错
                NormalV2Component({ val: ri.item}) // 支持普通V2自定义组件下面包含V2复用组件
              }
            }
          })
      }
    }
  }
}

@ComponentV2
struct NormalV2Component {
  @Require @Param val: number;
  build() {
    ReusableV2Component1({ val: this.val })
  }
}

// @ReusableV2
@ComponentV2
struct ReusableV2Component1 {
  @Require @Param val: number;
  build() {
    Column() {
      Text(`val: ${this.val}`)
    }
  }
}


@Builder
function reusableV2Builder(param: number) {
  ReusableV2Component1({ val: param })
}
//[End The_lifecycle_of_recycling_and_reuse]