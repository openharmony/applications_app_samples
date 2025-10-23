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
// [Start Complex_nested_observation_levels]
let complexNestingCompleteNextId = 1;

@Observed
class SubCounter {
  counter: number;

  constructor(c: number) {
    this.counter = c;
  }
}

@Observed
class ComplexNestingCompleteParentCounter {
  id: number;
  counter: number;
  subCounter: SubCounter;

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
    this.id = complexNestingCompleteNextId++;
    this.counter = c;
    this.subCounter = new SubCounter(c);
  }
}

@Component
struct ComplexNestingCompleteCounterComp {
  @ObjectLink value: ComplexNestingCompleteParentCounter;

  build() {
    Column({ space: 10 }) {
      Text(`${this.value.counter}`)
        .fontSize(25)
        .onClick(() => {
          this.value.incrCounter();
        })
      CounterChild({ subValue: this.value.subCounter })
      Divider().height(2)
    }
  }
}

@Component
struct CounterChild {
  @ObjectLink subValue: SubCounter;

  build() {
    Text(`${this.subValue.counter}`)
      .onClick(() => {
        this.subValue.counter += 1;
      })
  }
}

@Entry
@Component
struct ComplexNestingCompleteParentComp {
  @State counter: ComplexNestingCompleteParentCounter[] = [new ComplexNestingCompleteParentCounter(1), new ComplexNestingCompleteParentCounter(2), new ComplexNestingCompleteParentCounter(3)];

  build() {
    Row() {
      Column() {
        ComplexNestingCompleteCounterComp({ value: this.counter[0] })
        ComplexNestingCompleteCounterComp({ value: this.counter[1] })
        ComplexNestingCompleteCounterComp({ value: this.counter[2] })
        Divider().height(5)
        ForEach(this.counter,
          (item: ComplexNestingCompleteParentCounter) => {
            ComplexNestingCompleteCounterComp({ value: item })
          },
          (item: ComplexNestingCompleteParentCounter) => item.id.toString()
        )
        Divider().height(5)
        Text('Parent: reset entire counter')
          .fontSize(20).height(50)
          .onClick(() => {
            this.counter = [new ComplexNestingCompleteParentCounter(1), new ComplexNestingCompleteParentCounter(2), new ComplexNestingCompleteParentCounter(3)];
          })
        Text('Parent: incr counter[0].counter')
          .fontSize(20).height(50)
          .onClick(() => {
            this.counter[0].incrCounter();
            this.counter[0].incrSubCounter(10);
          })
        Text('Parent: set.counter to 10')
          .fontSize(20).height(50)
          .onClick(() => {
            this.counter[0].setSubCounter(10);
          })
      }
    }
  }
}
// [End Complex_nested_observation_levels]