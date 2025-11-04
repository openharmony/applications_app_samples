''/*
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
// [Start observedObject_globalObservedObject]
@ObservedV2
class ObservedClass2 {
  @Trace public name: string = 'Tom';
}
let globalObservedObject: ObservedClass2 = new ObservedClass2(); // 不被代理
let globalNumberList: number[] = [1, 2, 3]; // 不被代理
let globalSampleMap: Map<number, string> = new Map([[0, 'a'], [1, 'b'], [3, 'c']]); // 不被代理
let globalSampleSet: Set<number> = new Set([0, 1, 2, 3, 4]); // 不被代理
let globalSampleDate: Date = new Date(); // 不被代理
@Entry
@ComponentV2
struct Page4 {
  @Local observedObject: ObservedClass2 = globalObservedObject; // V2中对象不被代理
  @Local numberList: number[] = globalNumberList; // Array类型创建代理
  @Local sampleMap: Map<number, string> = globalSampleMap; // Map类型创建代理
  @Local sampleSet: Set<number> = globalSampleSet; // Set类型创建代理
  @Local sampleDate: Date = globalSampleDate; // Date类型创建代理

  build() {
    Column() {
      Text(`this.observedObject === globalObservedObject ${this.observedObject === globalObservedObject}`) // true
      Text(`this.numberList === globalNumberList ${this.numberList === globalNumberList}`) // false
    }
  }
}
// [End observedObject_globalObservedObject]