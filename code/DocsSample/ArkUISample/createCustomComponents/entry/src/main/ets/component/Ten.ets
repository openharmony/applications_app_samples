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
@Entry
@Component
struct Ten {
  @State arr: number[] = [0,1,2,3];
  // [ Start filter ]
  // 反例
//   @State arr : Array<...> = [ ... ];
//   ForEach(this.arr.sort().filter(...),
//   item => {
//   // ...
// })
// 正确的执行方式为：filter返回一个新数组，后面的sort方法才不会改变原数组this.arr
  // [StartExclude filter]
  For(){
    // [EndExclude filter]
    ForEach(this.arr.filter((item, index) => index >= 2).sort(),
    (item:number) => {
      // ...
    })
    // [StartExclude filter sort]
  }
  // [EndExclude filter sort]
  // [ End filter ]
  build() {
    RelativeContainer() {
    }
    .height('100%')
    .width('100%')
  }
}