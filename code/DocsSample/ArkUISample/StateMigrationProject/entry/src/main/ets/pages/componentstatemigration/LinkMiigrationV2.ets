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
// [Start Parent8_start]
@ComponentV2
struct Child8 {
  // @Param搭配@Event回调实现数据双向同步
  @Param val: number = 0;
  @Event addOne: () => void;

  build() {
    Column() {
      Text('child: ' + this.val.toString())
      Button('+1')
        .onClick(() => {
          this.addOne();
        })
    }
  }
}

@Entry
@ComponentV2
struct Parent8 {
  @Local myVal: number = 10;

  build() {
    Column() {
      Text('parent: ' + this.myVal.toString())
      Child8({ val: this.myVal, addOne: () => this.myVal++ })
    }
  }
}
// [End Parent8_start]