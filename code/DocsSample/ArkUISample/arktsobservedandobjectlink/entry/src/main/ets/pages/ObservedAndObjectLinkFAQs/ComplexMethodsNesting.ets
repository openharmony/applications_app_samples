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
let complexMethodsNestingNextId = 1;

@Observed
class SubCounter {
  public counter: number;

  constructor(c: number) {
    this.counter = c;
  }
}

@Observed
class ParentCounter {
  public id: number;
  public counter: number;
  public subCounter: SubCounter;

  incrCounter() {
    this.counter++;
  }

  incrSubCounter(c: number) {
    this.subCounter.counter += c;
  }

  setSubCounter(c: number): void {
    this.subCounter.counter = c;
  }

  constructor(c: number) {
    this.id = complexMethodsNestingNextId++;
    this.counter = c;
    this.subCounter = new SubCounter(c);
  }
}


@Entry
@Component
struct ParentComp {
  @State counter: ParentCounter[] = [new ParentCounter(1), new ParentCounter(2), new ParentCounter(3)];
  // [Start Complex_Methods_Nesting]
  build() {
    Row() {
        CounterComp({ value: this.counter[0] }) // ParentComp组件传递 ParentCounter 给 CounterComp 组件
    }
  }
  // [StartExclude Complex_Methods_Nesting]
}

@Component
struct CounterComp {
  // [EndExclude Complex_Methods_Nesting]
  @ObjectLink value: ParentCounter; // @ObjectLink 接收 ParentCounter
  build() {
      // CounterChild 是 CounterComp 的子组件，CounterComp 传递 this.value.subCounter 给 CounterChild 组件
      CounterChild({ subValue: this.value.subCounter })
  }
  // [StartExclude Complex_Methods_Nesting]
}

@Component
struct CounterChild {
  // [EndExclude Complex_Methods_Nesting]
  @ObjectLink subValue: SubCounter; // @ObjectLink 接收 SubCounter
  // [End Complex_Methods_Nesting]
  build() {
    Text(`${this.subValue.counter}`)
      .onClick(() => {
        this.subValue.counter += 1;
      })
  }
}
