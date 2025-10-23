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
// [Start NonObservedClass_outs]
import { UIUtils } from '@kit.ArkUI';
@Observed
class ObservedClass {
 public name: string = "Tom";
}
class NonObservedClass {
  public name: string = "Tom";
}
let observedClass: ObservedClass = new ObservedClass(); // 被代理
let nonObservedClass: NonObservedClass = new NonObservedClass(); // 不被代理
let globalNumberList: number[] = [1, 2, 3]; // 不被代理
let globalSampleMap: Map<number, string> = new Map([[0, "a"], [1, "b"], [3, "c"]]); // 不被代理
let globalSampleSet: Set<number> = new Set([0, 1, 2, 3, 4]); // 不被代理
let globalSampleDate: Date = new Date(); // 不被代理
@Entry
@Component
struct Page5 {
  @State observedObject: ObservedClass = observedClass; // 已被代理数据不会重复创建代理
  @State nonObservedObject: NonObservedClass = nonObservedClass; // 创建代理
  @State numberList: number[] = globalNumberList; // Array类型创建代理
  @State sampleMap: Map<number, string> = globalSampleMap; // Map类型创建代理
  @State sampleSet: Set<number> = globalSampleSet; // Set类型创建代理
  @State sampleDate: Date = globalSampleDate; // Date类型创建代理

  build() {
    Column() {
      Text(`this.observedObject === observedClass: ${this.observedObject ===
        observedClass}`) // true
      Text(`UIUtils.getTarget(this.nonObservedObject) === nonObservedClass: ${UIUtils.getTarget(this.nonObservedObject) ===
        nonObservedClass}`) // true
      Text(`UIUtils.getTarget(this.numberList) === globalNumberList: ${UIUtils.getTarget(this.numberList) ===
        globalNumberList}`) // true
      Text(`UIUtils.getTarget(this.sampleMap) === globalSampleMap: ${UIUtils.getTarget(this.sampleMap) ===
        globalSampleMap}`) // true
      Text(`UIUtils.getTarget(this.sampleSet) === globalSampleSet: ${UIUtils.getTarget(this.sampleSet) ===
        globalSampleSet}`) // true
      Text(`UIUtils.getTarget(this.sampleDate) === globalSampleDate: ${UIUtils.getTarget(this.sampleDate) ===
        globalSampleDate}`) // true
    }
  }
}
// [End NonObservedClass_outs]