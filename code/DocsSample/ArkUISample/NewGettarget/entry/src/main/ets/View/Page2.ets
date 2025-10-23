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
// [Start nonObservedObject_1]
@Observed
class ObservedClass1 {
  public name: string = "Tom";
}
class NonObservedClass1 {
  public name: string = "Tom";
}
let observedClass: ObservedClass1 = new ObservedClass1(); // 被代理
let nonObservedClass: NonObservedClass1 = new NonObservedClass1(); // 不被代理
@Entry
@Component
struct Page2 {
  @State observedObject: ObservedClass1 = observedClass; // 已被代理数据不会重复创建代理
  @State nonObservedObject: NonObservedClass1 = nonObservedClass; // 创建代理
  @State numberList: number[] = [1, 2, 3]; // Array类型创建代理
  @State sampleMap: Map<number, string> = new Map([[0, "a"], [1, "b"], [3, "c"]]); // Map类型创建代理
  @State sampleSet: Set<number> = new Set([0, 1, 2, 3, 4]); // Set类型创建代理
  @State sampleDate: Date = new Date(); // Date类型创建代理

  build() {
    Column() {
      Text(`this.observedObject === observedClass: ${this.observedObject === observedClass}`) // true
      Text(`this.nonObservedObject === nonObservedClass: ${this.nonObservedObject === nonObservedClass}`) // false
    }
  }
}
// [End nonObservedObject_1]