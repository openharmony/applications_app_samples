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
// [Start Parent7_start]
const INITIAL_MYVAL = 10;

@Component
struct Child {
  // @Link可以双向同步数据
  @Link val: number;

  build() {
    Column() {
      Text('child: ' + this.val.toString())
        .fontSize(20)
        .margin(10)
      Button('+1')
        .width(300)
        .margin(10)
        .onClick(() => {
          this.val++; // 子组件修改val，父子组件同步刷新
        })
    }
    .width('100%')
  }
}

@Entry
@Component
struct Parent {
  @State myVal: number = INITIAL_MYVAL;

  build() {
    Column() {
      Text('parent: ' + this.myVal.toString())
        .fontSize(20)
        .margin(10)
      Child({ val: this.myVal }) // 通过@Link建立父子双向同步
    }
    .width('100%')
  }
}
// [End Parent7_start]
const parent7 = Parent;
export default parent7;