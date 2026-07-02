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
// [Start example1_start]
const INITIAL_VALUE = 10;

class Child {
  public value: number = INITIAL_VALUE;
}

@Component
@Entry
struct Example {
  // @State可以观察第一层变化
  @State child: Child = new Child();

  build() {
    Column() {
      Text(this.child.value.toString())
        .fontSize(20)
        .margin(10)
      Button('value+1')
        .width(300)
        .margin(10)
        .onClick(() => {
          this.child.value++; // 修改对象属性，触发UI刷新
        })
    }
    .width('100%')
  }
}
// [End example1_start]
const example1 = Example;
export default example1;