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
let ComplexMethodsNestingNextId = 1;

@Observed
class ComplexMethodsNestingSubCounter {
  counter: number;

  constructor(c: number) {
    this.counter = c;
  }
}

@Observed
class ParentCounter {
  id: number;
  counter: number;
  subCounter: ComplexMethodsNestingSubCounter;

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
    this.id = ComplexMethodsNestingNextId++;
    this.counter = c;
    this.subCounter = new ComplexMethodsNestingSubCounter(c);
  }
}


@Entry
@Component
struct ParentComp {
  @State counter: ParentCounter[] = [new ParentCounter(1), new ParentCounter(2), new ParentCounter(3)];

  build() {
    Row() {
      Column() {
        // [Start Complex_Methods_Nesting]
        ComplexMethodsNestingCounterComp({ value: this.counter[0] }); // ParentComp组件传递 ParentCounter 给 CounterComp 组件
        // [StartExclude Complex_Methods_Nesting_One]
        ComplexMethodsNestingCounterComp({ value: this.counter[1] })
        ComplexMethodsNestingCounterComp({ value: this.counter[2] })
        Divider().height(5)
        ForEach(this.counter,
          (item: ParentCounter) => {
            ComplexMethodsNestingCounterComp({ value: item })
          },
          (item: ParentCounter) => item.id.toString()
        )
        Divider().height(5)
        Text('Parent: reset entire counter')
          .fontSize(20).height(50)
          .onClick(() => {
            this.counter = [new ParentCounter(1), new ParentCounter(2), new ParentCounter(3)];
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
@Component
struct ComplexMethodsNestingCounterComp {
  // [EndExclude Complex_Methods_Nesting_One]
  @ObjectLink value: ParentCounter; // @ObjectLink 接收 ParentCounter
  // [StartExclude Complex_Methods_Nesting_Two]

  build() {
    Column({ space: 10 }) {
      Text(`${this.value.counter}`)
        .fontSize(25)
        .onClick(() => {
          this.value.incrCounter();
        })
      // [EndExclude Complex_Methods_Nesting_Two]
      // CounterChild 是 CounterComp 的子组件，CounterComp 传递 this.value.subCounter 给 CounterChild 组件
      ComplexMethodsNestingCounterChild({ subValue: this.value.subCounter });
      // [StartExclude Complex_Methods_Nesting_Three]
      Divider().height(2)
    }
  }
}

@Component
struct ComplexMethodsNestingCounterChild {
  // [EndExclude Complex_Methods_Nesting_Three]
  @ObjectLink subValue: ComplexMethodsNestingSubCounter; // @ObjectLink 接收 SubCounter
  // [End Complex_Methods_Nesting]
  build() {
    Text(`${this.subValue.counter}`)
      .onClick(() => {
        this.subValue.counter += 1;
      })
  }
}
